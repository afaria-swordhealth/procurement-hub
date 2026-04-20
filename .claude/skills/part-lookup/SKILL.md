---
name: "Part Lookup"
description: "Query Nexar/Octopart for a given MPN (Manufacturer Part Number): returns price breakpoints, stock across distributors, datasheet link, lifecycle status, and alternates. Used primarily for M-Band (NPM1300, Renesas components) and BloomPod (coin cells). Stub until Nexar MCP is configured — currently HALTs with setup instructions."
---

# Part Lookup

Wraps the Nexar API (Octopart) as an on-demand lookup for any electronic component. Returns pricing, stock, datasheet, lifecycle, and alternates for a given MPN. Central use cases: M-Band BOM risk assessment (NPM1300 shortage, Renesas Jul 1 price increase) and BloomPod shortlist research.

## ⚠ CRITICAL STOP — Nexar MCP not yet configured

As of the Layer 6 ship date, the Nexar MCP is **not wired into `.mcp.json`**. This skill scaffolds the workflow but cannot execute a live query.

Before first use, André must:

1. Obtain Nexar API credentials at https://nexar.com (free tier: 1000 queries/month; paid: usage-based).
2. Add the MCP configuration block to `.mcp.json`:
   ```json
   "nexar": {
     "command": "npx",
     "args": ["-y", "@nexar/mcp-server"],
     "env": {
       "NEXAR_CLIENT_ID": "...",
       "NEXAR_CLIENT_SECRET": "..."
     }
   }
   ```
   (Exact package name TBD — placeholder. If no official Nexar MCP exists, wrap their GraphQL API as a local MCP server or fall back to WebFetch against the Octopart site.)
3. Restart Claude Code to load the new MCP.
4. Remove this CRITICAL STOP block from the skill and update the ship metric in `outputs/improvement-plan.md` §3 Layer 6.

Until then, this skill HALTs at Step 1 with a pointer to the setup steps above.

## Pre-flight

1. Read `outputs/session-state.md` for freshness.
2. Read `.claude/config/databases.md` (Supplier DBs — used to cross-reference suppliers offering this part).
3. Read `context/{project}/suppliers.md` when project is known (from the MPN's Notion OI, if any).
4. **Lessons read:** per `.claude/procedures/lessons-read.md`, read `.claude/skills/part-lookup/lessons.md` (top 10). Apply before composing output. If missing or empty, skip.
5. **MCP health check:** attempt a low-cost Nexar call (`nexar.search` with an empty filter). If the MCP is unavailable, HALT and display the CRITICAL STOP block above. Do not fall back to web-scraping without André's explicit approval — Nexar's ToS disallows scraping.

## Inputs

- `/part-lookup {MPN}` — required. Manufacturer Part Number (e.g., `NPM1300QAAA-R7`, `R7F0C807L2DFP#AA0`).
- Optional: `--project {project}` — narrows cross-reference to that project's Supplier DB.
- Optional: `--qty {N}` — target annual volume for price-break calculation (default: 20k for Pulse/M-Band, 50k for BloomPod).

## Step 1: MCP query

Call the Nexar MCP with the MPN. Expected response fields:

- `part.mpn` — canonical MPN
- `part.manufacturer.name`
- `part.lifecycleStatus` — Active / NRND / Obsolete / EOL
- `part.datasheetUrl`
- `part.sellers[]` — each with `company.name`, `offers[]` (price breaks, stock, moq, lead_time, currency)
- `part.similarParts[]` — Nexar's suggested alternates

If the MPN is not found, suggest a fuzzy search: strip packaging/reel suffixes, retry. If still not found, report `[MPN not found in Nexar corpus]` and ask André to verify.

## Step 2: Cross-reference Sword suppliers

Query the relevant Supplier DB(s) — all 4 if project not specified:

```sql
SELECT Name, Status, Notes
FROM "{SUPPLIER_DB}"
WHERE Notes LIKE '%{MPN}%'
   OR Notes LIKE '%{manufacturer}%'
```

Flag any supplier already engaged for this part or manufacturer. Surface their quoted price (from `context/{project}/suppliers.md` unit_cost field) alongside the Nexar distributor prices — highlight the delta.

## Step 3: Compose output

```
PART LOOKUP — {MPN} — {date}

PART:
- Manufacturer: {name}
- Lifecycle: {Active | NRND | Obsolete | EOL}
- Datasheet: {embedded link per writing-style.md}

PRICE BREAKS (top 5 distributors, sorted by price at target qty {N}):
| Distributor | Stock | MOQ | Lead Time | Price @ 1 | Price @ 1k | Price @ {N} | Currency |
|---|---|---|---|---|---|---|---|
| ...

SWORD SUPPLIER CROSS-REF:
- {Supplier A} ({project}): quoted {price}, Status={status} — delta vs Nexar best: {±$X / ±{%}}
- {Supplier B}: no quote on this part

ALTERNATES (Nexar-suggested, pin-compatible):
- {MPN2} by {mfg} — lifecycle {status}, best distributor price ${X}
- {MPN3} by {mfg} — ...

LIFECYCLE FLAGS:
- {Active | NRND | Obsolete}: {one line on what this means for sourcing}
- Known EOL trigger: {date if disclosed}

RECOMMENDATION:
[3-5 sentences. Compare Sword supplier quote vs Nexar distributor floor. Flag lifecycle risk. Suggest whether to push supplier for a better price or pursue distributor route. Surface known context: NPM1300 shortage, Renesas Jul 1 increase.]
```

## Step 4: Log

Log to `outputs/change-log.md`:

```
### Part lookup — {MPN}
- Manufacturer: {name} | Lifecycle: {status}
- Best distributor price @ {N}: ${price}
- Sword supplier cross-ref: {N} matches
- Recommendation: {one-line summary}
```

Append `[EVENT: PART_LOOKUP mpn={MPN} lifecycle={status} best_price={price} sword_matches={N}]`.

No Notion write. If the output suggests adding a new supplier or opening a new OI, that's a separate skill (`/supplier-prospection` or OI create).

## Rules

- NEVER scrape Octopart directly — use the official Nexar API via MCP only.
- NEVER cache Nexar results beyond the current session — prices and stock are live; stale data misleads sourcing.
- NEVER share Nexar-derived distributor prices with a supplier — it reveals our floor (strategy.md §1 Never reveal).
- Lifecycle flags (NRND, Obsolete, EOL) should be mirrored into the supplier OI as a page comment, not a status change.
- If Nexar returns >5 distributors, show top 5 by price-at-target-qty. Drop the rest with a `[+N more]` note.
- If a supplier's quoted price beats every Nexar distributor, that is informative — comment in the output; do not automatically escalate. Could be genuine volume pricing or could be an error.
- M-Band specific: for NPM1300, always include secondary source Avnet alongside primary Future Electronics (per memory `project_mband_coo_cn.md`).
- BloomPod specific: coin cells — show both Varta and Murata benchmarks even if the query is for a different manufacturer's part. Pedro's BOM (due 2026-04-24) may reassign.
- Nexar quota check: if monthly call count approaches the free-tier cap, surface `[Nexar quota: {used}/{cap}]` to André.
- MCP error handling: Nexar failure → HALT with the CRITICAL STOP block. Notion failure (Step 2 cross-ref) → continue without cross-ref and flag `[Notion unavailable — no Sword cross-reference]`.
