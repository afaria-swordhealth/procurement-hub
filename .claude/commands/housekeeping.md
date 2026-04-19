---
description: Background maintenance. Clean outreach, fix compliance, check OIs, verify context. Autonomous where safe.
model: sonnet
---

# Housekeeping

**Agents:** notion-ops (Notion read+write), supplier-comms (Gmail read for unanswered check)
**Session role:** B (background). Does NOT create Gmail drafts or update context files.
**Philosophy:** Fix what is mechanical. Report what needs judgment.
**Rules:** Follow CLAUDE.md Safety Rules and Writing Style sections.

## Pre-flight

Read `outputs/session-state.md`. Calculate age of Last-Warm-Up:
- If < 2h: use context snapshot. Do not re-read context files.
- If 2–8h: use snapshot as baseline. Run delta scan for this task.
- If > 8h or missing: warn André and recommend /warm-up before proceeding.

Before starting, check outputs/change-log.md for a HOUSEKEEPING REPORT entry today. If found, warn Andre and ask whether to re-run or skip.

## Phase 1: Outreach Maintenance (AUTO-EXECUTE)

Use config/databases.md (Query Patterns section) with columns: Name, Status; filter: Status != 'Rejected' to get all active suppliers.

For each active supplier page, fetch ## Outreach section. Then apply .claude/procedures/check-outreach.md:

1. **Condensation**: >7 visible entries? Archive older ones per condensation rules.
2. **Translation**: Portuguese entries? Translate to English. Write directly.
3. **Chronological order**: Entries out of order? Fix.
4. **Duplicates**: Remove exact duplicate entries.
5. Log all writes to outputs/change-log.md.

**Phase 1b (M4) — Last Outreach Date sync (REPORT ONLY):** After Phase 1 loop, for each active supplier (non-Rejected), query `"date:Last Outreach Date:start"`. Flag in NEEDS YOUR DECISION for: (a) field is NULL and the supplier has visible Outreach entries — "Last Outreach Date not populated; will self-correct on next /log-sent or chase"; (b) field is set but appears more than 7 days behind the most recent Outreach entry — "Last Outreach Date field drift detected."

## Phase 2: Notes Compliance (AUTO-EXECUTE)

Query all 4 DBs via config/databases.md (Query Patterns section) with columns: Name, Status, Notes, Currency, NDA Status.

For each active supplier:

6. **Pricing in Notes**: If pricing info appears in Notes AND the DB price field holds the exact same value (same currency, within 1% tolerance), remove from Notes. If values differ, flag as NEEDS YOUR DECISION instead of auto-removing — the discrepancy may indicate a data error or interim update.
7. **Contact in Notes**: If contact info appears in Notes AND exists in Contact field, remove from Notes.
8. **Length**: Condense Notes exceeding 2 lines. Format: "TYPE (Location). Product + differentiator. Flag." Max 2 lines.
9. **Language**: Translate any Portuguese Notes to English.
10. Log all writes to outputs/change-log.md.

## Phase 3: DB Field Hygiene (AUTO-EXECUTE)

Using the same query results from Phase 2:

11. **Currency**: CN/US suppliers = USD. PT/EU suppliers = EUR. Auto-fix null values only. If a non-null value appears wrong, flag as NEEDS YOUR DECISION — the setting may be intentional (e.g., CN entity invoicing via a UK subsidiary in GBP).
12. **NDA on Rejected**: Set NDA Status to "Not Required" for any Rejected supplier where NDA is "Pending" or null.
13. Log all writes to outputs/change-log.md.

## Phase 4: Open Items (MIXED)

Query Open Items DB (ID from .claude/config/databases.md, OI_DB) for items with Status != Closed.

