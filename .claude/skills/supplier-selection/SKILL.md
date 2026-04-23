---
name: "Supplier Selection"
description: "Shortlist decision across all qualified suppliers for a project. Pulls qualification scores, sample test results, and quote data, runs weighted comparison, and produces a ranked recommendation with decision memo. Use when quotes and samples are in and it's time to choose who advances."
---

# Supplier Selection

Produces a ranked comparison of all active suppliers for a project, generates a selection recommendation, and — after André's approval — updates statuses and creates a decision record.

## Pre-flight

1. Read `outputs/session-state.md` for freshness.
2. Read `.claude/config/databases.md` (DB IDs, Supplier DBs, Test Reviews DB).
3. Read `.claude/config/strategy.md` (baselines, FLC formula, decision framework).
4. Read `context/{project}/suppliers.md` for current supplier states.
5. **Execution checkpoint check:** per `procedures/exec-checkpoints.md`, read `outputs/checkpoints/supplier-selection_{project}.json`. If file exists with `status: "in-progress"`: STOP. Surface to André: "Incomplete prior run detected on {started}. Steps completed: {steps_done}. Resume from that point, or confirm fresh start to overwrite?" If André confirms resume: follow **## Step Resumption** below. If missing or `status: "complete"`: proceed (archive complete runs per the procedure).
6. **Prior selection check:** call `mcp__ruflo__memory_search` with query `"selection {project}"`, namespace "procurement", limit 1, threshold 0.5. If a prior selection record exists: surface to André — "A prior selection was run for {project} on {date}. Winner: {winner}. Confirm this is a new evaluation cycle before proceeding." If ruflo MCP fails: skip this check and proceed.

## Step Resumption

When André confirms resume after an in-progress checkpoint, look up the **last entry** in `steps_done` and jump to the corresponding entry point. Skip all steps already listed in `steps_done`.

| Last completed (`steps_done` tail) | Resume from |
|---|---|
| *(empty — checkpoint written, no steps done)* | Step 7.1: Update winner Status → Shortlisted |
| `winner_shortlisted` | Step 7.3: Create Decision OI |
| `decision_oi` | Step 7.4: Store selection in ruflo |

Re-read the checkpoint file to recover `meta.project` and `meta.winner` before resuming. Steps 1–6 (scoring, scorecard, decision memo) are read-only — they do not need to be replayed on resume. Only start from the first incomplete destructive step in Step 7.

## Step 1: Pull all candidates

Query the project Supplier DB for active suppliers (those worth comparing):

```sql
SELECT Name, Status, Notes, "NDA Status", "Samples Status", id, url
FROM "{SUPPLIER_DB_COLLECTION_ID}"
WHERE Status NOT IN ('Rejected', 'Identified')
```

Exclude suppliers without a quote (Status = Identified or no Quote section). If a supplier is missing a quote, flag it — do not score it, but note the gap.

## Step 2: Retrieve qualification scores

For each supplier, call `mcp__ruflo__memory_search`:
- `query`: `"qualification {supplier_name}"`
- `namespace`: "procurement", `limit`: 1, `threshold`: 0.5

If a qualification record exists (from `/supplier-qualification`), use stored scores directly. Do not re-score criteria already assessed.

If no qualification record exists for a supplier: run a lightweight version of the scoring from `supplier-qualification` Step 2, noting "unassessed" for product fit (requires André input).

## Step 3: Pull test results (Pulse only)

For Pulse projects, query Test Reviews DB:

```sql
SELECT Name, Status, "Overall Score", "BLE Score", "Cosmetic Score", "Reliability Score"
FROM "collection://911b7778-b80b-4e94-a5c4-9f8853934d2e"
WHERE Status IN ('Pass', 'Fail', 'In Testing')
```

Map test scores to qualification criterion 2c (Quality/Tests):
- Overall score ≥ 4.0 → Cert score = 5
- 3.0–3.9 → 4
- 2.0–2.9 → 3
- 1.0–1.9 → 2
- Failed eliminator → Hard fail, No-Go

For non-Pulse projects: use certification data from supplier page Profile section.

## Step 4: Request André's product fit scores

Product fit (criterion 2b) requires André's direct input — it cannot be inferred from data alone.

Present each supplier and ask André to rate product fit 1–5:
- What was the sample like? Does it fit the brand?
- For devices: is the flow clear? Would a patient use this without confusion?
- For components: does it match the technical spec and integration needs?

One score per supplier. One-line rationale.

If a supplier has no sample yet, mark product fit as "pending" and note it will be a gap in the selection score.

## Step 5: Build selection scorecard

Apply project weights:

