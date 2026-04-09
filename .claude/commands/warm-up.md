---
description: Start of day routine. Load context, review pending items, scan emails, prepare priorities.
---

# Warm-Up (Start of Day)

**Agents:** notion-ops (pending items), supplier-comms (email scan), logistics (tracking)

## Steps

### Phase 0: Remote Control
0. Activate Remote Control (`/remote-control`). This connects the session for remote monitoring.

### Phase 1: Context Load
1. Read all 3 context files (pulse, kaia, mband suppliers.md).
2. Flag any context file older than 24h (may be stale, suggest /cross-check).

### Phase 2: Pending Items from Yesterday
3. Fetch yesterday's daily log from Notion. Extract any open actions or items marked as pending.
4. Query Open Items DB for items with status not Complete, sorted by deadline.
5. Check outputs/change-log.md for yesterday's last entries (what was the last thing done?).

### Phase 3: Email Scan
6. Run the same logic as /mail-scan (Gmail scan for all 3 projects, cross-reference Notion, present recommendations).

### Phase 4: Calendar Check
7. Check Google Calendar for today's meetings (if calendar MCP available). Flag any meetings related to procurement (Pulse, Kaia, M-Band, supplier names, Jorge, Bianca, Pedro, Miguel).

### Phase 5: Day Briefing
8. Present a single briefing:
   - Pending from yesterday (actions not completed, items overdue)
   - New emails with recommendations (from Phase 3)
   - Today's meetings (from Phase 4)
   - Top 3 priorities for today (based on deadlines, overdue items, unanswered emails)
   - Stale context warning (if any file >24h old)

## Output format
Single briefing, organized by:
1. CARRY-OVER: Items from yesterday still open
2. NEW: Emails and notifications since last session
3. TODAY: Meetings and deadlines
4. PRIORITIES: Top 3 recommended actions for today

## Rules
- Read-only. No writes until Andre approves actions from the briefing.
- If calendar MCP not available, skip Phase 4 and note it.
- Keep the briefing scannable. No walls of text.
