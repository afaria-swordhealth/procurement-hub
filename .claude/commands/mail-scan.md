---
description: Scan Gmail for new supplier emails, cross-reference with Notion, present recommendations.
model: sonnet
---

## Agents

- supplier-comms: Gmail scan (incoming + sent)
- logistics: DHL/tracking email detection
- notion-ops: Notion cross-reference

## Pre-flight

Read `outputs/session-state.md`. Calculate age of Last-Warm-Up:
- If < 2h: use context snapshot. Do not re-read context files.
- If 2–8h: use snapshot as baseline. Run delta scan for this task.
- If > 8h or missing: warn André and recommend /warm-up before proceeding.

## Procedure

1. Run `.claude/procedures/scan-gmail.md` with mode: "filtered", direction: "both" (incoming + sent), lookback: 3 days.
2. Use config/databases.md (Query Patterns section) to cross-reference each sender against Notion supplier pages (status, last outreach, open items).
3. For each email with a commitment, pending decision, unresolved question, or blocker, propose a new OI OR an OI page comment on an existing OI per `.claude/procedures/create-open-item.md`. When updating an existing OI, use `notion-create-comment` — do NOT rewrite the Context field.
4. Follow CLAUDE.md Safety Rules and Writing Style sections.

## Output

Present a summary table per project (Pulse, Kaia, M-Band):

| Supplier | Subject | Date | Recommendation | Reason |
|----------|---------|------|----------------|--------|

Recommendation values: Log, Draft Reply, Ignore, Escalate, Create OI, Add OI Comment.

Use `notion-query-data-sources` with SQL for DB queries instead of fetching pages individually.

## Sample Receipt Detection

During step 1, when scanning DHL notifications or supplier emails:
- Flag as **Sample shipped** if subject or body contains: "tracking", "shipped", "dispatched", "AWB", "waybill", or supplier confirms sending units.
- Add to output table with Recommendation: "Update Samples Status → Shipped. Log tracking number."
- After André approves: update Samples Status field in the relevant Supplier DB. Log tracking number in the supplier page Notes or a dedicated field if available.

## Quote Detection

If any email contains a supplier quote (keywords: quote, pricing, unit price, OR-xxx, attachment with pricing data):
- Flag with Recommendation: "Quote received — run `.claude/procedures/fill-cost-fields-on-quote.md`"
- After André confirms the quote is valid: call `fill-cost-fields-on-quote.md` to populate `Unit Cost (EUR)` and `Tooling Cost (EUR)` in the Supplier DB.

## Internal Platform Processing

### Zip (from:swordhealth.ziphq.com)

For each Zip notification:
1. Identify the event type from subject and body:
   - "NDA approved" / "executed" / "fully signed" → NDA execution milestone
   - "Step completed" / "onboarding" / "vendor created" / "approved" → Supplier onboarding milestone
   - "Budget request approved" / "rejected" / "pending" → Budget decision
   - "Comments added" / "revision requested" → Action needed
2. Identify the supplier name (usually in subject line or body).
3. Match to Notion supplier page via Supplier DB. If no match, flag as unknown.
4. Extract the Zip request URL from the email body if present (format: https://swordhealth.ziphq.com/...).
5. Proposed actions per event:
   - NDA signed/executed: propose updating NDA Status in Supplier DB to "Signed" (SHOW BEFORE WRITE). Check for open NDA OI and propose closure.
   - Onboarding step completed: add Outreach milestone entry. Check for open onboarding OI and propose update.
   - Budget approved: propose closing or updating the relevant OI.
   - Revision/comment: flag for André's attention with Zip link.
6. Output row: include Zip link in Links column. Recommendation: Log / Update OI / Update NDA Status / Escalate.

### Jira ISC Shipping (from:swordhealth.atlassian.net, label:ISC-Shipping)

For each Jira ISC Shipping email:
1. Extract the Jira ticket ID (format: ISCSB-XXXX or ISC-XXXX — visible in subject line).
2. Build Jira link: `https://swordhealth.atlassian.net/browse/[TICKET-ID]`
3. Scan email body for DHL tracking number. Formats: 10-digit AWB (e.g., 1234567890) or JJDXXXXXXXXXXXXXX. If found, build DHL tracking link: `https://www.dhl.com/global-en/home/tracking.html?tracking-id=[AWB]`
4. Extract destination supplier or address from email body.
5. Match to an open OI: check if any open OI references this supplier + a sample shipment action.
6. Output row:
   - Links column: embed `[Jira ISCSB-XXXX](url)` and `[Track DHL AWB](url)` as clickable links.
   - Recommendation: Log (informational) / Update OI (if shipment resolves an OI action) / Escalate (if shipment delayed or cancelled).
   - If matched to OI: propose an OI page comment via `notion-create-comment` referencing both links (auto-approved per CLAUDE.md §5 Exception 2). Do NOT rewrite OI Context.

### Output table for internal platform emails

Add a **Links** column to the output table for Zip and Jira rows:

| Source | Supplier/Topic | Subject | Date | Recommendation | Links |
|--------|---------------|---------|------|----------------|-------|
| Zip | [Supplier] | [subject] | [date] | Log / Update NDA / Close OI | [Zip request](url) |
| Jira | [Supplier] | [subject] | [date] | Log / Update OI | [ISCSB-XX](url) · [Track DHL](url) |

## Safety

Wait for user approval before any writes. No exceptions.

## Note

For broader scan without domain filter, use /mail-scan-deep.
