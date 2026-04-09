---
description: "Generate ranked price comparison for a project. Usage: /price-compare {project}"
args: project
---

# Price Compare

**Agents:** analyst (primary)

**Argument:** `$ARGUMENTS` - one of: Pulse, Kaia, M-Band

## Steps

1. Read config/databases.md for the relevant Supplier DB collection ID based on project argument.
   Use config/databases.md (Query Patterns section) with columns = all price-related fields, project = $ARGUMENTS.

2. Query the relevant Supplier DB using notion-query-data-sources:
   ```sql
   SELECT "Name", "Status", "Device", "Region", {price_columns} FROM "{collection_id}"
   ```

3. Calculate Full Landed Cost (FLC) for each supplier:
   - Unit price (FOB or landed, flag which)
   - Freight estimate
   - Duties estimate
   - Fulfillment (Nimbl rates: $13.15-$17.15/unit)

4. Generate ranked comparison table, sorted by FLC ascending.

## Safety Rules
- Follow CLAUDE.md Safety Rules and Writing Style sections.
- **OUTPUT ONLY.** No writes to any database. READ-ONLY across all Supplier DBs.
- **CRITICAL: Never compare FOB and landed prices directly.** Always flag the distinction (see config/strategy.md Cost Analysis Rules section).
- Exclude suppliers with Status = "Rejected" from ranking (but include in footnote for reference).

## Output Format
Ranked table with columns: Rank | Supplier | Status | Unit Price | Price Basis (FOB/Landed) | FLC Estimate | Lead Time | Notes

Footer: methodology notes, assumptions, and any caveats about price basis differences.
