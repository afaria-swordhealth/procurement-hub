---
name: "Supplier Prospection"
description: "Find and pre-screen new supplier candidates for a project. Builds a longlist from web search, applies elimination criteria, and creates Identified entries in Notion for candidates that pass. Use at the start of a new project or when the active shortlist needs fresh candidates."
---

# Supplier Prospection

Builds a longlist of supplier candidates from web research, applies project-specific elimination criteria, and creates Identified entries in Notion for candidates worth pursuing.

## Pre-flight

1. Read `outputs/session-state.md` for freshness.
2. Read `.claude/config/databases.md` (Supplier DB IDs per project).
3. Read `.claude/config/strategy.md` (Cost Analysis Rules — know baselines before evaluating candidates).
4. Read `context/{project}/suppliers.md` — understand who is already in the pipeline to avoid duplicates.

## Step 1: Define search parameters

Ask André (or infer from context):
- **Product:** specific product type, form factor, specs (e.g., "upper arm BP cuff, validated", "yoga mat 6mm TPE", "BLE wearable module")
- **Region preference:** CN / PT / EU / US — affects cost, lead time, regulatory path
- **Certification baseline:** what is the minimum acceptable certification for this project (see Step 2b)
- **Volume ballpark:** affects which suppliers are viable (small factory vs. tier-1)
- **Exclusions:** any supplier categories or regions to avoid

## Step 2: Qualification eliminators by project

### 2a. Pulse (BP cuffs, smart scales — medical devices)
**Hard eliminators (no exceptions):**
- No clinical accuracy validation data available
- Not CE marked or not FDA registered (depending on target market)
- No ISO 13485 or equivalent quality system

**Soft eliminators (flag, don't auto-reject):**
- First-time medical device supplier (no track record)
- MOQ > 10K units for initial run
- Lead time > 16 weeks production

### 2b. Kaia (yoga mats — consumer wellness)
**Hard eliminators:**
- No material safety certification (OEKO-TEX Standard 100 or equivalent)
- MOQ > 5K units for initial order
- Cannot produce sample within 4 weeks

**Soft eliminators:**
- No CE marking on product
- Limited customization capability (logo, color, thickness)
- Lead time > 12 weeks

### 2c. M-Band (wearable band components)
**Hard eliminators:**
- Component does not match BLE/electrical specs (voltage, form factor, connector)
- No RoHS / REACH compliance
- No FCC/CE certification for radio components

**Soft eliminators:**
- Minimum order commitment too high for prototype phase
- No SDK or technical support available
- Lead time > 10 weeks for samples

### 2d. BloomPod (coin cell batteries)
**Hard eliminators:**
- No IEC 60086 compliance
- No UN38.3 certification (required for air freight)
- Self-discharge rate outside spec

**Soft eliminators:**
- No safety certification beyond IEC minimum
- Operating temperature range doesn't cover product spec

## Step 3: Web search

Search for candidates using:
- `site:alibaba.com "{product type}" "{certification}"` — for CN manufacturers
- `"{product type}" supplier manufacturer EU` — for EU/PT options
- `"{product type}" ISO 13485 manufacturer` — for medical-grade options
- Trade directories: ThomasNet (US), Europages (EU), Global Sources (CN)

For each candidate found, collect:
- Company name, website, country
- Product categories listed
- Certifications mentioned on site or catalog
- MOQ and lead time if visible
- Any red flags (reseller not manufacturer, no technical docs, no English support)

## Step 4: Pre-screen and longlist

Apply hard eliminators from Step 2. Discard any candidate that fails a hard criterion.

For remaining candidates, present a longlist table:

```
PROSPECTION LONGLIST — {Project} — {Date}

| # | Supplier | Country | Product | Certifications | MOQ | Lead Time | Hard Pass? | Flags |
|---|----------|---------|---------|----------------|-----|-----------|------------|-------|
| 1 | ...      | CN      | ...     | ISO 13485, CE  | 5K  | 14w       | Yes        | —     |
| 2 | ...      | PT      | ...     | OEKO-TEX       | 1K  | 8w        | Yes        | new supplier |
```

## Step 5: André selects candidates to pursue

André reviews the longlist and marks candidates to advance (or rejects outright).

**For each candidate André approves:**

1. Check Notion Supplier DB — does this supplier already exist? (search by name/domain)
2. If not: propose creating an Identified entry.
   - **SHOW BEFORE WRITE.**
   - Fields: Name, Status = Identified, Region, Notes (1-line format: "TYPE (Location). Product. Source: prospection [date].")
3. Add domain to `.claude/config/domains.md` if a website is confirmed.
4. Log to `outputs/change-log.md`.

## Step 6: Store prospection in ruflo

- `key`: `prospection::{project}::{YYYY-MM-DD}`
- `namespace`: "procurement"
- `upsert`: true
- `tags`: ["prospection", project]
- `value`: `{ project, date, product_searched, candidates_found, candidates_approved, sources_used }`

## Rules

- Never create Notion entries without André's approval (SHOW BEFORE WRITE).
- Never contact a supplier during prospection. First outreach is André's to write personally.
- If a candidate is already in the Supplier DB (any status), flag it — do not duplicate.
- Prospection output is a longlist, not a recommendation. André decides who to pursue.
- Keep descriptions factual. Do not frame any candidate as "promising" or "ideal" — let the data speak.
