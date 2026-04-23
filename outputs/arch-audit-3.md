# Architecture Audit 3.0 — AI Best Practices Review
# Date: 2026-04-23 | 8 agents × 5 lenses | Output: improvement plan for future session
# DO NOT implement from this file — each item requires a dedicated /improve session

---

## Executive Summary

8 specialist agents reviewed the system across orchestration, prompt engineering, context economics,
memory architecture, safety/autonomy, failure recovery, learning loop, and MCP integration.

**Overall verdict:** The architecture is structurally sound for its scale. The core patterns
(skills/commands/agents, SHOW BEFORE WRITE, session-single, context-loader layers) are well-designed.
The critical gap is that several feedback mechanisms exist on paper but have zero operational data —
especially the autonomy ledger, lessons.md, and exec-checkpoint resume paths. MCP batching is a
secondary opportunity for latency reduction.

**3 findings flagged independently by 2+ agents (highest confidence):**
1. Autonomy ledger empty — no decisions logged since inception (A4 + A5 + A7)
2. Session-state timestamps record start, not completion — false freshness on crash (A3 + A4 + A6)
3. Exec-checkpoint resume path undefined — `in-progress` detection exists, recovery does not (A4 + A6)

---

## Improvement Queue

Sorted by: severity × confidence × effort. Items marked with * were flagged by 2+ agents.

---

### TIER 1 — Fix before next structural sprint (micro/mini, high confidence)

**[T1-1] * Autonomy ledger disconnected from SHOW BEFORE WRITE gates**
Agents: A4, A5, A7 (all HIGH)
Finding: `outputs/autonomy-ledger.md` has zero entries since inception (2026-04-18). `ledger-append.md`
procedure exists and is detailed, but no skill is calling it after SHOW BEFORE WRITE outcomes.
The evidence-based autonomy promotion rule (20 clean + 0 rejected) cannot fire without ledger data.
Root cause: no skill has a `ledger-append` step wired into its approval gate.
Impact: autonomy promotion is permanently blocked; safety.md Exceptions are frozen at their initial
grandfathered set; the system cannot learn from approved/rejected decisions.
Fix: Audit 3 skills with high SHOW BEFORE WRITE frequency (quote-intake, supplier-chaser, rfq-workflow).
Add a ledger-append step immediately after each approval gate outcome. Verify entries appear after
next operational session.
Effort: micro × 3 files | Files: quote-intake/SKILL.md, supplier-chaser/SKILL.md, rfq-workflow/SKILL.md,
procedures/ledger-append.md

---

**[T1-2] * Session-state timestamps written at phase start, not completion**
Agents: A3, A4, A6 (HIGH / MED / MED)
Finding: `Last-Warm-Up`, `Last-Mail-Scan` timestamps are set when the operation begins, not when it
completes. A session crash at minute 3 of warm-up leaves a fresh-looking timestamp. Next session
trusts it, skips delta scan, and operates on stale context.
Fix: Move timestamp writes to AFTER phase completion in warm-up Phase 10, mail-scan Step 7, log-sent
final step. Add a `status: completed|started` field per timestamp so crashes are distinguishable.
Effort: micro × 3 files | Files: commands/warm-up.md, skills/mail-scan (if SKILL exists), commands/log-sent.md

---

**[T1-3] * Exec-checkpoint resume path undefined — detection without recovery**
Agents: A4, A6 (HIGH / MED)
Finding: When `status: "in-progress"` checkpoint is found, skills surface it to André and ask
"resume or fresh start?" — but skills have NO resume entry point. Choosing resume requires André
to manually track which steps to skip. For quote-intake (8 steps), rfq-workflow (5+ steps), this
is error-prone.
Fix: Add a `## Step Resumption` section to each critical skill (quote-intake, rfq-workflow,
supplier-selection) mapping `steps_done` arrays to specific entry points. Example:
`if steps_done contains db_fields + quote_section → start from Step 5 (compare quotes)`.
Effort: mini | Files: quote-intake/SKILL.md, rfq-workflow/SKILL.md, supplier-selection/SKILL.md,
procedures/exec-checkpoints.md

---

**[T1-4] supplier-chaser Step 6 still writes to deprecated promises.md**
Agents: A4 (HIGH)
Finding: promises.md was deprecated 2026-04-23 with header "do not add new entries here." But
supplier-chaser SKILL.md Step 6 still appends `- [ ] {Supplier}...` to promises.md. Every
supplier-chaser run creates ghost entries in a deprecated file. /promise-tracker will see these
as orphaned promises on next run.
Fix: Update supplier-chaser Step 6 to write OI Type=Commitment directly to OI DB instead of
promises.md. Remove promises.md write instruction.
Effort: micro | Files: skills/supplier-chaser/SKILL.md (Step 6)

