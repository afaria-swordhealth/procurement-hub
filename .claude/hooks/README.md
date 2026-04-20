# .claude/hooks/

Shell hooks wired into `.claude/settings.json`. See the Claude Code hooks docs for event semantics.

## Phase A — shipped (non-blocking)

| Script | Event | Purpose | Blocking |
|---|---|---|---|
| `session-start-env.sh` | SessionStart | Inject `CURRENT_DATE`, `CURRENT_WEEK_ISO`, `ACTIVE_PROJECT` as additionalContext. Kills 3-4 re-derivations per session. | No |
| `post-notion-write-flag.sh` | PostToolUse (Notion writes) | Touch `/tmp/claude-notion-write.flag` so the Stop hook can detect an unlogged write. | No |
| `stop-changelog-guard.sh` | Stop | Advisory: if a Notion write happened but `change-log.md` was not updated, emit a reminder. | No |
| `post-oi-status-event.sh` | PostToolUse (`notion-update-page`) | When the update payload sets a `Status` select, append a `[EVENT: STATUS_CHANGE ...]` line to `change-log.md`. Feeds the event-log schema. | No |

All Phase A scripts fail open. Any error inside a hook exits 0 so normal operation is never blocked by a harness bug.

## Phase B — deferred (blocking, needs test-on-3-skills)

Per the improvement plan Layer 2 ship metric, these hooks need a 1–2 week observation window before activation. Test targets: `quote-intake`, `supplier-chaser`, `risk-radar`.

| Script | Event | Purpose | Risk |
|---|---|---|---|
| _pre-notion-update-fetch-guard.sh_ | PreToolUse (`notion-update-page` on Supplier DBs) | Block writes that don't have a prior `notion-fetch` on the same page earlier in the turn. | Blocks blind writes. Transcript-parsing failure could brick an operational skill. |
| _pre-create-draft-style-guard.sh_ | PreToolUse (`create_draft`) | Block drafts unless `config/writing-style.md` was Read in the same turn. | Blocks "cold" drafts. False-negative could prevent a legitimate reply. |

Activation checklist before Phase B lands:
1. Run each guard in **report-only** mode for 5 sessions (emit advisory, no block).
2. Verify no false positives against the 3 test skills.
3. Review the collected advisory output. If clean, flip to `decision: "block"` and commit as `L2B`.

## Merge behavior with `settings.local.json`

`.claude/settings.local.json` is gitignored and holds André's personal hooks (session-doctor mandate, mail-scan → log-sent chain). Claude Code merges both files at runtime; multiple hooks at the same event all fire. The Phase A hooks here are additive — they do not replace the local hooks.

## Cross-platform note

These scripts assume bash + jq on PATH (Git Bash on Windows, any POSIX elsewhere). `$CLAUDE_PROJECT_DIR` is injected by Claude Code. The `/tmp` flag path works on Windows Git Bash (maps to `%TEMP%`).
