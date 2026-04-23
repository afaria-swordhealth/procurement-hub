# Change Log
# Rolling daily file. Keeps only today's entries.
# History lives in git log. On wrap-up, this file is committed then cleared for tomorrow.

## 2026-04-23

[EVENT: MICRO_FIX id=T4-1 file=skills/quote-intake/SKILL.md]
quote-intake Step 1a: validity <30d flag now explicitly says "routes to SHOW BEFORE WRITE, does not halt". Prevents confusion with PDF OCR HALT path.

[EVENT: MICRO_FIX id=T4-4 file=skills/supplier-chaser/SKILL.md]
supplier-chaser Rules: added Terminology clarification — DEFERRED (draft created, send-window blocked) vs MCP ERROR/skipped (no draft created).

[EVENT: MICRO_FIX id=T4-3 file=skills/session-doctor/SKILL.md]
session-doctor Step 1c: cron check threshold 2h → 8h. Crons stay valid all working day; 2h caused false "crons dropped" reports after a lunch break.

[EVENT: MICRO_FIX id=IMPROVE_SOURCE_G file=skills/improve/SKILL.md]
/improve: added Source G — improvement-plan.md §11 backlog. Pre-flight reads improvement-plan.md. T4 items surface always; T2 items surface when ungated; T3 items surface only after ledger ≥20 entries.

[EVENT: MICRO_FIX id=LEDGER_MEETING_NOTES file=skills/meeting-notes/SKILL.md]
meeting-notes Phase 2 SHOW BEFORE WRITE: added inline ledger-append instruction at approval prompt + Rules entry. Classes: oi_create_action, oi_create_decision, oi_close.

[EVENT: SKILL_CREATE skill=meeting-notes file=skills/meeting-notes/SKILL.md]
Two-phase skill: Phase 1 stores notes to Notion (My Work Log → Meeting Notes → W{week} → page, auto-approved). Phase 2 extracts action items, supplier changes, legal decisions, proposes OI creates/closes/updates (SHOW BEFORE WRITE). Week pages auto-created. Title = verbatim meeting title + date + time.

[EVENT: NOTION_STRUCTURE_CREATE pages=3 path="My Work Log → Meeting Notes → W17 → Final Alignment Pulse FDA Apr 23"]
Created Meeting Notes section + W17 week page + first meeting page (Final Alignment: Pulse — Private Label 3rd Party FDA Devices | Apr 23, 15:30).

[EVENT: MINI_SPRINT id=SLACK_INGEST_MISSING files=skills/slack-scan/SKILL.md,config/slack-channels.md,commands/wrap-up.md]
Slack→Notion ingest pipeline: created /slack-scan skill (6-step: scan log=true channels → classify signals → dedup vs OI DB → SHOW BEFORE WRITE → write OIs + comments → update Last-Slack-Scan). Added log/log_types columns to slack-channels.md (8 DMs log=true, 2 group DMs log=true, 3 channels log=true). Added Phase 0b to wrap-up.md to call /slack-scan at EOD.

[EVENT: MINI_SPRINT id=ARCH3_T1-3 files=skills/quote-intake/SKILL.md,skills/rfq-workflow/SKILL.md,skills/supplier-selection/SKILL.md,procedures/exec-checkpoints.md]
Exec-checkpoint resume path: added ## Step Resumption section to all 3 critical skills mapping steps_done tail → next entry point. Updated pre-flight detection text to reference the section. Added lifecycle step 1b to exec-checkpoints.md procedure.

[EVENT: IMPROVE_PERSIST unexecuted=2]
ARCH3_T1-3 (exec-checkpoint resume, mini) and SLACK_INGEST_MISSING (Slack→Notion pipeline, mini) left in friction-signals.md ## Pending for next session.

[EVENT: MICRO_FIX id=ARCH3_T1-2 files=commands/warm-up.md,commands/log-sent.md]
Timestamp timing: warm-up Phase 10 now writes Last-Warm-Up with (started) suffix; Phase 9 completion updates to (completed). log-sent Final Step writes Last-Log-Sent AFTER all writes complete.

[EVENT: MICRO_FIX id=ARCH3_T1-7 file=.claude/safety.md]
Exception 5 "clearly shows" replaced with explicit 3-condition checklist: (1) explicit action language, (2) directly addresses blocking condition, (3) traceable evidence (timestamp+sender+task reference).

