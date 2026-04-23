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
9. **Execution checkpoint check:** per `procedures/exec-checkpoints.md`, read `outputs/checkpoints/quote-intake_{supplier_slug}.json`. If file exists with `status: "in-progress"`: STOP. Surface to André: "Incomplete prior run detected on {started}. Steps completed: {steps_done}. Resume from that point, or confirm fresh start to overwrite?" If André confirms resume: follow **## Step Resumption** below. If missing or `status: "complete"`: proceed (archive complete runs per the procedure).
10. **Lessons read:** per `.claude/procedures/lessons-read.md`, read `.claude/skills/quote-intake/lessons.md` (top 10). Apply before default behavior. If missing or empty, skip.

## Step Resumption

When André confirms resume after an in-progress checkpoint, look up the **last entry** in `steps_done` and jump to the corresponding entry point. Skip all steps already listed in `steps_done` — do not re-run them.

| Last completed (`steps_done` tail) | Resume from |
|---|---|
| *(empty — checkpoint written, no steps done)* | Step 4: Fill Notion DB cost fields |
| `db_fields` | Step 5: Update supplier page Quote section |
| `quote_section` | Step 7: Update context file (`context/{project}/suppliers.md`) |
| `context_file` | Step 7: Log to `outputs/change-log.md` |
| `change_log` | Step 7: Log outreach milestone (check-outreach.md) |
| `outreach` | Step 7 (M4): Update Last Outreach Date DB field |
| `last_outreach_date` | Step 8: Store quote in ruflo memory |

Re-read the checkpoint file to recover `meta.project` and `meta.supplier` before resuming. The `steps_done` list is the single source of truth for what already succeeded.

## Step 1: Extract pricing from quote

Parse the quote source (email body, PDF/XLSX attachment, or André's input).

**Required:** unit price(s) per tier, currency (verify vs. region), MOQ, tooling/NRE (itemized, "no tooling" = 0), lead time (tooling + production separately), Incoterms (FOB/EXW/FCA/DDP).

**If stated:** payment terms, sample cost, certifications (ISO 13485, FDA, CE), quote validity (flag if < 30 days — routes to SHOW BEFORE WRITE in Step 4, does not halt; validity may expire before PO is placed).

If any required field is missing, list gaps and recommend asking the supplier.

### Step 1a: PDF attachment prefill (Levelpath pattern)

When the quote source is a PDF attachment (detected by `.pdf` extension in André's input or Gmail attachment):

1. Load the PDF via the Read tool. For PDFs > 10 pages, read in chunks using `pages` param (pricing tables usually first 3-5 pages).
2. Extract the 7 canonical fields into a single structured payload:
   - `unit_price_tier_table` (list of `{qty, unit_price, currency}` rows)
   - `tooling_nre` (amount + currency; "no tooling" = 0)
   - `moq` (integer)
   - `lead_time` (tooling weeks + production weeks; flag if only one stated)
   - `incoterm` (FOB/EXW/FCA/DDP + named place if present)
   - `payment_terms` (e.g. "30% deposit / 70% before shipment")
   - `fx_base` (currency stated on the quote — not the FX rate)
3. Record extraction confidence per field: `high` (explicit label + value), `medium` (inferred from table header), `low` (guessed from context — requires André confirm). Low-confidence fields cannot be auto-written; route to SHOW BEFORE WRITE regardless of Step 4 conditions.
4. If the PDF is scanned (image-only, no text layer): report "PDF OCR required — paste values manually or re-send text PDF" and HALT Step 1a. Do not fabricate values.
5. Log the extraction to change-log as `[EVENT: PDF_EXTRACT supplier={name} pdf={filename} fields_high={N} fields_low={N}]`.

Output of Step 1a is the same structured payload that feeds Steps 2-4. One parse, one approval gate (Step 4 auto-write OR SHOW BEFORE WRITE), instead of 3-4 approvals.

**Never send drafts or trigger supplier emails from this skill.** Step 1a only reads and prefills.

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

**Before writing:** store execution checkpoint per `procedures/exec-checkpoints.md` — write `outputs/checkpoints/quote-intake_{supplier_slug}.json` with `{ skill: "quote-intake", entity: "{supplier}", started, last_update, status: "in-progress", steps_done: [], meta: { project, supplier } }`. Atomic write (tmp + rename). On write failure: STOP (checkpoint is load-bearing).

**Auto-write path (CLAUDE.md §5 Exception 3):** If ALL conditions are true, write DB fields immediately and output a single confirmation line — `Auto-wrote: Unit Cost X.XXX EUR, Tooling X EUR (source: [currency] [amount]@[tier], FX: [rate])`:
- No flags raised in Steps 1-3 (no: >30% delta from median, FOB/landed mix, missing required fields, tier mismatch)
- FX rate sourced from `fx-rates.md`
- A prior quote exists in ruflo for this supplier AND `abs((new_unit_eur - prior_unit_eur) / prior_unit_eur) <= 0.30`. If no prior quote exists, route to SHOW BEFORE WRITE — first-ever quotes have no anchor for the range check.

**SHOW BEFORE WRITE path (fallback):** If any condition fails, present values (source tier, source currency, FX rate, converted amount) to André before writing. After André's decision (approved / approved+edit / rejected), append one line to `outputs/autonomy-ledger.md` per `.claude/procedures/ledger-append.md`. Class: `cost_field_within_30pct` or `cost_field_outside_30pct` depending on whether the delta was within 30%; `fx_stamp_write` for FX Rate stamps.

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
- Writing conventions: see `.claude/config/writing-style.md`.
- Use FX rates from `config/fx-rates.md` only. Never hardcode conversion rates.
- Round EUR: 3 decimals for Unit Cost, 0 decimals for Tooling >= 1,000 EUR.
- Flag incomplete FLC. Never present partial data as final.
- Log all Notion writes to `outputs/change-log.md`.
- Concurrency: session-single model (see `.claude/safety.md`). No per-write collision check.
- OI Context rewrites require approval. OI comment adds via notion-create-comment are auto-approved (per CLAUDE.md §5 Exception 2) — write directly, log to change-log.
- **MCP error handling — single supplier:** If Notion MCP fails at any write step (DB fields, Quote section): HALT, log to change-log, surface to André — do not write partial data. If ruflo MCP fails (pre-check Step 4, checkpoint store, memory store Step 8): log and proceed — ruflo is non-critical and its failure routes auto-write to SHOW BEFORE WRITE.
- **Autonomy ledger:** after every SHOW BEFORE WRITE decision on a cost-field or Quote-section payload, append one line to `outputs/autonomy-ledger.md` per `.claude/procedures/ledger-append.md`. Classes: `cost_field_within_30pct` or `cost_field_outside_30pct` (latter is `never_promote`); `fx_stamp_write` for FX Rate stamps.
