# Kaia Suppliers — Context File
# Last synced: 2026-05-14T00:15
# Schema: v1
# Note: All Kaia sourcing decisions gated on Caio + Max (memory `project_kaia_dependency`).

## Active (5)

### Tiger Fitness
- status: Under Review (pending de-facto rejection; status change deferred)
- nda: Not Required
- currency: USD
- unit_cost: 2.80
- tooling_cost: null
- last_outreach: 2026-05-13
- open_ois: 0
- next: Status update to Rejected pending. Rejection email sent May 13 (07:44 + 08:11) — both bounced (eva@tigerfitness.net.cn invalid). Decision communicated; no live channel to confirm receipt.
- blocker: Eva's email address invalid; rejection cannot be delivered.
- notes: |
  MANUFACTURER (Shanghai, CN). PVC yoga mats. Pricing @5K EXW: 3mm $2.80, 6mm $3.65,
  8mm $4.55. Branded samples delivered NYC 2026-03-30. New initiative fabric mat RFQ
  sent 2026-05-05 (different product from PVC scope). Eva follow-up May 7: requesting
  mat image + PVC timeline confirmation. May 13: rejection email sent twice — both
  bounced (eva@tigerfitness.net.cn no longer valid). De-facto rejected; DB status
  remains Under Review until alternative contact or final decision logged.

### Second Page Yoga
- status: Under Review
- nda: Not Required
- currency: USD
- unit_cost: 2.39
- tooling_cost: null
- last_outreach: 2026-05-11
- open_ois: 0
- next: ZIP PO #3511 in progress (correct amount $100K → $16,730). LRE-1957 MSA filed. Jerry onboarding in Zip (bank data upload pending). 4imprint backup if delays.
- blocker: null
- notes: |
  MANUFACTURER (Hefei, CN). PVC yoga mats. Pricing @5K EXW: 3mm $2.39, 6mm $3.39,
  8mm $4.39. Sea freight DDP ~$1.25-$3.00/un. Fernando FCL @5k $1.95/un confirmed
  (lowest freight of CN suppliers). New initiative RFQ + budget target $5-7 sent
  2026-05-07. PU material eliminated per André feedback. May 8: order intent confirmed
  (7K units: 2K air + 5K sea; payment by May 11). Revised pricing pending from Jerry.
  May 9: Jerry confirmed 12d air + 10d sea from payment. May 11: Andre emailed Jerry
  re Zip vendor onboarding (bank data upload step). Caio opened Zip PO #3511 ($100K).
  May 12: Max flagged ZIP amount correction needed ($100K → $16,730 per André Portugal).
  LRE-1957 Jira MSA filed. Anand engaging finance. 4imprint backup track confirmed by Caio.

### ProImprint
- status: Under Review
- nda: Not Required
- currency: USD
- unit_cost: 9.99
- tooling_cost: null
- last_outreach: 2026-04-21
- open_ois: 0
- next: Decision gated on Max/Caio
- blocker: Production slot cannot be held indefinitely (James pressing)
- notes: |
  US reseller. $9.99/un all-in (3mm only). James pressing for production decision
  2026-04-16 — slot cannot be held indefinitely. No reply sent — decision gated on
  Max/Caio.

### Nimbl
- status: Shortlisted
- nda: Not Required
- currency: USD
- unit_cost: 13.15
- tooling_cost: null
- last_outreach: 2026-05-07
- open_ois: 0
- next: Active fulfillment partner. Fulfillment transition plan confirmed (OI closed 2026-05-05).
- blocker: null
- notes: |
  Fulfillment partner (Salt Lake City, US). Price range $13.15-$17.15/un. Saves $2.68/un
  vs SV Direct. Established relationship, Kaia fulfillment in progress. Also loops into
  M-Band (Nimbl boxes for TransPak — memory `project_nimbl_boxes_transpak`).

### 4imprint
- status: Blocked
- nda: Not Required
- currency: USD
- unit_cost: 11.58
- tooling_cost: null
- last_outreach: null
- open_ois: 0
- next: Benchmark only — to be replaced
- blocker: Incumbent being transitioned out
- notes: |
  Current supplier (benchmark). $11.58/un + SV Direct. FLC ~$27-31/un. Kept as reference
  until Max/Caio confirm replacement.

## Rejected (8)

- 365 Wholesale, MOWIN Yoga, Amazfit/Zepp, Crestline, Fitbit/Google, RAZR, Ecosophia,
  Umicca.

## Key Decisions Pending

- Max/Caio: supplier selection (3mm confirmed May 5) + Nimbl transition.
- Caio flagged UHC audit risk for China vendors.
- Fernando: independent freight quotes for 6mm/8mm (carton dims available).

## Open Actions (ISC-level)

- Kaia sourcing gated on Caio/Max — André does not advance unilaterally (memory
  `project_kaia_dependency`).
- Standing risk: thickness decision overdue; ProImprint slot pressure rising.
- New initiative (fabric mat): budget target $5-7/mat sent to Second Page Yoga (May 7).
  Tiger Fitness capability for fabric mat TBD (awaiting image review by Eva).
