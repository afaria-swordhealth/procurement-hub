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
| Last-Mail-Scan > 4h | Emails may be stale, suggest /mail-scan | REPORT |
| Last-Log-Sent > 24h | Outreach may not be logged, suggest /log-sent | REPORT |
| Last-Wrap-Up > 24h | Context files likely stale, suggest /wrap-up | REPORT |
| Any timestamp in the future | Clock error or bad write | AUTO-FIX |
| Any timestamp missing | Incomplete session-state | REPORT |

## Step 2: Check context file freshness

For each project, read the first 3 lines of the context file to get the "Last synced" header:
- `context/pulse/suppliers.md`
- `context/kaia/suppliers.md`
- `context/mband/suppliers.md`

| Condition | Action |
|-----------|--------|
| "Last synced" > 48h | REPORT: stale context, recommend /wrap-up or context-doctor |
| "Last synced" missing | REPORT: no freshness header, recommend adding one |
| "Last synced" in the future | AUTO-FIX: set to current timestamp |
| File missing entirely | REPORT: critical, context file does not exist |

Do NOT read full context files here. Only the header. This skill must stay lightweight.

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

Compact report with sections: TIMESTAMPS (each with age and status), CONTEXT FILES (each with age), CHANGE-LOG status, GIT STATE (uncommitted files, unpushed count, last commit), AUTO-FIXED list, RECOMMENDED ACTIONS (numbered, specific commands).

## Rules

- NEVER modify context files. Only read headers. Use context-doctor for context fixes.
- NEVER modify session-state.md timestamps except to fix future-dated values.
- NEVER run git push, git commit, or any destructive git commands. Only read git state.
- NEVER modify promises.md. Use promise-tracker for that.
- This skill must be fast. No Notion queries, no Gmail scans, no full file reads. Headers and git commands only.
- Log all auto-fixes to `outputs/change-log.md`.
- Output the report directly. Do not write it to a file.
