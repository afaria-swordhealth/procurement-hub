# Architecture Review — Token Optimization
# Prepared end of session 2026-04-13. To be implemented in dedicated session.

---

## Diagnóstico: Onde estão os tokens a ir

| Fonte | Peso estimado | Frequência |
|-------|--------------|------------|
| Warm-up: Gmail scan completo + Notion cross-ref por email | Alto | Diária |
| Warm-up: 3 context files carregados sempre | Médio | Diária |
| Warm-up: OI DB com Context completo (~30 OIs x log corrido) | Alto | Diária |
| Warm-up: Slack scan (DMs + canais + threads) | Alto | Diária |
| Wrap-up: Slack scan repetido | Alto | Diária |
| Wrap-up: Context sync queries 3 DBs sempre | Médio | Diária |
| Mail-scan cron: Notion cross-ref por cada email (x3-4/dia) | Alto | 2h |
| Cross-check: Gmail + Slack + Notion completo | Muito alto | Semanal |

---

## Princípios para a nova arquitectura

1. **Session-state é a fonte de verdade intra-dia.** Se está fresco, confiar completamente. Não reler o que já está lá.
2. **Delta sempre, full só quando necessário.** Scans a partir do último timestamp, não histórico completo.
3. **Lazy loading.** Só carregar o que a tarefa atual precisa.
4. **Crons silenciosos ficam silenciosos.** Sem Notion lookups em background jobs.
5. **Sincronização seletiva.** Só sincronizar projetos com actividade hoje.
6. **Projeções em queries.** `SUBSTR(Context, 1, 300)` em listagens. Context completo só quando se edita um OI específico.

---

## Mudanças por comando

### /warm-up — partir em dois modos

**Modo Light (padrão, session-state < 8h)**
Faz apenas:
- Ler session-state.md → mostrar carry-over + OIs overdue/due-today
- Gmail delta desde `Last-Mail-Scan` timestamp (não lookback fixo de 3 dias)
- Slack delta desde `Last-Warm-Up` timestamp (não scan completo)
- Verificar promises.md
- Calendário para hoje
- Output: briefing compacto

Não faz:
- ~~Ler context files~~
- ~~Query OI DB completa~~
- ~~Scan Gmail completo~~
- ~~Scan Slack completo~~

Tokens estimados: ~8-12k (vs ~40-60k atual)

**Modo Full (session-state > 8h OU segunda-feira OU `--full` flag)**
Comportamento atual mas com as outras otimizações aplicadas:
- OI query com `SUBSTR(Context, 1, 300)` em vez de Context completo
- Context files: só carregar se session-state > 24h
- Slack: só DMs directos + canais mais activos (não todas as threads)

Tokens estimados: ~25-35k (vs ~50-80k atual)

**Auto-detect:** ler `Last-Warm-Up` timestamp. Se < 8h → Light. Se >= 8h → Full.

---

### /wrap-up — remover o que é redundante

**Remover:**
- ~~Phase 0: Slack scan~~ — já foi feito no warm-up. Só adicionar se wrap-up corre >8h depois do warm-up (flag no session-state).

**Modificar:**
- Phase 2 Context Sync: só sincronizar projetos com entradas no `change-log.md` de hoje. Ler change-log primeiro, identificar projetos tocados, só então query as DBs relevantes.
- Phase 3 Daily Log: compilar a partir do change-log (já está lá tudo) em vez de re-ler Notion. Notion só para verificar se o log já existe.
- Phase 5 Summary: remover pending items da OI DB (já estão no session-state). Só mostrar o que foi feito hoje.

Tokens estimados: ~15-20k (vs ~40-50k atual)

---

### /mail-scan cron (silencioso, cada 2h) — tornar realmente silencioso

**Agora:** Gmail scan + Notion cross-ref por cada email encontrado.

**Depois:**
- Gmail scan apenas. Extrair: sender, subject, date, snippet.
- Zero Notion lookups.
- Notificar André só se novos emails encontrados (lista simples).
- Nenhuma criação de OI, nenhum draft, nenhum write.

O Notion cross-ref acontece quando André está presente e corre `/mail-scan` manual.

Tokens estimados por cron: ~2-3k (vs ~8-15k atual)

---

### /mail-scan manual — adicionar OI cross-check (fechar o gap)

