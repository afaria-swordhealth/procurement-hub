---
description: Deep Gmail scan without domain filter. Catches emails from unknown or new senders.
---

# Agents

- supplier-comms: Gmail scan (incoming + sent)
- logistics: DHL/tracking email detection
- notion-ops: Notion cross-reference

# Procedure

1. Run `.claude/procedures/scan-gmail.md` with mode: "deep", direction: "both" (incoming + sent), lookback: 3 days. This applies base exclusions only, no domain filter.
2. Use config/databases.md (Query Patterns section) to cross-reference each sender against Notion Contact fields across all three Supplier DBs.
3. Classify each email:
   - Known supplier: match found in Notion Contact fields.
   - Unknown sender: no match found.
4. Follow CLAUDE.md Safety Rules and Writing Style sections.

# Output

## Known Suppliers

One summary table per project (Pulse, Kaia, M-Band):

| Supplier | Subject | Date | Recommendation | Reason |
|----------|---------|------|----------------|--------|

Recommendation values: Log, Draft Reply, Ignore, Escalate.

## Unknown Senders

| Sender | Subject | Date | Notes |
|--------|---------|------|-------|

Flag whether the sender domain looks procurement-relevant or is likely noise (newsletters, internal tools, etc.).

Use `notion-query-data-sources` with SQL for DB queries instead of fetching pages individually.

# Safety

Wait for user approval before any writes. No exceptions.
