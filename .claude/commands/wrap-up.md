---
description: End of day routine. Logs sent emails, syncs context files, creates daily log, commits to git.
model: opus
---

# Wrap-Up (End of Day)

**Agents:** supplier-comms (log-sent), notion-ops (daily log + context sync)

Follow CLAUDE.md Safety Rules and Writing Style sections.

## Steps

### Phase 0: Slack Scan
0. Read config/slack-channels.md for user IDs, channel IDs, and Group DMs.
1. For each key person: slack_read_channel with user ID. For each channel and Group DM: slack_read_channel with channel ID, slack_read_thread for replies.
2. Extract decisions, action items, or context relevant to Pulse, Kaia, or M-Band. Include findings in the daily log and pending items.

### Phase 1: Log Sent Emails
3. Run /log-sent procedure: scan Andre's sent emails for today.
4. For each sent email to a supplier domain, check Notion Outreach for matching entry.
5. Write missing milestone entries directly (auto-approved per check-outreach.md).
6. Report what was written and what was skipped.

### Phase 2: Context Sync
7. Query all 4 Supplier DBs following config/databases.md (Query Patterns section). Include columns: Name, Status, Notes, "NDA Status", "Samples Status", "Last Outreach Date", Region, Currency. A partial sync causes drift — all fields must be included.
8. Update context files (paths listed in .claude/config/databases.md). After updating, set the `# Last synced: YYYY-MM-DDTHH:MM` header to the current timestamp. If context-doctor is available, run it in report-only mode after sync to catch any remaining drift.

### Phase 2b: External Work
8b. Read outputs/external-work.md. If it contains entries beyond the header comments, include them in the daily log under ## ISC (or the relevant project section if specified).
8c. After inclusion in the daily log draft, clear the file back to headers only.

### Phase 3: Daily Log
9. Check if today's daily log exists in Notion (Daily Logs DB, see .claude/config/databases.md).
   - If yes: present current content, ask if anything to add.
   - If no: compile from today's mail-scan results, approved actions, change-log entries, and external work (Phase 2b). Present draft for approval.

### Phase 3b: Meeting Outcome Prompt

Check whether a `/meeting-prep` was run this session. Look for:
- `meeting-prep` entries in `outputs/session-state.md` Pending Actions
- Lines containing "meeting-prep" in today's `outputs/change-log.md`

If a meeting-prep was found: ask André — "Did you meet with [supplier/person] today? Want to log the outcome to ruflo? (yes/no)"
- **Yes:** Run meeting-prep Step 8 — call `mcp__ruflo__memory_store` with key `meeting::[supplier]::[YYYY-MM-DD]`, namespace "procurement", tags ["meeting", project, supplier].
- **No or skipped:** move on silently.

If no meeting-prep entry found this session: skip silently.

### Phase 4: Commit and Push
10. After daily log is approved and pushed to Notion:
    a. Run:
    git add context/ outputs/ .claude/skills/ CLAUDE.md .claude/agents/ .claude/commands/ .claude/config/*.md .claude/procedures/
    git commit -m "EOD [date]: context synced, daily log complete"
    git push
    b. Only after git push confirms success: clear outputs/change-log.md — keep only the header lines (# Change Log, policy comment, and today's date heading). If git push fails, halt and report the error. Do NOT clear the change-log until push succeeds — the entries are the only local record of today's writes.

### Phase 5: Summary
11. Present summary:
    - Sent emails logged (list entries written)
    - Context files updated (list changes)
    - Daily log status (created or updated)
    - Git commit hash + push status
    - Pending items for tomorrow (from Open Items DB + unanswered emails)

## Rules
- Always run log-sent BEFORE context sync (outreach may change during log-sent).
- Always sync context files BEFORE creating the daily log (log may reference current state).
- If daily log already exists and is Complete, skip Phase 3.
- Git commit + push is automatic after approval. No separate confirmation needed.
