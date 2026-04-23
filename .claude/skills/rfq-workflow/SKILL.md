---
name: "RFQ Workflow"
description: "Pipeline from NDA completion to RFQ email draft and response tracking. Validates NDA status, assembles the RFQ package with specs and volume tiers, drafts the email per audience rules, logs outreach, and creates OIs for response deadlines. Use after supplier onboarding when ready to request quotes."
---

# RFQ Workflow

Manages the full RFQ lifecycle: pre-check NDA, assemble the package, draft the email, log the milestone, and track the supplier's response.

## Pre-flight

1. Read `outputs/session-state.md` for freshness.
2. Read `.claude/config/databases.md` (DB IDs, schemas).
3. Read `.claude/config/writing-style.md` (tone rules by audience).
4. Read `.claude/config/strategy.md` (what to share, what to withhold).
5. Read `.claude/config/domains.md` (supplier contact verification).
6. Read `context/{project}/suppliers.md` for the target supplier.
7. Read `.claude/procedures/check-outreach.md` (milestone entry format).
8. Read `.claude/procedures/create-open-item.md` (OI field requirements).
9. Read `.claude/knowledge/nda-process.md` to confirm NDA trigger conditions and when proprietary specs require a fully executed NDA before RFQ.
10. **Execution checkpoint check:** per `procedures/exec-checkpoints.md`, read `outputs/checkpoints/rfq-workflow_{supplier_slug}.json`. If file exists with `status: "in-progress"`: STOP. Surface to André: "Incomplete prior run detected on {started}. Steps completed: {steps_done}. Resume from that point, or confirm fresh start?" If André confirms resume: follow **## Step Resumption** below. If missing or `status: "complete"`: proceed (archive complete runs per the procedure).
11. **Lessons read:** per `.claude/procedures/lessons-read.md`, read `.claude/skills/rfq-workflow/lessons.md` (top 10). Apply before default behavior. If missing or empty, skip.

## Step Resumption

When André confirms resume after an in-progress checkpoint, look up the **last entry** in `steps_done` and jump to the corresponding entry point. Skip all steps already listed in `steps_done`.

| Last completed (`steps_done` tail) | Resume from |
|---|---|
| *(empty — checkpoint written, no steps done)* | Step 3: Draft RFQ email (SHOW BEFORE WRITE gate) |
| `gmail_draft` | Step 4a: Log outreach milestone |
| `outreach` | Step 4a (M4): Update Last Outreach Date DB field |
| `last_outreach_date` | Step 4b: Update supplier status → RFQ Sent |
| `status` | Step 4c: Create response-tracking OI |
| `oi_created` | Step 4d: Update context |

Re-read the checkpoint file to recover `meta.project` and `meta.supplier` before resuming.

## Step 1: Pre-check — NDA status

Query the supplier's NDA Status field:

```sql
SELECT Name, Status, "NDA Status", Notes, id, url
FROM "{SUPPLIER_DB}"
WHERE Name LIKE '%{supplier_name}%'
```

| NDA Status | Action |
|-----------|--------|
| Signed | Proceed to Step 2 |
| Not Required | Proceed to Step 2 |
| In Progress / Sent | BLOCK. Report: "NDA not yet executed. Cannot send RFQ with proprietary specs." Create/update OI if none exists. |
| Not Started | BLOCK. Redirect to supplier-onboarding skill, Step 5. |

If the RFQ contains only non-proprietary info (generic specs, public datasheets), Andre may override the NDA block. Flag and get explicit approval.

## Step 2: Assemble RFQ package

Gather the following for the email and any attachments Andre will send:

### 2a. Specs document

