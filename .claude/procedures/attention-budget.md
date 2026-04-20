# Attention Budget

Hard cap on surfaces per block. Ranks signals so the top N land, rest defer. Consumed by `/morning-brief` and any other proactive surface.

## Caps per block

| Block | Cap | Rationale |
|---|---|---|
| Top 3 Decisions Today | 3 | One morning, three choices. Four is noise. |
| Overdue | 5 | Beyond 5 overdue, André needs a housekeeping pass, not a brief. |
| New Signals since last scan | 5 | Delta view; older signals stay in pending-signals.md. |
| Calendar | All (next 24h) | No cap — calendar is bounded naturally. |

Excess items are written to `outputs/pending-signals.md` under `## Deferred` with their computed score. Next brief re-scores against new signals.

## Scoring formula

```
score = urgency × type_weight × project_weight
```

### urgency (days vs deadline)

| Condition | Value |
|---|---|
| Past deadline | `10 + days_overdue` (cap 30) |
| Due today | 10 |
| Due tomorrow | 7 |
| Due this week | 4 |
| Due next week | 2 |
| No deadline | 1 |

### type_weight

| Type | Weight | Why |
|---|---|---|
| `Blocker` | 3.0 | Stops work |
| `Decision` | 2.5 | Needed to unblock others |
| `Action Item` | 2.0 | André execution |
| `Commitment` | 2.0 | External promise made |
| `Question` | 1.2 | Passive wait |
| `RISK` event (from risk-radar) | `severity_map` → CRITICAL=3, HIGH=2, MED=1.3, LOW=0.8 | Producer-supplied |

### project_weight

Pulse = 1.3 (active regulatory + volume track) · M-Band = 1.2 (component risk) · BloomPod = 1.0 (scaffold) · Kaia = 0.8 (gated on Caio/Max per `project_kaia_dependency`) · ISC-level = 1.0.

## Ranking rules

1. Compute score for every eligible signal.
2. Sort descending.
3. Fill each block until cap hit.
4. Tie-breaker: earliest deadline wins; then alphabetical supplier.
5. Items with the same `supplier + type` collapse to the highest-scored one (dedup per scan).

## Non-surfaceable (never ranked)

- Signals with `status=Closed` or `status=Resolved`.
- Signals marked `defer_until=YYYY-MM-DD` where the date has not arrived.
- Kaia signals where `project_kaia_dependency` memory still holds (gate active) — drop to weight 0.3, do not cap at 0, so a truly urgent Kaia item can still surface.

## Overflow handling

For each item that does not fit:
- Write `[EVENT: DEFER original_type=X score=N reason=budget]` to `pending-signals.md` under `## Deferred`.
- No retry until the next brief run.
- After 5 consecutive defers without surfacing, auto-escalate: bump `type_weight` by 0.3 for that item's next score.

## Output contract

`/morning-brief` reads this procedure, scores, and returns:
- A ranked list per block (filling to cap).
- A `deferred_count` integer.
- A `total_score_mean` for drift monitoring (if mean drops week-over-week, André is getting less pressure or the filter is too tight — surface in weekly retro).
