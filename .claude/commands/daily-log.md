---
description: Compile today's daily log across all 3 projects and push to Notion as Draft.
---

# Daily Log

**Agents:** notion-ops (primary), supplier-comms (email context if needed)

**References:**
- .claude/config/databases.md (Query Patterns section)
- .claude/config/databases.md (collection IDs for all DBs)
- CLAUDE.md Safety Rules and Writing Style sections

## Steps

1. **Query Supplier DBs** using config/databases.md (Query Patterns section):
   - columns: Name, Status, Notes
   - filter: modified today
   - project: all

2. **Query Open Items DB** (ID from config/databases.md, OI_DB):
   - columns: Name, Status
   - filter: updated today

3. **Check for existing entry** in Daily Logs DB (ID from config/databases.md, DAILYLOG_DB):
   - If entry for today exists, append to it. NEVER create a duplicate.

4. **Compile per-project sections:**
   - ## Pulse
   - ## Kaia
   - ## M-Band
   - ## ISC

5. **Present draft** to Andre for review.

6. After approval, **push to Notion** Daily Logs DB as Draft.

## Safety

CHECK BEFORE CREATE is critical here. Follow CLAUDE.md Safety Rules and Writing Style sections.

## Output Format

One section per project. Each section lists changes, updates, and decisions made today. Keep entries concise, factual, no filler.
