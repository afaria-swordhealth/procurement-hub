# M-Band Suppliers — Context File
# Last synced: 2026-04-30T22:00
# Schema: v1

## Active (18)

### Vangest
- status: Quote Received
- nda: Signed
- currency: EUR
- unit_cost: 3.348
- tooling_cost: 467228
- unit_cost_native: EUR 3.080
- tooling_cost_native: EUR 429850
- cost_basis: "@255K, converted USD at FX 1.087"
- last_outreach: 2026-04-14
- open_ois: 0
- next: Deprioritized per André feedback (Helmut Schmid pushy pattern)
- blocker: null
- notes: |
  Plastic Housings (PT). Revised quote 2026-04-09: EUR 3.080/unit @255k + EUR 429,850
  tooling. Quote expired 2026-04-14. Consolidated inline in supplier page 2026-04-14
  (sub-pages [MERGED]). Skip follow-ups in mail-scan/housekeeping per André memory
  `feedback_vangest_deprioritized`.

### SHX Watch
- status: Quote Received
- nda: Signed
- currency: USD
- unit_cost: 1.360
- tooling_cost: 0
- cost_basis: "@200K+ (confirmed)"
- last_outreach: 2026-04-11
- open_ois: 0
- next: Validate custom samples when delivered
- blocker: null
- notes: |
  Straps. ~$1.36/strap MP (200k+/yr). Pull force confirmed >70N. Stock samples picked up
  2026-04-11. Custom samples in progress. DB fields EUR 1.250 / 0 @200K (reference
  convention is @5K — needs re-quote or correction flag).

### MCM
- status: Quote Received
- nda: Signed
- currency: EUR
- unit_cost: 0.123
- tooling_cost: 35870
- unit_cost_native: EUR 0.113
- tooling_cost_native: EUR 33000
- cost_basis: "flat (no volume tier), converted USD at FX 1.087"
- last_outreach: 2026-04-17
- open_ois: 0
- next: Hold until more sheet-metal quotes received
- blocker: null
- notes: |
  Sheet Metal (PT). Quote 2026-04-10 (OR-050/26): €0.113/unit, €33k NRE, 12wk LT,
  FCA-MCM. Consolidated inline 2026-04-14. Gustavo confirmed 2026-04-17: AISI 301+C1000
  acceptable, 0.05mm flatness acknowledged. Engineering OI closed.

### GAOYI
- status: Quote Received
- nda: Signed
- currency: USD
- unit_cost: 0.484
- tooling_cost: 155
- cost_basis: "@200K EXW"
- last_outreach: 2026-04-16
- open_ois: 1
- next: Review full tier pricing (20K/25K/50K/200K received 2026-04-16)
- blocker: null
- notes: |
  Packaging. Honda Holdings group. Quote 2026-04-09 (updated 2026-04-13): $0.803/set @5K.
  DB fields €0.739 / 143 (FX 0.92). Re-quote sent 2026-04-14. Jessica asked about order
  frequency + delivery address 2026-04-15; André replied frequency TBD, delivery address
  to be discussed at Tangxia meeting. Full tiers received 2026-04-16 — internal review
  in progress.

### Lihua
- status: Quote Received
- nda: Not Required
- currency: USD
- unit_cost: 0.694
- tooling_cost: 0
- cost_basis: "@200K EXW"
- last_outreach: 2026-04-16
- open_ois: 1
- next: Confirm with Jorge whether outreach remains "on hold"
- blocker: Notion Outreach flagged "on hold — confirm with Jorge"
- notes: |
  Packaging. Quote 2026-04-13: $0.994/set @5K (Rigid Box Lid = bundle per quote note 6).
  DB fields €0.915 / 0 (existing tooling). Re-quote sent 2026-04-14, bug fixed (Base/Trays
  no longer TBC). Jessica flagged missing 50k/200k pricing 2026-04-15. Full tiers
  (25K/50K/200K) received 2026-04-16 — internal review in progress.

### Ribermold
- status: RFQ Sent
- nda: Signed
- currency: EUR
- unit_cost: null
- tooling_cost: null
- last_outreach: 2026-04-24
- open_ois: 1
- next: Clarification meeting 2026-04-22
- blocker: Quote finalization (adhesive supplier consultation in progress)
- notes: |
  Plastic Housings (PT). Meeting 2026-04-15: magnets confirmed NdFeB N45 nickel-plated,
  automated assembly line in development (single-button operation), IP68 as primary
  validation (no separate pull-force test), pin assembly method TBD (press-fit or adhesive).
  Ribermold finalizing quote with adhesive supplier recs. OI 33eb4a7d…d871 — clarification
  meeting 2026-04-22.

