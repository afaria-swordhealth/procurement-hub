---
name: "Quote Intake"
description: "Process incoming supplier quotes: extract pricing, convert currency, calculate full landed cost, update Notion DB fields and Quote section, compare against existing quotes. Use when a supplier sends a quote or revised pricing via email or attachment."
---

# Quote Intake

Extracts pricing from a supplier quote, converts to EUR, calculates FLC, updates Notion, and compares against the existing supplier set for that project.

## Pre-flight

1. Read `outputs/session-state.md` for freshness.
2. Read `.claude/config/databases.md` (DB IDs, schemas, query patterns).
3. Read `.claude/config/fx-rates.md` (current conversion rates).
4. Read `.claude/config/strategy.md` (Cost Analysis Rules section).
5. Read `.claude/procedures/fill-cost-fields-on-quote.md` (tier reference, field rules).
6. Read `.claude/procedures/check-outreach.md` (milestone entry format).
7. Read `.claude/procedures/create-open-item.md` (OI field requirements).
8. Read `context/{project}/suppliers.md` for the supplier's current state.
9. **Execution checkpoint check:** call `mcp__ruflo__memory_retrieve` with key `"exec::quote-intake::{supplier_name}"`, namespace "procurement". If a record is returned with `status: "in-progress"`: STOP. Surface to André: "Incomplete prior run detected on {date}. Steps completed: {steps_done}. Resume from that point, or confirm fresh start to overwrite."

## Step 1: Extract pricing from quote

