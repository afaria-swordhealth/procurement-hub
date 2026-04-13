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
- **<Item>** — <Owner> · due <Deadline> · <bucket-days>d late
  _<CtxPreview first sentence>_
...

### Today (N)
- **<Item>** — <Owner> · due today
  _<CtxPreview first sentence>_
...

### This week (N)
- **<Item>** — <Owner> · due <Deadline>
...

### Blocked (N)
- **<Item>** — <Owner> · blocked since <last Context date>
  _<CtxPreview first sentence>_
...
```

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
