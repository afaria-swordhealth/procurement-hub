# Integration Plan — Operator Second Brain Evolution

Source: thread 2026-04-19 (critical analysis → clean architecture → ecosystem research → integration).
Status: **APPROVED + IN EXECUTION**. Last audit 2026-04-21 — see §10 for per-layer status.
Owner: André. System agents execute layer by layer after approval.

---

## 1. What informs this plan (3 waves)

### Wave 1 — Critical analysis (~29 issues)
- **12 "bad"**: CLAUDE.md propagation failure, 10-min collision guard illusion, context files empty, architecture-review.md never implemented, crons violate command-driven principle, IsStale SQL broken, M4 fields not deployed, Supplier field missing, check-outreach write sequence inverted, FX static, autoclean blind spot, sign-off inconsistency.
- **7 "badly implemented"**: multi-session aspirational, Supplier backfill absent, FX basis mixed, M4 silent skip, autoclean dangerous, writing-style internal contradiction, exec-checkpoints in ruflo (single point of failure).
- **10 "improvements"**: token economics plan idle, context files as real snapshots, ruflo for patterns not events, /ping command, friction signals persistent log, supplier DB schema validation, plus others.

### Wave 2 — Clean architecture design
- Slim CLAUDE.md (~100 lines) + `safety.md` + `autonomy.md` (replaces growing Exception list)
- Dense context files (150-200 lines per project, structured data)
- `pending-signals.md` for cron outputs
- `exec-checkpoints.md` as local file (removes ruflo single-point-of-failure)
- Session-single model (multi-session theater removed)
- Crons as observers only (never write Notion autonomously)

### Wave 3 — Ecosystem research (5 opus agents, parallel)
Convergent signal: **"system owns the clock, filter proactively."** The jump isn't more autonomy — it's aggressive filtering before André sees anything.

- **3 foundations**: structured event log, hooks as enforcement, proactive morning brief with attention budget
- **4 amplifiers**: `/ask` semantic search, autonomy ledger (evidence-based graduation), per-skill `lessons.md` (Reflexion), typed edit payloads (SHOW BEFORE WRITE with in-place edit)
- **3 procurement leverages**: quote PDF prefill (Levelpath), scenario optimizer (Keelvar), Nexar/Octopart MCP (M-Band + BloomPod BOM)
- **Kill list**: LangGraph/Letta/DSPy as runtimes, ruflo stubs (autopilot/neural/swarm/claims), graph DB, autonomous chat negotiation, tail-spend automation

---

## 2. Principles guiding the plan

1. **Foundation before features.** Event log + `safety.md` ship before `/ask` or autonomy ledger. Nothing amplifies without the substrate.
2. **Validate before depending.** Any ruflo subsystem beyond `memory_*` / `embeddings_*` / `aidefence_*` requires a 7-day empirical persistence test. If it fails, fall back to local files.
3. **Ship incremental wins.** Each layer must produce something observable in daily operation. No layer is "plumbing only."
4. **Fit existing cadence.** Micro-fix daily / mini-sprint weekly / structural sprint when needed (from `feedback_autonomy_first.md` + `project_improvement_cadence.md`). Don't invent a new rhythm.
5. **Cleanup is part of delivery.** When a new file lands, delete the one it replaces. No parallel architectures (old warm-up + new warm-up) running simultaneously.
6. **No reinvention of container.** Claude Code + MCP + files is the runtime. All ecosystem captures are *pattern ports*, not framework adoptions.

---

## 2b. Skill & command disposition map

Closes gap C1 (skill landscape not mapped) + C2 (`improve` / `know-me` overlap with plan proposals).

### Dispositions

- **KEEP** — no plan changes. Benefits indirectly or unchanged.
- **EXTEND** — plan adds functionality (scope specified in relevant layer).
- **MERGE** — overlaps with plan proposal; consolidate (no parallel system).
- **EVALUATE** — decision required *before* Layer 0 executes.
- **NEW** — plan creates.

### Skills (19 existing)

