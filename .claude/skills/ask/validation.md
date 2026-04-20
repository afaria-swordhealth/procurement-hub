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
| 1 | Who is the primary QA/Regulatory contact at Sword? | | | — |
| 2 | What is the default Incoterm for CN suppliers? | | | — |
| 3 | Which project is Kaia Rewards blocked on decision-wise? | | | — |
| 4 | When was the last Ribermold chase sent? | | | — |
| 5 | What NDA Status is required before sending an RFQ with proprietary specs? | | | — |
| 6 | Who is the DHL contact? | | | — |
| 7 | What is the cost anchor % for quote-intake DB cost field writes? | | | — |
| 8 | Which suppliers are in the BloomPod shortlist scope? | | | — |
| 9 | What is the current Transtek Finance OI status? | | | — |
| 10 | Which action classes are tagged never_promote in the ledger? | | | — |
| 11 | When is the next Jorge 1:1? | | | — |
| 12 | What language must be used for emails to Sofia Lourenço? | | | — |
| 13 | What is the Sword Porto shipping address? | | | — |
| 14 | Which skill produces RISK signals into pending-signals.md? | | | — |
| 15 | What is the session-single concurrency model? | | | — |
| 16 | How many consecutive approved_clean decisions promote a class? | | | — |
| 17 | What is the difference between memory and lessons.md? | | | — |
| 18 | Which context file is the authoritative source for Pulse suppliers? | | | — |
| 19 | When was the last Layer 3 commit landed? | | | — |
| 20 | What skill handles the RFQ lifecycle end-to-end? | | | — |

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
