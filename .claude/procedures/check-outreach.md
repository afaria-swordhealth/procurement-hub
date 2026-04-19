# Procedure: Check and Write Outreach
# Reusable subroutine. Called by: /log-sent, /housekeeping, supplier-comms agent

## Milestones Policy (single source of truth)

### LOG these (milestones):
- Quote received or revised
- Supplier selected or shortlisted
- Samples shipped, received, or tested
- NDA signed, sent, or requested
- SQA initiated or completed
- Status change (Identified -> Contacted -> RFQ Sent -> etc.)
- Decision or commitment with a specific date
- Blocker raised or resolved
- Meeting held or scheduled
- RFQ sent or acknowledged
- Follow-up after >2 weeks silence (note the gap)

### SKIP these (routine):
- Simple acknowledgments ("got it", "thanks", "will check")
- FYI forwards with no action
- Logistics back-and-forth (tracking updates, label confirmations)
- Internal emails about the supplier (not TO the supplier)
- Content that merely restates what's already in the email subject

### Entry format
```
**Mon DD** -- One-line milestone. Key fact or commitment.
```
- One entry per email thread per day (consolidate if multiple emails in same thread same day)
- English only in Notion

## Condensation Rules

When writing outreach, check entry count and supplier status:
1. Shortlisted or Quote Received suppliers: archive when >10 visible entries
2. All other active suppliers: archive when >7 visible entries
3. Archive toggle label: "📁 Outreach Archive (Mon YYYY - Mon YYYY)"
4. Keep the threshold number of most recent entries visible below the toggle
5. Toggle syntax (Notion enhanced markdown): use `<details><summary>TITLE</summary>...</details>`. Do NOT use `<toggle summary="...">` — not a valid Notion block, renders as escaped literal text.
   - **If no archive toggle exists yet: CREATE one.** Move the oldest entries (those beyond the threshold count) into a new `<details>` block. Do NOT skip archiving because the toggle is absent — the toggle's absence is exactly the condition that requires creation.
   - If an archive toggle already exists: prepend newly archived entries to it and update the date range in the label.
6. Add/update summary line at top:
   ```
   **[X] milestones since [first date]. Last: [date] ([topic]). Key: [2-3 milestone events with dates].**
   ```

## Write Permissions
- Outreach entries go **directly to Notion without approval** (exception to SHOW BEFORE WRITE)
- Before writing to ## Outreach, verify the heading exists on the page. If not found, report to Andre instead of writing.
- Concurrency: session-single model (see `.claude/safety.md`). No per-write collision check.
- **Language check:** Entry must be in English before writing. If the email was in Portuguese or Chinese and the draft entry is not yet in English, translate inline before writing. Do NOT write in Portuguese intending to translate later — housekeeping is the only fix path and adds unnecessary churn.
- **Pre-write dedup guard:** Before appending, scan existing visible Outreach entries for an entry that matches BOTH: (1) same date in bold (`**Mon DD**`), AND (2) same event category by keyword — RFQ → "RFQ"; Quote → "Quote received" or "quote"; Follow-up/chase → "Follow-up" or "Chase"; Sample → "Sample" or "shipped"; NDA → "NDA"; Meeting → "Meeting" or "call"; Rejection → "rejected". If a match is found: **skip the write**. Log to `outputs/change-log.md`: `Skipped duplicate Outreach entry: [supplier] [date] [event] already logged.` This guard makes all Outreach writes idempotent — re-running log-sent or any writer on the same day+event produces no duplicates.
- When writing outreach, the write order is: (1) write to Notion first, (2) on successful write, append the success entry to outputs/change-log.md, (3) if Notion write fails, append a FAILED entry to change-log (`FAILED Outreach write: [supplier] [date] [event] — [error]`) and surface the failure to André. Rationale: the dedup guard above makes pre-claiming the slot in change-log unnecessary, and logging after the write means change-log never contains phantom entries for writes that silently failed mid-flight.
- **(M4)** After successful Notion prose write, update the supplier's `Last Outreach Date` DB field to today via `notion-update-page`. Skip if Status = 'Rejected'. If the field does not exist yet (not yet added to Notion UI), skip silently. If the update fails, note in change-log and proceed — field staleness is detectable and non-blocking.
