# Procurement Hub — Dashboard

## Open Promises

> Requires Dataview plugin. Install via Settings > Community Plugins > Browse > "Dataview"

```dataview
TASK
FROM "outputs/promises.md"
WHERE !completed
SORT text ASC
```

---

## Projects

| Project | Suppliers file | Key doc |
|---|---|---|
| Pulse | [[context/pulse/suppliers]] | BP cuffs + scales. Transtek + Unique Scales selected. |
| Kaia Rewards | [[context/kaia/suppliers]] | Yoga mats. Tiger Fitness / Second Page under review. |
| M-Band COO-PT | [[context/mband/suppliers]] | Wearable components. 14 active suppliers. |

---

## Operational Files

- [[outputs/session-state]] — Last warm-up, email state, pending actions, crons
- [[outputs/promises]] — Commitments to humans with deadlines
- [[outputs/change-log]] — Every Notion write, timestamped

---

## Config and Agents

- [[CLAUDE.md]] — System instructions and safety rules
- [[.claude/config/databases]] — All Notion DB IDs and query patterns
- [[.claude/config/domains]] — Supplier domain list and Gmail filters
- [[.claude/config/slack-channels]] — Slack user and channel IDs
- [[.claude/agents/supplier-comms]] — Email + outreach agent
- [[.claude/agents/notion-ops]] — Notion maintenance agent
- [[.claude/agents/analyst]] — Pricing and cost analysis agent

---

## Supplier Status Counts (manual refresh)

| Project | Shortlisted | Quote Received | RFQ Sent | Rejected |
|---|---|---|---|---|
| Pulse | 3 (Transtek, Unique, A&D) | 1 (Urion) | 0 | 8 |
| Kaia | 1 (Nimbl) | 0 | 0 | 0 |
| M-Band | 0 | 3 (Vangest, MCM, SHX) | 5 | 11 |

_Last updated: 2026-04-10_

---

## Plugin setup (first time only)

1. Settings > Community Plugins > turn off Restricted Mode
2. Browse > search "Dataview" > Install > Enable
3. Browse > search "Kanban" > Install > Enable
4. Reopen this file — the Open Promises table will populate
