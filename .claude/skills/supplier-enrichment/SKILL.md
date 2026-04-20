---
name: "Supplier Enrichment"
description: "Enrich a supplier's Notion Profile fields via web search over an allowlist (company website, LinkedIn, ISO/FDA/EU registries). Proposes a data card, André approves/edits, then writes approved fields to Notion. André fills any gaps Claude cannot find. Use after first contact to fill missing Profile metadata."
---

# Supplier Enrichment

Web-search based enrichment for supplier Profile fields on Notion supplier pages. Goal: reduce André's manual data-entry on Profile blocks (legal entity, ISO certs, FDA registration, parent company, HQ address, employee range, founded year) while preserving approval control.

**Write path:** Notion `notion-update-page` on the supplier page's Profile fields only. Never touches Contact, Quote, Outreach, or Open Items blocks.

---

## Pre-flight

1. Read `outputs/session-state.md` for freshness.
2. Read `.claude/config/databases.md` (Supplier DB schemas per project).
3. Read `.claude/config/strategy.md` §6 (supplier qualification criteria — what enrichment unlocks).
4. Read the supplier's existing Notion page to see which Profile fields are already populated.
5. **Lessons read:** per `.claude/procedures/lessons-read.md`, read `.claude/skills/supplier-enrichment/lessons.md` (top 10). Apply before running searches. If missing or empty, skip.

---

## Inputs

- `/supplier-enrichment {supplier_name}` — required. Matches exactly against one of the 4 Supplier DBs.
- Optional: `--project {pulse|kaia|mband|bloompod}` — disambiguates if the same supplier name exists across DBs.
- Optional: `--fields {list}` — restricts enrichment to a subset (default: all Profile fields).

If supplier not found in any DB, HALT: "Supplier `{name}` not found. Create the Notion page first, then re-run."

---

## Step 1: Identify fields to enrich

Pull the current Profile block state. Classify each field as:

- **Empty** — candidate for enrichment.
- **Populated** — skip unless `--fields` includes it with explicit override.
- **Locked** — fields manually flagged by André with `[MANUAL]` prefix in the field value. Never overwrite. **Contradiction rule (added 2026-04-20):** if enrichment finds evidence that contradicts a `[MANUAL]` field (e.g., locked HQ says Lisbon but website + registry say Porto), do NOT overwrite — instead surface the conflict in the data card as a separate line: `⚠ LOCKED field '{name}' has value '{current}' but evidence suggests '{proposed}' from {source}. Review manually.` André then updates (or removes the lock) in Notion directly.

**Mode auto-detect (added 2026-04-20):** decide write mode per section heading, not globally:

- If the page has `## Profile` → **replace mode**: rewrite the `## Profile` section body with the enriched prose block. Do not touch any other section.
- If the page has no `## Profile` but has `## Company` / `## Capabilities` (Kimball-style M-Band convention) → **additive mode**: insert a new `## Profile` section between `## Contact` and the first existing company block. Preserve the human-curated `## Company` / `## Capabilities` verbatim.
- If the page has neither → **insert-after-Contact mode**: add `## Profile` immediately below `## Contact`.

Canonical heading is always `## Profile`. Never rename existing `## Company` or `## Capabilities` blocks.

Target Profile fields (subject to confirmation with André on first run — see §Rules):

| Field | Type | Source priority |
|---|---|---|
| Legal entity | text | Company website > EU/PT company registry > SEC EDGAR > LinkedIn |
| HQ address | text | Company website > LinkedIn > registry |
| Country | select | Derived from HQ address |
| Founded year | number | Company website > LinkedIn > Wikipedia |
| Employee range | select | LinkedIn > company website |
| Parent company | text | SEC EDGAR > company website > news sources |
| ISO certifications | multi-select | ISO registries (IAF CertSearch) > company website quality page |
| FDA registration number | text | FDA Establishment Registration DB (Pulse only) |
| CE marking | checkbox | Company website > EU registry (M-Band / BloomPod only) |
| Website URL | url | Derived from outreach domain in `config/domains.md` |

If the field set on the Notion page differs from the table above: HALT on first run and ask André to confirm the write list. Save the confirmed list to `.claude/skills/supplier-enrichment/field-allowlist.md` for subsequent runs. Do not invent fields.

---

## Step 2: Run web searches

**Allowlist** (hard-coded — do not expand without André approval):

