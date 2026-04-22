---
name: "Morning Brief"
description: "Proactive daily filter. Reads pending-signals, OI DB, calendar, and recent DMs; applies attention-budget; surfaces a 4-block brief (Top 3 Decisions · Overdue · New Signals · Calendar). On-demand now; scheduled 07:30 once André approves Slack target. Replaces warm-up as the morning entry point on most days."
---

# Morning Brief

Proactive daily filter. System owns the clock. André sees a ranked shortlist, not a raw scan.

## Invocation

- **On-demand:** `/morning-brief` (any time). Default until scheduled.
- **Scheduled:** 07:30 local. Activated only after André confirms delivery target (Slack DM channel or self-DM). Until then, output goes to the chat.
- **Parameters:** `--dry-run` (score + rank only, no delivery) · `--force` (ignore same-day dedup guard).

## Pre-flight

1. Read `outputs/session-state.md`. If `Last-Morning-Brief` is today and not `--force` → exit with one line "already delivered today, use --force to re-run".
2. Read `outputs/pending-signals.md` (Pending + Deferred sections).
3. Read `.claude/procedures/attention-budget.md` (scoring + caps).
4. Read `.claude/config/databases.md` (OI DB ID, Supplier DB IDs).
5. Optional: read `outputs/promises.md` for parallel commitment view (until §4d retirement decision lands).

## Step 1: Gather signals

### 1a. OI DB — decisions due and overdue

```sql
SELECT Item, Type, Owner, Supplier,
       "date:Deadline:start" AS Deadline,
       Status,
       SUBSTR(Context, 1, 120) AS ContextPreview,
       id, url
FROM "collection://505b7f08-8816-4bf7-b77a-7f232b52d0a0"
WHERE Status IN ('Pending', 'In Progress', 'Blocked')
  AND Deadline <= date('now', '+7 days')
ORDER BY Deadline ASC
```

Drop OIs with `Owner` that is not André unless `Type=Blocker`.

### 1b. pending-signals.md — producer output

Parse every `[EVENT: ...]` line under `## Pending`. Fields: `TYPE`, `supplier`, `project`, `severity` (if RISK), `ts`, any custom keys.

Merge into the same signal pool as OIs. Each pending-signal becomes one candidate item.

### 1c. Calendar (next 24h)

Use `mcp__claude_ai_Google_Calendar__list_events` with `time_min=now`, `time_max=now+24h`. Include only events with attendees or location (skip personal blocks unless `Jorge 1:1`, `Sword All Hands`, `Weekly` prefix).

### 1d. Recent Slack DMs (optional, skip on MCP failure)

Read DMs from: Jorge Garcia, Miguel Pais, Sofia Lourenço, Pedro Rodrigues, Kevin Wang (per memory). Since `Last-Morning-Brief` or last 18h (whichever older). If a DM contains an unanswered message directed at André, append as a `[EVENT: DM_AWAITING_REPLY]` candidate.

## Step 2: Score and rank

Apply `attention-budget.md` scoring to every candidate from 1a + 1b + 1d. Calendar items (1c) are not scored — they go to the Calendar block as-is.

### 2a. Supplier pattern urgency multiplier

For each candidate naming a supplier, fetch pattern record per `.claude/procedures/supplier-pattern-store.md` §Consumers.2:
- `mcp__ruflo__memory_retrieve` key `supplier::{slug}::pattern`.
- Apply `×1.3` urgency multiplier (capped at attention-budget cap) when either: `response_rate_90d < 0.2`, OR (`last_chase_ts` > 7d ago AND `risk_flags` non-empty).
- If ruflo fails or record missing: skip multiplier for that candidate.

Fill blocks in order: Top 3 Decisions → Overdue → New Signals. Overflow to `## Deferred` with computed score.

Dedup: same `supplier + type` keeps highest score.

## Step 3: Compose brief

