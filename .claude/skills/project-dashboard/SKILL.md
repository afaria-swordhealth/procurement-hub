---
name: "Project Dashboard"
description: "Consolidated status view for one project (Pulse, Kaia, M-Band, or BloomPod). Shows all suppliers grouped by status, open items by severity, key metrics (quotes, NDAs, coverage gaps), and timeline progress. Use to review project health, prepare for Jorge/Anand updates, or assess where to focus effort."
---

# Project Dashboard

Generates a read-only dashboard for a single project. Pulls from Notion Supplier DB and Open Items DB, cross-references with context files and promises.

## Pre-flight

1. Read `outputs/session-state.md` for freshness. If warm-up < 2h, use snapshot.
2. Read `.claude/config/databases.md` (collection IDs, schemas, query patterns).
3. Identify the project and its Supplier DB:
   - Pulse: `collection://311b4a7d-7207-80a1-b765-000b51ae9d7d`
   - Kaia: `collection://046b6694-f178-47dc-aac1-26efbfc2ab20`
   - M-Band: `collection://311b4a7d-7207-80e7-8681-000b5f1cd0dd`
   - BloomPod: `collection://272844ce-c924-426c-bd32-facef6bca7ca` (light scaffold — Suppliers DB only; Skip Steps 2, 4 and Timeline section if context file absent)
4. If warm-up > 2h, read `context/{project}/suppliers.md` for additional state.

## Step 1: Query all suppliers

```sql
SELECT Name, Status, Notes, "NDA Status", "Samples Status", id, url
FROM "{PROJECT_DB}"
```

Group results by Status:
1. Shortlisted
2. Quote Received
3. RFQ Sent
4. Contacted
5. Identified
6. Rejected (count only, do not list details)

## Step 2: Extract supplier details

For each non-Rejected supplier, extract from Notes and page data:
- Product category (BP cuff, scale, yoga mat, band component, etc.)
- Last outreach date (from Outreach section or context file)
- Quote status (quoted, pending, expired)
- NDA status (Executed, Pending, Not Required)
- Days since last interaction (calculate from last outreach entry)

## Step 3: Query Open Items

```sql
SELECT Item, Status, Type, Owner, "date:Deadline:start" AS Deadline,
       SUBSTR(Context, 1, 150) AS ContextPreview
FROM "collection://505b7f08-8816-4bf7-b77a-7f232b52d0a0"
WHERE Status IN ('Pending', 'In Progress', 'Blocked')
ORDER BY Deadline ASC
```

Filter results to the target project. Group by urgency:
- **Overdue:** deadline < today
- **Blocked:** status = Blocked
- **In Progress:** active work
- **Pending:** not yet started

## Step 4: Check promises

Read `outputs/promises.md`. Filter for entries related to this project. Flag overdue and due-today.

## Step 5: Compile dashboard

```
PROJECT DASHBOARD -- {Project} -- {Date}

## Supplier Pipeline
(one table per status group: Shortlisted, Quote Received, RFQ Sent, Contacted, Identified)

| Supplier | Product | NDA | Samples/Quote | Last Contact | Days Silent |
Rejected: {count} (not listed)

## Key Metrics
| Metric | Value |
|--------|-------|
| Active suppliers | {n} |
| Quotes received / active | {n}/{n} |
| NDAs executed / needed | {n}/{n} |
| OIs overdue / blocked | {n} / {n} |
| Suppliers silent >14d | {n} |

## Part Category Coverage
| Category | Active Suppliers | Status (covered / single-source / gap) |

## Open Items (grouped: Overdue, Blocked, In Progress, Pending)
| Item | Owner | Deadline | Status |

## Timeline Status
{milestones and current position}

## Blockers Summary
{prose: who, what, since when}

## Active Promises
| Who | What | Due |
```

### Timeline references by project

- **Pulse:** Scale target Jul 7. BPM target Sep 20. Sample reviews gating selection.
- **Kaia:** Gated on Caio/Max (per memory). No unilateral advancement.
- **M-Band:** COO-PT. 2027 forecast 200K. EU distributors (Future Electronics, Avnet).

## Rules

- This skill is **read-only**. No Notion writes, no Gmail drafts, no state changes.
- All output in English.
- Never expose raw Notion collection IDs or page URLs in the dashboard output.
- If Notion MCP is unreachable, fall back to `context/{project}/suppliers.md` and note the limitation.
- Pricing details in the dashboard are for Andre's eyes only. If the dashboard is being prepared for sharing with Jorge or Anand, warn Andre to review pricing data before forwarding.
- "Days Silent" = calendar days since last outreach entry (sent or received). If no outreach history, mark "No history".
- Do not list Rejected suppliers individually. Show count only.
