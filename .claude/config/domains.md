# Domain-to-Supplier Mapping + Gmail Patterns
# Single source of truth. All commands reference this file instead of hardcoding domains.
# If a new supplier is added, update HERE. Everything else inherits.
#
# INVARIANT — TABLE ↔ FILTER SYNC: when a domain is added/removed/modified in any project
# table above, ALSO update the matching project line in §"Per-project domain filters" near
# the bottom of this file. The two are coupled — `/log-sent` reads the table for domain
# membership but `/mail-scan` reads the filter line for Gmail queries. Skipping the filter
# update silently drops emails from new suppliers in mail-scan default mode.

> **Note:** The Status column is informational only and may be stale. Always query Notion for authoritative supplier status. This file is the source of truth for DOMAINS and GMAIL PATTERNS only.

## Pulse

| Domain | Supplier | Status |
|--------|----------|--------|
| transtekcorp.com | Transtek Medical | Shortlisted |
| lefu.cc | Unique Scales | Shortlisted |
| urionsz.com | Urion Technology | Quote Received |
| andonline.com | A&D Medical | Shortlisted (Fallback) |
| andmedical.com | A&D Medical | (alt domain) |
| xrmould.com | Xinrui Group | Rejected |
| yimilife.com | Yimi Life | Rejected |
| myspo2.com | Yimi Life | (alt domain) |
| yilai-enlighting.cn | Yilai Enlighting | Rejected |
| daxinhealth.com | Daxin Health | Rejected |
| ullwin.com | Ullwin | Rejected |
| finicare.com | Finicare | Rejected |
| hingmed.com | Hingmed | Rejected |
| zewa.com | Zewa Inc | Rejected |
| ipadv.net | IPADV | Rejected (Intermediary) |

## Kaia

| Domain | Supplier | Status |
|--------|----------|--------|
| tigerfitness.net.cn | Tiger Fitness | Under Review |
| secondpageyoga.com | Second Page Yoga | Under Review |
| secondpagetech.com | Second Page Yoga | (alt domain) |
| proimprint.com | ProImprint | Under Review |
| 4imprint.com | 4imprint | Blocked (Benchmark) |

## Phone Stand (Thrive)

| Domain | Supplier | Status |
|--------|----------|--------|
| gzbwoo.com | BWOO (Guangzhou Wusen Electronic) | Contacted |
| bwoohk.com | BWOO | (alt domain) |
| lamicall.com | Lamicall | Contacted |
| chengrongtech.com | Shenzhen Chengrong Technology | Contacted |
| efast-tech.com | EFAST | Contacted |
| nulaxy.com | Nulaxy | Contacted |
| yrightsz.com | YRightSZ | Contacted |
| j-mold.com | J-Mold | Contacted |
| flyoung.en.made-in-china.com | Shenzhen Flyoung Technology | Contacted (via MIC platform) |
| xinsurui.en.alibaba.com | Shenzhen Xinsurui Technology | Contacted (via Alibaba platform) |

Note: Flyoung and Xinsurui replies typically arrive via Made-in-China or Alibaba forwarded addresses (e.g. `reply@alibaba.com`, `*.made-in-china.com`). First reply may expose the supplier's direct email — update this table as those become known. Use `/mail-scan-deep` to catch platform-forwarded replies until direct domains are mapped.

## M-Band

| Domain | Supplier | Status |
|--------|----------|--------|
| vangest.com | Vangest | Quote Received |
| ribermold.pt | Ribermold | RFQ Sent |
| mcm.com.pt | MCM | RFQ Sent |
| uartronica.pt | Uartronica | RFQ Sent |
| quantal.pt | Quantal | Engaged |
| conkly.com | CONKLY | Rejected |
| jxwatchband.com | JXwearable | RFQ Sent |
| watchstrapbands.com | JXwearable | (alt domain) |
| transpak.com | TransPak | RFQ Sent |
| shxwatch.com | SHX Watch | Quote Received |
| gaoyipp.com | GAOYI | RFQ Sent |
| hondaholdings.com | GAOYI | (alt domain) |
| lihuadirect.com | Lihua Direct | RFQ Sent |
| carfi.pt | Carfi Plastics | Rejected |
| kimballelectronics.com | Kimball Electronics | Rejected |
| sanmina.com | Sanmina | Contacted |
| 3dways.pt | 3DWays | Rejected |
| keenfinity.com | Keenfinity | Inactive - not in Gmail filters |
| xrmould.com | Xinrui Group | Contacted (M-Band) |

## Internal Platforms

| Domain | Platform | What it signals | Extract |
|--------|----------|-----------------|---------|
| swordhealth.ziphq.com | Zip (NDA + onboarding portal) | NDA status updates, supplier onboarding flow steps, budget requests | Supplier name, event type (NDA signed / step completed / budget approved), Zip request URL from body |
| swordhealth.atlassian.net | Jira | Shipping requests André submitted — label: ISC-Shipping | Ticket ID → link `atlassian.net/browse/[ID]`, DHL AWB → link `dhl.com/global-en/home/tracking.html?tracking-id=[AWB]`, destination supplier |

Scan these alongside supplier emails in /mail-scan. See mail-scan.md "Internal Platform Processing" section for full extraction and Notion write logic.

**Zip → Notion writes:** NDA Status field update (SHOW BEFORE WRITE), NDA OI closure, Outreach milestone entry.
**Jira → Notion writes:** OI context update referencing Jira + DHL links (SHOW BEFORE WRITE). Links always embedded, never raw URLs.

---

## Gmail Filter Rule

Only active suppliers (not Rejected or Inactive) are included in Gmail filter patterns. Use /mail-scan-deep to catch emails from rejected or unknown senders.

---

## Gmail Scan Patterns

### Base filters (always apply)
```
EXCLUDE: -from:a.faria@swordhealth.com -from:noreply -from:no-reply -category:promotions -category:social
```

### Internal platform filters (always include)
```
from:swordhealth.ziphq.com OR (from:swordhealth.atlassian.net label:ISC-Shipping)
```
Note: All Zip emails are relevant. Jira: only emails André labelled "ISC Shipping" (sample shipment requests).

### Andre's sent emails (always scan separately)
```
from:(a.faria@swordhealth.com OR a.faria@sword.com) after:YYYY/MM/DD
```

### Per-project domain filters (for /mail-scan default mode)
```
Pulse: from:(transtekcorp.com OR lefu.cc OR urionsz.com OR andonline.com OR andmedical.com)

Kaia: from:(tigerfitness.net.cn OR proimprint.com OR secondpageyoga.com OR secondpagetech.com OR 4imprint.com)

M-Band: from:(conkly.com OR jxwatchband.com OR watchstrapbands.com OR ribermold.pt OR vangest.com OR uartronica.pt OR mcm.com.pt OR quantal.pt OR transpak.com OR shxwatch.com OR lihuadirect.com OR sanmina.com OR gaoyipp.com OR hondaholdings.com OR xrmould.com)

Phone Stand: from:(gzbwoo.com OR bwoohk.com OR lamicall.com OR chengrongtech.com OR efast-tech.com OR nulaxy.com OR yrightsz.com OR j-mold.com)
```

### Deep scan mode (for /mail-scan --deep)
No domain filter. Scan all incoming after base exclusions. Cross-reference sender against Notion Contact fields to identify supplier emails from unknown domains. Flag unrecognized senders separately.
