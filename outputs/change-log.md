# Change Log
# Rolling daily file. Keeps only today's entries.
# History lives in git log. On wrap-up, this file is committed then cleared for tomorrow.

## 2026-04-23

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
