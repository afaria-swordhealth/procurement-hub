---
name: "Supplier Qualification"
description: "Go/no-go assessment for a supplier under active evaluation. Checks certifications, product fit, commercial viability, and engagement quality against project-specific criteria. Use after first contact, before investing in NDA or sample request. Also use when a supplier's status needs a structured review."
---

# Supplier Qualification

Produces a structured Go / Conditional Go / No-Go verdict for a specific supplier. Combines objective data (certifications, pricing, test results) with observed engagement quality to surface risks early.

## Pre-flight

1. Read `outputs/session-state.md` for freshness.
2. Read `.claude/config/databases.md` (DB IDs, collection URLs).
3. Read `.claude/config/strategy.md` (baselines, elimination criteria).
4. Read `context/{project}/suppliers.md` for the supplier's current state.
5. For Pulse projects: read `.claude/knowledge/qara-engagement.md` to understand SQA approval timelines and Sofia Lourenço's involvement before issuing the Step 3 verdict. QARA clearance is a gate for Pulse suppliers — a Go verdict without it may need to be revisited.

## Step 1: Pull supplier data

Query the relevant Supplier DB:

```sql
SELECT Name, Status, Notes, "NDA Status", "Samples Status", Currency, Region, id, url
FROM "{SUPPLIER_DB_COLLECTION_ID}"
WHERE Name LIKE '%{supplier}%'
```

Fetch the full Notion page. Extract:
- Contact section (name, email, role)
- Profile section (factory location, certifications, product types, capacity)
- Quote section (pricing, MOQ, lead time, incoterms)
- Outreach section (history, cadence, response quality)
- Linked OIs (any blockers or pending decisions)

Also search ruflo for prior context:
- `query`: "qualification {supplier_name}"`
- `namespace`: "procurement", `limit`: 3, `threshold`: 0.4

If prior assessment exists, note it and check for changes since then.

## Step 2: Score each qualification criterion

Score each criterion 1–5. For criteria where data is unavailable, flag as "unknown" — do not assume.

### 2a. Commercial viability

Compare unit price (reference tier, EUR) against project baseline from `strategy.md`:

| Score | Criteria |
|-------|----------|
| 5 | FLC ≤ baseline target |
| 4 | FLC 1–10% above target |
| 3 | FLC 10–20% above target |
| 2 | FLC 20–30% above target |
| 1 | FLC >30% above target, or quote missing |

Also flag: MOQ out of range, lead time beyond project threshold, payment terms unfavorable.

### 2b. Product fit

Assess how well the product matches project requirements:

| Score | Criteria |
|-------|----------|
| 5 | Full spec match. Strong look & feel. Brand-aligned. Intuitive single flow. |
| 4 | Meets core specs. Minor fit gaps (e.g., cosmetic only). |
| 3 | Meets basic requirements. Some concerns — needs sample evaluation to confirm. |
| 2 | Partial spec match. Significant fit issues identified. |
| 1 | Does not meet requirements. Fundamental product mismatch. |

For Pulse: weight look & feel, patient usability, accuracy claims.
For Kaia: weight material quality, customization capability, brand fit.
For M-Band: weight technical spec compliance, connector/form factor match.
For BloomPod: weight electrochemical performance, safety spec.

**André scores this criterion** — present the available data (catalog, sample notes, test results if available) and ask for a 1–5 rating with a one-line rationale.

### 2c. Certifications and quality system

Check against project-specific hard requirements (see supplier-prospection Step 2 for full lists):

| Score | Criteria |
|-------|----------|
| 5 | All required certifications confirmed and current |
| 4 | Core certifications confirmed. One secondary cert pending or in process |
| 3 | Core certifications present but not yet verified. Supplier claims compliance. |
| 2 | Key certification missing but supplier says it can be obtained |
| 1 | Missing critical certification with no clear path to obtain |

Flag any hard eliminator gaps separately — these may override the weighted score.

### 2d. Supplier engagement

Assess responsiveness, openness, and effort from the Outreach section:

| Score | Criteria |
|-------|----------|
| 5 | Proactive. Replies within 24h. Provides complete, well-structured responses. Clear interest in the partnership. Offers to go beyond the ask (e.g., shares extra docs, proposes call). |
| 4 | Responsive (24–48h). Mostly complete responses. Engaged and cooperative. |
| 3 | Generally responsive but requires follow-up for complete answers. |
| 2 | Slow (>48h typical). Incomplete responses. Requires repeated chasing. |
| 1 | Unresponsive. Minimal effort. Disengaged. |

Count: number of follow-ups needed, average reply time (from Outreach section), completeness of quote vs. what was asked.

### 2e. Risk profile

Assess supply chain risk:

| Score | Criteria |
|-------|----------|
| 5 | Low risk: established supplier, stable region, multiple alternatives exist, ample capacity, short lead time |
| 4 | Manageable risk: one moderate concern, mitigated by supplier history or contract terms |
| 3 | Moderate risk: single-source exposure OR regional concern OR capacity question |
| 2 | High risk: two or more moderate concerns, or one critical concern without mitigation |
| 1 | Critical risk: single-source critical category + unstable region, or capacity clearly insufficient |

## Step 3: Apply project weights and calculate score

| Criterion | Pulse | Kaia | M-Band | BloomPod |
|-----------|-------|------|--------|----------|
| Commercial (2a) | 20% | 35% | 25% | 30% |
| Product fit (2b) | 30% | 20% | 20% | 15% |
| Certifications/Quality (2c) | 25% | 15% | 25% | 30% |
| Engagement (2d) | 15% | 20% | 20% | 15% |
| Risk (2e) | 10% | 10% | 10% | 10% |

**Weighted score** = sum of (score × weight). Scale: 1.0–5.0.

Verdict thresholds:
- **Go** (score ≥ 3.5, no hard eliminator failures): advance to NDA + sample
- **Conditional Go** (score 2.5–3.4, or one minor hard eliminator gap): advance with conditions — list what must be resolved before RFQ
- **No-Go** (score < 2.5, or any hard eliminator failure): recommend rejection — run `/supplier-rejection`

## Step 4: Present verdict

```
QUALIFICATION VERDICT — {Supplier} — {Project} — {Date}

