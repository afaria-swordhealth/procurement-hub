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

### Micro-fix #4 — log-sent dynamic lookback
- `commands/log-sent.md` Phase 1: date_range now reads Last-Log-Sent from session-state, covers full gap (max 7d). Fixed 24h window was missing milestones after weekend gaps.

### Micro-fix #5 — daily-log completeness check
- `commands/daily-log.md` Step 3: stops if all 4 sections already complete; appends only missing sections if partial.

### Micro-fix #6 — supplier-onboarding field validation
- `skills/supplier-onboarding/SKILL.md`: post-creation check for Name/Status/Region/Currency/Notes before proceeding to Step 3.

### Mini-sprint #7 — OI inline bullet detection
- `commands/housekeeping.md` Phase 4 rule 17b: detects inline bullets in ## Open Items, flags NEEDS YOUR DECISION for migration.
- `commands/audit.md` Phase 2: marks inline bullets in ## Open Items as Critical violation.

### Micro-fix #8 — wrap-up context sync explicit fields
- `commands/wrap-up.md` Phase 2: lists all 8 required sync fields; adds Last-synced timestamp update + context-doctor call.

### Micro-fix #9 — Exception 5: OI In Progress auto-approved
- `CLAUDE.md` §5: Exception 5 — OI Status Pending/Blocked → In Progress auto-approved when email/Slack confirms active work started.

### Micro-fix #10 — check-outreach language check
- `procedures/check-outreach.md`: translate to English before writing. Do not write PT then translate later.

### Micro-fix #11 — NDA Status validation at onboarding
- `skills/supplier-onboarding/SKILL.md` Step 5: added post-NDA field check — after NDA decision, verify NDA Status is non-null before proceeding to Step 6. Previously absent; caused 12+ null NDA Status fields requiring bulk audit cleanup.

### Micro-fix #12 — wrap-up Phase 2 completion guard
- `commands/wrap-up.md` Phase 2 Step 8: added completion check — after writing context files, re-read each file's `# Last synced` header to verify update succeeded. Do not proceed to Phase 3 if any file is still stale. Prevents silent partial syncs.

### Micro-fix #13 — change-log future date guard
- `CLAUDE.md` §4d: added change-log date rule — always use `currentDate` from system context, never compute. If date would be in the future, use `currentDate` and log a warning. Eliminates recurring session-doctor auto-fix pattern.

### Micro-fixes #15–#21 — 3rd retroactive scan (deepest)

- **#15** `skills/risk-radar/SKILL.md` Step 1a: add M4 DB-first `Last Outreach Date` query before falling back to page fetch. Consistent with supplier-chaser Step 2 pattern.
- **#16** `procedures/decision-queue-render.md`: replace broken `SUBSTR(Context, 1, 10)` blocked-since calc (fails post-CLAUDE.md §4c reform) with deadline-age proxy `julianday('now') - julianday(Deadline)`. Renders as "Xd past deadline".
- **#17** `commands/wrap-up.md` Phase 4c: add CronDelete step — reads Session Crons from session-state.md and deletes each before git push. Prevents cron accumulation across sessions.
- **#18** `commands/housekeeping.md` Phase 4 rule 16: replace `SUBSTR(Context, 1, 10) < date(...)` stale SQL (broken post §4c reform) with `Deadline < date('now', '-21 days')` deadline-age proxy.
- **#19** `config/databases.md` context-sync column set: updated to include `Region`, `Currency`, `"Last Outreach Date"` — matches wrap-up.md explicit field list added in micro-fix #8.
- **#20** `skills/context-doctor/SKILL.md`: documented Invocation modes (auto-fix default vs --report-only). Makes housekeeping's "report-only mode" instruction enforceable and visible.
- **#21** `skills/supplier-chaser/SKILL.md` Step 6: fixed duplicate step "4." numbering — renumbered to 4, 5, 6.

### Mini-sprint #14 — OI Supplier field missing from creation checklist
Root cause: `Supplier` field exists in OI DB schema (databases.md) but was absent from `create-open-item.md` 7-field checklist and CLAUDE.md §4c required fields table. `supplier-rejection` Step 5 queried `WHERE Supplier LIKE '%{supplier}%'` — silently returned empty for all OIs created via standard flow.

**3 files updated:**
- `procedures/create-open-item.md`: field checklist updated from 7 → 8 fields; Supplier added as #8 with guidance (exact DB Name match, omit for ISC-level OIs)
- `CLAUDE.md §4c`: Supplier row added to Required Fields table
- `skills/supplier-rejection/SKILL.md` Step 5: SQL updated with dual filter — `Supplier LIKE OR Item LIKE` — covers post-fix OIs (Supplier set) + legacy OIs (supplier in Item title)
