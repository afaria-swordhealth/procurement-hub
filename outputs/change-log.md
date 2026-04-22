# Change Log
# Rolling daily file. Keeps only today's entries.
# History lives in git log. On wrap-up, this file is committed then cleared for tomorrow.

## 2026-04-22

### Status updates — 2026-04-22T~23:30

[EVENT: OI_COMMENT oi=348b4a7d…da68 target=Transtek-MSA]
LRE-1920 confirmed to cover both devices. LRE-1923 merged into LRE-1920 by Maggie Lumley. Kevin following up with Sarah before Apr 23 call.

[EVENT: OI_COMMENT oi=33eb4a7d…93c target=Transtek-SQA]
Manufacturing site question sent to Mika 23:04 (same entity or different? If different, name + address required for QTA).

[EVENT: OI_COMMENT oi=33eb4a7d…ffb target=UniqueScales-SQA]
Record retention 6yr included in revised QTA sent to Queenie Apr 21 22:20.

---

### Status updates — 2026-04-22T~EOD

[EVENT: OI_CLOSE oi=33fb4a7d…c45c target=Novares]
Status → Closed. Resolution: supplier deprioritized, no active M-Band sourcing requirement.

[EVENT: OI_COMMENT oi=33eb4a7d…d871 target=Ribermold]
Comment: clarification meeting completed Apr 22; awaiting revised quote.

[EVENT: OI_COMMENT oi=345b4a7d…8bae target=Transtek-NDA]
Comment: NDA received by Legal, under signature.

[EVENT: OI_COMMENT oi=33eb4a7d…664 target=Kaia-ProImprint]
Comment: ProImprint dropped; OI scope now Tiger + Second Page only.

---

### /log-sent — 2026-04-22T12:xx

[EVENT: OUTREACH_WRITE supplier=Unique_Scales date=Apr-22 event=FDA-regulatory-reply]
Outreach entry written: FDA/UDI/IOR comprehensive reply (09:21 AM). Summary line updated to 65+. Last Outreach Date already 2026-04-22 — no field update needed.

[EVENT: SKIP supplier=Unique_Scales date=Apr-22 event=PO-authenticator-reply reason=not-milestone]
"Re: Sword Health sent you a purchase order: #3145" (09:59 AM) — IT support reply, not a procurement milestone.

---

### /mail-scan — 2026-04-22T12:xx (MSA submissions logged by André)

[EVENT: EXTERNAL_SUBMIT platform=Jira ticket=LRE-1923 supplier=Transtek]
MSA legal review request submitted. Jira: https://swordhealth.atlassian.net/servicedesk/customer/portal/15/LRE-1923

[EVENT: EXTERNAL_SUBMIT platform=Jira ticket=LRE-1924 supplier=Unique_Scales]
MSA legal review request submitted. Jira: https://swordhealth.atlassian.net/servicedesk/customer/portal/15/LRE-1924

---

### /improve — L7 duplicate-rule cleanup (post-wrap-up)

6 files edited. Collapsed duplicated writing-style / Gmail-threading / OI-Context clauses to pointers at their canonical sources (`config/writing-style.md`, `agents/supplier-comms.md`, `procedures/create-open-item.md`):
- `.claude/config/presentation-guidelines.md` — collapsed 5-line writing-style mini-block (L234-239) to single pointer line.
- `.claude/skills/quote-intake/SKILL.md` — "All Notion content in English. No em dashes." → pointer.
- `.claude/skills/supplier-onboarding/SKILL.md` — same pattern → pointer.
- `.claude/skills/rfq-workflow/SKILL.md` — 4 lines (English/em dash/HTML-CDATA/sign-off) collapsed to 1 pointer + kept verify-recipient line.
- `.claude/skills/supplier-chaser/SKILL.md` — trimmed "Respect config/writing-style.md sign-off..." restatement.
- `.claude/skills/supplier-rejection/SKILL.md` — collapsed create_draft-threading note to pointer at supplier-comms.md.
- `.claude/agents/notion-ops.md` — trimmed duplicated OI-Context clauses after existing CLAUDE.md §4c pointer.

Ship metric (git grep for any rule returns exactly one canonical location): satisfied for writing-style, Gmail threading, OI Context. Session-single model and SHOW BEFORE WRITE already single-sourced in `.claude/safety.md`. L7 closed.

### /improve — L6 quote-intake PDF prefill (Step 1a)

