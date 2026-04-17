---
description: List all available skills with a one-line description and usage trigger.
model: haiku
---

# Skills Catalog

Lists all available skills. No tool calls required — output directly.

## Operational Skills

| Skill | Trigger | What it does |
|-------|---------|--------------|
| `/risk-radar` | Start of day, before Jorge update, anytime you need a risk snapshot | Cross-project risk scan: cold suppliers, expiring quotes, NDA pipeline, overdue OIs, stalled negotiations |
| `/project-dashboard {project}` | Before a project review or status update | Full pipeline view for one project: suppliers by status, open items, quotes, key metrics |
| `/meeting-prep {supplier or topic}` | Before any supplier call or Jorge 1:1 | 1-page briefing: supplier profile, quotes, OIs, email history, Slack context, talking points |
| `/supplier-chaser` | When suppliers haven't replied or OIs are overdue | Scans overdue items, drafts follow-up emails with the right tone tier |
| `/negotiation-tracker {supplier}` | Before a price discussion or concession decision | Quote history, concession map, leverage analysis, next-move recommendation |
| `/quote-intake` | When a supplier quote arrives | Extracts pricing, calculates FLC, updates Notion DB, compares against baselines |
| `/rfq-workflow {supplier}` | When NDA is executed and ready to send RFQ | Assembles RFQ package, drafts email, creates response-tracking OI |

## Supplier Evaluation Skills

| Skill | Trigger | What it does |
|-------|---------|--------------|
| `/supplier-prospection {project}` | When starting a new project or adding candidates to a shortlist | Web search + pre-screen: builds longlist against hard eliminators, creates Identified entries in Notion after André approval |
| `/supplier-qualification {supplier}` | After first contact, before investing in NDA or samples | 5-criterion scored assessment (commercial, product fit, certs, engagement, risk) → Go / Conditional Go / No-Go verdict |
| `/supplier-selection {project}` | When quotes and samples are in and it's time to choose | Weighted comparison of all active candidates, ranked scorecard, decision memo, winner → Shortlisted after approval |

## Maintenance Skills

| Skill | Trigger | What it does |
|-------|---------|--------------|
| `/outreach-healer` | When outreach sections feel bloated or messy | Audits and fixes outreach sections: archives excess, fixes order, translates to EN |
| `/promise-tracker` | Daily or when promises.md feels stale | Syncs promises.md against OI DB, flags mismatches, fixes format |
| `/context-doctor` | After missed wrap-ups, before /weekly-report | Detects drift between Notion supplier state and local context files |
| `/session-doctor` | Session start (runs automatically via hook) | Checks session-state freshness, change-log date, git state. Auto-fixes minor issues. |
| `/weekly-pulse` | Quick weekly health check or before Jorge Slack update | Compact cross-project snapshot: supplier movement, quotes, OIs, blockers |

## Setup and Profile Skills

| Skill | Trigger | What it does |
|-------|---------|--------------|
| `/supplier-onboarding {supplier}` | When a new supplier is added | End-to-end: Notion page, domain config, context file entry, NDA OI, first outreach prep |
| `/supplier-rejection {supplier}` | When eliminating a supplier from a shortlist | Rejection email draft, Jorge note (PT), OI closures, status → Rejected. Full SHOW BEFORE WRITE. |
| `/know-me` | Onboarding or monthly profile refresh | Builds structured operator profile from all memory files. SHOW BEFORE WRITE. |

## Notes

- All skill names work as slash commands: type `/risk-radar`, `/meeting-prep Transtek`, etc.
- Skills are read-only unless explicitly stated otherwise.
- For system commands (/warm-up, /wrap-up, /mail-scan, /housekeeping, etc.), see CLAUDE.md §4.
