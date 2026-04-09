# Implementation Playbook  - Claude Code Only
## No n8n. No Slack App. No IT approval needed.

---

# Prerequisites (André, ~15 min)

- [ ] Git for Windows installed (git-scm.com)
- [ ] Node.js LTS installed (nodejs.org)
- [ ] Claude Code installed: `npm install -g @anthropic-ai/claude-code`
- [ ] VSCode installed (optional but recommended, has Claude Code extension)
- [ ] Claude Max or Pro subscription active

---

# Step 1: Create Repo (~10 min, André)

```
mkdir procurement-hub
cd procurement-hub
git init
```

Copy these files into the repo:
- CLAUDE.md -> root
- context-pulse-suppliers.md -> context/pulse/suppliers.md
- context-kaia-suppliers.md -> context/kaia/suppliers.md
- context-mband-suppliers.md -> context/mband/suppliers.md

```
mkdir -p .claude/agents .claude/commands context/pulse context/kaia context/mband outputs/briefings outputs/weekly-reports outputs/email-drafts
touch outputs/change-log.md

git add .
git commit -m "Initial: CLAUDE.md + context files"
```

---

# Step 2: Configure MCP Servers (~10 min, Claude Code session)

Open terminal in procurement-hub/ and run `claude`.

First message:

```
Read CLAUDE.md. Configure MCP servers for Notion, Gmail, and Slack
as listed in Section 8. Then test each connection:
1. Query the Pulse Suppliers DB and list all suppliers with their status
2. Search Gmail for emails from transtekcorp.com in the last 7 days
3. Read Slack DM with Jorge Garcia (last 5 messages)
```

Deliverable: 3 MCP connections working. Commit.

---

# Step 3: First Command  - /morning-scan (~1-2 hours, Claude Code)

```
Read CLAUDE.md Section 4 (/morning-scan) and Section 9 (Gmail patterns).
Create .claude/commands/morning-scan.md with the full command definition.

Then execute a morning scan for all 3 projects:
1. Scan Gmail for supplier emails from the last 48 hours
2. For each email, check the Notion supplier page for context
3. Present a summary with recommendations (Log / Draft Reply / Ignore / Escalate)
4. Wait for my approval before any writes

Do NOT update Notion yet. Present the scan results first.
```

Test: Compare output with a manual email check. Should catch the same items.
Deliverable: /morning-scan working. Commit.

---

# Step 4: Agent Definitions (~1 hour, Claude Code)

```
Read CLAUDE.md Section 3 (Agents). Create the 5 agent definition files:
- .claude/agents/supplier-comms.md
- .claude/agents/logistics.md
- .claude/agents/testing.md
- .claude/agents/analyst.md
- .claude/agents/notion-ops.md

Each agent file should include:
- Job description
- Tools it uses (MCP servers + specific DBs)
- What it knows (from context/ files)
- What it does NOT touch
- Examples of tasks it handles
```

Deliverable: 5 agent files created. Commit.

---

# Step 5: Remaining Commands (~2 hours, Claude Code)

Build and test one at a time:

1. /daily-log  - Test: run, verify Notion Daily Log entry created as Draft
2. /price-compare  - Test: run for Pulse, verify FLC table matches known data
3. /weekly-report  - Test: run for current week, compare with manually written report
4. /test-update  - Test: run, verify Test Reviews DB updates are correct
5. /audit  - Test: run, compare findings with known issues

For each:
```
Read CLAUDE.md Section 4 for the command definition.
Create .claude/commands/{command-name}.md.
Then execute the command and present results before any writes.
```

Deliverable: All 6 commands working. Commit after each.

---

# Step 6: Workflow Patterns (~30 min, practice)

Practice the daily workflow:

**Morning:**
```
/morning-scan
```
Review recommendations. Approve logs and drafts. Check Gmail drafts, send manually.

**End of day:**
```
/daily-log
```
Review draft. Approve. Check Notion.

**Friday:**
```
/weekly-report
```
Review draft. Adjust. Mark as Sent in Notion UI.

**On demand:**
```
/price-compare pulse
/audit
/test-update
```

---

# Validation Checklist

| Step | Test | Pass? |
|------|------|-------|
| 2 | Claude Code can query Pulse Suppliers DB | |
| 2 | Claude Code can search Gmail | |
| 2 | Claude Code can read Slack | |
| 3 | /morning-scan catches same emails as manual check | |
| 3 | /morning-scan presents recommendations before acting | |
| 5 | /daily-log creates correct Notion entry (no duplicates) | |
| 5 | /weekly-report matches manual report quality | |
| 5 | /price-compare generates correct FLC table | |
| 5 | /audit finds known issues | |
| 6 | Full morning workflow runs in <10 min | |

---

# Timeline

| Step | Effort | Dependency |
|------|--------|-----------|
| 1. Create repo | 10 min (André) | None |
| 2. MCP servers | 10 min (Claude Code) | Step 1 |
| 3. /morning-scan | 1-2h (Claude Code) | Step 2 |
| 4. Agent definitions | 1h (Claude Code) | Step 2 |
| 5. Remaining commands | 2h (Claude Code) | Steps 3 + 4 |
| 6. Practice workflow | 30 min (André) | Step 5 |

Total: ~4-6 hours over 1-2 days.
André's manual effort: ~1 hour (setup + testing).

---

# What Changed vs Original Blueprint

| Original (3 layers) | Now (Claude Code only) |
|---|---|
| n8n detects emails automatically (5 min poll) | André types /morning-scan when ready |
| Slack notification with 5 buttons | Claude Code presents recommendations inline |
| n8n logs to Notion on button click | Claude Code logs after André's approval |
| Cron jobs for morning scan, daily log, weekly report | André runs commands manually |
| ~$55-65/month (n8n + Claude Code + Claude.ai) | ~$20-40/month (Claude Code API only) |

What stays the same: agents, safety rules, domain mapping, Notion workspace, writing style, SHOW BEFORE WRITE, change log, approval flow.

What improves: zero IT dependency, lower cost, full control, no risk of background actions.

What you lose: real-time email detection (you scan when you decide, not every 5 min).
