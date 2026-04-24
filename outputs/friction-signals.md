# Friction Log
# Persistent across sessions. /improve appends unexecuted signals here and clears them when executed.
# Resolved section is kept for retrospective (monthly session reads it for patterns).

## Pending

## Resolved
- [x] [2026-04-24 → 2026-04-24] session-doctor: no /ping recommendation when Gmail stale — token expiry discovered only after log-sent FAIL — micro — fixed in skills/session-doctor/SKILL.md (Last-Mail-Scan > 4h now surfaces /ping-first guidance)
- [x] [2026-04-24 → 2026-04-24] change-log stale date-section persists after wrap-up — ## {TARGET_DATE} heading preserved in clear step, next day's entries pile alongside it — micro — fixed in commands/wrap-up.md (Phase 4c: clear to 3 header comment lines only; session-doctor auto-adds fresh date header)
- [x] [2026-04-24 → 2026-04-24] Session-liveness check missing — idle Session A blocks writes indefinitely — mini — safety.md: 60min liveness threshold; session-doctor Step 1a: IDLE_SESSION flag; wrap-up Phase 4b: clears ## Active Sessions on EOD
- [x] [2026-04-24 → 2026-04-24] Skill handoff rfq→quote-intake implicit, no formal queue — mini — created outputs/skill-queue.md; rfq-workflow writes entry on quote received; quote-intake pre-flight surfaces it, Step 8 clears it; session-doctor Step 2b checks stale entries (>7d)
- [x] [2026-04-24 → 2026-04-24] Ruflo key naming ad-hoc across skills — orphaned records risk — mini — created config/ruflo-schema.md (canonical schema + slug format + retrieve vs search rule); fixed meeting-prep Step 8 key to use slug
- [x] [2026-04-24 → 2026-04-24] wrap-up synced all 4 project DBs unconditionally — mini — Phase 2 pre-step added to commands/wrap-up.md (change-log keyword scan + context freshness check; skips projects not touched + fresh < 24h)
- [x] [2026-04-24 → 2026-04-24] Context files not validated vs Notion on session start — mini — session-doctor Step 2 (24h threshold + COUNT_MISMATCH), context-loader.md drift signals
- [x] [2026-04-24 → 2026-04-24] MCP error policy inconsistent (HALT vs SKIP vs LOG) across skills — mini — created procedures/mcp-error-policy.md; updated quote-intake, rfq-workflow, supplier-chaser Rules
- [x] [2026-04-23 → 2026-04-23] lessons-read.md: "By skills directly" auto-write path bypasses SHOW BEFORE WRITE — micro — fixed in procedures/lessons-read.md (skills are readers-only; corrections → friction-signals.md)
- [x] [2026-04-23 → 2026-04-23] CLAUDE.md §9: skill/command/procedure/agent boundaries undocumented — micro — fixed in CLAUDE.md (workflow-type decision table added)
- [x] [2026-04-23 → 2026-04-23] meeting-notes SKILL.md: Phase 2 SHOW BEFORE WRITE missing autonomy ledger wiring — micro — fixed in skills/meeting-notes/SKILL.md
- [x] [2026-04-23 → 2026-04-23] /improve no Source G for improvement-plan.md backlog — micro — fixed in skills/improve/SKILL.md (Source G + pre-flight item 6)
- [x] [2026-04-22 → 2026-04-23] Slack→Notion ingest missing — mini — created skills/slack-scan/SKILL.md, extended config/slack-channels.md (log/log_types columns), added Phase 0b to commands/wrap-up.md
- [x] [2026-04-23 → 2026-04-23] exec-checkpoint resume path undefined — mini — fixed in quote-intake, rfq-workflow, supplier-selection SKILL.md + exec-checkpoints.md (## Step Resumption sections + lifecycle 1b)
- [x] [2026-04-23 → 2026-04-23] session-state timestamps at phase start: warm-up (started)→(completed) split; log-sent Final Step explicit write — micro — fixed in commands/warm-up.md + commands/log-sent.md
- [x] [2026-04-23 → 2026-04-23] safety.md Exception 5 "clearly shows" subjective — micro — replaced with 3-condition checklist in .claude/safety.md
- [x] [2026-04-23 → 2026-04-23] autonomy ledger disconnected from SHOW BEFORE WRITE: inline ledger steps added to 3 skills — micro — fixed in supplier-chaser, quote-intake, rfq-workflow SKILL.md
- [x] [2026-04-23 → 2026-04-23] wrap-up Phase 2a: blocker_count + top_deadline from fragile text parsing → OI DB queries — micro — fixed in commands/wrap-up.md
- [x] [2026-04-23 → 2026-04-23] quote-intake SKILL.md: auto-write 30% delta formula undefined — micro — fixed in skills/quote-intake/SKILL.md (explicit formula added)
- [x] [2026-04-23 → 2026-04-23] supplier-chaser SKILL.md: Step 6 wrote to deprecated promises.md — micro — fixed in skills/supplier-chaser/SKILL.md (3 hunks: pre-flight, Step 1, Step 6b sub-step 5)
- [x] [2026-04-22 → 2026-04-22] /mail-scan: sem closing prompt — incoming milestones em limbo sem resposta explícita — micro — fixed in mail-scan.md + mail-scan-deep.md
- [x] [2026-04-22 → 2026-04-22] /wrap-up: midnight crossing — micro — fixed in .claude/commands/wrap-up.md (TARGET_DATE pre-flight)
- [x] [2026-04-21 → 2026-04-21] supplier-enrichment: ruflo memory_store Step 5 not migrated — micro — fixed in .claude/skills/supplier-enrichment/SKILL.md (commit 1443ee1)
- [x] [2026-04-21 → 2026-04-21] change-log.md: Apr 20 section persisted below Apr 21 entries — micro — cleared in outputs/change-log.md (commit 1835131)
- [x] [2026-04-21 → 2026-04-21] package.json + package-lock.json untracked — micro — committed (commit 39a27a3)
- [x] [2026-04-21 → 2026-04-21] sword-logo.png missing prerequisite guard in build-deck — already fixed by CCR (build-deck.md pre-flight step 2)
- [x] [2026-04-21 → 2026-04-21] L5 context densification — structural — completed by CCR session before /improve ran (see change-log L5_MIGRATION + L5_VALIDATION events)
- [x] [2026-04-20 → 2026-04-21] create_draft threading: verified correct — rule documented in supplier-rejection L74, supplier-chaser L190, CLAUDE.md L104, supplier-comms.md L34–42. No code changes needed.
- [x] [2026-04-20 → 2026-04-21] ruflo exec-checkpoints: supplier-rejection, supplier-onboarding, outreach-healer — mini — fixed in 3 SKILL.md files (commit 52b8d27)
- [x] [2026-04-20 → 2026-04-21] promises.md: Berlin Wall OI ID wrong — `343b4a7d…cc39` → `343b4a7d…4c39` — micro — fixed in outputs/promises.md
- [x] [2026-04-20 → 2026-04-21] promises.md: 4 entries missing post André/Sofia Apr 20 meeting — micro — resolved by wrap-up commit (entries were uncommitted when CCR ran)
