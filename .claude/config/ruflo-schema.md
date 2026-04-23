# Ruflo Memory Key Schema

Canonical reference for all ruflo memory operations in this system.
All skills MUST follow these patterns. New concepts require a schema entry here before implementation.

---

## Namespace

All keys use `namespace: "procurement"`. No exceptions.

---

## Supplier slug format

Supplier slugs are **lowercase, dashes for spaces**. Must be consistent across all skills.

Examples:
- `Transtek Hong Kong` → `transtek-hong-kong`
- `Unique Scales` → `unique-scales`
- `Ribermold` → `ribermold`
- `Teca-Print` → `teca-print`

When computing a slug: `lower(supplier_name).replace(" ", "-").replace("/", "-")`.

The `supplier-pattern-store.md` procedure is the authoritative slug source. When in doubt, check `supplier::{slug}::pattern` for the slug used in that skill.

---

## Key patterns

| Concept | Key pattern | Namespace | Tags | Store tool | Lookup tool |
|---------|------------|-----------|------|------------|-------------|
| Supplier pattern | `supplier::{slug}::pattern` | procurement | `["supplier-pattern", {project}, {slug}]` | `memory_store` upsert | `memory_retrieve` |
| Chase event | `chase::{slug}::{YYYY-MM-DD}` | procurement | `["chase", {project}, {slug}]` | `memory_store` | `memory_search` (discovery) |
| Quote | `quote::{slug}::{YYYY-MM-DD}` | procurement | `["quote", {project}, {slug}]` | `memory_store` | `memory_search` (latest — date unknown) |
| Meeting outcome | `meeting::{slug}::{YYYY-MM-DD}` | procurement | `["meeting", {project}, {slug}]` | `memory_store` | `memory_search` (discovery) |
| Selection decision | `selection::{project}::{YYYY-MM-DD}` | procurement | `["selection", {project}, {winner_slug}]` | `memory_store` | `memory_search` (prior run check) |
| Negotiation event | `negotiation::{slug}::{YYYY-MM-DD}` | procurement | `["negotiation", {project}, {slug}]` | `memory_store` | `memory_search` (discovery) |

---

## Retrieve vs Search

| Use case | Tool | Reason |
|----------|------|--------|
| Get supplier pattern (exact key known: `supplier::{slug}::pattern`) | `memory_retrieve` | Deterministic, no embedding needed |
| Get latest prior quote for a supplier (date unknown) | `memory_search` | Date is part of key — cannot compute without knowing it |
| Get prior meeting outcomes (multiple records, date unknown) | `memory_search` | Intentional discovery; date unknown |
| Get prior selection for a project (date unknown) | `memory_search` | Intentional prior-run check; date unknown |
| Any single-record lookup where the full key is computable | `memory_retrieve` | Prefer `retrieve` over `search` whenever key is deterministic |

**Rule:** if you know the full key (concept + entity + date/subkey), use `memory_retrieve`. If date is unknown or you want multiple results, use `memory_search`.

---

## Producers and consumers

| Key pattern | Produced by | Consumed by |
|------------|-------------|-------------|
| `supplier::{slug}::pattern` | `supplier-chaser` (Steps 4a + 6b), `wrap-up` Phase 4c rollup | `supplier-chaser` (pre-check), `morning-brief` (urgency multiplier) |
| `chase::{slug}::{date}` | `supplier-chaser` Step 6b | `wrap-up` Phase 4c (response_rate_90d re-derivation) |
| `quote::{slug}::{date}` | `quote-intake` Step 8 | `quote-intake` Step 4 (prior quote pre-check) |
| `meeting::{slug}::{date}` | `meeting-notes` Step 3, `meeting-prep` Step 8 | `meeting-prep` Step 6b |
| `selection::{project}::{date}` | `supplier-selection` Step 7.4 | `supplier-selection` Pre-flight Step 6 |
| `negotiation::{slug}::{date}` | `negotiation-tracker` Step 5 | `negotiation-tracker` Step 2b |

---

## Adding a new concept

1. Add a row to the Key patterns table above.
2. Use `{concept}::{entity}::{YYYY-MM-DD}` or `{concept}::{entity}::{subkey}` format.
3. Always use `procurement` namespace.
4. Tags must include at least `[{concept}, {project}, {entity_slug}]`.
5. Slugify all entity names in keys (see slug format above).
