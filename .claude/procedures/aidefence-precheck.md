# AIDefence Pre-check

Fail-open PII / sensitive-content pre-check for outbound supplier-facing drafts. Invoked by any skill before `mcp__claude_ai_Gmail__create_draft` or Slack draft delivery.

## Why

Ruflo's `aidefence_has_pii` tool flags content that contains patterns typical of personal data (phone numbers, NIF, credit cards, passport numbers, etc.). Supplier-facing drafts occasionally embed internal identifiers by accident (employee IDs, André's personal mobile, test credit card numbers from cost analyses). Catching these pre-send protects reputation and compliance.

Fail-open means: if the check cannot run (MCP down, timeout, unexpected output), the draft still ships with a log entry. The check is a safety net, not a gate.

## Invocation

Call `mcp__ruflo__aidefence_has_pii`:
- `text`: the full composed draft body (subject + body, concatenated with `\n\n`)
- `locale`: `"pt"` if Portuguese supplier, else `"en"`

Response shape:
```json
{ "has_pii": true/false, "detected": [{"type": "phone", "span": [142, 156]}, ...] }
```

## Decision tree

| `has_pii` | `detected[].type` | Action |
|---|---|---|
| `false` | — | Proceed. Log `[EVENT: PII_CHECK result=clean skill={skill}]` — optional, skip unless skill is auditing its own PII rate. |
| `true` | Contains only `phone` types AND all phones match known supplier contact numbers in `.claude/config/domains.md` | Proceed (false positive on supplier phone). Log `[EVENT: PII_CHECK result=cleared_supplier_contact skill={skill}]`. |
| `true` | Contains `email` types that match the recipient domain | Proceed (the recipient's own address). Log `[EVENT: PII_CHECK result=cleared_recipient skill={skill}]`. |
| `true` | Anything else (NIF, credit_card, internal_phone, passport, street_address not in config) | **STOP**. Surface to André:
  ```
  PII detected in {skill} draft for {supplier}:
  - {type} at chars {span_start}-{span_end}: "{redacted_excerpt}"
  Review the draft. Remove the content or confirm it's intentional before proceeding.
  ```
  Do NOT create the draft. Wait for André. |
| MCP error or unexpected shape | — | Proceed (fail-open). Log `[EVENT: PII_CHECK result=failed_open skill={skill} error={short_msg}]`. |

## Implementation in skills

Add to the pre-draft step (right before `create_draft`):

```
## Step Xa: PII pre-check
Per .claude/procedures/aidefence-precheck.md, call mcp__ruflo__aidefence_has_pii on the draft body.
- Clean or fail-open → proceed to create_draft.
- PII detected (and not a known false positive) → STOP and surface to André.
```

Skills that must adopt this:
- `rfq-workflow` (Step 3 before Gmail draft)
- `supplier-chaser` (Step 6 before each draft, including [AUTO])
- `supplier-rejection` (Step 7.1 before Gmail draft)
- `quote-intake` (if it ever creates a reply draft — currently does not; future-proof only)
- Any future skill that creates a Gmail or Slack draft to an external audience

## Logging

All PII checks (pass, clear, fail-open, stop) append one `[EVENT: PII_CHECK …]` line to `outputs/change-log.md` under `### Hook events`. This gives `/improve` a frequency signal for tuning the false-positive list.

## False positive maintenance

If `[EVENT: PII_CHECK result=stop]` hits the same type repeatedly for legitimate content (e.g., a price spec that looks like a credit card number), `/improve` surfaces a proposal to extend the "known false positive" table above. Only André approves extensions.

## Out of scope

- This does not block Notion writes. Notion content goes to a different audience (internal + stakeholders) — different compliance posture.
- This does not scan attachments or external Drive links. Links are passed through unmodified; the content they point to is outside this check.
- This does not rewrite drafts. It only flags; the draft remains as composed.