---

**[T1-5] Auto-write 30% delta formula undefined — inconsistent across sessions**
Agents: A2 (HIGH)
Finding: quote-intake auto-write condition "within 30% of prior quote" does not specify the formula.
Is it `(new - prev) / prev` or `(new - prev) / new`? Is it symmetric (±30%) or one-directional?
Different sessions will compute it differently.
Fix: Add formula to quote-intake SKILL.md Step 4 auto-write condition:
"within 30% means: `abs((new_unit_eur - prior_unit_eur) / prior_unit_eur) <= 0.30`."
Effort: micro | Files: skills/quote-intake/SKILL.md (line ~112)

---

**[T1-6] context/index.json missing blocker_count and top_deadline fields**
Agents: A3 (HIGH)
Finding: context-loader Layer 1 resolution logic (lines 46-50) expects `blocker_count` and
`top_deadline` in index.json to prioritize which project context to load. But wrap-up Phase 2a
does not write these fields — the index only has `supplier_count_active`, `supplier_count_rejected`,
`active_suppliers`. The Layer 1 fast path falls back to Layer 2 for every decision.
Fix: Update wrap-up Phase 2a to compute and write `blocker_count` (OIs with Status=Blocked per
project) and `top_deadline` (earliest OI deadline per project) to context/index.json.
Effort: micro | Files: commands/wrap-up.md (Phase 2a), context/index.json (schema update)

---

**[T1-7] Exception 5 "clearly shows" is subjective — inconsistent OI Status auto-transitions**
Agents: A5 (MED)
Finding: safety.md Exception 5 auto-approves OI Status → In Progress when email/Slack "clearly shows
blocking condition resolved." The phrase "clearly shows" is interpretive, not mechanical. Two Claude
sessions reading the same supplier email may make different Status transition decisions.
Fix: Replace "clearly shows" with a checklist: "In Progress auto-approval requires ONE of:
(1) supplier/name + 'started'/'processing'/'working on it';
(2) internal + 'unblocked'/'resolved'/'fixed';
(3) timestamp + assignee + actionable task."
Effort: micro | Files: .claude/safety.md (Exception 5)

---

### TIER 2 — Address in next mini-sprint (structural or multi-file)

**[T2-1] MCP calls not parallelized — Slack, ruflo, Notion scans run serially**
Agent: A8 (HIGH × 2, MED × 4)
Finding: Multiple serial call patterns identified:
- morning-brief Step 1d: 5 separate Slack DM reads (Jorge, Miguel, Sofia, Pedro, Kevin) → should be
  parallel or single bulk search
- morning-brief Step 2a: N ruflo `memory_retrieve` calls (one per supplier candidate) → should
  collect all slugs first, then fetch in parallel
- scan-gmail.md deep mode: 15 Notion queries for 15 emails → should be one batch query
  `WHERE Name IN (sender1, sender2...)`
- wrap-up Phase 0: Slack reads serial → should parallelize
Impact: +2-10 seconds on morning-brief, mail-scan, wrap-up latency per run.
Fix: Refactor the 4 patterns above to parallel execution or bulk queries. Requires changes across
3-4 files. Each pattern is independent — can be done as 4 micro-fixes.
Effort: micro × 4 | Files: skills/morning-brief/SKILL.md, procedures/scan-gmail.md,
commands/wrap-up.md, skills/supplier-chaser/SKILL.md

---

**[T2-2] wrap-up context sync runs for all 4 projects even when only 1-2 were touched**
Agent: A3 (MED)
Finding: wrap-up Phase 2 queries all 4 Supplier DBs unconditionally. A day spent only on Pulse
still syncs Kaia, M-Band, BloomPod. ~400 wasted tokens per wrap-up, 2000/week.
Fix: Track "Projects Touched" in session-state (each skill updates it when touching a project).
wrap-up Phase 2 syncs only touched projects + any with overdue items. Fall back to full sync if
session-state missing or >48h old.
Effort: mini | Files: commands/wrap-up.md, skills/quote-intake/SKILL.md,
skills/supplier-chaser/SKILL.md, skills/rfq-workflow/SKILL.md (each adds 1 line to update
Projects Touched), outputs/session-state.md (add section)

---

