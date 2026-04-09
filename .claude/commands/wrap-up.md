---
description: End of day routine. Syncs context files, creates daily log, commits to git.
---

# Wrap-Up (End of Day)

**Agents:** notion-ops (daily log + context sync)

## Steps

### Phase 0: Slack Scan
0. Read recent DM history (last 24h) with key stakeholders:
   - Jorge Garcia (U03DHMPC8G6)
   - Miguel Pais (U09J1BQ564V)
   - Paulo Alves (U04CXBXFBUK)
   - Pedro Pereira
   - Bianca Lourenço
1. Read recent messages from key channels:
   - #pulse-packagin-artwork (C0ARTEJPMRC)
   - #pm-npi-isc (C0AKYG8JR42)
2. Extract any decisions, action items, or context relevant to Pulse/Kaia/M-Band.
3. Include Slack findings in the daily log and pending items.

### Phase 1: Context Sync
4. Query all 3 Supplier DBs and update context files:
   - context/pulse/suppliers.md
   - context/kaia/suppliers.md
   - context/mband/suppliers.md

### Phase 2: Daily Log
5. Check if today's daily log exists in Notion.
   - If yes: present current content, ask if anything to add.
   - If no: compile from today's mail-scan results, approved actions,
     and change-log entries. Present draft for approval.

### Phase 3: Commit
6. After daily log is approved and pushed to Notion, run:
   git add .
   git commit -m "EOD [date]: context synced, daily log complete"

### Phase 4: Summary
7. Present summary:
   - Context files updated (list changes)
   - Daily log status (created/updated)
   - Git commit hash
   - Pending items for tomorrow (from Open Items DB + unanswered emails)

## Rules
- Always sync context files BEFORE creating the daily log (log may reference current state).
- If daily log already exists and is Complete, skip step 2.
- Git commit is automatic after approval. No separate confirmation needed.
