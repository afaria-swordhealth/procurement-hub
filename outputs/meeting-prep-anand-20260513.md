# Meeting Prep — Anand Singh (VP ISC) — 2026-05-13

**Format:** Call or async DM. André's message sent (DM 00:08 + follow-up 21:53 May 12). No Anand reply yet.
**Agenda:** 4 topics across Pulse, Kaia, M-Band.

---

## TOPIC 1: Pulse — Nimbl Order Management Setup

**Background:**
On May 8, Sofia Lourenço blocked the Draco kitting approach for Pulse medical devices (#pulse-devices):
> "As Distributor we are not allowed to proceed with any kitting involving the medical devices we are distributing. We are navigating a narrow exception here and we need to be extra careful."

**Confirmed decision:** Pulse fulfillment at last mile = multi-order shipment (Transtek ships device, Nimbl assembles the non-medical kit around it). Draco continues for non-medical devices only.

**What's outstanding:**
Daniel Ledo (SLC ops — joined #pulse-devices May 8) has three open questions, still unanswered:

| Ask | Detail |
|-----|--------|
| Boxes + QR documentation | For all Pulse bundle materials |
| Sample product boxes | For Nimbl to begin processing setup |
| Warranty/replacement protocol | Supplier-related complaints: return to supplier vs. replace until threshold? |

Kevin Wang added a 4th question (May 12 13:53): "Will Transtek provide basic troubleshooting steps for CC to use, or strictly forward-only?"

**The Anand question:** You mentioned (last week) you'd set up a call with **Sterling at Nimbl**. Did that happen? What was the outcome on configurable order setup?

**What you need from Anand:**
- Sterling call outcome, or timeline if not yet held
- Confirmation on Nimbl's OMS configuration capability for multi-order Pulse bundles
- Who handles Daniel Ledo's questions — André or Anand/ops track?

---

## TOPIC 2: Kaia — Nimbl Fulfillment Timing

**Background:**
Nimbl is already Kaia's fulfillment partner ($13.15–$17.15/unit, Shortlisted). Fulfillment transition plan OI closed May 5. This is about starting a new conversation for Kaia-specific order flows — a new process.

Working context: André is working with Inês on the Kaia fulfillment approach with Nimbl. Jorge returns May 14.

**The question for Anand:**
> Start the Nimbl conversation before Jorge is back (this week), or wait for Jorge to be in from the start?

**Recommended framing:**
- If Anand has a relationship with Sterling at Nimbl, he's better placed to make this call
- Jorge's involvement is process-ownership, not relationship — starting before May 14 is defensible if timeline is urgent
- The Kaia fulfillment need is tied to the Second Page Yoga order (2K air + 5K sea targeting June delivery), already delayed

**What you need from Anand:**
- Start now or wait for Jorge?
- If now: can Anand loop Sterling into a 3-way intro call this week?

---

## TOPIC 3: M-Band Manufacturing Components — AMS-OSRAM + Nordic

**Background:**
André shared a Nordic lead-time summary + M-Band Component Blocker OI with Anand on May 8. Anand replied "Let's talk Monday" (May 8 19:56) — that call never happened.

**What's known:**

| Component | Distributor | Lead Time | Status |
|-----------|------------|-----------|--------|
| AMS-OSRAM (optics) | Future Electronics (primary) / Avnet (secondary) | 30 weeks | PO escalation gated on Jorge 1:1 |
| Nordic Semiconductor (BLE) | Avnet EU | Long lead | Under OI tracking |

**The blocker:** AMS-OSRAM PO escalation requires Jorge's direction. Jorge returns May 14. The 30wk lead time means each week of delay matters.

**What you need from Anand:**
- Can Anand advance the AMS-OSRAM PO ahead of Jorge's return, or does it wait until Thursday?
- Has the Nordic lead-time context (shared May 8) factored into M-Band COO-X timeline planning?

---

## TOPIC 4: Kaia — Purchase Ownership + Inventory Management (NetSuite vs Zip)

**Background:**
On May 11, André raised the key question in #kaia-nimbl-fullfillment:
> "Is this a Kaia purchase running through Kaia's process, or a Sword purchase? If Sword inventory purchase, it needs to go through NetSuite, not Zip."

Max confirmed (May 11): *"Kaia purchase processes were sunset by Sword finance, so all the regular Sword processes apply."*

**Conclusion:** It's a Sword purchase. That means:
1. PO must go through **NetSuite** (Zip is for vendor onboarding and service contracts only)
2. Sword owns and manages the inventory
3. Zip #3511 continues as the vendor onboarding vehicle for Second Page Yoga (bank data, MSA LRE-1957, QARA)

**Note:** Max confirmed he does not have NetSuite access.

**Current Zip #3511 status (May 12 evening):**

| Step | Status |
|------|--------|
| FP&A approval (André Portugal) | ✓ Approved May 12 16:59 |
| Amount correction ($100K → $16,730) | Pending — Caio to fix |
| Legal Contract Review (Bradley Bruchs) | Pending |
| QARA Approval (João Quirino) | Pending |
| Jerry SWIFT/BIC bank data | Pending |
| Anand finance support commitment | ✓ "already on it" May 12 16:15 |

**What you need from Anand:**
- Confirm path: Sword buys inventory via NetSuite PO; Zip = vendor onboarding only. Is this right?
- Who creates the NetSuite PO? (Max has no access; Caio is Kaia-side)
- Does Anand's "finance support" commitment cover unblocking Bradley + QARA on Zip #3511?

---

## Open Items (session snapshot — May 12)

| OI | Status | Owner | Overdue |
|----|--------|-------|---------|
| Kaia — Caio + Max sourcing decision | Pending | Caio | 12d (due Apr 30) |
| Pulse T2D — Kevin Wang re-engage | Pending | Kevin | 4d (due May 8) |

---

## Talking Points

1. **Sterling/Nimbl call** — get the outcome or schedule this week. Daniel Ledo is blocked.
2. **Kaia timing** — propose starting Nimbl conversation this week; suggest Anand facilitates via Sterling relationship.
3. **AMS-OSRAM** — 30wk clock is running. Can Anand advance ahead of Jorge Thursday?
4. **Kaia NetSuite/Zip split** — confirm the architecture to prevent Max/Caio from using Zip when they need NetSuite.

## Questions to Ask

- Did the Sterling call happen? If yes, what was the OMS configuration outcome?
- Is Anand comfortable starting the Kaia/Nimbl conversation before Jorge is back?
- On AMS-OSRAM: can Anand advance the PO escalation now, or is it Jorge-gated until Thursday?
- On Kaia inventory: who creates the NetSuite PO? (Max has no access)
- Does Anand's finance support commitment on Zip #3511 cover Bradley + QARA unblock?

## DO NOT Discuss

- Internal pricing targets or volumes beyond what Anand already knows
- M-Band CM shortlist specifics (Jorge's track)
- Other component suppliers competing with AMS-OSRAM / Nordic alternatives
- Second Page Yoga pricing vs 4imprint delta

---

*Sources: Anand DM, #pulse-devices, #kaia-nimbl-fullfillment, #pm-npi-isc, context/kaia/suppliers.md. OI DB 429 rate-limited — OI details from session snapshot (May 12 morning).*