**[T2-3] Skill-to-agent boundary rule not documented — onboarding degrades over time**
Agent: A1 (HIGH)
Finding: No written rule defines what makes something a skill vs. command vs. agent. The distinction
exists in practice (skills have SHOW BEFORE WRITE gates + lessons; commands are thin orchestrators;
agents define write scope) but is never formalized. New workflows get classified ad-hoc.
Fix: Add a canonical boundary rule to CLAUDE.md §9 (Modular Architecture):
"Skill: user-invoked, has SHOW BEFORE WRITE gates, reads lessons.md, end-to-end workflow.
Command: thin orchestrator (routes to skills/agents, no new approval gates).
Agent: defines write scope boundary and NOT-touch constraints — not invoked directly, referenced
by skills/commands."
Effort: micro | Files: CLAUDE.md §9

---

**[T2-4] Ruflo key naming is ad-hoc across skills — no canonical schema**
Agent: A4 (MED)
Finding: Different skills use different naming conventions for ruflo keys:
- supplier-chaser: `chase::{supplier_name}::{date}` (full name, with date)
- supplier-pattern-store: `supplier::{slug}::pattern` (slug, no date)
- quote-intake: `quote::{supplier_name}::{date}` (full name, with date)
No central schema. If two skills reference the same supplier but one uses "Transtek" and another
"transtek", they create orphaned records.
Fix: Create `.claude/config/ruflo-schema.md` with canonical key patterns and a normalize_slug
function spec. Add a one-line validation note to each ruflo-writing skill's Step.
Effort: mini | Files: new config/ruflo-schema.md, skills/supplier-chaser/SKILL.md,
skills/quote-intake/SKILL.md, procedures/supplier-pattern-store.md

---

**[T2-5] Context files not validated against Notion on session start — drift goes undetected**
Agent: A4 (MED)
Finding: context/{project}/suppliers.md files are the fast-path source of truth, but there is no
automated check that they match Notion. A supplier status changed in Notion (e.g., Rejected) without
a wrap-up running will cause the context file to report the old status for an entire day.
Fix: Add a lightweight drift check to session-doctor Step 2: query each Supplier DB for
`Name, Status, NDA Status` (3 columns, fast) and compare against context file headers. Flag any
status mismatch and recommend wrap-up or manual context-doctor run.
Effort: mini | Files: skills/session-doctor/SKILL.md (Step 2), procedures/context-loader.md

---

**[T2-6] MCP error policy inconsistent across skills (HALT vs SKIP vs LOG)**
Agent: A6 (MED)
Finding: quote-intake and rfq-workflow use HALT for Notion MCP failures. supplier-chaser uses
SKIP+LOG for Notion, HALT for Gmail. No unified policy. André cannot reason about which MCP
outage is recoverable without reading each skill's rules.
Fix: Create `.claude/procedures/mcp-error-policy.md` with canonical rules:
- Notion (write) = HALT + surface to André (load-bearing)
- Gmail (draft create) = HALT (safety-critical)
- Gmail (read/scan) = SKIP + LOG (degraded mode OK)
- Ruflo = SKIP + LOG (non-critical)
- Slack (read) = SKIP + LOG (degraded mode OK)
Update each skill's error handling section to reference this procedure.
Effort: mini | Files: new procedures/mcp-error-policy.md, skills/quote-intake/SKILL.md,
skills/rfq-workflow/SKILL.md, skills/supplier-chaser/SKILL.md

---

