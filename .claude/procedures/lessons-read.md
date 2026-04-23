# Lessons Read

Read-side procedure. Called by any skill that produces a draft or writes to Notion — in pre-flight, before composing the output.

## Purpose

Each skill accumulates `lessons.md` inside its own directory. When André edits or rejects a draft, the correction becomes a 1-line lesson. Next time the skill runs, it reads the top 10 lessons and prepends them to its working context — so the same edit doesn't have to be made twice.

Cap at 10 keeps bloat bounded. Newer lessons displace older ones.

## Location

```
.claude/skills/{skill}/lessons.md
```

One file per skill. Missing file = no lessons yet; skill proceeds normally.

## File format

```markdown
# Lessons — {skill}
<!-- Top 10 lessons. Newest at top. Oldest dropped on overflow. -->
<!-- Each lesson is one line. Written by /improve or by the skill itself. -->

1. {YYYY-MM-DD} — {one-line lesson}
2. {YYYY-MM-DD} — {one-line lesson}
...
```

## Reading rules

At pre-flight, in the skill that owns the lessons file:

1. Read `.claude/skills/{skill}/lessons.md`. If missing, skip.
2. Take lines 1–10 (top 10 in file order — newest at top).
3. Treat them as additional guidance for the run: apply before any default behavior.
4. Do not echo them in the final output to André. They are internal.

## Writing rules

**Skills are readers only.** No skill may write to its own `lessons.md` automatically. Only `/improve` may propose a lesson, and only after André approves it.

### By `/improve` at end of session
When André explicitly edits or rejects a draft and says *why*, `/improve` can propose:

```
Add lesson to {skill}/lessons.md?
"{YYYY-MM-DD} — {one-line lesson derived from the correction}"
```

André approves → append to the top (index 1). If file now has 11 entries, drop index 11.

### Skills: collect, never write
When a skill notices a repeated correction mid-run, it must NOT write to `lessons.md`. Instead, append a signal to `outputs/friction-signals.md` (Source E in `/improve`):

```
- [ ] [{today}] {skill}: repeated correction observed — "{one-line description}" — micro
```

`/improve` picks this up, proposes the lesson, and André decides. Unilateral skill writes bypass SHOW BEFORE WRITE and leave no approval trail.

## Lesson quality

A good lesson is:
- **Specific:** "Never say 'no rush' to CN suppliers" not "be firm".
- **One line:** if it needs two lines, it's two lessons.
- **Actionable at runtime:** something the skill can apply while composing.
- **Dated:** so `/improve` can retire stale ones (>180 days with no new corroboration).

Bad lessons to avoid:
- Generic style rules that already live in `config/writing-style.md`.
- Memory-style facts about the operator (those go in user memory, not here).
- Rules that belong in the skill's SKILL.md body — lessons are deltas, not base logic.

## Retention

- `/improve` monthly pass: drop lessons >180 days old unless they've been reinforced (dated range in body).
- If lessons.md hits 10 and a new one arrives, drop the oldest by date.
- Never delete a lesson mid-session just to make room. Batch retention at `/improve`.

## Relationship to memory and context

| Layer | Holds | Scope |
|---|---|---|
| User memory | Operator profile, preferences, durable rules | Cross-skill, cross-session |
| Skill lessons.md | Per-skill correction history | This skill only |
| Context files | Current supplier/project state | This week |
| Change-log | Daily activity trail | Today |

A correction that applies broadly → user memory. A correction specific to one skill's output shape → that skill's lessons.md. When unsure, prefer memory + skip the lesson.
