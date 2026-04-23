---
name: "Slack Scan"
description: "Reads Slack channels and DMs marked log=true in slack-channels.md since last scan, classifies messages into procurement signals (decisions, commitments, blockers, action items, risks), deduplicates against open OIs, and writes structured records to OI DB after André's approval. Prevents decisions made on Slack from being lost without a Notion record. Use at wrap-up (Phase 0b) or standalone."
---

# Slack Scan

Extracts procurement-relevant signals from Slack and writes them to the OI DB. Prevents decisions, commitments, and blockers from being lost in Slack without a Notion record.

## Pre-flight

1. Read `outputs/session-state.md` — extract `Last-Slack-Scan` timestamp from `## Timestamps`.
2. Read `.claude/config/slack-channels.md` — collect all entries where `log=true`.
3. Read `.claude/config/databases.md` — get OI DB ID (`collection://505b7f08-8816-4bf7-b77a-7f232b52d0a0`).
4. Read `.claude/procedures/create-open-item.md` — OI field requirements.

## Step 1: Scan log=true sources

For each entry with `log=true` in `slack-channels.md`:

- **DMs**: `slack_read_channel` with User ID as `channel_id`. Set `oldest` = `Last-Slack-Scan` timestamp (Unix epoch or ISO 8601). Limit 50 messages.
- **Group DMs**: `slack_read_channel` with Channel ID. Same `oldest` + limit.
- **Channels**: `slack_read_channel` with Channel ID. Same `oldest` + limit. Follow up with `slack_read_thread` for any thread with ≥2 replies.

If `Last-Slack-Scan` is absent or blank: scan last 24h (currentDate minus 1 day).

Collect raw messages. Record per message: channel_name, sender_name, timestamp, text.

Do not scan entries with `log=false` even if relevant content is known to exist.

## Step 2: Classify signals

For each message, apply inclusion and exclusion filters:

**Exclude first (before classification):**
- Messages sent by André Faria (a.faria@swordhealth.com or display name "André")
- Social content: greetings, thanks, emoji-only, GIFs, "+1" reactions
- Messages whose timestamp ≤ `Last-Slack-Scan` (already processed)

**Include if message contains any of:**

| Signal | Keywords / Patterns |
|--------|-------------------|
| Decision | "decided", "going with", "confirmed", "we're using", "final choice", "selected", "chose" |
| Commitment | "I'll", "I will", "by [date]", "will send", "will share", "will handle", "I can get" |
| Blocker | "blocked", "waiting on", "can't proceed", "on hold", "no response", "still waiting" |
| Action Item | "can you", "please", "need you to", "could you", "action:", "@André", "follow up" |
| Risk | "dropped", "deprioritized", "escalate", "issue with", "problem", "concern", "delay" |

For each included message, assign:
- `signal_type`: Decision | Commitment | Blocker | Action Item | Risk
- `project`: Pulse | Kaia | M-Band | BloomPod | ISC — infer from channel name and any supplier/project mentions
- `supplier`: best match against known supplier names from context files, or null for ISC-level
- `proposed_oi`: draft OI fields (see field mapping below)

**OI field mapping by signal_type:**

| signal_type | OI Type | Status | Deadline default |
|-------------|---------|--------|-----------------|
| Decision | Decision | Closed | today |
| Commitment | Commitment | Pending | extract from message; else +5 biz days |
| Blocker | Blocker | Blocked | +3 biz days |
| Action Item | Action Item | Pending | extract from message; else +5 biz days |
| Risk | Action Item | Pending | +7 biz days |

Owner: message sender if a Sword employee; else André Faria.
Item: `{Supplier/Area} — {action}`, ≤70 chars.
Context: English, one paragraph — signal summary + source channel + sender + timestamp.

## Step 3: Dedup against OI DB

For each proposed OI with a non-null supplier, query OI DB:

```
SELECT Item, Status, id, url
FROM "collection://505b7f08-8816-4bf7-b77a-7f232b52d0a0"
WHERE Status NOT IN ('Closed','Rejected') AND Supplier LIKE '%{supplier}%'
ORDER BY "date:Deadline:start" ASC
LIMIT 10
```

If an open OI covers the same action (similar Item text + same supplier): mark `dedup=true`. Propose a Notion comment on the existing OI instead of a new create. Comment text: `[YYYY-MM-DD] {sender}: {signal summary}. (via Slack #{channel}, {HH:MM})`

ISC-level signals (null supplier): skip dedup — low collision risk.

## Step 4: SHOW BEFORE WRITE

Present classification summary:

```
SLACK SCAN — {date} — {N} signals from {M} sources (since {Last-Slack-Scan})

New OIs to create ({count}):
| # | Type | Item | Owner | Deadline | Source |
|---|------|------|-------|----------|--------|
| 1 | Commitment | Transtek — confirm delivery window | André | 2026-04-28 | Jorge DM, Apr 23 14:02 |

Comments on existing OIs ({count}): [auto-approved per Exception 2]
| # | OI | Comment text | Source |
|---|-----|-------------|--------|
| 1 | Transtek — RFQ response | [2026-04-23] Jorge: confirmed 2-week lead time. | Jorge DM |

Excluded ({count}): chitchat ({n}) / André's own ({n}) / already-processed ({n})
```

OI creates require André's approval. André may:
- "siga" / "yes" → proceed with all
- "salta o #N" → skip specific OI
- Edit proposed Item or Deadline inline
- "cancela" → abort all writes

Comments are auto-approved per Exception 2 — no gate needed.

After André's decision on each OI create, append one line to `outputs/autonomy-ledger.md` per `.claude/procedures/ledger-append.md`. Class: `oi_create_decision` (for Decisions) or `oi_create_action` (for others).

If zero signals found after classification: output "Slack scan: 0 signals since {Last-Slack-Scan}." and skip to Step 6.

## Step 5: Write

After approval:

1. **OI creates**: per `procedures/create-open-item.md`. All 8 required fields. Status per Step 2 mapping. For Decisions: Status=Closed, fill Resolution = signal summary.
2. **Comments on existing OIs**: `notion-create-comment` on OI page. Auto-approved per Exception 2.
3. Log all writes to `outputs/change-log.md`:
   ```
   [EVENT: SLACK_SCAN count={N} ois_created={M} comments={K} source=wrap-up|standalone]
   ```

## Step 6: Update scan timestamp

Write `Last-Slack-Scan: {YYYY-MM-DDTHH:MM}` to `outputs/session-state.md` under `## Timestamps` — regardless of whether signals were found. This prevents re-scanning already-processed messages on the next run.

## Rules

- **SHOW BEFORE WRITE** for all new OI creates. Comments-only runs are auto-approved (Exception 2).
- Skip André's own messages — he is the operator, not a signal source.
- Signal classification is conservative: when in doubt, exclude. False negatives are preferable to OI noise.
- `log=false` entries are never scanned.
- If Slack MCP fails on any source: log `[EVENT: SLACK_SCAN_FAIL source={channel}]` to change-log and skip that source. Continue with remaining sources. Do not block wrap-up.
- All OI Context in English, one paragraph.
- Never put raw Slack message text verbatim in Notion Context — summarise.
- Session C scope: no writes to Notion unless André approves at Step 4.
