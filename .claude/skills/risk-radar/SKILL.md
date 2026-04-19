---
name: "Risk Radar"
description: "Proactive risk detection across all 4 projects. Scans supplier DBs, Open Items, Gmail, promises, and session state for risk signals: cold suppliers, expiring quotes, NDA pipeline blocks, single-source gaps, overdue OIs, unanswered emails. Use at start of day, before leadership updates, or whenever Andre needs a risk snapshot."
---

# Risk Radar

Scans all projects for risks and surfaces them in a prioritized report. Read-only, no writes. Designed to catch problems before they become blockers.

## Pre-flight

1. Read `outputs/session-state.md` for freshness. If warm-up < 2h, use snapshot.
2. Read `.claude/config/databases.md` (collection IDs, schemas).
3. Read `.claude/config/domains.md` (supplier domains for Gmail scan).
4. Read `outputs/promises.md` for open commitments.

## Step 1: Scan supplier DBs for risk signals

Query all 4 Supplier DBs (Pulse, Kaia, M-Band, BloomPod):

```sql
SELECT Name, Status, Notes, "NDA Status", "Samples Status", id, url
FROM "{DB_COLLECTION_ID}"
```

Run for each project DB (IDs in `config/databases.md`, including BLOOMPOD_DB).

For each non-Rejected supplier, check:

### 1a. Gone cold (no outreach >14 days)
- **(M4) DB-first:** query `"date:Last Outreach Date:start"` from the supplier DB (same pattern as supplier-chaser Step 2). If non-null, use that date directly — no page fetch needed.
- **Fallback:** if `Last Outreach Date` is null, fetch last outreach entry date from the supplier page Outreach section.
- **(M4 surfacing, B4):** collect the names of every non-Rejected supplier where `Last Outreach Date` is null across the full scan. After Step 1 completes, emit exactly one consolidated line at the top of the report: `[M4 fallback: Last Outreach Date null for N suppliers: <comma-separated list>] — will self-correct on next outreach write.` If N = 0, skip the line. Do not emit per-supplier noise. This surfaces previously-silent fallbacks without spamming.
- If last contact >14 days ago and Status is not Rejected or Identified, flag.

### 1b. NDA pending >14 days (individual signal)
- If "NDA Status" = Pending (or equivalent), check when NDA was first requested.
- If >14 days with no resolution, flag as individual risk.

### 1e. NDA pipeline — cross-project summary
After scanning all DBs, build a cross-project NDA status table:

```sql
SELECT Name, "NDA Status", id, url
FROM "{DB_COLLECTION_ID}"
WHERE "NDA Status" NOT IN ('Executed', 'Not Required')
  AND Status NOT IN ('Rejected', 'Identified')
```

Run for all 4 project DBs. For each result:
- Calculate days since NDA was first flagged (use outreach section or OI deadline as proxy if no date field).
- Flag any NDA in progress >21 days as MEDIUM risk.
- Flag any NDA in progress >7 days that is gating an active RFQ (Status = "NDA Sent" or "Quote Requested") as HIGH risk.
- If an "NDA Expiry" date field exists on executed NDAs, flag those expiring within 60 days.

Present as a summary table in the report:
```
| Supplier | Project | NDA Status | Est. Days Pending | Blocking RFQ? |
```

### 1c. Quote expired or expiring
- Parse Notes for quote validity dates.
- Flag quotes expiring within 7 days or already expired.

### 1d. Single-source categories
- Group active suppliers by product category per project.
- Any category with only 1 active supplier (non-Rejected, non-Identified) is a single-source risk.

## Step 2: Scan Open Items DB

```sql
SELECT Item, Status, Type, Owner, "date:Deadline:start" AS Deadline,
       SUBSTR(Context, 1, 150) AS ContextPreview
FROM "collection://505b7f08-8816-4bf7-b77a-7f232b52d0a0"
WHERE Status IN ('Pending', 'In Progress', 'Blocked')
ORDER BY Deadline ASC
```

Flag:
- **Overdue >7 days:** OIs with deadline more than 7 days past.
- **Blocked with no update:** OIs in Blocked status where Context has no entry in the last 14 days.
- **Deadline clustering:** multiple OIs due in the same 3-day window (capacity risk).

## Step 3: Scan Gmail for risk signals

Use `scan-gmail.md` procedure:
- **direction:** "both"
- **date_range:** 14
- **project_filter:** "all"

