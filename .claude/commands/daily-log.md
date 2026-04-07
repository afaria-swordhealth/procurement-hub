---
description: Compile today's daily log across all 3 projects and push to Notion as Draft.
---

# Daily Log

**Agents:** notion-ops (primary), supplier-comms (email context if needed)

## Steps

1. Query all 3 Supplier DBs for pages modified today using notion-query-data-sources:
   ```sql
   SELECT "Name", "Status", "Notes" FROM "collection://311b4a7d-7207-80a1-b765-000b51ae9d7d"
   SELECT "Name", "Status", "Notes" FROM "collection://046b6694-f178-47dc-aac1-26efbfc2ab20"
   SELECT "Name", "Status", "Notes" FROM "collection://311b4a7d-7207-80e7-8681-000b5f1cd0dd"
   ```

2. Query Open Items DB for items updated today:
   ```sql
   SELECT "Name", "Status" FROM "collection://505b7f08-8816-4bf7-b77a-7f232b52d0a0"
   ```

3. Query Daily Logs DB to check if an entry for today already exists:
   ```sql
   SELECT "Name" FROM "collection://386548e7-1a94-4c9f-8c5c-068aca0bc843"
   ```

4. Compile per-project sections:
   - ## Pulse
   - ## Kaia
   - ## M-Band
   - ## ISC

5. Present draft to André for review.

6. After approval, push to Notion Daily Logs DB (collection://386548e7-1a94-4c9f-8c5c-068aca0bc843) as Draft.

## Safety Rules
- **CHECK BEFORE CREATE:** If entry for today exists, append to it. NEVER create a duplicate.
- **SHOW BEFORE WRITE:** Present draft to André before pushing to Notion.
- **ALL NOTION CONTENT IN ENGLISH.**
- **NO EM DASHES.** Use commas, periods, or "or".
- Log to outputs/change-log.md after write.

## Output Format
One section per project. Each section lists changes, updates, and decisions made today. Keep entries concise, factual, no filler.
