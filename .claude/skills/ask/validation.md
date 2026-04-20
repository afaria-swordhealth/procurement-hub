# /ask Validation Harness

20-question accuracy harness. `/ask` does not launch until ≥18/20 are marked `PASS`.

**How to validate:**

1. For each question below: manually determine the correct answer by reading the cited source file directly.
2. Run the query through `/ask` (the skill will refuse to launch until this file is filled in — run the embeddings search manually via `mcp__ruflo__embeddings_search` with `namespace: "procurement-ask"` for validation passes).
3. Compare the returned answer + top citation to the expected answer + source.
4. Mark `PASS` only if: (a) the factual claim matches, AND (b) at least one top-3 citation points to the expected source file.
5. Any hallucinated source, wrong supplier name, wrong date, or wrong number = `FAIL`.

**CRITICAL STOP:** This file needs questions + expected answers authored by André before `/ask` can launch. Claude must not pre-fill "expected answer" fields by guessing from repo state — that defeats the validation. The questions below are templates; André fills in the expected answers column after index build.

---

## Questions

| # | Question | Expected answer (fill in) | Expected top source (fill in) | Result |
|---|---|---|---|---|
| 1 | Who is the primary QA/Regulatory contact at Sword? | Sofia Lourenço (Expert QSE). She is the single point of contact for QA/Regulatory (SQA, Qualio, FDA). Do NOT contact João Quirino or Bianca directly — Sofia escalates internally if needed. | `CLAUDE.md:19` (§2 Key People) + `.claude/config/strategy.md:114-120` (Escalation to Sofia) + memory `project_sofia_lourenco_qa.md` | — |
| 2 | What is the default Incoterm for CN suppliers? | FOB is the default for CN suppliers (EXW or FCA for EU/US). Destination defaults to Sword Porto unless André specifies otherwise. | `.claude/skills/rfq-workflow/SKILL.md:55-58` (Step 2c Delivery and timeline) | — |
| 3 | Which project is Kaia Rewards blocked on decision-wise? | All Kaia Rewards sourcing decisions are gated on Caio and Max (program owners/approvers). André does not advance Kaia suppliers unilaterally. | Memory `project_kaia_dependency.md` + `.claude/skills/risk-radar/SKILL.md:219` ("Kaia: sourcing gated on Caio/Max") | — |
| 4 | When was the last Ribermold chase sent? | UNKNOWN — needs André. Repo does not record outreach send dates for Ribermold (last known event is the Apr 15 clarification meeting; next touchpoint is the Apr 22 meeting per session-state). Ribermold OI `33eb4a7d…d871` references the Apr 22 meeting, not a chase. Authoritative answer requires Notion Outreach section. | — | — |
| 5 | What NDA Status is required before sending an RFQ with proprietary specs? | NDA Status must be `Signed` (Executed) or `Not Required` before sending an RFQ with proprietary specs. `In Progress / Sent` blocks the RFQ; `Not Started` redirects to supplier-onboarding Step 5. André may override only for non-proprietary RFQs (generic specs / public datasheets). | `.claude/skills/rfq-workflow/SKILL.md:34-41` (Step 1 NDA Status table) + `:142` (Rules) | — |
| 6 | Who is the DHL contact? | Catarina (Catarina Barbosa, Logistics Specialist) is the DHL contact. | `CLAUDE.md:20` (§2 Key People) + `.claude/config/slack-channels.md:18` | — |
| 7 | What is the cost anchor % for quote-intake DB cost field writes? | 30%. Pricing field updates (Unit Cost EUR, Tooling Cost EUR) auto-approve only when the computed EUR value is within 30% of the prior quote anchor in ruflo. Outside 30% → SHOW BEFORE WRITE; first-ever quotes (no anchor) also route to SHOW BEFORE WRITE. | `.claude/safety.md:28` (Exception 3) | — |
| 8 | Which suppliers are in the BloomPod shortlist scope? | Research-only shortlist candidates (not yet contacted): Varta (incumbent benchmark), Murata, Panasonic Energy, Renata (Swatch Group). Nexar lookup for MPN sourcing pending Pedro Rodrigues BOM (due 2026-04-24). No suppliers engaged yet — pre-sourcing scaffold. | `context/bloompod/suppliers.md:12-17` | — |
| 9 | What is the current Transtek Finance OI status? | Transtek Finance (Zip #3139): OI `33eb4a7d…9059` open with deadline Apr 24. João Linhares commented twice on bank documents Apr 17; Mika re-uploaded same day; André replying. Rúben OOO until Apr 20 (today). | `outputs/session-state.md:17` (Carry-Over) | — |
| 10 | Which action classes are tagged never_promote in the ledger? | Five classes: `cost_field_outside_30pct`, `supplier_status_rejected`, `nda_status_write`, `email_draft_send`, `slack_message_send`. Plus the autonomy.md hard-stop categories: any supplier-facing content, supplier status → Rejected, NDA Status field changes (except housekeeping "Not Required" on Rejected), price writes failing Exception 3, irreversible downstream effects (PO, vendor onboarding, budget). | `.claude/procedures/ledger-append.md:45-51` (action_class table) + `.claude/autonomy.md:46-56` (Hard stops) | — |
| 11 | When is the next Jorge 1:1? | 2026-04-20 at 12:00 (today), recurring Zoom. Confirmed against Google Calendar Apr 19; previous memory entry that said Apr 27 was wrong and was corrected. | Memory `project_jorge_11_apr20.md` + `outputs/session-state.md:48` | — |
| 12 | What language must be used for emails to Sofia Lourenço? | Portuguese. All Slack messages and emails to Sofia Lourenço must be written in Portuguese (same rule as Jorge Garcia). | Memory `feedback_sofia_portuguese.md` + `CLAUDE.md:104` (writing style: PT only for PT-supplier emails, Sofia, and Jorge) | — |
| 13 | What is the Sword Porto shipping address? | Sword Health — Porto Office. Av. de Sidónio Pais 153, Edifício A, Piso 5, 4100-467 Porto, Portugal. Contact André Faria, +351 910553788. Use for DHL labels, proforma invoices, supplier sample shipments. Commercial invoices to Sword SA (VAT 510675565). | Memory `reference_sword_porto_address.md` | — |
| 14 | Which skill produces RISK signals into pending-signals.md? | `risk-radar` (Step 6b). For each CRITICAL / HIGH / MEDIUM risk it appends a `[EVENT: RISK supplier=… project=… severity=… risk_type=…]` line to `outputs/pending-signals.md`. LOW severity stays report-only. Dedup by supplier+risk_type within 24h. `morning-brief` consumes the queue and applies `attention-budget.md`. | `.claude/skills/risk-radar/SKILL.md:178-191` (Step 6b) + `CLAUDE.md:34` (Layer 3 producers) | — |
| 15 | What is the session-single concurrency model? | One Claude session writes at a time. The system assumes a single active session and does not coordinate writes across concurrent sessions. If a second session opens while the first is active, treat it as read-only until the first closes (no Notion writes, no Gmail drafts, no context file writes). Read-only ops (queries, reports, /ping, /ask) are fine. The 10-minute collision guard from CLAUDE.md §4b is retired. | `.claude/safety.md:46-55` (Concurrency section) + `CLAUDE.md:12` | — |
| 16 | How many consecutive approved_clean decisions promote a class? | 20 consecutive `approved_clean` outcomes in the ledger for that class. Plus: zero `rejected` in last 50 outcomes AND zero `approved_edited` in last 20 outcomes AND class not tagged `never_promote`. Only André accepts the promotion — never auto-append to safety.md. | `.claude/autonomy.md:26-31` (Promotion rule) + `.claude/skills/improve/SKILL.md:51-54` | — |
| 17 | What is the difference between memory and lessons.md? | Memory = cross-skill, cross-session durable rules and operator profile (e.g., sign-off convention, Sofia in Portuguese). Lessons.md = per-skill correction history applied at that skill's pre-flight only (top 10, newest first). A correction that applies broadly → memory; a correction specific to one skill's output shape → that skill's lessons.md. When unsure, prefer memory and skip the lesson. | `.claude/procedures/lessons-read.md:80-89` (Relationship to memory and context) | — |
| 18 | Which context file is the authoritative source for Pulse suppliers? | `context/pulse/suppliers.md`. CLAUDE.md §4d Global Pre-flight requires loading the relevant `context/{project}/suppliers.md` for any email or supplier-facing work. Notion is the live system of record; the context file is the local synced view used for fast in-session reads. | `CLAUDE.md:61` (§4d) + `context/pulse/suppliers.md:1-2` | — |
| 19 | When was the last Layer 3 commit landed? | Commit `025e6de` — "Layer 3 — System owns the clock (proactive loop scaffolding)" — landed 2026-04-20 08:33 +0100. Shipped scaffolding + skill + producer wiring (pending-signals.md, attention-budget.md, morning-brief skill, risk-radar Step 6b). Cron redesign and promises.md retirement deferred. | git log commit `025e6de` + `outputs/change-log.md:113-140` (Layer 3 section) | — |
| 20 | What skill handles the RFQ lifecycle end-to-end? | `rfq-workflow`. Pipeline from NDA completion to RFQ email draft and response tracking: validates NDA status, assembles RFQ package (specs + volume tiers + Incoterms + standard quote items), drafts email per audience rules (CN simple English, PT Portuguese), logs the outreach milestone, creates response-tracking OIs. Use after supplier onboarding when ready to request quotes. | `.claude/skills/rfq-workflow/SKILL.md:1-7` + `.claude/commands/skills.md:20` | — |

---

## Process for André

Before running `/ask` for the first time:

1. Build the index per `.claude/procedures/ask-index.md`.
2. Fill in columns 3 and 4 for each row above.
3. Run each question through `mcp__ruflo__embeddings_search` + manual synthesis OR run `/ask` (if launch gate is lifted by a temporary override).
4. Mark `PASS` / `FAIL` in column 5.
5. If `PASS` count ≥ 18, `/ask` launches. If < 18, surface failing rows — they indicate either missing content in the corpus, bad chunking, or ambiguous questions. Fix the underlying issue (re-index, reword question) and re-test.

## Re-validation

- Re-run the harness whenever the index is rebuilt from scratch (not on incrementals).
- If any row flips to FAIL after a rebuild: HALT `/ask` until investigated.
- Harness row count can grow over time — if new failure modes emerge, add questions that cover them.

## Pass/fail log

Append one line to this file at the bottom on each full validation:

```
{YYYY-MM-DDTHH:MM} | {pass}/{total} | index_rebuild_ts={ts} | notes=...
```

## Current state

**Not yet validated.** `/ask` is disabled until this harness is filled in and ≥ 18/20 PASS.

## Hybrid fill — 2026-04-20

Pre-filled by Claude per André's approval. Rows filled: 19/20. Rows marked UNKNOWN (needs André): 1/20.

André: spot-check the rows. Flip Column 5 to FAIL if any answer is wrong; flip to PASS if correct; leave — for skip. Re-save the file when done. The `/ask` launch gate checks PASS count ≥ 18.