From results, flag:

### 3a. Unanswered outbound (>7 days)
- Emails sent by Andre where no reply has been received within 7 days.
- Cross-reference with supplier status: if supplier is in active negotiation (RFQ Sent, Quote Received, Shortlisted), escalate priority.

### 3b. Risk keywords in incoming mail
- Scan subjects and snippets for: "delay", "out of stock", "price increase", "cannot", "unfortunately", "unable", "discontinue", "MOQ increase".
- If found, flag with supplier name and keyword.

## Step 4: Check promises and session state

### 4a. Promises
Read `outputs/promises.md`. Flag:
- Overdue promises (due date past today).
- Promises due today.
- Promises with no clear resolution path.

### 4b. Session state carry-over
Read `outputs/session-state.md`. Check Carry-Over and Pending Actions for:
- Items older than 3 days.
- Items flagged as blocking.

## Step 4b: Check ruflo for historical risk patterns

Before classifying, call `mcp__ruflo__memory_search` to enrich findings with learned patterns:

```
query: "supplier risk patterns {project}"
namespace: "procurement"
limit: 5
threshold: 0.4
```

For each supplier flagged as "gone cold" in Step 1a, also search:
```
query: "gone cold {supplier_name}"
namespace: "procurement"
limit: 3
```

If results exist, use them to:
- Elevate or reduce severity if this supplier went cold before and resolved in a predictable pattern
- Note learned signals ("NDA delays for CN suppliers typically resolve after second follow-up")
- Surface prior actions that worked ("firm tone at Tier 3 got response within 48h")

If no results, proceed with standard classification below.

## Step 5: Classify risks

| Severity | Criteria |
|----------|----------|
| **CRITICAL** | Blocks timeline, single source at risk, regulatory dependency |
| **HIGH** | Active negotiation stalled, quote expiring, OI overdue >7d on active supplier |
| **MEDIUM** | NDA pending >14d, no backup identified, info gap on active supplier |
| **LOW** | Routine follow-up needed, minor info gap, housekeeping item |

## Step 6: Generate risk report

```
RISK RADAR -- {Date}
Scanned: {n} suppliers, {n} open items, {n} promises

## CRITICAL ({count})
### [{Project}] {Risk title}
- What: {1-2 sentences}  |  Impact: {what stalls}
- Supplier: {name, status}  |  Last contact: {date}
- Action: {specific next step}

## HIGH ({count})
### [{Project}] {Risk title}
- What: {description}  |  Action: {next step}

## MEDIUM ({count})
(1-2 lines per risk: what + action)

## LOW ({count})
(bullet list, one line each)

## Summary
| Project | Crit | High | Med | Low | Top Risk |
|---------|------|------|-----|-----|----------|

## Top 5 Priority Actions
1. {action, who, by when}
```

## Step 7: Store scan results in ruflo

After presenting the report, call `mcp__ruflo__memory_store` to record what was found:

**Overall scan record:**
- `key`: `risk-scan::[YYYY-MM-DD]`
- `namespace`: "procurement"
- `upsert`: true
- `tags`: ["risk-scan", "daily"]
- `value`: `{ date, total_critical, total_high, total_medium, top_risk_supplier, top_risk_type }`

**Per flagged supplier (one call per CRITICAL or HIGH risk):**
- `key`: `risk::[supplier_name]::[risk_type]::[YYYY-MM-DD]`
- `namespace`: "procurement"
- `upsert`: true
- `tags`: ["risk", project, supplier_name, risk_type]
- `value`: `{ supplier, project, risk_type, severity, days_since_contact, last_action, resolution: null }`

Update `resolution` when the risk is resolved (e.g., supplier replies, NDA executed). This closes the learning loop that was previously missing.

## Rules

- **Read-only for Notion.** No Notion writes, no Gmail drafts, no state changes.
- All output in English. Never expose raw Notion IDs in the report.
- Exclude Rejected suppliers from all risk checks.
- Do not flag Identified suppliers for "gone cold" (not yet contacted).
- Kaia: sourcing gated on Caio/Max. Flag as standing risk, but do not flag individual Kaia suppliers as cold if the project is paused.
- If Notion MCP unreachable, fall back to context files and note it. If Gmail MCP unreachable, skip Steps 3a/3b and note the gap.
- Report is for Andre only. Review before sharing with Jorge/Anand.
