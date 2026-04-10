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

## Output Format

Gap report organized by severity:
- **CRITICAL:** Decisions made (Slack/email) but not reflected in Notion
- **WARNING:** Emails not logged to Outreach (>24h old)
- **INFO:** Slack discussions referencing actions not yet executed, stale project page sections

Per gap: Source (Gmail/Slack/DM), Date, Content summary, What's missing in Notion, Suggested action.

Group by project, then by severity.

## Safety

Read-only scan. No writes until Andre approves. Follow CLAUDE.md Safety Rules and Writing Style sections.
- If a gap requires a Notion update, show the proposed change.
- If a gap requires an email, recommend Draft Reply but do not create without approval.