### TransPak
- status: Quote Received
- nda: Signed
- currency: USD
- unit_cost: 0.770
- tooling_cost: 2915
- cost_basis: "@200K EXW (Move = Mind). Tooling: $1,457.50 Move + $1,457.50 Mind = $2,915 total"
- last_outreach: 2026-04-28
- open_ois: 0
- next: Review vs GAOYI/Lihua; clarify sample dimension mismatch before progressing
- blocker: null
- notes: |
  Packaging (SE Asia). Quote received 2026-04-28 from Kevin Dempsey. 6 tiers: 10K/30K/
  50K/100K/200K/300K EXW. LT: first order 30-45 WD, repeat 30-40 WD. Boxes received
  (Move+Mind) appear not to be latest dimension/artwork — quote based on white box dims
  + RFQ artwork. Prices in attachment image, not yet entered into DB.

### JXwearable
- status: Under Review
- nda: Signed
- currency: USD
- unit_cost: 1.85
- tooling_cost: 2000
- cost_basis: "@200K+ FOB (50K+ $1.94 / 100K+ $1.90 / 200K+ $1.85)"
- last_outreach: 2026-04-29
- open_ois: 0
- next: Compare vs SHX Watch ($1.36 silicone). Different material (nylon+TPU+SUS304+ABS).
- blocker: null
- notes: |
  Straps. Quote JX20260429 (2026-04-29): nylon strap + TPU plug + SUS304 buckle + ABS
  stopper. FOB tiers $1.94/$1.90/$1.85. Tooling $2,000. MOQ 3,000. LT 25-40d. T/T advance
  or L/C at sight. +36% vs SHX silicone, different material category.

### Uartrónica
- status: Quote Received
- nda: Signed
- currency: EUR
- unit_cost: 24.685
- tooling_cost: 7625
- unit_cost_native: EUR 22.71
- tooling_cost_native: EUR 7015
- cost_basis: "@210K annual (closest to 200K), converted USD at FX 1.087"
- last_outreach: 2026-04-24
- open_ois: 1
- next: Chase re-quote (deadline moved to Apr 24)
- blocker: null
- notes: |
  PCBAs (PT). ~EUR 22.07/unit + EUR 7,112 tooling (Dec 2025 indicative). Sofia Amaro
  confirmed re-quote delivery "early next week" (2026-04-17). OI 33eb4a7d…818d deadline
  2026-04-24 (moved from Apr 22). DB promoted to Quote Received on indicative data; fresh
  re-quote still pending.

### Quantal
- status: RFQ Sent
- nda: Signed
- currency: EUR
- unit_cost: null
- tooling_cost: null
- last_outreach: 2026-04-28
- open_ois: 0
- next: Await quote from Miguel Costa
- blocker: null
- notes: |
  Sheet Metal. NDA fully executed 2026-04-14. Zip #3006 fully approved 2026-04-14. RFQ
  package sent to Miguel Costa 2026-04-14.

### Xinrui Group — Plastic Housings
- status: Quote Received
- nda: Signed
- currency: USD
- unit_cost: 1.7494
- tooling_cost: 41261
- cost_basis: "@50K EXW (200K not quoted)"
- last_outreach: 2026-04-29
- open_ois: 0
- next: DFM flag → Gustavo/Miguel (Light Pipe buckle positions). Request 200K tier from Asher.
- blocker: null
- notes: |
  Plastic Housings. OEM (China), 21yr experience. PI XR260429002 (unit) + XR260429001
  (tooling). Units EXW: $1.8982 @10K / $1.8065 @30K / $1.7494 @50K. Tooling NRE $41,261
  (Pogo Pins Plate $3,861 + Top+Light Pipe $17,550 + Rear+Lens $19,850). T0: 35-40 days.
  Mold life 300K. Post-processing excl. DFM: Light Pipe buckle positions need design mod.
  Valid 30d (expires 2026-05-29). Payment units 50/50; tooling 50/30/20.