Adicionar após cross-ref com Notion:
- Para cada email encontrado, query OI DB para supplier relevante: `WHERE Supplier LIKE '%name%' AND Status != 'Closed'`
- Se email parece resolver um OI aberto → propor fechar com resolução. Aguardar aprovação.
- Se email abre nova questão não documentada → propor criar OI.

Isto fecha o gap que André identificou esta noite sem custar tokens no cron silencioso.

---

### /log-sent cron — optimizar query

**Agora:** Para cada email sent, vai buscar a página individualmente ao Notion.

**Depois:** Query bulk: `SELECT Name, id FROM "SUPPLIER_DB" WHERE Name IN (list_of_names)` — uma query em vez de N fetches individuais.

---

### /cross-check — reduzir scope e frequência

**Remover:**
- ~~Phase 4: Project pages currency~~ — passar para housekeeping semanal.

**Adicionar:**
- Phase 0 (novo): OI vs email. Para cada OI aberto com owner André ou "waiting on external", pesquisar Gmail por emails do supplier nos últimos 14 dias. Sinalizar onde há evidência de resolução não registada.

**Frequência:** Semanal explícito (segunda ou quinta), não triggered automaticamente.

---

### /housekeeping — separar heavy de light

**Light checks (diário, folded no warm-up Light):**
- OIs overdue > 3 dias → já no briefing
- Promises vencidas → já no briefing

**Heavy checks (semanal, /housekeeping explícito):**
- Outreach condensation (>7 entradas visíveis)
- Notes compliance (formato, PT→EN)
- DB field hygiene
- Project pages currency (vem do cross-check)
- Context drift

---

## Mudanças no session-state.md

Adicionar dois campos novos:

```
## Projects Active Today
- M-Band (entradas no change-log: 6)
- Pulse (entradas: 0)
- Kaia (entradas: 1)
```

Usado pelo wrap-up para saber quais DBs sincronizar.

```
## OIs Touched Today
- 33fb4a7d (TransPak Nimbl): updated
- 33eb4a7d (GAOYI): closed
```

Usado pelo wrap-up para evitar re-query completa da OI DB.

---

## Mudanças nas queries Notion

Regra global a adicionar a `config/databases.md`:

```
## Query Efficiency Rules
- Listagem (warm-up, housekeeping, cross-check): SUBSTR(Context, 1, 300)
- Edição de OI específico: Context completo
- Context sync: só colunas necessárias (ver tabela por caller)
- Nunca SELECT * excepto para schema discovery
```

---

## Mudanças nos context files

**Agora:** Ficheiros grandes com todos os fornecedores incluindo Rejected.

**Depois:**
- Só fornecedores activos (Status != Rejected)
- Só campos que mudam: Status, Notes, last Outreach date, open OI count
- Adicionar header: `Active suppliers: N | Last meaningful change: YYYY-MM-DD`
- Rejected mantêm-se na DB do Notion, não nos ficheiros de contexto locais

Redução estimada: 40-60% do tamanho dos ficheiros.

---

## Ordem de implementação recomendada

1. **Session-state.md** — adicionar campos "Projects Active Today" e "OIs Touched Today". Baixo risco, alto impacto.
2. **Mail-scan cron** — remover Notion lookups. Mudança simples, impacto imediato (corre 4x/dia).
3. **Warm-up** — implementar auto-detect Light vs Full. Maior impacto de todos.
4. **Wrap-up** — remover Slack phase, adicionar context sync seletivo.
5. **OI query rule** — adicionar SUBSTR(Context, 1, 300) a databases.md.
6. **Context files** — refactor para remover Rejected + só campos activos.
7. **Mail-scan manual** — adicionar OI cross-check (fecha o gap).
8. **Cross-check** — remover Phase 4, adicionar Phase 0 OI vs email.
9. **Housekeeping** — separar light de heavy.

---

## Ganho estimado total

| Comando | Antes | Depois | Redução |
|---------|-------|--------|---------|
| Warm-up Light (uso mais comum) | ~50k tokens | ~10k tokens | -80% |
| Warm-up Full (1x/semana) | ~70k tokens | ~35k tokens | -50% |
| Wrap-up | ~45k tokens | ~15k tokens | -67% |
| Mail-scan cron (x4/dia) | ~10k tokens | ~2k tokens | -80% |
| **Total diário estimado** | **~130k** | **~35k** | **-73%** |