**[T2-7] Skill handoff is implicit — quotes and RFQs have no formal queue between skills**
Agent: A1 (MED)
Finding: rfq-workflow Step 5 says "hand off to quote-intake" but this means "user manually invokes
/quote-intake later." If the user forgets, the quote sits unprocessed with no reminder. No audit
trail of "quote received → quote-intake started."
Fix: Add a formal handoff mechanism: when rfq-workflow detects a quote received, write a pending
handoff entry to `outputs/skill-queue.md` (or session-state ## Skill Queue section). quote-intake
pre-flight checks for pending handoffs and surfaces them: "Resumed from rfq-workflow: {supplier}
quote from {date} — process now?".
Effort: mini | Files: new outputs/skill-queue.md schema, skills/rfq-workflow/SKILL.md (Step 5),
skills/quote-intake/SKILL.md (pre-flight)

---

**[T2-8] lessons.md write trigger ambiguous — auto vs. manual creates invisible behavior drift**
Agent: A2, A7 (MED)
Finding: lessons-read.md says "same correction observed 3+ times → propose adding lesson" but no
skill implements auto-detection. 6 of 7 lessons.md files are empty. The mechanism assumes manual
synthesis by André via /improve, but this is never stated clearly — skills imply they may
auto-write.
Fix: Clarify in lessons-read.md and all SKILL.md pre-flights: "Lessons are André-approved only.
Skills do NOT auto-write lessons. /improve surfaces candidates; André approves and André (or
operator-approved /improve) writes." Remove any language implying auto-write from skill files.
Effort: micro | Files: procedures/lessons-read.md, skills/supplier-chaser/SKILL.md (Step 6),
skills/quote-intake/SKILL.md (Rules), plus any other skill referencing auto-lessons

---

### TIER 3 — Improvements for monthly structural sprint

**[T3-1] SHOW BEFORE WRITE blast radius not tiered — approval fatigue risk**
Agent: A5 (MED)
Finding: All SHOW BEFORE WRITE interactions look the same to André regardless of risk level.
A Notes field reformat and a Unit Cost (EUR) update both present as "here's what I'll write,
approve?" — the same format for a cosmetic change and a cost-sensitive one.
Fix: Add a risk tier to the SHOW BEFORE WRITE presentation in safety.md:
- "COSMETIC — proceed with note" (Notes, Outreach milestones, label rewrites)
- "COST-SENSITIVE — full comparison required" (Unit Cost, Tooling Cost, FLC fields)
- "IRREVERSIBLE — mandatory review" (Status=Rejected, NDA write, Status=Closed)
Update ledger-append.md to tag entries with blast_radius.
Effort: structural | Files: .claude/safety.md, procedures/ledger-append.md,
skills/quote-intake/SKILL.md, skills/supplier-rejection/SKILL.md

---

**[T3-2] Session-liveness check missing — stale session blocks all writes indefinitely**
Agent: A5 (MED)
Finding: If Session A has been idle for 24h but wasn't formally closed, Session B is read-only
forever (session-single model). No timeout, no heartbeat, no liveness check.
Fix: Add to safety.md: "Session liveness: if Session A has no git commit and no Notion write for
>2h, Session B may request write access. Claude presents: 'Session A idle since HH:MM — allow
Session B? Y/N'." Add idle detection to session-doctor Step 4.
Effort: mini | Files: .claude/safety.md, skills/session-doctor/SKILL.md (Step 4)

---

**[T3-3] Autonomy promotion threshold unvalidated — may be too high or too low**
Agent: A7 (MED)
Finding: "20 consecutive clean approvals, 0 rejected in last 50" was chosen without data.
With zero ledger entries accumulated, this threshold has never been validated against actual
approval patterns. Monthly improvement cadence should produce a calibration report.
Fix: Add to monthly improvement cadence: "if ledger has N entries for any class, compute
projected promotion date at current approval rate and surface to André."
Depends on T1-1 (ledger must be populated first).
Effort: micro (after T1-1) | Files: skills/improve/SKILL.md (Step 6 monthly pass), autonomy.md

---

**[T3-4] Friction signal regression not tracked — same friction can re-appear without learning**
Agent: A7 (MED)
Finding: friction-signals.md moves signals from Pending → Resolved but has no mechanism to detect
if the same signal reappears. "Berlin Wall OI ID wrong" was fixed once; a future OI ID typo will
appear as a fresh signal with no context that this is a recurring issue.
Fix: Add a regression check to /improve Step 1: before adding a new signal, search Resolved
section for same file + same description. If found, flag as "REGRESSION: same signal appeared
previously on {date} — root cause fix may have been incomplete." Propose a lesson instead of
another one-time fix.
Effort: mini | Files: skills/improve/SKILL.md (Step 1, Source A/D)

---

**[T3-5] monthly proactive health check missing — shipped layers can silently regress**
Agent: A7 (LOW)
Finding: Daily /improve reacts to yesterday's friction. No proactive check verifies that shipped
layers (L0-L7, M-track) still function. L3 cron could fail silently for a week; L4 ledger could
stop accumulating without anyone noticing.
Fix: Add a monthly audit step to the monthly improvement cadence procedure:
"Run health assertions for each shipped layer: L3 (cron still registered?), L4 (ledger entries
this week > 0?), L5 (context files synced <48h?), L6 (quote-intake PDF flag never raised?)."
Surface failures to André.
Effort: mini | Files: commands/monthly-improvement.md (or create if missing)

---

### TIER 4 — Deferred / Low priority

