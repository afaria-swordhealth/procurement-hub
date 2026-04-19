---
description: "Generate ranked price comparison for a project. Usage: /price-compare {project}"
args: project
model: opus
---

# Price Compare

**Agents:** analyst (primary)

**Argument:** `$ARGUMENTS` - one of: Pulse, Kaia, M-Band

## Pre-flight

Read `outputs/session-state.md`. Calculate age of Last-Warm-Up:
- If < 2h: use context snapshot. Do not re-read context files.
- If 2–8h: use snapshot as baseline. Run delta scan for this task.
- If > 8h or missing: warn André and recommend /warm-up before proceeding.

Read `config/fx-rates.md`. Check the `Last updated:` header date. If rates are more than 7 days old: flag in the output footer — "FX rates last updated {date} — may be stale. Verify before using for decisions." Do not block execution; produce the analysis with the stale rates and label them.

## Steps

1. Read config/databases.md for the relevant Supplier DB collection ID based on project argument.
   Use config/databases.md (Query Patterns section) with columns = all price-related fields, project = $ARGUMENTS.

2. Query the relevant Supplier DB using notion-query-data-sources:
   ```sql
   SELECT "Name", "Status", "Device", "Region",
          "Unit Cost (EUR)", "Tooling Cost (EUR)", "FX Rate at Quote",
          {other_price_columns}
   FROM "{collection_id}"
   ```

3. Calculate Full Landed Cost (FLC) for each supplier:
   - Unit price (FOB or landed, flag which)
   - **FX basis per supplier:**
     - If `FX Rate at Quote` is stamped on the supplier row: use the EUR value already stored — it was computed at the stamped rate, which is the honest basis for that quote. In the output table, show the stamped rate and its delta vs the current rate from `config/fx-rates.md`. If `|stamped - current| / current > 5%`, add a `⚠ FX drift {+/-X%}` annotation in the row's Notes column.
     - If `FX Rate at Quote` is null (quote processed before B6, or manually entered): apply the current rate from `config/fx-rates.md` and label the Notes column `no stamped FX — current rate applied`. Do not rewrite the DB field here (read-only skill); instead flag for next quote-intake run to backfill.
   - Freight estimate
   - Duties estimate
   - Fulfillment (see config/strategy.md Kaia baselines for Nimbl rates)

4. Generate ranked comparison table, sorted by FLC ascending.

## Safety Rules
- Follow CLAUDE.md Safety Rules and Writing Style sections.
- **OUTPUT ONLY.** No writes to any database. READ-ONLY across all Supplier DBs.
- **CRITICAL: Never compare FOB and landed prices directly.** Always flag the distinction (see config/strategy.md Cost Analysis Rules section).
- Exclude suppliers with Status = "Rejected" from ranking (but include in footnote for reference).

## Output Format
Ranked table with columns: Rank | Supplier | Status | Unit Price | Price Basis (FOB/Landed) | FLC Estimate | Lead Time | Notes

Footer: methodology notes, assumptions, and any caveats about price basis differences.
