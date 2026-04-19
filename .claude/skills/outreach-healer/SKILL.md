---
name: "Outreach Healer"
description: "Scan and fix outreach sections across all active supplier pages in Notion. Enforces check-outreach.md rules: archive excess entries, fix chronological order, translate PT to EN, remove duplicates, validate format. Run after /log-sent batches, during /housekeeping, or when outreach sections look messy."
---

# Outreach Healer

Iterates over all active supplier pages in Notion, reads each ## Outreach section, and applies the rules from `.claude/procedures/check-outreach.md` to fix formatting, ordering, language, and entry counts.

## Pre-flight

1. Read `outputs/session-state.md` for freshness timestamps.
2. Read `.claude/procedures/check-outreach.md` (milestones policy, condensation rules, entry format).
3. Read `outputs/change-log.md` for collision guard.
4. **Execution checkpoint check:** call `mcp__ruflo__memory_retrieve` with key `"exec::outreach-healer::{YYYY-MM-DD}"`, namespace "procurement". If a record is returned with `status: "in-progress"`: surface to André — "Incomplete prior run detected on {date}. Suppliers processed: {suppliers_processed}. Resume (skip already-processed) or start fresh?" If ruflo MCP fails: skip this check and proceed.

## Step 1: Query active suppliers

For each project DB (IDs in `databases.md`), fetch active suppliers:

```sql
SELECT Name, Status, id, url FROM "{collection_id}" WHERE Status != 'Rejected'
```

Run for all 3 DBs (PULSE_DB, KAIA_DB, MBAND_DB). If Notion MCP is unreachable, abort.

**Before processing begins:** store execution checkpoint — `key: exec::outreach-healer::{YYYY-MM-DD}`, namespace "procurement", upsert true, value: `{ skill: "outreach-healer", date: "{today}", status: "in-progress", suppliers_processed: [], total_suppliers: {N} }`. If ruflo MCP fails: skip checkpoint and continue.

## Step 2: Fetch each supplier page

For each active supplier, use `notion-fetch` to retrieve the page content. Locate the `## Outreach` section. If the section does not exist, log it as a finding and skip (do not create the section).

## Step 3: Apply check-outreach.md rules

For each supplier's outreach section, run these checks in order:

### 3a. Duplicate removal
Identify entries with identical date AND identical content. Remove the duplicate (keep one).

### 3b. Chronological order
Entries must be newest-first. If out of order, re-sort by date descending. Archive toggle contents (inside `<details>`) are not re-sorted.

### 3c. Language check
All entries must be in English. Detect Portuguese entries (common indicators: "enviado", "recebido", "reuniao", "contacto", "seguimento", "resposta"). Translate to English, preserving the date prefix and factual content.

### 3d. Format check
Each entry must follow the pattern:
```
**Mon DD** -- One-line milestone. Key fact or commitment.
```
Fix common deviations:
- Missing bold on date: add `**...**`
- Wrong separator (`:` or `-` instead of ` -- `): replace with ` -- `
- Multi-line entries: condense to one line

### 3e. Entry count and archival
Count visible entries (outside any `<details>` toggle):

| Supplier status | Archive threshold |
|----------------|-------------------|
| Shortlisted, Quote Received | > 10 visible |
| All other active statuses | > 7 visible |

If over threshold:
1. Move oldest entries into a `<details>` toggle.
2. Toggle label: "Outreach Archive (Mon YYYY - Mon YYYY)" with date range of archived entries.
3. Keep the threshold number of most recent entries visible.
4. If an archive toggle already exists: prepend the newly archived entries to it and update the date range in the label.
5. **If no archive toggle exists: CREATE one.** Do NOT skip — the absence of a toggle is the reason to create it, not a reason to skip. A supplier with 13+ visible entries and no toggle is the primary target of this step.

### 3f. Summary line
The first line of the outreach section (before any entries) should be a summary:
```
**[X] milestones since [first date]. Last: [date] ([topic]). Key: [2-3 milestone events with dates].**
```
Update if stale (last date doesn't match most recent entry) or missing.

## Step 4: Write fixes to Notion

Outreach writes are auto-approved (per check-outreach.md write permissions). For each supplier that needs fixes:

1. Check `outputs/change-log.md` for same-page writes in last 10 min. If found, skip that supplier.
2. Append to `outputs/change-log.md` first (claim the slot).
3. Write the corrected ## Outreach section to Notion via `notion-update-page`.
4. If the Notion write fails, note the failure in change-log.
5. After each successful write: update checkpoint — append supplier name to `suppliers_processed[]`.

## Step 5: Output summary

Table with columns: #, Project, Supplier, Fixes Applied, Before (count), After (count). Then list any skipped suppliers (collision guard) and missing outreach sections. End with totals: scanned, fixed, skipped, missing.

After output complete: update checkpoint — `status: "complete"`.

## Rules

- NEVER create an ## Outreach section if one doesn't exist. Report it and let Andre set up the page.
- NEVER delete outreach entries. Archive them into the toggle.
- NEVER change the factual content of an entry. Only fix format, order, language, and duplicates.
- NEVER touch Rejected supplier pages.
- Outreach writes go directly to Notion without approval (exception to SHOW BEFORE WRITE, per check-outreach.md).
- Collision guard: always check change-log before writing. Skip if same page was written in last 10 min.
- All Notion content in English. Translate Portuguese entries but preserve factual accuracy.
- Log every fix to `outputs/change-log.md` with supplier name and fix type.
- If Notion MCP fails mid-run (after some suppliers processed), report partial results. Do not retry failed writes.
