# Cross-Functional Map
# Sword Health ISC — Procurement Knowledge Base
# Sword Insighter | Last updated: 2026-04-18

Who does what at each stage of procurement. André's relay map.

---

## Stakeholder Directory

| Person | Role | Domain | Language | Channel |
|--------|------|--------|----------|---------|
| André Faria | Sourcing Engineer, ISC | Sourcing, cost, vendor management, prioritization | EN / PT | — |
| Jorge Garcia | Director, Logistics & Purchasing | Escalations, budget, strategic decisions | PT | Slack DM |
| Anand Singh | VP ISC | Executive decisions, cross-functional | EN | Slack / email |
| Marcio | [ISC leadership] | [TBD] | EN | — |
| Bradley | Legal | NDAs, contracts, IP | EN | email |
| Sofia Lourenço | Expert QSE | SQA, Qualio, FDA, LoE review | PT | Slack DM + email |
| Bianca Lourenço | Senior Manager, Regulatory Affairs | Complex regulatory, FDA strategy, UDI | EN/PT | via Sofia first |
| João Quirino | QA/Regulatory Director | — (do not contact directly, use Sofia) | — | — |
| Pedro Pereira | Engineering | BLE/SDK testing, firmware evaluation | EN | Slack |
| Miguel Pais | Sr. TPM | M-Band technical, Wintech liaison | EN | Slack |
| Gustavo Burmester | NPI Engineering Manager | NPI engineering decisions | EN | Slack/email |
| Catarina | ISC Shipping | DHL, samples, customs coordination | PT/EN | Slack/email |
| Fernando Saraiva | International freight | Large shipments, freight negotiation | PT | email |
| Max Strobel | Kaia Program Manager (NYC) | Kaia sourcing decisions (co-sign required) | EN | Slack/email |
| Caio | Kaia Program | Kaia sourcing decisions (co-sign required) | PT/EN | Slack/email |
| Kevin Wang | [T2D / glucometer project] | T2D sourcing, CGM/glucometer | EN | Slack |

---

## Decision authority by topic

| Topic | André decides | André relays / escalates to |
|-------|--------------|----------------------------|
| Supplier selection (Pulse, M-Band, BloomPod) | Yes — subject to Jorge awareness | Jorge for major decisions |
| Supplier selection (Kaia) | No — co-sign required | Caio + Max Strobel before advancing |
| NDA initiation | Yes | Bradley for review/signing |
| Price negotiation strategy | Yes | Jorge if above threshold |
| Regulatory / QARA (SQA, FDA, UDI, LoE) | No — relay only | Sofia Lourenço (first); Bianca (escalation) |
| BLE / SDK technical validation | No — relay only | Pedro Pereira |
| M-Band technical specs | No — relay only | Miguel Pais |
| Kaia material quality | With Max/Caio input | Max Strobel + Caio |
| Legal clauses (NDA, SQA, contracts) | No — relay only | Bradley |
| First PO authorization | No — budget request required | Finance via Zip |
| DHL labels / shipping | With Catarina | Catarina executes |
| Logistics cost / Nimbl rates | Yes | Fernando for large freight |

---

## Involvement by procurement stage

### Stage: Prospection
| Who | Role |
|-----|------|
| André | Search, screen, create Identified entries |
| Jorge | Aware (no approval needed for Identified) |
| Sofia | Not yet involved |

### Stage: Qualification (GO/No-Go)
| Who | Role |
|-----|------|
| André | Score all criteria; rate commercial, engagement, risk |
| André | Score product fit (required André input — cannot be delegated to Claude) |
| Pedro | BLE/SDK validation input if relevant (M-Band, Pulse) |
| Sofia | Not yet involved (unless pre-qualification cert questions arise) |

### Stage: NDA
| Who | Role |
|-----|------|
| André | Submit Zip request, coordinate timeline |
| Bradley | Legal reviewer and signatory |
| Sofia | Involved only if QARA-relevant IP clauses present |

### Stage: RFQ / Quote
| Who | Role |
|-----|------|
| André | Send RFQ, receive quotes, run `/quote-intake` |
| Analyst agent | FLC calculation, comparison |
| Jorge | Aware of pricing progress |

### Stage: Selection
| Who | Role |
|-----|------|
| André | Build scorecard, make recommendation |
| Caio + Max | Co-sign for Kaia only |
| Jorge | Informed after decision |

### Stage: Supplier Onboarding (post-selection)
| Who | Role |
|-----|------|
| André | Coordinate all 3 tracks |
| Bradley | NDA finalized (if not already done) |
| Finance / AP | Zip vendor creation |
| Sofia | SQA initiation (Pulse only) |
| Catarina | Sample shipment logistics |

### Stage: Sample / Test Evaluation
| Who | Role |
|-----|------|
| André | Overall coordination, cosmetic assessment |
| Pedro | BLE/SDK testing (M-Band, Pulse) |
| Paulo | Cosmetic scoring |
| Miguel | M-Band technical spec verification |

---

## Escalation paths

| Situation | Escalate to | How |
|-----------|-------------|-----|
| Supplier threatening to walk | Jorge | Slack DM (PT), then decide together |
| NDA stalled > 3 weeks | Bradley | Slack DM or email |
| QARA blocking production commitment | Jorge + Sofia | Loop Jorge only after Sofia has tried to unblock |
| Kaia decision needed urgently | Caio, then Max | Caio first (internal), Max if urgent and Caio unavailable |
| Regulatory surprise from supplier | Sofia immediately | Do NOT commit to anything before looping Sofia |
| Budget overrun on FLC vs. baseline | Jorge | Bring data — FLC table vs. baseline, not just a number |
