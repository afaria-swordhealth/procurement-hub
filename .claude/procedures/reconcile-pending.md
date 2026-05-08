# Reconcile Pending Actions

Validates the draft `## Pending Actions` and `## Carry-over items` list against current repo + change-log state before warm-up writes them to `outputs/session-state.md`. Eliminates stale assertions about work that was already done (a recurring class of friction — a builder that re-emits Apr-30-vintage TODOs even after the fix shipped on May 6).

Called from `commands/warm-up.md` Phase 10, immediately before the session-state.md write.

## Inputs

- `draft_pending_actions` — list of candidate Pending Action lines from the warm-up builder.
- `draft_carry_over` — list of candidate Carry-over lines.
- `outputs/change-log.md` — today's entries (header `## {today}` and below).
- Optional: yesterday's daily log (Notion) if Phase 2 already fetched it.

## Validation rules

For each candidate line, classify by pattern and apply the matching rule. **First match wins.** If no rule matches → pass through unchanged.

### Rule A — File-path assertion

**Pattern:** the line names a literal repo path (`config/...`, `outputs/...`, repo-root filename, or absolute Windows path).

**Check:** Glob for the file. If the assertion claims the file is *missing* and Glob finds it → drop. If the assertion claims a file is *present at an unexpected location* (e.g., "Stray file at repo root: X.txt") and Glob does NOT find it → drop.

**Drop log:** append to `outputs/change-log.md`: `[reconcile] dropped pending: "{first 60 chars of line}" — file-state check resolved.`

### Rule B — Config-content assertion

**Pattern:** the line says "Add X to config/Y.md" or "X missing from config/Y.md" where X is a domain, supplier name, key, or other grep-able token.

**Check:** Grep the target config file for X. If found → the work is already done; drop the assertion.

**Drop log:** same format as Rule A.

### Rule C — Today's change-log match

**Pattern:** a TODO-style assertion ("TODAY — Add 5 phone-stand domains", "Reply to Brian on CSV"). Doesn't reference a file path directly.

**Check:** Extract 3-5 distinguishing keywords from the assertion (proper nouns, supplier names, action verbs, numbers). Search today's `## {today}` change-log section. If 3+ keywords overlap with a single change-log entry that contains a completion verb (`added`, `wrote`, `sent`, `closed`, `created`, `delivered`, `updated`) → mark the candidate `[likely done — verify]` and KEEP it (do not drop). André sees both lines and can confirm in 5 sec.

**Why mark, not drop:** Rule C is fuzzy. False-drop loses information; false-keep wastes one line in the briefing. Asymmetric cost — prefer keep.

### Rule D — OI / Notion-state assertion

**Pattern:** assertion references an OI ID, Notion DB query, or "verify in Notion".

**Check:** none — Notion is authoritative and reconcile is read-only / file-bound. Pass through unchanged.

### Rule E — Calendar / time-window assertion

**Pattern:** the line begins with `**NOW (HH:MM–HH:MM)**` or names a time window that has already passed (system clock vs. window end).

**Check:** if window end < current time → drop the line. The window expired; whatever happened in it is in change-log already.

**Drop log:** same format.

## Failure mode

If reconcile cannot read change-log.md or a target config file: skip the rule for that line and pass it through. Log `[reconcile] skipped: {reason}`. Never block the warm-up briefing on reconcile failure.

## Carry-over items

Apply Rules A, B, C to `draft_carry_over` the same way. Drop items where the underlying state has resolved. Pattern-match is more important here because carry-over is, by definition, multi-day stale candidates — most likely to have rotted.

## What reconcile does NOT do

- Does not edit `session-state.md` directly. Only filters the in-memory list before warm-up writes.
- Does not consult Notion. File + change-log only.
- Does not promote items to Pending if they look stale-but-still-true (that's the warm-up builder's job, not reconcile's).
- Does not handle Slack / DM context. Slack scan output is structured separately in session-state and not reconciled here.

## Quick examples (real, from 2026-05-07 / 2026-05-08)

| Draft line | Rule fires | Outcome |
|------------|------------|---------|
| "Stray file at repo root: `C:Tempcelestica_bom.txt`" | A | Glob finds nothing at that path on 2026-05-08 → drop. |
| "Add 6 phone-stand domains to config/domains.md (yrightsz.com, gzbwoo.com, ...)" | B | Grep finds all 6 in domains.md → drop. |
| "TODAY — Reply to Brian Rentas (Nimbl) on CSV loading process" | C | Change-log mentions "Brian Rentas" + "CSV" but with no completion verb → keep. |
| "**NOW (11:30–13:00)** — Prep for Anand 13:00 meeting" | E | Window ended at 13:00; current time 17:48 → drop. |
| "BloomPod — Coin Cell HW Investigation (Pending, André, due 2026-04-24)" | D | Notion-state assertion → pass through. |
