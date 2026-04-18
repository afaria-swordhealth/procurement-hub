# Change Log
# Rolling daily file. Keeps only today's entries.
# History lives in git log. On wrap-up, this file is committed then cleared for tomorrow.

## 2026-04-19

### mail-scan (silent cron)
- OI 33eb4a7d (Transtek Finance onboarding): comment added — bank letter missing account info, awaiting new upload from Transtek to Zip #3139. Pedro Coentrão CC'd.

### Audit 2.0 — Session 2 + 3 fixes applied

**Session 2 — Structural propagation:**
- Phase 0 pre-flight (session-state.md check) added to all 10 command files: audit, daily-log, test-update, weekly-report, price-compare, mail-scan-deep, cross-check, housekeeping, mail-scan, log-sent
- `test-update.md`: added change-log step after approved Notion updates
- `daily-log.md`, `weekly-report.md`: added change-log step after Notion push
- "all 3 Supplier DBs" → "all 4" in: negotiation-tracker, analyst, scan-gmail, fill-cost-fields-on-quote, wrap-up, housekeeping
- `housekeeping.md`: added Phase 6b synthesis step (supplier-chaser candidates from OI + email cross-reference)

**Session 3 — New content:**
- `warm-up.md` Phase 6: replaced dead file references with change-log scan
- `warm-up.md` quick mode: updated Phase 6 skip text
- `mail-scan.md`: added Quote Detection section with fill-cost-fields trigger
- `log-sent.md`: added Phase 4b quote detection flag
- `fill-cost-fields-on-quote.md`: changed "Runs whenever" → "Use this procedure when:" framing
- `CLAUDE.md §11`: added Skills layer; listed all 7 procedures (was 2)
- `knowledge/nda-process.md`: added NDA cancellation mid-process + expiry/renewal sections
- `knowledge/zip-workflow.md`: added Finance rejection and revision handling section
- `knowledge/qara-engagement.md`: added "If QARA objects post-selection" section; updated What NOT to do
- `knowledge/sample-testing-process.md` (NEW): Pulse sample lifecycle, tester assignments, scoring, eliminators, DHL labels
- `knowledge/INDEX.md`: added sample-testing-process.md entry + usage reference

### Sword Insighter — knowledge base created
- `.claude/knowledge/INDEX.md` (NEW): index of all knowledge files
- `.claude/knowledge/nda-process.md` (NEW): NDA process — triggers, Zip, Bradley, status values, project notes
- `.claude/knowledge/supplier-onboarding-process.md` (NEW): 3-track onboarding (Procurement + Finance/AP + QARA), per-project deps
- `.claude/knowledge/qara-engagement.md` (NEW): Sofia Lourenço contact rules, SQA/QTA/LoE/UDI, André relay role
- `.claude/knowledge/zip-workflow.md` (NEW): Zip portal states, notifications, NDA + vendor + budget flows
- `.claude/knowledge/cross-functional-map.md` (NEW): stakeholder directory, decision authority, escalation paths
- `CLAUDE.md §11`: added Knowledge base section referencing .claude/knowledge/ (Sword Insighter)
