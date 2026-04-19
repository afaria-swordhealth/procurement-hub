# Change Log
# Rolling daily file. Keeps only today's entries.
# History lives in git log. On wrap-up, this file is committed then cleared for tomorrow.

## 2026-04-19

### session-doctor auto-fix
- change-log date header cleared: 2026-04-18 → 2026-04-19 (stale from previous session)

### Structural sprint #1 — OI Context running log propagation fix

Root cause: `mail-scan.md` used "Update OI Context" as a recommendation label without specifying the Notion operation. 4 skills had no guidance on notion-create-comment for OI updates.

**8 files updated:**
- `commands/mail-scan.md`: renamed "Update OI Context" → "Add OI Comment"; step 3 + Jira step now explicitly use notion-create-comment, not Context rewrite
- `skills/supplier-rejection/SKILL.md` Step 7.2: adds notion-create-comment for each OI closed
- `skills/supplier-selection/SKILL.md` Step 7.3: adds note — future Decision OI updates via notion-create-comment only
- `skills/supplier-onboarding/SKILL.md`: adds OI delay update path (notion-create-comment, not Context prepend)
- `skills/negotiation-tracker/SKILL.md` Rules: OI Context read-only; updates via /log-sent or notion-create-comment
- `commands/housekeeping.md` Phase 4 rule 16: detects running-log Context (dated prefixes, PT text) → flags NEEDS YOUR DECISION for cleanup
- `procedures/create-open-item.md` Write permissions: clarified "OI comment additions via notion-create-comment: auto-execute" vs "Context field rewrites: SHOW BEFORE WRITE"
- `commands/cross-check.md` Phase 5: distinguishes material Context rewrite (notion-update-page, SHOW BEFORE WRITE) from incremental update (notion-create-comment, auto-approved)

### Mini-sprint #2 — Outreach duplicate prevention

Root cause: no pre-write existence check in check-outreach.md. Cron + manual re-runs wrote the same milestone twice.

**2 files updated:**
- `procedures/check-outreach.md`: added pre-write dedup guard — before append, check for same-date + same-event-category entry. Skip + log if found. Makes all Outreach writes idempotent.
- `commands/log-sent.md` Phase 3: replaced "email_date > last_entry_date" comparison with per-entry date+event check. Idempotent re-runs now skip already-logged emails silently.

### Micro-fix #3 — log-sent Gmail MCP resilience

- `commands/log-sent.md` Phase 5: writes one supplier at a time, logs each before moving to next. On Gmail MCP failure: log and exit cleanly, do not proceed with partial data. Re-run is safe (dedup guard).
