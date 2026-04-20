# Pending Signals
<!-- Append-only queue. Consumed by /morning-brief, produced by observer crons + risk-radar. -->
<!-- Format: `[EVENT: TYPE key=value ...] score=N ts=ISO` on its own line, prose below. -->
<!-- Purged monthly by /wrap-up. History lives in git. -->

## Pending
<!-- New signals append here. /morning-brief reads top N by score. -->

## Deferred
<!-- Overflow from attention-budget cap. Re-scored on next brief. -->

## Consumed
<!-- /morning-brief moves signals here after surfacing. Purged monthly. -->
