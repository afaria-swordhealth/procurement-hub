# Safety Rules

Authoritative source for approval gates, write scope, and concurrency. All skills, commands, procedures, and agents reference this file (not CLAUDE.md §5 — which points here).

## LEVEL 1 - TECHNICALLY IMPOSSIBLE
- Send email (Gmail scope: read + compose only, NO send)
- Delete Notion pages (no delete permission)
- Delete/archive Gmail emails (read-only)

## LEVEL 2 - BLOCKED BY RULES
- Supplier status to Rejected -> present to André first
- Price field update -> present to André first
- NDA Status change -> present to André first. Exception: housekeeping may set NDA to "Not Required" on Rejected suppliers without approval.
- Weekly Report to Sent -> André only, in Notion UI
- Maintenance Rules -> READ-ONLY
- First outreach to new supplier -> André writes personally

## LEVEL 3 - SHOW BEFORE WRITE
Every Notion write must be:
1. Presented to André before execution
2. Approved explicitly
3. Logged to outputs/change-log.md

Exceptions are tiered by risk impact: **[COSMETIC]** = informational/reversible writes, **[COST-SENSITIVE]** = data writes with quantitative guardrails. [IRREVERSIBLE] operations have no exceptions — Core Rules 2 and 5b are absolute.

**[COSMETIC] Exception 1:** Outreach entries (milestones only) go directly to Notion without approval. See supplier-comms.md Outreach Policy.

**[COSMETIC] Exception 2:** OI page comments via `notion-create-comment` (routine audit trail — follow-up sent, status observed, update logged) go directly without approval. NOT excepted: OI Context field rewrites and supplier status changes, which remain SHOW BEFORE WRITE.

**[COST-SENSITIVE] Exception 3:** Pricing field updates (Unit Cost EUR, Tooling Cost EUR) in quote-intake are auto-approved when ALL are true: no flags raised in Steps 1-3 (no >30% delta from median, FOB/landed mix, missing required fields, or tier mismatch), FX rate from `config/fx-rates.md`, a prior quote exists in ruflo for this supplier AND the computed EUR value is within 30% of it. If no prior quote exists, route to SHOW BEFORE WRITE — first-ever quotes have no anchor for the 30% check. Write immediately with a single confirmation line; do not gate. Overrides Level 2 "Price field update" rule under these conditions only.

**[COST-SENSITIVE] Exception 4:** Supplier status → `RFQ Sent` in rfq-workflow is auto-approved immediately after André confirms the RFQ was sent. The send confirmation IS the approval; a second SHOW BEFORE WRITE gate is redundant.

**[COSMETIC] Exception 5:** OI Status → `In Progress` (from `Pending` or `Blocked`) is auto-approved when an email or Slack message meets ALL THREE conditions: (1) **explicit action language** — sender uses words like "started", "processing", "working on", "in progress", "will do", or equivalent that indicate active engagement; (2) **directly addresses the blocking condition** — the message says "resolved", "fixed", "unblocked", or explicitly confirms the specific action named in the OI Context; (3) **traceable evidence** — the message has a timestamp, an identified sender or assignee, and references the specific task or OI. Rationale: `In Progress` is informational and reversible — it does not close the OI or commit to any outcome. Does NOT apply to Status → `Closed`.

New auto-approvals must not be added as ad-hoc Exceptions. Evidence-based promotion lives in `autonomy.md`: a candidate auto-approval earns a place here only after the autonomy ledger shows 20 consecutive `approved_clean` outcomes with zero `rejected`. See `.claude/autonomy.md`.

## CORE RULES
1. SHOW BEFORE WRITE: Display changes, wait for approval.
2. NEVER DELETE: Set status to Rejected/Archived.
3. SINGLE-DB SCOPE: Each agent writes only to its designated DBs.
4. ALL NOTION CONTENT IN ENGLISH.
5. NEVER SEND EMAIL: Gmail DRAFT only.
5b. NEVER POST TO SHARED PLATFORMS DIRECTLY: Any outbound communication visible to parties other than André requires text approval first. Applies to: Jira comments, Slack sends (slack_send_message), Confluence writes. No auto-approval exception covers this rule.
6. NO EM DASHES: Use commas, periods, or "or".
7. CHECK BEFORE CREATE: Verify daily log entry doesn't exist before creating.
8. OPEN ITEMS IN SUPPLIER PAGES: The ## Open Items section in every supplier page must be a linked database view of the central Open Items DB, filtered by Supplier. Never inline bullets. All OIs must exist as records in the central Open Items DB (collection://505b7f08-8816-4bf7-b77a-7f232b52d0a0) with all required fields populated.

## Classifying new write operations

When designing a new skill or adding a write step, use this decision tree to assign the correct approval level:

```
0. Does this action send a message or post content visible to any party other than André
   (Jira comment, Slack send, Confluence write)?
   → YES: STOP. Show the exact text to André and wait for explicit approval.
   → NO: continue to check 1.

1. Is it an email send or a Notion delete?
   → YES: Level 1. Do not implement. Use draft (email) or Status=Rejected (Notion).

2. Is it one of the blocked-by-rules categories (supplier rejection, price field,
   NDA status change, first outreach, Weekly Report → Sent)?
   → YES: Level 2. Present to André; do not auto-execute.

3. Is it covered verbatim by an existing Exception (1-5 above)?
   → YES: follow that Exception's conditions. Do not re-gate.

4. Is the write reversible in < 30 seconds by André in the Notion UI?
   → YES (cosmetic / informational): Level 3, SHOW BEFORE WRITE.
      If same write class is always approved cleanly, start autonomy.md process.
   → NO (overwrites data, closes OI, changes status in a way that affects
      downstream decisions, or is hard to find/undo): Level 2 minimum.

5. Does the write affect multiple records in batch or touch shared config?
   → YES: treat as Level 2 regardless of individual reversibility.
      Batch errors compound; single-record reversibility does not apply.
```

No new Exceptions via ad-hoc edits here. Promotion path is `.claude/autonomy.md` only.

## Concurrency (session-single model)

One Claude session at a time. The system assumes a single active session and does not coordinate writes across concurrent sessions.

If a second session opens while the first is active:
- Treat the second session as **read-only** until the first closes.
- Do not write Notion, Gmail drafts, or context files from the second session.
- Read-only operations (queries, reports, /ping, /ask) are fine.

**Session liveness definition:** A session is live only if `outputs/session-state.md` was modified within the last 60 minutes. If the file is older than 60 minutes, the prior session is considered idle or abandoned — the new session may proceed with full write access without waiting. The 60-minute threshold applies to ALL sessions, including Session A (operational). An abandoned session does not block indefinitely.

On session start: warm-up writes `## Active Sessions` in session-state.md with the start time. On session end: wrap-up clears `## Active Sessions` to `(none)`. If a session ends without running wrap-up, the 60-minute liveness rule applies.

The multi-session scope block previously in CLAUDE.md §4b is retired. No 10-minute collision guard in procedure files — dead code once session-single landed. If collision detection is ever needed again, add it here, not in each procedure.
