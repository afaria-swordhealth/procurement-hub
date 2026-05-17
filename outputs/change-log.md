# Change Log
# Rolling daily file. Keeps only today's entries.
# History lives in git log. On wrap-up, this file is committed then cleared for tomorrow.

## 2026-05-17

- [session-doctor AUTO-FIX] Added today's date header (file had no date section — stale entries cleared by wrap-up 2026-05-15).
- [improve micro-fix #1] session-doctor SKILL.md Step 2: added context/phonestand/suppliers.md to file list. Phone Stand project (9 active suppliers) was added 2026-05-06 but session-doctor hardcoded only pulse/kaia/mband — the project's context file was never checked for staleness or COUNT_MISMATCH.
- [improve signal #2 → pending] config/fx-rates.md stale 33d: could not execute — all ECB/financial fetch endpoints returned 403 in managed environment. Signal queued in friction-signals.md Pending for André manual refresh.
