# Procurement Automation System - CLAUDE.md
# André Faria | Sword Health ISC | v1.2 | April 2026

Orchestrator for André Faria's procurement automation. 4 projects: Pulse (BP cuffs + smart scales), Kaia (yoga mats), M-Band (wearable), BloomPod Battery (coin cell — light scaffold). Claude Code only.

---

# 1. Architecture

Command-driven. Nothing happens without André typing a command. Flow: command → Claude reads config + skill/agent → executes → presents with recommendations → André approves → writes → logged to `outputs/change-log.md`. All Notion writes follow SHOW BEFORE WRITE unless covered by a §5 exception.

Concurrency: **session-single model** (`.claude/safety.md`). Only one Claude session writes at a time.

---

# 2. Key People

- **André Faria** — Sourcing Engineer, ISC (operator). **Jorge Garcia** — Director, Logistics & Purchasing (André's manager, PT). **Anand Singh** — VP ISC.
- **Sofia Lourenço** — Expert QSE, QA/Regulatory contact (NOT João/Bianca; PT). **Pedro Pereira** — Eng BLE/SDK. **Bradley** — Legal/NDAs.
- **Catarina** — DHL. **Max Strobel** — Kaia PM. **Miguel Pais** — M-Band TPM. **Gustavo Burmester** — NPI.

---

# 3. Agents

Route by domain; each agent file in `.claude/agents/` defines its writes and NOT-touch boundaries.

- **supplier-comms** (emails/Outreach) · **logistics** (samples/DHL) · **testing** (Test Reviews) · **analyst** (pricing, read-only) · **notion-ops** (DB maintenance, logs, reports, audits)

---

# 4. Skills and Commands

Commands (`.claude/commands/`) are thin orchestrators; skills (`.claude/skills/`) are end-to-end workflows. Run `/skills` for the full list. Daily/weekly core: `/morning-brief` (proactive filter), `/warm-up`, `/wrap-up`, `/mail-scan`, `/log-sent`, `/housekeeping`, `/cross-check`, `/ping`, `/daily-log`, `/weekly-report`. Proactive loop (Layer 3): `/morning-brief` reads `outputs/pending-signals.md` (producers: `risk-radar`, future crons) and applies `.claude/procedures/attention-budget.md`.

**Session-state sync** (`outputs/session-state.md`): every command reads first. `Last-Warm-Up` <2h → use snapshot; 2–8h → baseline + delta scan; >8h → `/warm-up`. Load only the context file for the relevant project unless the command requires full state.

---

# 4c. Open Items Discipline

Open Items DB is the authoritative list of every action/decision/question/blocker across all 4 projects.

**Create when:** any scan, meeting, or ask yields an action with owner + deadline. OI vs `promises.md`: promises is a lightweight daily tracker for human commitments; OI DB is long-term authoritative. Items may live in both.

**Required fields (all 8):** Item (`Supplier/Area — action`, ≤70 chars), Status (Pending/In Progress/Answered/Blocked/Closed), Type (Action Item/Decision/Question/Blocker/Commitment), Owner (real name, default André), Deadline (always present), Project (relation), Context (summary paragraph), Supplier (exact DB match; omit only for ISC-level).

On close: Status=Closed and fill Resolution (1-2 sentences).

**Context = summary, not log.** English, one paragraph. New updates go as Notion page comments via `notion-create-comment` (auto-approved per §5 Exception 2) — never prepend to Context. Rewrite Context only when the summary changes materially.

**Supplier page `## Open Items`** must be a linked DB view filtered by Supplier. Never inline bullets.

---

# 4d. Global Pre-flight

Applies to every request.

- Read `outputs/session-state.md` first. Apply freshness rules above.
- Emails: load `config/writing-style.md`, `config/strategy.md`, `agents/supplier-comms.md`, relevant `context/{project}/suppliers.md`.
- Notion writes: load `agents/notion-ops.md`, fetch current page before proposing, follow SHOW BEFORE WRITE.
- Cost analysis: load `config/strategy.md` Cost Analysis Rules. Never compare FOB vs landed without flagging.
- Never raw URLs; always embed (Slack `<URL|text>`, Gmail `<a href>text</a>`).
- Log Notion writes to `outputs/change-log.md` (rolling daily).
- **Change-log date rule:** always use `currentDate` from system context for `## YYYY-MM-DD` header. Never compute. If would be future, use `currentDate` + log warning.

---

# 5. Safety

All levels, exceptions (1–5), and auto-approval rules live in `.claude/safety.md`. Evidence-based promotion of new auto-approvals lives in `.claude/autonomy.md` — do not add ad-hoc Exceptions here. Read both before any write.

**Never delete.** Set Status to Rejected/Archived.

---

# 6. Notion Workspace

Full IDs and query patterns: `.claude/config/databases.md`. Tree: Procurement Hub → Projects → Pulse/Kaia/M-Band/BloomPod → per-project Suppliers DB. Central Open Items DB `collection://505b7f08-8816-4bf7-b77a-7f232b52d0a0`. Test Reviews DB (Pulse) `collection://911b7778-b80b-4e94-a5c4-9f8853934d2e`. Daily Logs / Weekly Reports under My Work Log. **Maintenance Rules** READ-ONLY. **Internal Purchasing** BLOCKED.

Supplier page writes: Contact/Profile read-only; Quote → notion-ops; Outreach → supplier-comms; Open Items → notion-ops (linked DB view only). External platforms (ZIP, Jira): André submits manually.

---

# 7. Domains + Gmail + MCP

Domain-to-supplier table and Gmail scan patterns: `.claude/config/domains.md`.

| MCP | Access |
|---|---|
| Notion | Read + Write (no delete) |
| Gmail | Read + Draft (no send) |
| Slack | Read + Draft (live send requires explicit user phrase per safety.md Core Rule 5b) |
| ruflo | Non-critical: patterns, embeddings, aidefence, memory (audit/learning only) |

**Skill-author requirement:** any new skill or command that calls `notion-create-comment`, `notion-create-pages`, `notion-update-page`, or `notion-query-data-sources` MUST include an explicit error-handling block referencing `.claude/procedures/mcp-error-policy.md`. The policy doesn't auto-apply — without an explicit block, a Notion 429 will silently skip and lose the deferred work. Pattern: see `commands/log-sent.md` Phase 2 + Phase 5b or `commands/mail-scan.md` Safety section. Adding new Notion-write surfaces without this block is a friction-signal pattern (3 occurrences logged Apr 24 → May 7 → May 8).

---

# 8. Writing Style

See `.claude/config/writing-style.md`. Core: no em dashes; short sentences; all Notion content in English; Portuguese only for PT-supplier emails, Sofia, and Jorge; sign-off `"Best,"` or `"Thanks,"` (never `"Best regards,"`); Gmail drafts in HTML, no CDATA, always standalone (create_draft does not thread).

---

# 9. Modular Architecture

`config/` constants · `procedures/` reusable logic · `commands/` orchestrators · `skills/` end-to-end workflows · `agents/` scope boundaries · `knowledge/` Sword Insighter process (index in `INDEX.md`) · `safety.md` safety+concurrency · `autonomy.md` auto-approval promotion.

**When building a new workflow — pick one:**

| Type | Use when |
|------|----------|
| **skill** | End-to-end workflow: multi-step, has approval gates, writes to Notion/Gmail, tracks state |
| **command** | Thin orchestrator: calls 1-3 skills in sequence, manages session lifecycle (warm-up, wrap-up) |
| **procedure** | Reusable logic block: called by ≥2 skills/commands, no own output format, no approval gates |
| **agent** | Scoped write access: batched DB operations, defined NOT-touch boundaries, parallel execution |

Default is **skill**. Use **command** only when the logic is "run these skills in order." Use **procedure** when the same logic would be copy-pasted into multiple skills. Use **agent** when you need to isolate write scope from other agents.

**New supplier:** update `config/domains.md`, create Notion page (Contact/Profile/Quote/Outreach/Open Items), add to `context/{project}/suppliers.md`, log to change-log. First outreach: André writes personally.
