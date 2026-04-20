# Typed Edit Payloads — SHOW BEFORE WRITE pattern v2

Replaces binary yes/no approval with a structured decision payload. Reduces approval count per skill run (quote-intake went 3–4 → 1, rfq-workflow 2 → 1) and captures André's edit intent in one pass instead of a multi-turn loop.

This procedure is a **specification**, not an executable script. Skills that adopt it (`quote-intake`, `rfq-workflow`, `supplier-rejection`) reference this file and implement the pattern inline. Adoption is incremental — a skill can ship the typed-edit pattern in one write site and keep the legacy pattern in others until all approvals are migrated.

---

## 1. The legacy pattern (what this replaces)

```
[Skill]: Here's draft X. Approve?
[André]: Change subject line to Y.
[Skill]: Updated. Here's draft X with Y. Approve?
[André]: Now remove the FDA paragraph.
[Skill]: Updated. Here's draft X with Y and no FDA paragraph. Approve?
[André]: OK.
[Skill]: Writing.
```

Three approval turns. Two re-renders. Four drafts. Cost: ~8k tokens per edit cycle. Friction: André reads the same output three times.

---

## 2. The typed-edit pattern

### 2.1 Decision payload shape

Every SHOW BEFORE WRITE gate accepts one of three responses:

```json
{ "decision": "approve" }
```

```json
{
  "decision": "approve_with_edit",
  "edits": {
    "subject": "new subject line",
    "body": "new body text",
    "fields": { "unit_cost": 7.45, "moq": 1000 },
    "remove": ["fda_paragraph", "capacity_question"]
  }
}
```

```json
{ "decision": "reject", "reason": "quote is stale, re-intake in a week" }
```

The `edits` object is skill-specific. Each skill documents which keys are valid in its `SKILL.md` (see §4 per-skill contracts below).

### 2.2 Flow

```
[Skill]: Here's draft X. Respond with approve | approve_with_edit {...} | reject.
[André]: approve_with_edit: change subject to Y, remove FDA paragraph.
[Skill]: Applied edits. Writing.
```

One approval turn. One draft. One edit pass. Cost: ~2k tokens.

### 2.3 When André's reply is not literal JSON

André does not type JSON. The skill parses his natural-language reply into the payload:

- `"approve"`, `"yes"`, `"ok"`, `"go"` → `{"decision": "approve"}`
- `"reject"`, `"no"`, `"skip"`, `"drop it"` → `{"decision": "reject"}`
- Any natural-language edit instruction → skill parses into `approve_with_edit` and echoes the parsed payload back for a final confirm ONLY IF the edit touches a field flagged as `high_risk` in §4. Otherwise, apply directly.

High-risk fields (require echo-back confirm): recipient email address, supplier selection, NDA status value, price sent to supplier, final OI Status = Closed.
Low-risk fields (apply directly): subject line, body prose, question list, formatting, attachments.

The goal is autonomy-first (memory: `feedback_autonomy_first.md`) — minimize rounds, but never auto-apply an edit that could misfire on a high-risk field.

---

## 3. Parse strategy (implementation note for skills)

1. Present draft with the prompt: `Respond with: approve | approve_with_edit {describe changes} | reject {optional reason}.`
2. When André replies, first check literal prefix (`"approve"`, `"reject"`, `"approve_with_edit"`).
3. If no prefix match, treat the reply as free-form. If it contains verbs like `"change"`, `"remove"`, `"add"`, `"replace"`, `"set"`, `"update"` → classify as `approve_with_edit` and extract.
4. If it contains negations like `"no"`, `"not yet"`, `"skip"` without edit verbs → classify as `reject`.
5. If ambiguous, ask one clarifying question: `"approve as-is, or approve with edits? If edits, what changes?"` — do NOT re-render the full draft.

## 4. Per-skill edit contracts

### 4.1 `quote-intake`

Valid `edits` keys:
- `unit_cost` (number) — overrides parsed unit cost
- `tooling_cost` (number) — overrides parsed tooling
- `moq` (number)
- `lead_time_days` (number)
- `currency` (enum: USD, EUR, CNY, PLN)
- `fx_rate` (number) — stamps a specific FX rate different from config/fx-rates.md
- `incoterm` (string)
- `payment_terms` (string)
- `notes` (string — appended to Notion notes)

High-risk (echo-back confirm): `unit_cost`, `tooling_cost`, `fx_rate`, `currency`.
Low-risk (apply directly): `moq`, `lead_time_days`, `incoterm`, `payment_terms`, `notes`.

