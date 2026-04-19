---
description: Query devices in testing, present proposed score updates, flag eliminators.
model: sonnet
---

# Test Update

**Agents:** testing (primary)

## Pre-flight

Read `.claude/knowledge/sample-testing-process.md` for Pulse tester role assignments (Pedro = BLE/SDK, Paulo = cosmetic, André = overall), eliminator criteria, and scoring system before querying test data.

Read `outputs/session-state.md`. Calculate age of Last-Warm-Up:
- If < 2h: use context snapshot. Do not re-read context files.
- If 2–8h: use snapshot as baseline. Run delta scan for this task.
- If > 8h or missing: warn André and recommend /warm-up before proceeding.

## Steps

1. Read config/databases.md for TEST_DB collection ID.
   Query Test Reviews DB for devices with status "In Testing":
   ```sql
   SELECT "Name", "Status", "Tester", "Score" FROM "{TEST_DB}"
   ```

2. For each device "In Testing", fetch the full page for current scores and notes.

3. Present proposed updates to André:
   - Updated scores per tester (Pedro = BLE/SDK, Paulo = cosmetic, André = overall)
   - Any new test results or observations
   - Flag eliminators immediately (critical failures that disqualify a device)

4. After André approves, update:
   - DB fields (scores, status)
   - Page body (test notes, observations)

5. Log each approved write to `outputs/change-log.md`. Concurrency: session-single model (see `.claude/safety.md`); no collision guard.

## Safety Rules
- Follow CLAUDE.md Safety Rules and Writing Style sections.
- **Flag eliminators immediately**, do not wait for full review cycle.
- **SINGLE-DB SCOPE:** Only writes to Test Reviews DB (see config/databases.md, TEST_DB).

## Output Format
Table per device: Device | Tester | Category | Previous Score | Proposed Score | Notes
Eliminators flagged with bold warning at top of output.
