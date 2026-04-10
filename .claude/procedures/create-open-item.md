# Procedure: Create or Update Open Item
# Reusable subroutine. Called by: /mail-scan, /warm-up, /log-sent, supplier-comms, notion-ops

Authoritative rules live in CLAUDE.md section `4d. Open Items Discipline`. This procedure is the operational how-to.

## DB location
- Open Items DB: `collection://505b7f08-8816-4bf7-b77a-7f232b52d0a0`
- Project relations (paste as URL):
  - Pulse: `https://www.notion.so/310b4a7d72078145962ee5a9c875dc0d`
  - Kaia: `https://www.notion.so/313b4a7d7207810ca19fda03a61f8057`
  - M-Band: `https://www.notion.so/311b4a7d720781674b2cd9f88167d04`

## Field checklist (every create must have all 7)
1. **Item** — `Supplier/Area — specific action`. Max ~70 chars. Verb or noun-action.
2. **Status** — `Pending` / `In Progress` / `Blocked` / `Closed`.
3. **Type** — `Action Item` / `Decision` / `Question` / `Blocker`.
4. **Owner** — real name. Handoff: `André → Bradley / Legal`. Default = André.
5. **Deadline** — always present. Use `date:Deadline:start` (ISO YYYY-MM-DD) when calling create-pages.
6. **Project** — relation URL (mandatory).
7. **Context** — first entry must be assertive, self-contained (2-4 sentences). What, why it matters, what blocks, reference.

## Before creating
1. Query the DB for similar open items (same supplier + similar Item title). If found, UPDATE instead of create.
2. Verify Owner is a real person, not a role.
3. Verify Deadline is realistic given supplier lead times and working days.
4. Verify Project relation.

## Context as a running log
Context is append-only, prepend-latest.

### First write
```
First production commit blocked until Pedro validates BLE SDK of Transtek BB2284-AE01. Initial order 5,000 units. Selected Apr 1 as primary BPM. Pedro assigned Apr 10.
```

### Update 5 days later
```
**2026-04-15:** Pedro reports pairing stable but data handoff drops under low-battery. Waiting on Transtek firmware fix.

First production commit blocked until Pedro validates BLE SDK of Transtek BB2284-AE01. Initial order 5,000 units. Selected Apr 1 as primary BPM. Pedro assigned Apr 10.
```

### Another update
```
**2026-04-18:** Transtek sent firmware v1.03. Pedro re-testing.
**2026-04-15:** Pedro reports pairing stable but data handoff drops under low-battery. Waiting on Transtek firmware fix.

First production commit blocked until Pedro validates BLE SDK of Transtek BB2284-AE01. Initial order 5,000 units. Selected Apr 1 as primary BPM. Pedro assigned Apr 10.
```

### Update with no new info
Do NOT edit Context. Log the touch in `outputs/change-log.md` only.

### After ~8 entries
Collapse the oldest into a one-line origin summary at the bottom:
```
**Origin (Apr 10 - Apr 20):** Selected Apr 1. First 5K order. BLE validation + firmware iterations with Transtek.
```

## Closing an OI
1. Set `Status = Closed`.
2. Fill `Resolution`: 1-2 sentences. What happened, who resolved, date, link if any.
3. Do NOT clear Context. Keep the history.

## Write permissions
- Create: auto-execute when triggered by /mail-scan, /warm-up, /log-sent after André approves the OI set.
- Context updates (append new line): auto-execute, no approval needed (treated like outreach milestones).
- Status changes to Closed: SHOW BEFORE WRITE.
- Owner/Deadline changes: SHOW BEFORE WRITE.

## Collision guard
Before writing, check `outputs/change-log.md`. If another session touched this OI in the last 10 minutes, skip and log the conflict.
