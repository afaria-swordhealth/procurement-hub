# Procedure: Create or Update Open Item
# Reusable subroutine. Called by: /mail-scan, /warm-up, /log-sent, supplier-comms, notion-ops

Authoritative rules live in CLAUDE.md section `4c. Open Items Discipline`. This procedure is the operational how-to.

## DB location
- Open Items DB: `collection://505b7f08-8816-4bf7-b77a-7f232b52d0a0`
- Project relations (paste as URL):
  - Pulse: `https://www.notion.so/310b4a7d72078145962ee5a9c875dc0d`
  - Kaia: `https://www.notion.so/313b4a7d7207810ca19fda03a61f8057`
  - M-Band: `https://www.notion.so/311b4a7d720781674b2cd9f88167d04`

## Field checklist (every create must have all 8)
1. **Item** — `Supplier/Area — specific action`. Max ~70 chars. Verb or noun-action.
2. **Status** — `Pending` / `In Progress` / `Blocked` / `Closed`.
3. **Type** — `Action Item` / `Decision` / `Question` / `Blocker` / `Commitment`.
4. **Owner** — real name. Handoff: `André → Bradley / Legal`. Default = André.
5. **Deadline** — always present. Use `date:Deadline:start` (ISO YYYY-MM-DD) when calling create-pages.
6. **Project** — relation URL (mandatory).
7. **Context** — first entry must be assertive, self-contained (2-4 sentences). What, why it matters, what blocks, reference.
8. **Supplier** — exact match to the supplier's DB Name field (e.g. "Transtek", "Urion"). Required for supplier-based OI filtering in `/supplier-rejection` and cross-skill queries. Omit only for ISC-level OIs with no specific supplier (e.g. "M-Band — component risk review").

## Recommended OI triggers — propose to André before creating

These events typically require a new OI. When surfaced by a scan or action: query the DB for duplicates (see Before creating below), pre-fill all 8 required fields, and present the proposed OI to André for approval before writing to Notion. Do not auto-create.

| Event | OI Type | Default deadline |
|-------|---------|-----------------|
| Re-quote requested from a supplier | Action Item | Date given to supplier, or +14 days |
| RFQ sent to a new supplier | Action Item | +10 business days |
| Supplier commits to a date or deliverable in email | Action Item | Date they committed to |
| André commits to an action in a sent email | Action Item | Date committed, or next session |
| Internal decision pending from a named person (Jorge, Max, Kevin, Sofia, etc.) | Decision | +5 business days or meeting date |
| Blocker explicitly stated (supplier or internal) | Blocker | First realistic resolution date |
| Compliance / regulatory question raised (FDA, UDI, ISTA, NDA, SQA) | Question | +7 days or regulatory deadline |

**Critical rule:** a re-quote or follow-up tracked only as a context note is invisible to /cross-check Phase 5. If there is no OI, the system cannot auto-detect when the deadline passes or the event resolves. Propose the OI so André can approve it.

## Before creating
1. Query the DB for similar open items (same supplier + similar Item title). If found, UPDATE instead of create.
2. Verify Owner is a real person, not a role.
3. Verify Deadline is realistic given supplier lead times and working days.
4. Verify Project relation.

## Context as a Summary

Context holds a summarized current-state description of the OI. It is not a running log.

- Write in English, formal tone. One paragraph. No dated prefix.
- Capture: what the OI is, why it matters, current state, what blocks, who owns the next step.
- When a new update arrives, add it as a **Notion page comment** via `notion-create-comment`. Do NOT prepend it to Context.
- Rewrite Context only when the summary changes materially (owner changed, blocker cleared, scope shifted). Replace the whole paragraph — do not append.
- If you inherit an OI with a running-log Context (multiple dated prefixes, PT/EN mixed), summarize into one English paragraph.

### Example: first write
```
First production commit blocked until Pedro validates BLE SDK of Transtek BB2284-AE01. Initial order 5K units. Selected Apr 1 as primary BPM. Pedro assigned Apr 10. Testing in progress.
```

### Example: update with new info
Add as a Notion page comment on the OI via `notion-create-comment`. Do NOT touch Context:
```
[2026-04-15] BLE pairing stable, but data handoff drops under low-battery. Transtek firmware fix pending.
```

### Update with no new info
Do NOT edit Context. Log the touch in `outputs/change-log.md` only.

### Legacy OIs with running-log Context
If Context has multiple dated entries (old format), condense into one English summary paragraph. Comment history lives in Notion.

## Closing an OI
1. Set `Status = Closed`.
2. Fill `Resolution`: 1-2 sentences. What happened, who resolved, date, link if any.
3. Do NOT clear Context. Keep the history.

## Write permissions
- Create: auto-execute when triggered by /mail-scan, /warm-up, /log-sent after André approves the OI set.
- OI comment additions via `notion-create-comment`: auto-execute, no approval needed (auto-approved per CLAUDE.md §5 Exception 2).
- Context field rewrites (material changes only): SHOW BEFORE WRITE.
- Status changes to Closed: SHOW BEFORE WRITE.
- Owner/Deadline changes: SHOW BEFORE WRITE.

## Concurrency
Session-single model (see `.claude/safety.md`). No collision guard — only one Claude session is expected to be writing at any time.
