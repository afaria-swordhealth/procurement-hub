---
name: "Supplier Onboarding"
description: "End-to-end checklist for adding a new supplier to the system: Notion page, domain config, context file, NDA tracking, first outreach prep. Use when a new supplier is identified and needs to be set up across all tools before first contact."
---

# Supplier Onboarding

Adds a new supplier to the procurement system. Creates the Notion page, registers the domain, updates context, handles NDA, and prepares the context package for Andre's first outreach.

## Pre-flight

1. Read `outputs/session-state.md` for freshness. If warm-up < 2h, use snapshot.
2. Read `.claude/config/databases.md` (DB IDs, schemas, query patterns).
3. Read `.claude/config/domains.md` (current domain table for duplicate check).
4. Read `context/{project}/suppliers.md` for the relevant project.
5. Read `.claude/config/writing-style.md` (for outreach prep).
6. Read `.claude/config/strategy.md` (negotiation guardrails for context package).

## Step 0: Validate — supplier does not already exist

Before creating anything, check for duplicates:

```sql
SELECT Name, Status, Notes, id, url
FROM "{SUPPLIER_DB}"
WHERE Name LIKE '%{supplier_name}%'
```

Run against the target project's Supplier DB (IDs in `config/databases.md`). Also check the other two DBs if the supplier could be cross-project.

Check `config/domains.md` for the domain. If the supplier or domain already exists, STOP and report to Andre with the existing page URL.

## Step 1: Collect supplier info from Andre

Required: company name (EN), domain(s), contact name + email, region (CN/PT/US/DE/etc.), project (Pulse/Kaia/M-Band), part category. Optional: source (how found), NDA needed (default: Yes for CN manufacturing).

## Step 2: Create Notion page in Supplier DB

Use `notion-create-pages` in the correct DB (from `config/databases.md`).

### DB fields to set

| Field | Value |
|-------|-------|
| Name | Company name |
| Status | `Identified` |
| Region | As collected |
| Currency | By region: CN = RMB, US = USD, PT/DE = EUR |
| NDA Status | `Not Started` or `Not Required` |
| Notes | Per format: "TYPE (Location). Product + key differentiator. Flag." Max 2 lines. |

### Page body template

Five H2 sections in order: `## Contact` (table: Role, Name, Email, Phone), `## Profile` (company, location, part category, source, website), `## Quote` ("No quotes received yet."), `## Outreach` (empty), `## Open Items` (linked DB view of OI DB filtered by supplier, never inline bullets per CLAUDE.md rule 8).

**SHOW BEFORE WRITE.** Present the full page to Andre before creating.

## Step 3: Add domain to config/domains.md

Add one row per domain to the relevant project table:

```
| {domain} | {supplier_name} | Identified |
```

If the supplier has alt domains (e.g. andmedical.com for A&D), add each on its own row with `(alt domain)` in Status.

Also update the Gmail filter pattern for that project section in `domains.md` to include the new domain.

## Step 4: Add entry to context/{project}/suppliers.md

Add a new entry following the existing format in that file. Include: name, status, contact, key notes, "Added YYYY-MM-DD".

## Step 5: NDA handling

- **NDA needed:** Create OI `{Supplier} — NDA execution`. Andre submits via Zip (https://swordhealth.ziphq.com) with supplier legal name, email, country. OI deadline: submission + 10 biz days.
- **Not needed:** Set NDA Status = "Not Required" in DB.
- **Unsure:** Flag for Andre. Default "needed" for CN manufacturing.

## Step 6: First outreach — context package only

**Andre writes the first outreach email personally** (CLAUDE.md Level 2 rule). This skill prepares the context package, never drafts the first email.

Context package for Andre:

1. **Supplier snapshot:** name, location, part category, website, key differentiator
2. **What to request:** specs alignment, MOQ ranges, lead times, certifications
3. **Audience rule:** CN = simple English, PT = Portuguese, US = standard English (from `config/writing-style.md`)
4. **Strategy notes:** what NOT to share (from `config/strategy.md`): no pricing from other suppliers, no internal timelines, no shortlist status
5. **Specs reference:** Google Drive link to relevant specs doc (if known)

## Step 7: Create Open Items

Create OIs per `procedures/create-open-item.md` (all 7 fields required). **SHOW BEFORE WRITE.**

**OI 1 (if NDA needed):** `{Supplier} — NDA execution` | Pending | Action Item | Owner: Andre (or `Andre -> Bradley / Legal`) | Deadline: submission + 10 biz days | Context: why NDA is needed, Zip submission status.

**OI 2:** `{Supplier} — first outreach follow-up` | Pending | Action Item | Owner: Andre | Deadline: outreach date + 5 biz days | Context: what was sent, part category, expected response.

## Step 8: Log to change-log.md

```
YYYY-MM-DD HH:MM | supplier-onboarding | Created {supplier} in {project} DB | Page: {url} | Domain added | Context updated | OIs: {list}
```

## Rules

- NEVER send emails. Gmail draft only (Level 1 safety).
- SHOW BEFORE WRITE for Notion page creation and OIs.
- First outreach is always by Andre personally. Prepare context, never draft the email.
- All Notion content in English. No em dashes.
- Verify supplier does not exist (Step 0) before any writes.
- Set Currency by region automatically (CN=RMB, US=USD, PT/DE=EUR).
- Log all writes to `outputs/change-log.md`.
- Check `outputs/change-log.md` collision guard (10-min window) before any Notion write.
