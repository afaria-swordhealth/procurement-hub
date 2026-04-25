# Autonomy — Evidence-Based Promotion

How new auto-approvals get promoted into `safety.md` Exceptions. Replaces the habit of adding ad-hoc Exceptions whenever a mechanical step feels over-gated.

Principle: do not infer autonomy from intuition. Earn it from the ledger.

## The ledger

File: `outputs/autonomy-ledger.md` (created in Layer 4, append-only).

Every SHOW BEFORE WRITE interaction writes one line:

```
{YYYY-MM-DD HH:MM} | {action_class} | {decision} | {tier} | {skill} | {notes}
```

- `action_class` — short canonical label for the action type (e.g., `outreach_milestone`, `oi_status_in_progress`, `cost_field_within_30pct`, `supplier_notes_reformat`). The same class groups equivalent interactions across skills.
- `decision` — one of:
  - `approved_clean` — André approved without edit
  - `approved_edited` — André approved but edited the payload first
  - `rejected` — André rejected
- `tier` — one of `cosmetic`, `cost_sensitive`, `irreversible`. Lookup from `procedures/ledger-append.md` table. Determines promotion eligibility: `irreversible` classes never promote.
- `skill` — the skill or command that produced the gate
- `notes` — optional 1-line context (supplier, OI, flag)

## Promotion rule

A candidate `action_class` is eligible for auto-approval when:

1. **20 consecutive `approved_clean`** outcomes in the ledger for that class
2. **Zero `rejected`** in the last 50 outcomes for that class
3. **No `approved_edited`** in the last 20 outcomes (edits mean the payload needed adjustment — not safe to auto-approve yet)

When the rule fires, `/improve` surfaces a promotion proposal:

```
Autonomy candidate: {action_class}
  Evidence: 20 clean approvals since {date}, 0 rejections in last 50, 0 edits in last 20.
  Skills affected: {list}
  Proposed Exception text: {draft}
  Accept → append as new Exception in safety.md and update affected skills.
  Reject → reset counter; optionally add `never_promote` tag to the class.
```

Only André accepts the promotion. Never auto-append to `safety.md`.

## Hard stops (never promote)

Some action classes are permanently gated regardless of ledger state:

- **Supplier-facing content:** any email draft body, Slack message body, or Notion comment that a supplier will read. Tone and facts are non-mechanical.
- **Supplier status changes to `Rejected`:** commercial decision, always SHOW BEFORE WRITE.
- **NDA Status field changes (except housekeeping "Not Required" on Rejected):** legal implication.
- **Price field writes that fail any Exception 3 condition:** the 30% anchor, FX source, or flag check is the whole safety margin.
- **Anything with irreversible downstream effect** (vendor onboarding, PO issuance, budget requests).

These are `tier=irreversible` in the ledger schema. `/improve` Source F skips any `action_class` where tier is `irreversible`, regardless of clean-streak count. Cross-reference `procedures/ledger-append.md` Tier column — `never_promote` classes are always `irreversible`.

## Relationship to existing Exceptions 1-5

Exceptions 1-5 in `safety.md` were grandfathered in without a ledger. They stay as-is.

Going forward, every new auto-approval must either:
- Be promoted via the ledger rule above, or
- Be explicitly added by André with a written rationale (rare — typically only when a ledger-based path is impossible, e.g., a brand-new action class with no operational history).

## Demotion

If a promoted auto-approval later produces any `rejected` decision:
- Revert to SHOW BEFORE WRITE immediately (remove from `safety.md`).
- Log the demotion in change-log.
- Class remains ineligible for re-promotion for 30 days after the rejection.

## Ledger hygiene

- `/improve` reads the ledger each run (Source in Step 1).
- `/wrap-up` includes a ledger delta summary: new entries since last wrap-up, promotion candidates approaching threshold.
- Monthly: `/improve` proposes `never_promote` tags for classes that have hit threshold 3+ times but keep getting rejected at review.
- Monthly calibration: `/improve` Source F computes approval rate and projected promotion date per class (gated on `Last-Calibration` in ledger header — fires when null or ≥ 30 days old).

## Out of scope

This file governs promotion only. Day-to-day approvals still flow through the skill that raised the gate — the ledger is a passive recorder, not a real-time decision engine.
