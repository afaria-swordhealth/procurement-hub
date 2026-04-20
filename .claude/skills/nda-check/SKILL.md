---
name: "NDA Check"
description: "Compare a supplier-drafted or supplier-redlined NDA against the Sword Health standard. Flag clause deltas (term, governing law, IP ownership, non-solicit, scope), suggest a routing decision for Bradley, and produce a one-page diff for André. Read-only — never edits Notion, Zip, or email."
---

# NDA Check

Compares supplier NDA text against the Sword standard clauses documented in `.claude/knowledge/nda-process.md`. Produces a clause-by-clause delta and a routing suggestion (proceed, redline, escalate to Bradley). No writes. No legal advice — this is a triage aid for André + Bradley.

## Pre-flight

1. Read `outputs/session-state.md` for freshness.
2. Read `.claude/knowledge/nda-process.md` — canonical Sword NDA process, platform, status field values, IP-sensitivity guidance per project.
3. Read `.claude/config/strategy.md` §5 (escalation criteria — Bradley path).
4. Read the supplier context for the project if referenced: `context/{project}/suppliers.md` (status, NDA Status, project).
5. **Lessons read:** per `.claude/procedures/lessons-read.md`, read `.claude/skills/nda-check/lessons.md` (top 10). Apply before producing the diff. If missing or empty, skip.

## Inputs

The skill accepts any of:

- Pasted NDA text (supplier-provided or supplier-redlined Sword template)
- A path to a local file (`.docx`, `.pdf`, `.txt`) — if a PDF, route to André with a note; this skill does not itself OCR
- A supplier name + project — in which case the skill reports "NDA text not provided" and asks André to paste or attach

If the input is not text, HALT and ask André for a pasted version. Do not guess clauses from filenames.

## Step 1: Identify the reference standard

The Sword standard NDA lives in Zip. Claude cannot fetch it. Use the documented expectations from `.claude/knowledge/nda-process.md` + the following canonical clause checklist as the reference:

| Clause | Sword expectation | Why it matters |
|---|---|---|
| Term | 2–3 years from execution | Matches §NDA expiry and renewal |
| Governing law | Portugal or Delaware (Sword Inc.), depending on contracting entity | Pulse PLD uses Sword Inc. as importer; other projects default to Portugal |
| Confidential information definition | Covers clinical data, firmware/algorithms (Pulse), SDK (M-Band) | Pulse has clinical IP; M-Band has SDK IP |
| Permitted use | Evaluation and RFQ response only — no manufacturing, no resale | Prevents supplier from using specs for competing products |
| IP ownership | Sword retains all IP; no license granted by disclosure | Critical for firmware and device design |
| Non-solicit (employees) | 12 months post-termination | Standard |
| Non-compete | Sword does NOT ask suppliers for non-compete | Redline if supplier inserts one |
| Residuals clause | Sword does NOT accept residuals carve-out | Common supplier redline — always push back |
| Injunctive relief | Both parties entitled | Standard |
| Mutual vs unilateral | Mutual (Sword also discloses product plans) | Prevents one-sided protection |
| Termination | Either party, 30 days written notice | Standard |
| Survival | Confidentiality survives termination, minimum 3 years | Standard |

If the project is Pulse, add clinical-data and firmware clauses to the "must-have" list.
If the project is M-Band, add SDK and BLE-protocol clauses to the "must-have" list.
If the project is Kaia or BloomPod, the standard list above is sufficient.

## Step 2: Parse the supplier NDA

Scan the provided text for:

1. **Party names** — confirm the supplier legal entity matches `context/{project}/suppliers.md` Profile section. Flag mismatches (e.g., parent company signing vs. operating entity).
2. **Defined terms** — `"Confidential Information"`, `"Disclosing Party"`, `"Receiving Party"`, `"Affiliate"`, `"Purpose"`.
3. **Clause boundaries** — detect each clause from the reference checklist. Quote the exact supplier wording.
4. **New clauses not in the reference list** — flag every one. Common additions: data localization, audit rights, flow-down obligations, third-country restrictions.

Do not paraphrase supplier wording in the diff. Quote it verbatim so Bradley can assess.

