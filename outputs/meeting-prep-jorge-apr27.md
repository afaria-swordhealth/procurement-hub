# Meeting Brief — Jorge Garcia 1:1 — Apr 27, 2026
<!-- Generated 2026-04-17. Read-only. -->

## Agenda
1. Status update: Pulse, Kaia, M-Band
2. Mind Incentive rewards (mask + stress ball)
3. Arrow USA vendor creation in Zip (#3134)
4. M-Band PO placement — componentes fora de prazo

---

## 1. PULSE

**Estado:** Qualificação em curso — Transtek + Unique Scales em paralelo.

### Esta semana (W16)
- Labeling clarificado: "Distributed by: Sword Health, Inc., 615 Gladiola St, Salt Lake City, UT 84104" — device sticker + color box. Correção enviada à Transtek Apr 17.
- QTA V0.2 enviado à Unique Scales para review.
- NDA Unique Scales iniciado com Legal (Bradley). Entidade Sword Health Inc. (US).
- SQA V0.2 (QMS-updated) enviado à Transtek.
- ISTA inquiry enviado a ambos os suppliers.

### Blockers internos (para levar ao Jorge)
| Blocker | Owner | Deadline | Estado |
|---------|-------|----------|--------|
| PLD model Legal/Finance alignment | Anand / Hugo / Aaron | Apr 17 ⚠️ overdue | Blocker para PO |
| Sarah Hamid — labeler classification | Sarah Hamid | Apr 22 | Blocker artwork |
| SCA Jira — Transtek | André → Bradley | Apr 17 ⚠️ overdue | Não aberto ainda |
| SCA Jira — Unique Scales | André → Bradley | Apr 17 ⚠️ overdue | Não aberto ainda |
| Transtek Finance (Zip #3139) | Rúben Silva | Apr 24 | Rúben OOO até Apr 20 |
| Unique Scales Finance (Zip #3145) | Rúben Silva | — | Aprovado, Rúben OOO até Apr 20 |

### Próximos passos antes de Apr 27
- SCA Jira para Transtek + Unique Scales (André)
- NDA Transtek Sword Inc. (André → Bradley)
- Artwork: aguarda classificação Sarah + die-lines revistas da Transtek

---

## 2. KAIA

**Estado:** Aguarda decisões Max Strobel.

- Max sample feedback overdue desde Apr 15 (Tiger, Second Page, ProImprint — amostras com Max desde Mar 17-30)
- Max fulfillment decision (Nimbl vs SV Direct) overdue Apr 17
- Reunião Max + Caio em Porto semana Apr 21 — todas as decisões Kaia dependem desta reunião
- Nenhuma ação de André até depois dessa reunião

---

## 3. M-BAND

### Housing
| Supplier | Estado | Próximo |
|----------|--------|---------|
| Ribermold | Meeting Apr 22 (magnetos, IP68, pin assembly) | Quote pós-reunião |
| Uartrónica | Re-quote esperada Apr 22 | Email enviado Apr 17 |
| JXwearable / SHX / Quantal | Ativos | Em follow-up |

### Componentes — RISCO CRÍTICO ⚠️

| Componente | Distribuidor | LT | Deadline PO para Q4 2026 | Estado |
|-----------|-------------|-----|--------------------------|--------|
| AMS-OSRAM AS7058A | Future Electronics (Beito) | 30 sem | **Apr 5 — 12 dias overdue** | Aguarda Beito |
| Nordic NPM1300 | Avnet (Sónia) | 23-25 sem | ~Maio | Sem stock Avnet |
| SFH7074 | Future Electronics | 16 sem | ~Jun | Pendente |
| TSL25853P | Future Electronics | 12 sem | ~Jul | Pendente |
| Bosch BMI270 | Future Electronics | TBD | Pré-alocação Q4 | Volume pendente |
| **Renesas** | — | — | **Jul 1: subida de preço** | Decidir antes de Jul 1 |

**Decisão a pedir ao Jorge:**
1. Podemos colocar PO para AMS-OSRAM sem confirmação final de BOM do Pedro Rodrigues?
2. Renesas — precisamos deste componente? Se sim, encomenda antes de Jul 1.

Manuel Beito resposta esperada Apr 22. Escalação ao Jorge se silêncio.

---

## 4. MIND INCENTIVE REWARDS

**Contexto:** Kit incentivo Mind (máscara + stress ball).

**Estado atual (Apr 16):**
- Vendor onboardado no Zip + ativo no NetSuite ✅
- SKUs em criação: MIND-M-01 (máscara) + MIND-SB-01 (stress ball) — Francisco + Tiago
- **Instrução Jorge (Apr 13):** ISC cria PO no NetSuite diretamente (não via Zip — são itens de inventário)

**Próximo passo:** Confirmar criação SKUs antes da 1:1. Quando SKUs ativos → ISC cria PO NetSuite.

---

## 5. ARROW USA (Zip #3134)

**Estado (Apr 17):**
- Jorge adicionou André como follower (11:09)
- João Linhares **aprovou** Zip #3134 às 15:33 ✅
- Pendente: Rúben Silva cria vendor record no NetSuite (Rúben OOO até Apr 20)
- Resolução esperada semana Apr 21

**Talking point:** Arrow aprovado, na fila do Rúben. Resolução semana Apr 21. Jorge precisa antes?

---

## Talking Points (síntese)

1. **Pulse:** qualificação a full speed, mas múltiplos blockers internos (PLD alignment overdue, SCA Jira por abrir, labeler classification pendente Sarah). Necessita visibilidade Jorge em Finance + Legal.
2. **Kaia:** tudo dependente de reunião Max/Caio Apr 21. Nada acionável até lá.
3. **M-Band:** risco de componentes é a escalação urgente — AMS-OSRAM já overdue 12 dias. Decisão sobre autorização parcial de PO sem BOM final.
4. **Mind Incentive:** SKU creation em curso, PO ISC quando SKUs ativos.
5. **Arrow USA:** aprovado, Rúben cria record semana Apr 21.

## NÃO DISCUTIR
- Targets de preço internos ou budget
- Posição dos suppliers no shortlist
- Forecasts de volume além do que foi partilhado com suppliers
- Quotes de outros suppliers
