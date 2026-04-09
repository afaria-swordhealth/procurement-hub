---
description: Background maintenance. Log sent emails, clean Outreach, check OIs, verify compliance. No decisions needed.
---

# Housekeeping

**Agents:** supplier-comms (Gmail read), notion-ops (Notion read+write)
**Session role:** B (background). Does NOT create Gmail drafts or update context files.

## Steps

### Phase 1: Log Sent Emails (milestones only)
1. Scan Gmail sent (last 24h default):
   ```
   in:sent (from:a.faria@swordhealth.com OR from:a.faria@sword.com) after:YYYY/MM/DD
   ```
2. Filter to supplier domains (CLAUDE.md Section 7).
3. For each supplier with sent emails, fetch Notion page Outreach section.
4. Compare: identify emails newer than last Outreach entry.
5. Apply milestones filter (supplier-comms.md policy). Skip routine acks, FYIs, logistics.
6. Write qualifying milestone entries directly to Notion Outreach (no approval needed).
7. Apply condensation rules (>7 visible: archive older ones).

### Phase 2: Outreach Maintenance
8. For each active supplier page (Status not Rejected), check:
   - More than 7 visible Outreach entries? Archive older ones.
   - Summary line at top present and current? Update if stale.
   - Any entries in Portuguese? Flag for translation.

### Phase 3: Open Items Check
9. Query Open Items DB for items with Status != Complete.
10. Flag: overdue (deadline passed), stale (no update in 2+ weeks), resolved but not closed.
11. Propose closures for resolved items (present in report, do not write).

### Phase 4: Notes Compliance
12. Query all 3 Supplier DBs for active suppliers.
13. Check Notes field: max 2 lines, EN only, no pricing/contact info, format "TYPE (Location). Product + differentiator. Flag."
14. Flag non-compliant entries (present in report, do not write).

### Phase 5: Context Drift Check
15. Read context/{project}/suppliers.md for all 3 projects.
16. Compare key fields (Status, last outreach date, price) against Notion DB state.
17. Flag any drift (present in report, do not write).

### Phase 6: Unanswered Emails
18. For each active supplier, check: last received email date vs last sent email date.
19. Flag suppliers where we received an email >48h ago with no reply from us.

## Output

Single report:

```
HOUSEKEEPING REPORT — Apr DD

OUTREACH LOGGED:
- [Supplier]: [milestone entry written]
- Skipped: [count] routine emails

OUTREACH MAINTENANCE:
- [Supplier]: archived [X] entries
- [Supplier]: summary line updated

OPEN ITEMS:
- Overdue: [item] (deadline [date])
- Propose close: [item] (reason)

NOTES COMPLIANCE:
- [Supplier]: [issue]

CONTEXT DRIFT:
- [file]: [field] says X, Notion says Y

UNANSWERED (>48h):
- [Supplier] ([contact]): last received [date], no reply
```

## Rules
- Outreach writes: direct to Notion (no approval).
- All other writes: report only, do not execute. Andre decides in Session A.
- Never create Gmail drafts. Read-only on Gmail.
- Never update context/ files. That belongs to Session A (operational).
- Check outputs/change-log.md before writing to a supplier page. If another session wrote to that page in the last 10 minutes, skip it.
- ALL NOTION CONTENT IN ENGLISH.
- NO EM DASHES.
