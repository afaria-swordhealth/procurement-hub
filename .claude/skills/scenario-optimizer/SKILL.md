---
name: "Scenario Optimizer"
description: "Award-split permutation analysis for a project's shortlist. Runs N scenarios across Full Landed Cost (single-source, dual-source with primary/secondary volumes, capacity-capped), outputs a ranked table with risk/cost tradeoffs and a one-paragraph rationale per scenario. Use when shortlist is in and the decision is how to allocate volume. Read-only — never writes Notion."
---

# Scenario Optimizer

Takes the shortlist for a project and computes award-split permutations (Keelvar pattern, simplified). Each scenario is a different volume allocation. Output ranks by cost, flags risk (single-source exposure, capacity overreach), and gives André a one-page decision memo.

Read-only. Produces a recommendation, not a write. Award decisions go through `/supplier-selection`.

## Pre-flight

1. Read `outputs/session-state.md` for freshness.
2. Read `.claude/config/databases.md` (Supplier DBs, Open Items DB).
3. Read `.claude/config/strategy.md` §3 Cost Analysis Rules — FLC formula, FOB vs landed normalization, project baselines.
4. Read `context/{project}/suppliers.md` for the shortlist and latest quote state.
5. **Lessons read:** per `.claude/procedures/lessons-read.md`, read `.claude/skills/scenario-optimizer/lessons.md` (top 10). Apply before composing output. If missing or empty, skip.

## Inputs

- `/scenario-optimizer {project}` — required. Pulse, Kaia, M-Band, or BloomPod.
- Optional: `--volume {N}` to override annual unit volume (default: project baseline, e.g., Pulse 20k/yr).
- Optional: `--constraints "capacity:SupplierA=5000;tooling:SupplierB=60000"` to inject capacity caps or tooling costs not yet in Notion.

If no shortlist exists (fewer than 2 suppliers in Shortlisted or Quote Received), HALT: "Shortlist too small for scenario analysis — need ≥2 quoted suppliers. Currently {N}."

## Step 1: Pull the shortlist

```sql
SELECT Name, Status, "Unit Cost", "Tooling Cost", Currency,
       "FX Rate at Quote", "Samples Status", "NDA Status", "Lead Time", MOQ,
       "Capacity (units/month)", id, url
FROM "{SUPPLIER_DB}"
WHERE Status IN ('Shortlisted', 'Quote Received', 'Sample Received')
  AND "Unit Cost" IS NOT NULL
```

If `FX Rate at Quote` is null for any supplier, use `.claude/config/fx-rates.md` current reference rate and flag the row with `[FX basis current, not stamped]`. Do not silently substitute.

If `Capacity (units/month)` is null, flag the supplier as `[capacity unknown]` and exclude from any scenario that would award >50% of volume to that supplier.

## Step 2: Compute per-supplier FLC

Apply the FLC formula from `strategy.md`:

```
FLC = Unit Price (normalized to USD at stamped FX) + Freight + Duties + Fulfillment
```

Per project:

- **Pulse:** FOB baseline. Add freight ($0.40/unit ocean, $2.00/unit air for small qty) + duties (varies by HS code, use 0% for FDA-cleared Class I, 3% for Class II unless André overrides) + fulfillment ($0 direct ship, $1.80/unit Nimbl). A&D quotes are landed — do not add freight/duties again; flag as `[pre-landed, no additions]`.
- **Kaia:** All comparisons must include Nimbl fulfillment ($2.68/unit savings if replaced). Default fulfillment $4.00 current, $1.32 with Nimbl replacement.
- **M-Band:** FOB baseline. Add freight + duties similar to Pulse. If sourcing from EU distributor (Future Electronics / Avnet), treat as landed.
- **BloomPod:** Coin cell — use Murata/Renata benchmarks. FLC per 1000-cell reel.

Output a per-supplier FLC table before running scenarios. This is the input for Step 3.

## Step 3: Generate scenarios

Generate these canonical scenarios for N suppliers with valid FLC:

### Scenario A — Single-source (winner-takes-all)
For each supplier in the shortlist, a scenario where that supplier takes 100% of volume. N scenarios total.

### Scenario B — Dual-source 70/30
Top FLC supplier gets 70%, each other supplier gets 30% in turn. (N-1) scenarios.

### Scenario C — Dual-source 50/50
Every pair of suppliers splits volume equally. C(N,2) scenarios.

### Scenario D — Capacity-capped
For any supplier with a declared capacity < requested volume, cap at that capacity; remainder goes to the next-lowest-FLC supplier. Auto-generated.

### Scenario E — Tooling-amortized
If tooling cost differs materially across suppliers, compute the break-even volume where each supplier's (unit × N) + tooling beats the next. Flag the volume threshold.

