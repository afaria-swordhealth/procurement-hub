# Change Log
# Rolling daily file. Keeps only today's entries.
# History lives in git log. On wrap-up, this file is committed then cleared for tomorrow.

## 2026-04-28
- [MINI-FIX] (replay log — entry lost in concurrent wrap-up clear, fix is in commit 68f5c97) Concurrent warm-up cron pile-up: warm-up Phase 8 pre-cron guard + session-doctor Step 1a MULTI_SESSION row + Step 1c CRON_PILEUP per-task max-count detection.
- [STRUCTURAL] Slack live-send regression (Apr 28 incident) — policy propagation across 5 files: safety.md Core Rule 5b + decision tree node 0 (positive rule + tool name + override phrase list); CLAUDE.md §7 Slack row (Read+Draft); writing-style.md §6 Slack General approach (tool named); procedures/ledger-append.md (new `slack_message_draft` cosmetic class); agents/supplier-comms.md Write Permissions (Slack draft-only). Defense-in-depth, no hook (deferred to Phase 2 if regression #3 appears).
- [NOTION-WRITE] TransPak (M-Band Packaging): Status → Quote Received, Last Outreach Date → 2026-04-28, outreach entry added. Unit Cost $0.770 @200K EXW, Tooling $2,915 ($1,457.50 × 2 SKUs). Context file updated.
- [NOTION-WRITE] M-Band pricing cleanup — 7 suppliers updated to @200K USD baseline. GAOYI $0.484/$155, Lihua $0.694/$0, SHX Watch $1.360/$0, MCM $0.123/$35870 (EUR native, FX 1.087), Uartrónica $24.685/$7625 (EUR native, FX 1.087; tooling corrected from €89275→€7015), Vangest $3.348/$467228 (EUR native, FX 1.087; deprioritized). 3DWays cost fields cleared (Rejected). PENDING: Notion UI rename Unit Cost (EUR)→USD + Tooling Cost (EUR)→USD on all 4 supplier DBs; then update databases.md.
