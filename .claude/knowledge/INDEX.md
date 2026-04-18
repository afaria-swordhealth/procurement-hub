# Sword Insighter — Knowledge Index
# Process knowledge base for Sword Health ISC procurement
# Last updated: 2026-04-19

Reference documentation for how procurement processes work at Sword. Use when a skill or command needs context on triggers, stakeholders, timelines, or decision authority — not just what to do, but why and when.

---

## Files

| File | What it covers |
|------|---------------|
| [nda-process.md](nda-process.md) | When to initiate NDAs, Zip workflow, Bradley/Legal, NDA Status values, project-specific notes |
| [supplier-onboarding-process.md](supplier-onboarding-process.md) | 3-track onboarding (Procurement + Finance/AP + QARA), dependencies, timelines per project |
| [qara-engagement.md](qara-engagement.md) | When to loop Sofia, what she needs, SQA/QTA/LoE/UDI process, André's relay role |
| [zip-workflow.md](zip-workflow.md) | Zip portal: NDA, vendor onboarding, budget requests — states, notifications, OI mapping |
| [cross-functional-map.md](cross-functional-map.md) | Stakeholder directory, decision authority, involvement by stage, escalation paths |
| [sample-testing-process.md](sample-testing-process.md) | Pulse sample lifecycle, tester assignments, scoring system, eliminators, DHL label process |
| [po-first-order-process.md](po-first-order-process.md) | Post-selection: Zip budget approval, PO issuance, tooling deposit, production monitoring, first shipment |
| [requote-process.md](requote-process.md) | When and how to request revised quotes — triggers, what to share, Notion documentation, ruflo delta |

---

## Usage

Skills reference these files in pre-flight when the task involves a process decision (not just data lookup). For example:
- `/rfq-workflow` → reads `nda-process.md` (confirm NDA signed before proceeding)
- `/supplier-onboarding` → reads `supplier-onboarding-process.md` (which tracks to initiate)
- Any regulatory question → reads `qara-engagement.md` (who to contact and how)
- `/test-update`, `/supplier-selection` → reads `sample-testing-process.md` (scoring system, eliminators, tester roles)

---

## Maintenance

Update these files when:
- A process changes at Sword (new Zip step, new QARA contact, new regulatory requirement)
- A new project is added with different process requirements
- André corrects an assumption about how something works

These files reflect André's knowledge of Sword's internal processes. They are not derivable from code or Notion. Keep them accurate.
