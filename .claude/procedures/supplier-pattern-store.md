# Supplier Pattern Store

Ruflo-backed behavioral pattern store for each supplier. Complements the chase log (one entry per chase event) with a rolled-up profile (latest signal + response stats).

## Namespace

- `namespace`: `procurement`
- `key`: `supplier::{supplier_name_slug}::pattern`
  - `supplier_name_slug` is lowercase, dashes for spaces (e.g., `ribermold`, `transtek-hong-kong`, `unique-scales`).
- `upsert`: always `true` (one record per supplier, continuously updated).
- `tags`: `["supplier-pattern", {project}, {supplier_slug}]`.

## Schema (value field)

```json
{
  "supplier": "Ribermold",
  "project": "pulse",
  "channel_preference": "email",
  "language": "pt",
  "avg_response_days": 4.2,
  "last_response_days": 3,
  "response_rate_90d": 0.71,
  "last_chase_tier_that_worked": 1,
  "last_chase_tier_that_failed": 2,
  "last_chase_ts": "2026-04-10T14:22",
  "last_inbound_ts": "2026-04-13T09:05",
  "chase_count_90d": 4,
  "response_count_90d": 3,
  "known_patterns": [
    "Responds within 3-5 days on Tier 1",
    "Escalates to CC on Tier 3"
  ],
  "risk_flags": [],
  "last_updated": "2026-04-20T09:41"
}
```

Fields are additive. Unknown fields don't break reads. Missing fields read as `null` — consumers handle gracefully.

## Producers (who writes this)

### 1. supplier-chaser (Step 6)

After a chase is sent:
1. Read existing pattern record for the supplier.
2. Update fields:
   - `last_chase_ts` → now
   - `chase_count_90d` → increment (reset if last_updated > 90d ago)
   - `language` → from draft
   - `channel_preference` → channel used
3. `mcp__ruflo__memory_store` upsert.

### 2. /log-sent (Phase 5 observer)

When a milestone is logged for a supplier where Direction is "incoming response" (i.e., André replied to a supplier message):
1. Read existing pattern record.
2. Update response-side fields:
   - `last_inbound_ts` → incoming email ts
   - `response_count_90d` → increment (reset if last_updated > 90d ago)
   - `last_response_days` → `last_inbound_ts - last_chase_ts` in days
   - `avg_response_days` → rolling average (simple: `(old_avg × n + new_value) / (n + 1)` where n is prior sample size from `response_count_90d`)
   - `response_rate_90d` → `response_count_90d / max(chase_count_90d, 1)`
   - `last_chase_tier_that_worked` → prior `last_chase_tier_that_failed`'s tier if it produced this reply (infer from chase log within 14d window)
3. `mcp__ruflo__memory_store` upsert.

### 3. /wrap-up (Phase 5 daily rollup)

Not a per-event writer. On each wrap-up:
1. For suppliers touched today, re-derive `response_rate_90d` from the chase log (authoritative source) and store. This self-heals drift from missed per-event updates.
2. Trim `known_patterns` to the last 5 (keeping newest).

## Consumers (who reads this)

### 1. supplier-chaser Step 4a

Call `mcp__ruflo__memory_retrieve` for `supplier::{slug}::pattern`. If found:
- If `response_rate_90d < 0.3` AND `chase_count_90d ≥ 3`: escalate tone tier by +1 (Tier 1 → 2, Tier 2 → 3). Do not auto-escalate past Tier 3 — a 3+ miss supplier needs a human escalation decision, not a fourth draft.
- If `last_chase_tier_that_worked` is set: prefer that tier over default logic.
- If `avg_response_days` is set: use `last_chase_ts + 1.5 × avg_response_days` as "not yet overdue" (skip chase if within window).
- If `language` is set: override default language inference.

If no record found: fall back to default tone tier logic.

### 2. morning-brief (Step 3 scoring)

For each `[EVENT: RISK]` signal that names a supplier, fetch the pattern record. Bump urgency when:
- `response_rate_90d < 0.2` (unresponsive supplier)
- `last_chase_ts` is > 7 days ago AND `risk_flags` is non-empty

Integrates as a `×1.3` urgency multiplier, capped to the attention-budget cap.

### 3. /ask (indirect)

The pattern store is not indexed by `/ask` (it's operational state, not corpus). To query pattern facts, use `mcp__ruflo__memory_search` directly — `/ask` is for documentation, not live state.

## Retention

- No TTL on the record itself. Rolling 90-day counters handle freshness.
- On supplier rejection (supplier-rejection Step 7.1 completes):
  - Append to `known_patterns`: `Rejected on {date} — {reason_internal}`.
  - Set `risk_flags`: `["rejected"]`.
  - Do NOT delete the record — rejection history is useful for future re-engagement.

## Failure modes

- Ruflo MCP unreachable: producer skills log `[EVENT: FAIL target=supplier_pattern supplier={slug}]` and proceed. Consumer skills fall back to default logic (no pattern data = default tone).
- Record schema version drift: add fields defensively. Readers must not crash on missing keys.
- Slug collision: two suppliers with the same slug (e.g., two companies both slugged "shx") — disambiguate by appending `-{project}` (e.g., `shx-pulse`). Detect at write time by reading existing record and comparing `supplier` field.

## Not in scope

- This is not the chase log. Individual chase events still go to `chase::{supplier}::{date}` keys.
- This is not a risk register. Open risks live as `risk::{supplier}::{date}` keys with closure handled by supplier-rejection Step 7.7.
- This is not OI state. OIs live in Notion.
