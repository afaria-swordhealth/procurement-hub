# Friction Log
# Persistent across sessions. /improve appends unexecuted signals here and clears them when executed.
# Resolved section is kept for retrospective (monthly session reads it for patterns).

## Pending

[FRICTION: ARCH3_T1-1 ts=2026-04-23 tier=micro source=arch-audit-3.md]
Autonomy ledger disconnected from SHOW BEFORE WRITE gates.
Files: skills/quote-intake/SKILL.md, skills/supplier-chaser/SKILL.md, skills/rfq-workflow/SKILL.md, procedures/ledger-append.md
Fix: Add ledger-append step immediately after each approval gate outcome in the 3 skills.
Agents: A4+A5+A7 (HIGH confidence — flagged independently by 3 agents)

[FRICTION: ARCH3_T1-2 ts=2026-04-23 tier=micro source=arch-audit-3.md]
Session-state timestamps written at phase start, not completion — crash leaves false-fresh timestamp.
Files: commands/warm-up.md, commands/log-sent.md (and mail-scan if SKILL exists)
Fix: Move timestamp writes to AFTER phase completion. Add status: completed|started per timestamp.
Agents: A3+A4+A6 (HIGH/MED/MED)

[FRICTION: ARCH3_T1-3 ts=2026-04-23 tier=mini source=arch-audit-3.md]
Exec-checkpoint resume path undefined — detection exists but recovery does not.
Files: skills/quote-intake/SKILL.md, skills/rfq-workflow/SKILL.md, skills/supplier-selection/SKILL.md, procedures/exec-checkpoints.md
Fix: Add ## Step Resumption section to each critical skill mapping steps_done arrays to entry points.
Agents: A4+A6 (HIGH/MED)

[FRICTION: ARCH3_T1-4 ts=2026-04-23 tier=micro source=arch-audit-3.md]
supplier-chaser Step 6 still writes to deprecated promises.md.
Files: skills/supplier-chaser/SKILL.md (Step 6)
Fix: Replace promises.md write with OI DB Type=Commitment entry.
Agents: A4 (HIGH)

[FRICTION: ARCH3_T1-5 ts=2026-04-23 tier=micro source=arch-audit-3.md]
Auto-write 30% delta formula undefined in quote-intake — inconsistent across sessions.
Files: skills/quote-intake/SKILL.md (~line 112)
Fix: Add formula: abs((new_unit_eur - prior_unit_eur) / prior_unit_eur) <= 0.30
Agents: A2 (HIGH)

[FRICTION: ARCH3_T1-6 ts=2026-04-23 tier=micro source=arch-audit-3.md]
context/index.json missing blocker_count + top_deadline — Layer 1 fast path always falls back to L2.
Files: commands/wrap-up.md (Phase 2a), context/index.json
Fix: Compute + write blocker_count (Blocked OIs per project) and top_deadline (earliest OI deadline per project) in wrap-up Phase 2a.
Agents: A3 (HIGH)

[FRICTION: ARCH3_T1-7 ts=2026-04-23 tier=micro source=arch-audit-3.md]
Exception 5 "clearly shows" subjective — inconsistent OI Status auto-transitions across sessions.
Files: .claude/safety.md (Exception 5)
Fix: Replace "clearly shows" with 3-condition checklist (supplier started/processing/working; unblocked/resolved/fixed; timestamp+assignee+task).
Agents: A5 (MED)

[FRICTION: SLACK_INGEST_MISSING ts=2026-04-22]
Goal: Ingest important Slack messages into Notion (OI DB, supplier pages, project context, decisions/commitments).
Current state: /warm-up reads Slack for briefing context only — no write pipeline from Slack → Notion.
Gap: Decisions made on Slack (e.g., scale supplier switch, quantity changes, exec alignment) are lost unless manually captured in /log-sent or meeting notes.
Proposed: New skill /slack-scan. Reads channels/DMs marked log=true in slack-channels.md. Extracts: decisions, commitments, blockers, supplier updates, escalations. Writes to: OI DB (Commitment/Decision type), supplier page comments, context files. Trigger: inside /wrap-up or standalone cron.
Priority: mini-sprint (not micro-fix — requires new skill file + slack-channels.md schema extension).

## Resolved
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
