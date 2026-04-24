# Ledger Append

Write-side procedure. Called by any skill at the moment an André approval decision lands.

## When to append

After every SHOW BEFORE WRITE interaction — regardless of outcome. One line per decision.

**Append triggers:**
- André approves the payload as-shown → `decision = approved_clean`
- André approves but edits the payload first → `decision = approved_edited`
- André rejects the payload → `decision = rejected`

**Do NOT append when:**
- The write is auto-approved via a §5 Exception (those are already auto; ledger measures gated-then-approved patterns).
- The gate was skipped because the skill HALTed for a different reason (MCP failure, missing pre-flight data).
- The write never materialized because André changed scope mid-decision — those are not decisions on the original payload.

## Line format

```
{YYYY-MM-DD HH:MM} | {action_class} | {decision} | {tier} | {skill} | {notes}
```

- `YYYY-MM-DD HH:MM` — system `currentDate` + local time. Never future-dated.
- `action_class` — canonical short label. See table below. Same class = same gate across skills.
- `decision` — exactly one of `approved_clean`, `approved_edited`, `rejected`.
- `tier` — one of `cosmetic`, `cost_sensitive`, `irreversible`. Cosmetic = reversible <30s in Notion UI. Cost-sensitive = affects pricing or procurement workflow decisions. Irreversible = downstream commitment, legal implication, or supplier-facing content. Classes marked `never_promote` are always `irreversible`. Lookup from the table below.
- `skill` — slash-name of the command or skill that raised the gate (`quote-intake`, `supplier-rejection`, `rfq-workflow`, etc.).
- `notes` — ≤80 chars. Supplier name, OI short id, or flag that led to the gate. Omit `|` inside notes (replace with ` / `).

## Canonical action_class values

Start here. Add new values by convention; they become canonical after 5 uses.

| action_class | Raised by | Typical gate | Tier |
|---|---|---|---|
| `outreach_milestone` | log-sent, supplier-chaser | Milestone append to Outreach section | cosmetic |
| `oi_status_in_progress` | mail-scan, housekeeping | Pending → In Progress on OI | cosmetic |
| `oi_status_blocked` | any | → Blocked transition | cost_sensitive |
| `oi_status_closed` | supplier-rejection, supplier-selection | → Closed with Resolution | cost_sensitive |
| `oi_create_action` | any | New OI of Type=Action Item | cost_sensitive |
| `oi_create_decision` | any | New OI of Type=Decision | cost_sensitive |
| `oi_create_blocker` | any | New OI of Type=Blocker | cost_sensitive |
| `cost_field_within_30pct` | quote-intake | Unit Cost / Tooling Cost update within anchor | cost_sensitive |
| `cost_field_outside_30pct` | quote-intake | Same write but outside anchor — `never_promote` | irreversible |
| `fx_stamp_write` | quote-intake | FX Rate at Quote stamp | cost_sensitive |
| `supplier_notes_reformat` | housekeeping | Cosmetic Notes rewrite | cosmetic |
| `supplier_status_rejected` | supplier-rejection | `never_promote` (commercial decision) | irreversible |
| `nda_status_write` | onboarding, housekeeping | `never_promote` (legal) | irreversible |
| `email_draft_send` | supplier-chaser, supplier-rejection, rfq-workflow | `never_promote` (supplier-facing content) | irreversible |
| `slack_message_send` | any Slack draft | `never_promote` (supplier-facing) | irreversible |

`never_promote` classes log for audit but never cross into promotion candidates.

## Implementation

Every skill that runs a SHOW BEFORE WRITE flow ends its decision block with:

1. Read `outputs/autonomy-ledger.md` (only to find end of file).
2. Append one line under `## Entries` matching the format above.
3. No other side-effects. Ledger append never fails the parent operation — on write error, log to change-log as `[EVENT: FAIL target=autonomy_ledger skill=X]` and continue.

Atomic: single append, no locking needed (session-single concurrency model per `.claude/safety.md`).

## Examples

```
2026-04-20 09:41 | outreach_milestone | approved_clean | cosmetic | log-sent | Transtek / quote_received
2026-04-20 09:55 | oi_status_in_progress | approved_clean | cosmetic | mail-scan | OI 33eb4a7d-9059
2026-04-20 10:12 | cost_field_within_30pct | approved_edited | cost_sensitive | quote-intake | Unique_Scales / tooling
2026-04-20 10:30 | email_draft_send | rejected | irreversible | supplier-chaser | Ribermold / tone
2026-04-20 14:02 | supplier_status_rejected | approved_clean | irreversible | supplier-rejection | Vangest
```

## Consumers

- `/improve` Step 1 Source F — reads ledger for promotion candidates (see `.claude/autonomy.md`).
- `/wrap-up` Phase 5 — emits delta summary (new entries since last wrap-up, classes approaching threshold).
- Not by other skills. The ledger is a record, not a decision input.
