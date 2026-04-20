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

### Layer 4A — Learning loop (autonomy ledger + per-skill lessons)

Follows Layer 3. Session C scope. Do not push.

L4 split into A (ledger + lessons, this sprint) and B (`/ask` skill + supplier pattern store + aidefence PII check, next sprint). L4B deferred because it requires embedding index build + 20-question validation harness.

**New files:**
- `outputs/autonomy-ledger.md` — append-only scaffold. Schema `{ISO_ts} | {action_class} | {decision} | {skill} | {notes}`. Rules live in `.claude/autonomy.md` (shipped L1). Consumer: `/improve` Source F.
- `.claude/procedures/ledger-append.md` — write-side procedure. Defines when to append (SHOW BEFORE WRITE outcomes only), schema, canonical `action_class` table (15 values including 4 `never_promote` classes), implementation note (atomic single append, session-single concurrency). Append-on-error policy: log `[EVENT: FAIL target=autonomy_ledger]` and continue — ledger append never fails parent operation.
- `.claude/procedures/lessons-read.md` — read-side procedure. Per-skill `.claude/skills/{skill}/lessons.md` scaffold (top 10 lines, newest first). Applied in pre-flight before default behavior. Lessons vs memory: memory = cross-skill/durable, lessons = per-skill delta. Monthly retention drops >180d-old unless reinforced.
- `.claude/skills/{quote-intake,rfq-workflow,supplier-chaser,supplier-rejection,supplier-onboarding,outreach-healer}/lessons.md` — 6 empty scaffolds, one per write-heavy skill.

**Wiring — 6 skills, pre-flight `Lessons read` step:**
- `quote-intake` step 10, `rfq-workflow` step 11, `supplier-chaser` step 6, `supplier-rejection` step 6, `supplier-onboarding` step 9, `outreach-healer` step 5.
- Each reads `.claude/skills/{skill}/lessons.md` (top 10) via `lessons-read.md` procedure. Missing/empty → skip.

**Wiring — 3 skills, Rules section ledger-append:**
- `quote-intake` — `cost_field_within_30pct` / `cost_field_outside_30pct` (latter never_promote) / `fx_stamp_write`.
- `supplier-rejection` — `supplier_status_rejected` (never_promote), `nda_status_write` (never_promote), `oi_status_closed`, `email_draft_send` (never_promote).
- `rfq-workflow` — `email_draft_send` (never_promote), `oi_create_action`, `oi_create_decision`.

**`/improve` skill:**
- Pre-flight line 5 added: read autonomy-ledger.md.
- Step 1 Source F added: promotion-candidate detection per autonomy.md rule (20 clean + 0 rejected/50 + 0 edited/20 + not never_promote). Also surfaces classes hitting threshold 3+ times with rejections for `never_promote` tagging.

**Note on ruflo checkpoints:** `supplier-rejection`, `supplier-onboarding`, `outreach-healer` still use `mcp__ruflo__memory_retrieve` for exec checkpoints — L1 migrated only `quote-intake`, `rfq-workflow`, `supplier-selection`. Migrating the remaining 3 to local checkpoints is a follow-on micro-fix, not blocking L4.

**Deferred to L4B:**
- `/ask` skill (embeddings index build + 20-question validation).
- Supplier behavioral pattern store (ruflo namespace `supplier::{name}::pattern`).
- `aidefence_has_pii` pre-check on `create_draft` calls (fail-open, log-only).
- `/wrap-up` Phase 5 ledger delta summary.

### Layer 4B — Learning loop (ask skill + pattern store + PII pre-check + wrap-up delta)

Follows Layer 4A. Session C scope. Do not push.

All four L4B deliverables landed in one commit. Launch gates and operator actions documented; nothing auto-activates until André approves.

**New files:**
- `.claude/skills/ask/SKILL.md` — read-only Q&A over corpus via `mcp__ruflo__embeddings_search`. Answer rules: 1–5 sentences, every claim cited as `{path}:{line}`, never fabricate citations, conflicting-source handling. Logs `[EVENT: ASK query=… top_score=…]` (no answer body). Hard CRITICAL STOP at launch gate: skill refuses to run until validation harness shows ≥18/20 PASS.
- `.claude/procedures/ask-index.md` — index build procedure. Corpus: CLAUDE.md + configs + procedures + skills + agents + knowledge + context + promises + ledger + 60d git history of change-log. Excluded: hooks, transient state (session-state, pending-signals, friction-signals), binaries. Chunking 800 tok max / 50 tok min. Nightly rebuild cron documented (not yet registered — pending André). Incremental rebuild on wrap-up. State file `ask-index.state.md` tracks `Last rebuilt`.
- `.claude/skills/ask/validation.md` — 20-question harness template. Questions authored; **expected answers + expected sources columns left blank** — André authors before launch. Re-validation trigger on full index rebuild. Pass/fail log appended to file. Clear operator process documented.
- `.claude/procedures/supplier-pattern-store.md` — ruflo namespace `supplier::{slug}::pattern`, upsert-always. Schema: 11 fields (channel_pref, language, avg_response_days, response_rate_90d, last_chase_tier_that_worked/failed, chase_count_90d, response_count_90d, known_patterns, risk_flags). Producers: supplier-chaser Step 6, /log-sent Phase 5 (inbound response observer), /wrap-up Phase 4c (daily rollup self-heal). Consumers: supplier-chaser Step 4a (tone tier escalation), morning-brief Step 2a (×1.3 urgency multiplier), /ask (indirect — not indexed). Retention: no TTL, rolling 90d counters. On supplier rejection → risk_flags=["rejected"], record preserved.
- `.claude/procedures/aidefence-precheck.md` — fail-open PII pre-check procedure. Decision tree with 4 false-positive carve-outs (supplier phone, recipient domain email, etc.). STOP on novel PII type (NIF, credit card, passport, non-config street). `[EVENT: PII_CHECK result=… skill=…]` log line. Scope: Gmail drafts only — not Notion, not attachments, not link content.