Parse the quote source (email body, attachment, or Andre's input).

**Required:** unit price(s) per tier, currency (verify vs. region), MOQ, tooling/NRE (itemized, "no tooling" = 0), lead time (tooling + production separately), Incoterms (FOB/EXW/FCA/DDP).

**If stated:** payment terms, sample cost, certifications (ISO 13485, FDA, CE), quote validity (flag if < 30 days).

If any required field is missing, list gaps and recommend asking the supplier.

## Step 2: Currency conversion

Use rates from `.claude/config/fx-rates.md`. Never hardcode rates.

| Source | Conversion |
|--------|-----------|
| RMB quote | RMB -> EUR (current rate) |
| USD quote | USD -> EUR (current rate) |
| EUR quote | No conversion needed |

Record the rate used and source currency for audit trail. Round per `fill-cost-fields-on-quote.md` rules: Unit Cost to 3 decimals, Tooling to 0 decimals if >= 1,000 EUR.

## Step 3: Calculate Full Landed Cost (FLC)

FLC = Unit price + Freight estimate + Duties + Fulfillment

### Incoterms reference

What the buyer must add on top of the quoted price to reach FLC:

| Incoterm | Buyer adds |
|----------|-----------|
| **EXW** | Local transport + export customs + freight + import duties + last-mile |
| **FCA** | Freight + import duties + last-mile |
| **FOB** | Freight + import duties + last-mile |
| **DDP** | Last-mile only (supplier covers everything else) |

### FLC components

- **Unit price:** at reference tier per `fill-cost-fields-on-quote.md`
- **Freight:** CN->PT sea ~$0.30-0.80/unit (varies by CBM). Ask Andre for current benchmarks if unknown.
- **Duties:** by HS code + origin. Flag if unknown, do not guess.
- **Fulfillment:** Nimbl rates $13.15-$17.15/unit (M-Band only). Not all projects use Nimbl.

If freight or duties are unknown, present FLC as a range or flag "partial FLC". Never present incomplete FLC as final.

### FOB vs. Landed rule

**NEVER compare FOB and landed prices directly without flagging.** Label every price with its basis (`$X.XX FOB` or `$X.XX FLC`). Normalize to same basis before comparing. If normalization is impossible, present side-by-side with a clear warning.

## Step 4: Fill Notion DB cost fields

Per `procedures/fill-cost-fields-on-quote.md`:

1. Identify the reference tier for this project (Pulse: @5K, Kaia: @1K, M-Band: @5K current).
2. Convert unit price at reference tier to EUR.
3. Propose values for:
   - `Unit Cost (EUR)`: 3 decimal places
   - `Tooling Cost (EUR)`: 0 decimals if >= 1,000, else 2 decimals
   - `FX Rate at Quote`: the actual rate used from `config/fx-rates.md` (e.g. `0.128` for RMB→EUR). For EUR quotes, set to `1.0`. Stamps the rate basis on each quote so cost comparisons later can detect FX drift without guessing which rate was applied.

**Prior quote pre-check (must run before auto-write decision):** Call `mcp__ruflo__memory_search` with query `"quote {supplier_name}"`, namespace "procurement", limit 1. Store result as `{prior_quote}`. This gates the auto-write condition below AND populates `delta_vs_prev_pct` in Step 8 — no second ruflo call is needed there. If ruflo MCP fails: treat as no prior quote found — route to SHOW BEFORE WRITE (no anchor for the 30% delta check).

**Before writing:** store execution checkpoint — `key: exec::quote-intake::{supplier}`, namespace "procurement", upsert true, value: `{ skill: "quote-intake", supplier, date, status: "in-progress", steps_done: [] }`.

**Auto-write path (CLAUDE.md §5 Exception 3):** If ALL conditions are true, write DB fields immediately and output a single confirmation line — `Auto-wrote: Unit Cost X.XXX EUR, Tooling X EUR (source: [currency] [amount]@[tier], FX: [rate])`:
- No flags raised in Steps 1-3 (no: >30% delta from median, FOB/landed mix, missing required fields, tier mismatch)
- FX rate sourced from `fx-rates.md`
- A prior quote exists in ruflo for this supplier AND the computed EUR value is within 30% of it. If no prior quote exists, route to SHOW BEFORE WRITE — first-ever quotes have no anchor for the range check.

**SHOW BEFORE WRITE path (fallback):** If any condition fails, present values (source tier, source currency, FX rate, converted amount) to André before writing.

After DB fields write succeeds: update checkpoint — `steps_done: ["db_fields"]`.

If the supplier quoted a different tier than the reference, write that value and flag `tier mismatch` in the change-log. Do not inflate or deflate.

## Step 5: Update supplier page Quote section

Update the `## Quote` section on the supplier's Notion page. Consolidate inline (per Apr 14 convention): one structured block per quote, not sub-pages.

### Quote section format

One block per quote, most recent on top. Each block: `**Quote {date} — {Incoterm}**`, tier table (source currency + EUR), then bullet list: Tooling/NRE, MOQ, Lead time (tooling + production), Payment terms, Validity, FLC estimate with basis. Keep older quotes below.

**If Step 4 used auto-write path:** write Quote section immediately as part of the same operation, no gate.
**If Step 4 used SHOW BEFORE WRITE path:** SHOW BEFORE WRITE for Quote section as well.
After Quote section write succeeds: update checkpoint — `steps_done: ["db_fields", "quote_section"]`.

## Step 6: Compare against existing quotes

Query active suppliers in the same project DB:

```sql
SELECT Name, Status, "Unit Cost (EUR)", "Tooling Cost (EUR)", Notes, id, url
FROM "{SUPPLIER_DB}"
WHERE Status NOT IN ('Rejected', 'Identified')
```

Build the comparison table using `Unit Cost (EUR)` and `Tooling Cost (EUR)` DB fields from the query above — no prose read needed for pricing. For suppliers where both fields are null, note "pricing not yet processed via quote-intake." For full quote details (Incoterm, MOQ, lead time, FLC basis): read the current supplier's Quote section only (not all active suppliers). Note FX rates used and flag FOB/landed mix, tier mismatches, or expired quotes. Output only, no writes.

## Step 7: Flag, update context, and log

**Flag issues:** FOB vs. landed mix, expired quotes (past validity), missing tiers, tier mismatch vs. project reference, outlier pricing (>30% above/below median), missing required fields from Step 1.

**Update context:** Add to `context/{project}/suppliers.md`: quote date, key pricing (reference tier, EUR), FLC estimate, flags. After context write: update checkpoint — `steps_done: ["db_fields", "quote_section", "context_file"]`.

**Log to change-log.md:**
```
YYYY-MM-DD HH:MM | quote-intake | {Supplier} quote processed | Unit: {X} {currency} -> {Y} EUR @{tier} | Tooling: {Z} EUR | FX: {rate}
```
After change-log write: update checkpoint — `steps_done: ["db_fields", "quote_section", "context_file", "change_log"]`.

**Log outreach milestone** per `procedures/check-outreach.md` (direct write, no approval):
```
**Mon DD** -- Quote received. {currency} {price}/unit @{tier}, tooling {amount}. {Incoterm}.
```
After outreach write: update checkpoint — `steps_done: ["db_fields", "quote_section", "context_file", "change_log", "outreach"]`.

**(M4)** Update `Last Outreach Date` DB field to today via `notion-update-page`. Skip if Status = 'Rejected'; skip silently if field not yet created in Notion UI. If update fails, log to change-log and proceed. After Last Outreach Date update: update checkpoint — `steps_done: ["db_fields", "quote_section", "context_file", "change_log", "outreach", "last_outreach_date"]`.

## Step 8: Store quote in ruflo memory

After all Notion writes are complete, call `mcp__ruflo__memory_store`:

- `key`: `quote::[supplier_name]::[YYYY-MM-DD]`
- `namespace`: "procurement"
- `upsert`: true
- `tags`: ["quote", project, supplier_name]
- `value`:
  ```json
  {
    "supplier": "{name}",
    "project": "{Pulse|Kaia|M-Band|BloomPod}",
    "date": "{YYYY-MM-DD}",
    "unit_eur": {value},
    "tooling_eur": {value},
    "incoterm": "{FOB|EXW|FCA|DDP}",
    "lead_time_weeks": {production_weeks},
    "tier": "{reference tier}",
    "fx_rate": {rate_used},
    "flc_eur": {value_or_null},
    "quote_complete": true/false,
    "response_time_days": {days_from_rfq_to_quote_or_null},
    "delta_vs_prev_pct": {pct_change_vs_last_quote_or_null}
  }
  ```

`delta_vs_prev_pct`: use `{prior_quote}` fetched in the Step 4 pre-check (no second ruflo call needed). If a prior quote was found, compute `(new_unit - prev_unit) / prev_unit * 100`. If none found, set null.

After ruflo store succeeds: update checkpoint — `status: "complete"`, `steps_done: ["db_fields", "quote_section", "context_file", "change_log", "outreach", "ruflo"]`.

## Rules

- NEVER send emails. Gmail draft only (Level 1 safety).
- SHOW BEFORE WRITE for DB cost fields (Level 2) and Quote section updates.
- Outreach milestone entries go directly to Notion without approval (per `check-outreach.md`).
- NEVER compare FOB and landed prices without flagging the distinction.
- All Notion content in English. No em dashes.
- Use FX rates from `config/fx-rates.md` only. Never hardcode conversion rates.
- Round EUR: 3 decimals for Unit Cost, 0 decimals for Tooling >= 1,000 EUR.
- Flag incomplete FLC. Never present partial data as final.
- Log all Notion writes to `outputs/change-log.md`.
- Check `outputs/change-log.md` collision guard (10-min window) before any Notion write.
- OI Context rewrites require approval. OI comment adds via notion-create-comment are auto-approved (per CLAUDE.md §5 Exception 2) — write directly, log to change-log.
- **MCP error handling — single supplier:** If Notion MCP fails at any write step (DB fields, Quote section): HALT, log to change-log, surface to André — do not write partial data. If ruflo MCP fails (pre-check Step 4, checkpoint store, memory store Step 8): log and proceed — ruflo is non-critical and its failure routes auto-write to SHOW BEFORE WRITE.