`.claude/skills/quote-intake/SKILL.md`: added Step 1a "PDF attachment prefill (Levelpath pattern)". Extracts 7 canonical fields in a single pass (tier table, tooling/NRE, MOQ, lead time, Incoterm, payment terms, FX base), records per-field confidence (high/medium/low), routes low-confidence fields to SHOW BEFORE WRITE regardless of Step 4 auto-write conditions, HALTs on scanned PDFs (no OCR fabrication), logs `[EVENT: PDF_EXTRACT]` to change-log. Explicit "never send drafts or trigger supplier emails from this skill" guardrail. One parse → one approval gate (Step 4 auto-write or SBW), vs prior 3-4 gates.

### /improve — L6 chaser cadence confirmed shipped

Audit of `supplier-chaser/SKILL.md`: Step 4b "Signal-triggered cadence" (timezone map, CN weekend suppression, PT pre-09:00 hold, Gmail open/OOO modifiers, per-row send_window + defer_reason output) is fully present. §10 had a stale "not implemented" note — corrected to reflect shipped state. No code change to chaser needed.

### /morning-brief — 2026-04-22

[EVENT: SKILL_RUN skill=morning-brief status=delivered decisions=3 overdue=5 signals=5 deferred=10]
Brief delivered via chat. Consumed: 6 signals from pending-signals.md (3 schema + Sarah + M-Band FE + Ribermold). Session-state Last-Morning-Brief updated.

### /log-sent — 2026-04-22T18:xx

[EVENT: OUTREACH_UPDATE supplier=Transtek date=Apr-22 event=GBF-2008-B1-artwork-feedback]
Apr 22 entry updated: artwork review (16:03 UTC) consolidated into existing GBF-2008-B1 commitment bullet. QR code addition for Sword app front page (BPM IFU consistency) noted. Same thread, same day — no new bullet per consolidation rule.

---

### /log-sent — 2026-04-22T15:xx

[EVENT: OUTREACH_WRITE supplier=Transtek date=Apr-22 event=GBF-2008-B1-scale-commitment]
Outreach entry written: GBF-2008-B1 scale commitment (14:26 UTC). Summary line updated 66+ → 67+. Last Outreach Date already 2026-04-22 — no field update needed.

[EVENT: OI_COMMENT oi=33eb4a7d…c93c target=Transtek-SQA]
Comment added: UDI/DI for GBF-2008-B1 requested from Mika for QTA completion; 2k unit commitment confirmed.

[EVENT: OI_COMMENT oi=348b4a7d…a68 target=Transtek-MSA]
Comment added: Scale commitment confirmed, MSA scope now covers BPM + scale. LRE-1923 submitted today.

[EVENT: SKIP supplier=Unique_Scales date=Apr-22 event=PO-zip-login-x2 reason=not-milestone]
09:59 + 14:32 emails re: Zip MFA loop — IT support, not procurement milestone.

[EVENT: FLAG supplier=Daxin date=Apr-21 event=glucose-meter-pricing reason=not-in-notion-db]
Daxin (daxinhealth.com) email Apr 21 15:00 — T2D track, not in any Notion DB. Parked per memory (Kevin Wang glucometer sourcing parked). No write.

---

### /meeting-notes — 2026-04-22T14:30

[EVENT: NOTION_WRITE target=DailyLogs page_id=34ab4a7d…198b]
Meeting notes created: "Meeting Notes — Paulo / Kevin / Sofia | Apr 22 14:30 | Pulse Scale Decision"
Key decision logged: switch from Unique Scales to Transtek GBF-2008-B1 (2k units, partial deliveries OK).
Week W17 select not yet in DB — field omitted; add W17 to Daily Logs DB in next /housekeeping.
URL: https://www.notion.so/34ab4a7d72078157a928c05ec91c198b

---

### /improve — improvement-plan §10 status refresh

`outputs/improvement-plan.md` §10: L6 row moved ⚠ → ✅ (both sub-items now shipped); sequencing recommendation #4 marked as shipped. Remaining L6 work is real-data dogfooding on the first supplier PDF, not code.

---

### /log-sent — 2026-04-23T~00:xx (continuation — approved mail-scan recommendations)

[EVENT: OUTREACH_WRITE supplier=Transtek date=Apr-23 event=project-plan-request]
Outreach entry written: project plan update requested — email sent with fully executed NDA copy attached. Asked Mika for updated milestone plan for BB2284-AE01 (BPM) + GBF-2008-B1 (scale). Summary line updated 67+ → 68+, Last updated Apr 22 → Apr 23. Last Outreach Date field updated to 2026-04-23.

[EVENT: OUTREACH_WRITE supplier=Unique_Scales date=Apr-20 event=die-cut-templates-received]
Outreach entry written: CF635BLE die-cut complete set received from Queenie (inner box, outer carton, sticker/label, user manual). Resent as single batch. Summary line updated 65+ → 66+. Last Outreach Date remains 2026-04-22 (new entry is Apr 20, not more recent).


