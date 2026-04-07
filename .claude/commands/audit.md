---
description: Audit Notion workspace against Maintenance Rules for compliance issues.
---

# Workspace Audit

**Agents:** notion-ops (primary)

## Steps

1. Fetch Maintenance Rules page (READ-ONLY):
   ```
   notion-fetch: 321b4a7d-7207-81f7-9a8a-f059d7e38a14
   ```

2. Query all Supplier DBs using notion-query-data-sources:
   ```sql
   SELECT "Name", "Status", "Notes", "Contact", "NDA Status", "Samples Status", "SDK Status" FROM "collection://311b4a7d-7207-80a1-b765-000b51ae9d7d"
   SELECT "Name", "Status", "Notes" FROM "collection://046b6694-f178-47dc-aac1-26efbfc2ab20"
   SELECT "Name", "Status", "Notes" FROM "collection://311b4a7d-7207-80e7-8681-000b5f1cd0dd"
   ```

3. Query Open Items DB:
   ```sql
   SELECT "Name", "Status" FROM "collection://505b7f08-8816-4bf7-b77a-7f232b52d0a0"
   ```

4. Query Daily Logs DB:
   ```sql
   SELECT "Name" FROM "collection://386548e7-1a94-4c9f-8c5c-068aca0bc843"
   ```

5. Check against Maintenance Rules:
   - **EN-only:** All Notion content must be in English (no Portuguese, no Chinese)
   - **Notes format:** "TYPE (Location). Product + key differentiator. Flag." Max 2 lines.
   - **Section order:** ## Contact, ## Profile, ## Quote, ## Outreach, ## Open Items
   - **Field completeness:** Required fields populated (Status, Device, Region, Contact)
   - **Duplicates:** No duplicate supplier entries across DBs

6. Present findings to André. André decides what to fix.

## Safety Rules
- **Maintenance Rules page is READ-ONLY.** Never modify it.
- **SHOW BEFORE WRITE:** Present all findings before any corrections.
- André approves each fix individually.
- **NO EM DASHES.**

## Output Format
Table of findings with columns: DB | Supplier | Issue | Severity (High/Medium/Low) | Suggested Fix