### 4.2 `rfq-workflow`

Valid `edits` keys:
- `subject` (string)
- `body` (string — full replacement)
- `add_question` (string array — appended to the RFQ question list)
- `remove_question` (string array — question IDs to drop)
- `recipients` (string array — TO field)
- `cc` (string array)
- `attachments` (path array — additional files to include)

High-risk: `recipients`, `cc`.
Low-risk: `subject`, `body`, `add_question`, `remove_question`, `attachments`.

### 4.3 `supplier-rejection`

Valid `edits` keys:
- `body` (string — full replacement of rejection email body)
- `jorge_note` (string — full replacement of Portuguese internal note)
- `oi_closures` (array of OI IDs to close with custom resolution strings)
- `status_target` (enum: Rejected, Archived, On Hold)
- `keep_door_open` (boolean — adjusts closing line tone)

High-risk: `status_target`, `oi_closures`, recipient of rejection email.
Low-risk: `body`, `jorge_note`, `keep_door_open`.

### 4.4 Future adopters (L6 and beyond)

- `supplier-chaser` — edits on draft body, tone tier override, send window override.
- `meeting-prep` — edits on agenda items, attendee list, prep priorities.
- `weekly-report` — edits on draft narrative, metric inclusion, stakeholder list.
- `nda-check` — N/A (read-only, no writes).
- `scenario-optimizer` — N/A (read-only, no writes).
- `part-lookup` — N/A (read-only, no writes).

---

## 5. Ledger integration

Every typed-edit decision is logged to `outputs/autonomy-ledger.md` per L4A schema:

```
action_class: {skill_name}.{write_site}
decision: approved_clean | approved_edited | rejected
edits_applied: {count of keys in edits object}
edits_detail: {comma-separated key names, for pattern detection}
timestamp: YYYY-MM-DDTHH:MM
```

`approved_edited` replaces the prior single-dimension `edited` class — it now carries edit-shape telemetry. Promotion rule (20 clean + 0 rejected in last 50 + 0 edited in last 20, per `.claude/autonomy.md`) uses the same thresholds; edit-shape data informs which Exception proposal the ledger generates.

Example promotion insight: if `quote-intake.unit_cost_confirm` shows 20 `approved_clean` and 15 `approved_edited` where `edits_detail` always includes `notes` but never `unit_cost`, the promotion candidate is "auto-approve unit_cost parsing; auto-append notes field to user-edit queue". Without the edit-shape telemetry, the ledger could only propose "auto-approve all" (wrong) or nothing (status quo).

---

## 6. Migration order

Do NOT migrate all three skills in one sprint. Order:

1. **`quote-intake`** first — most approval turns per run (3–4), biggest time saving. 1 week observation.
2. **`rfq-workflow`** second — higher-risk writes (email recipients); adopt only after `quote-intake` shows zero mis-applied edits for 20 runs.
3. **`supplier-rejection`** third — highest-risk write (status change + email). Adopt last, and keep the high-risk field list stringent.

Each migration is its own L6 micro-fix or mini-sprint. This procedure is the forward-compatible spec; skill edits come in follow-up sprints gated on André's approval per migration.

---

## 7. Failure modes and fallbacks

| Failure | Fallback |
|---|---|
| André's reply is ambiguous (can't classify into approve / approve_with_edit / reject) | Ask one clarifying question, do not re-render draft. |
| Edit key is not in the skill's valid list | Surface the unknown key: "edit key `X` not recognized for this skill — did you mean Y?" |
| Edit value fails validation (e.g., `unit_cost: -5`) | Surface validation error with the offending key, do not apply any edits. |
| High-risk edit echo-back not confirmed within 2 turns | Cancel edit, fall back to legacy pattern (re-render + single approve/reject). |
| Skill has no typed-edit implementation yet | Legacy pattern (binary approve/reject) is still valid. Do not break skills mid-migration. |

---

## 8. What this procedure does NOT do

- Does not remove the SHOW BEFORE WRITE gate itself. Every write still shows first.
- Does not change which writes require approval. High-risk writes remain high-risk.
- Does not replace per-skill `lessons.md`. Edit-shape telemetry feeds the ledger; lessons feed the prompt. Different layer.
- Does not eliminate Gmail drafts (Level 1: Claude never sends email). Only the approval step changes; write semantics are unchanged.
- Does not introduce a new UI. All decisions go through the existing chat interface.
