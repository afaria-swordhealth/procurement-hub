# Pending Signals
<!-- Append-only queue. Consumed by /morning-brief, produced by observer crons + risk-radar. -->
<!-- Format: `[EVENT: TYPE key=value ...] score=N ts=ISO` on its own line, prose below. -->
<!-- Purged monthly by /wrap-up. History lives in git. -->

## Pending
<!-- New signals append here. /morning-brief reads top N by score. -->

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
