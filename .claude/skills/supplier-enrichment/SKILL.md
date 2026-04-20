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
- **Locked** — fields manually flagged by André (e.g., prefixed `[MANUAL]` in the field value). Never touch.

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

## First-run pair-work checklist

Before the first real run, André and Claude walk through together:

1. Confirm the Profile field allowlist against the actual Notion schema (schema may differ across the 4 DBs).
2. Save the confirmed list to `field-allowlist.md` in this directory.
3. Run on ONE safe supplier (suggest: a Rejected supplier, so an error has no live-flow impact) to validate the write path.
4. Review the change-log entry together.
5. Only after a clean first run: enable for active suppliers.

Until the pair-work checklist runs, the skill HALTs after Step 3 with: `First-run validation pending. Review data card, confirm Profile field allowlist, save to field-allowlist.md before writing.`
