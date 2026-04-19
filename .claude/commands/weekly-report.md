---
description: Compile weekly report from daily logs and supplier DBs, apply executive format, push to Notion as Draft.
model: opus
---

# Weekly Report

**References:**
- `.claude/knowledge/weekly-report-rules.md` — editorial rules and format (read before writing)
- `.claude/config/databases.md` — collection IDs and query patterns for all DBs

---

## Pre-flight

Read `outputs/session-state.md`. Calculate age of Last-Warm-Up:
- If < 2h: use context snapshot. Do not re-read context files.
- If 2–8h: use snapshot as baseline. Run delta scan for this task.
- If > 8h or missing: warn André and recommend /warm-up before proceeding.

Read `.claude/knowledge/weekly-report-rules.md` in full before writing a single line of the report.

---

## Steps

1. **Pull daily logs** for the current week from Daily Logs DB (DAILYLOG_DB in config/databases.md). Fetch each relevant daily log page for full content.

   Then ask André: *"Any relevant inputs this week outside the daily logs? (Legal memos, regulatory alignment, decisions from meetings not logged)"* — incorporate before writing.

2. **Pull previous week's report** from Weekly Reports DB (WEEKLY_DB in config/databases.md). Extract the "Goals next week" section — this becomes the "Goals last week" baseline. Do not reconstruct from memory or daily logs.

3. **Query Supplier DBs** (READ-ONLY) using config/databases.md query patterns:
   - Pull active supplier counts, quote status, open items per project
   - Calculate week-over-week deltas for Snapshot

4. **Determine week number and period** from daily logs.

5. **Write the report** following `.claude/knowledge/weekly-report-rules.md` exactly:

   ```
   # Weekly Report | W[XX] · [Period]
   ISC — Procurement

   ## The big thing this week
   ## Snapshot
   ## Good
   ## Bad
   ## Worries
   ## Key decisions / asks
   ## Goals last week
   ## Goals next week
   ```

6. **Apply editorial checklist** before finalising:
   - The big thing: is it an outcome that shifts a trajectory? If it appears here, does NOT repeat verbatim in Good
   - Good: outcomes only, no operational trail, supplier names only where justified; projects with only admin activity → omit from Good, keep in Snapshot as →
   - Bad / Worries / Key decisions: no individual or supplier names — area/function only
   - Worries: every row has a concrete impact AND a deadline — remove any that don't
   - Goals last week: sourced from previous week's report, ordered 🔴 → 🟡 → 🚫 → 🟢; use 🚫 for goals that expired or changed scope
   - Housekeeping anywhere: remove entirely
   - Total length: max 1 page when rendered — cut if over

7. **Present draft to André** for review before pushing anywhere.

8. After approval, **push to Notion** Weekly Reports DB (WEEKLY_DB in config/databases.md) as Draft. Log the write to `outputs/change-log.md`.

---

## Safety

- NEVER include internal housekeeping (Notion cleanup, command testing, session management).
- NEVER name individuals in Bad, Worries, or Key decisions — use area/function instead.
- Weekly Report status stays **Draft**. Only André marks it as Sent in Notion UI.
- Follow all rules in `.claude/knowledge/weekly-report-rules.md`.
