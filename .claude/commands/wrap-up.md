---
description: End of day routine. Logs sent emails, syncs context files, creates daily log, commits to git.
model: opus
---

# Wrap-Up (End of Day)

**Agents:** supplier-comms (log-sent), notion-ops (daily log + context sync)

Follow CLAUDE.md Safety Rules and Writing Style sections.

## Pre-flight: Date attribution

Before starting, determine `TARGET_DATE` — the date to which this wrap-up is attributed:

1. Check current time using `currentDate` from session context.
2. If current time is **between 00:00 and 03:00 (inclusive):** set `TARGET_DATE = yesterday` (the calendar day before `currentDate`). Note: "Post-midnight session — wrap-up attributed to {TARGET_DATE}." in Phase 5 summary header.
3. Otherwise: `TARGET_DATE = currentDate`.

Use `TARGET_DATE` for all date-sensitive operations below (Phase 3 daily log lookup, Phase 4 commit message, Phase 4c change-log header).

## Steps

### Phase 0: Slack Scan
0. Read config/slack-channels.md for user IDs, channel IDs, and Group DMs.
1. **Call all Slack reads in parallel** — issue all `slack_read_channel` calls (key people DMs + channels + Group DMs) in a single message. Then call `slack_read_thread` in parallel for any threads with replies.
2. Extract decisions, action items, or context relevant to Pulse, Kaia, or M-Band. Include findings in the daily log and pending items.

### Phase 0b: Slack → OI DB
Run `/slack-scan`. This extracts structured signals from all `log=true` channels/DMs since `Last-Slack-Scan` and writes approved signals to OI DB. If Slack MCP fails or zero signals are found, skip silently — wrap-up continues.

### Phase 1: Log Sent Emails
3. Run /log-sent procedure: scan Andre's sent emails for today.
4. For each sent email to a supplier domain, check Notion Outreach for matching entry.
5. Write missing milestone entries directly (auto-approved per check-outreach.md).
6. Report what was written and what was skipped.

### Phase 2: Context Sync

**Phase 2 pre-step — scope sync to touched projects:**

Before querying Notion, determine which projects need syncing:

1. Scan today's `outputs/change-log.md` for project keywords (case-insensitive): `pulse`, `kaia`, `m-band` / `mband`, `bloompod`.
2. For each of the 4 projects, read the first 3 lines of its context file to get `# Last synced:`.
3. Classify each project:
   - **Sync:** change-log mentions the project OR context file `Last synced` > 24h old OR context file missing.
   - **Skip:** change-log has NO mention AND `Last synced` < 24h old.
4. **Fallback — sync all 4:** if change-log is empty (e.g., pure /improve session), sync only projects whose context file is > 24h old; if all are fresh, skip all DB queries and go directly to Phase 2a (index.json regeneration uses the existing files).
5. Log the scope decision: `[Phase 2] Syncing: {list}. Skipping (fresh, not touched): {list}.`

This saves ~3-5k tokens per skipped project. A Pulse-only day skips 3 queries (~12k tokens). An /improve-only session with fresh context skips all 4.

7. **Query only the scoped Supplier DBs** (parallel if >1). Follow `config/databases.md` Query Patterns. Include columns: Name, Status, Notes, "NDA Status", "Samples Status", "Last Outreach Date", Region, Currency. A partial sync causes drift — all fields must be included for each queried project.
8. Update context files for synced projects only. After updating, set the `# Last synced: YYYY-MM-DDTHH:MM` header to the current timestamp. If context-doctor is available, run it in report-only mode after sync to catch any remaining drift.

   **Phase 2 completion check:** After all synced context files are written, re-read the first 3 lines of each and verify `# Last synced` matches the current timestamp. If any synced file still shows a stale timestamp, re-sync it before advancing. Skipped projects are not checked — their existing timestamps stand.

### Phase 2a: Regenerate context/index.json
8a. Per `.claude/procedures/context-loader.md` §Layer 1, regenerate `context/index.json` from the 4 updated context files. Parse each file for:
    - `last_synced` from the `# Last synced:` header
    - `supplier_count_active` = entries not in the Rejected section
    - `supplier_count_rejected` = entries in Rejected section
    - `active_suppliers` = name list from non-Rejected sections
    - `cross_project_suppliers` = supplier names that appear in `active_suppliers` for MORE THAN ONE project. Compute by intersecting the 4 `active_suppliers` lists. Example: Xinrui Group active in both Pulse and M-Band → `"cross_project_suppliers": ["Xinrui Group"]`. Empty list `[]` if none. Warm-up uses this to flag shared suppliers that may have competing priorities.
    - `blocker_count` = COUNT of OIs with Status=Blocked for this project, queried from OI DB:
      `SELECT COUNT(*) FROM "collection://505b7f08-8816-4bf7-b77a-7f232b52d0a0" WHERE Status='Blocked' AND Project LIKE '%{project_display_name}%'`
      Fallback if OI DB unavailable: count supplier entries with non-null `blocker:` field in the context file.
    - `top_deadline` = MIN(Deadline) across non-Closed, non-Rejected OIs for this project:
      `SELECT MIN("date:Deadline:start") FROM "collection://505b7f08-8816-4bf7-b77a-7f232b52d0a0" WHERE Status NOT IN ('Closed','Rejected') AND Project LIKE '%{project_display_name}%'`
      Fallback if OI DB unavailable: parse earliest date from `blocker:` + `next:` fields in the context file.

    Write atomically: tmp file, then rename. If generation fails, log `[EVENT: FAIL target=context_index]` and continue — warm-up falls back to Full mode when index is missing.

