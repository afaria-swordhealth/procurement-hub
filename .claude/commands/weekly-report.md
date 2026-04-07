---
description: Compile weekly report from daily logs, calculate key numbers, push to Notion as Draft.
---

# Weekly Report

**Agents:** notion-ops (primary), analyst (key numbers + W-over-W deltas)

## Steps

1. notion-ops pulls daily logs for the current week from Daily Logs DB:
   ```sql
   SELECT "Name", "Date" FROM "collection://386548e7-1a94-4c9f-8c5c-068aca0bc843"
   ```
   Then fetch each relevant daily log page for full content.

2. analyst queries all 3 Supplier DBs (READ-ONLY) to calculate Key Numbers with week-over-week deltas:
   ```sql
   SELECT "Name", "Status", "BP Cuffs Price (USD)", "Smart Scale Price (USD)" FROM "collection://311b4a7d-7207-80a1-b765-000b51ae9d7d"
   SELECT "Name", "Status" FROM "collection://046b6694-f178-47dc-aac1-26efbfc2ab20"
   SELECT "Name", "Status" FROM "collection://311b4a7d-7207-80e7-8681-000b5f1cd0dd"
   ```

3. Compile by project:
   - ## Pulse
   - ## Kaia Rewards
   - ## M-Band COO-PT
   - ## ISC

4. Each project section has sub-sections per topic. Blockers in prose. Next steps by project.

5. Present draft to André for review.

6. After approval, push to Notion Weekly Reports DB (collection://df85b3f8-6639-4ef3-b69f-1e0bd7cb5d79) as Draft.

## Safety Rules
- **SHOW BEFORE WRITE:** Present draft to André before pushing to Notion.
- **NEVER include internal housekeeping** (e.g., Notion cleanup, command testing).
- **Weekly Report status stays Draft.** Only André marks it as Sent in Notion UI.
- **ALL NOTION CONTENT IN ENGLISH.**
- **NO EM DASHES.**
- Log to outputs/change-log.md after write.

## Output Format
Sections by project. Sub-sections per topic. Key Numbers table with W-over-W deltas. Blockers in prose. Next steps by project. Colleague tone, not consultant.