1. Official company website (extracted from `config/domains.md` or supplier's email domain).
2. LinkedIn company page (`linkedin.com/company/{slug}`).
3. SEC EDGAR (US public parents).
4. EU/PT company registry (Portal da Empresa, EU Business Register).
5. IAF CertSearch + national ISO certification registries.
6. FDA Establishment Registration DB (Pulse device suppliers only).
7. Wikipedia (corporate history only — never for technical claims).
8. **PRNewswire + BusinessWire + BioSpace** (M&A / press releases, 24-month window — added 2026-04-21).

**Not allowed:**
- Generic news aggregators without attribution.
- Scraping LinkedIn personal profiles.
- Competitor intelligence sites (e.g., Crunchbase paid data, Bloomberg terminals — no access anyway).
- Any site the supplier has not made public.

Execute searches via `WebSearch` with queries shaped per field. Examples:
- `"{supplier_name}" legal entity site:{supplier_domain}`
- `"{supplier_name}" ISO 13485 certificate`
- `{supplier_name} FDA establishment registration`
- `{supplier_name} headquarters site:linkedin.com`
- `"{supplier_name}" acquisition OR acquired OR merger` (M&A check — always run)

### Research rigor rules (added 2026-04-21, after Crestline/Kimball/Zewa/Cerler retrospective)

Four mandatory rules — failing any of these on a run means re-running Step 2 before presenting the data card:

1. **Multi-page cross-check (minimum set).** On a company website, fetch at minimum: `/about` + `/history` OR `/company` + `/industries` OR `/markets` + `/certifications` OR `/quality` + `/products` OR `/solutions` + `/contact`. Never conclude from a subset. Missed case: Cerler — read /certificates-awards + /contact + /history + /overview but skipped /industries, then wrote "no medical vertical" as an absolute. `/industries` listed Electromedicine at position #6.
2. **M&A / news check.** Always run one M&A query on WebSearch with 24-month scope. Consult PRNewswire / BusinessWire / BioSpace / respiratory-therapy / medicalbuyer hits. Missed case: Zewa — Veridian Healthcare acquired Zewa 2024-09-04, trivially findable on PRNewswire. 18 months of stale company framing missed.
3. **Absolute-negative framing.** Never write `None`, `No X`, `Not applicable`, or `Independent` as bare absolute claims from a finite search. Always scope to evidence: `No X identified on public pages reviewed`, `No parent disclosed in reviewed filings`, etc. Missed case: Crestline — wrote "None ISO" based on absence, when the correct phrasing is absence-of-evidence.
4. **Cert list full-dump.** When a certifications / quality page exists, capture the ENTIRE per-site matrix, not a summary sampled from /overview or /about. If a public cert number (PDF/registration number) is surfaced, include it. Missed case: Kimball — had ISO 13485 at 7 sites + IATF 16949 at 6 sites, but write only named 3 sites. Also missed FDA Registered multi-site.

Apply these before presenting the data card. If any rule fails, halt and re-run Step 2 with the missing fetch.

For each finding, capture `{field, value, source_url, confidence}`. Confidence tiers:
- **High** — from the company's own website or a registry.
- **Medium** — from LinkedIn or Wikipedia.
- **Low** — inferred or single-source third-party.

Never write `confidence: Low` findings without explicit André approval.

---

## Step 3: Propose the data card to André

Present one table. No writes yet.

```
SUPPLIER ENRICHMENT — {supplier_name} ({project})
Scanned {N} sources. Found values for {M}/{total} fields.

| Field | Current (Notion) | Proposed | Source | Confidence |
|---|---|---|---|---|
| Legal entity | (empty) | Transtek Medical Co., Ltd. | transtekcorp.com/about | High |
| HQ address | (empty) | Zhongshan, Guangdong, CN | transtekcorp.com/contact | High |
| Founded year | (empty) | 1999 | linkedin.com/company/transtek | Medium |
| ISO certifications | (empty) | ISO 13485:2016, ISO 9001 | IAF CertSearch | High |
| FDA registration | (empty) | 3005123456 | FDA establishment DB | High |
| Parent company | (empty) | — not found — | — | — |
| Employee range | (empty) | 501–1000 | linkedin.com/company/transtek | Medium |
| CE marking | (empty) | N/A for Pulse project | — | — |

Missing fields for André to fill manually: Parent company.

Respond with: approve | approve_with_edit {field: new_value, ...} | reject.
```

Apply `.claude/procedures/typed-edit-payloads.md` for the approval gate — `approve_with_edit` accepts per-field overrides. High-risk fields (require echo-back confirm if edited): `legal entity`, `FDA registration`, `HQ address override` (when the enrichment proposes changing an already-populated `## Contact` HQ value — this crossed the skill boundary on the Crestline first run 2026-04-20 and required a case-by-case exception; the override now lives as a typed-edit field so future HQ corrections don't need ad-hoc approval). Low-risk (apply directly): everything else.

**HQ address override semantics:** if the enrichment finds a canonical HQ that conflicts with the existing `## Contact` value, surface the diff in the data card with both "current" and "proposed" shown side-by-side. Only when André passes `approve_with_edit {hq_override: true}` does the skill also rewrite the `## Contact` city/state line and the `Notes` DB property's parenthesized location if present. Without `hq_override: true`, the skill writes only the `## Profile` block and flags the `## Contact` / `Notes` mismatch for manual resolution.

**HQ conflict detection (extended 2026-04-20, lesson from Crestline):** do not trust `## Contact` as authoritative when checking for conflicts. Always compare the enrichment-discovered HQ against BOTH `## Contact` text AND the `Notes` DB property's parenthesized location (e.g., `RESELLER (Cincinnati, OH)`). If the discovered HQ differs from either, surface as a conflict even when `## Contact` is populated. Intake-stage city errors cannot be caught by a "populated means correct" heuristic.

**Pulse FDA structured fields (added 2026-04-20, lesson from Zewa):** while Option C (schema extension) is deferred, the skill writes FDA information as prose in `## Profile` ONLY. Never touch the structured `FDA`, `Scale FDA Code`, or `Scale FDA Status` select fields — those remain André-managed. FDA 510(k) numbers, establishment registration numbers, and product codes go into the `## Profile` Regulatory line. Reason: structured FDA writes are effectively irreversible for audit purposes; the prose path preserves the evidence without committing to a structured state change.

**Region enrichment (added 2026-04-20):** Region is a coarse proxy for Country per the per-DB option list (see `field-allowlist.md`). Write `Region` only when empty, and only when the discovered HQ maps unambiguously to one of the DB's select options. Never invent a Region outside the DB's option list. Never overwrite a populated Region.

---

## Step 4: Write to Notion

After André approves (possibly with edits):

1. For each approved field, call `notion-update-page` on the supplier page. Update the Profile block fields only.
2. For fields André marked as manual gaps in his reply: do not write — he will fill them in Notion directly. Note them in the change-log entry.
3. Add a Notion page comment on the supplier page: `Profile enriched via /supplier-enrichment. {M} fields written from {N} sources. Manual gaps: {list}.` (auto-approved per CLAUDE.md §5 Exception 2.)
4. Log to `outputs/change-log.md`:
   ```
   [EVENT: SUPPLIER_ENRICH supplier={name} project={p} fields_written={M} manual_gaps={K}]
   ### Supplier enrichment — {name}
   - Fields written: {list with values + sources}
   - Fields left for André: {list}
   - Sources consulted: {N}
   ```

5. Store enrichment outcome in ruflo memory:
   - `key`: `enrichment::{supplier_slug}::{YYYY-MM-DD}`
   - `namespace`: "procurement"
   - `tags`: ["enrichment", project, supplier_name]
   - `value`: `{ fields_written, sources, confidence_mix, manual_gaps }`

---

## Rules

- **Never write fields that don't exist in the Supplier DB schema.** If the field is missing, surface it to André and stop.
- **Never overwrite a populated field** unless André explicitly passes `approve_with_edit {field: new_value}` for that field.
- **Never write `confidence: Low` findings without explicit approval.**
- **Never invent a value when the search returned no result.** Mark as "not found" and pass to André.
- **SHOW BEFORE WRITE** applies to the full data card. Per-field approval is captured inside the typed-edit payload.
- **No Gmail scan, no Notion Profile writes outside the confirmed field allowlist, no Zip / Jira interaction.** This skill is scoped to Profile fields only.
- Do not enrich suppliers in Rejected / Archived status unless André passes `--force`.
- MCP failure handling: if `WebSearch` fails, continue with fewer sources — don't halt. If `notion-update-page` fails mid-write, log which fields succeeded vs. failed and present the failures for retry.
- Respect the allowlist strictly. Any site outside §Step 2 allowlist → do not fetch. Ask André to add it to the allowlist explicitly (append to this SKILL.md with his approval).

---

## First-run pair-work — COMPLETE (2026-04-20)

Checklist closed. Three validation runs executed on Rejected suppliers:

1. **Crestline (Kaia)** — empty-Profile baseline. Discovered HQ intake error (Cincinnati → Lewiston). Led to `HQ address override` typed-edit field + HQ conflict detection rule extension.
2. **Kimball (M-Band)** — populated-Profile edge case with human-curated `## Company` / `## Capabilities`. Validated additive mode.
3. **Zewa (Pulse)** — FDA-field interaction. Validated structured Pulse FDA fields stay untouched; prose-only in `## Profile`.

Field allowlist confirmed in `field-allowlist.md` — Options A (structured Website/Region where empty) + B (`## Profile` prose) are canonical. Option C (schema extension) deferred.

**Skill is now ACTIVE for live suppliers** in any Status — not just Rejected. Normal rules still apply (SHOW BEFORE WRITE, allowlist enforcement, contradiction rule on `[MANUAL]` fields, HQ conflict detection).

## Post-first-run retrospective — COMPLETE (2026-04-21)

Gemini + 3 internal review agents double-checked all 4 runs (Crestline, Kimball, Zewa, Cerler). Convergent errors found in all 4. Corrections written back to Notion 2026-04-21. Four research-rigor rules added to Step 2 (multi-page cross-check, M&A/news check, absolute-negative framing, cert list full-dump). Allowlist extended with PRNewswire + BusinessWire + BioSpace for M&A events. Case studies captured in `lessons.md`.
