---
description: Audit Notion workspace against Maintenance Rules for compliance issues.
model: sonnet
---

# Workspace Audit

**Agents:** notion-ops (primary)

**References:**
- .claude/config/databases.md (Query Patterns section)
- .claude/config/databases.md (collection IDs, page IDs)
- CLAUDE.md Safety Rules and Writing Style sections

## Pre-flight

Read `outputs/session-state.md`. Calculate age of Last-Warm-Up:
- If < 2h: use context snapshot. Do not re-read context files.
- If 2–8h: use snapshot as baseline. Run delta scan for this task.
- If > 8h or missing: warn André and recommend /warm-up before proceeding.

## Steps

### Phase 1: DB Compliance

1. **Fetch Maintenance Rules** page (ID from config/databases.md, READ-ONLY). This is the source of truth for all compliance checks.

2. **Query all Supplier DBs** using config/databases.md (Query Patterns section):
   - columns: Name, Status, Notes, Contact, NDA Status, Samples Status, SDK Status
   - project: all

3. **Query Open Items DB** (ID from config/databases.md, OI_DB):
   - columns: Name, Status

4. **Query Daily Logs DB** (ID from config/databases.md, DAILYLOG_DB):
   - columns: Name

5. **Check against Maintenance Rules:**
   - EN-only: All Notion content must be in English (no Portuguese, no Chinese)
   - Notes format: "TYPE (Location). Product + key differentiator. Flag." Max 2 lines.
   - Section order: ## Contact, ## Profile, ## Quote, ## Outreach, ## Open Items
   - Field completeness: Required fields populated (Status, Device, Region, Contact)
   - Duplicates: No duplicate supplier entries across DBs

6. **Present Phase 1 findings** to Andre.

### Phase 2: Content Quality

For each project page (Pulse, Kaia, M-Band):

1. Fetch the project page and all child pages.
2. Check: are key sections populated and current?
   - Overview/status up to date?
   - Shortlist or pricing tables reflect latest data?
   - Links to subpages working?
3. For each active supplier page:
   - Does it have all 5 sections (Contact, Profile, Quote, Outreach, Open Items)?
   - Is Quote section populated if status is "Quote Received" or higher?
   - Are Open Items resolved or clearly flagged?
   - Would someone unfamiliar understand the supplier's status from reading the page alone?
4. Flag:
   - Excessive content (Outreach section too long, needs archiving)
   - Missing context (no Quote section despite "Quote Received" status)
   - Outdated info (prices from >30 days ago without update note)
5. Present findings with severity:
   - **Critical:** Blocks decisions (missing data needed for shortlist, incorrect status)
   - **Warning:** Confusing for outsiders (missing sections, inconsistent information)
   - **Info:** Cosmetic (formatting, ordering, verbose content)

6. **Present all findings** (Phase 1 + Phase 2) to Andre. Andre decides what to fix.

## Safety

- Maintenance Rules page is READ-ONLY. Never modify it.
- Andre approves each fix individually.
- Follow CLAUDE.md Safety Rules and Writing Style sections.

## Output Format

Table of findings with columns: DB | Supplier | Issue | Severity (High/Medium/Low) | Suggested Fix
