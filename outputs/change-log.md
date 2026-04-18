# Change Log
# Rolling daily file. Keeps only today's entries.
# History lives in git log. On wrap-up, this file is committed then cleared for tomorrow.

## 2026-04-18

### M3 — Autonomy T3: Full implementation (10-agent methodology, Phase 4)

**Bug fixes (B1, B2):**
- `CLAUDE.md §4` /log-sent Step 7: removed "Wait for André's approval" for OI comments — contradicted Exception 2. Now auto-writes directly.
- `log-sent.md` Phase 5b trailing line: "present... for approval" replaced with "write directly, log to change-log."
- `rfq-workflow` Step 4c: justification updated — OI record creation is a standalone auto-approval rule, not covered by Exception 2 (which applies to OI page comments via notion-create-comment only).

**New exceptions in CLAUDE.md §5:**
- Exception 3: quote-intake pricing fields auto-approved when conditions met (no flags, FX from config, within 30% of prior quote).
- Exception 4: rfq-workflow Status → "RFQ Sent" auto-approved after André confirms send.

**New auto-approvals (high-frequency operations):**
- `rfq-workflow` Step 4b: Status → "RFQ Sent" now auto-updates after send confirmation. Last gated step in the send cluster removed.
- `quote-intake` Steps 4+5: collapsed into auto-write when Exception 3 conditions met. Single confirmation line output; SHOW BEFORE WRITE path still fires if any flag raised.
- `supplier-chaser` Tier 1: Gmail drafts auto-create when chase 1, ≤5d overdue, one unambiguous email address, language matches region. Shown as [AUTO] in table; André can skip #N. Tier 2/3 always gated.

**Housekeeping tightening:**
- `housekeeping.md` Phase 4: overdue OIs now get auto-comment "housekeeping flagged overdue [date]" via notion-create-comment (Exception 2).
- `housekeeping.md` Phase 2 rule 6: Notes pricing removal requires exact-match guard (within 1% tolerance). Mismatch → NEEDS YOUR DECISION.
- `housekeeping.md` Phase 3 rule 11: Currency auto-fix narrowed to null-only. Non-null mismatches → NEEDS YOUR DECISION.
- `housekeeping.md` Phase 6 rule 23: 48h unanswered clock starts Monday 09:00 for emails received Fri 17:00+ or weekend.

**V3 adversarial fixes (3 HIGH/MEDIUM gaps patched):**
- `quote-intake` + `CLAUDE.md` Exception 3: first-ever quote (no prior ruflo record) → SHOW BEFORE WRITE. Prior quote required for 30% range check.
- `rfq-workflow` Step 4 header: confirmation bound to draft from Step 3 only, not ambiguous generic "yes".
- `supplier-chaser` Tier 1 condition: auto-create excluded when supplier status = Quote Received or Shortlisted (active commercial exchange).

### session-doctor auto-fix
- change-log date header corrected: 2026-04-19 → 2026-04-18 (future date, likely late-session write error)

### mail-scan (silent cron)
- OI 33eb4a7d (Transtek Finance onboarding): comment added — bank letter missing account info, awaiting new upload from Transtek to Zip #3139. Pedro Coentrão CC'd.

### M3 — Autonomy T3: OI comments auto-approved + rfq OI auto-create

- `CLAUDE.md §5`: added Exception 2 — OI page comments via notion-create-comment are auto-approved (routine audit trail). NOT excepted: Context rewrites, status changes.
- `log-sent` Phase 5b: OI comments now auto-write without approval gate
- `rfq-workflow` Step 4c: response-tracking OI auto-created after send confirmation (no SHOW BEFORE WRITE)
- `supplier-chaser` Rules: SHOW BEFORE WRITE scope narrowed to Gmail drafts only; OI comments auto
- `quote-intake` Rules: OI comment approval gate removed

### M2 — Self-healing Level 4: execution checkpoints

