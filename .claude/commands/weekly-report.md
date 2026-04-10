---
description: Compile weekly report from daily logs, calculate key numbers, push to Notion as Draft.
model: opus
---

# Weekly Report

**Agents:** notion-ops (primary), analyst (key numbers + W-over-W deltas)

**References:**
- .claude/config/databases.md (Query Patterns section)
- .claude/config/databases.md (collection IDs for all DBs)
- CLAUDE.md Safety Rules and Writing Style sections

## Steps

1. **Pull daily logs** for the current week from Daily Logs DB (ID from config/databases.md, DAILYLOG_DB). Fetch each relevant daily log page for full content.

2. **Query Supplier DBs** (READ-ONLY) using config/databases.md (Query Patterns section):
   - columns: Name, Status, + price fields per project (see config/databases.md (Query Patterns section) common column sets)
   - project: all
   - analyst calculates Key Numbers with week-over-week deltas

3. **Compile by project:**
   - ## Pulse
   - ## Kaia Rewards
   - ## M-Band COO-PT
   - ## ISC

4. Each project section has sub-sections per topic. Blockers in prose. Next steps by project.

5. **Present draft** to Andre for review.

6. After approval, **push to Notion** Weekly Reports DB (ID from config/databases.md, WEEKLY_DB) as Draft.

## Safety

- NEVER include internal housekeeping (e.g., Notion cleanup, command testing).
- Weekly Report status stays Draft. Only Andre marks it as Sent in Notion UI.
- Follow CLAUDE.md Safety Rules and Writing Style sections.

## Output Format

Sections by project. Sub-sections per topic. Key Numbers table with W-over-W deltas. Blockers in prose. Next steps by project. Colleague tone, not consultant.