| Criterion | Pulse | Kaia | M-Band | BloomPod |
|-----------|-------|------|--------|----------|
| Commercial (FLC vs. baseline) | 20% | 35% | 25% | 30% |
| Product fit (look & feel, spec) | 30% | 20% | 20% | 15% |
| Quality / Tests | 25% | 15% | 25% | 30% |
| Engagement | 15% | 20% | 20% | 15% |
| Risk | 10% | 10% | 10% | 10% |

Calculate weighted total for each supplier. Present ranked table:

```
SELECTION SCORECARD — {Project} — {Date}
Candidates: {N} | Project baseline: {FLC target from strategy.md}

| Rank | Supplier | Status | Comm. | Fit | Quality | Engage. | Risk | TOTAL | FLC (EUR) | Rec. |
|------|----------|--------|-------|-----|---------|---------|------|-------|-----------|------|
|  1   | ...      | Short. | 4/5   | 5/5 | 4/5    | 5/5     | 4/5  | 4.45  | X.XX      | ADVANCE |
|  2   | ...      | Eval.  | 3/5   | 4/5 | 3/5    | 3/5     | 3/5  | 3.35  | X.XX      | WATCH  |
|  3   | ...      | Eval.  | 5/5   | 2/5 | 4/5    | 2/5     | 4/5  | 3.20  | X.XX      | REJECT |

Hard eliminator failures: [list any]
Data gaps: [suppliers with missing quote or no sample]
```

## Step 6: Generate decision memo

```
SELECTION RECOMMENDATION — {Project} — {Date}

Recommended: {Supplier name}
Score: {X.X / 5.0} | FLC: {X.XX EUR} | Status: {current}

Why this supplier:
- [Strongest factor — 1 sentence]
- [Second factor — 1 sentence]
- [Key differentiator vs. #2 — 1 sentence]

Runner-up: {Supplier name} — score {X.X}. Why not #1: [1 sentence reason]

Suppliers to reject: {list} — reasons: [1 line each]

Next steps if André approves:
1. Advance {winner} → Status: Shortlisted
2. Reject {others} → run /supplier-rejection for each
3. Create OI: [specific next action with winner, deadline, owner]
```

## Step 7: Execute after approval

**SHOW BEFORE WRITE for all status changes.**

After André approves the recommendation:

0. Store execution checkpoint per `procedures/exec-checkpoints.md` — write `outputs/checkpoints/supplier-selection_{project}.json` with `{ skill: "supplier-selection", entity: "{project}", started, last_update, status: "in-progress", steps_done: [], meta: { project, winner } }`. Atomic write. **On write failure: STOP.** Surface to André: "Cannot write execution checkpoint (filesystem error). Supplier selection is blocked — downstream writes (status changes, rejections) are not safely re-runnable without checkpoint protection." (Concurrency: see `safety.md` — session-single model, no 10-min guard.)
1. Update winner's Status → `Shortlisted` in Notion. After write succeeds: update checkpoint — `steps_done: ["winner_shortlisted"]`.
2. For suppliers to reject: offer to run `/supplier-rejection` for each.
3. Create Decision OI in Open Items DB:
   - Item: `{Project} — Supplier selected: {winner}`
   - Type: `Decision`
   - Status: `Closed`
   - Owner: André Faria
   - Deadline: today
   - Context: summary of selection rationale, score, key factors, alternatives considered
   This OI is created as Closed — no further updates expected. If the decision is later revisited, add context via `notion-create-comment` on the OI page. Do NOT prepend dated lines to Context.
   After OI created: update checkpoint — `steps_done: ["winner_shortlisted", "decision_oi"]`.
4. Store selection decision in ruflo:
   - `key`: `selection::{project}::{YYYY-MM-DD}`
   - `namespace`: "procurement"
   - `upsert`: true
   - `tags`: ["selection", project, winner_name]
   - `value`: `{ project, date, winner, winner_score, runner_up, runner_up_score, candidates_evaluated, key_factor, decision_rationale }`
   After ruflo store succeeds: update checkpoint — `status: "complete"`, `steps_done: ["winner_shortlisted", "decision_oi", "ruflo"]`.

## Rules

- **Never compare FOB and landed prices without flagging** (inherits from analyst rules).
- André must input product fit scores (Step 4) — do not estimate them.
- Hard eliminator failures disqualify regardless of weighted score.
- Suppliers with missing quote or no sample should be noted but not ranked.
- Selection recommendation is for André only — not for sharing externally.
- Decision memo language: factual, data-grounded. No "promising" or "excellent" without a score backing it.
- If only one supplier is active (single-source situation), flag it explicitly and note the risk before proceeding.
- Kaia: all selection decisions require Caio + Max Strobel sign-off before advancing. Note this in the recommendation.