Execution checkpoint pattern implemented in 3 critical skills:
- `quote-intake`: pre-flight check + checkpoint before Step 4 write + updates after Steps 4, 5, 7 + mark complete after Step 8
- `rfq-workflow`: pre-flight check + checkpoint before Gmail draft + update after OI created + mark complete after Step 4d
- `supplier-selection`: pre-flight check (Step 0b) + checkpoint store (Step 0c) + updates after winner shortlisted + OI created + mark complete after ruflo store

Pattern: `exec::{skill}::{subject}::{date}` in ruflo namespace "procurement". On incomplete detection: STOP and surface to André with steps_done list.

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

### Sword Insighter — gap fill: PO process + re-quote process

- `knowledge/po-first-order-process.md` (NEW): post-selection flow — Zip budget, PO issuance, tooling deposit, production monitoring, first shipment, Nimbl, OI map
- `knowledge/requote-process.md` (NEW): re-quote triggers, what to share/withhold, Notion doc format, ruflo delta, outreach milestones
- `knowledge/INDEX.md`: added both new files
- `CLAUDE.md §11`: added both files to knowledge base list

### Sword Insighter — knowledge base created
- `.claude/knowledge/INDEX.md` (NEW): index of all knowledge files
- `.claude/knowledge/nda-process.md` (NEW): NDA process — triggers, Zip, Bradley, status values, project notes
- `.claude/knowledge/supplier-onboarding-process.md` (NEW): 3-track onboarding (Procurement + Finance/AP + QARA), per-project deps
- `.claude/knowledge/qara-engagement.md` (NEW): Sofia Lourenço contact rules, SQA/QTA/LoE/UDI, André relay role
- `.claude/knowledge/zip-workflow.md` (NEW): Zip portal states, notifications, NDA + vendor + budget flows
- `.claude/knowledge/cross-functional-map.md` (NEW): stakeholder directory, decision authority, escalation paths
- `CLAUDE.md §11`: added Knowledge base section referencing .claude/knowledge/ (Sword Insighter)

### M2 — Self-healing Level 4: proper methodology (10-agent discovery + implementation)

10 discovery agents ran across 5 lenses (Correctness x3, Adversarial x2, Domain x2, Simulation x2, Zero Context x1). 9 strong-signal findings. Implementation covers clusters A+B+C+D+F.

**A1+A2 — Detection reliability (all 3 original skills):**
- `quote-intake`, `rfq-workflow`, `supplier-selection`: replaced `memory_search` (semantic, threshold 0.9) with `memory_retrieve` (exact key, deterministic)
- Removed `{YYYY-MM-DD}` from checkpoint keys — cross-midnight recovery now works correctly
- Key format: `exec::{skill}::{subject}` (date preserved in value object only)

**B1 — Structural fix (supplier-selection):**
- Checkpoint check moved from Step 7 (post-approval) to Pre-flight item 5
- Step 7 now only stores the checkpoint; no longer re-checks

**D1 — Hard block on ruflo failure (supplier-selection):**
- If `memory_store` fails in Step 7: STOP — downstream rejections are irreversible without protection

**C1 — Checkpoint granularity (rfq-workflow):**
- Added checkpoint update after Step 4a (outreach): `steps_done: ["gmail_draft", "outreach"]`
- Added checkpoint update after Step 4b (status): `steps_done: ["gmail_draft", "outreach", "status"]`
- Prevents duplicate outreach writes on recovery

**C2 — Checkpoint granularity (quote-intake):**
- Split Step 7 into 3 separate checkpoint updates: after context_file, change_log, outreach
- Recovery now shows exact sub-step that failed within Step 7

**F1 — New skill protected (supplier-rejection):**
- Added pre-flight checkpoint check (`memory_retrieve`, key: `exec::supplier-rejection::{supplier}`)
- Added checkpoint store before Step 7 writes
- Added updates after: gmail_draft, ois_closed, status_updated, ruflo
- Protects against OI/Supplier DB status mismatch on partial failure
