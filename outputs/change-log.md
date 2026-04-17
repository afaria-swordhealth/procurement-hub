# Change Log
# Rolling daily file. Keeps only today's entries.
# History lives in git log. On wrap-up, this file is committed then cleared for tomorrow.

## 2026-04-18

### System audit — 7-agent review (A1–A4 expert + B1–B3 fresh eyes)
- Completed synthesis of all 7 agent reports. 4 critical, 9 high, 6 quick wins, 7 architectural findings identified.

### Audit fixes — applied
- **C1 (critical):** OI Context prepend convention purged from 9 files. All references now correctly point to notion-create-comment. Files: CLAUDE.md (§4 /log-sent + §4c review cadence), log-sent.md (Phase 5b), notion-ops.md (OI policy), quote-intake SKILL.md, supplier-chaser SKILL.md, sql-capabilities.md (x2 locations), housekeeping.md, create-open-item.md, decision-queue-render.md.
- **Q2:** Section numbering fixed. §4c (Open Items) now appears before §4d (Global Pre-flight) — labels swapped to match file order (was 4b→4d→4c, now 4b→4c→4d). All 6 external references updated to match.
- **Q1:** "3 projects" → "4 projects" in CLAUDE.md §2 and §4c (BloomPod is the 4th). Also fixed title: "Lead Procurement Engineer" → "Sourcing Engineer, ISC."
- **H4:** Collision guard added to supplier-chaser Step 6 (check change-log 10-min window before Notion comment write).
- **Q6:** Enhanced ruflo stored value in supplier-chaser — added response_received + days_to_reply fields with update instruction.

### Architectural decisions implemented
- **AR1:** Created `.claude/commands/skills.md` — `/skills` catalog listing all 14 skills with trigger and description.
- **AR3:** mail-scan.md — added Sample Receipt Detection section: flags DHL/supplier shipment confirmations and recommends Samples Status update.
- **AR4:** risk-radar SKILL.md — added Step 1e (NDA pipeline cross-project summary table). Updated description to "all 4 projects".
- **AR5:** rules-quick.md — added Scope Boundaries section: proactive scanning only during /warm-up, no scope expansion during execution.
- **AR6:** analyst.md — added pre-flight step 3: confirm project scope before loading data, no cross-project data leakage without explicit framing.
- **AR7:** wrap-up.md — added Phase 3b: meeting outcome prompt (checks for meeting-prep in session, asks to log ruflo memory if yes).

### High-priority build items — implemented
- **H1:** risk-radar — added Step 7: memory_store after each scan (per-supplier risk records + overall scan summary). Dead learning loop closed.
- **H2:** quote-intake — added Step 8: memory_store after Notion writes. Full quote record (unit, tooling, FLC, delta vs. prior quote via memory_search). First ruflo wiring for this skill.
- **H5:** session-doctor — added Step 1b: session-state.md structure validation (required sections check, truncation guard).
- **H6:** warm-up Phase 4 — added Slack silent abort guard: empty results for active contacts flagged as possible connection failure.
- **H7:** Created `.claude/skills/supplier-rejection/SKILL.md` — new skill: rejection email, Jorge PT note, OI closures, status update, ruflo store. All SHOW BEFORE WRITE.
- **H8:** housekeeping Phase 5 — delegated context drift check to context-doctor skill instead of reimplementing.
