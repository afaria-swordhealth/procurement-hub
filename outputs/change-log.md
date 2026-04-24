# Change Log
# Rolling daily file. Keeps only today's entries.
# History lives in git log. On wrap-up, this file is committed then cleared for tomorrow.

## 2026-04-24

[EVENT: FAIL target=log-sent reason="Gmail MCP token expired — re-auth required. No sent emails scanned."]

[EVENT: MAIL_SCAN]
Transtek/Pulse: OI comment on OTS stock OI (34bb4a7d…ccce3) — Mika confirmed 50 Hub BPM OTS, 0 scales, ~20d after payment. OI comment on 510(k) cuff OI (34bb4a7d…1370) — K241351 reviewed, all 3 sizes confirmed, TMB-2092-G vs BB2284-AE01 flag noted, Bianca Slack DM drafted. NDA OI (345b4a7d…8bae) closed — Zip #3213 fully approved Apr 23. Transtek Outreach Apr 24 entry added + Last Outreach Date → 2026-04-24. Jira LRE-1924 comment — Unique Scales dropped, close ticket. Jira LRE-1923 comment — MSA ≠ QTA, proceed independently. Manual: Zip #3214 (Unique Scales) to be cancelled in Zip UI by André. Daxin glucose noted as parked (T2D track).

[EVENT: MINI_SPRINT id=T2-5 files=skills/session-doctor/SKILL.md,procedures/context-loader.md]
Context drift detection: session-doctor Step 2 now reads 6 lines (was 3) + index.json; DRIFT_RISK flag at >24h (was 48h), STALE at >48h; COUNT_MISMATCH flag when ## Active (N) in file differs from index.json supplier_count_active. context-loader.md: added Drift signals section — advisory warnings emitted on load when >24h stale or count mismatch. No Notion queries added.

[EVENT: MINI_SPRINT id=T2-6 files=procedures/mcp-error-policy.md,skills/quote-intake/SKILL.md,skills/rfq-workflow/SKILL.md,skills/supplier-chaser/SKILL.md]
MCP error policy centralised: created procedures/mcp-error-policy.md (3-tier taxonomy: CRITICAL=Notion writes+Gmail, OPTIONAL=Slack+Calendar, NON-CRITICAL=ruflo; Notion has single-supplier HALT vs batch SKIP+LOG sub-modes). Replaced bespoke error text in quote-intake, rfq-workflow, supplier-chaser Rules with 1-line pointer to policy.

[EVENT: MINI_SPRINT id=T2-2 files=commands/wrap-up.md]
Conditional wrap-up sync: Phase 2 pre-step scopes DB queries to touched projects only. Scans change-log for project keywords; skips projects not mentioned AND with context < 24h old. Fallback: if change-log empty + all fresh, skips all 4 DB queries and goes straight to Phase 2a. Saves ~3-5k tokens per skipped project (~12k on a Pulse-only day, all 4 on /improve-only sessions).

[EVENT: MINI_SPRINT id=T2-4 files=config/ruflo-schema.md,skills/meeting-prep/SKILL.md]
Ruflo key schema centralised: created config/ruflo-schema.md (canonical key patterns, slug format, namespace policy, retrieve vs search decision rule, producer/consumer map). Fixed meeting-prep Step 8 key from `meeting::[supplier_name]::` to `meeting::[supplier_slug]::` (aligns with meeting-notes). retrieve vs search for discovery paths documented as intentional (date unknown = memory_search; full key known = memory_retrieve).

[EVENT: MINI_SPRINT id=T2-7 files=outputs/skill-queue.md,skills/rfq-workflow/SKILL.md,skills/quote-intake/SKILL.md,skills/session-doctor/SKILL.md]
Formal skill handoff queue: created outputs/skill-queue.md. rfq-workflow Step 5 now appends a queue row on quote received. quote-intake pre-flight surfaces matching entry as context; Step 8 clears it on completion. session-doctor Step 2b checks for stale entries (>7d = REPORT). Also fixed quote-intake Step 8 ruflo key to use supplier_slug (schema alignment).

[EVENT: MINI_SPRINT id=T3-2 files=safety.md,skills/session-doctor/SKILL.md,commands/wrap-up.md]
Session-liveness check: safety.md now defines 60-minute liveness threshold (session-state.md mtime > 60min = idle/abandoned, new session may proceed). session-doctor Step 1a checks Active Sessions vs mtime — flags [IDLE_SESSION] if stale, flags conflict if active and fresh. wrap-up Phase 4b now clears ## Active Sessions on EOD to prevent next-session false-block.

[EVENT: WARN source=improve/preflight detail="scheduled_tasks.lock stale 2h14m (written 09:06:55, now 11:21) — treated as crashed prior run, proceeding"]

[EVENT: MICRO_FIX id=signal-2 file=skills/session-doctor/SKILL.md]
session-doctor Step 1 timestamp table: Last-Mail-Scan > 4h now recommends running /ping first to verify Gmail token before attempting /mail-scan. Prevents discovering token expiry only after log-sent or mail-scan fails.

[EVENT: MICRO_FIX id=signal-3 file=commands/wrap-up.md]
wrap-up Phase 4c: change-log clear now strips ALL content (date sections + entries), keeping only the 3 header comment lines. Removes stale ## {TARGET_DATE} heading artifact that persisted into the next day's log. Session-doctor auto-fix adds the fresh date header on next session start.

[EVENT: MICRO_FIX id=signal-4 file=skills/improve/SKILL.md]
/improve Step 6: added explicit scheduled_tasks.lock delete as final cleanup step. Pre-flight item 4 "best-effort" language replaced with pointer to Step 6. Prevents stale lock warning on next /improve fire after session ends abruptly.
