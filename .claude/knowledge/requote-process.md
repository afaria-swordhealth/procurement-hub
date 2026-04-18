# Re-quote Process
# Sword Health ISC — Procurement Knowledge Base
# Sword Insighter | Last updated: 2026-04-19

When and how to request a revised quote from a supplier who has already quoted. Different from a first RFQ — the relationship already exists, the approach is warmer and shorter.

---

## Triggers

Request a re-quote when:

| Trigger | Notes |
|---------|-------|
| **Design change** | Specs changed materially (dimensions, materials, BOM). Always re-quote if change affects tooling. |
| **Volume shift** | Target qty moved >30% from quoted tier. Use to renegotiate. |
| **Quote expiry** | Validity window expired (flagged in quote-intake at <30 days). |
| **Competitive pressure** | Another supplier came in lower. Legitimate counter-request, but see rules below. |
| **Currency move** | Significant FX movement (>5%) since quote. Request updated EUR pricing. |
| **Tooling refinement** | Initial tooling was an estimate; supplier now has actual mold cost. |

---

## What to share vs. withhold

| Share | Withhold |
|-------|---------|
| Updated specs (if design change) | Competing supplier's price |
| New volume tier(s) | Competing supplier's name |
| Revised delivery destination | Internal cost target |
| Reason for re-quote (high level: "updated volume plan", "design refinement") | Internal decision deadline |
| Revised production timeline (lead time only, not decision date) | Shortlist position |

**Competitive pressure:** Frame as "we're reviewing our options and want to ensure your pricing reflects current conditions." Never say "a competitor quoted lower" or imply the gap in absolute terms.

---

## Email format

Re-quote emails are shorter and warmer than first RFQs. Do not re-send the full 8-item RFQ checklist unless specs changed materially.

Structure:
1. Reference the prior quote (date, what was covered).
2. State what changed or that you're refreshing (expiry, volume update).
3. List only what's new or needs updating.
4. Response deadline: 10 business days default. Shorter if urgent (state why).
5. Sign-off per `config/writing-style.md`.

Use the `rfq-workflow` skill for draft creation. In Step 2 (assemble package): note this is a re-quote, reference prior quote date, and include only changed elements.

---

## Notion documentation

### Quote section
Add a new block at the top of `## Quote` on the supplier page (most recent first). Label clearly:

```
**Quote YYYY-MM-DD — [Incoterm] (Revised)**
```

Include in the block: what changed vs. prior quote, new pricing at reference tier, delta vs. previous quote. Keep the original quote block below for comparison.

### DB cost fields
Update `Unit Cost (EUR)` and `Tooling Cost (EUR)` only after the re-quote is received and confirmed — not when requested. Use `quote-intake` skill. Delta is auto-calculated in ruflo (Step 8 of quote-intake).

### Open Items
- If re-quote was triggered by an expiry or blocker: add a Notion page comment to the existing OI with request date and expected response. Do NOT create a new OI — update the existing one.
- If re-quote is triggered by a design change with no existing OI: create an OI "Supplier — Re-quote (design change)" | Pending | Action Item | Deadline: response due date.

---

## Ruflo delta tracking

`quote-intake` Step 8 auto-calculates `delta_vs_prev_pct` = (new_unit - prev_unit) / prev_unit × 100:
- Positive: price increased. Flag if >5%.
- Negative: price decreased. Log as a negotiation win.

Store the trigger in the ruflo memory value so patterns are trackable over time (which triggers tend to yield favorable re-quotes).

---

## Outreach milestone

Log in supplier Outreach section (direct write, per `check-outreach.md`):
```
**Mon DD** -- Re-quote requested. [Reason]. Response due Mon DD.
```
When re-quote arrives:
```
**Mon DD** -- Revised quote received. [Unit price] [currency] @[tier]. [Delta note if significant.]
```

---

## Rules

- Always request re-quotes via email. Never phone or Slack — audit trail matters.
- Never share the prior quote document in the re-quote email (supplier has it; sharing signals comparison).
- Do not request a competitive counter-quote if the supplier is already out of consideration. Only re-quote if they are genuinely still in the running.
- If re-quoting due to expiry: check that the supplier's status is still active (not Rejected or Paused) before reaching out.
- Never create a duplicate OI for a re-quote if one already exists for that supplier's pricing activity. Update the existing one.
