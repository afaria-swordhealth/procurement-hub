---
description: Scan sent emails, compare with Notion outreach sections, log missing milestones.
model: sonnet
---

# Log Sent

**Agents:** supplier-comms (Gmail scan), notion-ops (Notion outreach state)
**Rules:** Follow CLAUDE.md Safety Rules and Writing Style sections. Outreach writes go directly (no approval needed).

## Pre-flight

Read `outputs/session-state.md`. Calculate age of Last-Warm-Up:
- If < 2h: use context snapshot. Do not re-read context files.
- If 2–8h: use snapshot as baseline. Run delta scan for this task.
- If > 8h or missing: warn André and recommend /warm-up before proceeding.

## Phase 1: Scan Gmail Sent

**MANDATORY:** Always execute `search_threads` via Gmail MCP. Never infer from session context or prior tool results — those are stale the moment a new email is sent. Skipping the search and updating the timestamp anyway silently drops milestones on every subsequent run.

Use .claude/procedures/scan-gmail.md with:
- direction: "sent"
- date_range: **dynamic** — read `Last-Log-Sent` from `outputs/session-state.md`. Set date_range = days since Last-Log-Sent + 1 (round up, max 7). If Last-Log-Sent is missing or >7 days ago: use 7 and flag the gap. If session-state is unreadable or Last-Log-Sent is absent: HALT — output "session-state.md missing or unreadable. Run /warm-up before /log-sent." Do NOT default to 2 (a silent 2-day window may skip milestones from longer gaps).
  - Example: Last-Log-Sent was 38h ago → date_range: 2. Last-Log-Sent was 6h ago → date_range: 1.
  - Rationale: a fixed 24h window misses milestones when log-sent hasn't run since yesterday (weekend, crash, skipped session).
- project_filter: "all"

Domain filtering uses .claude/config/domains.md. Keep only emails sent to known supplier domains.

For each sent email, extract: recipient, subject, date, snippet.

## Phase 2: Fetch Notion Outreach State

For each supplier that received an email, query the supplier page from the relevant DB (.claude/config/databases.md).
Read the ## Outreach section. Find the last logged entry date.

**Notion error handling** (per `.claude/procedures/mcp-error-policy.md` — batch loop): on Notion error querying a single supplier page, retry once after 2s. If still failing on a 429 / rate-limit, log `[Supplier] — Notion 429 in Phase 2, skipped` to change-log and **continue the loop**. Surface skipped suppliers in the Phase 5 summary table as `[MCP ERROR — retry next /log-sent]`. Do not silently drop: every skip must appear in change-log.

## Phase 3: Compare and Flag

For each sent email, check against the existing Outreach entries fetched in Phase 2:
1. **Date match:** does any entry contain `**[email date in Mon DD format]**`?
2. **Event match:** does any same-date entry reference the same event category (RFQ / Quote / Follow-up / Sample / NDA / Meeting — using the keyword list in check-outreach.md dedup guard)?

If both match: **skip silently** — already logged. Do not flag or write.
If no match: flag as "not logged" and proceed to Phase 4.

This replaces the previous "email_date > last_entry_date" check, which failed when log-sent ran twice in the same day (second run would re-flag already-logged emails). The per-entry check is idempotent.

Also flag if the email content differs significantly from a draft (Andre may have edited manually).

## Phase 4: Filter for Milestones

Apply .claude/procedures/check-outreach.md milestones policy:
- Only log if the email qualifies as a milestone.
- Skip routine acks, FYIs, logistics back-and-forth.
- Use the entry format defined in check-outreach.md.

Present summary table of what will be logged and what was skipped (with reason).

## Phase 4b: Quote Detection

Before writing milestones, check whether any sent email in Phase 1 implies a quote was received or confirmed (e.g., André's email acknowledges a quote or requests cost revision). If so:
- Flag for André: "Quote activity detected — run `.claude/procedures/fill-cost-fields-on-quote.md` to update DB cost fields."
- Do NOT auto-run fill-cost-fields. André confirms first.

## Phase 5: Write

Write **one supplier at a time**. After each supplier's entry is written to Notion:
- **(M4)** update the supplier's `Last Outreach Date` DB field to today via `notion-update-page` (skip if Status = 'Rejected'; skip silently if field does not exist; if update fails, log to change-log and proceed).
- **Supplier pattern observer write** per `.claude/procedures/supplier-pattern-store.md` §Producers.2: if this milestone is an André response to an inbound supplier email (Direction "incoming response"), update the pattern record's response-side fields (`last_inbound_ts`, `response_count_90d`, `last_response_days`, `avg_response_days`, `response_rate_90d`, `last_chase_tier_that_worked`). Upsert via `mcp__ruflo__memory_store`. If ruflo fails, log `[EVENT: FAIL target=supplier_pattern supplier={slug}]` and proceed — pattern write is audit-only.
- Then log to `outputs/change-log.md` before moving to the next supplier.

If a Notion write fails mid-phase: log the failure, note which suppliers were already processed, and stop. Re-running is safe — the dedup guard in check-outreach.md prevents duplicates for already-written entries.

If Gmail MCP returns an error during Phase 1: log `log-sent Phase 1 failed: Gmail MCP error` to `outputs/change-log.md` and exit cleanly. Do NOT proceed with partial data. Re-run when MCP recovers.

Apply condensation rules from check-outreach.md (>7 visible entries triggers archiving).

If an email was sent to a supplier not in any Notion DB, flag it (may need DB entry created first).

## Phase 5b: OI Cross-Reference

For each supplier where an Outreach entry was written in Phase 5, query the Open Items DB (OI_DB from .claude/config/databases.md) for open OIs linked to that supplier (Status != 'Closed').

For each open OI found, check whether the email content is relevant:
- New information that updates the OI context
- A blocker partially or fully resolved
- A commitment made by André or the supplier
- A status change implied by the email

If relevant: propose a Notion page comment via notion-create-comment on that OI (per OI discipline in CLAUDE.md §4c). Comment format: `[YYYY-MM-DD] Follow-up sent [email/Slack]. [One-line summary of what was communicated.]`
If not relevant: skip silently.

**Write permissions:** OI comments via notion-create-comment are auto-approved (per CLAUDE.md §5 Exception 2). Write them directly after the Outreach write summary. Log each to `outputs/change-log.md`.

**Notion error handling** (per `.claude/procedures/mcp-error-policy.md` — batch loop): on `notion-query-data-sources` (OI lookup) or `notion-create-comment` failure, retry once after 2s. If still failing on a 429, log `[Supplier] — Notion 429 in Phase 5b OI cross-ref, skipped` to change-log and continue. Never silently skip: a skipped OI cross-reference is a deferred write that must be re-attempted next /log-sent run. Surface skipped OI checks in the Phase 5 summary table.

If no open OIs exist for a supplier, skip silently — do not flag.

## Output Format

Table per project:
| Supplier | Email Date | Subject | Last Outreach in Notion | Action |

Then the full proposed entries below the table.
Use the actual sent email content (not the draft), since Andre may have edited manually.
One outreach entry per email thread per day (consolidate if multiple in same thread same day).

After Outreach writes: OI comments are written directly (auto-approved per CLAUDE.md §5 Exception 2). Log each to outputs/change-log.md.

## Final Step: Session-State Timestamp

After all writes and output are delivered, update `Last-Log-Sent` in `outputs/session-state.md` to the current timestamp with a brief result note: `Last-Log-Sent: {YYYY-MM-DDTHH:MM} ({N} supplier(s) checked, {M} new milestone(s))`. Write this AFTER completion — not at scan start — so a crash mid-run leaves a stale timestamp detectable by session-doctor.
