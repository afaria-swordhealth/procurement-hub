# Safety & Control Analysis — Claude Code Only
# Updated for command-driven architecture (no n8n)

---

# 1. What Changed

Without n8n, the safety model simplifies. There are no background processes, no automatic triggers, no Slack buttons. Every action starts with André typing a command. This eliminates entire categories of risk (wrong email logged to wrong supplier automatically, duplicate daily logs from cron, etc.).

The remaining risks are all in the SHOW BEFORE WRITE category: Claude Code proposes an action, André approves or rejects, then it executes.

---

# 2. Safety Hierarchy

## LEVEL 1 — TECHNICALLY IMPOSSIBLE
These are blocked by API scopes:
- Send email: Gmail scope is gmail.readonly + gmail.compose. No gmail.send. Even if Claude Code hallucinates and tries, the API returns 403.
- Delete Notion pages: No delete permission in Notion API.
- Delete/archive Gmail: Read-only scope.

## LEVEL 2 — BLOCKED BY RULES (in CLAUDE.md)
- Change supplier status to Rejected -> must present to André first
- Update any price field -> must present to André first
- Change NDA status -> must present to André first
- Mark Weekly Report as Sent -> André does this manually in Notion UI
- Modify Maintenance Rules -> READ-ONLY
- Contact new supplier (first outreach) -> André writes personally

## LEVEL 3 — ALLOWED BUT SHOW FIRST
Every Notion write follows this sequence:
1. Claude Code proposes the change (shows old value, new value, source)
2. André reviews and approves
3. Claude Code executes
4. Change logged to outputs/change-log.md

## LEVEL 4 — FULLY AUTONOMOUS AND SAFE
- Email reading (read-only)
- Notion reading (queries, fetches)
- Context file updates (local filesystem)
- Briefing generation (local file)
- Price comparison output (no writes)

---

# 3. What Can Go Wrong

## Wrong data written to Notion
Example: Agent misreads email, writes $780 instead of $7.80.
Mitigation: SHOW BEFORE WRITE. André sees the proposed change before it executes.
Recovery: Change log has old value for reference.

## Daily log duplicate
Example: /daily-log creates second entry for same date.
Mitigation: Command checks if entry exists before creating. Rule in CLAUDE.md.
Recovery: André deletes duplicate manually (Claude Code cannot delete).

## Gmail draft on wrong thread
Example: Draft reply attached to wrong conversation.
Mitigation: André reviews every draft in Gmail before sending.
Recovery: Delete draft in Gmail, create new one.

## Agent writes to wrong DB
Example: Pulse supplier update written to Kaia DB.
Mitigation: SINGLE-DB SCOPE rule. Each agent only writes to designated DBs.
Recovery: Change log identifies which DB was affected.

## Worst case scenario
Maximum possible damage if all rules fail simultaneously:
- Incorrect data in Notion DB field (recoverable via change log)
- Wrong Gmail draft created (harmless until André manually sends)
- Wrong context file updated (local only, re-sync from Notion)

Cannot happen under any circumstances:
- Email sent to supplier without André's action
- Notion page/entry deleted
- External communication
- Legal documents submitted

---

# 4. Control Dashboard

André has visibility into everything:

## outputs/change-log.md (audit trail)
Every Notion write logged with timestamp, agent, target, old/new value, source.

## Git history
Every commit captures the state of CLAUDE.md, context files, and change log. Full rollback capability.

## Gmail Drafts folder
Every email draft sits in Gmail until André reviews and clicks Send.

---

# 5. Advantage of Command-Driven vs Event-Driven

| Risk | Event-driven (n8n) | Command-driven (current) |
|---|---|---|
| Email logged to wrong supplier | Possible (domain mismatch) | Cannot happen (André sees before write) |
| Duplicate daily log | Possible (cron overlap) | Unlikely (command checks first) |
| Background action without André knowing | Possible (cron) | Impossible (nothing runs without André) |
| Price updated silently | Possible (with safeguards) | Impossible (SHOW BEFORE WRITE) |
| System does something while André is offline | Possible | Impossible |

The command-driven model is inherently safer. The only trade-off is speed: André must initiate every action instead of reacting to notifications.
