# PO + First Order Process
# Sword Health ISC — Procurement Knowledge Base
# Sword Insighter | Last updated: 2026-04-19

What happens after a supplier is selected and commercial terms are aligned. Covers PO issuance, Zip budget approval, tooling deposit, production monitoring, and first shipment.

---

## Triggers

This process starts when:
- Supplier reaches "Selected" status in the Supplier DB
- Jorge has aligned with André on commercial terms
- QARA has cleared the supplier (Pulse: SQA complete; Kaia/BloomPod: not required; M-Band: TBD per Pedro/Miguel)

---

## Step 1: Finalize commercial terms in writing

Before any Zip or PO action, confirm in writing with the supplier (email, not Slack):

- Unit price at target volume tier
- Tooling/NRE total (itemized, if applicable)
- Payment terms: 30% deposit + 70% on shipment (CN default); Net 30 (PT suppliers may offer)
- Incoterms: FOB Shanghai for CN default; EXW or FCA for EU/US
- Lead time: tooling lead time + production lead time (separately)
- First order quantity

Log confirmation as an outreach milestone.

---

## Step 2: Zip budget request

A PO cannot be issued without prior Zip approval. André initiates at https://swordhealth.ziphq.com:

1. Create new request: Vendor = supplier legal name, Amount = PO value (unit price × qty + tooling if applicable), Category = Hardware/Manufacturing, Department = ISC.
2. Attach: supplier quote, specs reference, any approval email from Jorge.
3. Approver chain: Jorge Garcia → Finance.
4. Expected approval: 2-5 business days.

Open an OI: "Supplier — Zip budget approval" | Pending | Action Item | Owner: André | Deadline: 5 biz days. Close when Zip shows "Budget request approved."

---

## Step 3: PO issuance

Finance/AP creates the PO after Zip approval. André provides:
- Supplier legal name and address
- Invoice currency (CNY, USD, or EUR)
- Item description, unit price, quantity
- Incoterms and delivery address

**Porto address:** Av. de Sidónio Pais 153, Ed. A Piso 5, 4100-467 Porto (for PT/EU delivery).
**Nimbl SLC** (M-Band only): separate address — ask André or Catarina.

After Finance issues the PO number:
- Record PO number in supplier's Notion page Notes field.
- Update supplier Status to "PO Issued."
- Add outreach milestone: "PO issued. PO #[number]. Qty [X], [Incoterm]."

Do NOT share the PO number with the supplier until Finance confirms issuance.

---

## Step 4: Tooling deposit (if applicable)

Tooling is typically invoiced separately, 100% upfront before production starts.

- Supplier issues tooling invoice. André reviews: matches quote amount, correct legal entity.
- Route to Finance/AP via Zip (create a separate budget request if tooling wasn't included in Step 2).
- After payment confirmed by Finance: update the tooling OI + add outreach milestone.
- Tooling lead time starts from payment receipt date, not PO date. Confirm in writing with supplier.

**Tooling ownership rule:** Clarify in writing before paying. Default position: Sword owns custom tooling molds. Include this in the confirmation email (Step 1) if not already stated.

---

## Step 5: Production monitoring

Open an OI: "Supplier — Production" | Pending | Action Item | Owner: supplier contact (André monitors) | Deadline: expected ship date.

Checkpoints during production:
- Midpoint: request production photos or QC report from supplier.
- 2 weeks before ship: confirm packing list, commercial invoice format, HS codes.
- For Pulse (regulated): coordinate QARA first article inspection (FAI) per `qara-engagement.md`.

---

## Step 6: Shipment and logistics

**CN suppliers (sea freight for volume orders):**
- Coordinate with Fernando Saraiva for freight booking.
- HS code + commercial invoice required for customs.
- DHL Express for samples or small urgent orders (coordinate with Catarina).

**M-Band: ship to Nimbl SLC (not Porto).**
- Nimbl fulfillment rates: $13.15–$17.15/unit.
- Coordinate Nimbl inbound with Catarina.

**PT/EU suppliers:** EXW or FCA pickup from supplier location; inland freight to Porto.

Track via DHL or freight forwarder and update the production OI with shipping milestone.

---

## Step 7: First invoice and payment

- Supplier submits invoice after shipment (or goods received, per Incoterms).
- André reviews: invoice matches PO number, qty, price, currency, correct legal entity.
- Route to Finance/AP. If unclear on routing: ask Jorge.
- Log payment milestone in supplier Outreach section once Finance confirms payment sent.

---

## OI map for this process

| OI | Type | Owner | Close trigger |
|----|------|-------|---------------|
| "Supplier — Zip budget approval" | Action Item | André | Zip shows "Budget request approved" |
| "Supplier — Tooling deposit" | Action Item | André | Finance confirms tooling payment |
| "Supplier — Production" | Action Item | Supplier contact (André monitors) | Goods shipped |
| "Supplier — QARA FAI" (Pulse only) | Blocker | André → Sofia | Sofia clears FAI |
| "Supplier — First shipment / logistics" | Action Item | André (Catarina for DHL) | Goods received at destination |

---

## Project notes

**Pulse:** All steps apply. QARA FAI is mandatory before first shipment acceptance. Start SQA early (Track 3 in `supplier-onboarding-process.md`).

**Kaia:** Steps 1-7, no QARA FAI. OEKO-TEX cert verification done by André.

**M-Band:** Steps 1-7, ship to Nimbl SLC. Coordinate with Miguel Pais on SDK validation before PO.

**BloomPod:** Steps 1-7. UN38.3 (air freight cert) may be required — flag to Sofia if air shipping coin cells.