### Xinrui Group — Sheet Metal
- status: RFQ Sent
- nda: Signed
- currency: USD
- unit_cost: null
- tooling_cost: null
- last_outreach: 2026-04-15
- open_ois: 0
- next: Await quote from Asher
- blocker: null
- notes: |
  Sheet Metal. OEM (China). RFQ sent 2026-04-15. Quote pending. NDA shared with
  Xinrui Group — Plastic Housings (SHUFENG ZHANG, Dropbox Sign, Zip #3146).

### Xinrui Group — Packaging
- status: RFQ Sent
- nda: Signed
- currency: USD
- unit_cost: null
- tooling_cost: null
- last_outreach: 2026-04-15
- open_ois: 0
- next: Await quote from Asher (secondary scope)
- blocker: null
- notes: |
  Packaging — secondary scope, TBD post-capability. OEM (China). RFQ sent 2026-04-15.
  Quote pending. NDA shared with Xinrui Group — Plastic Housings.

### Xinrui Group — Straps
- status: RFQ Sent
- nda: Signed
- currency: USD
- unit_cost: null
- tooling_cost: null
- last_outreach: 2026-04-15
- open_ois: 0
- next: Await quote from Asher (secondary scope)
- blocker: null
- notes: |
  Straps — secondary scope, TBD post-capability. OEM (China). RFQ sent 2026-04-15.
  Quote pending. NDA shared with Xinrui Group — Plastic Housings.

### Falcon Electronica
- status: Contacted
- nda: Not Started
- currency: EUR
- unit_cost: null
- tooling_cost: null
- last_outreach: null
- open_ois: 0
- next: NDA setup if engagement progresses
- blocker: null
- notes: |
  PCBAs (via Manuel Beito). No NDA yet.

### Sanmina
- status: Contacted
- nda: Not Started
- currency: USD
- unit_cost: null
- tooling_cost: null
- last_outreach: null
- open_ois: 0
- next: No active follow-up (OI closed 2026-04-13)
- blocker: No contact established
- notes: |
  PCBAs. No contact established. OI closed 2026-04-13.

### Electronica Cerler
- status: Contacted
- nda: Not Started
- currency: EUR
- unit_cost: null
- tooling_cost: null
- last_outreach: 2026-04-18
- open_ois: 1
- next: Follow-up per OI deadline 2026-04-28 (Pedro PT trip until 2026-04-30)
- blocker: null
- notes: |
  PCBAs (via Manuel Beito). No NDA yet. OI 344b4a7d…a9dc deadline 2026-04-28.

### Novares
- status: Identified
- nda: Not Required
- currency: EUR
- unit_cost: null
- tooling_cost: null
- last_outreach: null
- open_ois: 1
- next: Direct-contact search (LinkedIn / Ribermold / MCM referrals) — deadline 2026-04-21 TODAY
- blocker: No direct contact established
- notes: |
  Plastic Housings. Re-engage pending. OI 33fb4a7d…c45c deadline 2026-04-21.

## Rejected (10)

- Braloba, 3DWays, TERA Plastics, Watts Electronics, Celoplas, Edaetech, Carfi Plastics,
  Kimball Electronics, AbleOne, CONKLY (rejected 2026-04-10 — TPU cannot be secured to
  strap; capability gap confirmed by Nikki; kept for future projects).

## Key Decisions

- 2026-04-09 (Audit): Currencies set — Quantal/MCM/Ribermold/Vangest/Uartrónica/Novares
  → EUR. TransPak/Lihua/GAOYI → USD.
- 2026-04-14: Unit Cost (EUR) + Tooling Cost (EUR) populated for 4 suppliers @5K ref tier
  (FX 0.92 USD→EUR). Quote sub-pages consolidated inline (Lihua/GAOYI/MCM/Vangest).
- 2026-04-14: 2027 forecast = 200K combined Move+Mind sets. Re-quote sent to Lihua + GAOYI
  for 20/25/50/200K tiers (MCM on hold pending more quotes).
- 2026-04-14: New config `.claude/config/fx-rates.md` + procedure
  `.claude/procedures/fill-cost-fields-on-quote.md`.

## Open Actions (ISC-level)

- AMS-OSRAM 30wk PO overdue 19d. Escalation gated on Jorge (1:1 2026-04-27). OI
  345b4a7d…81c3 deadline 2026-04-22 (overdue).
- Arrow Electronics Zip #3252 FULLY APPROVED 2026-04-24 (Manuel Pacheco 13:15 → Rúben
  Silva finalize 17:17). EUC forms procurement fully unblocked — unlocks Future / Avnet
  channel execution.
- Nimbl boxes for TransPak: 3 M-Band boxes from Nimbl SLC needed (memory
  `project_nimbl_boxes_transpak`).
- M-Band is hardware (physical wearable); Move + Mind are programs sharing it (memory
  `project_mband_hardware`).
- EU distributor channel single-source: Future Electronics primary, Avnet secondary
  (OI 345b4a7d…81c3; legacy page deleted 2026-04-17).
- Strap comparison 2026-04-23 (Miguel): Wintech ~$2.30 · JHX $1.36 · Celestica $0.58 ·
  Bitron $2.00 · Titoma $2.22. RFQ average ~$1.50. Titoma not moving forward (Jorge).
- Keenfinity strap sourcing: feedback sent to Keenfinity 2026-04-23 (Gustavo). SHX Watch
  + JXwearable remain as independent strap alternatives.

## Summary

- 28 suppliers total. 18 active (8 Quote Received, 5 RFQ Sent, 1 Under Review, 3 Contacted,
  1 Identified), 10 rejected.
- NDAs signed (GAOYI, MCM, SHX Watch, Uartrónica, Vangest, JXwearable, Quantal, Ribermold,
  TransPak, Xinrui Group [shared across 4 part splits]). 3 not started (Cerler, Falcon,
  Sanmina). 2 not required (Lihua, Novares). 5/5 part categories covered (Housings,
  PCBAs, Sheet Metal, Straps, Packaging). Active strap pool: SHX Watch + JXwearable.
  Xinrui Group split into 4 part-specific pages (Plastic Housings, Sheet Metal,
  Packaging, Straps) on 2026-04-30.
