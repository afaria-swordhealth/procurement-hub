---
description: Query devices in testing, present proposed score updates, flag eliminators.
model: sonnet
---

# Test Update

**Agents:** testing (primary)

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

## Safety Rules
- Follow CLAUDE.md Safety Rules and Writing Style sections.
- **Flag eliminators immediately**, do not wait for full review cycle.
- **SINGLE-DB SCOPE:** Only writes to Test Reviews DB (see config/databases.md, TEST_DB).

## Output Format
Table per device: Device | Tester | Category | Previous Score | Proposed Score | Notes
Eliminators flagged with bold warning at top of output.
