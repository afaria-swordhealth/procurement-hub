# Change Log

## 2026-04-11

### supplier-comms — 2026-04-11 — Outreach + OI writes (auto-approved outreach, approved OI)
- Transtek Medical (311b4a7d-7207-8110): Outreach — appended Apr 11 bullet (Mika completed all Zip vendor tasks, reply pending).
- SHX Watch (311b4a7d-7207-8184): Outreach — appended Apr 11 bullet (sample pickup acknowledged, two-track approach confirmed).
- A&D Medical (311b4a7d-7207-8131): Outreach — SKIPPED. Apr 11 entry already present (NDA sent to Brad Wiltz via Dropbox Sign).
- Transtek OI — Finance vendor onboarding (33eb4a7d-7207-814d): Status Blocked → In Progress. Context prepended: Mika completed Zip tasks Apr 11.

### notion-ops — 2026-04-11 — OI Triage (Pulse A&D + Urion)
- A&D Medical — 7 biometrics OI (33eb4a7d-7207-81a4): Closed. UC-450BLE rejected, CF635BLE selected.
- Urion — ESH/BHS certs OI (33eb4a7d-7207-81ee): Closed. Not a formal requirement.
- Urion — EMC gaps U807/U81Y OI (33eb4a7d-7207-8149): Closed. Models deprioritized.
- Urion — IEC 80601-2-30 U80K/U80M OI (33eb4a7d-7207-81c3): Closed. Models eliminated.
- Urion — U807 IEC outdated OI (33eb4a7d-7207-8124): Closed. Device already FDA cleared.
- Urion — U81Y IEC 60601-1-11 OI (33eb4a7d-7207-8107): Closed. U81Y eliminated.
- Urion — CES freshly issued OI (33eb4a7d-7207-8162): Closed. Not proactively actionable.
- Urion — U81Y LCD→LED OI (33eb4a7d-7207-81ea): Closed. U81Y eliminated.
- A&D Medical — UA-651BLE no memory OI (33eb4a7d-7207-81f2): Context updated. Queued for Jill email.

### system — 2026-04-11T09:35 — /log-sent procedure update
- `.claude/commands/log-sent.md`: added Phase 5b (OI Cross-Reference). After writing Outreach entries, query open OIs for each supplier. Propose Context updates if email is relevant. Requires André's approval before writing.
- `CLAUDE.md`: /log-sent step 7 added to match.

### supplier-comms — 2026-04-11T09:30 — /log-sent
- **Transtek Medical** (311b4a7d-7207-8110-83dc-ce0e90e4de5f): Outreach Apr 11 entry added (Zip 2FA troubleshooting sent to Mika).
- **Xinrui Group / M-Band** (33fb4a7d-7207-8120-a2c6-cd8c6440d2c8): Outreach Apr 11 entry updated (scope focused after Asher reply, housings + sheet metal confirmed, straps/packaging deferred).

### supplier-comms — 2026-04-11T08:50 — /log-sent
- Unique Scales: Apr 11 entry (Zip reg started, company details sent)
- A&D Medical: Apr 11 entry (NDA sent to Brad Wiltz via Legal)
- Daxin Health: Apr 11 entry (T2D scope clarification, thread kept warm)
- Xinrui Group: Apr 10 expanded (T2D reply) + Apr 11 entry (M-Band pivot)
- Ullwin: Apr 10 entry (close-out, not selected)
FLAG: Xinrui M-Band DB page creation pending André approval.

### notion-ops — 2026-04-11T00:30 — Context sync (wrap-up)

Queried all 3 Supplier DBs (Pulse, Kaia, M-Band) and compared against context files.

**Findings:** No status changes since last sync. All supplier statuses in context files match Notion state.
- Pulse: 13 suppliers confirmed. Shortlisted (3), Quote Received (1), Rejected (9). No delta.
- Kaia: 13 suppliers confirmed. Shortlisted (1), Under Review (3), Blocked (1), Rejected (8). No delta.
- M-Band: 24 suppliers confirmed. CONKLY Rejected status already reflected. No new delta.

**Writes:**
- context/pulse/suppliers.md: Last synced header updated to 2026-04-11T00:30
- context/kaia/suppliers.md: Last synced header updated to 2026-04-11T00:30
- context/mband/suppliers.md: Last synced header updated to 2026-04-11T00:30

---

### notion-ops — 2026-04-11 — Pulse OI bulk create (15 OIs) + Priority field + supplier page cleanup (approved by André)

