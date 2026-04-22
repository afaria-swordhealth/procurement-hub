# Pending Signals
<!-- Append-only queue. Consumed by /morning-brief, produced by observer crons + risk-radar. -->
<!-- Format: `[EVENT: TYPE key=value ...] score=N ts=ISO` on its own line, prose below. -->
<!-- Purged monthly by /wrap-up. History lives in git. -->

## Pending
<!-- New signals append here. /morning-brief reads top N by score. -->

[EVENT: SCHEMA_ENUM_DRIFT source=notion field=nda affected=3 suppliers=Falcon_Electronica,Sanmina,Electronica_Cerler project=mband] ts=2026-04-22T01:20
Notion M-Band supplier DB has NDA Status value `Pending` which is NOT in Schema v1 canonical enum (`Not Required | Not Started | In Progress | Sent | Signed` per `.claude/procedures/context-loader.md` §Dense format spec). `/wrap-up` c082b93 synced the Notion value back into `context/mband/suppliers.md` lines 181/194/207, overwriting Schema v1 migration's `Not Started`. Decision required: (a) add `Pending` to canonical enum (local-only change), or (b) update Notion DB to rename `Pending` → `Not Started` and reconcile 3 supplier pages. Parked pending André review (gate #10 adjacent: Notion schema write).

[EVENT: SCHEMA_ENUM_DRIFT source=notion field=oi_status missing=Answered] ts=2026-04-22T01:22
Notion Open Items DB Status enum has 5 values (`Pending, In Progress, Answered, Blocked, Closed`) but CLAUDE.md §4c and `.claude/procedures/create-open-item.md` line 16 list only 4 (missing `Answered`). Low impact — `Answered` is rarely used. Decision: (a) add `Answered` to local docs, or (b) remove `Answered` from Notion. Parked as doc drift.

[EVENT: SCHEMA_ENUM_CONFIRMED source=notion field=oi_type value=Commitment status=exists_unused] ts=2026-04-22T01:22
Notion OI DB Type enum already includes `Commitment` (0 OIs currently use it). No schema write needed to unblock promise-tracker migration. Gate #10 (add Commitment to Notion) is VOID. Promise-tracker retirement sprint can proceed with zero Notion prep work when scheduled.

## Deferred
<!-- Overflow from attention-budget cap. Re-scored on next brief. -->

[EVENT: DEFER original_type=Blocker score=27.3 reason=budget defer_count=1] ts=2026-04-21T10:30
Sarah (Legal) — Sword labeler classification (Pulse, Apr 22 deadline, Blocker)

[EVENT: DEFER original_type=Blocker score=25.2 reason=budget defer_count=1] ts=2026-04-21T10:30
M-Band — component blocker via Future Electronics (Apr 22, Blocker, AMS-OSRAM 30wk PO 15d overdue)

[EVENT: DEFER original_type=Action Item score=16.8 reason=budget defer_count=1] ts=2026-04-21T10:30
Uartrónica — awaiting re-quote (M-Band, Apr 22)

[EVENT: DEFER original_type=Action Item score=16.8 reason=budget defer_count=1] ts=2026-04-21T10:30
Ribermold — clarification meeting Apr 22 (M-Band)

[EVENT: DEFER original_type=Action Item score=10.4 reason=budget defer_count=1] ts=2026-04-21T10:30
Transtek — NDA under Sword Health Inc. (Pulse, Apr 24)

[EVENT: DEFER original_type=Action Item score=10.4 reason=budget defer_count=1] ts=2026-04-21T10:30
Urion — regulatory docs gap pack (Pulse, Apr 24)

[EVENT: DEFER original_type=Action Item score=10.4 reason=budget defer_count=1] ts=2026-04-21T10:30
Unique Scales — full US market documentation revision (Pulse, Apr 28)

[EVENT: DEFER original_type=Action Item score=10.4 reason=budget defer_count=1] ts=2026-04-21T10:30
Transtek — initiate Master Supply Agreement (Pulse, Apr 27)

[EVENT: DEFER original_type=Action Item score=9.6 reason=budget defer_count=1] ts=2026-04-21T10:30
Cerler — send volumes + technical documentation (M-Band, Apr 28)

[EVENT: DEFER original_type=Action Item score=8.0 reason=budget defer_count=1] ts=2026-04-21T10:30
BloomPod — Coin Cell HW Investigation (Apr 24)

[EVENT: DEFER original_type=Question score=6.24 reason=budget defer_count=1] ts=2026-04-21T10:30
Unique Scales — confirm ISTA packaging capability (Pulse, Apr 24)

[EVENT: DEFER original_type=Question score=6.24 reason=budget defer_count=1] ts=2026-04-21T10:30
Transtek — confirm ISTA packaging capability (Pulse, Apr 24)

## Consumed
<!-- /morning-brief moves signals here after surfacing. Purged monthly. -->
