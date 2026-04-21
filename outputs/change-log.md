# Change Log
# Rolling daily file. Keeps only today's entries.
# History lives in git log. On wrap-up, this file is committed then cleared for tomorrow.

## 2026-04-22

### /improve — micro-fix: /wrap-up midnight crossing

- `.claude/commands/wrap-up.md`: adicionado bloco "Pre-flight: Date attribution" antes da Phase 0. Define `TARGET_DATE = yesterday` quando wrap-up corre entre 00:00–03:00; `TARGET_DATE = currentDate` nos outros casos. Propagado a Phase 3 (daily log lookup), Phase 4 (commit message), Phase 4c (change-log header). Resolve atribuição errada de daily log quando sessão passa a meia-noite.
