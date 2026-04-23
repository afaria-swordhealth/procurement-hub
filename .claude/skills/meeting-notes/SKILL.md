---
name: "Meeting Notes"
description: "Store and process meeting notes. Phase 1 stores raw notes as a Notion subpage under My Work Log → Meeting Notes → W{week}. Phase 2 extracts action items, decisions, supplier changes, and proposes OI creates/closes/updates. Invoke after any internal or supplier meeting."
---

# Meeting Notes

Two-phase skill: **Store** then **Process**. Both phases run in the same invocation unless `--store-only` is passed.

## Invocation

- `/meeting-notes` — paste notes after invoking. Runs both phases.
- `/meeting-notes --store-only` — store to Notion only, skip OI processing.
- `/meeting-notes --process-only` — re-process already-stored notes (re-paste or reference page URL).

## Pre-flight

1. Read `outputs/session-state.md` for current date and warm-up freshness.
2. Read `.claude/config/databases.md` for OI DB ID and Supplier DB IDs.
3. Note: Meeting Notes Notion structure lives at:
   - **My Work Log:** `310b4a7d-7207-8197-a82e-da2a49baff2a`
   - **Meeting Notes section:** `34bb4a7d-7207-8124-a598-da1b1b2432aa`
   - Week pages are children of Meeting Notes, format: `W{NN} — {Mon DD}–{DD}, {YYYY}`

---

## Phase 1: Store

### Step 1a: Extract meeting metadata

From the pasted notes, extract:
- **Meeting title** — use the original meeting title verbatim (from calendar invite, email, or header)
- **Date** — default to `currentDate` if not specified
- **Time** — extract from notes or ask André (format: HH:MM)
- **Project(s)** — infer from content (Pulse / Kaia / M-Band / BloomPod / Internal)
- **Attendees** — extract if listed

Page title format: `{Meeting Title} | {Mon DD, HH:MM}`
Example: `Final Alignment: Pulse — Private Label 3rd Party FDA Devices | Apr 23, 15:30`

### Step 1b: Resolve week page

Calculate ISO week from meeting date (use `currentDate` as default).

Query Meeting Notes children to check if the week page already exists:
- Week page format: `W{NN} — {Mon DD}–{DD}, {YYYY}` (e.g., `W17 — Apr 21–27, 2026`)
- If exists: use its page ID as parent for the meeting page.
- If not exists: create week page first under Meeting Notes (`34bb4a7d-7207-8124-a598-da1b1b2432aa`), with icon 📅.

### Step 1c: Create meeting page

Create the meeting notes page under the week page with:
- **Title:** `{Meeting Title} | {Mon DD, HH:MM}` (exact as extracted)
- **Icon:** 📝
- **Content:** structured version of the pasted notes (see format below)

**Notion page content format:**
```
## Attendees
{list if present, else omit section}

## Context
{one-paragraph summary of why this meeting happened}

## Decisions
{bullet list of decisions made — use bold for the decision itself}

## {Original section headers from notes}
{preserve original structure verbatim — do not rewrite}

## Action Items
| Owner | Action | Deadline |
|-------|--------|----------|
{extracted from notes}
```

**Write permission:** Auto-approved. No approval needed for storing notes to Work Log.

Log to `outputs/change-log.md`:
```
[EVENT: MEETING_NOTES_STORED title="{title}" notion_url={url} week=W{NN}]
```

---

## Phase 2: Process

Analyze the stored notes and propose system updates. All proposed writes require André's approval (SHOW BEFORE WRITE), except OI page comments (auto-approved per CLAUDE.md §5 Exception 2).

### Step 2a: Extract action items

For each action item found (owner + action + deadline):
- Check OI DB for existing open OI matching the same owner + topic.
  - If exists: propose `Add OI Comment` with the action item.
  - If not exists: propose `Create OI` with all 8 required fields.

### Step 2b: Identify supplier status changes

Look for language indicating:
- **Supplier dropped / cancelled:** "dropped", "removed", "no longer", "transferred to", "cancelled"
  - Propose: close all open OIs for that supplier (Status → Closed, Resolution = "{reason from meeting}")
  - Flag: context file update needed (`context/{project}/suppliers.md`)
  - Flag: if supplier has open Zip/NDA requests, note they should be cancelled manually
