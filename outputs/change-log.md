# Change Log
# Rolling daily file. Keeps only today's entries.
# History lives in git log. On wrap-up, this file is committed then cleared for tomorrow.

## 2026-04-20

### session-doctor auto-fix
- change-log date header cleared: 2026-04-19 → 2026-04-20 (L1 entries preserved in commit `45809bf`)

### Layer 2A — Mechanical Enforcement (non-blocking hooks)

Follows Layer 1 (commit `45809bf`, unpushed). Session C scope: system files only. Do not push.

Phase split: Phase A (non-blocking, shipped now) vs Phase B (blocking PreToolUse, deferred 1–2 weeks for observation). User approved "A only; B after".

**New directory `.claude/hooks/` with 4 scripts:**

- `session-start-env.sh` (SessionStart) — emits `additionalContext` with `CURRENT_DATE`, `CURRENT_WEEK_ISO`, `ACTIVE_PROJECT` (derived from most-recently-modified `context/*/suppliers.md`). Kills 3–4 re-derivations per session. Uses `printf` only — no jq dependency.
- `post-notion-write-flag.sh` (PostToolUse: notion-update-page, notion-create-pages, notion-update-data-source) — touches `/tmp/claude-notion-write.flag` so Stop hook can detect unlogged writes.
- `stop-changelog-guard.sh` (Stop) — advisory: if Notion write flag exists but `outputs/change-log.md` is older than the flag, emit reminder via `additionalContext`. Non-blocking.
- `post-oi-status-event.sh` (PostToolUse: notion-update-page) — when payload contains `Status` select change, appends `[EVENT: STATUS_CHANGE page=<short_id> status=<name> ts=<YYYY-MM-DDTHH:MM>]` under `### Hook events` in change-log. Uses `python -c` for stdin JSON parsing (python3 confirmed on PATH; jq is not).
- `README.md` — documents Phase A shipped table + Phase B deferred table. Phase B activation checklist: 5-session report-only mode → 3-skill validation (quote-intake, supplier-chaser, risk-radar) → flip to `decision:"block"` → commit as L2B.

**Wired in `.claude/settings.json`** (new file, committed). `.claude/settings.local.json` remains gitignored; Claude Code merges both at runtime.

**Fail-open semantics:** every script uses `set +e` / exits 0 on any parse or I/O failure. Harness bugs cannot brick operational skills.

**Finding during smoke test:** `jq` not on PATH in this environment. Existing `.claude/settings.local.json` UserPromptSubmit hook uses `jq -r '.prompt // ""'` and has been silently broken (suffix `; exit 0` masks failure). Not fixed in this sprint — out of scope for L2A. Flagged for user awareness.

**Smoke tests passed:**
- SessionStart emitted `{"hookSpecificOutput":{"hookEventName":"SessionStart","additionalContext":"Session env: CURRENT_DATE=2026-04-20 CURRENT_WEEK_ISO=2026-W17 ACTIVE_PROJECT=kaia"}}`
- post-oi-status-event correctly parsed a `notion-update-page` payload with Status select and appended one `[EVENT: STATUS_CHANGE …]` line to change-log.md (test residue cleaned before commit).

**Phase B deferred** — PreToolUse guards documented but not activated:
- `pre-notion-update-fetch-guard.sh` — block writes to Supplier DBs without a prior `notion-fetch` on the same page in the same turn.
- `pre-create-draft-style-guard.sh` — block `create_draft` unless `config/writing-style.md` was Read in the same turn.

Both need transcript-parsing which is fragile; a false positive could prevent a legitimate reply. Gated behind 1–2 week Phase A observation window per improvement-plan.md Layer 2 ship metric.
