# Change Log
# Rolling daily file. Keeps only today's entries.
# History lives in git log. On wrap-up, this file is committed then cleared for tomorrow.

## 2026-04-24

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

## 2026-04-23
