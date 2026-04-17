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
3. For each email with a commitment, pending decision, unresolved question, or blocker, propose a new OI OR an append-line update to an existing OI per `.claude/procedures/create-open-item.md`. Present as part of the recommendation output.
4. Follow CLAUDE.md Safety Rules and Writing Style sections.

## Output

Present a summary table per project (Pulse, Kaia, M-Band):

| Supplier | Subject | Date | Recommendation | Reason |
|----------|---------|------|----------------|--------|

Recommendation values: Log, Draft Reply, Ignore, Escalate, Create OI, Update OI Context.

Use `notion-query-data-sources` with SQL for DB queries instead of fetching pages individually.

## Sample Receipt Detection

During step 1, when scanning DHL notifications or supplier emails:
- Flag as **Sample shipped** if subject or body contains: "tracking", "shipped", "dispatched", "AWB", "waybill", or supplier confirms sending units.
- Add to output table with Recommendation: "Update Samples Status → Shipped. Log tracking number."
- After André approves: update Samples Status field in the relevant Supplier DB. Log tracking number in the supplier page Notes or a dedicated field if available.

## Safety

Wait for user approval before any writes. No exceptions.

## Note

For broader scan without domain filter, use /mail-scan-deep.
