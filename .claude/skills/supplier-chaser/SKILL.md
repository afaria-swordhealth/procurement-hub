---
name: "Supplier Chaser"
description: "Scan overdue items and draft follow-up emails for unresponsive suppliers or internal stakeholders. Use when OIs are past deadline, promises are overdue, or suppliers haven't replied within expected timeframes."
---

# Supplier Chaser

Scans all overdue commitments (Open Items DB + promises.md), cross-references Gmail for last contact, and drafts follow-up emails with the right tone and urgency.

## Pre-flight

1. Read `outputs/session-state.md` for freshness. If warm-up < 2h, use snapshot.
2. Read `.claude/config/writing-style.md` (tone rules, templates).
3. Read `.claude/config/strategy.md` (never reveal prices, timelines, or shortlist status).
4. Read `.claude/config/domains.md` (supplier contacts and email addresses).
5. Read `outputs/promises.md` for open commitments.
6. **Lessons read:** per `.claude/procedures/lessons-read.md`, read `.claude/skills/supplier-chaser/lessons.md` (top 10). Apply before composing drafts. If missing or empty, skip.

## Step 1: Collect overdue items

### From Open Items DB

```sql
SELECT Item, Owner, Status, "date:Deadline:start" AS Deadline,
       SUBSTR(Context, 1, 200) AS ContextPreview
FROM "collection://505b7f08-8816-4bf7-b77a-7f232b52d0a0"
WHERE Status IN ('Pending', 'In Progress', 'Blocked')
  AND "date:Deadline:start" < date('now')
ORDER BY Deadline ASC
```

### From promises.md

Parse all unchecked `- [ ]` entries. Flag any where `due:` date is past today.

### From session-state.md

Check Carry-Over and Pending Actions sections for items marked "overdue" or "waiting".

## Step 2: Check Gmail for last contact

For each overdue item linked to a supplier or person:

1. **(M4) DB-first check:** Query the supplier's `Last Outreach Date` DB field:
   ```sql
   SELECT "date:Last Outreach Date:start" AS last_outreach
   FROM "{SUPPLIER_DB}" WHERE Name LIKE '%{supplier_name}%'
   ```
   - If `last_outreach IS NOT NULL`: use this as "last sent" date. Days since = `CAST(julianday('now') - julianday(last_outreach) AS INTEGER)`. Scan Gmail for **inbound direction only** (`direction: "incoming"`) in step 2.
   - If `last_outreach IS NULL`: fall back to full Gmail scan (`direction: "both"`) in step 2. **(B4 surfacing)** collect this supplier's name into a session-scoped `null_lod_suppliers` list. Do not log per-supplier here.
   - If Notion MCP fails: treat as `last_outreach IS NULL` — fall back to Gmail scan. If Gmail MCP also fails: skip this supplier and mark as `[MCP ERROR — skipped]` in the chase table.

   **(B4 consolidated log)** After Step 2 completes for every overdue item, if `null_lod_suppliers` is non-empty, emit exactly one line into the chase-table preamble: `[M4 fallback: Last Outreach Date null for N suppliers: <comma-separated list>] — will self-correct on next outreach write.` Single line per session, not per supplier.

2. Use `scan-gmail.md` (direction per step 1, date_range: 14) to find last received email (and last sent if DB field is null).
3. Calculate days since last exchange.
4. Classify:
   - **No reply (they owe us):** Last email was FROM us. They haven't responded.
   - **No action (we owe them):** Last email was FROM them. We haven't responded.
   - **Stale (no contact):** No email exchange in 7+ days from either side.

## Step 3: Prioritize

Sort by chase urgency:

| Priority | Criteria | Action |
|---|---|---|
| **P1 Critical** | Blocker status, or >7 days overdue, or blocks other work | Chase immediately, consider escalation |
| **P2 High** | 4-7 days overdue, active project dependency | Chase today |
| **P3 Normal** | 1-3 days overdue, routine follow-up | Chase, gentle tone |
| **P4 Watch** | Due today or tomorrow, not yet overdue | Flag only, no chase yet |

