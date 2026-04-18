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
9. **Execution checkpoint check:** call `mcp__ruflo__memory_retrieve` with key `"exec::rfq-workflow::{supplier_name}"`, namespace "procurement". If a record is returned with `status: "in-progress"`: STOP. Surface to André: "Incomplete prior run detected on {date}. Steps completed: {steps_done}. Resume from that point, or confirm fresh start."

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
2. **SHOW BEFORE WRITE.** Present full draft to Andre. He may edit.
3. Store execution checkpoint to ruflo before creating draft — `key: exec::rfq-workflow::{supplier}`, namespace "procurement", upsert true, value: `{ skill: "rfq-workflow", supplier, date, status: "in-progress", steps_done: [] }`.
4. Create Gmail draft in HTML (no CDATA). Append signature from `.claude/config/signature.html`. After draft created: update checkpoint — `steps_done: ["gmail_draft"]`.

## Step 4: After sending — log and track

After André confirms the draft created in Step 3 was sent (confirmation is contextually bound to that draft only):

### 4a. Log outreach milestone

Per `procedures/check-outreach.md`, write directly to the supplier's Outreach section (no approval needed):

```
**Mon DD** -- RFQ sent. {Part category}, {tiers}. Response requested by Mon DD.
```
After outreach write: update checkpoint — `steps_done: ["gmail_draft", "outreach"]`.

### 4b. Update supplier status

If current status is `Identified` or `Contacted`, auto-update to `RFQ Sent` immediately — no separate approval needed (per CLAUDE.md §5 Exception 4). The send confirmation IS the approval. Skip if status is already more advanced. After status write: update checkpoint — `steps_done: ["gmail_draft", "outreach", "status"]`.

### 4c. Create response-tracking OI

Auto-approved after André confirms RFQ was sent — no SHOW BEFORE WRITE needed. This OI creation is a mechanical consequence of a confirmed send, separately authorized from Exception 2 (which applies to OI page comments via notion-create-comment, not OI record creation). Per `procedures/create-open-item.md` (all 7 fields): `{Supplier} — RFQ response` | Pending | Action Item | Owner: supplier contact (Andre monitors) | Deadline: send date + 10 biz days | Context: what was sent, tiers, specs status, response deadline. After OI created: update checkpoint — `steps_done: ["gmail_draft", "outreach", "status", "oi_created"]`.

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
- All Notion content in English. No em dashes.
- Always verify recipient email address before creating draft.
- Always use HTML format for Gmail drafts. Never wrap body in CDATA.
- Sign-off: "Best, Andre" or "Thanks, Andre". Never "Best regards,".
- Never reveal other supplier pricing, internal timelines, or shortlist status in the RFQ.
- Log all Notion writes to `outputs/change-log.md`.
- Check `outputs/change-log.md` collision guard (10-min window) before any Notion write.
