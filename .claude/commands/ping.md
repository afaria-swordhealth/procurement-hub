---
description: "30-second MCP connectivity health check. Probes Gmail, Notion, Slack, and ruflo. Fail-fast with per-service diagnostics."
model: haiku
---

# Ping

Lightweight health check for all external MCPs the procurement system depends on. Use before any long-running command (`/warm-up`, `/mail-scan`, `/weekly-report`, structural sprints) to avoid starting work on a broken substrate.

Budget: under 30 seconds, all probes in parallel. No writes, no state changes, no approvals needed.

## Pre-flight

None. This command is intentionally stateless — it runs even when session-state.md is stale or missing.

## Probes (run in parallel)

### 1. Gmail MCP
Call `mcp__claude_ai_Gmail__list_labels`. Expected: returns at least one label (SYSTEM labels like INBOX, SENT, DRAFT always exist).
- OK if response contains ≥ 1 label.
- FAIL if MCP returns error, timeout, or empty list.

### 2. Notion MCP
Call `mcp__claude_ai_Notion__notion-query-data-sources` with:
```sql
SELECT id FROM "collection://505b7f08-8816-4bf7-b77a-7f232b52d0a0" LIMIT 1
```
(Open Items DB — the most-used collection; confirms both MCP connectivity and DB access.)
- OK if query returns a row.
- FAIL if MCP error, auth error, or empty (empty = possible collection-ID drift, still a failure signal).

### 3. Slack MCP
Call `mcp__claude_ai_Slack__slack_search_users` with query "andre" limit 1.
- OK if response returns at least one user.
- FAIL if MCP error or timeout.

### 4. Ruflo memory
Call `mcp__ruflo__memory_retrieve` with key `ping::health-check`, namespace "procurement". (Key may not exist — the call itself is the probe.)
- OK if the call returns a structured response (record found OR null result with no error).
- FAIL if MCP error or timeout.

## Output

Single compact table. One line per service. Total time at the bottom.

```
PING — {YYYY-MM-DD HH:MM}

| Service  | Status | Latency | Notes                       |
|----------|--------|---------|-----------------------------|
| Gmail    | OK     | 340ms   | 42 labels                   |
| Notion   | OK     | 520ms   | OI DB reachable             |
| Slack    | FAIL   | timeout | 5s timeout — retry or check |
| Ruflo    | OK     | 180ms   | memory namespace OK         |

Overall: DEGRADED (1/4 down) — Slack unavailable, operational commands that touch Slack will fall back or skip that phase.
```

## Overall status rule

- **GREEN:** all 4 OK.
- **DEGRADED:** 1-2 FAIL. Safe to run most commands; affected phases will skip or report.
- **RED:** 3+ FAIL or Notion FAIL. Do NOT run operational commands; investigate MCP state first (restart Claude, check `.mcp.json`, check network).

Notion is load-bearing — any Notion failure promotes overall status to RED regardless of other services.

## Rules

- Parallel probes only. Sequential probing blows the 30s budget.
- No retries within the command. If a probe fails, it fails — retry is André's decision, not the command's.
- No writes anywhere. Read-only across all 4 MCPs.
- Output goes to the terminal only. Do not log to `change-log.md` unless a probe FAILs, in which case append one line:
  `PING: {YYYY-MM-DD HH:MM} — {service} FAIL ({error_snippet})`.
  GREEN runs are not logged — log-noise reduction.
- This command does not update `session-state.md`. A recent PING does not count as a warm-up.