- **New supplier added:** "confirmed", "selected", "onboard"
  - Flag: run `/supplier-onboarding` if not yet in system
- **Supplier scope change:** "single supplier", "consolidated to", "both devices"
  - Flag: relevant OIs and context file fields to update

### Step 2c: Identify regulatory / legal decisions

Look for decisions about: QTA, MSA, SCA, NDA, LRE tickets, FDA, UDI, labelling, distributor model.

For each decision found:
- Match to open OI in OI DB.
- Propose `Add OI Comment` with the decision (format: `[YYYY-MM-DD] Decision in [meeting title]. {one-line summary}.`)
- If decision fully resolves the OI: propose Status → Closed.

### Step 2d: Identify new workstreams

Look for new tracks, parallel efforts, or timeline changes (e.g., "two-track approach", "accelerated timeline", "CEO pressure").

For each new workstream not already represented by an OI:
- Propose `Create OI` with Type = Action Item or Decision, Owner = André unless specified.

### Step 2e: Identify financial decisions

Look for: PO authorizations, payment approvals, budget commitments, pricing decisions.
Propose OI comments or new OIs as appropriate.

### Step 2f: Context file flags

After reviewing supplier status changes and decisions, flag which context files need updating:
- `context/pulse/suppliers.md` — if Pulse suppliers changed status or scope
- `context/kaia/suppliers.md` — if Kaia suppliers changed
- `context/mband/suppliers.md` — if M-Band suppliers changed

Do NOT write context files directly. Flag for `/wrap-up` or `/context-doctor` to handle.

### Step 2g: Ruflo memory store (optional)

If the meeting involved a supplier, call `mcp__ruflo__memory_store` to capture the outcome:
- **key:** `meeting::{supplier_slug}::{YYYY-MM-DD}`
- **namespace:** "procurement"
- **upsert:** true
- **tags:** ["meeting", project, supplier_slug]
- **value:** `{ "date", "supplier", "key_decisions", "supplier_status_change", "next_step", "tone" }`

If ruflo fails: skip silently, log `[EVENT: FAIL target=ruflo_meeting_store]`.

---

## Output Format

### Phase 1 output
One line: `Stored → [{title}]({notion_url}) under W{NN}.`

### Phase 2 output

```
## Processing: {Meeting Title}

### Supplier Changes
{list each supplier status change with proposed action}

### Action Items → OIs
| Owner | Action | Deadline | Proposed OI action |
(each row: Create OI / Add comment / Already exists)

### Legal / Regulatory Decisions
{list each decision with matched OI and proposed comment}

### New Workstreams
{list each new track with proposed OI}

### Context File Updates Needed
- context/pulse/suppliers.md: {what changed}
- (etc.)
```

End with the standard approval prompt:
> "**N recomendação(ões) pendente(s).** Responde com `aprova tudo`, `aprova [linhas]`, ou `salta`."

After André's decision, append one line to `outputs/autonomy-ledger.md` per `.claude/procedures/ledger-append.md` for each proposed Notion write. Classes: `oi_create_action` (Action Item / Blocker / Commitment), `oi_create_decision` (Decision), `oi_close` (Status → Closed update).

---

## Rules

- **Title fidelity:** always use the verbatim meeting title from the original invite. Do not paraphrase or shorten.
- **Preserve notes:** store the original structure. Do not rewrite the content of the notes.
- **Phase 1 is always auto-approved.** Notes storage to Work Log never requires approval.
- **Phase 2 requires approval** for all Notion writes except OI page comments.
- **Context files are never written directly** by this skill. Flag for /wrap-up.
- **If meeting date is ambiguous:** use `currentDate` from system context and note the assumption.
- **Duplicate guard:** before creating a meeting page, check if a page with the same title already exists in the week folder. If yes, add OI comment to existing page instead of creating duplicate.
- **Week page creation is auto-approved** (structural, no data content).
- Log all Notion writes to `outputs/change-log.md`.
- **Autonomy ledger:** after every Phase 2 SHOW BEFORE WRITE decision, append one line per `.claude/procedures/ledger-append.md`. Classes: `oi_create_action`, `oi_create_decision`, `oi_close`.
