---
description: Cross-reference Gmail, Slack, and Notion to find gaps in documentation.
model: opus
---

# Cross-Check

**Agents:** supplier-comms (email + Slack scan), notion-ops (Notion state)

**References:**
- .claude/procedures/scan-gmail.md (email scanning)
- .claude/config/slack-channels.md (Slack user IDs, channel IDs)
- .claude/config/databases.md (Query Patterns section)
- .claude/config/domains.md (supplier domain lists)
- CLAUDE.md Safety Rules and Writing Style sections

## Execution rules

- Run Gmail scans for all 3 projects in parallel (background agents or concurrent tool calls). A failure in one project must not block the others. If an agent fails, note it and continue.
- Use `pageSize: 10` or less per Gmail search to avoid output overflow. Run multiple searches rather than one large one if needed.
- If Slack MCP returns empty results or fails to connect: do not silently skip. Output a manual checklist of DMs and channels to check (Jorge, Miguel, Paulo, Pedro, Sofia — and key channels from slack-channels.md). Mark Phase 2 and 3 as "incomplete — manual check required."

## Steps

### Phase 1: Email vs Notion

1. For each active supplier (not Rejected), use procedures/scan-gmail.md to find last email exchange date (sent + received):
   - direction: both
   - date_range: 7
2. For each active supplier, fetch Notion page Outreach section and find last logged date.
3. Compare: flag any supplier where last email is newer than last Outreach entry.

### Phase 2: Slack Full Scan

4. Read config/slack-channels.md for user IDs and channel IDs.
   For each key person: slack_read_channel with user ID (last 7d). For each channel: slack_read_channel with channel ID, slack_read_thread for replies.
   Extract decisions, action items, blockers, supplier-related discussions.
5. For each Slack message or DM found, check if the decision or information is reflected in Notion (supplier page, project page, daily log, or Open Items).
6. Flag: decisions made in Slack but not in Notion (e.g., "Jorge said deprioritise Urion" but status unchanged).

### Phase 3: Slack vs Gmail

7. Check if any Slack discussions reference supplier actions that have no corresponding sent email (e.g., "we should reply to Transtek" but no sent email found).

### Phase 4: Project Pages Currency

8. For each project page (Pulse, Kaia, M-Band), check if key sections are current:
   - Shortlist reflects latest test results and verdicts
   - Pricing tables match latest quotes in Supplier DB
   - Sample status matches actual tracking/delivery state
9. Flag stale sections with last known update date.

### Phase 5: OI vs Email + Slack

9. Query Open Items DB (OI_DB from .claude/config/databases.md) for all OIs with Status != Closed.
10. For each open OI:
    a. Identify the linked supplier and owner from OI properties.
    b. Scan Gmail (direction: both, date_range: 7) filtered to that supplier's domain(s) per .claude/config/domains.md.
    c. Scan Slack for mentions of the supplier name or OI topic (use slack-channels.md channel + DM list).
    d. For any thread with recent activity (last 7d), call `get_thread` on the most recent matching thread. Read the body and compare against the OI Context. Ask specifically:
       - Does this email substantively resolve the OI? (e.g., re-quote received when OI was "awaiting re-quote", supplier confirmed when OI was "awaiting confirmation", blocker cleared)
       - Does this email advance the OI state without fully resolving it?
       - Does it contradict the OI's current Context (e.g., deadline slipped, scope changed)?
    e. Flag if:
       - Status should change (Pending → Closed, Blocked → In Progress, etc.)
       - Context needs a material rewrite (scope shifted, owner changed, blocker cleared)
       - A new OI or promise should be created from what was found
    f. If no relevant activity found: skip silently (no output for that OI).
11. Output per flagged OI: proposed action with source and rationale.

### Phase 6: Unanswered Incoming Emails

12. For each active supplier with at least one incoming email in the last 7 days:
    a. Find the most recent incoming email date.
    b. Check if a sent email to that supplier exists with a date AFTER the incoming email.
    c. If no sent reply within 48 business hours of the incoming email: flag as "unanswered >48h".
    d. Exception: if the Outreach section has a note explaining the hold (e.g., "decision gated on Max/Caio", "deprioritized per André"), skip silently.
13. Output: supplier, incoming date, subject snippet, recommended action (Draft Reply / Escalate / Hold).

## Output Format

Gap report organized by severity:
- **CRITICAL:** Decisions made (Slack/email) but not reflected in Notion
- **WARNING:** Emails not logged to Outreach (>24h old)
- **INFO:** Slack discussions referencing actions not yet executed, stale project page sections

Per gap: Source (Gmail/Slack/DM), Date, Content summary, What's missing in Notion, Suggested action.

Group by project, then by severity.

**OI UPDATES NEEDED** (from Phase 5, appended after gap report):

| OI | Owner | Deadline | Source | Proposed Action |
|----|-------|----------|--------|-----------------|
| [title] | [owner] | [date] | Gmail/Slack | Update Context / Change Status / Close / Create OI |

Show proposed Context rewrites or Status changes inline. Wait for approval before writing.

## Safety

Read-only scan. No writes until Andre approves. Follow CLAUDE.md Safety Rules and Writing Style sections.
- If a gap requires a Notion update, show the proposed change.
- If a gap requires an email, recommend Draft Reply but do not create without approval.
