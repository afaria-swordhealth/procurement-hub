# Autoclean Scan Lists

Prune stale entries from scan configs so they don't become unmanageable over time. Runs daily from `/housekeeping`.

## Scope

Entries in scope:
- `.claude/config/slack-channels.md` — Key People (DMs), Group DMs, Key Channels
- `.claude/config/domains.md` — supplier domain entries

## Rule

Remove any entry with **no activity in the last 21 days**, counting both directions:

- **Slack (person DMs / group DMs / channels):** check `slack_read_channel` history. If no message (sent or received) in the last 21 days, entry is stale.
- **Gmail (domains):** search `from:<domain> OR to:<domain> newer_than:21d`. If no results, entry is stale.

Activity window is a rolling 21 days from today.

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
2. If last-activity > 21 days ago, remove the entry from its config file.
3. Log each removal to `outputs/change-log.md` as:
   `Autoclean: removed <entry name> from <file> — last activity <YYYY-MM-DD>`
4. Present a single summary block in the `/housekeeping` report: "Autoclean removed N entries" with the list.

## Reversibility

Removals are mechanical and reversible. If André needs a removed contact back, he can:
- Recover from `git log` (the removal commit)
- Let the next outreach re-add it automatically via the outreach write flow

No manual undo required in most cases.

## Cadence

Runs once per day as part of `/housekeeping`. Not run from `/warm-up` or other commands.
