---
name: "Supplier Rejection"
description: "Orchestrate a supplier exit: draft rejection email, draft Jorge note, list OIs to close, then execute status update after approval. Use when a supplier is being eliminated from a shortlist or deprioritized permanently."
---

# Supplier Rejection

Manages the full exit workflow for a supplier being rejected: communication, internal note, OI cleanup, and Notion status update. All writes are SHOW BEFORE WRITE.

## Pre-flight

1. Read `outputs/session-state.md` for freshness.
2. Read `.claude/config/writing-style.md` (tone rules).
3. Read `.claude/config/strategy.md` (never reveal other suppliers or pricing reasons).
4. Read `.claude/config/databases.md` (DB IDs, collection URLs).
5. **Execution checkpoint check:** Read `outputs/checkpoints/supplier-rejection-{supplier}.json`. If the file exists and contains `status: "in-progress"`: STOP. Surface to André: "Incomplete prior run detected on {date}. Steps completed: {steps_done}. Resume from that point, or confirm fresh start to overwrite." If the file is missing or unreadable: proceed.
6. **Lessons read:** per `.claude/procedures/lessons-read.md`, read `.claude/skills/supplier-rejection/lessons.md` (top 10). Apply before composing rejection email. If missing or empty, skip.

## Step 1: Pull supplier state

Query the relevant Supplier DB for the supplier:

```sql
SELECT Name, Status, "NDA Status", "Samples Status", Notes, id, url
FROM "{SUPPLIER_DB_COLLECTION_ID}"
WHERE Name LIKE '%{supplier}%'
```

Fetch the full Notion page. Extract:
- Contact section (name, email)
- Quote section (latest pricing — for internal reference only, never share externally)
- Outreach section (last 3 entries — understand relationship history)
- Linked open OIs

If supplier is already Rejected: warn André and ask if this is intentional (re-rejection, cleanup, or mistake).

## Step 2: Check for blocking dependencies

Before proceeding, verify:
- No active sample in transit (Samples Status = "Shipped" or "In Testing")
- No active OI of type "Action Item" or "Blocker" that requires a supplier response
- No outstanding NDA or contract in process

**Exception — response-tracking OIs:** If the only open Action Item OIs are response-tracking items (e.g., "RFQ response", "sample confirmation") where the supplier has not replied despite follow-up, these are the reason for rejection, not blocking dependencies. Close them in Step 7 with resolution: "Supplier rejected for non-response. OI no longer actionable."

If any other dependency exists, flag it: "Rejecting [supplier] while [X] is in progress. Confirm to proceed?"

## Step 3: Draft rejection email

Keep this short, professional, and relationship-preserving. Do not explain the real reason. Never mention other suppliers, pricing comparisons, or internal timelines.

**Draft structure:**
```
Subject: Re: [last thread subject or "Sword Health — [Project] Evaluation"]

Dear [Name],

Thank you for your time and the information you've shared with us throughout this evaluation process.

After careful review, we have decided not to move forward with [Supplier] at this stage.

We appreciate your responsiveness and the quality of the materials provided. We will keep your information on file for future opportunities.

Best,
André
```

Language: English for CN/US suppliers. Portuguese for PT suppliers (adjust tone accordingly).

**Before creating draft:** Cross-check recipient email (from Step 1 Contact section) against `config/domains.md`. Flag any mismatch before proceeding.

**SHOW BEFORE WRITE.** Present draft for André's review before creating Gmail draft.

*(Note: Gmail draft will appear as a standalone email, not a threaded reply — `create_draft` does not thread. André must open the draft and manually reply within the original conversation thread.)*

## Step 4: Draft internal note to Jorge

Short Slack DM in Portuguese. Frame as a status update, not a detailed explanation.

```
Olá Jorge,

Avancei com a exclusão do [Supplier] do [projeto]. [One sentence reason — factual, no detail].

O shortlist atual fica com [N] fornecedores ativos.

Obrigado,
André
```

Present as chat text for André to send manually (Slack MCP DM, not email).

## Step 5: List OIs to close

Query Open Items DB for OIs linked to this supplier:

```sql
SELECT Item, Status, Type, Owner, "date:Deadline:start" AS Deadline
FROM "collection://505b7f08-8816-4bf7-b77a-7f232b52d0a0"
WHERE Status != 'Closed'
  AND (Supplier LIKE '%{supplier}%' OR Item LIKE '%{supplier}%')
```

The dual filter catches: (a) OIs created after this fix with `Supplier` field set (primary match), and (b) legacy OIs created before the `Supplier` field was required, where the supplier name appears in the `Item` title (fallback). Both are needed during the transition period.

