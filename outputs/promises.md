# Promises Board
<!-- Promises made to humans (suppliers, internal stakeholders) with deadlines. -->
<!-- Updated by /warm-up (review), /mail-scan (add on draft), /log-sent (add on sent), and manually. -->
<!-- Remove entries only when resolved. Overdue items stay visible until closed. -->

## Format
Each entry: `- [ ] {who} | {what} | promised: YYYY-MM-DD | due: YYYY-MM-DD | next: {concrete next step} | OI: {id or —} | source: {where}`

- **next**: the one concrete action that moves this forward (send email, wait for reply, raise in 1:1). If "waiting on them", say so explicitly.
- **OI**: short id of a linked Open Item (first 8 chars of Notion page id) or `—` if none exists. If the promise is big enough to warrant tracking in the OI DB, create one and link it here.

## Open

### Internal
- [ ] Pedro Rodrigues | Confirm NPM1300 BOM qty needed (Avnet no stock, LT 23-25wks) | promised: 2026-04-10 | due: 2026-04-22 | next: converges on Manuel Beito OI — confirm BOM qty after Beito replies | OI: 345b4a7d…81c3 | source: self-initiated from Avnet Apr 10 alert
- [ ] Jorge Garcia | Raise M-Band component risk (NPM1300 + Renesas Jul 1 price increase) at André/Jorge 1:1 | promised: 2026-04-10 | due: 2026-04-27 | next: 1:1 moved to Apr 27 — hold escalation unless Beito replies before then | OI: 345b4a7d…81c3 | source: self-initiated
- [ ] Kevin Wang | Re-engage Pulse T2D procurement | promised: 2026-04-08 | due: 2026-04-24 | next: restart procurement once Jorge green-lights (blocked on Jorge) | OI: — | source: Gmail 19d6f6ac25140759
- [ ] Caio (Kaia PM) | Kaia sourcing decision meeting | promised: 2026-04-17 | due: 2026-04-24 | next: meeting scheduled week of Apr 21 — all Kaia sourcing decisions gated on this | OI: — | source: André Apr 17
- [ ] Pedro Rodrigues | Share full specs for Bloom Pod coin cell (Vmax/min, current avg/peak + pulse duration, dimensions + STEP 3D, target capacity min) | promised: 2026-04-17 | due: 2026-04-24 | next: waiting on Pedro — procurement prepping supplier shortlist + RFQ template in parallel | OI: 345b4a7d | source: Slack C08C96G912N

### Suppliers
- [ ] Sónia Sousa (Avnet) | Confirm M-Band component lead times beyond Nordic (Renesas, STM32, etc.) | promised: 2026-04-10 | due: 2026-04-14 | next: dormant, waiting on Manuel Beito OI (Future Electronics primary channel for these parts) | OI: 345b4a7d…81c3 | source: Gmail thread 19d77327d6ac42ea
- [ ] Mika Lu (Transtek) | Letter of Equivalence confirming BB2284-AE01 covered under K241351 | promised: 2026-04-14 | due: 2026-04-18 | next: Mika enviou, ping enviado à Sofia — waiting on Sofia ack. Blocker for SQA closure | OI: — | source: Gmail draft r-4009151432736265637
- [ ] Mika Lu / Jenna Chen (Transtek) | UDI-DI ownership + FDA listing update process/timeline for "Pulse" trade name + white-label US precedent | promised: 2026-04-16 | due: 2026-04-23 | next: waiting on Transtek Legal/RA — chase Apr 23 if silent. Blocker for FDA registration alignment | OI: — | source: Gmail reply Transtek branding thread 2026-04-16
- [ ] Queenie (Unique Scales) | Confirm ISTA packaging transit test capability (1A/2A/3A), in-house vs partner lab, documentation | promised: 2026-04-17 | due: 2026-04-24 | next: email sent 13:29 Apr 17 — waiting on Queenie reply | OI: 345b4a7d…3797 | source: Gmail draft r-5418780676973771409

## Resolved
<!-- Move completed items here with resolution date. Prune monthly. -->
- [x] Miguel Pais | Update on Uartronica (no response since Dec 2025 quote, re-quote pending) | resolved: 2026-04-17 | Email status update sent to Miguel Apr 17; waiting Uartrónica reply early next week. OI …818d deadline pushed to Apr 22.
- [x] Queenie (Unique Scales) | Legal name, banking details, PO email for Zip onboarding | resolved: 2026-04-12 | All data received (business license + bank PDFs). Portal completion (Queenie 2FA) tracked in OI.
- [x] Mika (Transtek) | Zip onboarding + Certificate of Registration | resolved: 2026-04-13 | Transtek onboarding complete in Zip.
- [x] Jessica Costa (Lihua) | Re-quote M-Band packaging at 25K/50K/200K tiers | resolved: 2026-04-16 | Lihua enviou cotações completas (25K/50K/75K/100K/200K). Em análise interna.
- [x] Jessica Lee (GAOYI) | Re-quote M-Band packaging at 20K/25K/50K/200K tiers | resolved: 2026-04-16 | GAOYI enviou cotações USD EXW (1K/3K/5K/10K/20K/50K/200K). Em análise interna.
