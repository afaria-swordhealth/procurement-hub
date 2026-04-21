# Change Log
# Rolling daily file. Keeps only today's entries.
# History lives in git log. On wrap-up, this file is committed then cleared for tomorrow.

## 2026-04-22

### /improve — micro-fix: /mail-scan closing prompt

- `.claude/commands/mail-scan.md` + `mail-scan-deep.md`: adicionada secção `## Closing Prompt` em ambos. Após a tabela de output, o comando conta recomendações ≠ "Ignore" e emite prompt explícito: "N recomendação(ões) pendente(s). Responde com `aprova tudo`, `aprova [linhas]`, ou `salta`." Se N=0, fecha silenciosamente. Resolve gap estrutural: incoming milestones ficavam em limbo quando André não respondia imediatamente após o output.

### /improve — micro-fix: /wrap-up midnight crossing

- `.claude/commands/wrap-up.md`: adicionado bloco "Pre-flight: Date attribution" antes da Phase 0. Define `TARGET_DATE = yesterday` quando wrap-up corre entre 00:00–03:00; `TARGET_DATE = currentDate` nos outros casos. Propagado a Phase 3 (daily log lookup), Phase 4 (commit message), Phase 4c (change-log header). Resolve atribuição errada de daily log quando sessão passa a meia-noite.
