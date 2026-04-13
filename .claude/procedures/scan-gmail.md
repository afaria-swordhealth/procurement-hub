# Procedure: Scan Gmail
# Reusable subroutine. Called by: /mail-scan, /mail-scan-deep, /warm-up, /log-sent, /housekeeping

## Inputs
- **mode**: "filtered" (default) or "deep"
- **direction**: "incoming", "sent", or "both" (default: "both")
- **date_range**: number of days to look back (default: 3)
- **project_filter**: "pulse", "kaia", "mband", or "all" (default: "all")

## Steps

### 1. Build query
Read .claude/config/domains.md for domain lists and Gmail patterns.

### 2a. Filtered mode (default)
- Incoming: apply base exclusion filters + per-project domain filters from domains.md
- Sent: use sent filter pattern from config/domains.md
- Run per-project queries (Pulse, Kaia, M-Band) separately

### 2b. Deep mode
- Incoming: apply base exclusion filters only (NO domain filter)
- Sent: use sent filter pattern from config/domains.md
- After results: cross-reference each sender against Notion Contact fields (query all 3 Supplier DBs)
- Categorize: Known supplier | Unknown sender (flag for review)

### 3. For each email found
- Extract: sender, recipient, subject, date, snippet
- Query matching Notion supplier page for context (status, last outreach, open items)
- Use notion-query-data-sources with SQL. Use known schemas from config/databases.md (DB Schemas section) — do NOT do a SELECT * schema discovery step first. Query directly with targeted columns.

### 4. Classify each email
- **Log**: milestone worth recording in Outreach (see procedures/check-outreach.md)
- **Draft Reply**: needs response, generate draft
- **Ignore**: routine, no action needed
- **Escalate**: needs Andre's judgment or involves decisions above agent scope

### 5. Output
Present summary table per project:
| Supplier | Subject | Date | Direction | Recommendation | Reason |

Wait for caller to decide what to do with results.

## Error Handling
If Gmail MCP is unreachable, skip email phases and note the failure in the output. Never abort the entire command for a single MCP failure. The caller should present whatever results are available from other sources (Notion, Slack).
