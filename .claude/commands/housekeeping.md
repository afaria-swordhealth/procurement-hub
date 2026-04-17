---
description: Background maintenance. Clean outreach, fix compliance, check OIs, verify context. Autonomous where safe.
model: sonnet
---

# Housekeeping

**Agents:** notion-ops (Notion read+write), supplier-comms (Gmail read for unanswered check)
**Session role:** B (background). Does NOT create Gmail drafts or update context files.
**Philosophy:** Fix what is mechanical. Report what needs judgment.
**Rules:** Follow CLAUDE.md Safety Rules and Writing Style sections.
Before starting, check outputs/change-log.md for a HOUSEKEEPING REPORT entry today. If found, warn Andre and ask whether to re-run or skip.

## Phase 1: Outreach Maintenance (AUTO-EXECUTE)

Use config/databases.md (Query Patterns section) with columns: Name, Status; filter: Status != 'Rejected' to get all active suppliers.

For each active supplier page, fetch ## Outreach section. Then apply .claude/procedures/check-outreach.md:

1. **Condensation**: >7 visible entries? Archive older ones per condensation rules.
2. **Translation**: Portuguese entries? Translate to English. Write directly.
3. **Chronological order**: Entries out of order? Fix.
4. **Duplicates**: Remove exact duplicate entries.
5. Log all writes to outputs/change-log.md.

## Phase 2: Notes Compliance (AUTO-EXECUTE)

Query all 3 DBs via config/databases.md (Query Patterns section) with columns: Name, Status, Notes, Currency, NDA Status.

For each active supplier:

6. **Pricing in Notes**: If pricing info appears in Notes AND exists in a DB price field, remove from Notes.
7. **Contact in Notes**: If contact info appears in Notes AND exists in Contact field, remove from Notes.
8. **Length**: Condense Notes exceeding 2 lines. Format: "TYPE (Location). Product + differentiator. Flag." Max 2 lines.
9. **Language**: Translate any Portuguese Notes to English.
10. Log all writes to outputs/change-log.md.

## Phase 3: DB Field Hygiene (AUTO-EXECUTE)

Using the same query results from Phase 2:

11. **Currency**: CN/US suppliers = USD. PT/EU suppliers = EUR. Only fix if currently null or clearly wrong.
12. **NDA on Rejected**: Set NDA Status to "Not Required" for any Rejected supplier where NDA is "Pending" or null.
13. Log all writes to outputs/change-log.md.

## Phase 4: Open Items (MIXED)

Query Open Items DB (ID from .claude/config/databases.md, OI_DB) for items with Status != Closed.

14. **AUTO-EXECUTE**: Close OIs linked to Rejected suppliers (resolution: "Supplier rejected, no longer relevant").
15. **REPORT ONLY**: Flag overdue items (`"date:Deadline:start" < date('now')`).
16. **REPORT ONLY**: Flag stale items — leading Context date >21 days old on active items. Single SQL query covers both overdue and stale:
    ```sql
    SELECT Item, Owner, Status,
           "date:Deadline:start" AS Deadline,
           SUBSTR(Context, 1, 10) AS LastUpdate,
           CASE WHEN "date:Deadline:start" < date('now') THEN 'overdue' ELSE NULL END AS OverdueFlag,
           CASE WHEN Context IS NOT NULL AND SUBSTR(Context, 1, 10) < date('now', '-21 days') THEN 'stale' ELSE NULL END AS StaleFlag
    FROM "collection://505b7f08-8816-4bf7-b77a-7f232b52d0a0"
    WHERE Status != 'Closed'
      AND (
        "date:Deadline:start" < date('now')
        OR (Context IS NOT NULL AND SUBSTR(Context, 1, 10) < date('now', '-21 days'))
      )
    ORDER BY Deadline ASC
    ```
    Note: OI Context no longer uses a leading-date prefix (see CLAUDE.md §4c). The Context date substring check may not work for compliant OIs. Flag by Deadline overage and review Notion page comments for staleness.
17. **REPORT ONLY**: Propose closures for items that appear resolved (present reason, do not write).

## Phase 5: Context Drift Check (REPORT ONLY)

18. Delegate to the `context-doctor` skill. Call it in report-only mode (no auto-fix).
19. Include context-doctor's drift findings verbatim in the NEEDS YOUR DECISION section.
20. Do not re-implement the comparison logic here. context-doctor is the authoritative implementation.

## Phase 6: Unanswered Emails (REPORT ONLY)

21. Use .claude/procedures/scan-gmail.md (direction: "both", mode: "filtered") to get recent emails.
22. For each active supplier, compare last received email date vs last sent email date.
23. Flag suppliers where we received an email >48h ago with no reply from us.

## Output

Single report with two sections:

```
HOUSEKEEPING REPORT -- Apr DD

=== AUTO-EXECUTED ===

OUTREACH MAINTENANCE:
- [Supplier]: archived [X] entries (now [Y] visible)
- [Supplier]: translated [X] entries PT -> EN
- [Supplier]: summary line updated
- [Supplier]: [X] duplicates removed

NOTES FIXED:
- [Supplier]: pricing removed (already in DB)
- [Supplier]: condensed to 2 lines
- [Supplier]: translated PT -> EN

DB FIELDS FIXED:
- [Supplier]: Currency set to [USD/EUR]
- [Supplier]: NDA Status -> "Not Required" (rejected)

OIs CLOSED:
- [Item]: closed (supplier rejected)

=== NEEDS YOUR DECISION ===

OPEN ITEMS:
- Overdue: [item] (deadline [date], owner [name])
- Stale: [item] (last update [date], >21d)
- Propose close: [item] (reason)

CONTEXT DRIFT:
- [file]: [field] says X, Notion says Y

UNANSWERED (>48h):
- [Supplier] ([contact]): last received [date], no reply
```
