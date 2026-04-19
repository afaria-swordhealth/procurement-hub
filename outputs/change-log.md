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

### Structural sprint Wave 1 — 6 fixes (#22–#27)

- **#22** `commands/log-sent.md` Phase 5: add M4 Last Outreach Date update after each outreach write. Completes propagation for log-sent path (was missing alongside quote-intake + rfq-workflow).
- **#23** `skills/quote-intake/SKILL.md` Step 7: add M4 Last Outreach Date update after outreach write. Also Step 4: added prior-quote ruflo pre-check before auto-write decision — fixes backwards ordering (was running at Step 8 after the write, not before).
- **#24** `skills/rfq-workflow/SKILL.md` Step 4a: add M4 Last Outreach Date update after outreach write.
- **#25** `skills/supplier-rejection/SKILL.md` Step 7: added Step 7.7 — risk closure in ruflo. Searches open risks for rejected supplier and marks resolution: {status: "closed", reason: "supplier_rejected"}. Closes the learning loop that was promised but never implemented.
- **#26** `commands/warm-up.md` Phase 8: added Step 13b — write cron IDs to session-state immediately after CronCreate, before Phase 10. Prevents orphaned crons if session crashes before Phase 10.
- **#27** `commands/wrap-up.md` Phase 4: swapped 4b↔4c order — cron deletion now happens before change-log clear. Ensures cron deletion failures are recorded in change-log before it is wiped.
- **#28** `skills/supplier-chaser/SKILL.md` Step 6: replaced bare "update promises.md next: field" with full promise creation — appends new entry for supplier reply expectation. Fixes CLAUDE.md §4d compliance gap (all chases were missing promises.md entries).

### Structural sprint — weekly-report editorial overhaul

- `knowledge/weekly-report-rules.md`: new file — editorial rules for weekly report format (structure, section rules, names policy, Sword corporate model alignment)
- `commands/weekly-report.md`: rewritten to reference weekly-report-rules.md; added "pull previous week's goals" step; added editorial checklist before finalising; removed hardcoded analyst agent call; enforced 1-page max

### Micro-fix #43 — project-dashboard BloomPod coverage
- `skills/project-dashboard/SKILL.md`: description + Pre-flight updated — "Pulse, Kaia, or M-Band" → "Pulse, Kaia, M-Band, or BloomPod". BLOOMPOD_DB added with note: light scaffold — skip Steps 2/4/Timeline if context file absent.

### Micro-fix #44 — mail-scan promises.md closure loop
- `commands/mail-scan.md` Step 2b: added promise closure check. For each inbound supplier reply, cross-reference open `- [ ]` entries in promises.md. If matched, propose `Resolve promise` recommendation — André approves before promises.md is updated.
- `commands/mail-scan.md` Output: added "Resolve promise" to valid Recommendation values.

### Housekeeping — deleted weekly_report_W16_draft.md from repo root
- Untracked W16 draft (Apr 11–17) was sitting at root instead of outputs/. Deleted — content was from last week and already superseded.

### Micro-fix #41 — price-compare FX staleness check
- `commands/price-compare.md` Pre-flight: added read of `config/fx-rates.md` + staleness check. If rates > 7 days old: flag in output footer, do not block execution.
- `commands/price-compare.md` Step 3: added explicit FX conversion using fx-rates.md, with rate labelled in output table per supplier.

### Micro-fix #42 — weekly-pulse BloomPod omission
- `skills/weekly-pulse/SKILL.md`: description + body updated — "all 3 projects" → "all 4 projects". BLOOMPOD_DB added to Step 1 supplier query. BloomPod column added to per-project metrics table. BloomPod highlight added to output format.

### Structural sprint Wave 3 — MCP error handling (#40)

Root cause: all 6 critical skills had no defined behavior on MCP failure. Batch skills would silently abort entire runs; single-supplier skills had no HALT instruction. No distinction between ruflo failures (non-critical) and Notion/Gmail failures (critical).

**Policy applied:** Single-supplier operations → HALT on Notion/Gmail MCP failure. Batch loops → skip + log, continue. Ruflo failures → log and proceed (non-critical audit trail).