### Phase 2b: External Work
8b. Read outputs/external-work.md. If it contains entries beyond the header comments, include them in the daily log under ## ISC (or the relevant project section if specified).
8c. After inclusion in the daily log draft, clear the file back to headers only.

### Phase 3: Daily Log
9. Check if `TARGET_DATE`'s daily log exists in Notion (Daily Logs DB, see .claude/config/databases.md).
   - If yes: present current content, ask if anything to add.
   - If no: compile from `TARGET_DATE`'s mail-scan results, approved actions, change-log entries, and external work (Phase 2b). Present draft for approval.

### Phase 3b: Meeting Outcome Prompt

Check whether a `/meeting-prep` was run this session. Look for:
- `meeting-prep` entries in `outputs/session-state.md` Pending Actions
- Lines containing "meeting-prep" in today's `outputs/change-log.md`

If a meeting-prep was found: ask André — "Did you meet with [supplier/person] today? Want to log the outcome to ruflo? (yes/no)"
- **Yes:** Run meeting-prep Step 8 — call `mcp__ruflo__memory_store` with key `meeting::[supplier]::[YYYY-MM-DD]`, namespace "procurement", tags ["meeting", project, supplier].
- **No or skipped:** move on silently.

If no meeting-prep entry found this session: skip silently.

### Phase 4: Commit, Push, and Stop Crons
10. After daily log is approved and pushed to Notion:
    a. Run:
    git add context/ outputs/ .claude/skills/ CLAUDE.md .claude/agents/ .claude/commands/ .claude/config/*.md .claude/procedures/
    git commit -m "EOD {TARGET_DATE}: context synced, daily log complete"
    git push
    b. **Stop session crons:** read the `## Session Crons` section of `outputs/session-state.md`. For each cron ID listed, call `CronDelete`. If the cron no longer exists (already expired or deleted), skip silently. If the section is empty or absent, skip — no crons were started this session. Then clear the `## Session Crons` section in session-state.md (leave the header, remove the ID lines). This prevents stale crons from firing after session end.
    **Clear Active Sessions:** set `## Active Sessions` in `outputs/session-state.md` to `(none — cleared by /wrap-up {TARGET_DATE})`. This unblocks the 60-minute session-liveness check in `safety.md` for any CCR or next-day session.
    c. Only after crons are stopped: clear outputs/change-log.md — keep only the 3 header comment lines (`# Change Log`, policy line, `# History lives in git log…`). Remove all date sections and entries. If git push (step a) failed, halt and report the error. Do NOT clear the change-log until push succeeds — the entries are the only local record of today's writes. Session-doctor's auto-fix will add the fresh `## {NEXT_DATE}` heading on next session start.

### Phase 4b: FX Refresh Check (monthly)

Read the first ~12 lines of `.claude/config/fx-rates.md` and parse the `Last updated` column of the Current rates table. Compute days since that date.

- If >30 days: include the line `REFRESH FX RATES — last updated {date}, {N}d ago. Update ECB reference rates in config/fx-rates.md before next quote-intake.` at the top of the Phase 5 summary under a `## Action needed` header.
- If ≤30 days: skip silently.

This is a non-blocking flag. The commit still proceeds. The flag ensures André sees the refresh prompt exactly once per month during EOD rather than discovering stale rates mid-quote.

### Phase 4c: Supplier Pattern Rollup
9c. Per `.claude/procedures/supplier-pattern-store.md` §Producers.3: for each supplier touched today (any Outreach write in Phase 1 or status change in Phase 2), re-derive `response_rate_90d` from the chase log (`chase::{supplier}::*` keys via `mcp__ruflo__memory_search`, tag filter `chase`) and store back into the pattern record. This self-heals drift from missed per-event updates. Trim `known_patterns` to the last 5. Ruflo failures non-blocking.

### Phase 4d: Autonomy Ledger Delta
9d. Read `outputs/autonomy-ledger.md`. Compute delta since last `/wrap-up` (use `Last-Wrap-Up` from `outputs/session-state.md` as cutoff):
- Count new entries by `action_class` × `decision`.
- For each class with `approved_clean` entries, compute consecutive-clean streak (reset on any `approved_edited` or `rejected` inside last 20).
- Flag any class hitting these thresholds: ≥15 clean streak (approaching promotion), ≥3 rejected in last 20 (demotion candidate).
- Format as a 3-5 line block:
  ```
  Ledger delta ({N} new entries since {last_wrap_up}):
  - {action_class}: {clean}/{edited}/{rejected} — streak={N}
  - ...
  Promotion-approaching: {class1}, {class2}
  Demotion-candidates: {class3}
  ```
- Store this block in a variable; emit in Phase 5 summary.

### Phase 5: Summary
11. Present summary:
    - Sent emails logged (list entries written)
    - Context files updated (list changes)
    - Daily log status (created or updated)
    - Git commit hash + push status
    - Pending items for tomorrow (from Open Items DB + unanswered emails)
    - `REFRESH FX RATES` flag from Phase 4b if triggered
    - **Autonomy ledger delta** from Phase 4d (new entries, promotion-approaching, demotion-candidates).
    - **Supplier patterns touched** — count of pattern records upserted in Phase 4c.

## Rules
- Always run log-sent BEFORE context sync (outreach may change during log-sent).
- Always sync context files BEFORE creating the daily log (log may reference current state).
- If daily log already exists and is Complete, skip Phase 3.
- Git commit + push is automatic after approval. No separate confirmation needed.