**[T4-1] Instruction ambiguity: quote validity < 30 days flag does not specify action**
Agent: A2 (MED) — quote-intake/SKILL.md line 29. Clarify that validity < 30d routes to SHOW
BEFORE WRITE, not halt. Easy but low-stakes.

**[T4-2] Context bleed risk: Xinrui appears in both Pulse and M-Band active_suppliers**
Agent: A3 (MED) — add "cross_project_suppliers" array to context/index.json. Low occurrence.

**[T4-3] session-doctor cron check threshold: should be 8h not 2h**
Agent: A6 (LOW) — session-doctor Step 1c: change `Last-Warm-Up < 2h` to `< 8h` for cron
liveness check. Trivial.

**[T4-4] Deferred vs. skipped terminology inconsistency in supplier-chaser**
Agent: A2 (LOW) — supplier-chaser/SKILL.md: add one-sentence clarification that both are
operationally equivalent in Step 6. Cosmetic.

**[T4-5] Irreversibility taxonomy missing — no decision tree for new write operations**
Agent: A5 (LOW) — add a reversiblity decision tree to safety.md for new contributors. Low
immediate value, high documentation value.

---

## Summary Table

| ID | Title | Tier | Effort | Files | Agents |
|----|-------|------|--------|-------|--------|
| T1-1 | Autonomy ledger disconnected | 1 | micro×3 | 4 files | A4+A5+A7 |
| T1-2 | Timestamps on start not completion | 1 | micro×3 | 3 files | A3+A4+A6 |
| T1-3 | Checkpoint resume path undefined | 1 | mini | 4 files | A4+A6 |
| T1-4 | supplier-chaser still writes promises.md | 1 | micro | 1 file | A4 |
| T1-5 | Auto-write 30% formula undefined | 1 | micro | 1 file | A2 |
| T1-6 | index.json missing blocker_count/top_deadline | 1 | micro | 2 files | A3 |
| T1-7 | Exception 5 "clearly shows" subjective | 1 | micro | 1 file | A5 |
| T2-1 | MCP calls not parallelized (4 patterns) | 2 | micro×4 | 4 files | A8 |
| T2-2 | wrap-up syncs all 4 DBs unconditionally | 2 | mini | 5 files | A3 |
| T2-3 | Skill/command/agent boundary not documented | 2 | micro | 1 file | A1 |
| T2-4 | Ruflo key naming ad-hoc across skills | 2 | mini | 4 files | A4 |
| T2-5 | Context files not validated vs Notion | 2 | mini | 2 files | A4 |
| T2-6 | MCP error policy inconsistent | 2 | mini | 4 files | A6 |
| T2-7 | Skill handoff implicit — no queue | 2 | mini | 3 files | A1 |
| T2-8 | lessons.md write trigger ambiguous | 2 | micro | 3 files | A2+A7 |
| T3-1 | SHOW BEFORE WRITE blast radius not tiered | 3 | structural | 5 files | A5 |
| T3-2 | Session-liveness check missing | 3 | mini | 2 files | A5 |
| T3-3 | Autonomy threshold unvalidated | 3 | micro | 2 files | A7 |
| T3-4 | Friction signal regression not tracked | 3 | mini | 1 file | A7 |
| T3-5 | Monthly proactive layer health check | 3 | mini | 1 file | A7 |
| T4-x | Low-priority / deferred (5 items) | 4 | micro | various | various |

**Tier 1 total:** 7 items — 6 micro + 1 mini — ~2h total
**Tier 2 total:** 8 items — 4 micro + 4 mini — ~3-4h total
**Tier 3 total:** 5 items — 2 micro + 2 mini + 1 structural — ~3h total

**Recommended execution order:**
1. T1-1 first (unblocks learning loop, everything else feeds into it)
2. T1-2 + T1-4 + T1-5 + T1-7 (all micro, can batch in one session)
3. T1-3 + T1-6 (mini, one session)
4. T2-1 (parallel MCP calls, 4 independent micro-fixes)
5. T2-3 + T2-8 (micro, documentation)
6. T2-4 + T2-6 (mini, new procedure files)
7. T2-2 + T2-5 + T2-7 (mini, data-flow changes)
8. T3-x after T1-1 produces ledger data (~6 weeks)

---

## Raw agent reports
Stored in session transcript. Each agent filed: A1 (orchestration), A2 (prompt engineering),
A3 (context/tokens), A4 (memory), A5 (safety/autonomy), A6 (failure/recovery),
A7 (learning loop), A8 (MCP integration).
