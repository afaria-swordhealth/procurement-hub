# Supplier Enrichment — Lessons Learned

Top-of-list lessons are pre-read by the skill (per `.claude/procedures/lessons-read.md`). Keep each entry to one line + a WHY + a rule link. Chronological, most recent first.

---

## 2026-04-21 — Zewa / Veridian acquisition missed for 18 months

**Lesson:** Always run `"{supplier_name}" acquisition OR acquired OR merger` WebSearch with 24-month scope before finalising the Profile.
**Why:** Veridian Healthcare acquired Zewa on 2024-09-04; trivially findable on PRNewswire. The first run (2026-04-20) framed Zewa as independent distributor, missing that RFQ silence likely mapped to post-acquisition integration.
**Rule:** Step 2 rule #2 (M&A / news check). Allowlist #8 (PRNewswire / BusinessWire / BioSpace).

## 2026-04-21 — Kimball certifications listed 3 sites instead of 7

**Lesson:** On a /certifications page with per-site matrix, never sample or summarize — capture every site and every cert exactly.
**Why:** Kimball had ISO 13485 at 7 sites + IATF 16949 at 6 sites. The first run named only 3 sites with cert numbers and dropped the rest. Reviewers reading the Profile would under-weight Kimball's regulatory footprint.
**Rule:** Step 2 rule #4 (cert list full-dump).

## 2026-04-21 — Crestline "None ISO" written as absolute negative

**Lesson:** Never write `None`, `No X`, or `Not applicable` as bare claims from a finite search. Scope to evidence: "No ISO certifications identified on public pages reviewed".
**Why:** Absence in the reviewed pages is not absence in the world. Crestline's original Profile wrote "None ISO" in a way that reads as an audited fact.
**Rule:** Step 2 rule #3 (absolute-negative framing).

## 2026-04-21 — Crestline ZIP wrote 04241 (PO Box) instead of 04240 (street)

**Lesson:** When two public sources disagree on a US ZIP, trust the street address sources (Yellow Pages, D&B, BBB) over LinkedIn. Dual-ZIP cities are common in US mailing.
**Why:** LinkedIn and Gemini both returned 04241 (PO Box ZIP); Yellow Pages + D&B + BBB all confirmed 04240 (street ZIP for 70 Mount Hope Ave).
**Rule:** Validate address-type fields against ≥2 non-LinkedIn sources when LinkedIn disagrees with website/registry data.

## 2026-04-21 — Zewa business model mislabelled as distributor-only

**Lesson:** Read the target's own About page before classifying business model. "Manufactured for X" language implies OEM sourcing but not distributor-only status.
**Why:** Zewa self-describes as "leading medical device manufacturer" and "product manufacturer and solutions provider". The first run wrote "US distributor — not a manufacturer", contradicting the target's own public identity.
**Rule:** Step 2 rule #1 (multi-page cross-check, minimum set includes /about).

## 2026-04-21 — Zewa FDA Owner/Operator 1417572 wrongly attributed

**Lesson:** Cross-check FDA Owner/Operator numbers on the FDA establishment DB directly — never trust a number inferred from context.
**Why:** The first run noted "Owner/Operator 1417572" as Zewa's. That number resolves to **Baxter Healthcare Corporation**. Writing a competitor's reg# into the Profile is a material error with audit consequences.
**Rule:** FDA fields — prose only, always source-verified. No inferred numbers.

## 2026-04-20 — Cerler /industries page missed, "no medical vertical" written

**Lesson:** On a company website, fetch /industries OR /markets OR /sectors before concluding a vertical is absent.
**Why:** Cerler's /industries page listed "Electromedicine" at position #6 of 10. The first run fetched /about + /history + /certificates + /overview and skipped /industries, then wrote "no medical vertical" as an absolute. Caught by user's Gemini cross-check.
**Rule:** Step 2 rule #1 (multi-page cross-check, minimum set includes /industries).

## 2026-04-20 — HQ conflict detection must include Notes DB property

**Lesson:** When checking if enrichment-discovered HQ conflicts with existing page data, compare against BOTH `## Contact` text AND the `Notes` DB property's parenthesized location.
**Why:** Crestline's `## Contact` was populated with "Cincinnati, OH" from intake, but the actual HQ is Lewiston, ME. A populated-means-correct heuristic would have hidden the error.
**Rule:** Step 3 rule (HQ conflict detection extended).

## 2026-04-20 — Pulse structured FDA fields are effectively irreversible

**Lesson:** Never write structured `FDA` / `Scale FDA Code` / `Scale FDA Status` select values via enrichment. Put FDA data in `## Profile` prose only.
**Why:** Structured FDA writes have audit consequences and are hard to undo. The prose path preserves the evidence without committing to a structured state change. Confirmed with André during Zewa pair-work run.
**Rule:** Step 3 — Pulse FDA structured fields rule.

## 2026-04-20 — Additive mode preserves human-curated narrative

**Lesson:** When a page has `## Company` or `## Capabilities` from human notes (e.g., sales-call intake), insert a new `## Profile` above them; do not merge or rename.
**Why:** Kimball's Mar 6 call produced structured `## Company` + `## Capabilities` blocks. Replacing them with enrichment prose would have destroyed first-party human content.
**Rule:** Step 1 — mode auto-detect (additive mode).
