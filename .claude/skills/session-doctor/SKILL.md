---
name: "Session Doctor"
description: "Validate and heal session state at the start of any session. Checks timestamp freshness, context file staleness, change-log hygiene, and git state. Auto-fixes stale change-logs and bad timestamps. Reports issues with recommended actions. Designed to be lightweight and fast."
---

# Session Doctor

Quick health check for session infrastructure. Run at the start of any session, before other commands. Catches issues left by crashed sessions, missed wrap-ups, or stale state.

## Pre-flight

1. Read `outputs/session-state.md` (the primary target of this skill).
2. Read `outputs/change-log.md` (check for stale entries).
3. Note the current time for all freshness comparisons.

## Step 1: Check session-state.md timestamps

Parse the `## Timestamps` section. For each timestamp, calculate age:

| Timestamp | Threshold | Flag |
|-----------|-----------|------|
| Last-Warm-Up > 8h | Full warm-up needed before operational commands | REPORT |
| Last-Warm-Up 2-8h | Delta scan recommended, context snapshot usable as baseline | REPORT |
| Last-Warm-Up < 2h | Context snapshot is fresh, no action needed | OK |
| Last-Mail-Scan > 4h | Emails may be stale — run `/ping` first to verify Gmail token is valid, then `/mail-scan`. If token expired, re-auth before scanning. | REPORT |
| Last-Log-Sent > 24h | Outreach may not be logged, suggest /log-sent | REPORT |
| Last-Wrap-Up > 24h | Context files likely stale, suggest /wrap-up | REPORT |
| Any timestamp in the future | Clock error or bad write | AUTO-FIX |
| Any timestamp missing | Incomplete session-state | REPORT |

## Step 1a: Liveness check

Check the `## Active Sessions` section and the mtime of `outputs/session-state.md`:

| Condition | Action |
|-----------|--------|
| `## Active Sessions` lists 2+ sessions AND most recent mtime ≤ 60 min | REPORT: `[MULTI_SESSION] {N} sessions listed as active ({roles}). Likely from concurrent warm-up (e.g., post-compact light run). Crons may be duplicated (Step 1c will confirm). Run /wrap-up to clean up before next /warm-up; or rely on warm-up Phase 8 pre-cron guard going forward.` |
| `## Active Sessions` lists a session AND session-state.md mtime > 60 min | REPORT: `[IDLE_SESSION] Session A listed as active but session-state.md is {N}h old — session likely abandoned. New session may proceed with full write access (60min liveness threshold per safety.md).` |
| `## Active Sessions` is `(none)` or empty | OK — no prior session active |
| `## Active Sessions` lists a single session AND mtime ≤ 60 min | REPORT: `Session A active (started {time}). Write operations may conflict — confirm this is the only active session.` |

This catches the common case: wrap-up ran last night, session-state still says "Session A active" from yesterday, blocks today's writes unnecessarily. Also catches concurrent warm-up (Session A + Session B) — the warm-up Phase 8 pre-cron guard prevents this prospectively, but Step 1a flags any pile-up that slipped through.

## Step 1b: Validate session-state.md structure

Before checking timestamps, verify the file is structurally intact (guard against partial writes from crashed sessions):

Required sections that must be present:
- `## Timestamps`
- `## Context Snapshot`
- `## Pending Actions`

| Condition | Action |
|-----------|--------|
| Any required section missing | REPORT: session-state.md may be corrupt (partial write). Recommend re-running /warm-up before any operational command. |
| File exists but is under 10 lines | REPORT: file is suspiciously short — likely truncated. Treat as missing. |
| All sections present | OK, proceed to timestamp checks |

Do NOT attempt to repair a corrupt session-state.md. Only /warm-up can rebuild it.

## Step 1c: Verify session crons (only if Last-Warm-Up < 8h)

If `Last-Warm-Up >= 8h`: skip this step — warm-up was from a prior session; crons were dropped on session end.

If `Last-Warm-Up < 8h`:
1. Read the `## Session Crons` section from `outputs/session-state.md`. Count listed cron ID lines (N) — ignore comment lines starting with `#`.
2. Group cron IDs by task (parse the `(mail-scan ...)`, `(log-sent ...)`, `(morning-brief ...)` annotation per line). Compute max-per-task M.
3. Call `CronList`.

