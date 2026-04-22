# Pulse Suppliers — Context File
# Last synced: 2026-04-22T20:30
# Schema: v1

## Active (3)

### Transtek Medical
- status: Shortlisted
- nda: In Progress
- currency: USD
- unit_cost: 19.20
- tooling_cost: null
- last_outreach: 2026-04-22
- open_ois: 3
- next: Chase Bradley on NDA + SCA escalation; await Sofia SQA legal review; await Mika scale (GBF-2008-B1) quote
- blocker: Labelling classification (Sarah Hamid, OI 343b4a7d…4c39 deadline 2026-04-22)
- notes: |
  MANUFACTURER (Zhongshan, CN). Entity: Guangdong Transtek Medical Electronics Co., Ltd
  (corrected 2026-04-20, Bradley notified). BP cuff BB2284-AE01. FOB ZS @5K (reference):
  Std $19.20, XS $20.70, XL $22.70. LT 12-16 wk. ~200 units in 40-45 days off-shelf.
  FDA DXN K241351. SDK + samples received Porto. PLD approach confirmed.

  Plan A/B received 2026-04-09: Plan A (Sword artwork + physical GS) 2026-07-13,
  Plan B (Transtek artwork, no GS) 2026-06-29. White box confirmed 2026-04-13
  (BU + Design). Full-color box +$0.30-1.50/unit + 10-14d testing. Cuffs: no logos,
  remove TeleRPM only. Manual: change logo/company info, keep functional content/layout.
  Needs PDF with Pantone codes. Artwork die-lines received 2026-04-15; revised with
  Pantone sent same day 22:25.

  Finance/NetSuite CLOSED 2026-04-20: vendor record created, PO issuance unblocked.
  LoE (Model Equivalence Affidavit, notarized) delivered 2026-04-15: BB2284-AE01
  confirmed under K241351 by substantial equivalence to TMB-2092-G. ISTA 2A CONFIRMED
  2026-04-20 (Mika: full carton already passed). SQA closure unblocked on LoE side.

  Labelling BLOCKED: FCC Responsible Party, Distributed by vs Manufactured for, UDI-DI
  ownership pending Sarah Hamid formal classification. Sarah agreed with Bianca's PLD
  analysis 2026-04-15. Sofia: "keep Transtek on label = not Legal Manufacturer."
  QMS-updated SQA V0.2 resent 2026-04-17. Labelling correction sent 2026-04-17:
  "Distributed by: Sword Health, Inc., 615 Gladiola St, Salt Lake City, UT 84104"
  (per 21 CFR 801.1(a)).

  NDA Sword Inc. (Zip #3213): In Progress — Bradley reviewing (pinged 2026-04-20).
  SCA (Jira Legal): blocked — portal requires PO number but SCA is PO prerequisite;
  escalate to Bradley directly. SQA v0.2: Mika checking diff with legal (2026-04-20 02:04).
  Qualio SQM draft created 2026-04-20 (Risk: Critical, Sponsor: Elena Cavallini VP QARA);
  awaiting Sofia for Supplier Management Record + Approvers fields.

  SCALE PATH (new 2026-04-21 23:17): GBF-2008-B1 sourcing inquiry sent to Mika as alt
  path to Unique Scales (Kevin Wang-authorized). Asked about full-Sword branding + FDA
  path, MSRP timeline, MOQ, golden sample schedule, ISTA, packaging. Awaiting reply.

### Unique Scales
- status: Shortlisted
- nda: In Progress
- currency: USD
- unit_cost: 9.24
- tooling_cost: null
- last_outreach: 2026-04-22
- open_ois: 2
- next: Chase Bradley on NDA + SCA; await QARA direction on UDI-DI declaration-of-equivalence (D336721 importer add — pivot confirmed Apr 22)
- blocker: UDI-DI refused by Unique Scales 2026-04-21 (QARA escalation pending)
- notes: |
  MANUFACTURER (Shenzhen, CN). BIA scale CF635BLE dual-freq selected. Pricing FOB SZ:
  $9.24/unit @5K ($46,200 total), $8.76/unit @20K ($175,200 total). LT 35-40 days.
  FDA FRI+PUH. SDK received. BLE name "SWORD_PULSE". Dual-freq upgrade in progress.

  Proforma requested 2026-04-08. DHL shipping label sent 2026-04-09 (to Kenny +
  Li Qiong). Die-line files received 2026-04-09 (sticker, carton, inner box, user manual).
  White box confirmed 2026-04-13.

  Finance/NetSuite CLOSED 2026-04-20: vendor record created, PO issuance unblocked
  (João Linhares approved 2026-04-17). QTA V0.2 shared 2026-04-17 via regulatory thread
  (email had "Hi Mika" salutation error — content clear, no correction sent).

  NDA Sword Inc. (Zip #3214): In Progress — Bradley reviewing (pinged 2026-04-20).
  Bradley comment 2026-04-20 17:52 asking for Shenzhen address. SCA blocked same as
  Transtek. ISTA capability asked 2026-04-17 (OI 345b4a7d…3797).

  Open-items email sent to Queenie 2026-04-20 22:32 (CC: Sofia + Paulo): QTA/SQA scope,
  ISTA testing, ISO 9001/13485 certs, US packaging standards, CF635BLE sample label.
  Qualio SQM draft created 2026-04-20 (Risk: Critical, Sponsor: Elena Cavallini);
  awaiting Sofia for SMR + Approvers fields.

  Queenie replied 2026-04-21 08:24+08:30 on 6-point email. Substantive answers:
  (1) ISTA in own lab, ~20pp Chinese docs translation pending. (2) QTA with their edits
  sent. (3) ISO certs "we got all" — needs her to send. (4) **UDI-DI REFUSED** —
  declaration-of-equivalence template offered instead (regulatory escalation to
  Sofia / #pulse-qara on 2026-04-21). (5) US packaging: "use what we sent". (6) LT
  35-40 working days, gated on 30% deposit + final packing details. Revised QTA v0.2
  (Sofia edits + Appendix II) sent to Queenie 2026-04-21 22:20.

### Urion Technology
- status: Quote Received
- nda: Signed
- currency: USD
- unit_cost: 9.90
- tooling_cost: null
- last_outreach: 2026-04-15
- open_ois: 2
- next: Await custom sample delivery; maintain warm backup posture
- blocker: null
- notes: |
  MANUFACTURER (Shenzhen, CN). BP cuffs U807 $9.90, U80K/U80M $9.90-$12.00, U81Y $13.00
  FOB SZ @20K (only tier quoted — @5K re-quote not yet requested). FDA DXN.
  LT 30-35 days (+5-7 days first branded order). Samples delivered Porto. Custom sample
  in production with Sword logo. Miki sent invoice + panel design 2026-04-15. DHL label
  sent 2026-04-15 for custom sample shipment.

  STRATEGIC BACKUP: Urion LT ~5-6 weeks branded vs Transtek 12-16 weeks. Keep warm
  pending custom sample delivery. Sofia ESH/BHS OI 345b4a7d…66d5 + regulatory gap pack
  OI 345b4a7d…e1f5 both deadline 2026-04-24.

## Rejected (10)

- Xinrui Group, Yimi Life, Finicare, Yilai Enlighting, Daxin Health, Hingmed, Zewa Inc,
  Ullwin, A&D Medical (Status → Rejected 2026-04-18, NDA → Not Required; no rejection
  email sent).
- IPADV (intermediary, on hold pending Jorge direction; NDA → Not Required).

Notes condensed (2-line max) on Xinrui, Yilai, Daxin, Zewa per 2026-04-09 audit.

## Key Decisions

- 2026-04-08 (BU Alignment): PO authorization for Transtek BPM + Unique Scales BIA. PLD
  approach confirmed by Kevin Wang. Kevin mandated Sword-branded packaging. Paulo Alves
  assigned PM. SQA mandatory. Gantt: Scale ready Jul 7, BPM air Sep 20, BPM sea Nov 1.
- 2026-04-13 (BU + Design): WHITE BOX confirmed for all Pulse devices (BPM + Scale).
  Reason: green tone discrepancies unavoidable across manufacturers when bundled — white
  eliminates mismatch risk. Plan B/C confirmed: no die-cut/material changes, no extra
  testing. Sofia Lourenço added to project for regulatory + SQA/QTA.
- 2026-04-15 (Legal): Sarah Hamid + Bianca agreed on PLD legal framework (private label
  distributor, Sword Inc. as importer). Finance Jira status TBD.
- 2026-04-20 (Finance): Zip #3139 Transtek + #3145 Unique Scales + #3134 Arrow all
  FULLY APPROVED. NetSuite vendor records created. PO issuance unblocked on both sides.
- 2026-04-21 (Regulatory): Queenie refused to add Sword SKU to Unique Scales FDA
  registration — offered declaration-of-equivalence only. Escalated to QARA (Sofia DM
  in PT; #pulse-qara with Elena/Sarah/Bianca/Sofia tagged). Transtek GBF-2008-B1 scale
  inquiry opened as alt path.

## Open Actions (ISC-level)

- Legal contracts: Jira tickets via service desk (portal 15/group 217). Need banking
  details + legal name from suppliers. Wait for Finance & Legal review before PO
  contracts (per Jorge).
- QTA vs SQA: PLD = critical supplier, needs both. Transtek SQA template already with
  Bianca.
- Qualio page: Andreia to handle on return (now unblocked via Sofia + Elena sponsor).
- Finance: supplier records via ticket (Catarina to identify Finance stakeholder).
- Design: Marta Valente engaged in #pulse-packaging-artwork. Manual artwork rules: keep
  functional content/layout, change logo/company only.
- Kevin confirmed: devices ship separately (cuff or scale +/- band, never all 3). Remove
  TeleRPM from cuffs, no other logos.
- Packaging path (2026-04-10 Slack + 2026-04-13 BU/Design): Kevin approved air freight.
  White box for all devices keeps die-cuts/materials unchanged (Plan B/C), no extra
  testing.
- Confirm BLE name with Transtek (only Unique Scales confirmed).
- Pedro: 5 Notion comment threads on BIA Scale Testing page — all replied 2026-04-09.
- Jorge: awaiting reply on Urion background option. IPADV: Jorge handling in person.
- Jorge: prioritize closing Transtek + Unique Scales.
- Kevin Wang: T2D Expansion email (glucometers + CGMs H2 2026) — needs response (parked).
- Anand: Legal/Finance PLD alignment email to Hugo + Aaron — Jorge says wait for review.
