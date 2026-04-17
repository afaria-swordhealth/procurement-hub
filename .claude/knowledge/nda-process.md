# NDA Process
# Sword Health ISC — Procurement Knowledge Base
# Sword Insighter | Last updated: 2026-04-18

When and how to initiate, track, and close NDAs for new suppliers.

---

## When to initiate

**Trigger:** supplier reaches GO or Conditional GO verdict in `/supplier-qualification`.

Do NOT initiate before qualification — an NDA signals intent and moves a relationship forward. It should not be used for exploratory prospection.

**Exceptions:**
- Supplier requests NDA before sharing pricing or specs: evaluate on case by case. Flag to André. If the supplier is a strong candidate, proceed early.
- Rejected suppliers: NDA Status → "Not Required" (auto-approved in housekeeping).

---

## Platform

**Zip:** https://swordhealth.ziphq.com
André submits all NDA requests manually in Zip. Claude cannot submit (Level 1: technically impossible).

**Legal reviewer:** Bradley (Legal). Tag him in Zip when submitting.

---

## Required inputs (before submitting in Zip)

| Input | Source |
|-------|--------|
| Supplier legal entity name | Supplier page Profile section |
| Supplier country / jurisdiction | Supplier page Profile section |
| Supplier primary contact (name + email) | Supplier page Contact section |
| Project name | Notion project relation |
| IP sensitivity level | Assess based on project: Pulse has clinical data + IP; Kaia is lower risk |
| Any special clauses needed | Ask Bradley if unsure |

---

## NDA Status field values (Supplier DB)

| Value | Meaning |
|-------|---------|
| _(blank)_ | Not yet initiated |
| Sent | Zip request submitted; awaiting supplier signature |
| Under Review | Supplier or Legal reviewing / negotiating |
| Signed | Fully executed; safe to proceed to RFQ |
| Not Required | Supplier rejected, or NDA waived (Bradley confirmed) |

**Level 2 rule:** NDA Status changes require André's approval (SHOW BEFORE WRITE). Exception: "Not Required" on Rejected suppliers is auto-approved in housekeeping.

---

## Typical timeline

- Simple NDA (standard Sword template, no redlines): 5–10 business days
- Redlined NDA: 2–4 weeks depending on Bradley's bandwidth and supplier legal team
- Stalled NDA: flag as Blocker OI if >14 days with no movement

---

## What blocks an NDA

- Supplier legal team requests significant redlines → escalate to Bradley
- Supplier wants to use their own template → bring to Bradley, do not agree unilaterally
- QARA has concerns about IP clauses (rare, Pulse-specific) → loop Sofia Lourenço
- Finance has not onboarded the supplier yet → NDA can proceed in parallel with Zip vendor onboarding

---

## Notifications to watch

Mail-scan watches `swordhealth.ziphq.com` emails. Key events:
- "NDA executed" / "fully signed" → update NDA Status → Signed. Close NDA OI. Log milestone in Outreach.
- "Revision requested" → review in Zip portal. Flag to André with link.
- "Step completed" → informational. Log if relevant to OI.

---

## OI handling

| Event | OI action |
|-------|-----------|
| NDA initiated | Create OI: `{Supplier} — NDA execution`. Type: Action Item. Deadline: +14 days. |
| NDA signed | Close OI. Resolution: "NDA executed [date]. Signed by [name]." |
| NDA stalled >14 days | Add page comment on OI. Escalate to Bradley if supplier-side. |
| NDA not required (waived) | No OI needed. Set Status to Not Required directly. |

---

## Project-specific notes

**Pulse:** NDA often includes clinical data confidentiality and IP on device firmware/algorithms. Bradley may need extra time for these clauses. Sofia Lourenço may review if there are QARA-relevant terms (LoE ownership, regulatory file access).

**Kaia:** Standard NDA. Lower IP risk. Usually straightforward.

**M-Band:** SDK and firmware sharing may be involved — flag any IP transfer clauses to Bradley.

**BloomPod:** Standard NDA. Battery chemistry IP unlikely to be an issue at this stage.
