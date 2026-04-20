# Commands vs Skills — disposition audit (L7)

Snapshot: 2026-04-20. Supersedes improvement-plan.md §2b for future operational reference.

---

## Principle

- **Commands** = thin orchestrators with optional `$ARGUMENTS`. Live in `.claude/commands/`. Model pinned via frontmatter. Purpose: entry points typed directly by André.
- **Skills** = end-to-end workflows with multi-step logic, pre-flight, rules, MCP error handling, logging. Live in `.claude/skills/{name}/SKILL.md`. Purpose: orchestrated procedures that may or may not be exposed as commands.
- A command can invoke a skill. A skill can be invoked directly as `/skill-name` by the harness. Some commands ARE essentially `/<skill>` (same name, same behavior). That is redundancy, not hierarchy.

---

## Audit — keep, rewrite, or delete

| Command | Has parallel skill? | Current role | Disposition |
|---|---|---|---|
| `audit.md` (81 lines) | No | Notion workspace compliance check | **KEEP as command.** No skill exists; it is itself the procedure. |
| `build-deck.md` (37) | No | Sword brand presentation generator | **KEEP as command.** Taking `$ARGUMENTS` (topic); workflow fits command size. |
| `cross-check.md` (111) | No | Gmail × Slack × Notion gap detection | **KEEP as command.** Dense orchestrator; no skill counterpart. |
| `daily-log.md` (53) | No | Compile + push daily log | **KEEP as command.** Thin by design. |
| `housekeeping.md` (154) | No | Background maintenance (outreach, compliance, OI, context) | **KEEP as command.** Already invokes multiple skills (context-doctor, outreach-healer) — pure orchestrator. |
| `log-sent.md` (105) | No | Sent-email scan + outreach milestone write | **KEEP as command.** Called by cron; invokes agents. |
| `mail-scan-deep.md` (50) | No | Unfiltered Gmail scan | **KEEP as command.** Thin wrapper over scan-gmail procedure. |
| `mail-scan.md` (99) | No | Filtered Gmail scan by domain | **KEEP as command.** Daily entry point. |
| `ping.md` (75) | No | MCP health check | **KEEP as command.** L0 deliverable, stays a command. |
| `price-compare.md` (55) | Partial overlap: `scenario-optimizer` (L6) | Ranked FLC table for a project | **KEEP as command.** Different scope — price-compare ranks; scenario-optimizer permutes allocations. Not redundant. |
| `skills.md` (52) | No | List all skills | **KEEP as command.** Utility. |
| `test-update.md` (47) | No | Device test-score update | **KEEP as command.** Invokes testing agent. |
| `warm-up.md` (103) | No | Start-of-day routine | **KEEP as command.** Daily entry point; L5 modes live here. |
| `weekly-report.md` (75) | Parallel skill: `weekly-pulse` | Weekly summary push to Notion | **REVIEW — not delete.** `weekly-report` = executive-facing push; `weekly-pulse` = compact metrics snapshot. Different audiences. No merge needed but confirm with André next sprint whether both are used. Low-risk — leave for now. |
| `wrap-up.md` (114) | No | End-of-day routine | **KEEP as command.** Core orchestrator; L4B/L5 additions live here. |

---

## Skills with no command wrapper (invoked via harness as `/<skill-name>`)

All 24 skills in `.claude/skills/` are invokable directly. No command wrapper required for discovery — the harness auto-registers them.

Skills that benefit from a dedicated command wrapper would be those taking a required argument (`$ARGUMENTS`) where a typo in the skill name could silently succeed with empty args. Candidates:

- `scenario-optimizer` (requires `{project}`) — currently works as `/scenario-optimizer pulse`, no wrapper needed since the skill enforces the arg.
- `part-lookup` (requires `{MPN}`) — same. Skill HALTs without arg.
- `nda-check` — no required arg (accepts pasted text or file). Fine as-is.

**Decision:** no new command wrappers this sprint. Revisit if André reports friction invoking L6 skills.

---

## Redundancies detected — none requiring action

- `weekly-report` (command) vs `weekly-pulse` (skill): different output format and audience. Both justified.
- `price-compare` (command) vs `scenario-optimizer` (skill): ranking vs permutation. Both justified.
- `project-dashboard` (skill) vs morning-brief per-project block: dashboard = deep dive, brief = shallow scan. Both justified per improvement-plan.md §2b evaluation.

No parallel architectures. Each concept has one canonical location per §2b EVALUATE decisions (recorded in plan, not enforced here).

---

## What this audit does NOT do

- Does not rewrite any command or skill.
- Does not propose merging `weekly-report` ↔ `weekly-pulse` without André confirmation that both are in use.
- Does not delete any file — the L7 deletions already happened and targeted orphan documents, not commands.
- Does not enforce a new rule (e.g., "commands must be <50 lines"). Commands have grown organically; forcing a length limit would just move content elsewhere without net benefit.

---

## Maintenance cadence

Re-audit this file when:

1. A new skill or command lands with overlapping scope.
2. `/weekly-report` vs `/weekly-pulse` usage pattern becomes clear (André uses one consistently).
3. L6 second-wave sprints ship (`/supplier-enrichment`, `/quote-intake` PDF) — those may retire commands.
4. Quarterly (or monthly if volume changes) — part of the Sprint A maintenance cycle.