Verdict: GO / CONDITIONAL GO / NO-GO

| Criterion         | Score | Weight | Weighted |
|-------------------|-------|--------|---------|
| Commercial        | X/5   | XX%    | X.XX    |
| Product fit       | X/5   | XX%    | X.XX    |
| Certifications    | X/5   | XX%    | X.XX    |
| Engagement        | X/5   | XX%    | X.XX    |
| Risk              | X/5   | XX%    | X.XX    |
| **TOTAL**         |       |        | **X.XX** |

Hard eliminators: [PASS / FAIL: list any failures]

Strengths: [top 2 reasons to advance]
Concerns: [top 2 risks or gaps]
Conditions (if Conditional Go): [specific items to resolve before RFQ]
Recommended next step: [NDA → sample → /rfq-workflow | /supplier-rejection]
```

**SHOW BEFORE WRITE.**

## Step 5: Log and store

After André reviews:

1. Log qualification outcome to Outreach section as a milestone (auto-approved):
   `**[Date]** -- Qualified: [Go/Conditional Go/No-Go]. Score: [X.X/5]. [One-line summary.]`

2. Store in ruflo:
   - `key`: `qualification::{supplier_name}::{YYYY-MM-DD}`
   - `namespace`: "procurement"
   - `upsert`: true
   - `tags`: ["qualification", project, supplier_name, verdict]
   - `value`: `{ supplier, project, verdict, total_score, scores_by_criterion, hard_eliminator_failures, conditions, date }`

3. If verdict is No-Go: offer to run `/supplier-rejection` immediately.
4. If verdict is Go or Conditional Go: propose next OI (NDA initiation or sample request).

## Rules

- André scores product fit (2b) — do not infer it without his input.
- Hard eliminator failures override the weighted score. A 4.2 with a hard fail = No-Go.
- Never reveal scores or internal assessments to the supplier.
- If key data is missing (no quote, no sample results), mark criterion as unknown and note the gap. Do not score 0 — flag separately.
- This skill is read-heavy. Notion writes only in Step 5 (Outreach milestone, auto-approved) and OI creation (SHOW BEFORE WRITE).
