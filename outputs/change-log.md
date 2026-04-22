# Change Log
# Rolling daily file. Keeps only today's entries.
# History lives in git log. On wrap-up, this file is committed then cleared for tomorrow.

## 2026-04-22

### /improve — L7 duplicate-rule cleanup (post-wrap-up)

6 files edited. Collapsed duplicated writing-style / Gmail-threading / OI-Context clauses to pointers at their canonical sources (`config/writing-style.md`, `agents/supplier-comms.md`, `procedures/create-open-item.md`):
- `.claude/config/presentation-guidelines.md` — collapsed 5-line writing-style mini-block (L234-239) to single pointer line.
- `.claude/skills/quote-intake/SKILL.md` — "All Notion content in English. No em dashes." → pointer.
- `.claude/skills/supplier-onboarding/SKILL.md` — same pattern → pointer.
- `.claude/skills/rfq-workflow/SKILL.md` — 4 lines (English/em dash/HTML-CDATA/sign-off) collapsed to 1 pointer + kept verify-recipient line.
- `.claude/skills/supplier-chaser/SKILL.md` — trimmed "Respect config/writing-style.md sign-off..." restatement.
- `.claude/skills/supplier-rejection/SKILL.md` — collapsed create_draft-threading note to pointer at supplier-comms.md.
- `.claude/agents/notion-ops.md` — trimmed duplicated OI-Context clauses after existing CLAUDE.md §4c pointer.

Ship metric (git grep for any rule returns exactly one canonical location): satisfied for writing-style, Gmail threading, OI Context. Session-single model and SHOW BEFORE WRITE already single-sourced in `.claude/safety.md`. L7 closed.

### /improve — L6 quote-intake PDF prefill (Step 1a)

`.claude/skills/quote-intake/SKILL.md`: added Step 1a "PDF attachment prefill (Levelpath pattern)". Extracts 7 canonical fields in a single pass (tier table, tooling/NRE, MOQ, lead time, Incoterm, payment terms, FX base), records per-field confidence (high/medium/low), routes low-confidence fields to SHOW BEFORE WRITE regardless of Step 4 auto-write conditions, HALTs on scanned PDFs (no OCR fabrication), logs `[EVENT: PDF_EXTRACT]` to change-log. Explicit "never send drafts or trigger supplier emails from this skill" guardrail. One parse → one approval gate (Step 4 auto-write or SBW), vs prior 3-4 gates.

### /improve — L6 chaser cadence confirmed shipped

Audit of `supplier-chaser/SKILL.md`: Step 4b "Signal-triggered cadence" (timezone map, CN weekend suppression, PT pre-09:00 hold, Gmail open/OOO modifiers, per-row send_window + defer_reason output) is fully present. §10 had a stale "not implemented" note — corrected to reflect shipped state. No code change to chaser needed.

### /improve — improvement-plan §10 status refresh

`outputs/improvement-plan.md` §10: L6 row moved ⚠ → ✅ (both sub-items now shipped); sequencing recommendation #4 marked as shipped. Remaining L6 work is real-data dogfooding on the first supplier PDF, not code.

