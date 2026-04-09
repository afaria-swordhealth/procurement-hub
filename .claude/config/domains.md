# Domain-to-Supplier Mapping + Gmail Patterns
# Single source of truth. All commands reference this file instead of hardcoding domains.
# If a new supplier is added, update HERE. Everything else inherits.

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
| proimprint.com | ProImprint | Under Review |
| 4imprint.com | 4imprint | Blocked (Benchmark) |

## M-Band

| Domain | Supplier | Status |
|--------|----------|--------|
| vangest.com | Vangest | Quote Received |
| ribermold.pt | Ribermold | RFQ Sent |
| mcm.com.pt | MCM | RFQ Sent |
| uartronica.pt | Uartronica | RFQ Sent |
| quantal.pt | Quantal | Engaged |
| conkly.com | CONKLY | RFQ Sent |
| jxwatchband.com | JXwearable | RFQ Sent |
| watchstrapbands.com | JXwearable | (alt domain) |
| transpak.com | TransPak | RFQ Sent |
| shxwatch.com | SHX Watch | Quote Received |
| lihuadirect.com | Lihua Direct | RFQ Sent |
| carfi.pt | Carfi Plastics | Rejected |
| kimballelectronics.com | Kimball Electronics | Rejected |
| sanmina.com | Sanmina | Contacted |
| 3dways.pt | 3DWays | Rejected |
| keenfinity.com | Keenfinity | Inactive - not in Gmail filters |

---

## Gmail Filter Rule

Only active suppliers (not Rejected or Inactive) are included in Gmail filter patterns. Use /mail-scan-deep to catch emails from rejected or unknown senders.

---

## Gmail Scan Patterns

### Base filters (always apply)
```
EXCLUDE: -from:a.faria@swordhealth.com -from:notifications@swordhealth.ziphq.com -from:noreply -from:no-reply -category:promotions -category:social
```

### Andre's sent emails (always scan separately)
```
from:(a.faria@swordhealth.com OR a.faria@sword.com) after:YYYY/MM/DD
```

### Per-project domain filters (for /mail-scan default mode)
```
Pulse: from:(transtekcorp.com OR lefu.cc OR urionsz.com OR andonline.com OR andmedical.com)

Kaia: from:(tigerfitness.net.cn OR proimprint.com OR secondpageyoga.com OR 4imprint.com)

M-Band: from:(conkly.com OR jxwatchband.com OR watchstrapbands.com OR ribermold.pt OR vangest.com OR uartronica.pt OR mcm.com.pt OR quantal.pt OR transpak.com OR shxwatch.com OR lihuadirect.com OR sanmina.com)
```

### Deep scan mode (for /mail-scan --deep)
No domain filter. Scan all incoming after base exclusions. Cross-reference sender against Notion Contact fields to identify supplier emails from unknown domains. Flag unrecognized senders separately.