**Wirings — 4 skills:**
- `supplier-chaser` Step 4a rewritten to formally consume pattern store (prior ad-hoc `memory_search` replaced). Step 6a new PII pre-check block before any draft ([AUTO] or reviewed). Step 6.7 new pattern-write producer (chase-side fields). Steps renumbered; no other behavior change.
- `rfq-workflow` §Before creating draft: PII pre-check inserted as step 3 between SHOW BEFORE WRITE and checkpoint store. Subsequent steps renumbered.
- `supplier-rejection` Step 7 (Execute): PII pre-check inserted as step 1 before Gmail draft creation. Subsequent numbered steps renumbered.
- `/log-sent` Phase 5 amended with supplier pattern observer write on inbound-response milestones (response-side fields; rolling 90d counters with self-reset on >90d stale).
- `/wrap-up` new Phase 4c supplier pattern rollup (self-heal `response_rate_90d` from chase log) + Phase 4d autonomy ledger delta (counts since last wrap-up, streak detection, promotion-approaching + demotion-candidate flags). Phase 5 summary now includes ledger delta + patterns-touched count.
- `morning-brief` Step 2a new pattern-based urgency multiplier (×1.3 on unresponsive-supplier + stale-chase-with-risk). Capped at attention-budget cap.

**Intentionally NOT activated in this sprint (gated on André actions):**
- `/ask` launch — blocked by CRITICAL STOP in validation.md until André fills the 20 answer+source columns and marks ≥18 PASS.
- Nightly embeddings rebuild cron — documented in `ask-index.md` §Rebuild schedule but not registered via `schedule` skill. Waiting for André to approve the cron schedule.
- Slack DM target for morning-brief 07:30 cron — still gated (L3 leftover, unchanged).
- promises.md retirement — still deferred (L3 decision unchanged).

**Fail-open semantics preserved throughout:**
- Ruflo MCP failures (pattern store, embeddings, aidefence) log `[EVENT: FAIL target=…]` and proceed with default behavior.
- AIDefence PII check is fail-open by design — a missing check never blocks a draft.
- Ledger append failures (L4A) already fail-open; ledger delta in /wrap-up continues even if append misses.

**Not shipped, not planned:**
- `/ask-rebuild` slash command — `ask-index.md` procedure is invokable directly; a thin command wrapper can be added later if the rebuild cadence proves manual-intensive.
- Pattern store schema versioning — readers are defensive on missing keys; no migration layer until second schema change.

### Layer 5 — Context densification (tooling only; file rewrites deferred as pair-work gate)

Follows Layer 4B. Session C scope. Do not push.

Plan §4 explicitly flags "Rewrite context files might need pair work for supplier details — 1-2 sessions" — so context file content rewrites are held back to avoid destructive automation of live operational data. All L5 *tooling* lands now; the actual pulse/kaia/mband file rewrites are gated on André pair work.

**New files:**
- `.claude/procedures/context-loader.md` — progressive disclosure spec. 3 layers: (1) `context/index.json` always loaded; (2) per-project `context/{project}/suppliers.md` loaded on demand based on message content + skill scope; (3) deep corpus opt-in only (via `/ask`). Defines v1 dense schema per supplier: structured bullet header (`status`, `nda`, `currency`, `unit_cost`, `tooling_cost`, `last_outreach`, `open_ois`, `next`, `blocker`) plus free-form `notes:` block preserving existing prose. Readers fall back to free-form for v0 (no Schema header) files.
- `context/bloompod/suppliers.md` — scaffold only. BloomPod in pre-sourcing (Pedro BOM due 2026-04-24). No active suppliers yet; shortlist research names listed; v1 schema header present so future fills integrate cleanly.

**Wirings:**
- `/warm-up` modes rewritten: Light (default, reads `context/index.json` + per-project on demand per context-loader Layer 1/2, ~10k tokens, <30s target), Full (`--full`, reads all 4 files + Notion verification, ~40k tokens), Quick (deprecated alias → Light). Auto-promotes to Full on missing session-state, Last-Warm-Up > 8h, or missing index.
- `/warm-up` Phase 1 amended: Light reads index only; Full reads all 4 context files. Staleness warning now triggers on index >24h, not just per-file.
- `/wrap-up` Phase 2a new: regenerate `context/index.json` atomically from updated context files after Phase 2 sync. Parses section headers + (for v1 schema files) structured fields to compute active/rejected counts, active_suppliers list, blocker_count, top_deadline. Fail-open: missing index triggers Full warm-up next session.
- `context-doctor` Step 3b new: v1 schema validation block. Validates required structured fields, enum values, numeric fields (unit_cost/tooling_cost), last_outreach sync with DB, open_ois count against OI DB, stale blocker auto-null. v0 files skipped silently — migration is pair work.

**Deferred pair-work gate (explicitly not this sprint):**
- `context/pulse/suppliers.md`, `context/kaia/suppliers.md`, `context/mband/suppliers.md` rewrites from prose to v1 dense schema — **requires André pair work**. Plan §4 labels this 1-2 sessions. Autonomous rewrite risks silent data loss (prose entries contain audit-history detail not fully reconstructable from Notion). Files remain v0 format; context-doctor skips Step 3b on them.
- First `context/index.json` generation — happens on next `/wrap-up` Full run once files are migrated OR on any `/wrap-up` now (v0 files generate a degraded index without blocker/top_deadline fields; usable as warm-up fallback).

**Not shipped in L5 (nothing extra planned beyond pair-work gate).**
