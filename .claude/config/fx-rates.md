# FX Rates

Reference FX rates used when converting supplier quotes to EUR for Notion DB fields (Unit Cost (EUR), Tooling Cost (EUR)).

## Current rates (April 2026)

| Pair | Rate | Source | Last updated |
|------|------|--------|--------------|
| USD → EUR | 0.92 | ECB reference, Apr 2026 | 2026-04-14 |
| RMB → EUR | 0.128 | ECB reference, Apr 2026 | 2026-04-14 |
| RMB → USD | 0.139 | ECB reference, Apr 2026 | 2026-04-14 |

## Rules

- Use these rates when converting a supplier quote to EUR for DB storage.
- Round EUR values to 3 decimals for Unit Cost, 0 decimals for Tooling ≥ 1,000 EUR.
- When rates move >5% vs stored EUR values, flag in /housekeeping as "FX drift — review supplier EUR fields".
- Update this file on the 1st of each month (manual task, add to /wrap-up checklist).
- Do NOT adjust already-written EUR values on every rate move — only when drift triggers the flag above, to avoid churn on comparison data.

## Change log

- 2026-04-14: initial rates set. Applied to MCM, SHX Watch, GAOYI, Lihua (M-Band).
