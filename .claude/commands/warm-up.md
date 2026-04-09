---
description: Start of day routine. Load context, review pending items, scan emails, prepare priorities.
---

# Warm-Up (Start of Day)

**Agents:** notion-ops (pending items), supplier-comms (email scan), logistics (tracking)

Follow CLAUDE.md Safety Rules and Writing Style sections.

## Steps

### Phase 1: Context Load
1. Read all 3 context files (pulse, kaia, mband suppliers.md). Paths listed in .claude/config/databases.md.
2. Flag any context file older than 24h (may be stale, suggest /cross-check).

### Phase 2: Pending Items from Yesterday
3. Fetch yesterday's daily log from Notion (Daily Logs DB, see .claude/config/databases.md). Extract any open actions or items marked as pending.
4. Query Open Items DB (see .claude/config/databases.md) for items with status not Complete, sorted by deadline.
5. Check outputs/change-log.md for yesterday's last entries (what was the last thing done?).

### Phase 3: Email Scan
6. Run email scan following .claude/procedures/scan-gmail.md for all 3 projects. Cross-reference with Notion using config/databases.md (Query Patterns section). Present recommendations per email: Log, Draft Reply, Ignore, or Escalate.

### Phase 4: Slack Scan
7. Read config/slack-channels.md for user IDs and channel IDs.
   For each key person: slack_read_channel with user ID. For each channel: slack_read_channel with channel ID, slack_read_thread for replies.
   Extract decisions, action items, or context relevant to Pulse, Kaia, or M-Band.
   Note any unanswered messages or pending requests.

### Phase 5: Calendar Check
8. Check Google Calendar for today's meetings (if calendar MCP available). Flag any meetings related to procurement (Pulse, Kaia, M-Band, supplier names, key stakeholders).

### Phase 6: Day Briefing
9. Present a single briefing covering all phases.

## Output Format

Single briefing, organized by:
1. CARRY-OVER: Items from yesterday still open
2. NEW: Emails, Slack messages, and notifications since last session
3. TODAY: Meetings and deadlines
4. PRIORITIES: Top 3 recommended actions for today

## Rules
- Read-only. No writes until Andre approves actions from the briefing.
- If calendar MCP not available, skip Phase 5 and note it.
- Keep the briefing scannable. No walls of text.