```
MORNING BRIEF — {YYYY-MM-DD}
Scanned: {n_oi} OIs, {n_signals} signals, {n_dms} DMs  |  Deferred: {deferred_count}

## Top 3 Decisions Today
1. [{Project}] {Item} — {supplier} · {deadline_delta} · Action: {next step}
2. ...
3. ...

## Overdue ({count})
- [{Project}] {Item} — {days_overdue}d overdue · {Owner} · {shortest-next-step}
- ...

## New Signals since last scan ({count})
- [{TYPE}] {supplier}/{project} — {one-line}
- ...

## Calendar (next 24h)
- {HH:MM} — {title} ({duration})
- ...

---
Deferred: {deferred_count} items (see outputs/pending-signals.md ## Deferred)
Mean score: {mean} (week drift: {trend})
```

Rules:
- Every line ≤90 chars. If longer, truncate with ellipsis.
- English only (per writing-style.md).
- No raw Notion IDs. Embed links as Slack `<URL|text>` if Slack delivery, else inline markdown `[text](url)`.
- If any block is empty, print `- (none)` not the block header alone.

## Step 4: Delivery

### 4a. Default — chat output
Print the composed brief directly. No Slack write.

### 4b. Slack DM (after approval)
When `config/morning-brief-target.md` exists and contains a non-empty `channel_id` line:
- Use `mcp__claude_ai_Slack__slack_send_message` with the configured channel.
- Fallback to chat output on any Slack MCP failure. Log to change-log as `[EVENT: FAIL target=slack_morning_brief skill=morning-brief]`.

### 4c. Log delivery
Append one line to `outputs/change-log.md`:
```
[EVENT: SKILL_RUN skill=morning-brief status=delivered decisions=3 overdue={n} signals={n} deferred={n}]
Brief delivered via {chat|slack}.
```

## Step 5: Update pending-signals.md

For each signal surfaced (not deferred):
- Move from `## Pending` to `## Consumed` with timestamp.

For each deferred signal:
- Move to `## Deferred` with computed score.

For signals that have been in Deferred for 5+ scans without surfacing:
- Bump `type_weight` by +0.3 on next run (track via `defer_count=N` key).

Atomic rewrite: read → transform → write to tmp → rename.

## Step 6: Update session-state

Set `Last-Morning-Brief: {ISO_timestamp}` under `## Timestamps` in `outputs/session-state.md`. If the key doesn't exist, append it.

## Rules

- **Read-only for Notion.** No Notion writes.
- **No Gmail drafts.** The brief surfaces actions; André still triggers drafts via other skills.
- **Attention budget is hard.** Never exceed the cap by "just one more." That's how the filter rots.
- **Same-day dedup.** Re-runs without `--force` exit early. Prevents accidental duplicate Slack posts.
- **MCP partial failure is tolerated.** Calendar down → skip block with `(calendar unavailable)` note. Slack DM scan down → skip 1d. Notion down → HALT (can't brief without OIs).
- **Kaia de-prioritization is automatic** via `attention-budget.md` project_weight, not logic here.
- **Sofia / Jorge DM detection** still uses PT per `feedback_sofia_portuguese` / `feedback_jorge_portuguese` memories — the brief surfaces the fact, any reply André drafts follows the usual PT rule.

## Not this skill's job

- Raising OIs (that's `create-open-item.md`).
- Writing Notion updates (that's the relevant domain skill).
- Replacing `/weekly-pulse` (weekly roll-up, different cadence — per improvement-plan.md EVALUATE #1).
- Replacing `/project-dashboard` (deep dive, per EVALUATE #2).
- Deciding which signals matter — that's `attention-budget.md`'s job; this skill executes.

## Ship-ready state

| Piece | Status |
|---|---|
| pending-signals.md scaffold | ✅ shipped |
| attention-budget.md procedure | ✅ shipped |
| morning-brief skill | ✅ shipped |
| risk-radar as producer | ✅ shipped |
| Slack DM target | ✅ shipped — config/morning-brief-target.md (channel_id: U03BKAV990S) |
| 07:30 cron | ✅ shipped — weekdays 07:32, job f2b24a98 (session-scoped, re-register at warm-up) |
| `/mail-scan` cron re-route to morning-brief | ⚠️ deferred (see improvement-plan.md EVALUATE #5) |
| promises.md retirement | ⚠️ deferred (see improvement-plan.md EVALUATE #3) |
