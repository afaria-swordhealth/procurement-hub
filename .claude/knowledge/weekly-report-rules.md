# Weekly Report — Rules & Editorial Standards

## Structure (fixed order, always)

1. **The big thing this week** — 1 sentence. The most impactful thing of the week. If nothing qualifies: "None"
2. **Snapshot** — status table by project. Addition to the corporate model.
3. **Good** — what moved forward.
4. **Bad** — what didn't go as expected.
5. **Worries** — active risks.
6. **Key decisions / asks** — what requires leadership visibility or decision.
7. **Goals last week** — with status indicators.
8. **Goals next week** — priorities.

---

## Section Rules

### The big thing
- 1 sentence max
- Only if something genuinely significant happened — otherwise "None"
- Qualifies as "big": a decision made, a milestone reached, or a risk resolved/escalated that changes the trajectory of a project
- Does NOT qualify: an activity, a meeting held, an email sent — only outcomes that shift something
- Synthesis beats specificity — if multiple gates closed, synthesise them into one headline rather than picking just one event
- What appears here does NOT repeat verbatim in Good — but Good may expand on it or detail its consequences

### Snapshot
- Table: Project / Status (🟢🟡🔴) / Trend (↗ → ↘) / Note (1 line)
- One row per active project (Pulse, Kaia, M-Band, ISC)
- Status reflects reality, not the desired state

### Good
- Outcomes only — what was decided, delivered, unblocked
- No operational trail (no emails, no supplier interaction sequences)
- Supplier names in Good: only when the outcome is supplier-specific and anonymizing would lose meaning (e.g. "Letter of Exemption received from primary BPM supplier" — no name needed; "Transtek confirmed as selected BPM supplier" — name justified)
- Supplier names in Bad / Worries: never — use role instead ("primary BPM supplier", "packaging supplier", "PCBA supplier")
- Max 3 bullets per project
- Language: "X was confirmed", "X was launched", "X was unblocked" — not "I sent / I called / I followed up"
- Confirmation language: if an outcome depends on pending third-party confirmation, use "advancing" instead of "confirmed" — reserve "confirmed" for outcomes with full closure
- A project with no deliverable that moves the project forward does NOT enter Good — it shows as → in Snapshot and, if relevant, appears in Bad. Note: a deliverable that prepares a decision (e.g. freight quotes consolidated, decision data ready) qualifies — the criterion is "did something move?" not "was a decision made?"

### Bad
- Factual and direct
- No individual names in negative context → use area/function instead (Legal, Finance, BU, R&S, Regulatory)
- No blame framing, no drama
- If nothing bad happened: "None"

### Worries
- Mandatory table format: Severity / What / Impact if unresolved / Deadline
- 🔴 Critical = blocks a delivery or decision
- 🟡 Moderate = under monitoring, not yet blocking
- If a worry has no concrete impact or no deadline → it is noise, do not include it

### Key decisions / asks
- Max 3 items
- Only genuine asks — not status updates dressed as asks
- Framing: "what's needed" — not "who is blocking"
- If nothing requires leadership action: "None"

### Goals last week
- Source: pull "Goals next week" from the previous week's report in Weekly Reports DB — do not reconstruct from memory or daily logs
- Four statuses: 🟢 Done / 🟡 In progress / 🔴 Not achieved or at risk / 🚫 Superseded (goal expired, was cancelled, or changed scope — no longer relevant)
- Order: 🔴 first, 🟡 second, 🚫 third, 🟢 last — active failures demand attention before closed ones
- No explanations — item + status only. Exception: one short parenthetical if the status is 🔴 or 🚫 and the reason is not obvious

### Goals next week
- Concise, max 10 items
- Ordered by priority, not by area

---

## Editorial Rules (apply to all sections)

| Avoid | Use instead |
|-------|-------------|
| Individual names in Bad/Worries/asks | Area or function (Legal, Finance, BU, R&S) |
| Supplier names in Bad/Worries | "primary BPM supplier", "packaging supplier", "PCBA supplier" |
| Operational detail | Outcome of the action |
| "I sent / I called / I followed up" | "X was confirmed / X is pending / X is blocked" |
| Worries without impact or deadline | Do not include |
| Key asks without a real decision needed | Do not include |
| More than 1 page when rendered | Cut — enforce editorial discipline |
| Internal housekeeping in any section | Omit entirely |

**Housekeeping = never include:** session management, context syncs, CLAUDE.md updates, command testing, tool/skill creation, system audits, cron configuration, DB cleanup, Notion restructuring. These are invisible infrastructure — not work output.

**Checklist is a filter, not a prescription.** If applying a rule mechanically produces worse output than editorial judgment would, flag the conflict rather than blindly following the rule. Quality overrides compliance.

---

## Corporate Alignment

This format is a superset of the Sword Health corporate weekly model (Good / Bad / Worries / Key decisions / Goals).
The only addition is the **Snapshot table** at the top, which provides a 10-second read for executives.
All other sections preserve the corporate labels exactly.

---

## Language
- Always English
- Colleague tone, not consultant tone
- No jargon unless it is standard Sword/ISC vocabulary
