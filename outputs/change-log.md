# Change Log
# Rolling daily file. Keeps only today's entries.
# History lives in git log. On wrap-up, this file is committed then cleared for tomorrow.

## 2026-04-22

### /improve — micro-fix: /mail-scan closing prompt

- `.claude/commands/mail-scan.md` + `mail-scan-deep.md`: adicionada secção `## Closing Prompt` em ambos. Após a tabela de output, o comando conta recomendações ≠ "Ignore" e emite prompt explícito: "N recomendação(ões) pendente(s). Responde com `aprova tudo`, `aprova [linhas]`, ou `salta`." Se N=0, fecha silenciosamente. Resolve gap estrutural: incoming milestones ficavam em limbo quando André não respondia imediatamente após o output.

### gap-fill: Transtek + Unique Scales Outreach + OI comments (Apr 22)

**Transtek Outreach** (311b4a7d…de5f): +3 entradas — Sofia artwork approved (Apr 21 #pulse-qara), QTA → Sarah/Legal (Apr 21), NDA draft → Mika (Apr 22). Summary 63+→66+. Last Outreach Date → 2026-04-22.
**Unique Scales Outreach** (311b4a7d…e1e): +3 entradas — Shenzhen address → Bradley (Apr 22), NDA draft → Queenie (Apr 22), FCC files → BU/QARA (Apr 22). Summary 61+→64+. Last Outreach Date → 2026-04-22.
**OI comments (4):**
- Transtek SQA QARA review (33eb4a7d…5dc): Sofia artwork approval + QTA → Legal.
- Unique Scales SQA (33eb4a7d…ffb): Elena §502 ruling + D336721 importer re-framing.
- Transtek NDA (345b4a7d…bae): draft forwarded to Mika.
- Unique Scales NDA (344b4a7d…e9f): draft forwarded to Queenie.
Source: Slack #pulse-qara + #pulse-packaging-artwork + Gmail sent Apr 22. Gaps não capturados por /log-sent (crons down) nem /mail-scan (Slack fora de scope).

### /improve — micro-fix: /wrap-up midnight crossing

- `.claude/commands/wrap-up.md`: adicionado bloco "Pre-flight: Date attribution" antes da Phase 0. Define `TARGET_DATE = yesterday` quando wrap-up corre entre 00:00–03:00; `TARGET_DATE = currentDate` nos outros casos. Propagado a Phase 3 (daily log lookup), Phase 4 (commit message), Phase 4c (change-log header). Resolve atribuição errada de daily log quando sessão passa a meia-noite.
