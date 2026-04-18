---
name: "Negotiation Tracker"
description: "Build negotiation profiles per supplier: quote history, concessions, leverage, and next-move recommendations. Use when preparing for a price discussion, evaluating a new quote, or reviewing negotiation posture across active suppliers."
---

# Negotiation Tracker

Compiles the full negotiation state for one or more suppliers. Quote history, concessions exchanged, leverage points, open pricing items, and a recommended next move. Read-only output, no writes.

## Pre-flight

1. Read `outputs/session-state.md` for freshness. If warm-up < 2h, use snapshot.
2. Read `.claude/config/strategy.md` (negotiation rules, pricing leverage, never-reveal list).
3. Read `.claude/config/databases.md` (supplier DB schemas, query patterns).
4. Read `.claude/config/fx-rates.md` (for normalizing quotes across currencies).
5. Load `context/{project}/suppliers.md` for the relevant project(s).

## Input

- **Supplier name**: single supplier, comma-separated list, or `all active`.
- **Project scope**: inferred from supplier name. If ambiguous, ask.

If `all active`: query all 4 Supplier DBs for Status NOT IN ('Rejected', 'Parked').

## Step 1: Gather quote data

### From Supplier DBs

```sql
SELECT Name, Status, Notes, Currency, Region, "NDA Status", "Samples Status"
FROM "{SUPPLIER_DB}"
WHERE Name = '{supplier}'
```

Parse Notes field and page body (## Quote section) for: quoted prices with dates/tiers/Incoterms, tooling costs, MOQ, lead times, breakdowns, re-quote outcomes.

### From Open Items DB

```sql
SELECT Item, Status, "date:Deadline:start" AS Deadline, Context
FROM "collection://505b7f08-8816-4bf7-b77a-7f232b52d0a0"
WHERE Supplier = '{supplier}'
  AND Status IN ('Pending', 'In Progress', 'Blocked')
```

Flag any OI related to pricing, quotes, or cost breakdowns.

Cross-reference `context/{project}/suppliers.md` for relationship notes, strategic positioning, pricing signals.

## Step 2: Build negotiation profile

For each supplier, assemble:

### Quote history table

Chronological table: Date, Price, Volume, Incoterms, Currency, Notes. Normalize to same currency using `fx-rates.md` (show both original and converted).

### Price evolution

Direction (improving/flat/worsening), magnitude (% change first to latest), trigger (volume tier, re-quote, relationship). Single quote = "no trend."

### Concessions (us to them)

Free DHL labels, goodwill sample requests, volume commitments communicated, extended timelines, waived tooling/NRE.

### Concessions (them to us)

Price reductions (absolute + %), free samples/tooling, expedited lead times, added services, extended payment terms.

### Leverage points

- **Competing suppliers:** count of active alternatives in category (never name externally)
- **Volume:** 2027 forecast (200K M-Band, 20K Pulse)
- **Relationship:** reply speed, sample quality, NDA status
- **Timing:** early evaluation = more leverage

### Open negotiation items

Pending re-quotes, missing breakdowns, unresolved pricing questions, stale quotes (>30 days).

## Step 2b: Check ruflo for negotiation patterns

Before generating recommendations, call `mcp__ruflo__memory_search`:
- `query`: "negotiation patterns for [supplier_name]"
- `namespace`: "procurement"
- `limit`: 5
- `threshold`: 0.5

If results exist, surface them in the profile card under a **Learned Patterns** section:
- Price-drop triggers ("dropped 8% after second re-quote request")
- Concession sequences ("tooling waived when volume >50K committed")
- Optimal re-quote timing ("responds best within 48h of follow-up")

If no results, omit the section entirely.

## Step 3: Generate next-move recommendation

Apply this decision tree:

| Condition | Recommendation |
|-----------|---------------|
| Quote is competitive + samples passed | Advance: discuss PO terms, production timeline |
| Quote is competitive + no samples yet | Advance: request samples with DHL label |
| Quote is high but supplier is responsive | Re-quote: request specific volume tier or breakdown |
| Quote is high and supplier is slow | Deprioritize: send "still evaluating" and reduce cadence |
| Quote received >30 days ago, no follow-up | Re-engage: check if pricing is still valid, request updated quote |
| No quote yet, RFQ sent | Follow up: reference original RFQ, ask for timeline |
| Supplier rejected or parked | Skip: no recommendation |

### Strategy guardrails (from config/strategy.md)

- NEVER suggest revealing competing prices, budget targets, or shortlist status in any recommendation.
- NEVER suggest mentioning how many suppliers are in the pipeline.
- Frame all re-quote requests around volume breakpoints, not "your price is too high."
- If recommending sample request, reference the standard evaluation process framing.
- Acknowledge price improvements without confirming competitiveness.

## Step 4: Present output

For each supplier, output a profile card with these sections in order: header (name, project, status, region, currency), Quote History table, Price Evolution (one line), Concessions (us/them), Leverage, Open Items, Next Move.

If running `all active`, sort cards by project, then by recommendation urgency (advance > re-quote > re-engage > deprioritize).

## Rules

- READ-ONLY for Notion and Gmail. This skill does not write to Supplier DBs or draft emails. Step 4b writes to ruflo memory only, when André confirms a negotiation outcome.
- Never include competing supplier names, prices, or rankings in any output that could be shared externally.
- Always flag FOB vs landed distinction when comparing across suppliers (per config/strategy.md).
- Use fx-rates.md for cross-currency normalization. Show both original and converted values.
- If a supplier has no quote data at all, still show the card with "No quotes on file" and recommend next step.
- If Notion MCP is unreachable, abort with a clear message. Do not produce partial analysis from context files alone.

## Step 4b: Store negotiation outcome (if outcome changes)

When a negotiation milestone is reached (price agreed, concession granted, re-quote result), store via `mcp__ruflo__memory_store`:
- `key`: "negotiation::[supplier_name]::[YYYY-MM-DD]"
- `namespace`: "procurement"
- `upsert`: true
- `tags`: ["negotiation", project_name, supplier_name]
- `value`: `{ supplier, event, price_before, price_after, trigger, concession, notes }`

This step only runs when André confirms a change. Not on read-only profile views.