## Step 4: Draft follow-up emails

### 4a: Read supplier pattern record

Per `.claude/procedures/supplier-pattern-store.md`, call `mcp__ruflo__memory_retrieve` for each supplier:
- `key`: `supplier::{supplier_slug}::pattern`
- `namespace`: "procurement"

If a record is returned, apply the Consumer rules in supplier-pattern-store.md §Consumers.1:
- `response_rate_90d < 0.3` AND `chase_count_90d ≥ 3` → escalate tone tier by +1 (capped at Tier 3 — fourth miss is a human escalation decision, not a fourth draft).
- `last_chase_tier_that_worked` set → prefer that tier over default logic.
- `avg_response_days` set → treat supplier as "not yet overdue" until `last_chase_ts + 1.5 × avg_response_days`; skip chase if within the window.
- `language` set → override default language inference.

If no record or ruflo MCP fails: fall back to default tone tier logic below. Log `[EVENT: FAIL target=supplier_pattern supplier={slug}]` to change-log and proceed.

### 4b: Signal-triggered cadence

Before drafting, compute the supplier's send window. This layer suppresses or shifts chases that would land in a low-response-probability slot.

**Timezone map** (derived from `.claude/config/domains.md` region field, with pattern-record override if present):

| Supplier region | Business hours (local) | André's action window (UTC+1 WEST) | Weekend rule |
|---|---|---|---|
| CN | 09:00–18:00 CST (UTC+8) | Draft created any time; **send window 01:00–10:00 WEST** so it lands 09:00–18:00 CST | Never send Sat/Sun local (CN Mon–Fri only). Never send on mainland-China public holidays if known. |
| EU / PT | 09:00–18:00 local | 09:00–18:00 WEST | No send Sat/Sun local. |
| US East | 09:00–17:00 EDT (UTC−4) | 14:00–22:00 WEST | No send Sat/Sun local. |
| US West | 09:00–17:00 PDT (UTC−7) | 17:00–01:00 WEST (next day) | No send Sat/Sun local. |
| DE (Nimbl, Helmut Schmid) | 09:00–18:00 CEST | 08:00–17:00 WEST | No send Sat/Sun local. |
| Internal (Jorge, Sofia PT) | Porto business hours | 09:00–18:00 WEST | Never Sat/Sun. |

**Rules applied at Step 6 execution time** (drafts may still be prepared and queued outside the window):