Identify specs from Google Drive (per `context/{project}/suppliers.md` or Andre's input). Pulse: device/BLE/cosmetic/labeling specs. Kaia: material/dimension/print specs. M-Band: mechanical drawings, BOM, Gerbers, strap/packaging specs. If link not in context, ask Andre. Never use local paths.

### 2b. Volume tiers

Pulse: 1K, 5K, 10K, 50K. Kaia: 500, 1K, 5K. M-Band: 5K, 50K, 100K, 200K. Customize if Andre specifies.

### 2c. Delivery and timeline

- Incoterms preference: FOB (CN default), EXW or FCA (EU/US)
- Destination: Porto, Portugal (Sword address in memory) unless Andre specifies otherwise
- Samples: typically 5-10 units pre-production
- Quote response deadline: 10 business days from send (default). Never share internal project timelines (per `config/strategy.md`).

### 2d. Standard quote request items

1. Unit pricing at each volume tier
2. Tooling / NRE costs (itemized)
3. MOQ
4. Lead time (tooling + production, separately)
5. Incoterms basis
6. Payment terms
7. Certifications held (ISO 13485, FDA, CE, etc.)
8. Sample availability and cost

## Step 3: Draft RFQ email

### Audience rules (from config/writing-style.md)

| Audience | Language | Style |
|----------|----------|-------|
| CN suppliers | Simple English | Numbered items, short sentences, explicit asks |
| PT suppliers | Portuguese | Professional, clear structure |
| US/EU suppliers | Standard English | Professional, direct |

### RFQ email structure

Subject: `RFQ — {Part Category} for {Project} | Sword Health`. Body: (1) brief intro, (2) what we need, (3) volume tiers, (4) quote request items from 2d, (5) response timeline, (6) attachments note, (7) sign-off per `config/writing-style.md`.

### Strategy guardrails (from config/strategy.md)

Never reveal: other supplier pricing, internal timelines, decision deadlines, shortlist position, competing supplier names. Frame volume tiers as "planning scenarios", not commitments.

### Before creating draft

1. Cross-check recipient email against Notion Contact section and `config/domains.md`. Flag mismatches.
2. **SHOW BEFORE WRITE.** Present full draft to Andre. He may edit. After André's decision, append one line to `outputs/autonomy-ledger.md` per `.claude/procedures/ledger-append.md`. Class: `email_draft_send` (`never_promote`, supplier-facing).
3. **PII pre-check.** Per `.claude/procedures/aidefence-precheck.md`, call `mcp__ruflo__aidefence_has_pii` on draft body. Clean / fail-open → proceed. PII detected (not false positive) → STOP, surface to André.
4. Store execution checkpoint per `procedures/exec-checkpoints.md` before creating draft — write `outputs/checkpoints/rfq-workflow_{supplier_slug}.json` with `{ skill: "rfq-workflow", entity: "{supplier}", started, last_update, status: "in-progress", steps_done: [], meta: { project, supplier } }`. Atomic write. On write failure: STOP.
5. Create Gmail draft in HTML (no CDATA). Append signature from `.claude/config/signature.html`. After draft created: update checkpoint — `steps_done: ["gmail_draft"]`.

## Step 4: After sending — log and track

After André confirms the draft created in Step 3 was sent (confirmation is contextually bound to that draft only):

### 4a. Log outreach milestone

Per `procedures/check-outreach.md`, write directly to the supplier's Outreach section (no approval needed):

```
**Mon DD** -- RFQ sent. {Part category}, {tiers}. Response requested by Mon DD.
```
After outreach write: update checkpoint — `steps_done: ["gmail_draft", "outreach"]`.

**(M4)** Update `Last Outreach Date` DB field to today via `notion-update-page`. Skip if Status = 'Rejected'; skip silently if field not yet created in Notion UI. If update fails, log to change-log and proceed. After Last Outreach Date update: update checkpoint — `steps_done: ["gmail_draft", "outreach", "last_outreach_date"]`.

### 4b. Update supplier status

If current status is `Identified` or `Contacted`, auto-update to `RFQ Sent` immediately — no separate approval needed (per CLAUDE.md §5 Exception 4). The send confirmation IS the approval. Skip if status is already more advanced. After status write: update checkpoint — `steps_done: ["gmail_draft", "outreach", "status"]`.

### 4c. Create response-tracking OI

Per `procedures/create-open-item.md` (all 8 fields required): `{Supplier} — RFQ response` | Pending | Action Item | Owner: André | Deadline: send date + 10 biz days | Context: what was sent, tiers, specs status, response deadline | Supplier: {name}. **SHOW BEFORE WRITE** — present to André as part of the post-send summary. André's confirmation of this OI alongside the send confirmation is sufficient; no separate gate needed. After André's decision, append one line to `outputs/autonomy-ledger.md` per `.claude/procedures/ledger-append.md`. Class: `oi_create_action`. After OI created: update checkpoint — `steps_done: ["gmail_draft", "outreach", "status", "oi_created"]`.

### 4d. Update context and promises

Add to `context/{project}/suppliers.md`: RFQ sent date, what was requested, response deadline. If Andre committed to a follow-up date, add to `outputs/promises.md`. After Step 4d completes: update checkpoint — `status: "complete"`, `steps_done: ["gmail_draft", "outreach", "status", "oi_created", "context"]`.

## Step 5: Track response

When checking for RFQ responses (called from /mail-scan or manually):

1. Scan Gmail for replies from the supplier domain (per `procedures/scan-gmail.md`, direction: "incoming").
2. If quote received: hand off to the **quote-intake** skill.
3. If overdue (past deadline, no response): hand off to the **supplier-chaser** skill.
4. Add a Notion page comment on the OI via `notion-create-comment`:
   - `[YYYY-MM-DD] No response yet. {N} days past deadline.`
   - `[YYYY-MM-DD] Quote received. Handing off to quote-intake.`
   Do NOT modify the OI Context field.

## Rules

- NEVER send emails. Gmail draft only (Level 1 safety).
- SHOW BEFORE WRITE for Notion writes (exception: outreach milestones go direct per `check-outreach.md`).
- NDA must be Executed or Not Required before sending RFQ with proprietary specs. Andre can override for non-proprietary RFQs.
- Writing conventions (em dash, English, sign-off, HTML/no-CDATA): see `.claude/config/writing-style.md`.
- Always verify recipient email address before creating draft.
- Never reveal other supplier pricing, internal timelines, or shortlist status in the RFQ.
- Log all Notion writes to `outputs/change-log.md`.
- Concurrency: session-single model (see `.claude/safety.md`). No per-write collision check.
- **MCP error handling — single supplier:** If Notion or Gmail MCP fails at any step: HALT and surface to André — do not proceed with a partial outreach state. Ruflo failures (checkpoint check, checkpoint store): log warning and proceed fresh — checkpoint is audit-only, not a gate.
- **Autonomy ledger:** after every SHOW BEFORE WRITE decision on RFQ draft or OI creation, append one line to `outputs/autonomy-ledger.md` per `.claude/procedures/ledger-append.md`. Classes: `email_draft_send` (`never_promote`, supplier-facing), `oi_create_action`, `oi_create_decision`.
