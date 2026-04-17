---
description: Start of day routine. Load context, review pending items, scan emails, prepare priorities.
model: opus
---

# Warm-Up (Start of Day)

**Agents:** notion-ops (pending items), supplier-comms (email scan), logistics (tracking)

## Quick Mode (`/warm-up --quick`)

Use when: returning to session after a short break, or Last-Warm-Up is same day and context is still fresh.

**Skips:**
- Phase 1: Do NOT read context files. Use session-state.md snapshot directly.
- Phase 6: Skip reading overnight report files. Check last-modified timestamps only.

**Keeps:** Decision Queue, Promises, Email scan, Slack scan, Calendar, Crons, Briefing — all unchanged.

If session-state.md is missing or Last-Warm-Up > 8h, fall back to full warm-up automatically and note it.

Follow CLAUDE.md Safety Rules and Writing Style sections.

## Steps

### Phase 1: Context Load
1. Read all 3 context files (pulse, kaia, mband suppliers.md). Paths listed in .claude/config/databases.md.
2. Flag any context file older than 24h (may be stale, suggest /cross-check).

### Phase 2: Decision Queue + Promises
3. Run the Decision Queue render per `.claude/procedures/decision-queue-render.md`. This is the FIRST thing Andre sees: OIs grouped by Overdue / Today / This week / Blocked, with inline stale flag (⚠ stale if leading Context date >21d old on overdue or blocked items).
4. Read outputs/promises.md. Surface every open promise immediately after the Decision Queue, flagged by overdue/due-today/upcoming. If a promise has an `OI` reference, note it inline so André doesn't process the same item twice.
5. Fetch yesterday's daily log from Notion (Daily Logs DB, see .claude/config/databases.md). Extract any open actions or items marked as pending that are NOT already surfaced in the Decision Queue.
6. Check outputs/change-log.md for yesterday's last entries (what was the last thing done?).

### Phase 3: Email Scan (Incoming)
6. Run email scan following .claude/procedures/scan-gmail.md for all 3 projects. Cross-reference with Notion using config/databases.md (Query Patterns section). Present recommendations per email: Log, Draft Reply, Ignore, or Escalate.

### Phase 3b: Sent Email Scan
6b. Scan Andre's sent emails since last session (from:a.faria@swordhealth.com OR from:a.faria@sword.com).
    - For each sent email to a supplier domain (per config/domains.md), check if the corresponding Outreach section in Notion has a matching entry.
    - For sent emails to internal recipients (swordhealth.com, sword.com) that mention supplier names or procurement keywords, note them as context (decisions communicated, escalations sent, etc.).
    - Flag: supplier emails sent but not logged in Outreach (>24h old).

### Phase 4: Slack Scan
7. Read config/slack-channels.md for user IDs, channel IDs, and Group DMs.
   For each key person: slack_read_channel with user ID. For each channel and Group DM: slack_read_channel with channel ID, slack_read_thread for replies.
   Extract decisions, action items, or context relevant to Pulse, Kaia, or M-Band.
   Note any unanswered messages or pending requests.
   **Silent abort guard:** If slack_read_channel returns an empty result for a DM with an active contact (Jorge, Miguel, Paulo, Pedro, Bianca, Sofia), do not treat as "no messages." Flag in the briefing: "Slack scan returned empty for [person] — may be a connection issue. Verify manually." Continue with other channels.

### Phase 5: Calendar Check
8. Check Google Calendar for today's meetings (if calendar MCP available). Flag any meetings related to procurement (Pulse, Kaia, M-Band, supplier names, key stakeholders).

### Phase 6: Overnight Reports
9. Check if remote triggers produced reports overnight:
   - outputs/housekeeping-report.md (daily housekeeping)
   - outputs/cross-check-report.md (Mon + Thu cross-check)
   If found, include key findings in the briefing. Flag items that need Andre's decision.

### Phase 7: Maintenance Status
10. Check outputs/change-log.md for last housekeeping and cross-check dates.
11. Count unpushed commits: `git log --oneline origin/main..HEAD | wc -l`.
12. Check context file "Last synced" headers for staleness (>24h = warn).

### Phase 8: Start Session Crons
13. Start in-session recurring tasks (CronCreate):
    - Every 2 hours: silent /mail-scan. Only notify Andre if new emails found.
    - Every 3 hours: silent /log-sent. Write outreach milestones directly (auto-approved). Only notify if entries were written.
14. Confirm crons started in the briefing.

### Phase 9: Day Briefing
15. Present a single briefing covering all phases.

### Phase 10: Write Session State
16. After presenting the briefing, write outputs/session-state.md with:
    - Timestamps: Last-Warm-Up (now), Last-Mail-Scan, Last-Log-Sent, Last-Wrap-Up
    - Active Sessions: this session's role (A or B) and start time
    - Context Snapshot: carry-over items, new findings, email state (last scan time + unread count), Slack state
    - Upcoming Meetings: next 5 days
    - Pending Actions: items flagged for André's decision
    This file is the shared context for any session that starts after this warm-up.

## Output Format

Single briefing, organized by:
1. DECISION QUEUE: Overdue / Today / This week / Blocked (from OI DB, grouped)
2. PROMISES: Open commitments from promises.md
3. OVERNIGHT: Results from automated housekeeping/cross-check (if any)
4. NEW: Emails (incoming + sent not logged), Slack messages, notifications since last session
5. TODAY: Meetings and deadlines
6. PRIORITIES: Top 3 recommended actions for today
7. MAINTENANCE: Unpushed commits, context staleness
8. SESSION: Crons started (mail-scan every 2h, log-sent every 3h)

## Rules
- Read-only. No writes until Andre approves actions from the briefing.
- If calendar MCP not available, skip Phase 5 and note it.
- Keep the briefing scannable. No walls of text.
- If Andre provides a quick debrief of offline actions (calls, WhatsApp, manual edits), incorporate into the briefing context.
