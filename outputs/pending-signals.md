# Pending Signals
<!-- Append-only queue. Consumed by /morning-brief, produced by observer crons + risk-radar. -->
<!-- Format: `[EVENT: TYPE key=value ...] score=N ts=ISO` on its own line, prose below. -->
<!-- Purged monthly by /wrap-up. History lives in git. -->

## Pending
<!-- New signals append here. /morning-brief reads top N by score. -->

## Deferred
<!-- Overflow from attention-budget cap. Re-scored on next brief. -->

[EVENT: DEFER original_type=Action_Item score=26.4 reason=budget defer_count=1] ts=2026-04-23T08:58
M-Band Future Electronics — AMS-OSRAM PO 18d overdue. Gated on Jorge 1:1 Apr 27.

[EVENT: DEFER original_type=Question score=20.8 reason=budget defer_count=1] ts=2026-04-23T08:58
Novares — direct-contact search 2d overdue (LinkedIn / Ribermold / MCM referrals).

[EVENT: DEFER original_type=Action_Item score=18.2 reason=budget defer_count=3] ts=2026-04-23T08:58
Transtek — NDA under Sword Health Inc. (Pulse, Apr 24)

[EVENT: DEFER original_type=Action_Item score=16.8 reason=budget defer_count=3] ts=2026-04-23T08:58
Uartrónica — awaiting re-quote with updated BOM + COO-X volumes (M-Band, Apr 24)

[EVENT: DEFER original_type=Action_Item score=10.4 reason=budget defer_count=3] ts=2026-04-23T08:58
Urion — regulatory docs gap pack (Pulse, Apr 24)

[EVENT: DEFER original_type=Action_Item score=10.4 reason=budget defer_count=3] ts=2026-04-23T08:58
Unique Scales — full US market documentation revision (Pulse, Apr 28)

[EVENT: DEFER original_type=Action_Item score=10.4 reason=budget defer_count=3] ts=2026-04-23T08:58
Transtek — initiate Master Supply Agreement (Pulse, Apr 27)

[EVENT: DEFER original_type=Action_Item score=9.6 reason=budget defer_count=3] ts=2026-04-23T08:58
Cerler — send volumes + technical documentation (M-Band, Apr 28)

[EVENT: DEFER original_type=Action_Item score=8.0 reason=budget defer_count=3] ts=2026-04-23T08:58
BloomPod — Coin Cell HW Investigation (Apr 24)

[EVENT: DEFER original_type=Question score=6.24 reason=budget defer_count=3] ts=2026-04-23T08:58
Unique Scales — confirm ISTA packaging transit test capability (Pulse, Apr 24)

[EVENT: DEFER original_type=Question score=6.24 reason=budget defer_count=3] ts=2026-04-23T08:58
Transtek — confirm ISTA packaging transit test capability (Pulse, Apr 24)

[EVENT: DEFER original_type=Decision score=12.75 reason=budget defer_count=2] ts=2026-04-23T08:58
Kaia — Max Strobel sample feedback (Tiger / Second Page / ProImprint). 8d overdue.
Score depressed by project_kaia_dependency gate (weight 0.3). Surfaces when Max/Caio deadline set.

[EVENT: DEFER original_type=Decision score=11.25 reason=budget defer_count=2] ts=2026-04-23T08:58
Kaia — Max decide: Nimbl vs SV Direct fulfillment. 6d overdue.
Same gate as above. Escalate only if ProImprint production slot closes (watch James email thread).

## Consumed
<!-- /morning-brief moves signals here after surfacing. Purged monthly. -->

[EVENT: CONSUMED skill=morning-brief ts=2026-04-23T08:58]
TOP3-1: Pulse Final Alignment 15:30 — surfaced as Decision #1.

[EVENT: CONSUMED skill=morning-brief ts=2026-04-23T08:58]
TOP3-2: Sofia QTA chain (record retention + manufacturing site + parent-company doc) — surfaced Decision #2.

[EVENT: CONSUMED skill=morning-brief ts=2026-04-23T08:58]
TOP3-3: Ribermold Apr 22 clarification meeting log missing — surfaced Decision #3.

[EVENT: CONSUMED skill=morning-brief ts=2026-04-23T08:58]
OVERDUE: Transtek SCA Jira (Blocked 6d) — surfaced in Overdue.

[EVENT: CONSUMED skill=morning-brief ts=2026-04-23T08:58]
OVERDUE: Unique Scales SCA Jira (Blocked 6d) — surfaced in Overdue.

[EVENT: CONSUMED skill=morning-brief ts=2026-04-23T08:58]
OVERDUE: Legal/Finance PLD alignment (Blocked 6d) — surfaced in Overdue.

[EVENT: CONSUMED skill=morning-brief ts=2026-04-23T08:58]
OVERDUE: Sarah labelling classification (Blocked 1d) — surfaced in Overdue.

[EVENT: CONSUMED skill=morning-brief ts=2026-04-23T08:58]
OVERDUE: Unique Scales NDA initiate (André, 2d overdue) — surfaced in Overdue.

[EVENT: CONSUMED skill=morning-brief ts=2026-04-23T08:58]
SIGNAL: Miguel DM unanswered (SHX strap samples) — surfaced in New Signals.

[EVENT: CONSUMED skill=morning-brief ts=2026-04-23T08:58]
SIGNAL: Cuff size distribution (André "double check" commitment) — surfaced in New Signals.

[EVENT: CONSUMED skill=morning-brief ts=2026-04-23T08:58]
SIGNAL: Titoma dropped from M-Band CM shortlist — surfaced in New Signals.

[EVENT: CONSUMED skill=morning-brief ts=2026-04-23T08:58]
SIGNAL: Mind card deck $14K PO (Kendall/NetSuite) — surfaced in New Signals.

[EVENT: CONSUMED skill=morning-brief ts=2026-04-23T08:58]
SIGNAL: Sofia Transtek QTA parent-company entity doc needed — surfaced in New Signals.

[EVENT: CONSUMED skill=morning-brief ts=2026-04-22T09:00]
SCHEMA_ENUM_DRIFT — NDA Status "Pending" not in canonical enum (M-Band: Cerler/Falcon/Sanmina).
Decision required: add to enum OR rename Notion values. Parked.

[EVENT: CONSUMED skill=morning-brief ts=2026-04-22T09:00]
SCHEMA_ENUM_DRIFT — OI Status "Answered" missing from CLAUDE.md §4c + create-open-item.md.
Decision: add to local docs OR remove from Notion. Low impact.

[EVENT: CONSUMED skill=morning-brief ts=2026-04-22T09:00]
SCHEMA_ENUM_CONFIRMED — OI DB Type "Commitment" already exists in Notion (0 uses).
Gate #10 VOID. Promise-tracker migration can proceed without Notion prep.

[EVENT: CONSUMED skill=morning-brief ts=2026-04-22T09:00]
Sarah (Legal) — Sword labeler classification (Pulse, Blocked, due Apr 22). Surfaced in "Also due today."

[EVENT: CONSUMED skill=morning-brief ts=2026-04-22T09:00]
M-Band Future Electronics — AMS-OSRAM PO 17d overdue (Blocked, due Apr 22). Surfaced in "Also due today."

[EVENT: CONSUMED skill=morning-brief ts=2026-04-22T09:00]
Ribermold — clarification meeting Apr 22. Surfaced in Top 3 Decision #2 area + Calendar.
