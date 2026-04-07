---
description: End of day routine. Syncs context files, creates daily log, commits to git.
---

# Wrap-Up (End of Day)

**Agents:** notion-ops (daily log + context sync)

## Steps

1. Query all 3 Supplier DBs and update context files:
   - context/pulse/suppliers.md
   - context/kaia/suppliers.md
   - context/mband/suppliers.md

2. Check if today's daily log exists in Notion.
   - If yes: present current content, ask if anything to add.
   - If no: compile from today's mail-scan results, approved actions,
     and change-log entries. Present draft for approval.

3. After daily log is approved and pushed to Notion, run:
   git add .
   git commit -m "EOD [date]: context synced, daily log complete"

4. Present summary:
   - Context files updated (list changes)
   - Daily log status (created/updated)
   - Git commit hash
   - Pending items for tomorrow (from Open Items DB + unanswered emails)

## Rules
- Always sync context files BEFORE creating the daily log (log may reference current state).
- If daily log already exists and is Complete, skip step 2.
- Git commit is automatic after approval. No separate confirmation needed.
