---
name: "Ask"
description: "Read-only Q&A over the procurement corpus (change-log history, context, memory, knowledge, configs). Uses ruflo embeddings for semantic search. Returns synthesized answer with citations. Gated behind a 20-question validation harness — does not launch until accuracy bar is met."
---

# Ask

Semantic search + synthesis over procurement-hub project state. No writes, no Notion queries, no Gmail. Read-only by construction.

## Launch gate

Before the first user-facing run:

1. Read `.claude/skills/ask/validation.md`.
2. Count results:
   - `{validated}` = rows marked `PASS` in the harness
   - `{total}` = rows in the harness (target 20)
3. Launch rule: if `validated < 18` OR `total < 20` → HALT. Print:
   ```
   /ask not yet validated. Harness shows {validated}/{total} PASS.
   Run the validation pass: answer each question in validation.md,
   compare against the authoritative source, mark PASS/FAIL, and
   re-run /ask when ≥18/20 PASS.
   ```
4. If `validated ≥ 18` AND `total ≥ 20`: proceed to Pre-flight.

The gate protects against confidently wrong answers sourced from a misindexed or stale corpus.

## Pre-flight

1. Read `outputs/session-state.md` for freshness stamps (used as citation context).
2. Read `.claude/procedures/ask-index.md` to confirm index is built and fresh.
3. If index `Last rebuilt` > 48h ago: warn in answer header — "Index stale ({Nh}). Results may miss recent writes. Run index rebuild."
4. If index missing entirely: HALT. Output: "Index not built. Run `.claude/procedures/ask-index.md` build step before /ask."

## Step 1: Accept the question

Input: one natural-language question. No template. Examples:
- "When was the last time Ribermold was chased?"
- "What cost anchor did we use for Transtek Pulse v3?"
- "Which suppliers have NDA status still Pending?"

If the question is ambiguous (two valid interpretations), ask one clarifying question first. Do not search on a guess.

## Step 2: Embeddings search

Call `mcp__ruflo__embeddings_search`:
- `query`: the user's question (raw, no rewrite for first pass)
- `namespace`: "procurement-ask"
- `top_k`: 8
- `threshold`: 0.35

Returns a list of `{content, source, score, ts}`. Each `source` is a repo-relative path + line range (e.g., `context/pulse/suppliers.md:142-168`).

If zero results above threshold: lower threshold to 0.2 and retry once. If still zero: answer "No matches in the indexed corpus. The fact may live outside the index (Notion, Gmail) — those are not searched."

## Step 3: Synthesize answer

Rules:
- Answer in 1–5 sentences. Longer only if the question explicitly asks for a list or timeline.
- Every factual claim must cite a source from Step 2 as `{path}:{line}`.
- If results conflict (two sources disagree): surface the conflict, cite both, and name the more recent source as the current truth.
- If the top result's score is < 0.5: prefix the answer with `[Low confidence — top match score {N}].` and encourage the operator to verify.
- Never fabricate a citation. If a claim can't be sourced from Step 2 results, drop the claim.

## Step 4: Deliver + log

Output format:

```
{1-5 sentence answer with inline citations}

Sources:
- {path}:{line} (score {N})
- {path}:{line} (score {N})
```

Append one line to `outputs/change-log.md` under `### Hook events`:
```
[EVENT: ASK query="{first 60 chars of question}" top_score={N} sources={count}]
```

Do not log the answer body. The log is a signal, not a transcript.

## Rules

- Read-only. /ask never writes to Notion, Gmail, Slack, context/, or promises.md.
- The ledger is NOT consulted by /ask — autonomy-ledger decisions live in `/improve`.
- Index freshness is the operator's problem, not the skill's. If the answer seems wrong, check `ask-index.md` Last rebuilt.
- No cascading questions — one question, one answer, one return. Do not follow up with "want me to also look at X?"
- Do not quote more than 200 chars verbatim from a single source — paraphrase and cite.
- If the question references a supplier or project, the answer should include that entity name in Sources for quick verification.
- MCP error handling: ruflo embeddings failure → HALT with "Ruflo embeddings MCP unavailable. /ask cannot run." Do not fall back to keyword grep — that is a different tool.
