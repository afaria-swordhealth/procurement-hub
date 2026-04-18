---
description: Scan sent emails, compare with Notion outreach sections, log missing milestones.
model: sonnet
---

# Log Sent

**Agents:** supplier-comms (Gmail scan), notion-ops (Notion outreach state)
**Rules:** Follow CLAUDE.md Safety Rules and Writing Style sections. Outreach writes go directly (no approval needed).

## Pre-flight

Read `outputs/session-state.md`. Calculate age of Last-Warm-Up:
- If < 2h: use context snapshot. Do not re-read context files.
- If 2–8h: use snapshot as baseline. Run delta scan for this task.
- If > 8h or missing: warn André and recommend /warm-up before proceeding.

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

## Phase 4b: Quote Detection

Before writing milestones, check whether any sent email in Phase 1 implies a quote was received or confirmed (e.g., André's email acknowledges a quote or requests cost revision). If so:
- Flag for André: "Quote activity detected — run `.claude/procedures/fill-cost-fields-on-quote.md` to update DB cost fields."
- Do NOT auto-run fill-cost-fields. André confirms first.

## Phase 5: Write

Write milestone entries directly to Notion per check-outreach.md write permissions.
Apply condensation rules from check-outreach.md (>7 visible entries triggers archiving).
Log all writes to outputs/change-log.md.

If an email was sent to a supplier not in any Notion DB, flag it (may need DB entry created first).

## Phase 5b: OI Cross-Reference

For each supplier where an Outreach entry was written in Phase 5, query the Open Items DB (OI_DB from .claude/config/databases.md) for open OIs linked to that supplier (Status != 'Closed').

For each open OI found, check whether the email content is relevant:
- New information that updates the OI context
- A blocker partially or fully resolved
- A commitment made by André or the supplier
- A status change implied by the email

If relevant: propose a Notion page comment via notion-create-comment on that OI (per OI discipline in CLAUDE.md §4c). Comment format: `[YYYY-MM-DD] Follow-up sent [email/Slack]. [One-line summary of what was communicated.]`
If not relevant: skip silently.

**Write permissions:** OI comment adds require André's approval (SHOW BEFORE WRITE). Present all proposed comments grouped after the Outreach write summary. Wait for approval before calling notion-create-comment.

If no open OIs exist for a supplier, skip silently — do not flag.

## Output Format

Table per project:
| Supplier | Email Date | Subject | Last Outreach in Notion | Action |

Then the full proposed entries below the table.
Use the actual sent email content (not the draft), since Andre may have edited manually.
One outreach entry per email thread per day (consolidate if multiple in same thread same day).

After Outreach writes: present any proposed OI comment adds for approval.
