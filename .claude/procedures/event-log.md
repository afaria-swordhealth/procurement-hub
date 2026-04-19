# Event Log Schema

Every change-log entry gets a single-line machine-readable header above the prose. Enables `/ask`, `/improve`, and later analytics to parse history without NLP.

## Format

```
[EVENT: TYPE key=value key=value ...]
```

- `TYPE` — one of the canonical types below, UPPERCASE.
- `key=value` pairs — no quotes, no spaces inside a value. Spaces separate pairs. Unknown keys allowed; unknown types not allowed.
- Exactly one `[EVENT: ...]` header per change-log entry, on its own line, immediately before the prose.
- Prose body follows the existing free-form convention.

## Canonical TYPE values

| TYPE | Emitted by | Required keys | Optional keys |
|------|-----------|---------------|---------------|
| `OUTREACH` | /log-sent, check-outreach | supplier, event | oi, project |
| `QUOTE` | quote-intake | supplier, project | unit_eur, tooling_eur, fx, tier |
| `OI_CREATE` | create-open-item | oi, project, type | supplier, deadline |
| `OI_UPDATE` | notion-create-comment paths | oi | supplier, status |
| `OI_STATUS` | status transitions | oi, from, to | supplier |
| `OI_CLOSE` | supplier-rejection, selection | oi, resolution | supplier |
| `SUPPLIER_STATUS` | supplier-rejection, selection | supplier, from, to | project |
| `NDA` | housekeeping, onboarding | supplier, status | project |
| `DB_FIELD` | quote-intake, housekeeping | supplier, field | project, value_type |
| `CONTEXT_SYNC` | wrap-up, context-doctor | project | suppliers_count |
| `AUTOCLEAN` | housekeeping | entry, file | kind |
| `SYSTEM` | session-doctor, improve, ping | subject | severity |
| `SKILL_RUN` | any skill end | skill | status, duration_s |
| `FAIL` | any failed write | target | error, skill |

## Key conventions

- `supplier=Transtek` — exact supplier name from the Supplier DB Name field. Use underscore for spaces: `supplier=Unique_Scales`.
- `oi=33eb4a7d-9059` — short OI id (first 8 chars + last 4), enough for grep.
- `project=pulse|kaia|mband|bloompod|isc` — lowercase.
- `status=Pending|In_Progress|Blocked|Closed` — same values as Notion OI DB.
- `from=`/`to=` — transition states.
- Booleans: `flag=true` or omit. Never `flag=false`.
- Dates: ISO `date=2026-04-19`. Timestamps inherit from the change-log header; do not repeat.

## Examples

```
[EVENT: OUTREACH supplier=Transtek event=quote_received project=pulse oi=33eb4a7d-9059]
Quote received. USD 12.50/unit @5K, tooling $18,000. FOB.

[EVENT: QUOTE supplier=Transtek project=pulse unit_eur=11.750 tooling_eur=16875 fx=0.94 tier=5K]
- Auto-wrote: Unit Cost 11.750 EUR, Tooling 16875 EUR (source: USD 12.50@5K, FX: 0.94)

[EVENT: OI_STATUS oi=345b4a7d-81c3 from=Blocked to=In_Progress supplier=Future_Electronics]
Avnet confirmed LT on M-Band components. Blocker cleared, active work started.

[EVENT: FAIL target=notion_update_page skill=quote-intake error=timeout]
Notion update-page failed after 30s. Retry surfaced to André.
```

## What doesn't get a header

- File-level comments at the top of change-log.md (preserved by session-doctor).
- The daily `## YYYY-MM-DD` date header.
- Multi-line prose under an event header (only the first line is the event).

## Adoption rule

New code paths that write change-log entries must include the header from day one. Existing entries without headers are left alone — back-filling is a cleanup task, not a substrate requirement.

`/improve` and `/ask` consumers must tolerate unheadered entries (skip or fallback to NLP) until backfill is complete.
