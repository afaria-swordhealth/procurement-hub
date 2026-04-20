# Ruflo Memory Purge — Procedure (doc only, André-gated execution)

Ruflo memory accumulates keys indefinitely. Over 14 months of use, some categories drift into irrelevance (rejected suppliers, obsolete projects, canceled pursuits). This procedure documents **how** to purge without data loss. Execution is NOT automatic — André runs it manually when the memory footprint is worth trimming.

---

## When to run

- Quarterly (part of the monthly improvement cadence promoted to quarterly scope when memory growth warrants it).
- After a project shuts down (e.g., a rejected RFQ, a cancelled product line).
- After a supplier is Rejected and has been silent for >12 months — their patterns are dead weight.
- When `mcp__ruflo__memory_stats` returns entry count that crosses an arbitrary but noticed threshold (currently undefined — set one after first purge).

Not: every wrap-up. Not: weekly. Not: in response to a single friction signal.

---

## Step 1 — Snapshot before purge

ALWAYS take a snapshot before deleting anything.

1. Call `mcp__ruflo__memory_list` with no filter. Paginate if >1000 entries.
2. For each entry, capture `{key, namespace, tags, value_excerpt (first 200 chars), last_updated, created_at}`.
3. Write snapshot to `outputs/ruflo-snapshot-{YYYY-MM-DD}.md`. Do NOT commit this file to git (contains supplier-confidential value excerpts). Add to `.gitignore` if not already.
4. Verify snapshot line count matches `memory_stats` entry count. Abort purge if mismatch — indicates pagination bug.

If `memory_list` pagination is unreliable (ruflo #827 — listing can truncate silently), DO NOT PURGE. Fall back to targeted deletes by key only.

---

## Step 2 — Classify entries

From the snapshot, classify each entry into one of:

| Category | Definition | Purge policy |
|---|---|---|
| **Keep — active** | Supplier with Status ∈ {Shortlisted, Quote Received, Sample Received, Contacted, Identified}, project active, last updated ≤6 months | NEVER purge |
| **Keep — audit trail** | Selection records, qualification records, meeting notes with decisions | NEVER purge — source of truth for "why we picked X" |
| **Keep — lessons** | Per-skill lessons.md content mirrored to ruflo (if any) | NEVER purge |
| **Candidate — stale** | Supplier Rejected >12 months ago with no inbound activity | Purge after André review |
| **Candidate — orphan** | Key references a supplier slug or project no longer in the 4 Supplier DBs | Purge after André review |
| **Candidate — test/debug** | Keys starting with `test::`, `debug::`, `tmp::` | Purge without review |

Namespace handling: `procurement` is the live namespace. Any other namespace is either (a) a historical test run or (b) a different project. Do NOT delete non-`procurement` namespace entries without confirming their origin.

---

## Step 3 — Present candidates to André

Do NOT delete automatically. Show André a table:

```
RUFLO PURGE CANDIDATES — {date}

CATEGORY: stale (rejected >12mo)
| Key | Supplier | Project | Last updated | Value excerpt |
|---|---|---|---|---|
| chase::helmut::2025-02-12 | Helmut Schmid | M-Band | 2025-02-12 | "chase tier 3, no response, escalation considered" |
| pattern::supplier::helmut | Helmut Schmid | M-Band | 2025-03-01 | "response_rate_90d: 0.0, risk_flags: [pushy, rejected]" |

CATEGORY: orphan (no matching supplier in DB)
| Key | Supplier | Reason | Value excerpt |
|---|---|---|---|
| qualification::nexgen-devices | NexGen Devices | Not in any Supplier DB | "preliminary scorecard 40/100, never advanced" |

CATEGORY: test/debug (auto-removable)
| Key | Count |
|---|---|
| test::* | 7 |
| debug::* | 3 |

Reply with purge IDs to delete, or 'all stale + all orphan + all test' for bulk, or 'skip' to abort.
```

---

## Step 4 — Execute deletion

For each approved key:

1. Call `mcp__ruflo__memory_delete` with the `key` and `namespace`.
2. Verify deletion with a follow-up `memory_retrieve` on the same key — expect not-found response.
3. Log to `outputs/change-log.md`:

```
### Ruflo memory purge — {date}
- Candidates presented: {N} (stale: {A}, orphan: {B}, test/debug: {C})
- Deleted: {M}
- Skipped by André: {N-M}
- Snapshot: outputs/ruflo-snapshot-{date}.md
```

Append `[EVENT: RUFLO_PURGE deleted={M} skipped={N-M}]` above the prose entry.

---

## Step 5 — Verify post-purge

1. Call `mcp__ruflo__memory_stats`. Note new entry count.
2. Expected: `stats.count == pre_purge_count - M`.
3. If mismatch, ruflo indexing may be stale — do not alarm, but log `[EVENT: RUFLO_STATS_DRIFT expected={A} actual={B}]` and move on.
4. Validate one live consumer still works: call `supplier-chaser` Step 4a (pattern retrieval) against an active supplier. Confirm record returns.

---

## Failure modes

| Failure | Response |
|---|---|
| `memory_list` returns partial results (ruflo #827) | Abort purge. Fall back to targeted deletes per key only — no bulk purge on pagination-broken corpus. |
| `memory_delete` returns success but `memory_retrieve` still finds the key | Log as `[EVENT: RUFLO_DELETE_GHOST key=X]`. Retry once. If still present, escalate to ruflo issue tracker. |
| André approves deletion of a key that was mis-classified | Data loss. Recover from snapshot — manually `memory_store` the key + value from the snapshot file. This is why Step 1 is non-negotiable. |
| Snapshot file not written (disk full, path error) | Abort purge. NEVER delete without a snapshot. |
| Ruflo MCP unavailable | Defer. Re-attempt when MCP is healthy (per `/ping`). |

---

## What this procedure does NOT do

- Does not purge per-session chase logs automatically. Those are expected to accumulate; roll-up happens in `/wrap-up` Phase 4c (pattern aggregation), not via deletion.
- Does not delete `ask` embeddings (namespace `procurement-ask`). Those are rebuilt nightly per L4B; purge them via index rebuild, not `memory_delete`.
- Does not touch `know-me` operator profile memory — that is user-authored and lives outside supplier/project scope.
- Does not run on a schedule. Triggered only by André.
- Does not commit the snapshot to git. Snapshot contains value excerpts that may include supplier-confidential content. Keep local.

---

## First-run checklist (when ready)

1. [ ] Confirm `memory_list` pagination works on current ruflo version (test with `limit=10, offset=0` then `offset=10`).
2. [ ] Run Step 1 snapshot; commit `.gitignore` update for `outputs/ruflo-snapshot-*.md`.
3. [ ] Run Step 2 classification locally; do not call `memory_delete`.
4. [ ] Present Step 3 candidate table to André in session.
5. [ ] On approval, run Step 4 deletion in batches of ≤20 keys with verification between batches.
6. [ ] Run Step 5 verification.
7. [ ] Log to change-log.

Estimated first-run effort: 45–60 minutes André-facing + background sync time.