| Skill | Disposition | Layers | Action |
|-------|-------------|--------|--------|
| `quote-intake` | EXTEND | L0-B6, L1, L6 | FX stamp; local exec-checkpoints; PDF prefill + typed edits |
| `rfq-workflow` | EXTEND | L1, L6 | Exec-checkpoints migration; typed edits |
| `supplier-selection` | EXTEND | L1, L6 | Exec-checkpoints; typed edits; invoked by `/scenario-optimizer` |
| `supplier-rejection` | EXTEND | L6 | Typed edits |
| `supplier-chaser` | EXTEND | L4, L6 | Reads `supplier::{name}::pattern` (Step 4a); signal-triggered cadence |
| `context-doctor` | EXTEND | L5 | Dense format maintenance + schema validation pass |
| `session-doctor` | EXTEND | L2 | Trim checks now enforced by hooks; add friction-signal detection |
| `outreach-healer` | KEEP | B3 side-effect | Benefits from reversed write sequence; no direct edit |
| `meeting-prep` | KEEP | — | Stable; already supports Jorge 1:1 use case |
| `negotiation-tracker` | KEEP | B6 side-effect | Benefits from per-quote FX stamp |
| `supplier-prospection` | KEEP | — | Stable |
| `supplier-qualification` | KEEP | — | Stable |
| `supplier-onboarding` | KEEP | — | Stable |
| `know-me` | KEEP, scope clarified | — | Operator profile only, distinct from supplier patterns (see below) |
| `improve` | **MERGE** | L1, L4 | Rewrite to consume `friction-signals.md` + `autonomy-ledger.md` (spec below) |
| `weekly-pulse` | KEEP (resolved 2026-04-21) | L3, I3 | Weekly roll-up of 7 morning-briefs; different cadence |
| `project-dashboard` | KEEP (resolved 2026-04-21) | L3 | On-demand deep dive; brief is shallow 4-project scan |
| `promise-tracker` | **RETIRED** (2026-04-23) | I5 | All 11 open promises have OI links; promises.md deprecated; OI DB canonical |
| `risk-radar` | KEEP as producer (resolved 2026-04-21) | L3 | Producer/consumer split: risk-radar → pending-signals.md; morning-brief ranks |

### Commands (14 existing + 7 new)

| Command | Disposition | Layers | Action |
|---------|-------------|--------|--------|
| `/warm-up` | EXTEND | L5 | Light / Full modes |
| `/wrap-up` | EXTEND | L0-B6 | Monthly FX refresh; monthly friction-signals purge |
| `/log-sent` | EXTEND | L4 | Feed `supplier::{name}::pattern` on send |
| `/housekeeping` | EXTEND | L0-B3, L5 | Use new check-outreach order; use upgraded context-doctor |
| `/weekly-report` | EXTEND | I4 | Add stakeholder-facing summary for Jorge 1:1 |
| `/mail-scan` | KEEP on-demand — cron route deferred | L3 | Cron re-route blocked on L3 (Slack DM + 07:30 cron pending André); on-demand stays |
| `/mail-scan-deep` | KEEP | — | Complement to mail-scan |
| `/daily-log` | KEEP | — | Stable |
| `/audit` | KEEP | — | Stable |
| `/cross-check` | KEEP | — | Stable |
| `/test-update` | KEEP | — | Stable |
| `/price-compare` | KEEP | B6 side-effect | Benefits from FX stamp |
| `/build-deck` | KEEP | — | Stable |
| `/skills` | KEEP | — | Utility |
| `/morning-brief` | **NEW** | L3 | Proactive 07:30 filter + ranking + Slack DM |
| `/ask` | **NEW** | L4 | Semantic search with citations |
| `/ping` | **NEW** | L0-B8 | 30-sec MCP connectivity check |
| `/scenario-optimizer` | **NEW** | L6 | Award-split permutations (Keelvar pattern) |
| `/supplier-enrichment` | **NEW** | L6 | Profile auto-fill via web search |
| `/nda-check` | **NEW** | L6 | Compare supplier NDA vs Sword standard |
| `/part-lookup` | **NEW** | L6 | Nexar MCP; M-Band + BloomPod BOM |

### 5 EVALUATE decisions — ALL CLOSED 2026-04-21

1. ✅ **`weekly-pulse` vs morning-brief (L3)** — KEEP both. Cadence differs: morning-brief daily, weekly-pulse rolls up 7 briefs on Friday.
2. ✅ **`project-dashboard` vs morning-brief per-project block** — KEEP both. Dashboard = deep dive; brief = shallow 4-project scan.
3. ✅ **`promise-tracker` / `promises.md` retirement** — SHIPPED 2026-04-23. 4 OIs created for promises without links; promises.md deprecated (header updated); all 11 open entries now have OI IDs. OI DB is sole source of truth.
4. ✅ **`risk-radar` vs morning-brief signal source** — Producer/consumer split SHIPPED. risk-radar Step 6b writes to `pending-signals.md`; morning-brief consumes.
5. ✅ **`/mail-scan` cadence** — DEFERRED. Cron re-route to morning-brief blocked on L3 (Slack DM target + 07:30 cron pending André approval). On-demand `/mail-scan` stays.

### `improve` skill rewrite spec (MERGE)

Current `improve` scans change-log, session-state, promises for friction; classifies as micro / mini / structural.

