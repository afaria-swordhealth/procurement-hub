---
name: "Context Doctor"
description: "Detect and fix drift between Notion supplier DBs and local context files. Run after /wrap-up gaps, before /weekly-report, or when context files feel stale. Auto-fixes status/NDA mismatches and timestamps. Reports missing suppliers and structural differences for Andre."
---

# Context Doctor

Compares Notion supplier DB state against context/{project}/suppliers.md files, fixes mechanical drift, and reports structural issues that need human judgment.

## Pre-flight

1. Read `outputs/session-state.md` for freshness timestamps.
2. Read `.claude/config/databases.md` for DB IDs and query patterns.
3. Read `outputs/change-log.md` to check for recent writes (collision guard: skip any page written in last 10 min).

## Step 1: Query Notion supplier DBs

For each project, query the supplier DB using `notion-query-data-sources`:

```sql
-- Pulse
SELECT Name, Status, "NDA Status", Currency, id
FROM "collection://311b4a7d-7207-80a1-b765-000b51ae9d7d"

-- Kaia
SELECT Name, Status, "NDA Status", Currency, id
FROM "collection://046b6694-f178-47dc-aac1-26efbfc2ab20"

-- M-Band
SELECT Name, Status, "NDA Status", Currency, id
FROM "collection://311b4a7d-7207-80e7-8681-000b5f1cd0dd"
```

If Notion MCP is unreachable, abort with a clear message. Do not attempt partial analysis.

## Step 2: Read context files

For each project, read:
- `context/pulse/suppliers.md`
- `context/kaia/suppliers.md`
- `context/mband/suppliers.md`

Parse the "Last synced" header timestamp and each supplier entry (name, status section, NDA mention).

## Step 3: Compare field by field

For each supplier in Notion, check against the context file:

| Check | Example | Classification |
|-------|---------|---------------|
| Status mismatch | Context says "Contacted", Notion says "RFQ Sent" | AUTO-FIX |
| NDA status mismatch | Context says "Pending", Notion says "Signed" | AUTO-FIX |
| Supplier in Notion but not in context | New supplier added via UI | REPORT |
| Supplier in context but not in Notion | Deleted or renamed in Notion | REPORT |
| Supplier count mismatch | Context lists 4 Shortlisted, Notion has 3 | REPORT |
| "Last synced" header > 48h old | Stale context | AUTO-FIX (timestamp after sync) |

**Notion is authoritative.** When Status or NDA Status differs, update the context file to match Notion.

## Step 4: Check promises.md for rejected-supplier references

1. Read `outputs/promises.md`.
2. For each open promise, check if the referenced supplier now has Status = Rejected in Notion.
3. If found: REPORT. The promise should likely be moved to Resolved.

## Step 5: Auto-fix

Safe to auto-fix (no approval needed):

- **Status/NDA corrections:** Update the supplier line in context/{project}/suppliers.md to match Notion. Preserve all other content on that line (pricing, notes, flags).
- **"Last synced" timestamp:** Update to current ISO timestamp after all fixes applied.
- **Section header counts:** If the count in a section header (e.g., "## Shortlisted (2)") no longer matches the entries below it, fix the count.

Before each write:
1. Check `outputs/change-log.md` for same-file writes in last 10 min. Skip if found.
2. Write to change-log first (claim the slot).
3. Apply the edit to the context file.

## Step 6: Report

Items that need Andre's judgment:

- **Missing suppliers** (in Notion but not context, or vice versa). Include the supplier name, project, and Notion status.
- **Count mismatches** that indicate structural differences (e.g., context groups suppliers differently than Notion status values).
- **Rejected-supplier promises** from Step 4.
- **Context files with structural issues** (e.g., a supplier appears under the wrong status section even after auto-fix).

## Output format

```
CONTEXT DOCTOR REPORT -- Apr DD

AUTO-FIXED:
| Project | Supplier | Field | Old (context) | New (Notion) |
|---------|----------|-------|---------------|-------------|
| Pulse   | Urion    | Status | Contacted    | Quote Received |

NEEDS YOUR DECISION:
- [Kaia] Supplier "NewCo" exists in Notion (Status: Identified) but not in context file.
  → Add to context/kaia/suppliers.md under ## Identified?
- [promises.md] Open promise for Sonia Sousa, but Avnet is now Rejected in Notion.
  → Move to Resolved?

FILES UPDATED:
- context/pulse/suppliers.md (Last synced: 2026-04-16T14:30)
- context/kaia/suppliers.md (Last synced: 2026-04-16T14:30)
```

## Rules

- NEVER edit Notion. This skill only reads Notion and writes local files.
- NEVER change supplier notes, pricing, or flags. Only update Status, NDA Status, counts, and timestamps.
- NEVER remove a supplier from a context file. Only add or update fields. Removals need Andre.
- Preserve all existing content on supplier lines when updating a field.
- Log every auto-fix to `outputs/change-log.md` with project, supplier, and what changed.
- If a context file has no "Last synced" header, add one at line 2 in the format `# Last synced: YYYY-MM-DDTHH:MM`.
