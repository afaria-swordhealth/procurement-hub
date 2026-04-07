---
description: "Generate ranked price comparison for a project. Usage: /price-compare {project}"
args: project
---

# Price Compare

**Agents:** analyst (primary)

**Argument:** `$ARGUMENTS` — one of: Pulse, Kaia, M-Band

## Steps

1. Determine which Supplier DB to query based on project argument:
   - **Pulse:** `collection://311b4a7d-7207-80a1-b765-000b51ae9d7d`
   - **Kaia:** `collection://046b6694-f178-47dc-aac1-26efbfc2ab20`
   - **M-Band:** `collection://311b4a7d-7207-80e7-8681-000b5f1cd0dd`

2. Query the relevant Supplier DB using notion-query-data-sources:
   ```sql
   -- Example for Pulse:
   SELECT "Name", "Status", "Device", "Region", "BP Cuffs Price (USD)", "Smart Scale Price (USD)", "BP Cuffs Lead Time", "Smart Scale Lead Time" FROM "collection://311b4a7d-7207-80a1-b765-000b51ae9d7d"
   ```

3. Calculate Full Landed Cost (FLC) for each supplier:
   - Unit price (FOB or landed, flag which)
   - Freight estimate
   - Duties estimate
   - Fulfillment (Nimbl rates: $13.15-$17.15/unit)

4. Generate ranked comparison table, sorted by FLC ascending.

## Safety Rules
- **OUTPUT ONLY.** No writes to any database.
- **CRITICAL: Never compare FOB and landed prices directly.** Always flag the distinction.
- **READ-ONLY** across all Supplier DBs.
- **NO EM DASHES.**
- Exclude suppliers with Status = "Rejected" from ranking (but include in footnote for reference).

## Output Format
Ranked table with columns: Rank | Supplier | Status | Unit Price | Price Basis (FOB/Landed) | FLC Estimate | Lead Time | Notes

Footer: methodology notes, assumptions, and any caveats about price basis differences.
