---
name: "Arch Audit"
description: "Architecture audit session. 20 specialist agents across 5 lens groups diagnose the system. Synthesizes findings into improvement tiers, seeds friction-signals + improvement-plan, plans the next audit (2-4 agents), and runs an innovation scan (2-4 agents)."
---

# Arch Audit

Full architecture review. 4 phases. Output: numbered `outputs/arch-audit-N.md` + seeded queues.

Cadence: every 2-3 months, or when friction-signals.md has fewer than 3 pending items.

---

## Pre-flight

1. Detect next audit number: count `outputs/arch-audit-*.md` files → N = highest + 1.
2. Read `outputs/arch-audit-{N-1}.md` (previous audit) — agents must not re-surface already-resolved items.
3. Read `outputs/improvement-plan.md` §10 + §11 — current layer/M-track status.
4. Read `outputs/friction-signals.md` ## Pending — items already in queue (do not duplicate).
5. Read `outputs/autonomy-ledger.md` — current ledger state (agent A11 needs this).
6. Read `.claude/safety.md` and `.claude/autonomy.md` — current safety posture.
7. Note current date for output header.

---

## Phase 1 — 20 parallel diagnostic agents

Launch all 20 agents simultaneously. Each receives:
- The pre-flight files listed above as context.
- Its specific lens brief below.
- Instruction: "Flag findings. Do NOT propose fixes yet. Each finding must include: file + line (if known), severity (HIGH/MED/LOW), confidence (HIGH if evidence in file, MED if inferred, LOW if hypothetical), and whether it was flagged by a previous audit."

Group findings are independent. An agent should not wait for another.

### Group 1 — Orchestration (A1–A4)

**A1 — Skill/Command/Agent boundaries**
Review: Are skills, commands, and agents correctly classified? Do any skills act as commands or vice versa? Are agent scope boundaries (NOT-touch rules) enforced in the skills that call them? Are there skills that should be commands or commands that have grown into skills?

**A2 — Prompt engineering quality**
Review: Are skill instructions precise enough to produce deterministic behavior? Are there ambiguous verbs ("review", "check", "ensure") without acceptance criteria? Are SHOW BEFORE WRITE presentations informative enough for André to make a decision without reading the full context? Are there instructions that two Claude sessions could interpret differently?

**A3 — Context economics / token budget**
Review: Does each skill load only the context it needs (per §4d Global Pre-flight)? Are there skills that load full context files when a header would suffice? Are any context files growing past their density targets? Does context/index.json Layer 1 fast path actually get used, or does every skill fall through to Layer 2?

**A4 — Orchestration flow completeness**
Review: Are there operational flows with no skill covering them (gaps)? Are there skills that duplicate each other's logic? Do all skills that write Notion follow the same pre-fetch → SHOW BEFORE WRITE → write → log pattern, or are there shortcuts?

---

### Group 2 — Data & State (A5–A8)

**A5 — Memory architecture**
Review: Are ruflo keys consistent across skills (canonical schema)? Are there memory writes that duplicate information already in context files? Are context files and Notion in sync (or could they drift silently)? Is autonomy-ledger.md being populated, or is it still empty?

**A6 — Session state management**
Review: Are session-state.md timestamps written after completion (not at start)? Are all session crons correctly registered and re-registered at warm-up? Is the session-single model enforced, or are there race conditions between Session A and Session C?

**A7 — Data flow between skills**
Review: Is there a formal handoff mechanism between skills (e.g., rfq-workflow → quote-intake)? Are there implicit dependencies (skill A assumes skill B ran first) that are not documented? Are exec-checkpoint resume paths defined, or just detection?

**A8 — Context drift detection**
Review: Is there any mechanism to detect when context files diverge from Notion? How long could a stale context file go undetected? Does session-doctor catch context drift, or only timestamp drift?

---

### Group 3 — Safety & Learning (A9–A12)

