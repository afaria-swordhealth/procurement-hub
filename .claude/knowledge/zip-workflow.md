# Zip Workflow
# Sword Health ISC — Procurement Knowledge Base
# Sword Insighter | Last updated: 2026-04-18

How the Zip portal works for procurement at Sword Health.

---

## What is Zip

Zip (swordhealth.ziphq.com) is Sword's internal procurement and vendor management portal. André uses it for:

1. **NDA requests** — initiating, tracking, and receiving signed NDAs
2. **Vendor onboarding** — creating suppliers in the ERP (Finance / AP track)
3. **Budget requests** — PO authorization for new spend categories or suppliers

**Claude cannot submit Zip requests.** André does this manually. (CLAUDE.md Safety Rules, Level 1 + Level 2)

---

## Request types

### NDA Request

**When:** after supplier reaches GO verdict in qualification.

**Submit:** In Zip, create new NDA request. Attach: supplier details, project context, Bradley as legal reviewer.

**Tracking:**
- Zip request ID appears in notification emails (format: `#XXXX` in subject line)
- Track in Supplier DB: NDA Status field
- Open an OI when submitted: `{Supplier} — NDA execution` with deadline +14 days

**Key notifications:**
| Subject keyword | Meaning | Action |
|-----------------|---------|--------|
| "executed" / "fully signed" | NDA complete | Update NDA Status → Signed. Close NDA OI. |
| "revision requested" | Supplier or Legal redlined | Review in Zip portal. Flag to André. |
| "pending review" | Waiting on Bradley or counterparty | No action unless >7 days |

---

### Vendor Onboarding

**When:** supplier is Shortlisted and a PO is anticipated.

**Submit:** In Zip, create vendor onboarding request. Supply: legal entity name, registered address, AP contact, bank details, tax docs.

**Key notifications:**
| Subject keyword | Meaning | Action |
|-----------------|---------|--------|
| "vendor created" / "onboarding complete" | Supplier in ERP | Log milestone in Outreach. Can now receive PO. |
| "step completed" | Intermediate milestone | Log if relevant to an OI. |
| "revision requested" / "information needed" | Finance needs more docs | Flag to André with Zip link. |

---

### Budget Request

**When:** new spend category or supplier requires Finance authorization before PO.

**Submit:** In Zip, create budget request. Attach: quote, supplier details, project justification.

**Key notifications:**
| Subject keyword | Meaning | Action |
|-----------------|---------|--------|
| "budget approved" | PO can proceed | Close/update budget OI. |
| "budget rejected" | PO blocked | Escalate to Jorge. |
| "pending approval" | Waiting on Finance or Anand | No action unless overdue |

---

## Zip link format

Links in Zip notification emails follow the pattern:
`https://swordhealth.ziphq.com/requests/XXXX` (or similar path)

Always embed these as `[Zip #XXXX](url)` in OI context or Outreach entries. Never paste raw URLs in Notion. (See: no-local-paths-in-notion rule in memory.)

---

## Jira ISC Shipping (adjacent to Zip)

André also submits DHL/shipping requests through Jira service desk:
- URL: https://swordhealth.atlassian.net/servicedesk/customer/portal/16/group/79/create/231
- Ticket IDs follow format: ISCSB-XXXX
- Notifications come from swordhealth.atlassian.net with label ISC-Shipping
- Mail-scan extracts ticket ID + DHL AWB number and builds clickable links

---

## Current Zip requests to watch

Check Zip for open/pending requests whenever:
- An NDA has been pending > 14 days
- A budget request was submitted and no approval received
- Vendor onboarding was submitted and "vendor created" notification has not arrived

André checks Zip manually. Claude monitors Zip notifications via mail-scan.