For each scenario, compute:

- Total annual cost = Σ (volume_i × FLC_i) + tooling_i (one-time)
- Savings vs. baseline (project-specific: Pulse $7.60–$18.60 range, Kaia $27–$31 baseline, etc. from `strategy.md`)
- Single-source risk score: 100 = one supplier = 100%. 50 = 70/30 split. 0 = 50/50 or more suppliers.
- Qualification risk: NDA not signed = +20, samples not received = +15, FDA verification gap = +30 (Pulse only)

## Step 4: Rank and filter

Rank scenarios by:

1. **Primary:** total annual cost ascending (cheapest first)
2. **Tiebreak 1:** lower single-source risk score wins
3. **Tiebreak 2:** lower qualification risk wins

Filter out scenarios where:
- Any supplier with `[capacity unknown]` is awarded >50%
- Any supplier with Status = Rejected appears (should be excluded by Step 1, but double-check)
- Any supplier without a valid `FX Rate at Quote` is in the top 3 — surface the FX uncertainty instead of presenting the scenario as optimal

## Step 5: Compose output

```
SCENARIO OPTIMIZER — {Project} — annual volume {N} units — {date}

SHORTLIST FLC TABLE:
| Supplier | Unit | FX stamped | Freight | Duties | Fulfillment | FLC | Capacity/mo |
|---|---|---|---|---|---|---|---|
| ...

TOP 5 SCENARIOS (ranked):

#1 — Dual-source 70/30: Supplier A + Supplier B
- Annual cost: $X (vs baseline $Y, saves $Z / {%})
- Allocation: A = 70% (14k units), B = 30% (6k units)
- Single-source risk: 50 | Qualification risk: 15
- Rationale: A is lowest FLC with proven capacity; B hedges against A's 8-week LT by providing backup supply. B's NDA is Signed. [2 lines max.]

#2 — Single-source: Supplier A
- Annual cost: $X (vs baseline, saves $Z)
- Allocation: A = 100% (20k units)
- Single-source risk: 100 | Qualification risk: 5
- Rationale: Lowest FLC; tooling amortized over 20k beats any split. Risk: A's capacity is 25k/mo — headroom of 20% only. If A slips, no backup. [2 lines max.]

... (up to 5)

RECOMMENDATION:
[One paragraph, 3–5 sentences. Pick one scenario. Explain the trade — why the recommended scenario wins on cost+risk over the cheapest-single-scenario. Surface open questions: "This assumes Supplier B's quote stamps FX at stamped rate; confirm if André wants to re-quote with current FX". Never claim the recommendation is final — that's /supplier-selection's job.]

OPEN QUESTIONS FOR ANDRÉ:
- [bulleted list, only when relevant]
- Capacity for Supplier X is declared at 5k/mo — does Wintech's peak season (Q4) affect this?
- FX stamp missing on Supplier Y quote — re-quote or proceed with current rate?
```

## Step 6: Log

Log to `outputs/change-log.md`:

```
### Scenario optimizer — {project}
- Shortlist: {N} suppliers
- Scenarios evaluated: {M}
- Top scenario: {one-line}
- Cost vs baseline: ${savings} / {%}
- Open questions surfaced: {count}
```

Append `[EVENT: SCENARIO_RUN project={project} shortlist={N} scenarios={M} top_savings_pct={P}]` above the prose entry.

No Notion write. No Status change. No OI create. The output is a decision memo. André takes it into `/supplier-selection` if he wants to act on it.

## Rules

- NEVER compare FOB and landed in the same FLC column (strategy.md §3). Normalize before the table, not during scenario ranking.
- NEVER reveal one supplier's quote to another supplier (strategy.md §1). This skill is internal synthesis only — do not draft emails.
- NEVER assume a supplier's capacity; if field is null, mark `[unknown]` and cap scenario eligibility.
- NEVER present a scenario using a current-rate FX if the quote was stamped at a different rate (B6 rule). Flag and use stamped rate.
- Kaia scenarios must always include fulfillment cost (Nimbl or current) — omitting it invalidates the comparison.
- Pulse scenarios should surface FDA product-code consistency (DXN for BP, FRI/PUH/MNW for scales). If a shortlist mixes classifications, flag to André.
- If the shortlist is locked by an upstream gate (Kaia awaiting Max/Caio), run the scenarios but prefix the output: `INFORMATIONAL — decision gated on {gate}, per memory project_kaia_dependency.md`.
- Output is English. No Portuguese version even for Jorge — cost memos stay in English for consistency.
- MCP error handling: Notion failure → HALT (can't score without quotes). Ruflo failure (lessons read) → log and proceed.
