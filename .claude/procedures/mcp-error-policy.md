# MCP Error Policy

Central policy for MCP failure handling. All skills reference this file — do not duplicate error policy text in individual skill Rules sections.

## Tier classification

| Tier | MCPs | On failure | André notified? |
|------|------|-----------|-----------------|
| CRITICAL | Notion (writes), Gmail | HALT — log + surface to André | YES |
| OPTIONAL | Slack, Google Calendar | SKIP — log inline, fallback output | NO |
| NON-CRITICAL | ruflo (all tools) | LOG only — proceed with default behavior | NO |

## Notion write: two modes

Notion write failures behave differently depending on operation scope:

| Mode | When | Policy |
|------|------|--------|
| **Single-supplier** | quote-intake, rfq-workflow, supplier-rejection — one supplier, one atomic transaction | HALT immediately. Do not write partial data. Surface to André with checkpoint path. |
| **Batch loop** | supplier-chaser, outreach-healer, housekeeping — iterating across multiple suppliers | SKIP the failing item. Log `[{Supplier}] — Notion MCP error, skipped`. Continue loop. Report all skipped in summary. |

## Per-tier response

### CRITICAL — single-supplier (Notion write / Gmail)
1. Stop execution immediately.
2. Log to `outputs/change-log.md`: `[EVENT: MCP_FAIL target=notion|gmail operation={op} entity={supplier} status=halted]`
3. Surface to André: "Notion [op] failed on [supplier]. Checkpoint at `outputs/checkpoints/{skill}_{slug}.json` if available. Restart or resume with `/skills {skill}`."
4. Do NOT proceed. Do NOT write partial data.

### CRITICAL — batch loop (Notion / Gmail per item)
1. Skip the failing item. Do not abort the loop.
2. Log `[{Supplier}] — Notion MCP error, skipped` to change-log and mark in the run summary table as `[MCP ERROR]`.
3. After the loop: report all skipped items to André in the summary.

### OPTIONAL (Slack / Google Calendar)
1. Log one line: `[EVENT: MCP_FAIL target=slack|calendar skill={skill} status=skipped]`
2. Fallback: deliver to chat instead of Slack DM; omit the Calendar block with `(calendar unavailable)` note.
3. Do not interrupt the skill. Continue normally.

### NON-CRITICAL (ruflo — any tool)
1. Log: `[EVENT: FAIL target=ruflo_{tool} key={key} status=logged_continue]`
2. Apply the calling skill's fallback (e.g., route to SHOW BEFORE WRITE if prior-quote anchor is missing; use default tone tier if supplier pattern is missing; skip urgency multiplier in morning-brief).
3. Do not surface to André. Do not interrupt.

## Checkpoint interaction

Local checkpoint files (`outputs/checkpoints/*.json`) are written by local file I/O — not MCP. A local checkpoint write failure is a CRITICAL error (HALT + surface), because the checkpoint is the resume gate.

ruflo memory stores used for audit logging are NON-CRITICAL even in checkpoint-adjacent roles — they are not resume gates; local files are.

## Quick reference for skill authors

```
New skill touches Notion?
  Single supplier → CRITICAL (single mode): HALT on failure
  Batch loop     → CRITICAL (batch mode): SKIP item + log + continue

New skill touches Gmail?
  → CRITICAL (single mode): HALT on failure

New skill touches Slack or Calendar?
  → OPTIONAL: SKIP + log + fallback to chat / omit block

New skill touches ruflo?
  → NON-CRITICAL: LOG only + apply skill's default fallback
```
