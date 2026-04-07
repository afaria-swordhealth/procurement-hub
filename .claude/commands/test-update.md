---
description: Query devices in testing, present proposed score updates, flag eliminators.
---

# Test Update

**Agents:** testing (primary)

## Steps

1. Query Test Reviews DB for devices with status "In Testing":
   ```sql
   SELECT "Name", "Status", "Tester", "Score" FROM "collection://911b7778-b80b-4e94-a5c4-9f8853934d2e"
   ```

2. For each device "In Testing", fetch the full page for current scores and notes.

3. Present proposed updates to André:
   - Updated scores per tester (Pedro = BLE/SDK, Paulo = cosmetic, André = overall)
   - Any new test results or observations
   - Flag eliminators immediately (critical failures that disqualify a device)

4. After André approves, update:
   - DB fields (scores, status)
   - Page body (test notes, observations)

## Safety Rules
- **SHOW BEFORE WRITE:** Present all proposed updates before executing.
- **Flag eliminators immediately** — do not wait for full review cycle.
- **SINGLE-DB SCOPE:** Only writes to Test Reviews DB (collection://911b7778-b80b-4e94-a5c4-9f8853934d2e).
- **ALL NOTION CONTENT IN ENGLISH.**
- **NO EM DASHES.**
- Log changes to outputs/change-log.md after write.

## Output Format
Table per device: Device | Tester | Category | Previous Score | Proposed Score | Notes
Eliminators flagged with bold warning at top of output.
