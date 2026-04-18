---
name: "Improve"
description: "Session C improvement session. Scans change-log, session-state, and promises for friction signals. Classifies each by level (micro/mini/structural), presents a ranked queue, and executes with the appropriate methodology."
---

# Improve

Identifies system friction signals from operational session output, classifies them by effort level, and executes improvements in priority order. Always surfaces multiple signals — never picks one and goes.

## Pre-flight

1. Read `outputs/session-state.md` for context and Carry-Over section.
2. Read `outputs/change-log.md` for today's operational signals.
3. Read `outputs/promises.md` for recurring or overdue promises.
4. **Session C scope.** Do NOT write to Notion, Gmail, or `context/` files.

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
- Unchecked `- [ ]` entries where `due:` is past today AND the promise is more than 3 days old (pattern, not one-off miss)

### Source D — cross-session pattern
If change-log is empty or thin (improvement session without prior operational session today):
- Read last 3 commit messages via `git log --oneline -5` for recent fix themes
- Check if the same file or skill appears in multiple recent commits (systemic churn)

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

## Step 3: Build improvement queue

Rank by: severity (blocking > degrading > cosmetic) × frequency (recurring > occasional > one-off).

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

### Mini-sprint
1. Launch 3-5 parallel Explore agents, each analyzing one dimension.
2. Synthesize findings.
3. Present implementation plan to André (1 confirmation before writing).
4. Implement (2-4 files). Log + commit.

### Structural sprint
1. Launch 10 parallel Explore agents across 5 lenses (per milestone methodology in memory).
2. Synthesize → consensus table → present to André for approval.
3. Implement after approval. Verify. Log + commit.

## Rules

- **Session C only:** write to `.claude/` files and `outputs/change-log.md`. Never touch Notion, Gmail, `context/` files, or `session-state.md`.
- **Always surface multiple signals.** Never pick one without showing the full queue first.
- One signal at a time. Commit after each before starting the next.
- If change-log is empty, lean on session-state Carry-Over + git log.
- Log every change to `outputs/change-log.md` before committing.
- If a structural sprint is needed but the signal is unclear, launch discovery agents first — do not implement without understanding the root cause.