For each open OI:
- Propose: Status = Closed, Resolution = "Supplier rejected on [date]. No further action."
- **SHOW BEFORE WRITE.** Present list, wait for approval.

## Step 6: Update Notion status

**Level 2 safety — SHOW BEFORE WRITE.**

Propose:
- Supplier Status → `Rejected`
- NDA Status → `Not Required` (if currently Pending or null)

Present the full change summary. Wait for André's explicit approval before writing.

## Step 7: Execute (after approval)

Before executing writes: write execution checkpoint to `outputs/checkpoints/supplier-rejection-{supplier}.json` — value: `{ "skill": "supplier-rejection", "supplier": "{supplier}", "date": "{today}", "status": "in-progress", "steps_done": [] }`.

In order:
1. **PII pre-check.** Per `.claude/procedures/aidefence-precheck.md`, call `mcp__ruflo__aidefence_has_pii` on the rejection draft body. Clean / fail-open → proceed. PII detected (not false positive) → STOP, surface to André.
2. Create Gmail draft for rejection email (HTML format, append signature). After draft created: update checkpoint file — `steps_done: ["gmail_draft"]`.
2. Update OI statuses to Closed with resolution text (per Step 5 approval). If Notion update fails for one OI: skip it, log `[OI title] — Notion MCP error, skipped` to change-log, and continue to the next. Report skipped OIs in the final output. For each OI closed, also add a Notion page comment via `notion-create-comment`: `Supplier rejected [date]. OI closed via /supplier-rejection.` (auto-approved per CLAUDE.md §5 Exception 2). After OI closures: update checkpoint file — `steps_done: ["gmail_draft", "ois_closed"]`.
3. Update Supplier DB: Status → Rejected, NDA Status → Not Required. After status write: update checkpoint file — `steps_done: ["gmail_draft", "ois_closed", "status_updated"]`.
4. Log milestone to Outreach section (direct write, auto-approved):
   `**[Date]** -- Supplier rejected. Rejection email drafted. OIs closed.`
5. Log to `outputs/change-log.md`.
6. Store in ruflo memory:
   - `key`: `rejection::[supplier_name]::[YYYY-MM-DD]`
   - `namespace`: "procurement"
   - `upsert`: true
   - `tags`: ["rejection", project, supplier_name]
   - `value`: `{ supplier, project, date, reason_internal, ois_closed, contact_email, relationship_quality }`
   After ruflo store: update checkpoint file — `status: "complete"`, `steps_done: ["gmail_draft", "ois_closed", "status_updated", "ruflo"]`.

7. **(Risk closure)** Close any open risks for this supplier in ruflo. Call `mcp__ruflo__memory_search` with `query: "risk {supplier_name}"`, namespace "procurement", limit 10, threshold 0.3. For each result returned with `resolution: null`: call `mcp__ruflo__memory_store` (upsert true) preserving all existing fields and adding `resolution: { status: "closed", closed_date: "{today}", closed_reason: "supplier_rejected", closed_via_skill: "supplier-rejection" }`. Log to change-log: `risk-closure | Closed N risks for {supplier}`. If ruflo MCP fails: log and proceed — rejection is already recorded in Notion.

## Rules

- NEVER reveal pricing comparisons, other suppliers, or internal timelines in the rejection email.
- NEVER send email. Gmail draft only.
- SHOW BEFORE WRITE for all Notion writes (Status, NDA, OI closures).
- Outreach milestone (step 7.4) is auto-approved and goes directly.
- If supplier is a PT supplier, rejection email must be in Portuguese.
- Jorge note is always in Portuguese regardless of supplier language.
- Concurrency: session-single model (see `.claude/safety.md`). No per-write collision check.
- **MCP error handling:** Single-supplier operations (page fetch, Gmail draft, status write): if MCP fails, HALT and surface to André. Batch OI closures (Step 7.2): if one write fails, skip that OI, log `[OI title] — Notion MCP error, skipped`, and continue — report skipped OIs in the final output. Ruflo failures (checkpoint, risk closure Step 7.7): log and proceed.
- **Autonomy ledger:** after every SHOW BEFORE WRITE decision on supplier status, NDA, or OI closure, append one line to `outputs/autonomy-ledger.md` per `.claude/procedures/ledger-append.md`. Classes: `supplier_status_rejected` (`never_promote`), `nda_status_write` (`never_promote`), `oi_status_closed`. Email drafts log as `email_draft_send` (`never_promote`).