## Step 3: Clause-by-clause delta

Produce a table:

| Clause | Sword expectation | Supplier wording (quoted) | Delta | Suggested action |
|---|---|---|---|---|
| Term | 2–3 years | `"five (5) years from Effective Date"` | +2 years | Redline to 3 years OR accept if supplier requires longer |
| Governing law | Portugal | `"Laws of the People's Republic of China"` | Jurisdiction mismatch | Redline to Portugal. Flag to Bradley — CN jurisdiction is a blocker unless Bradley approves. |
| Residuals | None | `"Residuals exception — general knowledge retained"` | New clause | Redline out. Sword never accepts residuals. |
| Non-compete | None | — | Not present | OK |

For each row, classify the delta into one of:

- **OK** — matches or is acceptable
- **Redline** — must push back; Sword standard language available
- **Escalate** — legal judgment required; route to Bradley
- **Blocker** — supplier must change this before Sword will sign (jurisdiction mismatch, residuals acceptance, term >5y, IP assignment to supplier, mandatory arbitration in supplier jurisdiction)

## Step 4: Routing recommendation

Based on the delta counts:

| Signal | Recommended routing |
|---|---|
| 0 Blockers, 0 Escalates, ≤2 Redlines | Proceed to Bradley with redlines marked — standard Zip submission, 5–10 bd |
| 1–2 Escalates | Bradley review required before response — surface in next 1:1 or Slack DM in PT |
| Any Blocker | Do NOT counter-sign. Surface to André with a draft note to Bradley explaining what must change |
| Supplier used their own template (not Sword's) | Per `nda-process.md`: "bring to Bradley, do not agree unilaterally". Always escalate |

Output the recommendation as a 3-line paragraph, not a bullet list. Bradley gets enough unstructured text already — give him a sentence, not a form.

## Step 5: Present to André

```
NDA CHECK — [Supplier] / [Project] — [date]

Source: [pasted text | supplier-redlined Sword template | supplier-own template]
Party match: [✓ matches Profile | ✗ Profile shows {X}, document shows {Y}]

DELTA TABLE:
[table from Step 3]

BLOCKERS: [count]
ESCALATES: [count]
REDLINES: [count]

RECOMMENDATION:
[3-line paragraph from Step 4]

SUGGESTED NEXT STEP:
[one of:]
  - Submit to Bradley via Zip with the redlines above
  - Slack Bradley (PT) summarising the Blockers before Zip submission
  - Ask supplier to use Sword's template instead — their version has [X] material deviations
  - Decline — term/jurisdiction/IP issue is a hard no
```

Always show the full delta table, even when every row is OK. Bradley benefits from seeing what was checked, not just what failed.

## Step 6: Log

Log to `outputs/change-log.md` under today's date:

```
### NDA check — {Supplier} ({project})
- Source: {pasted | file | template-return}
- Blockers: {N} | Escalates: {N} | Redlines: {N}
- Recommendation: {one-line summary}
- Routing: {Bradley via Zip | Slack PT | return template | decline}
```

Also append `[EVENT: NDA_CHECK supplier={slug} project={project} blockers={N} redlines={N} recommendation={tag}]` above the prose entry (per L1 event-log schema).

No Notion write. No Zip submission. No NDA Status field change. Those are André's actions after Bradley responds.

## Rules

- NEVER propose red-lined counter-text in the output. This skill triages; Bradley writes the redlines.
- NEVER contact the supplier directly. Any response goes through André.
- NEVER update the supplier's NDA Status field in Notion. That is a §5 Level 2 write, done manually after Bradley approves.
- NEVER include raw URLs in any output; embed per writing-style.md.
- If the text looks auto-translated or machine-generated (stilted phrasing, unusual capitalisation), flag it — translation drift can change clause meaning.
- Sofia Lourenço is looped **only** if the supplier NDA includes QARA-specific terms (LoE ownership, regulatory file access, Qualio sharing). Do not loop her on standard legal clauses.
- Portuguese suppliers: output remains in English (André reads it; Bradley reads it). Any note to Jorge is in Portuguese (memory: `feedback_jorge_portuguese.md`).
