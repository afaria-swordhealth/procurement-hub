# Procurement Strategy - André Faria
# Business rules, negotiation principles, escalation criteria
# Used by: all agents (especially supplier-comms and analyst)

---

# 1. Negotiation Rules

## Never reveal
- Prices from competing suppliers. Not even ranges.
- Internal budget or price targets.
- How many suppliers are in the pipeline.
- Internal decision timelines or shortlist status.
- Which supplier is currently leading.
- Test results from other suppliers' devices.

## Pricing leverage tactics
- Reference "our standard evaluation process" when asking for free samples or goodwill.
- Frame DHL label as significant cost on Sword's side to justify asking for free samples.
- Use volume (20k units) as leverage without committing to specific orders.
- If a supplier is expensive, ask for volume breakpoints instead of directly saying "too expensive".
- If a supplier improves their price, acknowledge it but don't confirm it's competitive.

## Sample negotiation playbook
1. Ask for samples with DHL label provided by Sword.
2. Request goodwill samples (free) as "gesture of partnership".
3. If supplier insists on payment, accept but note it for leverage later.
4. Always request proforma invoice, dimensions, weight before generating DHL label.
5. Samples are for evaluation, never commit to PO during sample phase.

---

# 2. Supplier Relationship Management

## New supplier (first contact to RFQ)
1. First outreach: introduce Sword Health, attach specs document, propose call.
2. After response: answer their questions, request quote (FOB, lead time, cuff sizes, BLE/SDK).
3. After quote: request FDA docs, compliance certs, BLE protocol.
4. If NDA required: use Sword's template via ZIP platform. Never sign supplier's NDA first.
5. Sample request: only after quote + FDA docs are satisfactory.

## Established supplier (ongoing)
- Respond within 24-48h to maintain momentum.
- Always acknowledge receipt of documents/info even if no action needed.
- Keep supplier informed of "next steps" without revealing internal decision process.
- If deprioritising: don't ghost. Send a polite "we're still evaluating and will be in touch."

## Rejecting a supplier
- Never say "you're rejected" or "we chose someone else."
- Use: "We're unable to move forward at this time" or "If that changes in the future, we'd be happy to revisit."
- If they follow up after rejection: brief, polite acknowledgment. Don't re-engage.

---

# 3. Cost Analysis Rules

## FOB vs Landed
- NEVER compare FOB and landed prices in the same table without flagging.
- Landed = FOB + freight + duties + fulfillment.
- All Kaia comparisons must be fully loaded (unit + freight + duties + Nimbl fulfillment).
- Pulse: most suppliers quote FOB. A&D quotes landed. Always normalize before comparing.

## FLC (Fully Loaded Cost) formula
```
FLC = Unit Price (FOB/EXW) + Freight + Duties + Fulfillment
```

## Kaia baselines
- Current: $27-$31/unit (4imprint $11.58 + SV Direct $15.83-$19.83)
- Nimbl replacement: saves $2.68/unit on fulfillment regardless of supplier.
- All savings quoted against the baseline must include fulfillment.

## Pulse baselines
- BP Cuff range: $7.60 (Finicare) to $18.60 (Transtek) FOB
- Smart Scale range: $6.98 (Unique CF632) to $12.80 (Transtek GBF-2008-B1) FOB
- A&D at $18.00 LANDED is not directly comparable to FOB prices.

---

# 4. FDA/Regulatory Rules

## Product codes
- DXN: BP monitors (non-invasive blood pressure measurement system)
- FRI: Weight scales only (Class I, GMP-exempt)
- PUH: Body composition analyzers with BIA (Class II, full QMS)
- MNW: Body composition with clinical claims (Class II, 510(k) required)

## Supplier FDA verification checklist
Before shortlisting any device supplier:
1. Check FDA Establishment Registration (manufacturer must be registered)
2. Check Device Listing (specific model must be listed)
3. If 510(k) claimed, verify K-number on FDA database
4. If FRI/PUH claimed, verify product code matches device features
5. BIA features = PUH minimum. Weight-only = FRI eligible.

## Red flags
- Supplier claims FDA but can't provide K-number or listing number.
- Supplier not found in FDA Establishment Registration database.
- BIA device listed under FRI (impossible, regulatory mismatch).
- Device listing under a different company name than the supplier.

---

# 5. Escalation Criteria

## Escalate to Jorge Garcia (manager) when:
- Supplier requests non-standard payment terms (100% upfront, LC, etc.)
- Price exceeds benchmark by >30% without clear justification
- Supplier asks about Sword's financial standing or credit references
- Contract/BAA questions from stakeholders (Max, Caio)
- Site visit planning or scheduling
- Any question about Kimball $10M path or revenue forecasting

## Escalate to Bianca Lourenco (regulatory) when:
- FDA classification uncertainty (FRI vs PUH vs MNW)
- IFU/labeling questions (private label, OBL status)
- Supplier claims FDA clearance that can't be verified
- Any device features that might change regulatory classification

## Escalate to Pedro Pereira (engineering) when:
- BLE protocol compatibility questions
- SDK integration feasibility
- New BLE profile type from a supplier
- Device pairing issues or technical BLE behavior

## Escalate to Bradley (legal) when:
- NDA execution (via ZIP platform)
- Supplier pushes back on Sword's NDA terms
- IP or confidentiality concerns
- LOA (Letter of Authorization) requests

## Do NOT escalate (handle directly):
- Standard sample requests and logistics
- Quote clarifications and follow-ups
- Proforma invoice / DHL label requests
- Routine supplier follow-ups
- Technical spec confirmations already in device docs
- Notion updates and database maintenance

---

# 6. Decision Framework

## When recommending a supplier:
1. Price (FLC, not just unit price)
2. FDA compliance (verified, not just claimed)
3. Lead time (within launch window?)
4. Technical fit (BLE/SDK, cuff sizes, weight capacity, memory)
5. Sample quality (test scores, build quality)
6. Relationship quality (responsiveness, transparency, goodwill)

## Elimination criteria (any one = out):
- No FDA clearance/listing for US market
- BLE pairing fails
- Weight capacity below 180kg (scales)
- Lead time exceeds launch window with no acceleration path
- Cuff size doesn't cover 22-42cm range (BP)
- Supplier unresponsive for >14 days after 2+ follow-ups
