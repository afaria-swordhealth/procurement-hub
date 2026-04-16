---
name: "Weekly Pulse"
description: "Generate a compact weekly metrics snapshot across all 3 projects: supplier movement, quotes, OIs, email activity, and blockers. Use for a quick health check or to prepare a summary for Jorge/Anand. Lighter than /weekly-report."
---

# Weekly Pulse

Automated weekly metrics snapshot. Pulls data from Notion DBs, Gmail, and change-log git history. Produces a compact, shareable report. Read-only output, no writes.

## Pre-flight

1. Read `outputs/session-state.md` for freshness.
2. Read `.claude/config/databases.md` (DB IDs, schemas, query patterns).
3. Read `.claude/procedures/scan-gmail.md` (email scan patterns).
4. Read `outputs/promises.md` for promise fulfillment tracking.

## Input

- **Time window**: defaults to last 7 days. Accepts custom range (e.g., "last 14 days", "Apr 7-14").
- Calculate `start_date` and `end_date` from input.

## Step 1: Query Notion DBs

### Supplier movement (per project)

For each Supplier DB (PULSE_DB, KAIA_DB, MBAND_DB):

```sql
SELECT Name, Status, Notes FROM "{SUPPLIER_DB}"
```

Cross-reference with `context/{project}/suppliers.md`, change-log git history, and Daily Logs to detect status changes. Classify: **Advanced** (higher tier), **Deprioritized** (Parked/Rejected), **New** (appeared in window).

### Open Items snapshot

```sql
SELECT Item, Status, Type, Owner, "date:Deadline:start" AS Deadline, Project
FROM "collection://505b7f08-8816-4bf7-b77a-7f232b52d0a0"
```

Calculate: created this week (Context first date in window), closed this week, overdue (open + past deadline), total open.

### Daily Logs

```sql
SELECT title, Date, Highlights FROM "collection://386548e7-1a94-4c9f-8c5c-068aca0bc843"
WHERE Date >= '{start_date}' AND Date <= '{end_date}' ORDER BY Date ASC
```

Scan Highlights for significant events.

## Step 2: Scan Gmail

Use `scan-gmail.md` procedures with date range = window. Map domains to projects via `config/domains.md`.

- **Sent:** `from:a.faria@swordhealth.com {domain_filters} after:{start_date} before:{end_date}` (count per project)
- **Received:** `to:a.faria@swordhealth.com {domain_filters} after:{start_date} before:{end_date}` (count per project)
- **Response time:** match sent/received pairs by thread. Calculate business days between exchanges. Report averages for each direction separately.

## Step 3: Change-log and promises

**Git history:** `git log --oneline --after="{start_date}" --before="{end_date}" -- outputs/change-log.md`. Parse for Notion write counts and quote events.

**Promises:** Parse `outputs/promises.md`. Calculate fulfillment rate: resolved this week / (resolved + still open from start-of-week cohort).

## Step 4: Compile and present

### Per-project table

Rows: Suppliers advanced, Suppliers deprioritized, New quotes received, Outreach entries logged, OIs created, OIs closed, OIs overdue, Emails sent, Emails received. Columns: Pulse, Kaia, M-Band, Total.

### Cross-project metrics

Total active suppliers (W/W delta), promise fulfillment rate, avg response time (them/us), blockers resolved vs new.

W/W delta requires previous window data. If unavailable, show count only with note "first run."

### Highlights (1 per project)

Pick most significant event. Priority: supplier selected/rejected > large quote > blocker resolved > sample received > NDA signed. If none, "Steady state, routine follow-ups."

### Concerns

Flag: response time increasing, OIs accumulating (created > closed), suppliers going cold (active + no email >10d), promises overdue (rate < 70%), project with zero activity. If nothing, "No flags this week."

### Output format

```
WEEKLY PULSE — {start_date} to {end_date}

[Per-project table]
[Cross-project metrics]

HIGHLIGHTS
- Pulse: {highlight}
- Kaia: {highlight}
- M-Band: {highlight}

CONCERNS
- {items}

---
Sources: Notion, Gmail, change-log, promises.md.
```

Compact enough to paste into Slack for Jorge/Anand. For the full version, use `/weekly-report`.

## Rules

- READ-ONLY. This skill produces analysis, no writes to Notion, Gmail, or context files.
- Never include supplier pricing details in the output. Counts and trends only.
- If a data source is unavailable (Notion down, Gmail MCP unreachable), report the gap clearly and produce partial results from available sources. Label which sections are incomplete.
- Promise fulfillment rate uses only the cohort of promises open at start of the window, not all-time.
- Week-over-week delta for active suppliers requires data from the previous window. If unavailable, show the count without delta and note "W/W delta unavailable, first run."
- Do not include ISC-level or internal housekeeping items. This is supplier-facing metrics only.
- Response time calculation excludes weekends (count business days only).
