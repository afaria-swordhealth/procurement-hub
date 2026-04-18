# Sample Testing Process
# Sword Health ISC — Procurement Knowledge Base
# Sword Insighter | Last updated: 2026-04-18

How samples are requested, received, tested, and scored for Pulse device evaluation.

---

## Scope

This document covers Pulse (BP cuffs + smart scales). Kaia (yoga mats) and M-Band components do not use the Test Reviews DB. Pulse is the only project with a formal structured test protocol.

---

## Sample lifecycle

```
Supplier confirmed as candidate
      ↓
Request sample + DHL label (supplier-comms drafts, André sends)
      ↓
Samples Status: Requested
      ↓
Supplier ships → DHL AWB in email
      ↓
Samples Status: Shipped (update on AWB receipt, logistics agent)
      ↓
Sample arrives at Sword Porto / Sword US
      ↓
Samples Status: Received → create Test Review page
      ↓
Testing begins (parallel: Pedro / Paulo / André)
      ↓
Samples Status: In Testing
      ↓
All testers submit scores
      ↓
Samples Status: Pass / Fail (overall verdict, André sets)
```

Samples Status is a field in the Supplier DB (Pulse). The Test Reviews DB holds the detailed scoring.

---

## Tester assignments

| Tester | Role | Categories |
|--------|------|-----------|
| Pedro Pereira | Engineering | BLE/SDK testing — connectivity, pairing flow, SDK integration |
| Paulo | Operations | Cosmetic evaluation — build quality, packaging, unboxing |
| André | Overall | Overall assessment — patient experience, flow clarity, brand fit |

Each tester submits their own score (1–5 scale) in the Test Reviews DB. André consolidates into an Overall Score.

---

## Scoring system (Test Reviews DB)

| Field | Scored by | Description |
|-------|-----------|-------------|
| BLE Score | Pedro | BLE pairing, SDK handshake, data transfer reliability |
| Cosmetic Score | Paulo | Physical build, materials, packaging quality |
| Overall Score | André | End-to-end experience: patient flow, clarity, brand alignment |
| Reliability Score | André + Pedro | Consistency across repeated measurements or BLE cycles |

Score scale:
- 5: Exceeds expectations — no gaps, ready to advance
- 4: Meets requirements — minor issues, acceptable
- 3: Marginal — passes but needs monitoring or supplier attention
- 2: Below requirements — requires improvement before advancing
- 1: Unacceptable — cannot pass at current state

---

## Eliminators (hard fails)

An eliminator immediately disqualifies a device regardless of other scores. The testing agent flags eliminators before the full review cycle completes.

Current eliminator criteria (from Sample Reviews Guide page in Notion):
- BLE pairing failure after 3 attempts
- Clinical accuracy outside accepted tolerance for BP readings
- Physical safety concern (sharp edges, loose battery compartment)
- SDK not implementable with current Sword platform

If an eliminator is detected: flag in /test-update output as a bold warning. Set device Status → Fail immediately after André confirms. Do not wait for all testers to score.

---

## Creating a Test Review page

When a sample is received:

1. Check Test Reviews DB (collection://911b7778-b80b-4e94-a5c4-9f8853934d2e) for an existing page for this supplier + device.
2. If none: testing agent creates a new page with fields:
   - Name: `{Supplier} — {Device model}`
   - Status: `In Testing`
   - Tester assignments per role above
   - All score fields initialized to blank
3. Log to outputs/change-log.md.
4. Update Samples Status in Supplier DB → `In Testing`.

---

## Completing a test cycle

When all testers have submitted scores:

1. André reviews and sets Overall Score.
2. André sets Status → `Pass` or `Fail`.
3. Samples Status in Supplier DB updated to match.
4. If Pass: flag for supplier-selection consideration (qualify test scores → criterion 2c).
5. If Fail (non-eliminator): document specific gaps. André decides whether to request a revised sample.
6. Log all updates to outputs/change-log.md.

---

## Score-to-selection mapping

Used in /supplier-selection Step 3 (Quality / Tests criterion):

| Overall Score | Criterion 2c score |
|---------------|-------------------|
| ≥ 4.0 | 5 |
| 3.0–3.9 | 4 |
| 2.0–2.9 | 3 |
| 1.0–1.9 | 2 |
| Eliminator fail | Hard fail — disqualified regardless of weighted score |

---

## DHL label process

André requests DHL labels via Jira ISC Shipping service desk (see zip-workflow.md). Labels are sent to Catarina to coordinate pickup. The supplier ships to Sword Porto address (see memory: Sword Porto address).

When DHL AWB appears in an email or Jira notification: logistics agent updates Samples Status → Shipped and logs the tracking number.
