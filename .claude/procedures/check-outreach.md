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
6. Add/update summary line at top:
   ```
   **[X] milestones since [first date]. Last: [date] ([topic]). Key: [2-3 milestone events with dates].**
   ```

## Write Permissions
- Outreach entries go **directly to Notion without approval** (exception to SHOW BEFORE WRITE)
- Before writing to ## Outreach, verify the heading exists on the page. If not found, report to Andre instead of writing.
- Before writing, check outputs/change-log.md: if another session wrote to this page in last 10 min, skip
- When writing outreach: (1) append to outputs/change-log.md first (claim the slot), (2) then write to Notion, (3) if Notion write fails, note the failure in change-log.
