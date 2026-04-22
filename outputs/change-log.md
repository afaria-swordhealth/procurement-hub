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
