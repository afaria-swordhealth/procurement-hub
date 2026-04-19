# Execution Checkpoints

Local JSON sidecar pattern for mid-skill crash recovery. Replaces ruflo-based checkpointing for critical skills (`quote-intake`, `rfq-workflow`, `supplier-selection`). Ruflo was a single point of failure — when its MCP was down, checkpoint writes silently failed and partial skill runs could not be detected on resume.

## Why local files

- Filesystem is always available. MCP services are not.
- Git-ignored, so checkpoints never end up in a commit.
- Trivial to inspect: `cat outputs/checkpoints/{skill}_{entity}.json`.
- No cross-session race — session-single model (see `safety.md`) already rules out concurrent writers.

## File location

```
outputs/checkpoints/{skill}_{entity_slug}.json
```

- `skill` — exact skill folder name (`quote-intake`, `rfq-workflow`, `supplier-selection`).
- `entity_slug` — the natural per-run key, lowercased, with non-alphanumerics replaced by `_`. Examples:
  - `quote-intake` keyed by supplier → `quote-intake_transtek.json`
  - `rfq-workflow` keyed by supplier → `rfq-workflow_unique_scales.json`
  - `supplier-selection` keyed by project → `supplier-selection_pulse.json`

Directory `outputs/checkpoints/` is created on first write. Listed in `.gitignore` (add on first commit touching this procedure).

## Schema

```json
{
  "skill": "quote-intake",
  "entity": "Transtek",
  "started": "2026-04-19T10:15",
  "last_update": "2026-04-19T10:17",
  "status": "in-progress",
  "steps_done": ["db_fields", "quote_section"],
  "meta": {
    "project": "pulse",
    "supplier": "Transtek"
  }
}
```

- `status` — `"in-progress"` | `"complete"` | `"failed"`.
- `steps_done` — append-only list of completed step identifiers. Each skill defines its own step names (same strings previously used in ruflo payloads).
- `meta` — free-form skill-specific context, enough to resume intelligently.

## Lifecycle

### 1. Pre-flight check (skill entry)

Read the checkpoint file if it exists.

- **File missing** → fresh run. Proceed.
- **File present, status `complete`** → previous run finished. Archive: rename to `{skill}_{entity}_{started_date}.json.done` (keeps short history), then start fresh.
- **File present, status `in-progress`** → STOP. Surface to André:
  ```
  Incomplete prior {skill} run detected on {started}. Steps completed: {steps_done}.
  Resume from that point, or confirm fresh start to overwrite?
  ```
- **File present, status `failed`** → surface error + last step. Ask to resume or restart.

### 2. Initial write (before first destructive step)

Write the full object with `status: "in-progress"`, `started` = current time, `steps_done: []`.

Use atomic write: write to `{file}.tmp`, then rename to `{file}`. Prevents half-written JSON if the session dies mid-write.

### 3. Step updates

After each successful destructive step (Notion write, draft creation, etc.):
- Append step id to `steps_done`.
- Update `last_update` to current time.
- Atomic write.

Never update before the step succeeds — the checkpoint records completed work, not intent.

### 4. Completion

After the final step, set `status: "complete"` and write.

### 5. Cleanup

`/wrap-up` archives all `*.json` in `outputs/checkpoints/` with `status: "complete"` older than 24h, renaming them to `*.json.done`. Weekly: delete `.done` files older than 14 days (they exist only for audit).

`in-progress` or `failed` files are never auto-cleaned — they require André's attention.

## Failure semantics

- **Write fails (disk full, permission)** — skill must STOP and surface. Unlike ruflo, filesystem failure is not tolerable; it means the system cannot track progress at all.
- **File corrupt (bad JSON)** — surface to André with raw contents. Do not overwrite automatically.
- **Cross-skill concurrency** — session-single model forbids it. If two skills write to the same checkpoint file, it is a bug.

## Comparison to ruflo pattern (what changed)

| Aspect | Old (ruflo) | New (local file) |
|--------|-------------|------------------|
| Transport | `mcp__ruflo__memory_*` | filesystem (`Read`/`Write`) |
| Persistence | ruflo namespace `procurement` | `outputs/checkpoints/*.json` |
| Availability | dies when ruflo MCP down | always available while session runs |
| Failure mode | silent skip (continue without checkpoint) | STOP (checkpoint is load-bearing) |
| Visibility | opaque, needs MCP call | `ls outputs/checkpoints/` |

## Migration status

- `quote-intake` — migrated in L1
- `rfq-workflow` — migrated in L1
- `supplier-selection` — migrated in L1
- `outreach-healer`, `supplier-rejection`, `supplier-onboarding` — still on ruflo pattern. Non-critical path (smaller blast radius on partial run). Migrate when next micro-fix touches those skills.
