# Decision Queue Render

Used at the top of `/warm-up` (Phase 2) to surface everything André needs to decide or push today. Replaces the older "pending items" narrative section.

## Source

Open Items DB — `collection://505b7f08-8816-4bf7-b77a-7f232b52d0a0`.

## Query

```sql
SELECT
  Item, Owner, Status, Type,
  "date:Deadline:start" AS Deadline,
  SUBSTR(Context, 1, 180) AS CtxPreview,
  CASE
    WHEN Status = 'Blocked' THEN 'blocked'
    WHEN "date:Deadline:start" < date('now') THEN 'overdue'
    WHEN "date:Deadline:start" = date('now') THEN 'today'
    WHEN "date:Deadline:start" <= date('now', '+7 days') THEN 'week'
    ELSE 'later'
  END AS bucket
FROM "collection://505b7f08-8816-4bf7-b77a-7f232b52d0a0"
WHERE Status != 'Closed'
  AND (
    Owner LIKE '%André%'
    OR Status = 'Blocked'
    OR "date:Deadline:start" < date('now')
  )
ORDER BY
  CASE bucket
    WHEN 'overdue' THEN 1
    WHEN 'today' THEN 2
    WHEN 'blocked' THEN 3
    WHEN 'week' THEN 4
    ELSE 5
  END,
  Deadline ASC
```

Rationale for WHERE: show items André owns directly, items handed off but still his to chase (Owner contains `André → ...`), any blocked item across projects, and anything overdue regardless of owner (safety net).

## Render format

```
## Decision Queue

### Overdue (N)
- **<Item>** · due <Deadline> · <N>d late
  _<CtxPreview first sentence>_
...

### Today (N)
- **<Item>** · due today
  _<CtxPreview first sentence>_
...

### This week (N)
- **<Item>** · due <Deadline>
...

### Blocked (N)
- **<Item>** · blocked <N>d
  _<CtxPreview first sentence>_
...
```

## Owner display rule

Omit Owner entirely when it is `André Faria` or `André` — the Decision Queue is already filtered to items André is chasing, so the tag is redundant and adds visual noise.

**Show Owner only when:**
- It's a handoff chain (`André → Bradley / Legal`, `André → Jorge`) — surfaces who currently holds the ball.
- It's a real external owner (`Max Strobel`, `Pedro Rodrigues`, `Sword Legal`) — useful context when André is waiting on someone.

Format when shown: append `· <Owner>` at the end of the line (after the deadline/age).

## Grouping rule for `This week` (> 5 items)

When the `week` bucket has more than 5 items, collapse by date instead of one item per line. This keeps the section scannable.

Format:
```
### This week (10)
- **Apr 15**: Transtek SDK review (Pedro), Kaia samples feedback (Max), Transtek SQA template (Bianca)
- **Apr 17**: Cerler contact (Manuel Beito, mtg Thu), JXwearable plug, ...
- **Apr 18**: MCM AISI 301, Kaia freight (Fernando), Tiger DDP, ...
```

Each Item is abbreviated to just its distinctive noun phrase; a non-André owner in parens when relevant. No Context preview in collapsed mode.

If `week` bucket has ≤ 5 items, use the standard one-line-per-item format.

Overdue, Today, and Blocked never collapse — they are high-priority, full detail always.

## Blocked — "past deadline" calculation

For each item in the Blocked bucket, compute days past deadline:

```sql
CAST(julianday('now') - julianday("date:Deadline:start") AS INTEGER) AS BlockedDays
```

Render as `· Xd past deadline`. If Deadline is null, show `· blocked (no deadline set)`.

**Why deadline-age:** CLAUDE.md §4c removed dated Context prefixes — Context is now a summary paragraph. Parsing `SUBSTR(Context, 1, 10)` for a date is broken for all post-reform OIs. Deadline-age is queryable, always present, and a meaningful proxy: a Blocked item that is 10d past its deadline has been stuck for at least 10 days.

## Limits

- Max 10 items rendered per bucket. If more, append `... and N more — run /housekeeping to triage`.
- `CtxPreview`: show the first sentence only (split on `. `). If Context is null, show `_(no context)_`.
- Do not render the `later` bucket. It's out of the week's horizon.
- Skip a bucket entirely if empty (don't render empty headers).

## Stale flagging (inline, not a separate bucket)

For any item in `overdue` or `blocked`, check if the leading Context date is older than 21 days. If yes, append ` ⚠ stale` to the item line. This satisfies Task 1.5 (stale detection) inside the queue render instead of as a separate /housekeeping output.

Stale check in SQL (add to SELECT):
```sql
CASE WHEN Context IS NOT NULL AND SUBSTR(Context, 1, 10) < date('now', '-21 days')
     THEN 1 ELSE 0 END AS IsStale
```

## Output placement in /warm-up

Decision Queue goes at the very top of the briefing, after the single-line session header and before promises.md surface. Promises and Decision Queue are the two things André sees first — both scannable.
