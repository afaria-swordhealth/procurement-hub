---
description: Cross-reference Gmail, Slack, and Notion to find gaps in documentation.
---

# Cross-Check

**Agents:** supplier-comms (email + Slack scan), notion-ops (Notion state)

## Steps

### Phase 1: Email vs Notion
1. For each active supplier (not Rejected), query Gmail for last email exchange date (sent + received).
2. For each active supplier, fetch Notion page Outreach section and find last logged date.
3. Compare: flag any supplier where last email is newer than last Outreach entry.

### Phase 2: Slack vs Notion
4. Search Slack public and private channels for supplier names and project keywords (Pulse, Kaia, M-Band) from the last 7 days.
5. Search Slack DMs with Jorge Garcia, Pedro Pereira, Miguel Pais, and Bianca Lourenço for procurement-related decisions.
6. For each Slack message found, check if the decision or information is reflected in Notion (supplier page, project page, daily log, or Open Items).
7. Flag: decisions made in Slack but not in Notion (e.g., "Jorge said deprioritise Urion" but status unchanged).

### Phase 3: Slack vs Gmail
8. Check if any Slack discussions reference supplier actions that have no corresponding sent email (e.g., "we should reply to Transtek" but no sent email found).

### Phase 4: Project Pages Currency
9. For each project page (Pulse, Kaia, M-Band), check if key sections are current:
   - Shortlist reflects latest test results and verdicts
   - Pricing tables match latest quotes in Supplier DB
   - Sample status matches actual tracking/delivery state
10. Flag stale sections with last known update date.

## Output format

Gap report organized by severity:
- CRITICAL: Decisions made (Slack/email) but not reflected in Notion
- WARNING: Emails not logged to Outreach (>24h old)
- INFO: Slack discussions referencing actions not yet executed, stale project page sections

Per gap: Source (Gmail/Slack/DM), Date, Content summary, What's missing in Notion, Suggested action.

Group by project, then by severity.

## Slack search patterns
- Supplier names: search each active supplier name in public + private channels
- DM channels to check: Jorge Garcia, Pedro Pereira, Miguel Pais, Bianca Lourenço
- Keywords: supplier names, "Pulse", "Kaia", "M-Band", "scale", "BP", "cuff", "sample", "quote", "FDA", "NDA", "shortlist", "reject", "deprioritise"
- Time range: last 7 days (default, configurable by user)

## Rules
- Read-only scan. No writes until André approves.
- Present all gaps before any action.
- If a gap requires a Notion update, show the proposed change (SHOW BEFORE WRITE).
- If a gap requires an email, recommend Draft Reply but do not create it without approval.
