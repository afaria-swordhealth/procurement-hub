---
description: Start of day routine. Load context, review pending items, scan emails, prepare priorities.
model: opus
---

# Warm-Up (Start of Day)

**Agents:** notion-ops (pending items), supplier-comms (email scan), logistics (tracking)

## Modes

| Mode | Invocation | Loads | When to use |
|---|---|---|---|
| **Light** (default) | `/warm-up` or `/warm-up --light` | Session-state + `context/index.json` (context-loader Layer 1). Project context files loaded on demand per `.claude/procedures/context-loader.md`. No Notion re-queries beyond Decision Queue. | Most mornings. Target <30s, ~10k tokens. Relies on last `/wrap-up` context sync being fresh (<24h). |
| **Full** | `/warm-up --full` | All 4 context files (Layer 2) + Notion verification of supplier DBs + full email + Slack + calendar. | After a gap >24h, crash recovery, or when Last-Wrap-Up is stale. ~40k tokens. |
| **Quick** (deprecated alias) | `/warm-up --quick` | Same as Light. Preserved for backward compat. | Prefer `--light`. |

Rule: if `session-state.md` is missing, `Last-Warm-Up > 8h`, or `context/index.json` is missing/stale → auto-promote to Full and note it in the briefing.

**Skips in Light:**
- Phase 1: Do NOT read context files eagerly. Load per `context-loader.md` Layer 2 rules when the briefing references a specific project/supplier.
- Phase 6: Skip change-log review (trust /wrap-up handoff).

**Keeps in Light:** Decision Queue, Promises, Email scan, Slack scan, Calendar, Crons, Briefing — unchanged.

Follow CLAUDE.md Safety Rules and Writing Style sections.

## Steps

### Phase 1: Context Load
1. **Light mode:** read `context/index.json` only (context-loader Layer 1). Per-project context files load on demand per `.claude/procedures/context-loader.md`.
1a. **Full mode:** read all 4 context files (pulse, kaia, mband, bloompod suppliers.md). Paths listed in .claude/config/databases.md.
2. Flag any context file or index older than 24h (may be stale, suggest `/warm-up --full` or `/wrap-up`).

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

### Phase 6: Overnight Activity Check
9. Check `outputs/change-log.md` for any entries written since Last-Wrap-Up (scheduled tasks or cron jobs may have run overnight). Flag entries that reference unexpected Notion writes or errors. No separate report files — change-log is the authoritative record.

### Phase 7: Maintenance Status
10. Check outputs/change-log.md for last housekeeping and cross-check dates.
11. Count unpushed commits: `git log --oneline origin/main..HEAD | wc -l`.
12. Check context file "Last synced" headers for staleness (>24h = warn).

### Phase 8: Start Session Crons

**Pre-cron guard (concurrent warm-up).** Before calling CronCreate, read `outputs/session-state.md` sections `## Active Sessions` and `## Session Crons`. If ANOTHER session entry is listed with a start time within the last 30 min AND `## Session Crons` already contains ≥3 cron ID lines (non-comment): SKIP step 13 entirely — do NOT call CronCreate. Instead, append one line under `## Session Crons`: `# Session {role} sharing prior crons (registered {N}min ago) — no new registration`. Continue to Phase 9. This prevents duplicate registration when a second warm-up runs post-compact or in a parallel session. Wrap-up Phase 4b will tolerate the comment line (CronDelete on a non-ID skips silently).

13. Start in-session recurring tasks (CronCreate):
    - Every 2 hours: silent /mail-scan. Only notify Andre if new emails found.
    - Every 3 hours: silent /log-sent. Write outreach milestones directly (auto-approved). Only notify if entries were written.
    - **Morning brief (weekdays 07:32):** if `.claude/config/morning-brief-target.md` exists and contains a non-empty `channel_id` line, register cron `32 7 * * 1-5` → `/morning-brief` with `durable: true`. This is session-scoped per runtime constraints — re-register every warm-up.
13b. Immediately after CronCreate calls return: write the returned cron IDs to `outputs/session-state.md` under `## Session Crons` (create the section if absent). Format: one ID per line. Do NOT wait for Phase 10 — if the session crashes before Phase 10, cron IDs must already be persisted for wrap-up Phase 4b to clean up.
14. Confirm crons started in the briefing.

### Phase 10: Write Session State
16. **Before presenting the briefing**, write outputs/session-state.md with:
    - Timestamps: `Last-Warm-Up: {time} (started)`, Last-Mail-Scan, Last-Log-Sent, Last-Wrap-Up. Write `(started)` suffix on Last-Warm-Up — it will be updated to `(completed)` after Phase 9.
    - Active Sessions: this session's role (A or B) and start time
    - Context Snapshot: carry-over items, new findings, email state (last scan time + unread count), Slack state
    - Upcoming Meetings: next 5 days
    - Pending Actions: items flagged for André's decision
    After writing, re-read the first 10 lines of `outputs/session-state.md` and verify the `## Timestamps` section is present. If missing or file is under 10 lines, retry the write. If retry fails, halt and report — do not present the briefing until session-state is confirmed written.

### Phase 9: Day Briefing
17. Present a single briefing covering all phases.
18. **After the briefing is successfully delivered:** update the `Last-Warm-Up` line in `outputs/session-state.md` to replace `(started)` with `(completed)`. This confirms the warm-up fully completed and prevents stale-detection from treating a crashed mid-briefing session as fresh.

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
