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

**SHOW BEFORE WRITE.** Pricing field update is Level 2 per CLAUDE.md Safety Rules. Present values, source tier, source currency, FX rate, and converted amount to Andre before writing.

If the supplier quoted a different tier than the reference, write that value and flag `tier mismatch` in the change-log. Do not inflate or deflate.

## Step 5: Update supplier page Quote section

Update the `## Quote` section on the supplier's Notion page. Consolidate inline (per Apr 14 convention): one structured block per quote, not sub-pages.

### Quote section format

One block per quote, most recent on top. Each block: `**Quote {date} — {Incoterm}**`, tier table (source currency + EUR), then bullet list: Tooling/NRE, MOQ, Lead time (tooling + production), Payment terms, Validity, FLC estimate with basis. Keep older quotes below.

**SHOW BEFORE WRITE** for Quote section updates.

## Step 6: Compare against existing quotes

Query active suppliers in the same project DB:

```sql
SELECT Name, Status, Notes, id, url
FROM "{SUPPLIER_DB}"
WHERE Status NOT IN ('Rejected', 'Identified')
```

Read each supplier's Quote section. Build a comparison table: Supplier, Status, Unit (EUR) @tier, Tooling (EUR), MOQ, Lead Time, Incoterm, FLC (EUR). Note FX rates used and flag any FOB/landed mix, tier mismatches, or expired quotes. Output only, no writes.

## Step 7: Flag, update context, and log

**Flag issues:** FOB vs. landed mix, expired quotes (past validity), missing tiers, tier mismatch vs. project reference, outlier pricing (>30% above/below median), missing required fields from Step 1.

**Update context:** Add to `context/{project}/suppliers.md`: quote date, key pricing (reference tier, EUR), FLC estimate, flags.

**Log to change-log.md:**
```
YYYY-MM-DD HH:MM | quote-intake | {Supplier} quote processed | Unit: {X} {currency} -> {Y} EUR @{tier} | Tooling: {Z} EUR | FX: {rate}
```

**Log outreach milestone** per `procedures/check-outreach.md` (direct write, no approval):
```
**Mon DD** -- Quote received. {currency} {price}/unit @{tier}, tooling {amount}. {Incoterm}.
```

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
- OI Context prepends are auto-approved (per `create-open-item.md`).
