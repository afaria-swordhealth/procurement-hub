# Autoclean Scan Lists

Prune stale entries from scan configs so they don't become unmanageable over time. Runs daily from `/housekeeping`.

## Scope

Entries in scope:
- `.claude/config/slack-channels.md` — Key People (DMs), Group DMs, Key Channels
- `.claude/config/domains.md` — supplier domain entries

## Rule

Remove an entry only when **both** conditions are true:
1. **No activity in the last 21 days**, counting both directions, AND
2. **≥3 chase attempts** have been made in the silence window (not counting the original outreach — only follow-up chases).

The second condition prevents pruning ghosting suppliers: a supplier who received one RFQ and went dark is still an open thread; removing them from the scan list loses visibility. Only when André has chased 3+ times with zero reply is it safe to conclude the channel is truly dead and worth pruning.

Check pointers:

- **Slack (person DMs / group DMs / channels):** check `slack_read_channel` history. If no message (sent or received) in the last 21 days, condition 1 is met. For condition 2: count outbound Slack messages from André to that person/channel within the silence window that match chase keywords ("follow-up", "checking in", "any update", "quick reminder", or similar). 3+ outbound with no reply = prune eligible.
- **Gmail (domains):** search `from:<domain> OR to:<domain> newer_than:21d`. If no results, condition 1 is met. For condition 2: expand window to `from:me to:<domain> newer_than:90d` and count threads where the most recent message is outbound AND subject or body contains chase keywords. 3+ unreplied chases = prune eligible.

Activity window for condition 1 is a rolling 21 days from today. Chase window for condition 2 extends to 90 days to capture the full silence pattern.

## Exceptions (never auto-remove)

Protected because they are structural contacts even during quiet periods:

**Key People DMs:**
- Jorge Garcia
- Anand Singh
- Bianca Lourenço
- Sofia Lourenço
- Max Strobel
- Caio Pereira
- João Quirino
- Kevin Wang
- Pedro Pereira

**Group DMs / Channels:** no channel exceptions — same 21-day rule applies. Active working channels will refresh naturally; silent ones get pruned.

**Domains:** no permanent exceptions. If a supplier goes silent >21 days, they drop from the scan list. Reinstated automatically on the next sent/received email (outreach flow writes the contact back into `domains.md` when applicable).

## Procedure

1. For each entry not in the exception list, compute last-activity date from Slack/Gmail.
2. If last-activity ≤ 21 days ago, skip (active, not stale).
3. If last-activity > 21 days ago, count chase attempts within the 90-day chase window (see Rule, condition 2). If count < 3, skip and flag in the `/housekeeping` report as `Silent but not prunable: <entry name> — <N>d silent, <count> chase(s)` so André sees the ghost without auto-removal.
4. If last-activity > 21 days ago AND chase count ≥ 3, remove the entry from its config file.
5. Log each removal to `outputs/change-log.md` as:
   `Autoclean: removed <entry name> from <file> — last activity <YYYY-MM-DD>, <count> chases unanswered`
6. Present a single summary block in the `/housekeeping` report: "Autoclean removed N entries" with the list, plus the "Silent but not prunable" list from step 3.

## Reversibility

Removals are mechanical and reversible. If André needs a removed contact back, he can:
- Recover from `git log` (the removal commit)
- Let the next outreach re-add it automatically via the outreach write flow

No manual undo required in most cases.

## Cadence

Runs once per day as part of `/housekeeping`. Not run from `/warm-up` or other commands.