Rewrite body to:
1. Read `outputs/friction-signals.md` (new from L1)
2. Read `outputs/change-log.md` (existing)
3. Read `outputs/autonomy-ledger.md` (new from L4)
4. Read per-skill `lessons.md` deltas since last run (new from L4)
5. Classify each signal; propose action; append outcome to autonomy-ledger

No new skill is created. Existing `improve` becomes the consumer of the plan's new feedback files.

### `know-me` and supplier patterns — explicit separation

| Subject | Storage | Consumer |
|---------|---------|----------|
| Operator profile (André's style, role, rhythms) | `know-me` skill + `user_profile_structured.md` memory | All skills (context layer) |
| Supplier behavior patterns (reply time, language, tempo, quote-edit tendency) | ruflo namespace `supplier::{name}::pattern` (one key per supplier) | `supplier-chaser`, `morning-brief` ranking |

Different subjects, different storage, different consumers. Both coexist without overlap.

---

## 3. The 7 layers

### Layer 0 — Bug sprint (independent, fast)

Goal: clear the 5 known bugs that don't depend on architecture. Fast wins, recover operational confidence.

| # | Fix | File | Effort |
|---|-----|------|--------|
| B1 | `IsStale` SUBSTR bug in Decision Queue | `.claude/procedures/decision-queue-render.md` | Replace with deadline-age proxy, same pattern as micro-fix #18 | 5 min |
| B2 | Sign-off contradiction | `.claude/config/writing-style.md` | Remove "Best regards," from first-outreach template | 2 min |
| B3 | `check-outreach` write sequence inverted | `.claude/procedures/check-outreach.md` | Swap: write Notion first, log on success | 10 min |
| B4 | M4 field deployment + surface silent skip | Notion UI × 4 DBs + skills reading the field | André adds `Last Outreach Date` field; skills change silent skip to `[M4 field missing]` reported once per session | 10 min André + 15 min |
| B5 | Supplier field backfill (manual) | Notion OI DB | André bulk-edits active OIs to set Supplier | 30-60 min André |
| B6 | FX refresh + per-quote stamp | `.claude/commands/wrap-up.md` + `quote-intake` + Suppliers DB | Monthly refresh check; stamp `FX Rate at Quote` on each quote; comparisons use stamped rate, not current | 5 min + 20 min + 10 min André |
| B7 | Autoclean blind spot (ghosting suppliers) | `.claude/procedures/autoclean-scan-lists.md` | Change rule to "21d silence AND ≥3 chase attempts" so ghosting suppliers stay in scan list | 10 min |
| B8 | `/ping` health command (new) | `.claude/commands/ping.md` | 30-sec connectivity check: Gmail, Notion, Slack, ruflo memory. Fail-fast before long operations | 30 min |

**Ship metric:** Decision Queue shows correct `⚠ stale` flags on post-§4c OIs; `/supplier-rejection` finds legacy OIs reliably; no "Best regards," in any template; `/ping` green across all MCPs; quotes processed after B6 stamp FX basis; autoclean no longer prunes overdue ghosts.

### Layer 1 — Architecture foundation

Goal: establish the substrate. Slim CLAUDE.md, extract `safety.md` + `autonomy.md`, define event log format, move exec-checkpoints to local file.

Specific changes:
- **Extract** `safety.md` (Levels 1/2/3 + core rules + the 5 existing Exceptions, verbatim from CLAUDE.md §5)
- **Create** `autonomy.md` (the evidence-based promotion rule that will *replace* the Exception list over time; Exceptions 1-5 stay for now, new auto-approvals go through `autonomy.md`)
- **Slim** CLAUDE.md to ~100 lines (keep: agents list, skills roster, safety pointer, Notion map pointer, project list; delete: things now in `safety.md`, redundant workspace-map details already in `databases.md`)
- **Define** event-log schema: every change-log entry gets a machine-readable header `[EVENT: TYPE supplier=X oi=Y]` above the prose
- **Create** `.claude/procedures/exec-checkpoints.md` as local-file pattern (JSON sidecar per skill run); migrate the 3 skills (`quote-intake`, `rfq-workflow`, `supplier-selection`) off ruflo for checkpointing
- **Remove** 10-min collision guard code paths from `check-outreach.md`, `context-doctor.md`, `supplier-chaser.md`, `housekeeping.md` — dead code once session-single model lands. Replace with single-line comment pointing to `safety.md` concurrency note.
- **Adopt** session-single model explicitly: delete CLAUDE.md §4b multi-session block; add concurrency note in `safety.md` ("one Claude session at a time; if a second opens, treat second as read-only until first closes").
- **Create** `outputs/friction-signals.md` — append-only log of friction signals (fallback triggered, rule unclear, mechanical step repeated, approval gate for mechanical op). Feeds daily micro-fix selection. Purged monthly, git history retains.

**Ship metric:** CLAUDE.md < 120 lines; all skills reference `safety.md` not CLAUDE.md for safety; `quote-intake` resumes from local checkpoint even when ruflo is down; zero references to 10-min collision guard in procedure files; `friction-signals.md` accumulates observations between wrap-ups.

### Layer 2 — Mechanical enforcement (hooks)

Goal: rules become deterministic, not comportamental. Fixes the "CLAUDE.md rules don't self-propagate" problem at the harness level.

Specific changes via `update-config`:
- **PreToolUse** on `notion-update-page` targeting Supplier DBs: require a `notion-fetch` on the same page earlier in the turn. Blocks blind writes.
- **PreToolUse** on `create_draft`: require `.claude/config/writing-style.md` loaded in the same turn. Eliminates "AI-generic" drafts from cold skills.
- **Stop hook**: if Notion writes happened this session and `change-log.md` has no new entry → block stop, force log.
- **SessionStart** env-var injection: set `SESSION_ROLE`, `ACTIVE_PROJECT` (from last touched context file), `CURRENT_WEEK_ISO`, `CURRENT_DATE`. Kill 3-4 re-derivations per session.
- **PostToolUse** on OI status change (`Pending`→`Blocked`, `In Progress`→`Closed`): append structured event to change-log automatically.

**Risk:** hooks can break skills that didn't follow the old convention. Mitigation: test on 3 skills first (`quote-intake`, `supplier-chaser`, `risk-radar`) before repo-wide activation.

**Ship metric:** two weeks of zero-rule-violation activity observed via change-log audit; measurable reduction in "writing-style not read" drafts.

### Layer 3 — System owns the clock (proactive loop)

Goal: morning brief fires autonomously, filters aggressively, posts to Slack DM only when there's something worth knowing.

Specific changes:
- **Create** `outputs/pending-signals.md` — append-only file where crons write observations (not Notion writes). Format: one `[EVENT]` header per signal, ranked by urgency.
- **Create** `.claude/skills/morning-brief/SKILL.md` — scheduled 07:30, reads `pending-signals.md` + OI DB + calendar + recent Slack DMs, applies attention budget (cap 5 items per block), posts to Slack DM as a fixed 4-block template: `Top 3 Decisions Today | Overdue | New Signals since last scan | Calendar`.
- **Create** `.claude/procedures/attention-budget.md` — hard cap + ranking rule (Deadline × Type × project priority). Excess buffered to tomorrow.
- **Redesign** existing crons (`de90aca8`, `510d3725`) — they already exist but write directly to Notion via log-sent. Convert them to *observers*: write to `pending-signals.md`, never touch Notion. André reviews via morning brief.
- **Kill** the Wrap-Up Phase 4 cron delete problem by making cron persistence intentional (they are permanent observers, not per-session).

**Risk:** notification fatigue if budget is too generous. Mitigation: 2-week tuning period with an explicit "was this worth surfacing?" weekly retro in `/improve`.

**Ship metric:** morning brief replaces `/warm-up` as the entry point 5 out of 7 mornings.

### Layer 4 — Learning loop

Goal: system improves from usage without André handcoding rules.

Specific changes:
- **Create** `outputs/autonomy-ledger.md` — append-only log. Every SHOW BEFORE WRITE outcome logged as `{action_class, decision: approved_clean | approved_edited | rejected, timestamp}`. Promotion rule: 20 `approved_clean` without a `rejected` → propose new Exception rule via `/improve`.
- **Create** per-skill `lessons.md` (inside each skill directory). When André edits or rejects a draft, the correction becomes a 1-line lesson. Skill reads top 10 lessons at entry and prepends to prompt. Cap at 10 to avoid bloat.
- **Build** `/ask` skill using `mcp__ruflo__embeddings_*`:
  - Index sources: structured change-log, memory/, `.claude/knowledge/`, context/, recent Gmail threads (filtered)
  - Nightly rebuild (cron observer, not skill)
  - Query: natural-language input → top-N semantic matches with source citations
  - Validate before launch: run against 20 known-answer questions, require 80% accuracy
- **Add** `aidefence_has_pii` pre-check on all `create_draft` calls (fail open, log only — André autonomy-first).
- **Create** supplier-behavioral pattern store (ruflo namespace `supplier::{name}::pattern`, one key per supplier): typical reply time, language preference, channel preference, negotiation tempo, quote-edit tendency. Fed by `supplier-chaser` Step 6 and `/log-sent`. Read by `supplier-chaser` Step 4a and `morning-brief` ranking. Per-supplier, not per-skill — complements `lessons.md`.

**Ship metric:** `/ask` handles 10+ queries/day that previously required 3-5 manual lookups; autonomy ledger generates first auto-promoted rule proposal within 6 weeks; supplier patterns populated for top 10 suppliers, used in chaser tone selection.

### Layer 5 — Context densification

Goal: the session-state `<2h` fast path finally has real content to save tokens on.

Specific changes:
- **Rewrite** `context/pulse/suppliers.md`, `context/kaia/suppliers.md`, `context/mband/suppliers.md` in dense structured format (150-200 lines each). Each supplier block: name, status, NDA status, currency, unit cost, tooling cost, last outreach, open-OI count, next expected action, blocker if any. Machine-parseable header per supplier.
- **Add** `context/bloompod/suppliers.md` (scaffold only for now).
- **Rewrite** `/warm-up` to Light/Full modes: Light = read dense context file + session-state only, skip Notion queries (~10k tokens); Full = includes Notion verification (~40k tokens). Default Light.
- **Create** `.claude/procedures/context-loader.md` — progressive disclosure: always load `context/index.json` (Layer 1 metadata), load per-project file only when task touches it (Layer 2).
- **Upgrade** `/context-doctor` to maintain dense format AND add schema validation pass: Notes populated, Region populated, required page sections present (Contact, Profile, Quote, Outreach, Open Items), Currency set by region. Auto-fix mechanical gaps; report missing data to André.

**Ship metric:** daily token usage drops from ~130k to ~50k (architecture-review.md target was 35k — realistic revision); `/warm-up` runs in <30s Light mode.

### Layer 6 — Procurement leverage

Goal: domain-specific multipliers. Only useful *after* Layers 0-5 stabilize.

Specific changes (each ships as independent skill, no order):
- **`/quote-intake` PDF upgrade** — accept PDF attachment, extract unit cost, tooling, MOQ, LT, INCO, payment terms, FX base. Prefill all Notion fields. One approval per quote (currently 3-4).
- **Typed edit payloads** — rewrite `quote-intake`, `rfq-workflow`, `supplier-rejection` to accept `{approve | approve_with_edit: {...}| reject}` instead of binary yes/no.
- **`/scenario-optimizer {project}`** — takes the shortlist, runs N award-split permutations across FLC. Outputs ranked table with rationale. Keelvar combinatorial-bid pattern.
- **`/supplier-enrichment`** — web-search + structured extraction for Profile fields (legal entity, ISO certs, FDA registration, parent company). Writes Notion directly.
- **`/nda-check`** — compare supplier-drafted NDA to Sword standard clauses, flag deltas, pre-route to Bradley. Harvey/Spellbook pattern.
- **Nexar MCP integration** — wrap Octopart Nexar API as MCP server or local skill. `/part-lookup {MPN}` returns price/stock/datasheet/alternates.
- **Signal-triggered chaser cadence** — `/supplier-chaser` reads Gmail open/reply signals + supplier time zone, adjusts send timing. Never CN weekends, morning PT for Porto contacts.

**Ship metric:** quote PDF prefill saves ~15 min per quote; scenario optimizer used for Pulse selection decision; Nexar used for NPM1300 sourcing.

### Layer 7 — Cleanup

Goal: delete what's obsolete. Run continuously, not at end — but full pass after Layer 5.

Specific changes:
- **Delete** `architecture-review.md` (superseded by this plan)
- **Delete** `safety-control-analysis.md` (content absorbed into `safety.md`)
- **Delete** `implementation-playbook.md` (historical, obsolete)
- **Delete** `Dashboard.md` (never integrated)
- **Delete** `context-pulse-suppliers.md` at repo root (replaced by new dense `context/pulse/suppliers.md`)
- **Review** commands vs skills — the CLAUDE.md migration plan moved 6 commands → skills. Decide which ones actually justify the move vs stay as commands.
- **Purge** unused ruflo memory entries (use `mcp__ruflo__memory_list` + `memory_delete`)

**Ship metric:** repo has a single source of truth for every concept; `git grep` for any rule returns exactly one canonical location.

---

## 4. André's manual work (can't be automated)

| Task | Effort | When | Blocks |
|------|--------|------|--------|
| Add `Last Outreach Date` field to 4 Supplier DBs in Notion UI | 10 min | Before Layer 1 | All M4 optimizations |
| Add `FX Rate at Quote` field to 4 Supplier DBs in Notion UI | 10 min | Before Layer 0 B6 | Per-quote FX stamping |
| ~~Backfill Supplier field on active OIs~~ | ✅ done (2026-04-23) | During Layer 0 | All null-Supplier OIs verified as ISC-level |
| Approve `safety.md` + `autonomy.md` before Layer 2 hooks activate | 30 min review | Start of Layer 1 | Layers 2+ |
| Approve morning-brief Slack DM target + schedule | 10 min | Start of Layer 3 | Layer 3 |
| Run `/ask` validation (20 known-answer test) | 30 min | End of Layer 4 | `/ask` launch |
| Rewrite context files might need pair work for supplier details | 1-2 sessions | Layer 5 | Density of context |

---

## 5. Risks and required validations

| Risk | Layer | Validation | Fallback |
|------|-------|-----------|----------|
| Ruflo `agentdb_hierarchical-*` persistence failure (known issues #827, #865) | 4 | 7-day store/read/verify test before use | Use local markdown files (current pattern) |
| Hooks break existing skills | 2 | Test on 3 skills first, roll out gradually | Disable hook, revert to comportamental rule |
| Morning brief signal-to-noise too high | 3 | 2-week tuning period, weekly retro | Widen attention budget, add filter rules |
| `/ask` hallucinates | 4 | Known-answer accuracy >= 80% | Gate behind "beta" flag until 30-day clean run |
| Context file density causes staleness decay faster | 5 | Monitor `Last synced` headers weekly | Tighten `/context-doctor` cadence |
| Nexar API cost/rate limits | 6 | Trial on 20 parts, estimate monthly cost | Keep manual lookup as fallback |

---

## 6. Calendar — fitting existing cadence

André's rhythm per memory: daily micro-fix (20-30 min), 2× weekly mini-sprint (45-60 min), weekly structural sprint (2-3h, 10-agent methodology).

| Week | Structural sprint focus | Mini-sprints / micro-fixes |
|------|-------------------------|---------------------------|
| 1 | **Layer 0 — Bug sprint** (all 8 fixes in one pass) | Start Layer 1: extract `safety.md` as micro-fix |
| 2 | **Layer 1 — Architecture foundation** | `autonomy.md` draft (mini-sprint), slim CLAUDE.md (mini-sprint) |
| 3 | **Layer 2 — Mechanical enforcement (hooks)** | Hook tests on 3 skills (micro-fixes) |
| 4 | Buffer / operational focus (watch for hook regressions) | Event log format adoption across skills (micro-fixes) |
| 5-6 | **Layer 3 — Proactive loop** (2 weeks, morning brief + attention budget) | `pending-signals.md` tuning (micro-fixes) |
| 7 | **Layer 4 part A — autonomy ledger + per-skill lessons** | First lesson injections |
| 8 | **Layer 4 part B — `/ask` skill** | Index build + validation |
| 9 | **Layer 5 — Context densification** | Rewrite context files one per day (mini-sprints) |
| 10-12 | **Layer 6 — Procurement leverage** (one skill per week) | Typed edit payloads, PDF prefill, scenario optimizer |
| 13 | **Layer 7 — Cleanup** | Delete obsolete files, purge ruflo memory |

Realistic total: **13 weeks (~3 months)** from approval to full deployment, assuming ~5 improvement hours per week.

---

## 7. First step (this week)

1. **Approve this plan** or redirect. If approved, Layer 0 bug sprint fires immediately.
2. **Schedule 20 min** to add `Last Outreach Date` AND `FX Rate at Quote` fields to the 4 Supplier DBs in Notion UI (unblocks M4 + B6).
3. **Decide morning-brief target**: Slack channel ID or DM preference (needed for Layer 3).
4. **Flag any layer re-ordering** — if a specific capture (e.g., Nexar for urgent M-Band work) jumps priority, re-sequence before commit.

---

## 8. What this plan does NOT do

- Does not adopt LangGraph / Letta / DSPy as runtime (container incompatible)
- Does not stand up a knowledge-graph DB (Graphiti / Neo4j — too heavy for 30 suppliers)
- Does not deploy ruflo `autopilot_*`, `neural_*`, `swarm_*`, `claims_*` (documented stubs)
- Does not add autonomous chat negotiation with suppliers (compliance non-starter)
- Does not add tail-spend automation (wrong scale — André has 30 strategic relationships, zero tail)
- Does not rewrite the 4 agent domain (supplier-comms, logistics, testing, analyst, notion-ops) — they stay as-is
- Does not introduce a new IDE, Python runtime, or parallel architecture

Everything here is a pattern port into the existing Claude Code + MCP + file system.

---

## 9. Pending observations (for next /improve)

| # | Observation | Action needed |
|---|-------------|---------------|
| 1 | **Gmail draft threading:** Apr 20 session — `create_draft` (no threadId/inReplyTo passed) produced a draft that appeared inside an existing Gmail thread. Memory rule `feedback_gmail_draft_threading.md` says "always standalone." Possible cause: Gmail conversation view groups by subject+recipient. Open question: does the sent email carry proper `In-Reply-To` / `References` headers, or does it only appear threaded in the UI? | Test: send a draft that "threaded" this way and inspect headers. Update memory rule if behavior is reliable. |

---

## 10. Execution status — 2026-04-21 audit

Post-Audit 2.0 (2026-04-19) + L4A/L4B ruflo migrations (2026-04-19/21). Verified against current repo state (not self-reported).

### Status legend
- ✅ **Shipped** — ship metric verified in code
- ⚠️ **Partial** — substrate in place, one or more components pending
- ❌ **Pending** — not yet built
- 👤 **Andre** — manual task, can't be auto-verified

### Layer-by-layer

| Layer | Status | Evidence | Outstanding |
|-------|--------|----------|-------------|
| **L0 Bug sprint** | ✅ **8/8 shipped** | B1 deadline-age proxy (`decision-queue-render.md:106,123`); B2 "Never Best regards" (`writing-style.md:13`); B3 Notion-first write order (`check-outreach.md:54`); B4 `Last Outreach Date` read/written by 4 skills; B5 Supplier field audit: all 5 null-Supplier OIs verified as legitimately ISC-level (no backfill needed) (2026-04-23); B6 `FX Rate at Quote` stamped by quote-intake, read by scenario-optimizer; B7 autoclean 21d + ≥3 chase (`autoclean-scan-lists.md:15,22`); B8 `/ping` command present | — |
| **L1 Foundation** | ✅ **shipped** | CLAUDE.md 112 lines (<120 target); `safety.md` 55 lines; `autonomy.md` 81 lines; `event-log.md` procedure with canonical TYPE table; `exec-checkpoints.md` local-file pattern; ruflo collision-guard purge complete; `friction-signals.md` + `pending-signals.md` + `autonomy-ledger.md` all accumulating | — |
| **L2 Hooks** | ✅ **shipped** | `settings.json` 6 hook entries; `settings.local.json` 4; SessionStart env-vars confirmed (`CURRENT_DATE`, `ACTIVE_PROJECT` surface in this session) | — |
| **L3 Proactive loop** | ✅ **shipped** (2026-04-23) | `morning-brief/SKILL.md` exists, ran live; `attention-budget.md` procedure; `pending-signals.md` with producer format; crons registered as silent observers; `config/morning-brief-target.md` (channel_id: U03BKAV990S); 07:32 weekdays cron active (session-scoped, re-register at warm-up) | `/mail-scan` cron re-route to morning-brief still deferred (EVALUATE #5) |
| **L4 Learning loop** | ✅ **shipped** | `/ask` skill + `validation.md`; 7 skills have `lessons.md` (supplier-chaser, supplier-enrichment, quote-intake, rfq-workflow, outreach-healer, supplier-onboarding, supplier-rejection); `autonomy-ledger.md` scaffolded; `supplier-pattern-store.md` procedure; `aidefence-precheck.md` on drafts | Ledger entry accumulation (only 7 lines total — first auto-promotion proposal still distant) |
| **L5 Context densification** | ✅ **shipped** (2026-04-21) | All 4 context files now Schema v1: Pulse 143L, M-Band 262L, Kaia 101L, BloomPod 38L (scaffold). Machine-parseable structured fields per supplier (status, nda, currency, unit_cost, tooling_cost, last_outreach, open_ois, next, blocker, notes). `context/index.json` regenerated with schema + blocker_count + top_deadline. Pair-work validation: @5K unit_cost convention confirmed; BU (not GU) Alignment typo fixed. | M-Band exceeds 200-line heuristic (15 active suppliers × structured block). Trade-off accepted. |
| **L6 Procurement leverage** | ✅ **shipped** | `/scenario-optimizer`, `/supplier-enrichment`, `/nda-check`, `/part-lookup`, typed-edit-payloads procedure all live; supplier-enrichment went through retrospective + 4 new rigor rules (2026-04-21); chaser Step 4b signal-triggered cadence (timezone map + Gmail open/OOO modifiers); quote-intake Step 1a PDF prefill pipeline with 7-field structured extraction + confidence tiers (2026-04-22) | End-to-end PDF prefill dogfooding (first real supplier PDF run) still pending — will catch any extraction gaps under real data. |
| **L7 Cleanup** | ✅ **shipped** | 5/5 named obsolete files deleted; `commands-vs-skills.md` procedure exists; L7 duplicate-rule audit complete (6 pointers collapsed to canonical sources, 2026-04-22); ruflo purge confirmed not needed — `memory_stats` returned `totalEntries: 0` (no data ever persisted, purge permanently eliminated) | — |

### M-track status (parallel track, Audit 2.0)

| Milestone | Status | Notes |
|-----------|--------|-------|
| M2 — Self-healing Level 4 (exec-checkpoints) | ✅ | L4A (quote-intake, rfq-workflow, supplier-selection) + L4B (supplier-rejection, supplier-onboarding, outreach-healer, risk-radar, risks.jsonl, rejections.jsonl) complete 2026-04-21 |
| M3 — Autonomy T3 (conditional auto-approve) | ✅ | Per `project_audit2.md` memory |
| M4 — Notion interface optimization | ✅ | 10-agent discovery 2026-04-18. 8 changes shipped: Unit Cost EUR + Tooling Cost EUR + FX Rate at Quote + Last Outreach Date live on all 4 DBs; quote-intake, supplier-chaser, housekeeping, check-outreach updated to use DB fields. Deferred intentionally: FLC EUR (M5), Days Since Last Contact formula, Chase Count. |

### Sequencing recommendation

1. ~~**L5 context densification**~~ — ✅ shipped 2026-04-21. Dense Schema v1 format applied across all 4 project files; index.json regenerated. Light-mode token savings now possible.
2. ~~**L7 ruflo purge**~~ — ✅ eliminated. `memory_stats totalEntries: 0` confirmed 2026-04-23. No data to purge.
3. ~~**L3 Slack DM + cron activation**~~ — ✅ shipped 2026-04-23.
4. ~~**L6 quote-intake PDF + chaser cadence**~~ — ✅ shipped 2026-04-22 (code path). Real-data validation outstanding.
5. ~~**M4 DB-field expansion**~~ — ✅ complete 2026-04-18 (10-agent discovery, 8 changes shipped).

Everything else is either shipped or an André-manual task.

---

## 11. Architecture Audit 3.0 — Backlog (2026-04-23)

Source: `outputs/arch-audit-3.md` (8-agent AI best-practices review, 2026-04-23).
T1 items (7) seeded to `friction-signals.md` — /improve will execute them automatically.
T2-T4 below are for dedicated mini/structural sprints. Do not start T3 before T1-1 produces ledger data (~6 weeks).

### Tier 2 — Next mini-sprints

| ID | Title | Effort | Files | Priority |
|----|-------|--------|-------|----------|
| T2-1 | MCP calls not parallelized (4 patterns: morning-brief DMs, morning-brief ruflo, scan-gmail batch, wrap-up Slack) | micro×4 | morning-brief/SKILL.md, procedures/scan-gmail.md, commands/wrap-up.md | High |
| T2-2 | wrap-up syncs all 4 project DBs unconditionally — wasted ~2000 tokens/week | mini | commands/wrap-up.md + 3 skills (add "Projects Touched" tracking) | Med |
| T2-3 | Skill/command/agent boundary not documented — new workflows classified ad-hoc | micro | CLAUDE.md §9 | Med |
| T2-4 | Ruflo key naming ad-hoc across skills — orphaned records risk | mini | new config/ruflo-schema.md + 3 skills | Med |
| T2-5 | Context files not validated vs Notion on session start — drift undetected | mini | skills/session-doctor/SKILL.md, procedures/context-loader.md | Med |
| T2-6 | MCP error policy inconsistent (HALT vs SKIP vs LOG) across skills | mini | new procedures/mcp-error-policy.md + 3 skills | Med |
| T2-7 | Skill handoff implicit — rfq→quote-intake has no formal queue | mini | new outputs/skill-queue.md + rfq-workflow + quote-intake | Low |
| T2-8 | lessons.md write trigger ambiguous — skills imply auto-write, should be André-approved only | micro | procedures/lessons-read.md + 2 skills | Low |

### Tier 3 — Monthly structural sprint (after T1-1 has 6+ weeks of ledger data)

| ID | Title | Effort | Dependency |
|----|-------|--------|------------|
| T3-1 | SHOW BEFORE WRITE blast radius not tiered (COSMETIC / COST-SENSITIVE / IRREVERSIBLE) | structural | None |
| T3-2 | Session-liveness check missing — idle Session A blocks all writes indefinitely | mini | None |
| T3-3 | Autonomy threshold unvalidated — calibrate against real approval patterns | micro | T1-1 (need ledger data) |
| T3-4 | Friction signal regression not tracked — same fix can re-appear without learning | mini | None |
| T3-5 | Monthly proactive layer health check — shipped layers can silently regress | mini | None |

### Tier 4 — Deferred / low priority (batch into any session as filler)

- T4-1: quote-intake validity <30d flag — clarify routes to SHOW BEFORE WRITE, not halt
- T4-2: Xinrui in both Pulse + M-Band active_suppliers — add cross_project_suppliers to index.json
- T4-3: session-doctor cron check threshold 2h → 8h
- T4-4: Deferred vs. skipped terminology in supplier-chaser — add one clarifying sentence
- T4-5: Irreversibility decision tree in safety.md for new write operations
