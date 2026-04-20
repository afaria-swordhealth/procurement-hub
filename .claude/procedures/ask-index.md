# Ask Index

Index build + rebuild procedure for `/ask`. Produces a semantic search index over the procurement-hub corpus via `mcp__ruflo__embeddings_*`.

## Corpus

Indexed sources (repo-relative paths):

| Source | Scope | Notes |
|---|---|---|
| `CLAUDE.md` | Full file | Orchestrator, rules, tree |
| `.claude/config/*.md` | All configs | databases, writing-style, strategy, domains, signature, fx-rates, slack-channels |
| `.claude/procedures/*.md` | All procedures | Reusable logic |
| `.claude/skills/**/SKILL.md` | All skill definitions | Excludes lessons.md (per-skill deltas) |
| `.claude/agents/*.md` | All agents | Scope boundaries |
| `.claude/knowledge/**/*.md` | All knowledge | Sword Insighter process |
| `.claude/safety.md` + `.claude/autonomy.md` | Full files | Policy |
| `context/**/suppliers.md` | All projects | Pulse, Kaia, M-Band, BloomPod |
| `outputs/promises.md` | Current state only | Rebuilt fresh on each rebuild |
| `outputs/autonomy-ledger.md` | Full file | Decision history |
| Git log of `outputs/change-log.md` | Last 60 days | Commit messages + diffs — the operational history |

NOT indexed:
- `.claude/hooks/*.sh` — runtime, not knowledge
- `outputs/session-state.md`, `outputs/pending-signals.md`, `outputs/friction-signals.md` — transient state (stale by design)
- `Procurement-hub/`, `.claude/projects/`, `.claude/scheduled_tasks.lock` — tooling, not corpus
- Binary files, screenshots

## Chunking

- Markdown sections split by `##` heading. Max chunk size 800 tokens. Min 50 tokens (shorter sections merge with previous).
- Each chunk stores:
  - `content` — the markdown body
  - `source` — `{repo-path}:{start_line}-{end_line}` for active files; `git:{commit_sha}:{file}` for historical commits
  - `title` — nearest `#`/`##` heading chain
  - `ts` — file mtime, or commit time for historical chunks

## Build command (first time)

1. Initialize: `mcp__ruflo__embeddings_init` with `namespace: "procurement-ask"`, `model: "default"`.
2. For each file in Corpus: read, chunk, then `mcp__ruflo__embeddings_generate` + `mcp__ruflo__hnsw_add` into `namespace: "procurement-ask"`.
3. For git history: `git log --since="60.days.ago" --name-only --format="%H|%ct|%s" -- outputs/change-log.md`. For each commit, `git show {sha}:outputs/change-log.md` → index as historical chunks.
4. Write index metadata to `.claude/procedures/ask-index.state.md`:
   ```
   namespace: procurement-ask
   Last rebuilt: {YYYY-MM-DDTHH:MM}
   Chunks: {N}
   Corpus file count: {N}
   Git history commits: {N}
   ```
5. Smoke test: run 3 sample queries from `validation.md` and verify top-3 results include the expected source paths. If any fail, the build is invalid — do not mark rebuilt.

## Rebuild schedule

- Nightly at 02:00 via observer cron (to be registered — L4B deliverable). Observer only: rebuild, write state file, emit `[EVENT: INDEX_REBUILD ts=... chunks=N]` to change-log. No André notification unless build fails.
- On-demand: `/ask-rebuild` invokes this procedure.
- After `/wrap-up`: wrap-up triggers a lightweight incremental rebuild (only files modified in the session).

## Incremental rebuild

For files touched since `Last rebuilt` (use `git diff --name-only {last_rebuild_sha} HEAD` + current uncommitted changes):
1. Delete existing chunks for those sources: `mcp__ruflo__embeddings_search` with exact source filter, then delete by id.
2. Re-chunk + re-add.
3. Update `Last rebuilt` timestamp.

Incremental runs should complete in < 30s. Full rebuild only once per 48h.

## Staleness

- Index Last rebuilt ≤ 4h → fresh. `/ask` runs normally.
- 4h–48h → acceptable. `/ask` runs but prints age in the answer header.
- > 48h → stale. `/ask` prints a warning; operator should trigger rebuild.
- Missing state file → `/ask` HALTs.

## Failure modes

- Ruflo MCP unreachable during build: abort, log `[EVENT: FAIL target=ask-index reason=mcp]`, leave previous state file untouched. Next nightly cron retries.
- Partial build (some files indexed, crash mid-run): the state file is the commit. If not written, the partial index is silently ignored — next full rebuild supersedes it.
- Git history > 60 days is not re-indexed. Older history lives in `git log` itself.

## Sizing

Expected corpus: ~300 files, ~4,000 chunks, ~3M tokens. Embedding dim 384 (default ruflo model). Index footprint < 30MB. Rebuild time: ~2 min on full, ~20s incremental.

## Consumers

- `/ask` skill only. No other caller reads this index.