**A9 — Safety gate coverage**
Review: Are all Notion writes covered by SHOW BEFORE WRITE or a named Exception? Are there any write paths that bypass the gate silently? Is Exception 5 ("clearly shows") specific enough to be applied consistently? Is the blast radius of each write type tiered (cosmetic vs cost-sensitive vs irreversible)?

**A10 — Autonomy & auto-approval**
Review: Is autonomy-ledger.md wired into approval gates? Are there approval patterns that have been consistent for 20+ sessions but aren't being tracked? Are there auto-approvals in safety.md Exceptions that should be graduated (or revoked)?

**A11 — Learning loop (lessons + patterns)**
Review: Are per-skill lessons.md files being written and read? Is the write trigger clearly defined (André-approved only, never auto)? Are supplier patterns in ruflo being populated by supplier-chaser/supplier-enrichment? Is there a feedback loop from lessons back into skill behavior?

**A12 — Failure recovery**
Review: Are exec-checkpoints defined in all critical skills? Are resume paths (not just detection) specified? What happens if a skill crashes mid-Notion-write — is there a partial-write guard? Is there a recovery path for a crashed warm-up that left a fresh-looking timestamp?

---

### Group 4 — Integration (A13–A16)

**A13 — MCP integration quality**
Review: Are MCP calls parallelized where possible? Are there serial call patterns that should be batched? Is the error policy (HALT vs SKIP+LOG) consistent across skills and documented centrally? Are there MCP capabilities being underused (e.g., Notion formula fields, Slack search operators)?

**A14 — Slack/Gmail/Notion usage patterns**
Review: Are Gmail drafts always created in HTML? Are Slack messages always embedding links (never raw URLs)? Are Notion writes using the correct property names (unprefixed for writes, `date:` prefix for reads)? Are there write patterns that should be auto-approved but aren't?

**A15 — Latency & performance**
Review: What are the slowest operations in the daily flow (warm-up, mail-scan, morning-brief, wrap-up)? Are there Notion queries fetching more columns than needed? Are there skills that run sequentially where parallelism is possible?

**A16 — Cron & scheduled automation**
Review: Are crons correctly scoped (session-scoped vs durable)? Is the morning-brief cron re-registered at every warm-up? Are there operations that run on every session start that should be cron-driven instead? Are there crons that could silently fail without André noticing?

---

### Group 5 — Human & Domain (A17–A20)

**A17 — UX & cognitive load**
Review: How many SHOW BEFORE WRITE approvals does André face per operational session? Is approval fatigue a risk? Are brief outputs (morning-brief, session-doctor report) scannable in under 60 seconds? Are there approval patterns that could be batched?

**A18 — Supplier data model integrity**
Review: Does the data model match real procurement flows (NDA → SQA → QTA → MSA → PO)? Are there supplier states or transitions that the system doesn't model? Are supplier context files dense enough for the most-active suppliers (Transtek, Unique Scales)?

**A19 — Scalability**
Review: What breaks if projects grow from 4 to 10? What breaks if André manages 60 suppliers instead of 30? Are there hardcoded assumptions about project count or supplier count? Is the context/index.json Layer 1 fast path designed to scale?

**A20 — Observability & debugging**
Review: If a skill fails silently, how quickly would André notice? Is change-log.md rich enough to diagnose a failure after the fact? Are there operations that should emit [EVENT: ...] entries but don't? Is there a way to replay what happened in a previous session?

---

## Phase 2 — Synthesis

1. Collect all findings from 20 agents.
2. De-duplicate: same file + same description = same finding. Keep highest confidence.
3. Cross-reference: findings flagged by 2+ agents are HIGH CONFIDENCE — mark with *.
4. Classify each finding by tier (same criteria as /improve):
   - Tier 1: micro/mini, high confidence, fix before next structural sprint
   - Tier 2: mini/structural, medium confidence, next dedicated session
   - Tier 3: structural, low urgency, monthly sprint
   - Tier 4: deferred/low priority