14. **AUTO-EXECUTE**: Close OIs linked to Rejected suppliers (resolution: "Supplier rejected, no longer relevant").
15. **REPORT ONLY + AUTO-COMMENT**: Flag overdue items (`"date:Deadline:start" < date('now')`). For each overdue OI, also auto-post a Notion page comment via notion-create-comment: `Housekeeping flagged overdue [date]. Deadline: [deadline]. Owner: [owner].` (auto-approved per CLAUDE.md §5 Exception 2). Log each comment to outputs/change-log.md.
16. **REPORT ONLY**: Flag stale items — non-Closed OIs whose deadline is >21 days past today (proxy for stale since CLAUDE.md §4c removed dated Context prefixes). Single SQL covers both overdue and stale:
    ```sql
    SELECT Item, Owner, Status,
           "date:Deadline:start" AS Deadline,
           CASE WHEN "date:Deadline:start" < date('now') THEN 'overdue' ELSE NULL END AS OverdueFlag,
           CASE WHEN "date:Deadline:start" < date('now', '-21 days') THEN 'stale' ELSE NULL END AS StaleFlag
    FROM "collection://505b7f08-8816-4bf7-b77a-7f232b52d0a0"
    WHERE Status != 'Closed'
      AND (
        "date:Deadline:start" < date('now')
        OR "date:Deadline:start" < date('now', '-21 days')
      )
    ORDER BY Deadline ASC
    ```
    Note: deadline-age replaces the old `SUBSTR(Context, 1, 10)` date check, which was broken by the CLAUDE.md §4c reform (Context is now a summary paragraph, not a running log with dated prefixes).
    Additionally, for any OI where Context contains multiple dated-prefix lines (e.g. `[2026-04-10]`, `[2026-04-15]`) or Portuguese text, flag as NEEDS YOUR DECISION: "Context cleanup needed — running-log format detected. Summarize into one English paragraph per CLAUDE.md §4c." Do NOT auto-rewrite — this is SHOW BEFORE WRITE.
17. **REPORT ONLY**: Propose closures for items that appear resolved (present reason, do not write).
17b. **REPORT ONLY**: For each active supplier page, fetch the ## Open Items section body. If it contains inline bullet list items (as opposed to a linked database view), flag as NEEDS YOUR DECISION: `[Supplier]: ## Open Items contains inline bullets — migrate to central OI DB and replace with linked view per CLAUDE.md Rule 8.` List the bullet items found so André can create the OI records. Do NOT auto-migrate (irreversible).

## Phase 5: Context Drift Check (REPORT ONLY)

18. Delegate to the `context-doctor` skill. Call it in report-only mode (no auto-fix).
19. Include context-doctor's drift findings verbatim in the NEEDS YOUR DECISION section.
20. Do not re-implement the comparison logic here. context-doctor is the authoritative implementation.

## Phase 6: Unanswered Emails (REPORT ONLY)

21. **(M4 pre-filter)** Query `"date:Last Outreach Date:start"` for all active suppliers. Skip Gmail scan entirely for suppliers where `Last Outreach Date > date('now', '-2 days')` (recently active, no concern). For remaining suppliers, run the scan below.
22. Use .claude/procedures/scan-gmail.md (direction: "both", mode: "filtered") to get recent emails for suppliers not skipped in step 21.
23. For each active supplier not skipped, compare last received email date vs last sent email date.
24. Flag suppliers where we received an email >48h ago with no reply from us. Exception: if the email was received after Friday 17:00 or on a weekend, start the 48h clock from Monday 09:00 — prevents routine Friday-evening emails from flagging as overdue every Monday morning.

## Phase 6b: Synthesis — Supplier Chaser Candidates (REPORT ONLY)

25. Cross-reference Phase 4 overdue OIs and Phase 6 unanswered emails.
26. Identify suppliers appearing in BOTH lists: an overdue OI linked to them AND an unanswered email.
27. For each such supplier: add a NEEDS YOUR DECISION entry recommending `/supplier-chaser`.
    Format: `[Supplier]: overdue OI "{title}", unanswered email since [date]. Recommend /supplier-chaser.`

## Error Handling

**Batch loop failures (Phases 1–3, Phase 4 rule 14):** If Notion MCP fails for one supplier mid-loop: skip that supplier, log `[Supplier] — Notion MCP error, skipped` to change-log, and continue to the next. Do not abort the phase.

**Phase-level query failures (Phase 4 OI query, Phase 6 Gmail scan):** If the initial query fails entirely: skip that phase, report the failure in the output, and continue with remaining phases. Do not abort the full housekeeping run.

**Report skipped items** under a `MCP ERRORS:` bucket in the AUTO-EXECUTED output section.

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

OIs FLAGGED (auto-comment added):
- [Item]: "housekeeping flagged overdue [date]" comment posted

MCP ERRORS:
- [Supplier/phase]: MCP error, skipped

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
