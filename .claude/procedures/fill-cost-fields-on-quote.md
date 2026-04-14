# Fill Cost Fields on Quote

Auto-populate the supplier DB fields `Unit Cost (EUR)` and `Tooling Cost (EUR)` whenever a new supplier quote arrives.

## Scope

Runs whenever any of these happen:
- `/mail-scan` detects a supplier email with a quote (keyword: quote, pricing, OR-xxx, attachment)
- `/log-sent` logs a milestone "Quote received"
- A Quote sub-page is created or updated on a supplier page
- André manually runs `/update-costs {supplier}`

Applies to all 3 Supplier DBs: Pulse, Kaia, M-Band.

## Rule

For every supplier with a new or updated quote:

1. Extract the **unit price at the reference tier** (see Tier Reference below) and the **tooling/NRE cost** from the quote.
2. Convert to EUR using `.claude/config/fx-rates.md` (current rate).
3. Write to DB fields:
   - `Unit Cost (EUR)`: 3 decimals
   - `Tooling Cost (EUR)`: 0 decimals if ≥ 1,000; else 2 decimals
4. Log to `outputs/change-log.md` with: supplier, source tier, source currency → EUR conversion, FX rate used.

Pricing field update is **Level 2 (SHOW BEFORE WRITE)** per CLAUDE.md Safety Rules. Present values and source to André before the write. Exception: auto-update of FX-only adjustments is never silent — always surfaces in /housekeeping.

## Tier Reference

Standard reference tier per project (chosen so suppliers are comparable on the same denominator):

| Project | Default Tier | Rationale |
|---------|-------------|-----------|
| M-Band | @5K (current) | Moving target. Will switch to @50K or @100K once multi-tier quotes land from Lihua + GAOYI (re-quote due Apr 21). |
| Pulse | @5K | MOQ-low suppliers, 5K covers first-order volume. |
| Kaia | @1K | Gated on Caio/Max, current discussions at lower volumes. |

When a supplier only quoted at a single tier (e.g. SHX Watch @200K), write that value and flag in the change-log with `⚠️ tier mismatch`. Do not inflate/deflate.

## Tooling field rules

- Tooling / NRE / setup cost at full program volume (typical @200K for M-Band).
- If tooling is "existing" or "no charge if no structural changes", enter 0 with a Notes field comment.
- If tooling is per-set (e.g. GAOYI ¥1,200), multiply by units required (typically 1 set of tools covers the run) — record as single amount, not per-unit.

## When tiers change

When the project's reference tier changes (e.g. M-Band moving from @5K to @50K after multi-tier quotes arrive):

1. Rewrite all `Unit Cost (EUR)` values at the new tier.
2. Log the tier change event in change-log.
3. Note the old tier in the supplier's Notes field if valuable for history.

## Related files

- `.claude/config/fx-rates.md` — current FX rates
- `.claude/config/databases.md` — supplier DB IDs
- `CLAUDE.md` §5 Safety Rules — Level 2 pricing write rule