5. Write `outputs/arch-audit-N.md` with:
   - Executive summary (3 highest-confidence cross-agent findings)
   - Full improvement queue table (all tiers)
   - Per-finding detail (same format as arch-audit-3.md)
6. Seed immediately:
   - T1 items → `outputs/friction-signals.md ## Pending` (format: `[FRICTION: ARCH{N}_T1-{n} ts=today tier=micro|mini source=arch-audit-N.md]`)
   - T2-T4 items → new `## Architecture Audit N.0 — Backlog` section in `outputs/improvement-plan.md`
7. Commit: `Arch Audit N.0: 20-agent review — {X} improvement items in 4 tiers`.

---

## Phase 3 — Plan the next audit (2–4 agents)

Launch 2–4 agents after Phase 2 is committed. Each agent receives `outputs/arch-audit-N.md` as input.

**B1 — Lens coverage reviewer**
Which of the 20 lenses produced the most findings? Which produced nothing (possibly too narrow or overlapping)? Which lenses were missing entirely? Propose: 3 lenses to split, 3 lenses to merge, 3 new lenses not covered this time.

**B2 — Blind spot detector**
Read the last 2 audit outputs. Which areas keep producing findings (systemic)? Which areas have never been flagged (possibly not being looked at properly)? Are there parts of the system that no lens covers end-to-end?

**B3 — Process quality reviewer**
Was Phase 1 well-structured? Did agent briefs produce actionable findings or vague observations? Were there findings that were too high-level to act on? Propose improvements to the agent briefs themselves.

**B4 — Next audit spec**
Synthesize B1+B2+B3 into a concrete spec for the next audit: number of agents (same or more), lens list, any structural changes to the process. Write as `## Next Audit Spec` section appended to `outputs/arch-audit-N.md`. This section is the input for the next `/arch-audit` run.

---

## Phase 4 — Innovation scan (2–4 agents, web search enabled)

Launch after Phase 3. These agents may use web search. They do NOT look at the current codebase — they look outward.

**C1 — AI agent architecture trends**
Search: latest developments in agentic AI systems (late 2025–present). What patterns are production teams adopting? What's working at scale? What maps onto this system's constraints (Claude Code + MCP + files, no Python runtime)?

**C2 — Procurement tech landscape**
Search: procurement automation tools, supplier management platforms, sourcing AI (2025–present). What capabilities are buyers at André's scale using? What integrations (ERP, PDM, regulatory databases) are becoming standard?

**C3 — MCP ecosystem expansion**
Search: new MCP servers released or announced (2025–present). Which would add value to this system? (e.g., Jira MCP for Zip integration, calendar write access, document parsing MCPs for supplier specs). Assess feasibility against current constraints.

**C4 — Synthesis**
Collect C1+C2+C3. For each opportunity: rate adoptability (HIGH = can implement in 1 sprint; MED = requires new infrastructure; LOW = blocked by constraint). Write as `## Innovation Opportunities` section appended to `outputs/arch-audit-N.md`. Do NOT add these to friction-signals — they require André's explicit decision before entering the queue.

---

## Output

`outputs/arch-audit-N.md` contains:
1. Executive summary
2. Full improvement queue (Tiers 1-4)
3. Per-finding detail (20 agents × findings)
4. `## Next Audit Spec` (from Phase 3)
5. `## Innovation Opportunities` (from Phase 4)

`outputs/friction-signals.md` — T1 items seeded.
`outputs/improvement-plan.md` — T2-T4 backlog section added.

---

## Rules

- **Never implement during the audit.** This skill produces a plan only. Execution is via /improve.
- **Phase 2 commits before Phase 3 starts.** Never run Phase 3/4 on uncommitted findings.
- **Innovation Opportunities never go directly to friction-signals.** André decides first.
- **Previous audit is mandatory context.** Agents must not re-flag already-resolved items.
- **Cross-agent findings (2+ agents) are highest priority.** Always surface them first.
- **Phase 4 agents use web search.** This is the only skill where web search is expected and encouraged.
