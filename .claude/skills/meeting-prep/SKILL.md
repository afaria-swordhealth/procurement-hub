---
name: "Meeting Prep"
description: "Build a 1-page briefing before any supplier or internal meeting. Pulls supplier profile, quotes, OIs, recent emails, Slack mentions, and promises into a structured brief with talking points and guardrails. Use before any call or meeting with a supplier, Jorge, or cross-functional stakeholder."
---

# Meeting Prep

Generates a read-only briefing for a specific supplier or meeting topic. Consolidates context from Notion, Gmail, Slack, and local state files so Andre walks into the meeting fully prepared.

## Pre-flight

1. Read `outputs/session-state.md` for freshness. If warm-up < 2h, use snapshot.
2. Read `.claude/config/strategy.md` (negotiation guardrails, what NOT to reveal).
3. Read `.claude/config/domains.md` (supplier contact and email domains).
4. Read `.claude/config/databases.md` (DB schemas and query patterns).
5. Identify the project (Pulse, Kaia, M-Band) from the supplier name or topic.
6. If warm-up > 2h, read `context/{project}/suppliers.md` for the relevant project.

## Step 1: Resolve the supplier

Input: supplier name, person name, or meeting topic.

- If a supplier name, query the matching Supplier DB for the page:

```sql
SELECT Name, Status, Notes, Currency, Region, "NDA Status", "Samples Status", id, url
FROM "{SUPPLIER_DB_COLLECTION_ID}"
WHERE Name LIKE '%{supplier}%'
```

- If a meeting topic (e.g., "packaging review"), identify all relevant suppliers and pull each.
- If an internal meeting (Jorge 1:1, team sync), skip supplier queries and focus on OIs and promises.

## Step 2: Pull supplier page details

For each supplier identified:

1. Fetch the full Notion page (use the `url` from Step 1).
2. Extract:
   - Contact section (names, emails, roles)
   - Profile section (factory location, certifications, product types)
   - Quote section (pricing, MOQ, lead times, incoterms)
   - Outreach section (last 5 entries, communication cadence)
   - Open Items section (linked OIs)

## Step 3: Pull Open Items

Query Open Items DB for this supplier:

```sql
SELECT Item, Status, Type, Owner, "date:Deadline:start" AS Deadline, Context
FROM "collection://505b7f08-8816-4bf7-b77a-7f232b52d0a0"
WHERE Status IN ('Pending', 'In Progress', 'Blocked')
ORDER BY Deadline ASC
```

Filter results to those matching the supplier name or project. Flag any overdue items.

## Step 4: Pull recent emails

Use `scan-gmail.md` procedure:
- **direction:** "both"
- **date_range:** 14 (days)
- **project_filter:** matching project

From results, extract the last 5 email exchanges with this supplier. For each:
- Date, sender, subject, 1-line summary of content.

## Step 5: Check promises

Read `outputs/promises.md`. Filter for entries mentioning this supplier or the people attending the meeting. Flag any overdue or due-today promises.

## Step 6: Scan Slack

Read `.claude/config/slack-channels.md` for channel IDs.

Search recent messages (7 days) mentioning the supplier name in:
- Key project channels
- DMs with Jorge, Miguel, Pedro, Paulo, Sofia (per memory: scan DMs proactively)

Summarize any relevant threads (decisions, blockers, asks).

## Step 6b: Check ruflo for past meeting outcomes

Before generating talking points, call `mcp__ruflo__memory_search`:
- `query`: "meeting outcomes {supplier_name}"
- `namespace`: "procurement"
- `limit`: 3
- `threshold`: 0.5

If results exist, add a **Past Meeting Patterns** section to the briefing (between Slack Context and Talking Points):
- What worked (tone, framing, specific asks that landed)
- What to avoid (topics that stalled, commitments that slipped)
- Unresolved threads from previous meetings (cross-check vs open OIs)

If no results, omit the section.

## Step 7: Generate briefing

```
MEETING BRIEF -- {Supplier/Topic} -- {Date}

## Supplier Profile
- {name} | {region} | Status: {status} | NDA: {status} | Samples: {status}
- Product: {what they supply} | Contact: {name, email}

## Quotes & Pricing
- Unit: {price} {currency} ({incoterm}) | MOQ: {qty} | Lead time: {weeks}
- FLC: {if available} | Validity: {expiry if known}

## Open Items
| Item | Status | Owner | Deadline |
(from Step 3, sorted by deadline)

## Promises
(from Step 5, filtered to this supplier)

## Communication Timeline (last 5)
| Date | Direction | Subject | Summary |
(from Step 4)

## Slack Context
(from Step 6)

## Talking Points
(derived from OIs, pending items, strategy goals)

## Questions to Ask
(derived from info gaps: missing quotes, specs, NDAs)

## DO NOT Discuss
- Internal pricing targets or budget
- Other suppliers or shortlist position
- Internal timelines or decision deadlines
- Volume forecasts beyond what's shared
- Competing quotes from other suppliers
```

## Step 8: Store meeting outcome (post-meeting, optional)

After the meeting, call `mcp__ruflo__memory_store` to capture what happened:

- **key**: `meeting::[supplier_slug]::[YYYY-MM-DD]` — slug format per `config/ruflo-schema.md` (lowercase, dashes)
- **namespace**: "procurement"
- **upsert**: true
- **tags**: ["meeting", project, supplier_slug]
- **value**:
  ```json
  {
    "supplier": "{name}",
    "date": "{YYYY-MM-DD}",
    "tone": "{collaborative|tense|neutral}",
    "key_outcomes": ["{outcome 1}", "{outcome 2}"],
    "what_worked": "{framing or ask that landed}",
    "what_to_avoid": "{topic or approach that stalled}",
    "unresolved": ["{open thread 1}"],
    "next_step": "{agreed next action}"
  }
  ```

André must explicitly request this step after the meeting. The briefing itself is always read-only.

## Rules

- This skill is **read-only**. No Notion writes, no Gmail drafts, no Slack messages.
- All output in English. If the meeting is with a PT supplier, note the language preference but keep the brief in English.
- Never include raw Notion page IDs or collection URLs in the output.
- If a supplier is in Rejected status, warn Andre and ask if the meeting is intentional.
- If Notion MCP is unreachable, fall back to `context/{project}/suppliers.md` and note the limitation.
- Pricing data is sensitive. The brief is for Andre only, not for sharing externally.