**Step 1: Priority field added to Open Items DB**
- Added "Priority" SELECT field to OI DB (collection://505b7f08-8816-4bf7-b77a-7f232b52d0a0)
- Options: Critical (red), High (orange), Medium (yellow), Low (blue)
- Field did not previously exist.

**Step 2: 15 Pulse OIs created**
All created in OI DB, Status=Pending, Project=Pulse (310b4a7d-7207-8145-962e-e5a9c875dc0d).

| # | Item | Priority | Owner | Deadline |
|---|------|----------|-------|----------|
| 1 | Urion — ESH/BHS clinical certs: hard blocker or waivable? | Critical | João Quirino | 2026-04-17 |
| 2 | Urion — ISO 81060-2 results report missing (GAP 1) | Critical | André Faria | 2026-04-22 |
| 3 | Urion — U807/U81Y EMC gaps (GAP 4 + GAP 6) | Critical | André Faria | 2026-04-22 |
| 4 | Urion — IEC 80601-2-30 missing for U80K + U80M (GAP 5) | Critical | André Faria | 2026-04-22 |
| 5 | Urion — U807 IEC 60601-1 outdated standard edition (GAP 3) | High | André Faria | 2026-04-22 |
| 6 | Urion — K160019 scope: confirm U807/U80K/U80M coverage + cuff range | High | André Faria | 2026-04-22 |
| 7 | Urion — U81Y IEC 60601-1-11 US national differences missing (GAP 7) | High | André Faria | 2026-04-22 |
| 8 | Unique Scales — PUH acceptable for Pulse scale? | High | João Quirino | 2026-04-20 |
| 9 | A&D Medical — UA-651BLE no memory: firmware fix or hardware limitation? | Medium | André Faria | 2026-04-17 |
| 10 | Unique Scales — monitor potential Urion intermediary activity | Medium | André Faria | 2026-04-30 |
| 11 | Urion — Clinical Equivalence Statements freshly issued (GAP 2) | Medium | João Quirino | 2026-04-24 |
| 12 | Urion — U81Y LCD to LED display change in CES (GAP 8) | Medium | João Quirino | 2026-04-24 |
| 13 | A&D Medical — send final quantities + delivery dates to Jill | Medium | André Faria | 2026-04-17 |
| 14 | A&D Medical — confirm if 7 scale biometrics meet Pulse clinical requirements | Low | João Quirino | 2026-04-20 |
| 15 | A&D Medical — decide white-label vs branded for initial rollout | Low | André Faria | 2026-04-24 |

**Step 3: Inline ## Open Items bullets cleared from 11 Pulse supplier pages**
Replaced stale bullet content with: "Open items tracked in the central Open Items DB. See linked view above."

| Page | Page ID | Status |
|------|---------|--------|
| Transtek Medical | 311b4a7d-7207-8110 | Cleaned |
| Unique Scales | 311b4a7d-7207-8130 | Cleaned |
| Daxin Health | 311b4a7d-7207-81a8 | Cleaned |
| Finicare | 311b4a7d-7207-815d | Cleaned |
| Hingmed | 311b4a7d-7207-81a4 | Cleaned |
| IPADV | 326b4a7d-7207-81e5 | Cleaned |
| Ullwin | 311b4a7d-7207-81e5 | Cleaned |
| Xinrui Group | 311b4a7d-7207-812b | Cleaned |
| Yilai Enlighting Ltd | 311b4a7d-7207-8133 | Cleaned |
| Yimi Life | 311b4a7d-7207-812f | Cleaned |
| Zewa Inc. | 311b4a7d-7207-81ca | Cleaned |

NOT touched: Urion Technology, A&D Medical (active suppliers, per instructions).

## 2026-04-10

### notion-ops — 2026-04-10 — M-Band OI backfill (20 OIs) + inline bullet cleanup (approved by André)

**Step 1: Priority field**
- Priority field already present on OI DB (collection://505b7f08-8816-4bf7-b77a-7f232b52d0a0) with options Critical/High/Medium/Low. No action needed.

**Step 2: 20 M-Band Open Items created**
All linked to project: M-Band — Tier Parts CMs (311b4a7d-7207-8167-b4b2-cd9f88167d04)

| # | Item | Priority | Owner | Deadline | OI ID |
|---|------|----------|-------|----------|-------|
| 1 | Quantal — submit NDA countersignature via Zip | Critical | André Faria | 2026-04-14 | 33eb4a7d-7207-81b8-9f67-cdf96725c657 |
| 2 | Uartrónica — awaiting re-quote with updated BOM and COO-X volumes | High | André Faria | 2026-04-17 | 33eb4a7d-7207-818d-b800-d7653fae491b |
| 3 | Uartrónica — LOA Nordic components via Avnet, resolve route | High | Jorge Garcia | 2026-04-17 | 33eb4a7d-7207-8197-b56f-c8480dd4f90d |
| 4 | MCM — confirm flatness tolerance 0.05mm vs spec | High | Miguel Pais | 2026-04-18 | 33eb4a7d-7207-816d-9a63-f87ffac8fd16 |
| 5 | MCM — confirm AISI 301 +C1000 raw material acceptability | High | Miguel Pais | 2026-04-18 | 33eb4a7d-7207-8132-a4a5-c31212009f0b |
| 6 | TransPak — provide CAD/spec inputs to unblock quote | High | Miguel Pais | 2026-04-18 | 33eb4a7d-7207-816f-afae-c4c3444d8ae0 |
| 7 | Lihua — confirm with Jorge whether to continue engagement | High | André Faria | 2026-04-14 | 33eb4a7d-7207-8129-99f4-db58ef8746b7 |
| 8 | Ribermold — quote expected, follow up if not received by Apr 14 | High | André Faria | 2026-04-14 | 33eb4a7d-7207-81a1-882e-d26f594ed871 |
| 9 | SHX Watch — engineering review of DFM docs | High | Miguel Pais | 2026-04-21 | 33eb4a7d-7207-8186-ae0c-e961a34b31bb |
| 10 | Falcon Electronica — establish direct contact via Manuel Beito | Medium | André Faria | 2026-04-17 | 33eb4a7d-7207-816c-9917-c8744296ec53 |
| 11 | Electronica Cerler — establish contact via Manuel Beito (cerler@ bounced) | Medium | André Faria | 2026-04-17 | 33eb4a7d-7207-812b-94ce-e035daf2f8c3 |
| 12 | GAOYI — 6 open questions from quote review, awaiting reply | Medium | André Faria | 2026-04-17 | 33eb4a7d-7207-81e0-aa09-ec616b77c858 |
| 13 | JXwearable — quote pending, plug placement decision ongoing | Medium | André Faria | 2026-04-17 | 33eb4a7d-7207-8143-862f-e9509a1097c8 |
| 14 | Vangest — site visit date pending from Helmut/Sérgio | Medium | Helmut Schmid | 2026-04-21 | 33eb4a7d-7207-8112-8ac4-c1d878528df9 |
| 15 | SHX Watch — confirm MOQ per PO | Medium | André Faria | 2026-04-21 | 33eb4a7d-7207-8146-97bf-dd0c027e97f8 |
| 16 | TransPak — C-16 Customer Application Form not applicable for EU entity | Medium | Miguel Pais | 2026-04-18 | 33eb4a7d-7207-81df-ba03-d7dc25a09915 |
| 17 | Sanmina — no BD contact established, escalate or park | Low | André Faria | 2026-04-17 | 33eb4a7d-7207-81dd-9655-e0f66a080cf7 |
| 18 | Novares — retry outreach, web form failed | Low | André Faria | 2026-04-17 | 33eb4a7d-7207-811b-be4f-cea488519d5a |
| 19 | SHX Watch — tooling decision after sample evaluation | Medium | André Faria | 2026-04-30 | 33eb4a7d-7207-819c-a956-e146b3b0a1e8 |
| 20 | MCM — negotiate payment terms to NET45 | Low | André Faria | 2026-04-25 | 33eb4a7d-7207-8100-8c95-d553c00d1517 |

**Step 3: Inline ## Open Items bullet cleanup (8 pages)**
Replaced stale/resolved inline bullets with: "Open items tracked in the central Open Items DB."

| Page | Page ID | Action |
|------|---------|--------|
| Carfi Plastics | 311b4a7d-7207-81d7-be7c-cf8e12aecd18 | Removed 1 self-closed bullet (Rejected) |
| Kimball Electronics | 313b4a7d-7207-810c-86bc-f992ce0e8636 | Removed 1 self-closed bullet (Rejected) |
| CONKLY | 311b4a7d-7207-8107-8901-f47e23282d84 | Removed 2 self-closed bullets (Rejected) |
| TERA Plastics | 311b4a7d-7207-8188-9711-c1ee6def6f5f | Removed 1 stale bullet (Rejected) |
| MCM | 311b4a7d-7207-8118-b800-dc7c754f84b6 | Removed resolved quote bullet, ported 3 valid OIs to DB |
| Vangest | 311b4a7d-7207-8176-b31b-fb3b680d0e16 | Removed resolved feedback bullet + site visit bullet (both ported to DB) |
| SHX Watch | 311b4a7d-7207-8184-93ff-d14e8fa128a4 | Removed all 4 bullets (3 valid ported to DB, 1 resolved) |
| GAOYI | 328b4a7d-7207-81a1-9762-da42c6cdad29 | Removed resolved RFQ bullet, ported follow-up OI to DB |

### notion-ops — 2026-04-10 — Kaia OI backfill + inline bullet cleanup (approved by André)

#### Step 1: Priority field
- Priority field already present in OI DB (Critical/High/Medium/Low). No action needed.

#### Step 2: 8 Kaia Open Items created in central OI DB
- OI-1 (Critical/Decision): "Kaia — Max Strobel sample feedback (Tiger, Second Page, ProImprint)" — Deadline 2026-04-15 — Max Strobel — ID: 33eb4a7d-7207-8161-8677-dff470972664
- OI-2 (Critical/Blocker): "Kaia — Caio UHC audit risk: China-sourced suppliers may be disqualified" — Deadline 2026-04-17 — André Faria — ID: 33eb4a7d-7207-816f-9b9e-c38dd6bc96d9
- OI-3 (High/Action Item): "Kaia — Fernando independent freight quote (Tiger + Second Page 6mm/8mm)" — Deadline 2026-04-14 — André Faria — ID: 33eb4a7d-7207-8161-bbb0-da9ebdef97d7
- OI-4 (High/Question): "China Tiger Fitness — clarify CNF freight ambiguity ($4,998 vs $6,555)" — Deadline 2026-04-14 — André Faria — ID: 33eb4a7d-7207-81f9-b5a1-c6d49bd1316d
- OI-5 (Medium/Decision): "Kaia — Max decide: migrate fulfillment to Nimbl or stay with SV Direct" — Deadline 2026-04-17 — Max Strobel — ID: 33eb4a7d-7207-8146-bfba-ee8c60a08353
- OI-6 (Medium/Action Item): "China Tiger Fitness — confirm DDP SLC freight for 6mm @5k" — Deadline 2026-04-18 — André Faria — ID: 33eb4a7d-7207-81bc-afa6-e8cec1871e3c
- OI-7 (Medium/Question): "Nimbl — confirm fulfillment rate for yoga mat (volumetric weight)" — Deadline 2026-04-18 — André Faria — ID: 33eb4a7d-7207-8131-a895-d31044beb022
- OI-8 (Low/Question): "Second Page Yoga — confirm Incoterms before PO" — Deadline 2026-04-18 — André Faria — ID: 33eb4a7d-7207-8120-b6c4-e5d6b6e4ae6b

#### Step 3: Inline bullet cleanup (5 supplier pages)
- **Crestline** (318b4a7d-7207-816e-b6c4-dfab1470c318): 2 stale bullets removed. Supplier Rejected. Replaced with central DB pointer.
- **Ecosophia** (318b4a7d-7207-81db-a3c7-ec2080fc1426): 2 stale bullets removed. Supplier Rejected. Replaced with central DB pointer.
- **Umicca Sport Products** (322b4a7d-7207-81b4-b43d-f9a9d712cee3): 1 stale bullet removed. Supplier Rejected. Replaced with central DB pointer.
- **Nimbl** (318b4a7d-7207-81da-98d2-cab0be45e37b): 2 checked (resolved) bullets + 2 active bullets removed. Active items ported to OI DB (OI-5, OI-7). Replaced with central DB pointer.
- **ProImprint** (318b4a7d-7207-81ad-a2fe-f396b121cd36): 1 checked bullet + 1 stale open bullet + 1 low-priority note removed. Active item ported to OI DB (OI-1 covers Max feedback). Replaced with central DB pointer.

### notion-ops — 2026-04-10 — Open Items DB structural upgrade (approved by André)

**Task 1: Supplier field added to Open Items DB**
- Added "Supplier" as RICH_TEXT field to Open Items DB (collection://505b7f08-8816-4bf7-b77a-7f232b52d0a0)
- Approach: text fallback (not relation). Notion does not support a single relation field spanning 3 separate DBs. Text field used as canonical approach.

**Task 2: Supplier field populated on existing open OIs (12 of 19)**
- A&D Medical — NDA countersign and file (33eb4a7d-7207-81e9-8a95-ca32479ca886): Supplier = "A&D Medical"
- Transtek Zip — unblock Mika's access (33eb4a7d-7207-81ba-a5cf-ffe55796c3fe): Supplier = "Transtek"
- Transtek — Finance vendor onboarding ticket (33eb4a7d-7207-814d-855d-c91c07c69059): Supplier = "Transtek"
- Transtek — Qualio supplier page (33eb4a7d-7207-8140-a453-fe9b7a31ca05): Supplier = "Transtek"
- Transtek — SQA template QARA review (33eb4a7d-7207-81ab-b23f-ee791f5185dc): Supplier = "Transtek"
- Transtek — Supplier Compliance Agreement (SCA) via Jira (33eb4a7d-7207-8174-b81b-c608a90e396f): Supplier = "Transtek"
- Transtek — Supplier Quality Agreement (SQA) (33eb4a7d-7207-81d7-8057-d08bce2fc93c): Supplier = "Transtek"
- Unique Scales — Finance vendor onboarding ticket (33eb4a7d-7207-8161-b77c-e65aad326ee2): Supplier = "Unique Scales"
- Unique Scales — Qualio supplier page (33eb4a7d-7207-8150-8561-d27a0fba79db): Supplier = "Unique Scales"
- Unique Scales — Supplier Compliance Agreement (SCA) via Jira (33eb4a7d-7207-81b2-a1f4-cf5d110194d1): Supplier = "Unique Scales"
- Unique Scales — Supplier Quality Agreement (SQA) (33eb4a7d-7207-81ee-934c-c2101da38ffb): Supplier = "Unique Scales"
- Vangest — Decide on revised quote before Apr 14 expiry (33eb4a7d-7207-81d1-845d-c563cc79e7b8): Supplier = "Vangest"
- 7 OIs had no supplier prefix (internal decisions, packaging, SDK, legal) — Supplier field left blank.

**Task 3: Linked views in supplier pages**
- MCP limitation confirmed: inline linked database views cannot be created inside page content via MCP (notion-update-page does not support <database> block creation; notion-create-view permission not granted).
- All 23 active supplier pages have inline bullet ## Open Items sections. None have a linked DB view.
- No writes made to supplier page content for Task 3. See output report for full list.

### notion-ops — 2026-04-10T22:31 — Supplier Overview page edits (approved by André)
Page: Supplier Overview — Apr 2026 (33eb4a7d-7207-81ec-96b4-febdb83bd379)
- **Uartronica (PCBAs):** Quote Summary updated to clarify Dec 2025 vintage and formal quote pending on updated BOM.
- **3DWays (Plastic Housings):** Quote Summary appended with note that quote data exists but supplier is rejected — disregard for sourcing.
- **Carfi Plastics (Plastic Housings):** Quote Summary appended with note that quote data exists but supplier is rejected — disregard for sourcing.

### notion-ops — 2026-04-10T21:00
- Created child page "Supplier Overview — Apr 2026" inside M-Band project page (311b4a7d-7207-8167-b4b2-cd9f88167d04)
- New page ID: 33eb4a7d-7207-81ec-96b4-febdb83bd379
- URL: https://www.notion.so/33eb4a7d720781ec96b4febdb83bd379
- Scope: 24 M-Band suppliers across 5 part categories. Pricing sourced from MCM (Quote -- 10 Apr 2026), SHX Watch (Quote section), GAOYI (Quote -- 9 Apr 2026), Uartronica (Quote section). Requested by Andre for Miguel Pais (Sr. TPM) briefing.

### /log-sent — 2026-04-10T20:55
- Scan window: last 24h sent (a.faria@sword.com / a.faria@swordhealth.com)
- 50 sent emails reviewed across Pulse, Kaia, M-Band, plus internal/logistics/Zip.
- No new outreach entries written. All supplier milestones from the last 24h are already reflected in Notion outreach sections (Transtek Apr 10 onboarding/CoR/Zip blocker, Unique Scales Apr 10 ship + onboarding, Urion Apr 10 infinite-loop pushback + keep-warm, Xinrui/Yimi/Yilai/Finicare/Ullwin/Daxin/Hingmed Apr 10 close-outs, MCM Apr 10 quote ack, SHX Watch Apr 10 DHL label issued, GAOYI Apr 10 follow-up, Quantal Apr 10 NDA, CONKLY Apr 10 close-out, Ribermold Apr 9 quote ETA, Vangest Apr 9 revised quote ack, Lihua Apr 10 Lihe update, Tiger Fitness Apr 9 packing ack, Second Page Yoga Apr 9 packing ack).
- Skipped (routine): Transtek "Testing email" at 10:53, Tiger Fitness Apr 10 holding reply, Mika Zip access reassurance, several read receipts, internal BPM sourcing follow-up to Kevin Wang, Kaia thickness update to Max, Avnet Renesas LT request (M-Band COO-CN distributor track), Zip invoice email.

### Nimbl (Kaia) — Status + Notes update

- **Nimbl** (318b4a7d-7207-81da-98d2-cab0be45e37b): Status `Contacted` → `Shortlisted`. Notes updated to "FULFILLMENT (Salt Lake City, UT). Current Sword fulfillment partner. Kaia yoga mat fulfillment in progress." Rationale: established relationship, Kaia fulfillment already in progress.
- **context/kaia/suppliers.md**: Section header updated `## Current Supplier (1)` → `## Shortlisted (1)`. Nimbl entry note updated to reflect status change.



### Housekeeping — Phases 4, 5, 6 (Notes + OI + Drift + Email)

#### Notes Fixed (AUTO-EXECUTED — André approved)
- **Vangest** (311b4a7d-7207-8176-b31b-fb3b680d0e16): Notes updated to "MANUFACTURER (Marinha Grande, PT). Plastic injection + 2K moulding + assembly. Quote valid Apr 14."
- **MCM** (311b4a7d-7207-8118-b800-dc7c754f84b6): Notes updated to "MANUFACTURER (Braga, PT). Precision stamping + CNC. 0.02mm tolerance, 500k pcs/month."

#### Phase 4 — Open Items (AUTO + REPORT)
- No OIs linked to rejected suppliers found. No auto-closures executed.
- No OIs overdue (all deadlines Apr 14+).
- No OIs with stale context (all created/updated Apr 10).
- No propose-close candidates identified.

#### Phase 5 — Context Drift (REPORT ONLY)
- **Kaia/suppliers.md**: Nimbl listed as "Current Supplier (1)" in context. Notion Status field shows "Contacted". Status drift detected. No write executed.

#### Phase 6 — Unanswered Emails (REPORT ONLY)
- All supplier emails received in the last 7 days have replies within 48h, except ProImprint (intentional ignore per André's direction). No flags raised.

### Housekeeping — Phases 1, 2, 3

#### Phase 1: Outreach Maintenance (AUTO-EXECUTED)
- **MCM** (311b4a7d-7207-8118-b800-dc7c754f84b6): Fixed broken `\<toggle summary>` to valid `<details><summary>` block in Outreach archive.
- **Vangest** (311b4a7d-7207-8176-b31b-fb3b680d0e16): Updated stale Outreach summary line (was "Last: 1 Apr", now reflects Apr 9 revised quote).
- **ProImprint** (318b4a7d-7207-81ad-a2fe-f396b121cd36): Condensed Outreach — 9 visible entries exceeded 7-entry threshold. Moved 5 Mar 12 entries into archive toggle. Visible entries reduced to 7.

#### Phase 3: DB Field Hygiene (AUTO-EXECUTED)
- **CONKLY** (311b4a7d-7207-8107-8901-f47e23282d84): NDA Status Executed → Not Required (Rejected supplier, auto per housekeeping rules).
- **3DWays** (311b4a7d-7207-815a-9bfd-c50dbedca9fd): NDA Status Executed → Not Required (Rejected supplier, auto per housekeeping rules).
- **Carfi Plastics** (311b4a7d-7207-81d7-be7c-cf8e12aecd18): NDA Status Executed → Not Required (Rejected supplier, auto per housekeeping rules).

### Open Items — Triage (Apr 10 EOD)

#### Closed
- **EVALUATE: Samples**: Closed. Primary suppliers selected Apr 8. Resolution logged.

#### Deadlines Updated
- **SOURCE: Yoga mat alternatives**: Deadline extended Mar 20 → May 1.
- **DECIDE: Yoga mat thickness**: Deadline set Apr 15. Note: follow up with Max if no response by then.

#### Status → Blocked (critical path to PO)
- Legal/Finance PLD alignment, Transtek Finance onboarding, Unique Scales Finance onboarding, Transtek SCA, Unique Scales SCA, Transtek Zip (Mika access)

#### Status → In Progress
- Pulse packaging artwork: Marta Valente engaged.

### Late Evening Session (post-23h)

#### Open Items DB — Pulse Backfill
Created 15 OIs in Open Items DB (collection://505b7f08-8816-4bf7-b77a-7f232b52d0a0), all with Project = Pulse:
- Transtek: Finance onboarding, SCA, Qualio, SQA
- Unique Scales: Finance onboarding, SCA, Qualio, SQA
- Transtek Zip — unblock Mika access (Blocker)
- A&D Medical — NDA countersign
- SDK review — Transtek BB2284-AE01
- SDK test — CF635BLE dual-freq prototype
- Pulse packaging artwork
- Full-color box decision
- Legal / Finance PLD alignment (Blocker)

#### System Rules — Open Items Discipline
- **CLAUDE.md:** added §4d "Open Items Discipline" (when to create, field schema, Context as running log, review cadence, OI vs promises.md).
- **New file:** .claude/procedures/create-open-item.md — checklist, DB IDs, Context append-only examples, closing rules.
- **.claude/agents/notion-ops.md:** Open Items Policy block added.
- **.claude/agents/supplier-comms.md:** Open Items creation rule added.
- **.claude/commands/mail-scan.md:** new step 3 (propose Create OI / Update OI Context); recommendation table extended.
- **.claude/commands/warm-up.md:** Phase 2 OI query now sorts by Deadline asc, surfaces overdue, flags stale Context (>14d).

#### Notion New-Projects Verification
- Pulse T2D page (33eb4a7d-7207-811d) — already exists, no duplicate created.
- M-Band COO-CN page (33eb4a7d-7207-816f) — already exists, no duplicate created.

#### Daily Log
- **Daily Log Apr 10** (33eb4a7d-7207-818e-9265-fb79b098aff1): Late evening session appended.


### Wrap-Up (Apr 10 EOD)

#### Outreach Updated (Notion)
- **Urion Technology** (311b4a7d-7207-816c-a1e2-e019f5ead33e): Apr 10 entry updated — added keep-warm reply sent after Miki response. Summary line updated.
- **Transtek Medical** (311b4a7d-7207-8110-83dc-ce0e90e4de5f): Apr 10 entry updated — added Certificate of Registration sent + zip file access link. Summary line updated.

#### Context Files Synced
- **context/pulse/suppliers.md**: Urion entry updated (keep-warm Apr 10, custom sample ~Apr 22).
- **context/mband/suppliers.md**: Full rewrite — CONKLY moved to Rejected, MCM + GAOYI promoted to Quote Received, SHX Watch DHL note added, summary updated (15 active, 10 rejected).

#### Daily Log Updated
- **Daily Log Apr 10** (33eb4a7d-7207-818e-9265-fb79b098aff1): Afternoon/evening session appended. Pulse close-outs, Urion keep-warm, Transtek onboarding, MCM/GAOYI/SHX Watch M-Band activity, ISC project pages, OI proposals.

### Notion Write — CONKLY Rejected (Apr 10)
- **CONKLY** (311b4a7d-7207-8107-8901-f47e23282d84): Status RFQ Sent → Rejected. Notes updated (TPU capability gap). OI closed.

### Cross-Check Writes Executed — 2026-04-10

Writes A–F approved by André and executed:
- A: Vangest — Removed 2 stale inline OI bullets (Apr 3 expiry) from Vangest page body. Created new OI "Vangest — Decide on revised quote before Apr 14 expiry" (ID: 33eb4a7d-7207-81d1-845d-c563cc79e7b8, Deadline: Apr 14, Owner: André Faria, Decision).
- B: MCM — Outreach entry appended: Apr 10 quote acknowledgment with flagged flatness tolerance and raw material alternative.
- C: Lihua — Outreach entry appended: Apr 10 Jessica Costa inbound (awaiting sourcing team, proposal under internal review).
- D: Transtek — Outreach entry appended: Apr 10 Zip login blocker (SMS 2FA, Ruben advising) + finance onboarding ask to Mika and Queenie.
- E: Open Items — Created "Transtek — SQA template QARA review" (ID: 33eb4a7d-7207-81ab-b23f-ee791f5185dc, Owner: Bianca Lourenco, Deadline: Apr 15, Action Item, Pulse).
- F: Open Items — Prepended Apr 10 context to "Full-color box decision" OI (33eb4a7d-7207-8172-a232-d4bfe3ec512e): Paulo Slack confusion, Andre callback needed, Kevin mid-July question, Paulo/Marta meeting Apr 13 14:30.

### Toggle Block Fix
Replaced broken `<toggle summary>` tags with valid `<details><summary>` blocks in Outreach archives.
- **Xinrui Group** (311b4a7d-7207-812b-bba5-ef7bbfcb13f2): Fixed (Feb 2026 - Mar 2026).
- **Unique Scales** (311b4a7d-7207-8130-9be9-cfcfa4254f1e): Fixed (Feb 2026 - Apr 1 2026).
- **A&D Medical** (311b4a7d-7207-8131-9327-dbb43bc85174): Fixed (Feb 2026 - Mar 30 2026).
- **Urion Technology** (311b4a7d-7207-816c-a1e2-e019f5ead33e): Fixed (Feb 2026 - Apr 4 2026).
- **ProImprint** (318b4a7d-7207-81ad-a2fe-f396b121cd36): Fixed (Mar 9 2026 - Mar 12 2026).
- **China Tiger Fitness** (318b4a7d-7207-81e6-b9d9-d3c0cf3c26c3): Fixed (Mar 2026).
- **Second Page Yoga** (318b4a7d-7207-81fd-98b6-c746265e7ab1): Fixed (Mar 2026).
- **Quantal** (311b4a7d-7207-8100-ba8f-cd264b786ea9): Fixed (Feb 2026 - Mar 18 2026).
- **CONKLY** (311b4a7d-7207-8107-8901-f47e23282d84): Fixed (Feb 2026 - Mar 9 2026).
- **MCM** (311b4a7d-7207-8118-b800-dc7c754f84b6): Fixed (Feb 2026 - Mar 3 2026).
- **Ribermold** (311b4a7d-7207-8160-8fb5-c78a234d8f76): Fixed (Mar 10 2026 - Mar 11 2026).
- **Vangest** (311b4a7d-7207-8176-b31b-fb3b680d0e16): Fixed (Feb 2026 - Mar 17 2026).
- **TransPak** (311b4a7d-7207-817c-9db0-e61e06db9e4e): Fixed (Feb 2026 - Mar 19 2026).
- **SHX Watch** (311b4a7d-7207-8184-93ff-d14e8fa128a4): Fixed (Feb 2026 - Mar 30 2026).
- **JXwearable** (311b4a7d-7207-8185-adf3-c22bcc2a330d): Fixed (Feb 2026 - Mar 6 2026).
- No toggle found (skipped): Yimi Life, Yilai Enlighting, Finicare, Hingmed, Daxin Health, Zewa, Ullwin, IPADV, 365 Wholesale, MOWIN Yoga, Amazfit/Zepp, Crestline, 4imprint, Fitbit/Google, Nimbl, Ecosophia, RAZR Marketing, Umicca, Braloba, 3DWays, TERA Plastics, Novares, Lihua, Watts Electronics, Celoplás, Edaetech, Uartrónica, Carfi Plastics, Kimball Electronics, Falcon Electronica, Sanmina, Electronica Cerler, AbleOne, GAOYI.

### Notion Write — MCM Quote (Apr 10)
- **MCM** (311b4a7d-7207-8118-b800-dc7c754f84b6): Status updated RFQ Sent → Quote Received. Added ## Quote section (OR-050/26: €0.113/unit, €33k NRE, 12wk LT). Closed awaiting OI, added 3 new OIs (flatness, raw material, payment terms).
- **MCM subpage** (33eb4a7d-7207-816a-910e-fea4700002c3): Created "Quote -- 10 Apr 2026" with full pricing, tooling amortization table, exclusions, open points, Drive path.

### Notion Write — GAOYI Quote (Apr 10)
- **GAOYI** (328b4a7d-7207-81a1-9762-da42c6cdad29): Status updated RFQ Sent → Quote Received. Added ## Quote section with USD/RMB pricing tables. Closed RFQ OI, added follow-up OI (6 open questions).
- **GAOYI subpage** (33eb4a7d-7207-8199-b6ec-e4cf2333e9ae): Created "Quote -- 9 Apr 2026" with full component breakdown, open questions, and Drive file path.

### Notion Write — Close-out Outreach Entries (Apr 10)
- **Yimi Life** (311b4a7d-7207-812f-ac1f-dfd0bec1bc62): Apr 10 close-out logged. T2D seed planted. Note: 13+ visible entries, flag for /housekeeping archive.
- **Hingmed** (311b4a7d-7207-81a4-85cf-f9ea3b5c0b2f): Apr 10 close-out logged. T2D seed planted.

### Notion Write — Transtek Open Items (Apr 10)
- **Transtek Medical** (311b4a7d-7207-8110-83dc-ce0e90e4de5f): Added OI — Certificate of Registration required for Zip onboarding. André to request from Ruben Silva.

### Log-Sent (Session — Apr 10, second pass)

#### Outreach Entries Written
- **A&D Medical** (311b4a7d-7207-8131-9327-dbb43bc85174): Apr 9 -- NDA execution step: André confirmed Legal will send final NDA to Brad Wiltz via Dropbox Sign.
- **GAOYI** (328b4a7d-7207-81a1-9762-da42c6cdad29): Apr 9 -- Quote received from Jessica Lee. No reply sent yet.

### New Project Pages Created (Session — Apr 10)

- **Pulse T2D Expansion — Glucose Monitoring Devices** (33eb4a7d-7207-811d-9316-e18e202454cb): New project page created. Status: RFQ. Priority: High. Deadline: Dec 31 2026. Content: glucometer + CGM vendor shortlist, volumes, cost ranges, stakeholders, supply chain action items from Kevin Wang's Apr 8 email.
- **M-Band COO-CN** (33eb4a7d-7207-816f-93c7-de5d32209198): New project page created. Status: In Progress. Priority: High. Content: EU distributor channel (Future Electronics / Manuel Beito, Avnet / Sónia Sousa), active lead time and price increase topics (Nordic, Renesas, STM32, MPS, NXP, Diodes, GREPOW battery, SGMicro PCM, TI alt ICs).

### Log-Sent (Session A — Apr 11 morning)

#### Outreach Entries Written
- **Quantal** (311b4a7d-7207-8100-ba8f-cd264b786ea9): Apr 10 -- Quantal signed NDA received. André acknowledged, committed to countersign via Legal/Zip and share technical docs after signing. Archive condensed (14 Mar + 18 Mar moved to toggle).
- **Transtek Medical** (311b4a7d-7207-8110-83dc-ce0e90e4de5f): Apr 10 -- Supplier onboarding initiated. Requested legal name, address, IBAN, and PO email from Mika to register in Sword's procurement system (Zip). Acknowledged Transtek's buyer profile request.
- **Unique Scales** (311b4a7d-7207-8130-9be9-cfcfa4254f1e): Apr 10 -- Confirmed ship 4 samples with DHL label. Branding: logo files pending from Sword design team; supplier ID team to handle glass artwork. Appended: supplier onboarding initiated, requested legal name, address, IBAN, and PO email.
- **Urion Technology** (311b4a7d-7207-816c-a1e2-e019f5ead33e): Apr 10 -- André pushed back on SDK/BLE protocol policy. Flagged infinite loop: cannot develop app without protocol, cannot test device without app. Proposed Urion test with standard app and share BLE protocol. No payment until connectivity confirmed.
- **CONKLY** (311b4a7d-7207-8107-8901-f47e23282d84): Apr 10 -- Closed out: cannot manufacture M-Band TPU strap design. André replied: will keep contact for future projects. Archive condensed (6 Mar + 9 Mar moved to toggle).
- **Xinrui Group** (311b4a7d-7207-812b-bba5-ef7bbfcb13f2): Apr 10 -- Close-out sent. Supplier selection complete, not selected. T2D seed planted: asked about glucose meters and CGMs for future project.
- **Daxin Health** (311b4a7d-7207-81a8-8cfe-fcd60cff5a8e): Apr 10 -- Close-out sent. Supplier selection complete, not selected. T2D seed planted. Archive condensed (Feb 26 - Mar 23 moved to toggle, 7 visible).
- **Ullwin** (311b4a7d-7207-81e5-96aa-cbbe8f3844d8): Apr 10 -- Close-out sent. Supplier selection complete, not selected. T2D seed planted. Archive condensed (Feb 23 - Mar 26 moved to toggle, 7 visible).
- **Finicare** (311b4a7d-7207-815d-af96-e3deeb4d8d20): Apr 10 -- Close-out sent. Supplier selection complete, not selected. T2D seed planted. Archive condensed (Feb 25 - Mar 30 moved to toggle, 7 visible).
- **Yilai Enlighting** (311b4a7d-7207-8133-8b7d-cacd23e62570): Apr 10 -- Close-out sent. Supplier selection complete, not selected. T2D seed planted. Archive condensed (Feb 25 - Feb 26 moved to toggle, 7 visible).

### Housekeeping (Session B)

#### Outreach Maintenance (AUTO)
- **Transtek Medical** (311b4a7d-7207-8110-83dc-ce0e90e4de5f): Outreach reordered chronologically (Apr 8 Sent moved before Apr 9 entries).
- **Unique Scales** (311b4a7d-7207-8130-9be9-cfcfa4254f1e): Outreach reordered chronologically (Apr 9 DHL moved after Apr 8 entries).
- **CONKLY** (311b4a7d-7207-8107-8901-f47e23282d84): Outreach reordered chronologically (Apr 9 follow-up moved to bottom). Archive toggle consolidated. 7 visible entries.
- **JXwearable** (311b4a7d-7207-8185-adf3-c22bcc2a330d): Archive toggle expanded (Feb 26 - Mar 6). 7 visible entries (was 8).

#### Outreach Entries Written (Cross-Check)
- **MCM** (311b4a7d-7207-8118-b800-dc7c754f84b6): Apr 9 -- Daniel confirmed Maria Jose quote Apr 10.
- **Ribermold** (311b4a7d-7207-8160-8fb5-c78a234d8f76): Apr 9 -- Filipe confirmed quote next week.
- **TransPak** (311b4a7d-7207-817c-9db0-e61e06db9e4e): Apr 9 -- Kevin requested PVT samples, Andre replied.
- **Lihua** (311b4a7d-7207-8194-9b5c-d53388120e4a): Apr 9 -- Jessica Mind/Move clarification, Andre explained.

### Coverage Audit & Config Updates

#### slack-channels.md
- Added 4 people to DM scan: Kevin Wang (U02L4KTU1CH), Marta Valente (U094DN98DL1), Andreia Gomes (U01TACJ5SLB), Mariana Peixoto (U05F4TU91L0).
- Added 2 channels: #m-band_sourcing (C08170ETSKG), #pulse-isc (C0905Q7SFU2).
- Added 1 Group DM: André/Jorge/Miguel/Gustavo M-Band sourcing (C0AGZ2WNUEM).

#### domains.md
- Added GAOYI domains: gaoyipp.com + hondaholdings.com (alt). Added to M-Band Gmail filter.
- Added Second Page Yoga alt domain: secondpagetech.com. Added to Kaia Gmail filter.

#### warm-up.md
- Added Phase 3b: Sent Email Scan. Auto-scans André's sent emails at session start to catch outreach not logged in Notion.

### Log-Sent

#### Outreach Entries Written
- **Transtek Medical** (311b4a7d-7207-8110): Apr 9 -- New branding thread, SQA shared with Legal, packaging guidelines requested.
- **Vangest** (311b4a7d-7207-8176): Apr 9 -- Acknowledged revised quote, internal analysis pending.

#### Samples Status Updated
- **Unique Scales** (311b4a7d-7207-8130-9be9-cfcfa4254f1e): Samples Status "Requested" -> "Label Sent" (DHL label sent Apr 9).

#### Gmail Draft Created
- **Unique Scales** (huangchunlian@lefu.cc): Follow-up asking when samples will ship. Thread: 19d1b46a2fd4a11b. Draft ID: r-2935969466602757389.

#### DB Fields Fixed (AUTO)
- **Falcon Electronica** (313b4a7d-7207-812b-aa29-ff2dd1a43a72): Currency set to EUR (EU/Spain supplier).
- **Sanmina** (313b4a7d-7207-8158-aaf8-d24fa128719c): Currency set to USD (US supplier).
- **Electronica Cerler** (313b4a7d-7207-81a8-9e0c-e2299a27b0ea): Currency set to EUR (EU/Spain supplier).

## 2026-04-09

### Vangest  - Revised Quote Analysis (Session B)
- **Vangest** (311b4a7d-7207-8176-b31b-fb3b680d0e16): Created sub-page "Quote -- 9 Apr 2026 (Revised)" (33db4a7d-7207-8176-90cd-fc230bbba1aa). Updated DB fields: Tooling EUR 436,850 -> EUR 429,850, Unit Cost EUR 1.549 -> EUR 3.080. Quote section rewritten with revised data. Outreach entry added (Apr 9 Sonia revised quote). Notes updated.

### Daily Log  - Apr 09 (Session B append)
- **Daily Log Apr 09** (33cb4a7d-7207-810c-9dcb-eb3817849243): Appended Session B (afternoon Slack + housekeeping). Transtek Plan A/B timeline, full-color box decision, Marta artwork engagement, Jorge Legal/Finance guidance, Miguel SHX feedback, M-Band quote updates, housekeeping results, Gmail signature automation. Highlights updated.

### Notion Outreach  - 3 Milestone Entries Written
- **Unique Scales** (Pulse): Apr 9 -- DHL label sent to Queenie for CF635 dual-freq + 8-electrode sample shipment. Summary line updated.
- **Second Page Yoga** (Kaia): Apr 9 -- Packing details received from Jerry, shared with logistics. Summary line updated.
- **CONKLY** (M-Band): Apr 9 -- Follow-up sent on RFQ (no response since Mar 18). Summary line updated. 2 oldest entries archived into toggle (5 Mar x2).

### Gmail  - CONKLY Follow-up Draft
- **CONKLY** (nikki@conkly.com): Follow-up draft created. RFQ sent Mar 17, receipt confirmed Mar 18, no quote in 22 days. Thread: 19ce49ad53cddaf9.

### Context Files  - Drift Fixes
- **mband/suppliers.md**: Vangest (revised quote Apr 9), MCM (quote coming Apr 10), Ribermold (quote next week).

### Notion  - Transtek Medical (Kevin Decision)
- **Transtek Medical** (311b4a7d-7207-8110-83dc-ce0e90e4de5f): Added Kevin Wang branding decision to Quote section (OK to remove TeleRPM, full-color +10-14 days, Paulo assessing timeline).

### Notion  - Outreach Archiving (Session B)
Applied condensation rules to 9 supplier pages. Moved older entries into toggle archives, kept 7 most recent visible, added summary lines.
- **Vangest** (311b4a7d72078176b31bfb3b680d0e16): Archived 7 entries (Feb 23 - Mar 17). 7 visible. Summary line added.
- **Quantal** (311b4a7d72078100ba8fcd264b786ea9): Archived 7 entries (Feb 26 - Mar 13). 7 visible. Summary line added.
- **CONKLY** (311b4a7d720781078901f47e23282d84): Archived 6 entries (Feb 26 - Mar 5). 7 visible. Summary line added.
- **TransPak** (311b4a7d7207817c9db0e61e06db9e4e): Archived 6 entries (Feb 25 - Mar 19). Deduplicated Mar 31 entries. 7 visible. Summary line added.
- **JXwearable** (311b4a7d72078185adf3c22bcc2a330d): Archived 6 entries (Feb 26 - Mar 6). 9 visible. Summary line added.
- **MCM** (311b4a7d72078118b800dc7c754f84b6): Archived 5 entries (Feb 26 - Mar 3). 7 visible. Summary line added.
- **SHX Watch** (311b4a7d7207818493ffd14e8fa128a4): Already had archive toggle with 7 visible. Summary line updated.
- **Ribermold** (311b4a7d720781608fb5c78a234d8f76): Archived 2 entries (Mar 10 - Mar 11). 7 visible. Summary line added.
- **ProImprint** (318b4a7d720781ada2fef396b121cd36): Archived 8 entries (Mar 9 - Mar 12). 11 visible (reverse chrono, reordered to chrono). Summary line added.

### Notion  - Portuguese-to-English Translation (All Projects)
- **CONKLY** (311b4a7d720781078901f47e23282d84): Outreach Mar 17-18 entries translated from Portuguese.
- **MCM** (311b4a7d72078118b800dc7c754f84b6): Outreach Mar 17 entry translated from Portuguese.
- **Ribermold** (311b4a7d720781608fb5c78a234d8f76): Outreach Mar 16, Mar 19 entries translated from Portuguese.
- **TransPak** (311b4a7d7207817c9db0e61e06db9e4e): Outreach Mar 19 entry translated from Portuguese.
- **JXwearable** (311b4a7d72078185adf3c22bcc2a330d): Outreach Mar 11, Mar 17 entries translated from Portuguese.
- **Falcon Electronica** (313b4a7d7207812baa29ff2dd1a43a72): Outreach reminder translated from Portuguese.
- **Electronica Cerler** (313b4a7d720781a89e0ce2299a27b0ea): Outreach reminder translated from Portuguese.
- **ProImprint** (318b4a7d720781ada2fef396b121cd36): Outreach Mar 12 entry translated from Portuguese.
- **Urion Technology** (311b4a7d7207816ca1e2e019f5ead33e): Outreach archive Mar 14 entries translated from Portuguese.
- **M-Band project page** (311b4a7d-7207-8167-b4b2-cd9f88167d04): Removed Portuguese text at bottom of page.

### Log-Sent (EOD Apr 10 — third pass)

#### Outreach Entries Written
- **SHX Watch** (311b4a7d-7207-8184-93ff-d14e8fa128a4): Apr 10 -- DHL label issued and pickup scheduled for Apr 11 ~10:00 AM China time. Stock samples (3 pcs) in transit.

### Notion  - Suppliers DB (M-Band)
- **SHX Watch** (311b4a7d7207818493ffd14e8fa128a4): Notes field condensed. Removed NDA duplicate and reviewer names.
- **Braloba** (311b4a7d7207812caa4af4b07e6ba528): Notes field reformatted to TYPE (Location) standard.
- **JXwearable** (311b4a7d72078185adf3c22bcc2a330d): Outreach Mar 18 entry, corrected "Jason" to "Daisy".
- **CONKLY** (311b4a7d720781078901f47e23282d84): Added "Awaiting quote" to existing ## Open Items.
- **Ribermold** (311b4a7d720781608fb5c78a234d8f76): Added ## Open Items section with "Awaiting quote".
- **JXwearable** (311b4a7d72078185adf3c22bcc2a330d): Added ## Open Items section with "Awaiting quote".
- **Falcon Electronica** (313b4a7d7207812baa29ff2dd1a43a72): Added ## Open Items section with "Awaiting direct contact".
- **Electronica Cerler** (313b4a7d720781a89e0ce2299a27b0ea): Added ## Open Items section with "Awaiting direct contact".
- **Sanmina** (313b4a7d72078158aaf8d24fa128719c): Added ## Open Items section with "No BD contact established".

### Notion  - Suppliers DB (Pulse)
- **Urion Technology** (311b4a7d7207816ca1e2e019f5ead33e): Notes field condensed. Removed detailed K-numbers, kept flag.

### Notion  - Open Items DB
- **IFU / Labeling** (329b4a7d720781b6a608e14637ff287d): Status Answered -> Closed. Resolution line added to page body.
- **FDA Operating Model** (32cb4a7d720781a58a0fcf82334eb079): Status Answered -> Closed. Resolution line added to page body.

### Notion  - Daily Logs DB
- **Apr 06** (33ab4a7d72078109ae28fe9d3fbf467d): Status Draft -> Complete.
- **Apr 07** (33bb4a7d720781278d95db914ab52a30): Status Draft -> Complete.
- **Apr 08** (33cb4a7d720781acb0e0f9381d807b2e): Status Draft -> Complete.

### Notion  - Outreach (Log Sent)
- **Transtek Medical** (311b4a7d-7207-8110-83dc-ce0e90e4de5f): Apr 9 outreach entries added (Plan A/B timeline + SQA template received, new branding/packaging thread initiated).

### Housekeeping
- **Second Page Yoga** (318b4a7d-7207-81fd-98b6-c746265e7ab1): Outreach archive toggle created (Mar 2026). Summary line added. 5 visible entries (was 9).

### Kaia Page Deep Review + Summary Tab
- **Kaia Project Page** (313b4a7d-7207-810c-a19f-da03a61f8057): Comparison table rewritten (9 rows, all thicknesses, annual savings @20k). FLC link v4 to v6. Flags updated (Apr 9, stale items removed). Overview updated (annual volume, thickness line).
- **Tiger Fitness** (318b4a7d-7207-81e6-b9d9-d3c0cf3c26c3): DB Unit Price corrected $2.785 to $2.80.
- **Kaia_FLC_v6.xlsx**: Summary tab created (supplier comparison, FLC, savings %, annual savings projection @20k, quick win Nimbl $53k/year). All formula-driven from Tiger Fitness and Second Page tabs.
- **Gmail Draft**: Max Strobel pricing update + thickness decision email created (HTML table, annual savings, FLC v6 reference).

### Notion  - Kaia Deep Dive (Session A)
- **Tiger Fitness** (318b4a7d-7207-81e6-b9d9-d3c0cf3c26c3): Quote section (6mm/8mm carton dims added), Freight section (Eva CNF quotes + DDP limitation), Outreach (Apr 8 expanded, Apr 9 added), OI (freight clarification). DB Freight+Duties corrected $7.22 to $1.60 (sea).

### Daily Log  - Apr 09 (appended, final)
- **Daily Log Apr 09** (33cb4a7d-7207-810c-9dcb-eb3817849243): Appended: Transtek Plan A/B + SQA template received (files unreadable, reply sent). Paulo Alves Slack message sent (timeline corrections). Highlights updated (timeline review added).

### Daily Log  - Apr 09 (appended)
- **Daily Log Apr 09** (33cb4a7d-7207-810c-9dcb-eb3817849243): Appended Kaia Deep Dive session (supplier review, 3 Gmail drafts, Tiger Fitness Notion updates, FLC v6 created). ISC section updated (FLC evolution note). Highlights updated.

### Notion  - Outreach Maintenance (Audit)
- **SHX Watch** (311b4a7d-7207-8184-93ff-d14e8fa128a4): Outreach archive toggle created (Feb 2026 - Mar 30 2026). Summary line added. Portuguese entry translated. 19 to 7 visible entries.

### Notion  - Audit Phase 3 (DB Fields + OIs)

#### Notes Condensed (pricing removed, 2-line max enforced)
- **Transtek Medical** (311b4a7d-7207-8110-83dc-ce0e90e4de5f): Notes condensed. Removed FDA K-numbers, SDK status, samples status (all in DB fields).
- **Unique Scales** (311b4a7d-7207-8130-9be9-cfcfa4254f1e): Notes condensed. Removed operational details (30+ yrs, BLE+WiFi, SDK received).
- **A&D Medical** (311b4a7d-7207-8131-9327-dbb43bc85174): Removed "NDA signed" from Notes (duplicates NDA Status field).
- **Yimi Life** (311b4a7d-7207-812f-ac1f-dfd0bec1bc62): Notes condensed. Removed pricing ($7.80-$9.06).
- **Tiger Fitness** (318b4a7d-7207-81e6-b9d9-d3c0cf3c26c3): Notes condensed. Removed pricing (already in Unit Price field).
- **Second Page Yoga** (318b4a7d-7207-81fd-98b6-c746265e7ab1): Notes condensed. Removed pricing (already in Unit Price field).
- **Nimbl** (318b4a7d-7207-81da-98d2-cab0be45e37b): Notes condensed. Removed pricing (already in DB fields).
- **Crestline** (318b4a7d-7207-816e-b6c4-dfab1470c318): Notes condensed. Removed pricing.

#### M-Band Currency Fields Set
- **Quantal, MCM, Ribermold, Vangest, Uartronica, Novares**: Currency set to EUR (PT suppliers).
- **TransPak, Lihua, GAOYI**: Currency set to USD (US/CN suppliers).

#### Open Items Updated
- **Clarify Xinrui/Alicn FDA** (32eb4a7d-7207-81ba-9b90-c5c1303e4856): Status Closed. Resolution: Xinrui rejected, no longer relevant.
- **IFU / Labeling** (329b4a7d-7207-81b6-a608-e14637ff287d): Status Answered. PLD approach confirmed Apr 8. Sword creates own IFU/labels/packaging.
- **FDA Operating Model** (32cb4a7d-7207-81a5-8a0f-cf82334eb079): Status Answered. PLD confirmed by Kevin Wang. SQA mandatory. Anand escalated legal/finance to Hugo + Aaron.

#### Pulse Project Page Updated
- **Pulse  - BPM & BIA Scale sourcing** (310b4a7d-7207-8145-962e-e5a9c875dc0d): Notes updated (PLD approach, Paulo Alves PM). Overview: Packaging changed from "Original manufacturer" to PLD. PM and Gantt lines added. IFU callout updated to "Decided". FDA regulatory summary updated.

### Notion  - Daily Log
- **Daily Log Apr 09** (33cb4a7d-7207-810c-9dcb-eb3817849243): Appended Session B + Audit results. Highlights updated. Pulse: outreach logged (Unique Scales, Urion), outreach maintenance (4 pages), OIs closed/answered (3), project page updated (PLD decisions), timeline review sent to Paulo. Kaia: Notes audit (4 suppliers). M-Band: Currency set (9 suppliers), SHX Watch outreach. ISC: housekeeping + full audit summary.

### Notion  - Outreach
- **Unique Scales** (311b4a7d-7207-8130-9be9-cfcfa4254f1e): Apr 9 outreach entry added (6 emails from Queenie: invoice, die lines, packing reminder, dual-freq ready. Reply sent: invoice OK, DHL soon, die lines to design team, 3-5 golden samples, SQA from Sword).

### Notion  - Tiger Fitness (Kaia)
- **China Tiger Fitness** (318b4a7d-7207-81e6-b9d9-d3c0cf3c26c3): Quote section updated: 6mm/8mm carton dims added (were "pending from Eva", received Apr 8). Freight section updated: Eva's CNF quotes ($4,998/$6,555) + forwarder can't do DDP + Fernando independent quote pending. Outreach: Apr 8 entry expanded (8mm dims added), Apr 9 entry added (packing lists xlsx + freight clarification asked). Open Items: freight clarification OI added. DB fields: Freight+Duties corrected $7.22 (air) -> $1.60 (sea, consistent with FLC $17.55). Notes updated.

### Notion  - Outreach (Log Sent, Session B)
- **Urion Technology** (311b4a7d-7207-816c-a1e2-e019f5ead33e): Apr 9 outreach entry added (Miki confirmed Alipay payment, custom sample specs confirmed, delivery ~Apr 22, DHL dims requested).
- **SHX Watch** (311b4a7d-7207-8184-93ff-d14e8fa128a4): Apr 9 outreach entry added (3 stock samples approved for shipment, additional texture/velcro samples requested, custom straps in parallel, DHL dims requested).

### Notion  - Outreach Maintenance (Housekeeping Session B)
- **Transtek Medical** (311b4a7d-7207-8110-83dc-ce0e90e4de5f): Removed duplicate Apr 8 BU alignment entry. Archived Mar 24 + Apr 1-2 entries into toggle (now "Feb 2026 - Apr 2 2026"). Reordered Apr 7 entries before Apr 8. Summary line updated. 5 visible entries (was 11).
- **Unique Scales** (311b4a7d-7207-8130-9be9-cfcfa4254f1e): Removed 4 duplicate entries (Apr 8 BU x1, Mar 31 quotation x1, Mar 31 8-electrode x1, Mar 25 visa x1). Archived Mar 25 - Apr 1 entries into toggle (now "Feb 2026 - Apr 1 2026"). Summary line updated. 3 visible entries (was 18).
- **A&D Medical** (311b4a7d-7207-8131-9327-dbb43bc85174): Archived Mar 23-30 entries into toggle (now "Feb 2026 - Mar 30 2026"). Summary line updated. 4 visible entries (was 10).
- **Urion Technology** (311b4a7d-7207-816c-a1e2-e019f5ead33e): Removed duplicate Apr 5 entry. Moved 3 out-of-order Mar 27 entries into archive toggle. Archived Apr 1-4 entries. Toggle now "Feb 2026 - Apr 4 2026". Summary line updated. 6 visible entries (was 15).

### Notion  - Audit Fixes
- **Lihua** (311b4a7d-7207-8194-9b5c-d53388120e4a): Notes updated, removed stale "on hold per Jorge", reflects active RFQ status.
- **Transtek Medical** (311b4a7d-7207-8110-83dc-ce0e90e4de5f): Notes condensed to 2-line max.
- **Xinrui Group** (311b4a7d-7207-812b-bba5-ef7bbfcb13f2): Notes condensed, history removed.
- **Yilai Enlighting** (311b4a7d-7207-8133-8b7d-cacd23e62570): Notes condensed, history removed.
- **Daxin Health** (311b4a7d-7207-81a8-8cfe-fcd60cff5a8e): Notes condensed, history removed.
- **Zewa Inc.** (311b4a7d-7207-81ca-bfb0-f50e2d6c3118): Notes condensed, staleness text removed.
- **IPADV** (326b4a7d-7207-81e5-aa89-eee1348d4ec3): Notes condensed, operational details removed.
- **Braloba** (311b4a7d-7207-812c-aa4a-f4b07e6ba528): NDA Status null -> "Not Required".
- **Celoplas** (311b4a7d-7207-81b0-af4c-e01a7ab17c4b): NDA Status null -> "Not Required".
- **Kimball Electronics** (313b4a7d-7207-810c-86bc-f992ce0e8636): NDA Status "Pending" -> "Not Required" (rejected).
- **TERA Plastics** (311b4a7d-7207-8188-9711-c1ee6def6f5f): NDA Status "Pending" -> "Not Required" (rejected).
- **GAOYI** (328b4a7d-7207-81a1-9762-da42c6cdad29): Notes clarified Honda Printing Holdings group relationship. Website confirmed correct.
- **CONKLY** (311b4a7d-7207-8107-8901-f47e23282d84): Currency set to "USD" (CN strap supplier).
- **JXwearable** (311b4a7d-7207-8185-adf3-c22bcc2a330d): Currency set to "USD" (CN strap supplier).
- **Nimbl** (318b4a7d-7207-81da-98d2-cab0be45e37b): Type "Alternative" -> "Current Supplier". Notes updated to reflect active fulfillment partnership.

### Notion  - Audit Phase 2 (Content Quality)
- **A&D Medical** (311b4a7d-7207-8131-9327-dbb43bc85174): Notes updated (NDA "pending" -> "signed"). Outreach reordered chronologically (Mar 24 testing + Apr 1 BU meeting). NDA OI closed.
- **SHX Watch** (311b4a7d-7207-8184-93ff-d14e8fa128a4): Notes condensed (removed pricing + contact). Outreach Mar 17 Portuguese -> EN.
- **Tiger Fitness** (318b4a7d-7207-81e6-b9d9-d3c0cf3c26c3): Outreach Mar 13 Portuguese -> EN. Stale OI closed (carton dims received Apr 8).
- **Transtek Medical** (311b4a7d-7207-8110-83dc-ce0e90e4de5f): Outreach reordered chronologically (Mar 24 testing + Apr 1 BU meeting placed before Apr 2).
- **Unique Scales** (311b4a7d-7207-8130-9be9-cfcfa4254f1e): Outreach reordered chronologically (Mar 25, Mar 31 entries moved to correct position). Resolved OIs cleaned up. Apr 8 BU meeting entry placed correctly.
- **Tiger Fitness** (318b4a7d-7207-81e6-b9d9-d3c0cf3c26c3): Outreach archive toggle created (Mar 2026). Summary line added. "Artwork enviado" -> "Artwork sent".
- **A&D Medical** (311b4a7d-7207-8131-9327-dbb43bc85174): Outreach archive toggle created (Feb-Mar 2026). Summary line added.

### Notion
- **Daily Log Apr 09** (33cb4a7d-7207-810c-9dcb-eb3817849243): Created. Cross-check results, workflow improvement discussion, pending Notion gaps by project.
- **Daily Log Apr 08** (33cb4a7d-7207-81ac-b0e0-f9381d807b2e): Restructured Pulse section. GU alignment meeting elevated to own heading with grouped decisions and flags. Pre-meeting and evening emails separated into sub-sections.
- **Transtek Medical** (311b4a7d-7207-8110-83dc-ce0e90e4de5f): BP Cuffs Price updated $18.60 → $19.20 FOB ZS @5K. Outreach: Apr 8 entry added (PLD confirmation, branding, golden sample, SQA).
- **Unique Scales** (311b4a7d-7207-8130-9be9-cfcfa4254f1e): Outreach: Apr 8 entry added (proforma request + PLD/branding/SQA follow-up).
- **Urion Technology** (311b4a7d-7207-816c-a1e2-e019f5ead33e): Outreach: Apr 8 entry added (commercial invoice, Alipay payment, receipt request).
- **A&D Medical** (311b4a7d-7207-8131-9327-dbb43bc85174): NDA Status updated "Under Review" → "Signed". Outreach: Apr 8 entry added (Kyle confirmed NDA, Legal to send via Dropbox Sign).
- **Tiger Fitness** (318b4a7d-7207-81e6-b9d9-d3c0cf3c26c3): Outreach: Apr 8 entry added (carton dims received, shared with Fernando).
- **SHX Watch** (311b4a7d-7207-8184-93ff-d14e8fa128a4): Outreach: Apr 8 entry added (parallel sample approach proposed).
- **JXwearable** (311b4a7d-7207-8185-adf3-c22bcc2a330d): Outreach: Apr 8 entry added (Daisy plug update, quotation next week).
- **Lihua** (311b4a7d-7207-8194-9b5c-d53388120e4a): Status updated "Identified" → "RFQ Sent". Outreach: Apr 6-8 entries added (Jessica Costa RFQ reply, Lihe group connection, M-Band proposal).
- **/log-sent command created** (.claude/commands/log-sent.md). Added to CLAUDE.md Section 4.

## 2026-04-08

### Notion
- **Daily Log Apr 08** (33cb4a7d-7207-81ac-b0e0-f9381d807b2e): Updated Highlights. Appended evening supplier emails to Pulse (Transtek, Unique Scales, Urion, A&D, IPADV hold, Gantt). Replaced Kaia section (Tiger Fitness carton dims). Replaced M-Band section (SHX Watch, JXwearable, Lihua Direct). Appended ISC (domain filter updates, cross-check results, memory created).

### Pulse Page Dashboard Restructure — 2026-04-10
- Added Status Snapshot callout (13 suppliers, device selections, Gantt, blockers)
- Added Owners table (8 roles)
- Added Risks & Alerts callout (6 current risks)
- Added ## Open Items heading above existing linked DB view
- Backup: outputs/backups/pulse-page-pre-dashboard-2026-04-10.md
- Page ID: 310b4a7d-7207-8145-962e-e5a9c875dc0d
