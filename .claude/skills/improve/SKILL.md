---
name: "Improve"
description: "Session C improvement session. Scans change-log, session-state, and promises for friction signals. Classifies each by level (micro/mini/structural), presents a ranked queue, and executes with the appropriate methodology."
---

# Improve

Identifies system friction signals from operational session output, classifies them by effort level, and executes improvements in priority order. Always surfaces multiple signals — never picks one and goes.

## Pre-flight

### Concurrency guard (abort-on-conflict)

Session C must not race Session A (interactive operator) on shared files. Check in order:

1. **Scheduled-task lock.** If `.claude/scheduled_tasks.lock` exists AND its mtime is < 5 min old AND belongs to a different `/improve` invocation, abort with: `another /improve run active, skipping`. If lock is > 5 min stale, log a warning to change-log and proceed (treat as crashed prior run).
2. **Active Session A.** Read `outputs/session-state.md` `## Active Sessions`. If "Session A (Operational)" was started within the last 30 min AND `outputs/session-state.md` mtime is within the last 10 min, abort with: `Session A active (interactive), deferring /improve to next fire`. Append one line to `outputs/friction-signals.md` `## Pending`: `[EVENT: IMPROVE_DEFERRED reason=session_a_active ts={now}]`.
3. **Uncommitted working tree on shared files.** Run `git status --short -- outputs/ context/ .claude/`. If any file is modified (`M ` or `MM`) and was not touched by this invocation, abort with: `uncommitted Session A delta on {files}, skipping to avoid overwrite`. Same deferral log as #2.
4. **scheduled_tasks.lock write.** If all checks pass, touch `.claude/scheduled_tasks.lock` with this invocation's PID/timestamp. Explicit cleanup happens in Step 6 — do not rely on best-effort removal here.

If aborted: exit cleanly. Next cron fire retries. No alert to André — this is expected and benign.

### Read inputs

1. Read `outputs/session-state.md` for context and Carry-Over section.
2. Read `outputs/change-log.md` for today's operational signals.
3. Read `outputs/promises.md` for recurring or overdue promises.
4. Read `outputs/friction-signals.md` `## Pending` section — accumulated signals from prior sessions.
5. Read `outputs/autonomy-ledger.md` for promotion-candidate detection (see Source F).
6. Read `outputs/improvement-plan.md` §11 (T2/T3/T4 backlog) for ready-to-execute items (see Source G).
6b. Read first 5 lines of `outputs/layer-health.md` for `Last-Check:` date — monthly health gate (see Source H).
7. **Session C scope.** Do NOT write to Notion, Gmail, or `context/` files.

## Step 1: Scan for friction signals

Scan all sources. Collect every signal found — do not filter yet.

### Source A — change-log.md
Parse today's entries for:
- `fallback` — a DB-first path fell back to a slower method
- `SHOW BEFORE WRITE` or `needs your decision` — approval gate fired on a mechanical operation
- `skip` / `skipped` — step bypassed unexpectedly
- `failed` / `retry` / `error` — execution failure or partial run
- `flag` — something flagged but no fix applied
- Same supplier or skill appearing 3+ times in one day

### Source B — session-state.md (Carry-Over + Pending Actions)
- Items in Carry-Over that have appeared across multiple sessions (recurring, not resolved)
- Pending Actions marked overdue or stale
- Blockers that haven't moved in 3+ days

### Source C — promises.md
- **Skip if file header contains `DEPRECATED`** — promises.md was retired 2026-04-23; all entries migrated to OI DB. Source C is a no-op until a replacement tracker is live.
- Otherwise: unchecked `- [ ]` entries where `due:` is past today AND the promise is more than 3 days old (pattern, not one-off miss)

### Source D — cross-session pattern
If change-log is empty or thin (improvement session without prior operational session today):
- Read last 3 commit messages via `git log --oneline -5` for recent fix themes
- Check if the same file or skill appears in multiple recent commits (systemic churn)

### Source E — friction-signals.md (accumulated pending)
Read `## Pending` in `outputs/friction-signals.md`. Each `- [ ]` entry is a signal from a prior session that was identified but not executed. Add all to the current queue. De-duplicate against signals already found in Sources A-D (same file + same description = same signal).

### Source F — autonomy-ledger.md (promotion candidates)
Read `outputs/autonomy-ledger.md` `## Entries`. Group entries by `action_class`. For each class, apply the promotion rule from `.claude/autonomy.md`:

- 20 consecutive `approved_clean` AND
- Zero `rejected` in last 50 AND
- Zero `approved_edited` in last 20 AND
- Class `tier` is not `irreversible` (check ledger entries or `procedures/ledger-append.md` Tier column — `irreversible` classes never promote regardless of streak).

