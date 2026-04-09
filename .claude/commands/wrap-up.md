---
description: End of day routine. Syncs context files, creates daily log, commits to git.
---

# Wrap-Up (End of Day)

**Agents:** notion-ops (daily log + context sync)

Follow CLAUDE.md Safety Rules and Writing Style sections.

## Steps

### Phase 0: Slack Scan
0. Read config/slack-channels.md for user IDs and channel IDs.
1. For each key person: slack_read_channel with user ID. For each channel: slack_read_channel with channel ID, slack_read_thread for replies.
2. Extract decisions, action items, or context relevant to Pulse, Kaia, or M-Band. Include findings in the daily log and pending items.

### Phase 1: Context Sync
3. Query all 3 Supplier DBs following config/databases.md (Query Patterns section).
4. Update context files (paths listed in .claude/config/databases.md).

### Phase 2: Daily Log
5. Check if today's daily log exists in Notion (Daily Logs DB, see .claude/config/databases.md).
   - If yes: present current content, ask if anything to add.
   - If no: compile from today's mail-scan results, approved actions, and change-log entries. Present draft for approval.

### Phase 3: Commit
6. After daily log is approved and pushed to Notion, run:
   git add context/ outputs/ CLAUDE.md .claude/agents/ .claude/commands/ .claude/config/*.md .claude/procedures/
   git commit -m "EOD [date]: context synced, daily log complete"

### Phase 4: Summary
7. Present summary:
   - Context files updated (list changes)
   - Daily log status (created or updated)
   - Git commit hash
   - Pending items for tomorrow (from Open Items DB + unanswered emails)

## Rules
- Always sync context files BEFORE creating the daily log (log may reference current state).
- If daily log already exists and is Complete, skip Phase 2.
- Git commit is automatic after approval. No separate confirmation needed.