1. **CN suppliers, Sat/Sun local:** suppress send. Defer to Monday 01:00 WEST (09:00 CST). Flag `[DEFERRED: CN weekend]` in the chase table.
2. **PT suppliers, first send of the day before 09:00 WEST:** hold until 09:00 WEST. Morning-arrival matters in Porto (memory: steady-gentle-pressure; a 06:30 email reads as pushy, a 09:15 email reads as professional).
3. **CN supplier, current WEST time outside 01:00–10:00:** queue for the next window. If André approves in the afternoon, draft is created but not auto-sent. (Gmail draft creation is already the only write — no auto-send exists. This rule is advisory: mark the draft `[SEND AFTER: 01:00 WEST tomorrow]` so André opens and sends within the window.)
4. **Supplier timezone unknown:** default to PT rules (safe: business-hours send from André's clock).

**Gmail signal-triggered modifiers** (optional — applied when `mcp__claude_ai_Gmail__get_thread` can retrieve read receipts or recent inbound activity):

1. **Supplier opened the prior outreach <24h ago but did not reply:** skip chase. They are processing. Flag `[DEFERRED: recent-open]` with the open timestamp. Re-evaluate tomorrow.
2. **Supplier sent any email to André in the last 48h (even on another topic):** downgrade tone tier by −1 (Tier 3 → Tier 2, Tier 2 → Tier 1). They are engaged; don't escalate.
3. **Supplier inbox has an auto-reply / OOO indicator:** defer chase until the OOO end-date + 1 business day. Flag `[DEFERRED: OOO until {date}]`.

If Gmail `get_thread` fails or read-receipt data is unavailable: skip these modifiers silently. This is an optimiser, not a gate.

**Output of Step 4b:** per chase row, a computed `send_window` and optional `defer_reason`. Feed into Step 5 presentation:

| # | Supplier | Tone tier | Send window | Defer reason |
|---|---|---|---|---|
| 3 | Ribermold | Tier 2 | 09:00–18:00 WEST | — |
| 4 | Lihua (Jessica) | Tier 1 | 01:00–10:00 WEST | — |
| 5 | GAOYI | Tier 1 | — | DEFERRED: CN weekend → Monday 01:00 |

Draft creation still happens for deferred rows (André can open and send when the window opens). Only the `[AUTO]` path is suppressed for deferred rows — never auto-create a draft that would ship outside the send window.

For each P1-P3 item, draft a follow-up email. Apply these rules:

### Chase tone tiers

**Tier 1 — Gentle nudge (1-3 days overdue, first chase)**
- Frame: "Following up on..." or "Just wanted to check in on..."
- Keep short. Restate what's needed in one sentence.
- No urgency language.
- **Auto-create condition:** Gmail draft is created without a SHOW BEFORE WRITE gate if ALL are true: chase number = 1, days overdue ≤ 5, exactly one email address for this supplier in `config/domains.md`, language matches supplier region, supplier status is not `Quote Received` or `Shortlisted` (active commercial exchange — route to review). Present as `[AUTO]` in the chase table with draft body shown as informational. Type `skip #N` to hold a specific auto item before execution.

**Tier 2 — Direct follow-up (4-7 days, or second chase)**
- Frame: "I wanted to follow up on [specific item] from [date]."
- Restate what's needed clearly. Include the original context.
- Add a soft deadline: "Could you share an update by [date]?"

**Tier 3 — Firm (7+ days, or third chase)**
- Frame: "I'm reaching out again regarding [item], originally due [date]."
- Be specific about what's blocking: "This is currently holding up [X]."
- Propose alternative: "If [original ask] isn't feasible, could you suggest an alternative timeline?"
- For internal: consider escalation path (CC manager, raise in 1:1).

### Language rules

| Audience | Language | Chase style |
|---|---|---|
| CN suppliers | Simple English, numbered questions | Direct, polite, structured |
| PT suppliers | Portuguese | "Bom dia [Name], queria dar seguimento a..." |
| US suppliers | Standard English | Professional, direct |
| Internal (Jorge, Sofia) | Portuguese | Casual, Slack-first |
| Internal (others) | English | Casual, Slack-first |

### Strategy guardrails (from config/strategy.md)

- Never reveal internal timelines or decision status.
- Never indicate urgency that implies desperation.
- Never mention other suppliers or competitive pressure.
- Frame follow-ups as routine process, not pressure.
- Maintain steady, gentle pressure (memory: feedback_supplier_pressure.md).

## Step 5: Present to André

Show a single table. Mark Tier 1 items meeting auto-create conditions as `[AUTO]` in the Action column — these will execute immediately after presentation. All others are `[Review]` and wait for approval. Deferred rows (Step 4b) surface their `defer_reason` in place of a send window and are never auto-created.

```
CHASE QUEUE — Apr DD

| # | Priority | Supplier/Person | Item | Days Overdue | Last Contact | Action |
|---|----------|----------------|------|-------------|-------------|--------|
| 1 | P1       | Ribermold      | Mold quote | 12d | Sent Apr 6 | [Review] Draft below |
| 2 | P3       | SHX Watch      | Pulse RFQ | 3d | Sent Apr 15 | [AUTO] Draft below |
```

Type `skip #N` to hold a specific [AUTO] item before it executes.

Then, for each item with a draft:

```
### #1 — Sonia Sousa (Avnet)
**Channel:** Email (sonia.sousa@avnet.com)
**Tone tier:** 2 (4-7d overdue, direct)
**Subject:** RE: [original thread subject]
*(Note: Gmail draft will appear as a standalone email, not a threaded reply. André must open the draft in Gmail and reply within the original thread manually.)*

[Draft body]

---
```

## Step 6: Execute chasers

### 6a: PII pre-check

Before creating any Gmail draft ([AUTO] or reviewed), run the PII pre-check per `.claude/procedures/aidefence-precheck.md`:
- Clean / fail-open → proceed.
- PII detected (not a known false positive) → STOP and surface to André. Do not create the draft.

### 6b: Create drafts

For **[AUTO] items** (Tier 1, all conditions met, PII clean): create Gmail drafts immediately after Step 5 presentation without waiting for approval. Output confirmation line per item: `Auto-created draft: [Supplier] — [subject] (Tier 1, chase 1, [N]d overdue)`.

For all other items: after André approves (may edit drafts):

1. Create Gmail drafts for approved email chasers (HTML format, append signature).
2. For Slack chasers, present the message text for André to send manually.
3. Concurrency: session-single model (see `.claude/safety.md`). No per-write collision check before the Notion comment write.
4. Add a Notion page comment on the OI via notion-create-comment: `Follow-up sent [channel] [date]. [Brief note].`
5. Add to `outputs/promises.md`: extract soft deadline from the draft body (pattern: "by YYYY-MM-DD" or similar date phrase). If none found, use today + 7 days. Append entry:
   `- [ ] {Supplier contact} ({Company}) | Reply to {item} chase | promised: {today} | due: {soft_deadline} | next: waiting on supplier reply | OI: {oi_id or —} | source: supplier-chaser {[AUTO] or [Review]} Tier {N}`
   If an existing open promise already tracks this item (same supplier + same OI), update its `next:` and `due:` fields instead of adding a duplicate.
6. Log all actions to `outputs/change-log.md`.
6. Store chase outcome in ruflo memory via `mcp__ruflo__memory_store`:
   - `key`: "chase::[supplier_name]::[YYYY-MM-DD]"
   - `namespace`: "procurement"
   - `upsert`: true
   - `tags`: ["chase", project_name, supplier_name]
   - `value`: `{ supplier, tone_tier, channel, days_overdue, item, outcome: "sent", response_received: false, days_to_reply: null }` — update `response_received: true, days_to_reply: N` if a reply arrives

7. **Update supplier pattern record** per `.claude/procedures/supplier-pattern-store.md` §Producers.1:
   - Read existing `supplier::{slug}::pattern` record (or start fresh if missing).
   - Update `last_chase_ts`, `chase_count_90d` (increment; reset if `last_updated > 90d`), `language`, `channel_preference`.
   - `mcp__ruflo__memory_store` upsert.
   - If ruflo fails, log `[EVENT: FAIL target=supplier_pattern supplier={slug}]` and proceed — pattern update is audit-only, not a gate.

8. **(M4)** Update the supplier's `Last Outreach Date` DB field to today via `notion-update-page`. Applies to all chase tiers, including [AUTO] items. If the field does not exist yet (not yet added via Notion UI), skip silently. If update fails, log to change-log and proceed.

## Rules

- NEVER send emails. Gmail drafts only (Level 1 safety).
- SHOW BEFORE WRITE for Gmail draft creation, except Tier 1 drafts meeting auto-create conditions (chase 1, ≤5d overdue, one unambiguous email address, language matches region) — those create immediately after presentation. OI comments via notion-create-comment are auto-approved (per CLAUDE.md §5 Exception 2) — write them directly after draft creation, no separate confirmation needed.
- Do not chase suppliers in Rejected status.
- Do not chase items where Owner is not André (flag for André to decide).
- If an item has been chased 3+ times with no response, recommend escalation path instead of another chase.
- Writing conventions (sign-off): see `.claude/config/writing-style.md`.
- **MCP error handling — batch:** This skill loops over multiple suppliers and OIs. If Notion or Gmail MCP fails for one item: skip it, log `[item] — MCP error, skipped` to change-log, and continue. Report skipped items in the final chase table as `[MCP ERROR]`. Ruflo failures (Step 4a pattern search, Step 6 memory store) are non-critical: log and proceed with default behavior.
