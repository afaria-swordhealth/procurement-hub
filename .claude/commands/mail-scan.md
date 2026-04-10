---
description: Scan Gmail for new supplier emails, cross-reference with Notion, present recommendations.
model: sonnet
---

## Agents

- supplier-comms: Gmail scan (incoming + sent)
- logistics: DHL/tracking email detection
- notion-ops: Notion cross-reference

## Procedure

1. Run `.claude/procedures/scan-gmail.md` with mode: "filtered", direction: "both" (incoming + sent), lookback: 3 days.
2. Use config/databases.md (Query Patterns section) to cross-reference each sender against Notion supplier pages (status, last outreach, open items).
3. Follow CLAUDE.md Safety Rules and Writing Style sections.

## Output

Present a summary table per project (Pulse, Kaia, M-Band):

| Supplier | Subject | Date | Recommendation | Reason |
|----------|---------|------|----------------|--------|

Recommendation values: Log, Draft Reply, Ignore, Escalate.

Use `notion-query-data-sources` with SQL for DB queries instead of fetching pages individually.

## Safety

Wait for user approval before any writes. No exceptions.

## Note

For broader scan without domain filter, use /mail-scan-deep.
