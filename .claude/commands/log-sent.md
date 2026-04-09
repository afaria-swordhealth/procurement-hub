---
description: Scan sent emails, compare with Notion outreach sections, propose missing log entries.
---

# Log Sent

**Agents:** supplier-comms (Gmail scan), notion-ops (Notion outreach state)

## Purpose
After Andre sends supplier emails (which may have been manually edited from drafts), scan Gmail sent folder and compare with Notion outreach sections. Propose entries for any emails not yet logged.

## Steps

### Phase 1: Scan Gmail Sent
1. Scan sent emails from the last 24h (default) or user-specified range:
   ```
   in:sent after:YYYY/MM/DD from:a.faria@swordhealth.com OR from:a.faria@sword.com
   ```
2. Filter to supplier domains only (Section 7 of CLAUDE.md).
3. For each sent email, extract: recipient, subject, date, snippet.

### Phase 2: Fetch Notion Outreach State
4. For each supplier that received an email, fetch their Notion page.
5. Read the ## Outreach section and find the last logged entry date.

### Phase 3: Compare and Flag
6. For each sent email where the date is newer than the last Notion outreach entry, flag as "not logged".
7. Also flag if the email content differs significantly from the draft (Andre may have edited manually).

### Phase 4: Filter for Milestones
8. For each flagged email, apply the Milestones Only policy (see supplier-comms.md):
   - Only log if the email represents a milestone (quote, selection, samples, NDA, SQA, status change, decision, commitment with date, blocker).
   - Skip routine acks, FYI emails, logistics back-and-forth, and content that's just restating the email.
9. For qualifying milestones, draft entry in format:
   ```
   **Apr DD** — One-line milestone. Key fact or commitment.
   ```
10. Present summary table of what will be logged and what was skipped (with reason).

### Phase 5: Write (direct)
11. Write milestone entries directly to Notion (no approval needed for outreach).
12. Follow outreach condensation rules from notion-ops.md (>7 entries: archive older ones).
13. Log all writes to outputs/change-log.md.

## Output Format
Table per project:
| Supplier | Email Date | Subject | Last Outreach in Notion | Proposed Entry |
Then the full proposed entries below the table for review.

## Rules
- Outreach writes go directly to Notion (no approval needed).
- Other Notion writes (status changes, price updates, etc.) still require approval.
- If an email was sent to a supplier not in Notion DB, flag it (may need DB entry created first).
- Use the actual sent email content (not the draft), since Andre may have edited manually.
- One outreach entry per email thread per day (consolidate if multiple emails in same thread same day).
- Only log milestones. Skip routine acks, FYIs, and logistics back-and-forth.
- ALL NOTION CONTENT IN ENGLISH.
- NO EM DASHES.
