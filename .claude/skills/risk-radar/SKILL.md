---
name: "Risk Radar"
description: "Proactive risk detection across all 3 projects. Scans supplier DBs, Open Items, Gmail, promises, and session state for risk signals: cold suppliers, expiring quotes, single-source gaps, overdue OIs, unanswered emails. Use at start of day, before leadership updates, or whenever Andre needs a risk snapshot."
---

# Risk Radar

Scans all projects for risks and surfaces them in a prioritized report. Read-only, no writes. Designed to catch problems before they become blockers.

## Pre-flight

1. Read `outputs/session-state.md` for freshness. If warm-up < 2h, use snapshot.
2. Read `.claude/config/databases.md` (collection IDs, schemas).
3. Read `.claude/config/domains.md` (supplier domains for Gmail scan).
4. Read `outputs/promises.md` for open commitments.

## Step 1: Scan supplier DBs for risk signals

Query all 3 Supplier DBs:

```sql
SELECT Name, Status, Notes, "NDA Status", "Samples Status", id, url
FROM "{DB_COLLECTION_ID}"
```

Run for each project DB (IDs in `config/databases.md`).

For each non-Rejected supplier, check:

### 1a. Gone cold (no outreach >14 days)
- Fetch last outreach entry date from supplier page or context file.
- If last contact >14 days ago and Status is not Rejected or Identified, flag.

### 1b. NDA pending >14 days
- If "NDA Status" = Pending (or equivalent), check when NDA was first requested.
- If >14 days with no resolution, flag.

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

## Rules

- **Read-only.** No Notion writes, no Gmail drafts, no state changes.
- All output in English. Never expose raw Notion IDs in the report.
- Exclude Rejected suppliers from all risk checks.
- Do not flag Identified suppliers for "gone cold" (not yet contacted).
- Kaia: sourcing gated on Caio/Max. Flag as standing risk, but do not flag individual Kaia suppliers as cold if the project is paused.
- If Notion MCP unreachable, fall back to context files and note it. If Gmail MCP unreachable, skip Steps 3a/3b and note the gap.
- Report is for Andre only. Review before sharing with Jorge/Anand.
