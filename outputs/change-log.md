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

### Layer 3 — System owns the clock (proactive loop)

Follows Layer 2A. Session C scope. Do not push.

Scope shipped: scaffolding + skill + producer wiring. Deferred: cron redesign (needs DM target), promises.md retirement (operational data).

**New files:**
- `outputs/pending-signals.md` — append-only queue with 3 sections: Pending, Deferred, Consumed. Signals formatted as `[EVENT: TYPE key=value ...] score=N ts=ISO`. Purged monthly by `/wrap-up`, history in git.
- `.claude/procedures/attention-budget.md` — scoring formula `urgency × type_weight × project_weight` with hard caps (Top 3 Decisions=3, Overdue=5, New Signals=5, Calendar=uncapped). Tie-break: earliest deadline, then alphabetical. Kaia drops to weight 0.3 (not 0) so urgent items still surface. Overflow → Deferred with `[EVENT: DEFER]`; 5 consecutive defers auto-escalates `type_weight` by +0.3.
- `.claude/skills/morning-brief/SKILL.md` — 6-step skill: pre-flight → gather (OI DB + pending-signals + calendar + optional Slack DMs) → score → compose 4-block brief → deliver → persist consumed/deferred + session-state timestamp. Same-day dedup via `--force`. Notion HALT policy; calendar and Slack MCP failures tolerated.

**Producer wiring:**
- `skills/risk-radar/SKILL.md` new Step 6b — for each CRITICAL/HIGH/MEDIUM risk, append `[EVENT: RISK supplier=X project=Y severity=Z risk_type=T]` to pending-signals.md. LOW stays report-only. Dedup by supplier+risk_type within 24h (in-place severity bump if higher). Risk-radar does not score — severity maps to `type_weight` in attention-budget.md.

**Delivery gating:**
- Default output: chat (no Slack write). Slack DM activates when `config/morning-brief-target.md` exists with `channel_id`. Until André approves target, `/morning-brief` runs on-demand and prints to chat.
- 07:30 cron deferred until DM target confirmed.
- Existing `/log-sent` cron (510d3725) unchanged — milestone writes remain auto-approved per `feedback_outreach_milestones_only`. Plan's "crons as observers" applies to new observer crons, not to the documented auto-write one.

**CLAUDE.md §4:** added `/morning-brief` to daily/weekly core list and a Proactive loop note pointing at pending-signals.md + attention-budget.md.

**Deferred from improvement-plan.md §2b EVALUATE (not this sprint):**
- #1 weekly-pulse vs morning-brief — plan keeps both (different cadence); no change needed.
- #2 project-dashboard — keep; no change needed.
- #3 promises.md retirement — deferred. Retiring now would regress active promises tracking; needs staged migration.
- #4 risk-radar as producer — ✅ landed (Step 6b).
- #5 /mail-scan cron re-route — deferred until morning-brief cron is wired.