| Condition | Action |
|-----------|--------|
| Any task appears with M ≥ 2 cron IDs in session-state | REPORT: `[CRON_PILEUP] {N} crons registered, max {M} per task — likely from concurrent warm-up. Run /wrap-up Phase 4b to delete all and re-register cleanly on next warm-up.` |
| session-state lists N crons AND CronList is empty | REPORT: session crons dropped — warm-up ran but crons are not registered. Re-run /warm-up. |
| session-state lists N crons AND CronList matches (same count) | OK |
| session-state has no `## Session Crons` section | OK — no crons configured |
| CronList has crons but session-state lists none | REPORT: unregistered crons found — session-state may be stale |

This check catches the case where the session restarted after warm-up (crons are session-scoped and lost on restart) while the timestamp still looks fresh, AND the case where a concurrent warm-up registered duplicate crons (M ≥ 2 per task).

## Step 2: Check context file freshness and count

Read the first 6 lines of each context file (captures `# Last synced:` header and `## Active (N)` count) plus `context/index.json`:
- `context/pulse/suppliers.md`
- `context/kaia/suppliers.md`
- `context/mband/suppliers.md`
- `context/phonestand/suppliers.md`

| Condition | Action |
|-----------|--------|
| "Last synced" > 24h | REPORT: `[DRIFT_RISK]` — Notion may have changed since last sync. Recommend `/context-doctor {project}`. |
| "Last synced" > 48h | REPORT: `[STALE]` — context is likely out of date. Recommend `/wrap-up` or `/context-doctor {project}`. |
| "Last synced" missing | REPORT: no freshness header. |
| "Last synced" in the future | AUTO-FIX: set to current timestamp. |
| File missing entirely | REPORT: critical, context file does not exist. |
| `## Active (N)` count in file ≠ `supplier_count_active` in `index.json` for that project | REPORT: `[COUNT_MISMATCH]` — file says N active, index says M. A supplier may have been added or rejected without a full sync. Recommend `/context-doctor {project}`. |

Do NOT read full context files. Maximum 6 lines per file + `index.json`. No Notion queries.

## Step 2b: Check skill queue

Read `outputs/skill-queue.md`. If the file is missing or empty (header only), skip. Otherwise:

| Condition | Action |
|-----------|--------|
| Row with date > 7 days ago | REPORT: `[STALE_HANDOFF] {target_skill} for {supplier} queued on {date} — not yet executed. Run /{target_skill} {supplier} or clear the row manually.` |
| Row with date ≤ 7 days ago | Note in report as `[PENDING_HANDOFF] {target_skill} — {supplier} ({date})` — informational, no action required |

## Step 3: Check change-log.md

Read `outputs/change-log.md`. Check the date header:

| Condition | Action |
|-----------|--------|
| Date header matches today | OK, normal state |
| Date header is yesterday or older | AUTO-FIX: wrap-up likely missed the cleanup. Clear the file body, set today's date header, preserve the file header comments |
| File is empty (no date header) | AUTO-FIX: add today's date header |
| File missing | REPORT: change-log.md does not exist |

When clearing stale entries, preserve the file header (first 3 lines) and set today's date section.

## Step 4: Check git state

Run read-only git commands: `git log --oneline origin/main..HEAD`, `git status --short`, `git log -1 --format="%h %s (%cr)"`.

| Condition | Action |
|-----------|--------|
| Unpushed commits | REPORT: recommend `git push` |
| Uncommitted context/ or outputs/ files | REPORT: previous session may have crashed. Recommend /wrap-up |
| Last commit > 24h but Last-Wrap-Up recent | REPORT: wrap-up may not have committed |

## Step 5: Auto-fix

Safe to auto-fix without approval:
- **Future timestamps in session-state.md:** Replace with current time. Log the bad value.
- **Stale change-log:** Clear old entries, set today's date header. Old entries are in git history.
- **Empty change-log:** Add standard header and today's date.

Log each fix to `outputs/change-log.md` after ensuring it has today's date.

## Step 6: Output report

Compact report with sections: TIMESTAMPS (each with age and status), CONTEXT FILES (each with age), CRONS (registered vs expected, only if Last-Warm-Up < 2h), CHANGE-LOG status, GIT STATE (uncommitted files, unpushed count, last commit), AUTO-FIXED list, RECOMMENDED ACTIONS (numbered, specific commands).

## Rules

- NEVER modify context files. Only read headers. Use context-doctor for context fixes.
- NEVER modify session-state.md timestamps except to fix future-dated values.
- NEVER run git push, git commit, or any destructive git commands. Only read git state.
- NEVER modify promises.md. Use promise-tracker for that.
- This skill must be fast. No Notion queries, no Gmail scans, no full file reads. Headers, git commands, and CronList only.
- Log all auto-fixes to `outputs/change-log.md`.
- Output the report directly. Do not write it to a file.
