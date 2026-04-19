# Notion Database IDs
# Single source of truth. All commands and agents reference this file.
# CLAUDE.md Notion Workspace Map section remains the full workspace map. This file is for programmatic use.

## Supplier DBs

| Project | Collection ID | Shorthand |
|---------|--------------|-----------|
| Pulse | collection://311b4a7d-7207-80a1-b765-000b51ae9d7d | PULSE_DB |
| Kaia | collection://046b6694-f178-47dc-aac1-26efbfc2ab20 | KAIA_DB |
| M-Band | collection://311b4a7d-7207-80e7-8681-000b5f1cd0dd | MBAND_DB |
| BloomPod | collection://272844ce-c924-426c-bd32-facef6bca7ca | BLOOMPOD_DB |

## Other DBs

| DB | Collection ID | Shorthand |
|----|--------------|-----------|
| Test Reviews | collection://911b7778-b80b-4e94-a5c4-9f8853934d2e | TEST_DB |
| Open Items | collection://505b7f08-8816-4bf7-b77a-7f232b52d0a0 | OI_DB |
| Daily Logs | collection://386548e7-1a94-4c9f-8c5c-068aca0bc843 | DAILYLOG_DB |
| Weekly Reports | collection://df85b3f8-6639-4ef3-b69f-1e0bd7cb5d79 | WEEKLY_DB |

## Key Pages (READ-ONLY)

| Page | ID |
|------|----|
| Procurement Hub | 310b4a7d-7207-81ac-a4e5-fa5a297c7087 |
| Maintenance Rules | 321b4a7d-7207-81f7-9a8a-f059d7e38a14 |
| Workspace Audit | 321b4a7d-7207-81ab-9829-cd4b6f09592f |
| Sample Reviews Guide | 326b4a7d-7207-816c-9c9f-e19286fc7c99 |

## Context Files

| Project | Path |
|---------|------|
| Pulse | context/pulse/suppliers.md |
| Kaia | context/kaia/suppliers.md |
| M-Band | context/mband/suppliers.md |
| BloomPod | (none — light scaffold, add when shortlist matures) |

## BLOCKED (never touch)

| Page | ID | Reason |
|------|----|--------|
| Internal Purchasing | 318b4a7d-7207-80cb-aaaf-db6687890079 | Portuguese, internal |

## Query Patterns

**Note: If "Name" column fails, use `SELECT *` (known Notion API quirk).**

Use notion-query-data-sources with SQL format:
```sql
SELECT {columns} FROM "{collection_id}" [WHERE {filter}]
```

### Known DB Schemas (use these for direct queries — no schema discovery needed)

**Supplier DBs (Pulse / Kaia / M-Band):**
```
Name, Status, Notes, Currency, Region, "NDA Status", "Samples Status",
"Unit Cost (EUR)", "Tooling Cost (EUR)",
"Last Outreach Date", id, url
```
Note: `"Unit Cost (EUR)"` and `"Tooling Cost (EUR)"` are written by quote-intake Step 4. `"Last Outreach Date"` (M4) must be added manually via Notion UI to all 4 Supplier DBs before first use — Date field type.

**Open Items DB:**
```
Item, Status, Type, Owner, "date:Deadline:start", Context, Resolution, Project, Supplier, id, url
```

**Daily Logs DB:**
```
title, Status, Week, Date, Highlights, id, url, createdTime
```
Note: `Date` is a plain string field (e.g. "2026-04-13"), not a date object. Filter with `WHERE Date = '2026-04-13'` or use `ORDER BY createdTime DESC LIMIT 1`.

**Test Reviews DB:**
```
Name, Status, id, url
```

### Common column sets by caller

| Caller | Columns to SELECT |
|--------|---------|
| context-sync (wrap-up) | Name, Status, Notes, "NDA Status", "Samples Status", "Last Outreach Date", Region, Currency, id |
| daily-log check | title, Date, Status, id, createdTime |
| OI triage | Item, Status, Type, Owner, "date:Deadline:start", id |
| housekeeping | Name, Status, Notes, Currency, "NDA Status", Region |
| price-compare | Name, Status, "Unit Cost (EUR)", "Tooling Cost (EUR)", Notes, id |

## M4 Field Setup (one-time, via Notion UI)

Before M4 queries work, add these fields to all 4 Supplier DBs manually in Notion:

| Field | Type | Writer | Notes |
|-------|------|--------|-------|
| `Last Outreach Date` | Date | check-outreach.md, supplier-chaser Step 7, quote-intake Step 7 | Auto-populated on every outreach write after this field exists |

Optional (deferred — formula fields untested):
| `Days Since Last Contact` | Formula: `dateBetween(now(), prop("Last Outreach Date"), "days")` | Notion (auto) | Test formula field query in sql-capabilities.md before relying on it |

`Unit Cost (EUR)` and `Tooling Cost (EUR)` already exist — no action needed.

## Error Handling

If Notion MCP is unreachable, abort the command with a clear message to Andre. Do not attempt partial writes. Note the failure and suggest retrying later. This applies to all commands that query or write to Notion databases.
