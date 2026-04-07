---
description: Scan Gmail for new supplier emails, cross-reference with Notion, present recommendations.
---

1. Scan Gmail for Pulse supplier emails from the last 3 days using these domains:
   from:(transtekcorp.com OR lefu.cc OR finicare.com OR urionsz.com OR daxinhealth.com OR ullwin.com OR andonline.com OR xrmould.com OR ipadv.net)
   Also scan sent: from:a.faria@swordhealth.com to these same domains

2. Scan Gmail for Kaia supplier emails:
   from:(tigerfitness.net.cn OR proimprint.com OR secondpageyoga.com)

3. Scan Gmail for M-Band supplier emails:
   from:(conkly.com OR jxwatchband.com OR ribermold.pt OR vangest.com OR uartronica.pt OR mcm.com.pt OR quantal.pt OR kimballelectronics.com OR transpak.com OR carfi.pt)

4. For each email found, query the matching Notion supplier page for context (status, last outreach, open items).

5. Present a summary table per project with columns: Supplier | Subject | Date | Recommendation (Log / Draft Reply / Ignore / Escalate) | Reason

6. Wait for user approval before any writes.

Use notion-query-data-sources with SQL for DB queries instead of fetching pages individually.