Each eligible class becomes one signal in the queue, tier `structural` (creating a new auto-approval touches `safety.md` + affected skills). Surface format:

```
Autonomy candidate: {action_class}
  Evidence: {N} clean approvals since {date}, 0 rejections in last 50, 0 edits in last 20.
  Skills affected: {list}
  Proposed Exception text: {draft}
```

Also surface classes that have hit threshold 3+ times but keep getting rejected at review — propose `never_promote` tag for monthly pass.

Never auto-append to `safety.md`. André must explicitly accept each promotion.

**Monthly calibration pass:** Read the `<!-- Last-Calibration:` line from the `outputs/autonomy-ledger.md` header. If the value is `null` or ≥ 30 days before today: for each `action_class` with ≥ 5 ledger entries, compute (a) approval rate = `approved_clean` / total entries for that class, (b) current consecutive `approved_clean` streak, (c) entries still needed = max(0, 20 − streak). Surface as a signal: `Calibration — {class}: {N} entries, {rate:.0%} clean, {needed} more to threshold (~{weeks:.0f}w at current pace).` Then update the ledger header line to `<!-- Last-Calibration: {today} -->`. If < 30 days ago: skip calibration entirely.

### Source G — improvement-plan.md §11 (ready backlog)

Read `outputs/improvement-plan.md` §11. Surface items in this priority order:

1. **T4 items** — always surface. These are micro-fixes with no stated dependencies. Surface all of them.
2. **T2 items** — surface if: (a) the item's Notes column has no explicit gating note (e.g., "blocked on X", "requires Y first"), AND (b) the item appears in today's session (Sources A–F produced nothing, or this item is directly relevant to a signal found).
3. **T3 items** — surface only if the autonomy ledger (Source F) has ≥20 entries for the relevant `action_class`. T3-3 is explicitly gated on ledger data — do not surface it before that threshold. T3-1, T3-2, T3-4, T3-5 have no stated dependency but are structural sprints — surface at most one per session.

**Do not surface T2/T3 items** just to fill a thin queue. Only surface them when genuinely ready or when Sources A–F have no signals.

Surface format (same as other sources):

```
improvement-plan.md §11 backlog — T4 ready items:
- T4-1: [description] — micro
- T4-2: [description] — micro
...
```

De-duplicate against signals already found in Sources A–F.

### Source H — Monthly layer health check

Read first 5 lines of `outputs/layer-health.md`. Parse `Last-Check:` line:

- If `Last-Check: null` or the date is ≥ 30 days before today: surface one signal — "Layer health check due — last run: {date or 'never'}". Tier: mini.
- If the date is < 30 days ago: skip Source H entirely.

**When the signal is executed (mini-sprint):**
1. For each assertion in `outputs/layer-health.md`: run FILE_CHECK via Glob (file exists?), LINE_COUNT via `wc -l`, CONTENT_CHECK via Grep (pattern present?), or ABSENT_CHECK via Glob (file must not exist). Record HEALTHY, WARN, or MISSING for each.
2. For any WARN or MISSING: scan `outputs/friction-signals.md` `## Resolved` for a prior fix of the same file. If found → flag `[REGRESSION]` and apply tier escalation per Step 2.
3. Update `outputs/layer-health.md`: set `Last-Check:` to today, `Next-Due:` to today+30d. Append a row to `## History`: `| {date} | {WARN/REGRESSED layers or "none"} | {missing files or "none"} | {notes} |`.
4. Surface all WARN/MISSING/REGRESSION signals into `## Pending` of `outputs/friction-signals.md` (standard signal format from Step 6).
5. Commit `outputs/layer-health.md` with message: `"Layer health check {date}: {N} layers HEALTHY, {M} WARN/REGRESSED"`.

De-duplicate against signals already found in Sources A–G.

## Step 1.5: Regression check

After collecting all signals from Sources A–G, before classifying:

For each new signal where a file is identifiable:
1. Scan `outputs/friction-signals.md` `## Resolved` for entries where `fixed in {file}` matches the affected file.
2. If a resolved entry is found with a similar symptom (2+ overlapping keywords in the description): flag the new signal as `[REGRESSION]`. Note the prior-fix date from the resolved entry.

For signals without a clear file reference: match on 3+ consecutive keywords in the description against the Resolved section.

A regression means the prior fix didn't hold — the root cause is systemic. Surface format:
```
[REGRESSION] {signal description}
  Prior fix: {resolved entry date} in {file}
  Implication: root cause was not fully addressed — escalate tier.
```

If no match in Resolved: signal is new, proceed normally.

## Step 2: Classify each signal

For each signal:

