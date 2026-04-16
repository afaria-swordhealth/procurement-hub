---
name: "Promise Tracker"
description: "Sync and validate promises.md against the Open Items DB in Notion. Detects deadline mismatches, stale promises, missing OI links, and format issues. Auto-fixes formatting only. Reports consistency issues and suggests OI creations or closures for Andre."
---

# Promise Tracker

Reads `outputs/promises.md`, cross-references each entry against the Open Items DB in Notion, and reports inconsistencies. Auto-fixes only formatting issues. All substantive changes (closures, OI creation, deadline alignment) are reported for Andre.

## Pre-flight

1. Read `outputs/session-state.md` for freshness timestamps.
2. Read `outputs/promises.md` (full file).
3. Read `.claude/procedures/create-open-item.md` (OI field rules, Context format).
4. Read `.claude/config/databases.md` for OI DB query patterns.

## Step 1: Parse promises.md

Parse all entries in the `## Open` section. Expected format per entry:
```
- [ ] {who} | {what} | promised: YYYY-MM-DD | due: YYYY-MM-DD | next: {step} | OI: {id or --} | source: {where}
```

For each entry, extract: who, what, promised date, due date, next step, OI reference, source.

Flag any entry that doesn't match the format (missing fields, wrong date format, missing pipes).

## Step 2: Query Open Items DB

Fetch all non-closed OIs, plus the 20 most recently closed (for cross-ref):

```sql
SELECT Item, Status, Owner, "date:Deadline:start" AS Deadline, Context, id
FROM "collection://505b7f08-8816-4bf7-b77a-7f232b52d0a0"
WHERE Status != 'Closed'
```

```sql
SELECT Item, Status, Resolution, id
FROM "collection://505b7f08-8816-4bf7-b77a-7f232b52d0a0"
WHERE Status = 'Closed' ORDER BY "date:Deadline:start" DESC LIMIT 20
```

If Notion MCP is unreachable, run format-only checks and note Notion was unavailable.

## Step 3: Cross-reference promises with OIs

For each promise that has an OI reference (OI field != "--"):

| Check | Condition | Classification |
|-------|-----------|---------------|
| Deadline mismatch | Promise `due:` differs from OI `Deadline` by > 1 day | REPORT |
| Promise open, OI closed | OI Status = Closed but promise still in Open section | REPORT |
| OI closed, promise open | Same as above, opposite direction check | REPORT |
| OI status changed | OI moved to Blocked/In Progress since promise was written | REPORT |
| OI not found | OI ID in promise doesn't match any record | REPORT |

## Step 4: Check promises without OI links

For each promise where OI = "--":

1. **Overdue > 3 days and significant:** Suggest creating an OI. "Significant" means: involves a supplier commitment, blocks other work, or has a specific deliverable. Simple acks or low-stakes follow-ups do not need OIs.
2. **Appears resolved:** If the `what` matches a completed item in session-state.md or change-log.md, suggest moving to Resolved.
3. **Stale next step:** If the `next:` field references a date that has passed (e.g., "chase Apr 14" but today is Apr 17), flag for update.

## Step 5: Check Resolved section

For each entry in `## Resolved`:
- If it still has a linked OI that is NOT Closed in Notion, flag: "Resolved promise but OI still open."

## Step 6: Auto-fix (format only)

Safe to auto-fix without approval:

- **Missing pipes:** Add `|` separators where fields run together.
- **Date format:** Normalize to YYYY-MM-DD (e.g., "Apr 14" in due field becomes "2026-04-14").
- **Whitespace:** Trim extra spaces around pipe separators.
- **Checkbox format:** Ensure open items use `- [ ]` and resolved use `- [x]`.
- **Missing "OI: --":** If the OI field is entirely absent, append `| OI: -- |` in the correct position.

Do NOT auto-fix:
- Deadline values (even if they mismatch Notion).
- Status (open vs resolved).
- Content of who/what/next fields.

Log format fixes to `outputs/change-log.md`.

## Step 7: Output report

Sections: FORMAT FIXES (auto-applied list), CONSISTENCY ISSUES (table: #, Promise, Issue, Recommendation), STALE NEXT STEPS (list), RESOLVED WITH OPEN OIs (list), SUGGESTED OI CREATIONS (table with all 7 required fields pre-filled per create-open-item.md), SUMMARY (counts).

## Rules

- NEVER move a promise to Resolved without Andre's approval. Only suggest it.
- NEVER create OIs automatically. Only suggest them with pre-filled fields.
- NEVER change deadline values in promises.md. Only report mismatches.
- Format fixes are the only auto-writes. Everything else is a report.
- Log all format fixes to `outputs/change-log.md`.
- When suggesting an OI creation, include all 7 required fields (Item, Status, Type, Owner, Deadline, Project, Context) pre-filled per create-open-item.md.
- If Notion is unreachable, run format checks only and note Notion was unavailable.