**6 files updated:**
- `skills/supplier-chaser/SKILL.md`: Rules + Step 2 — batch skip-and-report; Notion DB failure falls back to Gmail scan; Gmail also fails = skip supplier
- `skills/quote-intake/SKILL.md`: Rules + Step 4 — single-supplier HALT; ruflo pre-check failure routes to SHOW BEFORE WRITE
- `skills/rfq-workflow/SKILL.md`: Rules + Pre-flight Step 10 — single-supplier HALT; ruflo checkpoint failure = proceed fresh
- `skills/supplier-rejection/SKILL.md`: Rules + Step 7.2 — single-supplier HALT for main ops; batch OI closures skip-and-report
- `skills/supplier-onboarding/SKILL.md`: Rules — HALT-only policy; partial onboarding is dangerous (duplicate on retry)
- `commands/housekeeping.md`: Error Handling section + MCP ERRORS output bucket — batch skip-and-report; phase-level query failure skips phase, doesn't abort run

### Structural sprint Wave 2 — 9 fixes (#29–#37)

- **#29** `procedures/create-open-item.md`: "Mandatory OI triggers — create without waiting" → "Recommended OI triggers — propose to André before creating." Removes undocumented auto-write behavior not covered by any §5 exception.
- **#30** `skills/rfq-workflow/SKILL.md` Step 4c: OI creation changed from "Auto-approved after send confirmation" → SHOW BEFORE WRITE. No §5 exception covered OI creation; was an undocumented gap.
- **#31** `skills/rfq-workflow/SKILL.md` Pre-flight line 9: added `nda-process.md` read. Ensures NDA trigger conditions are validated before RFQ proceeds — was missing from 6 of 8 knowledge files in skill pre-flights.
- **#32** `commands/test-update.md` Pre-flight: added `sample-testing-process.md` read. Tester roles, eliminators, scoring system now loaded before querying test data.
- **#33** `skills/supplier-onboarding/SKILL.md` Pre-flight line 7: added `supplier-onboarding-process.md` read. 3-track timeline and dependencies now loaded before executing onboarding steps.
- **#34** `skills/supplier-qualification/SKILL.md` Pre-flight line 5: added `qara-engagement.md` read (Pulse-conditional). QARA clearance is a gate for Pulse suppliers — previously absent from pre-flight.
- **#35** `skills/risk-radar/SKILL.md` Step 1: changed "all 3 Supplier DBs" → "all 4 Supplier DBs (Pulse, Kaia, M-Band, BloomPod)". BloomPod was silently omitted from every risk scan.
- **#36** `commands/warm-up.md` Phase 10/9: moved session-state write to BEFORE briefing (not after). Added read-back verification. Fixes race condition where mail-scan during warm-up would hit stale state.
- **#37** `commands/log-sent.md` Phase 1: HALT instead of silent default-to-2 when session-state is missing. Prevents silent 2d window that could skip milestones after long gaps.
- **#38** `skills/supplier-chaser/SKILL.md` Step 4: added threading note — `create_draft` is always standalone, not threaded. André must manually reply within original thread.
- **#39** `skills/supplier-rejection/SKILL.md` Step 3: added threading note — same limitation.

### Mini-sprint #14 — OI Supplier field missing from creation checklist
Root cause: `Supplier` field exists in OI DB schema (databases.md) but was absent from `create-open-item.md` 7-field checklist and CLAUDE.md §4c required fields table. `supplier-rejection` Step 5 queried `WHERE Supplier LIKE '%{supplier}%'` — silently returned empty for all OIs created via standard flow.

**3 files updated:**
- `procedures/create-open-item.md`: field checklist updated from 7 → 8 fields; Supplier added as #8 with guidance (exact DB Name match, omit for ISC-level OIs)
- `CLAUDE.md §4c`: Supplier row added to Required Fields table
- `skills/supplier-rejection/SKILL.md` Step 5: SQL updated with dual filter — `Supplier LIKE OR Item LIKE` — covers post-fix OIs (Supplier set) + legacy OIs (supplier in Item title)
