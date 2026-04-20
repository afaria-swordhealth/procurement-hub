# Pulse Suppliers  - Context File
# Last synced: 2026-04-20T23:00

## Shortlisted (2)  - PO Authorization Confirmed Apr 8
- **Transtek Medical**  - MANUFACTURER (Zhongshan, CN). Entity: Guangdong Transtek Medical Electronics Co., Ltd (corrected Apr 20 — Bradley notified). BP cuff BB2284-AE01. $19.20 FOB ZS @5K (Std), XS $20.70, XL $22.70. LT 12-16 wk. ~200 units in 40-45 days off-shelf. FDA DXN K241351. SDK received. Samples delivered Porto. PLD approach confirmed. Plan A/B timeline received Apr 9: Plan A (Sword artwork + physical GS) Jul 13, Plan B (Transtek artwork, no GS) Jun 29. ✅ WHITE BOX CONFIRMED Apr 13 (BU + Design alignment). Full-color box standard for PLD, +$0.30-$1.50/unit, +10-14 days packaging testing. Cuffs: no logos, remove TeleRPM only. Manual: change logo/company info, keep functional content/layout. Need PDF with Pantone codes. ✅ Finance/NetSuite: CLOSED Apr 20 — vendor record created, PO issuance unblocked. ✅ LoE (Model Equivalence Affidavit, notarized) delivered Apr 15: BB2284-AE01 confirmed under K241351 by substantial equivalence to TMB-2092-G. SQA closure unblocked. Artwork die-lines + feedback shared by Mika Apr 15, revised artwork with Pantone codes sent Apr 15 22:25. ⚠️ Labelling blocked: FCC Responsible Party, Distributed by vs Manufactured for, UDI-DI ownership pending Sarah Hamid formal classification (OI created, Blocked, deadline Apr 22). Sarah agreed with Bianca's PLD analysis Apr 15. Sofia: "keep Transtek on label = not Legal Manufacturer." QMS-updated SQA V0.2 resent Apr 17. Labelling correction sent Apr 17: full distributor address required per 21 CFR 801.1(a) — "Distributed by: Sword Health, Inc., 615 Gladiola St, Salt Lake City, UT 84104." ✅ ISTA 2A CONFIRMED Apr 20 (Mika: "full carton has already passed ISTA 2A testing") — OI closeable. NDA Sword Inc. (Zip #3213): In Progress — Bradley reviewing (pinged Apr 20). SCA (Jira Legal): blocked — Jira portal requires PO number, but SCA is prerequisite for PO; escalate directly to Bradley. ⚠️ SQA v0.2: Mika checking diff doc with legal (Apr 20 02:04) — awaiting. Qualio SQM draft created Apr 20 (Risk: Critical, Sponsor: Elena Cavallini VP QARA); awaiting Sofia for Supplier Management Record + Approvers fields.
- **Unique Scales**  - MANUFACTURER (Shenzhen). BIA scale CF635BLE dual-freq selected. $8.76 FOB SZ @20K. LT 35-40 days. FDA FRI+PUH. SDK received. BLE name "SWORD_PULSE". Dual-freq upgrade in progress. Proforma requested Apr 8. DHL shipping label sent Apr 9 (to Kenny + Li Qiong). Die-line files received Apr 9 (sticker, carton, inner box, user manual). ✅ WHITE BOX CONFIRMED Apr 13 (BU + Design alignment). ✅ Finance/NetSuite: CLOSED Apr 20 — vendor record created, PO issuance unblocked (João Linhares approved Apr 17). QTA V0.2 shared Apr 17 via regulatory thread (⚠️ email had "Hi Mika" salutation error — content clear, no correction sent). NDA Sword Inc. (Zip #3214): In Progress — Bradley reviewing (pinged Apr 20). SCA (Jira Legal): blocked — same circular dependency as Transtek; escalate to Bradley directly. ISTA capability asked Apr 17 (OI 345b4a7d…3797) — no response yet. ⚠️ Open items email sent to Queenie Apr 20 22:32 (CC: Sofia + Paulo): QTA/SQA scope, ISTA testing confirmation, ISO 9001/13485 certs, US packaging standards, CF635BLE sample label. Qualio SQM draft created Apr 20 (Risk: Critical, Sponsor: Elena Cavallini VP QARA); awaiting Sofia for Supplier Management Record + Approvers fields.

## Quote Received (1)
- **Urion Technology**  - MANUFACTURER (Shenzhen). BP cuffs U807/U80K/U80M $9.90-$12.00, U81Y $13.00 FOB SZ @20K. FDA DXN. LT 30-35 days (+5-7 days for first branded order). Samples delivered Porto. Custom sample in production with Sword logo. Miki sent invoice + panel design Apr 15. DHL label sent Apr 15 for custom sample shipment. ⚠️ STRATEGIC BACKUP: Urion LT ~5-6 weeks branded vs Transtek 12-16 weeks. Keep warm pending custom sample delivery.

## Rejected (9)
- Xinrui Group, Yimi Life, Finicare, Yilai Enlighting, Daxin Health, Hingmed, Zewa Inc, Ullwin, A&D Medical (was Fallback; Status → Rejected Apr 18, NDA → Not Required; no rejection email sent)
- Audit: Notes condensed on Xinrui, Yilai, Daxin, Zewa (history removed, 2-line max enforced)

## Rejected (1)  - Intermediary
- IPADV  - Notes condensed (audit). On hold pending Jorge direction. NDA Status set to "Not Required" (rejected).

## Key Decisions  - Apr 8 (GU Alignment Meeting)
- PO authorization confirmed: Transtek BPM + Unique Scales BIA
- PLD approach confirmed by Kevin Wang
- Kevin mandated Sword-branded packaging
- Paulo Alves assigned as PM
- SQA mandatory for both suppliers
- Gantt: Scale ready Jul 7, BPM air Sep 20, BPM sea Nov 1

## Key Decisions  - Apr 13 (BU + Design Alignment)
- ✅ WHITE BOX confirmed for all Pulse devices (BPM + Scale). Reason: green tone discrepancies unavoidable across manufacturers when devices bundled — white eliminates mismatch risk.
- Plan B/C confirmed: no die-cut/material changes, no extra testing required.
- Sofia Lourenço (Expert Quality Systems Engineer) added to project — supporting regulatory + SQA/QTA supplier contracts.
- Emails sent to Mika (Transtek) + Queenie (Unique Scales) to communicate white box decision.

## Closed OIs (Apr 9 Audit)
- Xinrui/Alicn FDA relationship: Closed (Xinrui rejected, no longer relevant).
- IFU/Labeling: Answered. PLD approach confirmed Apr 8. Sword creates own IFU/labels/packaging.
- FDA Operating Model: Answered. PLD confirmed by Kevin Wang. SQA mandatory. Anand escalated legal/finance to Hugo + Aaron.

## Open Actions
- Legal contracts: open Jira tickets via service desk (portal 15/group 217). Need banking details + legal name from suppliers. Jorge: wait for Finance & Legal review before PO contracts.
- QTA vs SQA: Jorge confirmed different things. PLD = critical supplier, needs both. Transtek SQA template already shared with Bianca.
- Qualio page for suppliers: Andreia can do when she returns.
- Finance: create supplier records via ticket. Catarina to identify Finance stakeholder.
- Design team: Marta Valente engaged in #pulse-packaging-artwork. Shared device photos + Transtek constraints. Manual artwork: keep functional content/layout, change logo/company only.
- Kevin confirmed: devices ship separately (cuff or scale +/- band, never all 3). Remove TeleRPM from cuffs, no other logos.
- Packaging path decision (Apr 10 Slack + Apr 13 BU/Design meeting): Kevin approved air freight. WHITE BOX confirmed for all devices — keeps die-cuts/materials unchanged (Plan B/C), no extra testing. Communicated to Mika + Queenie Apr 13.
- Confirm BLE name with Transtek (only Unique Scales confirmed)
- Pedro: 5 Notion comment threads on BIA Scale Testing page -- all replied Apr 9. Page updated: Test Protocol rewritten with session definitions, consensus bias sentence clarified.
- Jorge: awaiting reply on Urion background option. IPADV: Jorge will handle in person (meeting Mon/Tue)
- Jorge: prioritize closing with Transtek + Unique Scales
- Kevin Wang: T2D Expansion email (glucometers + CGMs for H2 2026)  - unread, needs response
- Anand: Legal/Finance PLD alignment email to Hugo + Aaron  - Jorge says wait for their review before PO
