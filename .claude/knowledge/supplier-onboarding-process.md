# Supplier Onboarding Process
# Sword Health ISC — Procurement Knowledge Base
# Sword Insighter | Last updated: 2026-04-18

End-to-end checklist for bringing a new supplier into the Sword system. Three parallel tracks: Procurement (Notion), Finance/AP (Zip), and QARA (Qualio — Pulse only).

---

## Overview

Onboarding a supplier involves three largely independent tracks that can run in parallel after the NDA is signed:

```
NDA Signed
   │
   ├── Track 1: Procurement (Notion)
   │     Add supplier page, domain, context file entry
   │
   ├── Track 2: Finance / AP (Zip)
   │     Vendor creation in ERP, payment terms, tax docs
   │
   └── Track 3: QARA / SQA (Pulse only)
         Supplier qualification audit, Qualio record, LoE
```

---

## Track 1: Procurement (Notion)

Handled by Claude via `/supplier-onboarding` skill. Steps:

1. Create Notion page in the relevant Supplier DB (sections: Contact, Profile, Quote, Outreach, Open Items)
2. Set Status = Identified (or current status if advancing from prospection)
3. Add domain to `.claude/config/domains.md` (table + Gmail filter pattern)
4. Add entry to `context/{project}/suppliers.md`
5. Log to `outputs/change-log.md`

**Note:** First outreach is always André personally. Claude drafts; André reviews and sends. (CLAUDE.md Safety Rules, Level 2)

---

## Track 2: Finance / AP Onboarding (Zip)

**Platform:** https://swordhealth.ziphq.com (André submits manually)

**When to initiate:** After NDA is signed and supplier has been selected or is likely to receive a PO. Do NOT onboard Finance for every qualified supplier — only when a PO is likely.

**What Zip / Finance needs:**
- Supplier legal entity name and registration number
- Registered address (for invoice matching)
- Primary AP contact (name + email)
- Bank details (wire transfer / IBAN)
- Tax documentation (W-9 for US suppliers, VAT certificate for EU)
- Payment terms agreement (typically Net 30 or Net 45 — confirm with Finance)

**Zip states to watch:**
- "Vendor created" → supplier is in ERP and can receive POs. Log milestone in Outreach.
- "Revision requested" → Finance needs more info. Flag to André.
- "Budget request approved" → relevant PO authorization. Update/close budget OI.

**Timeline:** Typically 5–10 business days once documents are submitted.

---

## Track 3: QARA / SQA Onboarding (Pulse only)

**Contact:** Sofia Lourenço (Expert QSE) — always in Portuguese, via Slack or email.
**Do NOT contact:** João Quirino or Bianca Lourenço directly on SQA matters.

**When to initiate:** After supplier is selected (Shortlisted) and before first production commit.

**What SQA involves:**
- Supplier Quality Agreement (SQA): formal quality contract between Sword and supplier
- Supplier audit (may be desk-based or on-site depending on supplier tier)
- Qualio record creation (handled by Sofia)
- LoE (Letter of Evaluation) — supplier-issued, reviewed by Sofia + potentially Bianca

**What André does:** relay documents between supplier and Sofia. Does NOT decide on SQA terms. Does NOT approve LoE content.

**Documents André collects from supplier and passes to Sofia:**
- ISO 13485 certificate (current, with expiry date)
- CE/FDA registration documents
- Quality manual (or executive summary)
- LoE draft (if applicable)

**Timeline:** SQA process can take 4–8 weeks depending on Sofia's queue and supplier responsiveness.

**OI handling:** Create a Blocker OI if SQA is stalled > 2 weeks. Owner: André → Sofia Lourenço.

---

## Track dependencies

| Track | Depends on | Blocks |
|-------|-----------|--------|
| Procurement (Notion) | Nothing | Everything |
| Finance / AP | NDA signed | First PO |
| QARA / SQA | Supplier selected (Shortlisted) | Production commit (Pulse) |

NDA and Finance can be initiated roughly in parallel. QARA comes later (post-selection).

---

## Project-specific notes

**Pulse:** All 3 tracks required. QARA is the longest-lead item. Start SQA early.

**Kaia:** Tracks 1 + 2. No SQA required (not a medical device). OEKO-TEX cert verification is done by André, not QARA.

**M-Band:** Tracks 1 + 2. Engineering (Pedro / Miguel) may need to validate SDK before Finance onboarding makes sense.

**BloomPod:** Tracks 1 + 2. Regulatory review may be needed for UN38.3 (air freight cert) — Sofia on loop if shipping compliance is a question.
