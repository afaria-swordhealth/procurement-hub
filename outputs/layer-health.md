# Layer Health Log
# Updated by /improve Source H (monthly). Do not edit manually.
# Assertions for L0-L7 regression detection. Pass = HEALTHY, failure = signal into friction-signals.md.

Last-Check: null (pending first run)
Next-Due: 2026-05-24

## L0 — Bug Sprint
- FILE_CHECK `.claude/procedures/decision-queue-render.md` — exists
- FILE_CHECK `.claude/config/writing-style.md` — exists
- FILE_CHECK `.claude/procedures/check-outreach.md` — exists
- FILE_CHECK `.claude/commands/ping.md` — exists
- FILE_CHECK `.claude/procedures/autoclean-scan-lists.md` — exists
- CONTENT_CHECK `.claude/procedures/autoclean-scan-lists.md` — contains "21d silence"
- CONTENT_CHECK `.claude/config/writing-style.md` — does NOT contain "Best regards,"

## L1 — Architecture
- FILE_CHECK `CLAUDE.md` — exists
- LINE_COUNT `CLAUDE.md` — ≤ 120 lines (soft limit; flag WARN if 121-130, MISSING if > 130)
- FILE_CHECK `.claude/safety.md` — exists
- FILE_CHECK `.claude/autonomy.md` — exists
- FILE_CHECK `outputs/friction-signals.md` — exists, contains "## Pending" and "## Resolved"
- FILE_CHECK `outputs/autonomy-ledger.md` — exists
- FILE_CHECK `outputs/pending-signals.md` — exists

## L2 — Hooks
- FILE_CHECK `.claude/settings.json` — exists, contains `"hooks"`
- FILE_CHECK `.claude/settings.local.json` — exists

## L3 — Proactive Loop
- FILE_CHECK `.claude/skills/morning-brief/SKILL.md` — exists
- FILE_CHECK `.claude/procedures/attention-budget.md` — exists
- FILE_CHECK `.claude/config/morning-brief-target.md` — exists

## L4 — Learning Loop
- FILE_CHECK `.claude/skills/supplier-chaser/lessons.md` — exists
- FILE_CHECK `.claude/skills/quote-intake/lessons.md` — exists
- FILE_CHECK `.claude/skills/rfq-workflow/lessons.md` — exists
- FILE_CHECK `.claude/procedures/supplier-pattern-store.md` — exists
- FILE_CHECK `.claude/procedures/aidefence-precheck.md` — exists

## L5 — Context Densification
- FILE_CHECK `context/pulse/suppliers.md` — exists
- FILE_CHECK `context/kaia/suppliers.md` — exists
- FILE_CHECK `context/mband/suppliers.md` — exists
- FILE_CHECK `context/index.json` — exists
- FILE_CHECK `.claude/procedures/context-loader.md` — exists

## L6 — Procurement Leverage
- FILE_CHECK `.claude/skills/scenario-optimizer/SKILL.md` — exists
- FILE_CHECK `.claude/skills/supplier-enrichment/SKILL.md` — exists
- FILE_CHECK `.claude/skills/nda-check/SKILL.md` — exists
- FILE_CHECK `.claude/skills/part-lookup/SKILL.md` — exists

## L7 — Cleanup (must be ABSENT)
- ABSENT_CHECK `architecture-review.md` — must not exist at repo root
- ABSENT_CHECK `safety-control-analysis.md` — must not exist at repo root
- ABSENT_CHECK `implementation-playbook.md` — must not exist at repo root
- ABSENT_CHECK `Dashboard.md` — must not exist at repo root

## History

| Date | Layers WARN/REGRESSED | Files missing or drifted | Notes |
|------|----------------------|--------------------------|-------|