[EVENT: MICRO_FIX id=ARCH3_T1-1 files=skills/supplier-chaser/SKILL.md,skills/quote-intake/SKILL.md,skills/rfq-workflow/SKILL.md]
Autonomy ledger disconnected: added inline ledger-append instructions at SHOW BEFORE WRITE gates in all 3 skills. supplier-chaser was completely missing it; quote-intake and rfq-workflow had Rules-only note — now also inline at each gate.

[EVENT: MICRO_FIX id=ARCH3_T1-6 files=commands/wrap-up.md]
Phase 2a blocker_count + top_deadline: replaced fragile context-file text parsing with OI DB queries (Status=Blocked COUNT; MIN(Deadline) non-Closed). Fallback preserved.

[EVENT: MICRO_FIX id=ARCH3_T1-5 file=skills/quote-intake/SKILL.md]
Auto-write 30% delta condition: replaced vague "within 30% of it" with explicit formula abs((new_unit_eur - prior_unit_eur) / prior_unit_eur) <= 0.30.

[EVENT: MICRO_FIX id=ARCH3_T1-4 file=skills/supplier-chaser/SKILL.md]
Replaced 3 promises.md references with OI DB equivalents: Pre-flight step 5 (skip note), Step 1 From-promises block (deprecated note), Step 6b sub-step 5 (OI Type=Commitment create instead of promises.md append).

[EVENT: SKILL_RUN skill=morning-brief status=delivered decisions=3 overdue=5 signals=5 deferred=13]
Brief delivered via chat (Slack send failed: Proxy error). Fallback per skill rules.

[WARNING: STALE_LOCK ts=2026-04-23T00:50 sessionId=3ec755a2]
Prior /improve session left .claude/scheduled_tasks.lock stale (>5h old). Treated as crashed prior run. Proceeding normally.

[EVENT: OI_CREATE count=4 source=promise_retirement]
Created OIs: 34ab4a7d…810a (Pulse T2D / Kevin Wang), 34ab4a7d…8106 (Kaia sourcing decision / Caio), 34ab4a7d…8132 (Transtek LoE / André), 34ab4a7d…813e (Transtek UDI-DI / André).

[EVENT: PROMISE_RETIREMENT status=deprecated]
promises.md: added DEPRECATED header; all 11 open promises now have OI links. OI DB is canonical. File retained for backward compat.

[EVENT: B5_AUDIT result=no_action]
5 active OIs with null Supplier verified as legitimately ISC-level. No backfill required.

[EVENT: WARM_UP_UPDATE field="Phase 8 cron"]
warm-up.md Phase 8: added morning-brief cron re-register step (weekdays 07:32, config/morning-brief-target.md).

## 2026-04-22

[EVENT: NOTION_SCHEMA_UPDATE dbs=4 field="NDA Status" operation="add canonical options"]
M-Band Supplier DB: added Not Started (red), In Progress (yellow), Sent (blue), Signed (green) to NDA Status schema (existing Pending/Executed/Not Required preserved as legacy).
Pulse Supplier DB: added Not Started (red), In Progress (yellow) to NDA Status schema.
Kaia Supplier DB: added Not Started (red), In Progress (yellow) to NDA Status schema.
BloomPod Supplier DB: full canonical set applied (Not Required, Not Started, In Progress, Sent, Signed).

[EVENT: NOTION_FIELD_UPDATE db=M-Band field="NDA Status" from="Pending" to="Not Started" count=3]
Migrated: Falcon Electronica, Sanmina, Electronica Cerler — Pending → Not Started.

[EVENT: NOTION_FIELD_UPDATE db=M-Band field="NDA Status" from="Executed" to="Signed" count=10]
Migrated: Quantal, MCM, Ribermold, Vangest, TransPak, SHX Watch, JXwearable, Uartrónica, GAOYI, Xinrui Group — Executed → Signed.

[EVENT: CONTEXT_UPDATE file=context/mband/suppliers.md]
Updated nda field: Falcon Electronica, Sanmina, Electronica Cerler → Not Started. Summary line updated: "executed" → "signed", "pending" → "not started".

[EVENT: CLAUDE_MD_UPDATE section="4c"]
Added Answered to Status enum: Pending/In Progress/Answered/Blocked/Closed.

[EVENT: PROCEDURE_UPDATE file=create-open-item.md field=Status]
Added Answered to field checklist #2 Status options.

[EVENT: L3_SHIPPED config=morning-brief-target.md cron=f2b24a98 schedule="weekdays 07:32"]
Created config/morning-brief-target.md (channel_id: U03BKAV990S). Cron job f2b24a98 registered for /morning-brief weekdays at 07:32. Session-scoped — must re-register at warm-up. improvement-plan.md §10 L3 row updated to ✅ shipped.