| Criterion | Micro-fix | Mini-sprint | Structural sprint |
|-----------|-----------|-------------|-------------------|
| Files affected | 1 | 2-4 | 5+ or unknown |
| Cause | Obvious | Probable | Unclear |
| Frequency | First | 2-3 times | 4+ times or systemic |
| Estimated fix | < 30 min | 45-60 min | 2-3h |
| Agents needed | 0 | 3-5 | 10 |

When in doubt between two levels: default to the lower level and note it.

**Regression escalation:** `[REGRESSION]`-flagged signals always escalate one tier (micro → mini, mini → structural). The first fix addressed symptoms; re-emergence means the root cause needs analysis.

## Step 3: Build improvement queue

Rank by: severity (blocking > degrading > cosmetic) × frequency (recurring > occasional > one-off). **`[REGRESSION]`-flagged signals sort to the top of the queue at severity = blocking, regardless of their independent impact assessment.** A recurrence means the system's own memory failed — that is always higher priority than a new first-occurrence signal.

Present the full queue — never pre-select one:

```
IMPROVEMENT QUEUE — [date]

| # | Signal | Source | Level | Est. | Notes |
|---|--------|--------|-------|------|-------|
| 1 | [description] | change-log / session-state / promises / git | micro / mini / structural | [time] | [why this rank] |
| 2 | ...
```

Do NOT start executing. Present queue first.

## Step 4: Confirm execution order

"Executo por esta ordem? Ou reordenas?"

André may:
- "siga" → execute in queue order, one at a time
- Reorder: "começa pelo #3"
- Exclude: "salta o #2"
- Downgrade: "o #1 é micro, não estrutural"
- Merge: "o #2 e #3 são o mesmo problema"

## Step 5: Execute

One signal at a time. Finish + commit before starting the next.

### Micro-fix
1. Identify the exact file and change.
2. Edit directly. No agents.
3. Log to `outputs/change-log.md`.
4. Commit: `Micro-fix: [one-line description]`.
5. Remove the signal from `## Pending` in `friction-signals.md`. Append to `## Resolved`: `- [x] [{original_date} → {today}] {description} — micro — fixed in {file}`. If `[REGRESSION]`-flagged, append `[REGRESSION prior: {prior_fix_date}]` at the end of the entry so the recurrence chain is traceable.
6. **If signal came from Source G:** remove its row (or bullet) from `outputs/improvement-plan.md` §11 so it is not re-surfaced next session.

### Mini-sprint
1. Launch 3-5 parallel Explore agents, each analyzing one dimension.
2. Synthesize findings.
3. Present implementation plan to André (1 confirmation before writing).
4. Implement (2-4 files). Log + commit.
5. Remove executed signals from `## Pending` in `friction-signals.md`. Append each to `## Resolved`: `- [x] [{original_date} → {today}] {description} — mini — fixed in {files}`. If `[REGRESSION]`-flagged, append `[REGRESSION prior: {prior_fix_date}]`.
6. **If signal came from Source G:** remove its row (or bullet) from `outputs/improvement-plan.md` §11.

### Structural sprint
1. Launch 10 parallel Explore agents across 5 lenses (per milestone methodology in memory).
2. Synthesize → consensus table → present to André for approval.
3. Implement after approval. Verify. Log + commit.
4. Remove executed signals from `## Pending` in `friction-signals.md`. Append each to `## Resolved`: `- [x] [{original_date} → {today}] {description} — structural — fixed in {files}`.
5. **If signal came from Source G:** remove its row (or bullet) from `outputs/improvement-plan.md` §11.

## Step 6: Persist unexecuted signals

After execution is complete (or André ends the session early):

For each signal in the queue that was NOT executed: append to `## Pending` in `outputs/friction-signals.md`:
```
- [ ] [{today}] {skill/file}: {signal description} — {tier}
```

Do not append signals that are already in `## Pending` (de-duplicate by description). Log the append to `outputs/change-log.md`.

**Final cleanup:** Delete `.claude/scheduled_tasks.lock` (Bash: `rm .claude/scheduled_tasks.lock`). This is the definitive concurrency-guard release. Run this even if the session was interrupted mid-queue — a stale lock on next fire is handled by pre-flight #1, but an explicit delete here prevents unnecessary warnings.

## Rules

- **Session C only:** write to `.claude/` files, `outputs/change-log.md`, `outputs/friction-signals.md`, `outputs/improvement-plan.md`, and `outputs/layer-health.md`. Never touch Notion, Gmail, `context/` files, or `session-state.md`.
- **Always surface multiple signals.** Never pick one without showing the full queue first.
- One signal at a time. Commit after each before starting the next.
- If change-log is empty, lean on session-state Carry-Over + git log.
- Log every change to `outputs/change-log.md` before committing.
- If a structural sprint is needed but the signal is unclear, launch discovery agents first — do not implement without understanding the root cause.
