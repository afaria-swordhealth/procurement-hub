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

**Exception 1:** Outreach entries (milestones only) go directly to Notion without approval. See supplier-comms.md Outreach Policy.

**Exception 2:** OI page comments via `notion-create-comment` (routine audit trail — follow-up sent, status observed, update logged) go directly without approval. NOT excepted: OI Context field rewrites and supplier status changes, which remain SHOW BEFORE WRITE.

**Exception 3:** Pricing field updates (Unit Cost EUR, Tooling Cost EUR) in quote-intake are auto-approved when ALL are true: no flags raised in Steps 1-3 (no >30% delta from median, FOB/landed mix, missing required fields, or tier mismatch), FX rate from `config/fx-rates.md`, a prior quote exists in ruflo for this supplier AND the computed EUR value is within 30% of it. If no prior quote exists, route to SHOW BEFORE WRITE — first-ever quotes have no anchor for the 30% check. Write immediately with a single confirmation line; do not gate. Overrides Level 2 "Price field update" rule under these conditions only.

**Exception 4:** Supplier status → `RFQ Sent` in rfq-workflow is auto-approved immediately after André confirms the RFQ was sent. The send confirmation IS the approval; a second SHOW BEFORE WRITE gate is redundant.

**Exception 5:** OI Status → `In Progress` (from `Pending` or `Blocked`) is auto-approved when an email or Slack message clearly shows the blocking condition has resolved or active work has started (e.g., supplier confirms they are working on a re-quote, an internal blocker is explicitly unblocked in writing). Rationale: `In Progress` is informational and reversible — it does not close the OI or commit to any outcome. Does NOT apply to Status → `Closed`.

New auto-approvals must not be added as ad-hoc Exceptions. Evidence-based promotion lives in `autonomy.md`: a candidate auto-approval earns a place here only after the autonomy ledger shows 20 consecutive `approved_clean` outcomes with zero `rejected`. See `.claude/autonomy.md`.

## CORE RULES
1. SHOW BEFORE WRITE: Display changes, wait for approval.
2. NEVER DELETE: Set status to Rejected/Archived.
3. SINGLE-DB SCOPE: Each agent writes only to its designated DBs.
4. ALL NOTION CONTENT IN ENGLISH.
5. NEVER SEND EMAIL: Gmail DRAFT only.
6. NO EM DASHES: Use commas, periods, or "or".
7. CHECK BEFORE CREATE: Verify daily log entry doesn't exist before creating.
8. OPEN ITEMS IN SUPPLIER PAGES: The ## Open Items section in every supplier page must be a linked database view of the central Open Items DB, filtered by Supplier. Never inline bullets. All OIs must exist as records in the central Open Items DB (collection://505b7f08-8816-4bf7-b77a-7f232b52d0a0) with all required fields populated.

## Concurrency (session-single model)

One Claude session at a time. The system assumes a single active session and does not coordinate writes across concurrent sessions.

If a second session opens while the first is active:
- Treat the second session as **read-only** until the first closes.
- Do not write Notion, Gmail drafts, or context files from the second session.
- Read-only operations (queries, reports, /ping, /ask) are fine.

The multi-session scope block previously in CLAUDE.md §4b is retired. No 10-minute collision guard in procedure files — dead code once session-single landed. If collision detection is ever needed again, add it here, not in each procedure.
