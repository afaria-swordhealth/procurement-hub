# SQL Capabilities — notion-query-data-sources

Tested 2026-04-13 against Open Items DB (`collection://505b7f08-8816-4bf7-b77a-7f232b52d0a0`).

The tool runs SQLite on Notion's projected schema. Below: what works, how to use it, and the gotchas.

---

## Confirmed working

| Feature | Example |
|---|---|
| AND / OR / parens | `WHERE Status != 'Closed' AND (Status = 'Pending' OR Status = 'In Progress')` |
| `IS NULL` / `IS NOT NULL` | `WHERE "date:Deadline:start" IS NOT NULL` |
| `IN (...)` | `WHERE Status IN ('Pending', 'In Progress', 'Blocked')` |
| `ORDER BY ... ASC/DESC` | `ORDER BY "date:Deadline:start" ASC` |
| `LIMIT` | `LIMIT 5` |
| Column aliases | `SELECT Item AS i, COUNT(*) AS n` |
| `COUNT(*)` + `GROUP BY` | `GROUP BY Status` |
| `CASE WHEN ... THEN ... ELSE ... END` | bucket classifiers for queue rendering |
| `SUBSTR(col, start, len)` | 1-indexed. `SUBSTR(Context, 1, 10)` extracts leading date |
| `LIKE '%...%'` | works with Unicode (e.g. `LIKE '%André%'`) |
| Parameterized queries (`?` + `params`) | safer than string concat |
| Date helpers | `date('now')`, `date('now', '+7 days')`, `date('now', '-21 days')` |
| `julianday()` for day arithmetic | `CAST(julianday('now') - julianday(SUBSTR(Context, 1, 10)) AS INTEGER)` returns integer days between dates |

---

## Field naming conventions

- Regular fields: bare name, e.g. `Status`, `Owner`, `Item`, `Context`.
- Date fields: three columns — `"date:Field:start"`, `"date:Field:end"`, `"date:Field:is_datetime"`. Quote them in SQL because of the colons.
- Relation fields: stored as a JSON-encoded array of URLs. Filter with `LIKE '%page-id-no-hyphens%'`. Example: `Project LIKE '%310b4a7d72078145962ee5a9c875dc0d%'`.
- Rich text (Context): stored as plain text. Markdown asterisks (`**...**`) are NOT in the stored value — they render in Notion UI but the raw column is clean. Note: OI Context no longer uses a leading-date prefix (see §4c); `SUBSTR(Context, 1, 10)` for date comparison only works on legacy items.
- Checkboxes: use literal `'__YES__'` / `'__NO__'` as params.

---

## Date comparisons

ISO-8601 dates (`YYYY-MM-DD`) compare lexicographically, which matches chronological order — no casting needed.

```sql
WHERE "date:Deadline:start" < date('now')            -- overdue
WHERE "date:Deadline:start" <= date('now', '+7 days') -- next week
WHERE SUBSTR(Context, 1, 10) < date('now', '-21 days') -- stale OI (>21d)
```

---

## Patterns for watchdogs / queue rendering

**Decision Queue buckets:**
```sql
SELECT
  Item, Owner, "date:Deadline:start" AS Deadline,
  CASE
    WHEN Status = 'Blocked' THEN 'blocked'
    WHEN "date:Deadline:start" < date('now') THEN 'overdue'
    WHEN "date:Deadline:start" = date('now') THEN 'today'
    WHEN "date:Deadline:start" <= date('now', '+7 days') THEN 'week'
    ELSE 'later'
  END AS bucket
FROM "collection://505b7f08-8816-4bf7-b77a-7f232b52d0a0"
WHERE Status != 'Closed' AND Owner LIKE '%André%'
ORDER BY "date:Deadline:start" ASC
```

**Stale OI detection (>21 days since last Context update):**
```sql
WHERE Status != 'Closed'
  AND Context IS NOT NULL
  AND SUBSTR(Context, 1, 10) < date('now', '-21 days')
```
**Note:** This query assumes legacy OI Context format (YYYY-MM-DD: prefix). Current convention (CLAUDE.md §4c) uses a summary paragraph — no date prefix — so SUBSTR(Context, 1, 10) will not parse as a date for compliant OIs. For staleness detection, rely on Deadline overage and manual review of recent Notion page comments rather than this SQL pattern.

**Project filter via relation:**
```sql
WHERE Project LIKE '%310b4a7d72078145962ee5a9c875dc0d%'  -- Pulse
WHERE Project LIKE '%313b4a7d7207810ca19fda03a61f8057%'  -- Kaia
WHERE Project LIKE '%311b4a7d72078167b4b2cd9f88167d04%'  -- M-Band
```
IDs have hyphens stripped in the stored URL payload.

---

## Token efficiency

- Use `SUBSTR(Context, 1, 300)` when listing OIs. Full Context only when editing a specific OI.
- Always project explicit columns (`SELECT Item, Status, Owner, Deadline`). Avoid `SELECT *` except for schema discovery.
- Aggregate in SQL (`COUNT`, `GROUP BY`) instead of pulling rows and counting in the model.

---

## Not yet tested (add as we need them)

- JOINs across data sources (can pass multiple URLs; queryable as separate tables)
- `UNION`
- `strftime`, more complex date math
- Rollup fields
- Formula fields
