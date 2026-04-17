# Rules Quick Reference
# Condensed from CLAUDE.md §5 + §10. Agents load this instead of full CLAUDE.md sections.

## Safety: Technically Impossible
- Cannot send email (draft only), delete Notion pages, or delete/archive Gmail

## Safety: Blocked (show André first)
- Supplier status → Rejected
- Price field update
- NDA Status change (exception: housekeeping may set Not Required on Rejected without approval)
- First outreach to new supplier (André writes personally)
- Weekly Report → Sent (André does in Notion UI)
- Maintenance Rules are READ-ONLY always

## Safety: Show Before Write
Every Notion write: (1) present to André, (2) wait for explicit approval, (3) log to outputs/change-log.md.
Exception: Outreach milestones go directly to Notion without approval.

## Core Rules
1. SHOW BEFORE WRITE — display changes, wait for approval
2. NEVER DELETE — set status to Rejected/Archived instead
3. SINGLE-DB SCOPE — each agent writes only to its designated DBs
4. ALL NOTION CONTENT IN ENGLISH
5. NEVER SEND EMAIL — Gmail DRAFT only
6. NO EM DASHES — use commas, periods, or "or"
7. CHECK BEFORE CREATE — verify daily log entry doesn't exist before creating
8. OIs IN SUPPLIER PAGES — linked DB view only, never inline bullets; all OIs in central DB (collection://505b7f08-8816-4bf7-b77a-7f232b52d0a0)

## Writing Style
- No em dashes. Short sentences. Simple transitions. No filler words.
- Colleague tone, not consultant or bot.
- All Notion content in English.
- Portuguese only: PT supplier emails, Jorge Garcia (Slack + email), Sofia Lourenço (Slack + email).
- Sign-off: "Best," or "Thanks," — never "Best regards,"
- Embed links always: Slack `<URL|text>`, Gmail `<a href="URL">text</a>`
- Never put local paths (G:\, C:\) in Notion. Use Google Drive links.

## Scope Boundaries
- Proactive scanning (Slack DMs, Gmail) runs only during /warm-up and /session-start.
- During task execution, respond to the specific ask only. Do not expand scope or pile on additional proposals.
