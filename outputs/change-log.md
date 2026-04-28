# Change Log
# Rolling daily file. Keeps only today's entries.
# History lives in git log. On wrap-up, this file is committed then cleared for tomorrow.

## 2026-04-28
- [MINI-FIX] (replay log — entry lost in concurrent wrap-up clear, fix is in commit 68f5c97) Concurrent warm-up cron pile-up: warm-up Phase 8 pre-cron guard + session-doctor Step 1a MULTI_SESSION row + Step 1c CRON_PILEUP per-task max-count detection.
- [STRUCTURAL] Slack live-send regression (Apr 28 incident) — policy propagation across 5 files: safety.md Core Rule 5b + decision tree node 0 (positive rule + tool name + override phrase list); CLAUDE.md §7 Slack row (Read+Draft); writing-style.md §6 Slack General approach (tool named); procedures/ledger-append.md (new `slack_message_draft` cosmetic class); agents/supplier-comms.md Write Permissions (Slack draft-only). Defense-in-depth, no hook (deferred to Phase 2 if regression #3 appears).
