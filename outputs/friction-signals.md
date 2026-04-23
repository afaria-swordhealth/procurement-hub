# Friction Log
# Persistent across sessions. /improve appends unexecuted signals here and clears them when executed.
# Resolved section is kept for retrospective (monthly session reads it for patterns).

## Pending

[FRICTION: SLACK_INGEST_MISSING ts=2026-04-22]
Goal: Ingest important Slack messages into Notion (OI DB, supplier pages, project context, decisions/commitments).
Current state: /warm-up reads Slack for briefing context only — no write pipeline from Slack → Notion.
Gap: Decisions made on Slack (e.g., scale supplier switch, quantity changes, exec alignment) are lost unless manually captured in /log-sent or meeting notes.
Proposed: New skill /slack-scan. Reads channels/DMs marked log=true in slack-channels.md. Extracts: decisions, commitments, blockers, supplier updates, escalations. Writes to: OI DB (Commitment/Decision type), supplier page comments, context files. Trigger: inside /wrap-up or standalone cron.
Priority: mini-sprint (not micro-fix — requires new skill file + slack-channels.md schema extension).

## Resolved
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
