---
description: Scan sent emails, compare with Notion outreach sections, log missing milestones.
---

# Log Sent

**Agents:** supplier-comms (Gmail scan), notion-ops (Notion outreach state)
**Rules:** Follow CLAUDE.md Safety Rules and Writing Style sections. Outreach writes go directly (no approval needed).

## Phase 1: Scan Gmail Sent

Use .claude/procedures/scan-gmail.md with:
- direction: "sent"
- date_range: 1 (last 24h default, or user-specified)
- project_filter: "all"

Domain filtering uses .claude/config/domains.md. Keep only emails sent to known supplier domains.

For each sent email, extract: recipient, subject, date, snippet.

## Phase 2: Fetch Notion Outreach State

For each supplier that received an email, query the supplier page from the relevant DB (.claude/config/databases.md).
Read the ## Outreach section. Find the last logged entry date.

## Phase 3: Compare and Flag

For each sent email where the date is newer than the last Notion outreach entry, flag as "not logged".
Also flag if the email content differs significantly from a draft (Andre may have edited manually).

## Phase 4: Filter for Milestones

Apply .claude/procedures/check-outreach.md milestones policy:
- Only log if the email qualifies as a milestone.
- Skip routine acks, FYIs, logistics back-and-forth.
- Use the entry format defined in check-outreach.md.

Present summary table of what will be logged and what was skipped (with reason).

## Phase 5: Write

Write milestone entries directly to Notion per check-outreach.md write permissions.
Apply condensation rules from check-outreach.md (>7 visible entries triggers archiving).
Log all writes to outputs/change-log.md.

If an email was sent to a supplier not in any Notion DB, flag it (may need DB entry created first).

## Output Format

Table per project:
| Supplier | Email Date | Subject | Last Outreach in Notion | Action |

Then the full proposed entries below the table.
Use the actual sent email content (not the draft), since Andre may have edited manually.
One outreach entry per email thread per day (consolidate if multiple in same thread same day).
