# Writing Style - André Faria
# Extracted from real email analysis (20+ emails, Feb-Apr 2026)
# Used by: supplier-comms agent for all drafts

---

# 1. Core Rules

- No em dashes. Use commas, periods, or "or" instead.
- Short sentences. One idea per sentence.
- No filler: "notably", "furthermore", "it's worth mentioning", "it's important to note", "I wanted to reach out".
- No excessive courtesy padding. One "thank you" per email is enough.
- Sign-off: "Best," (default) or "Thanks," (internal/casual). Never use "Best regards,". Do NOT add "André Faria" after the sign-off. The name comes from the signature block.
- Email signature: Always append the HTML signature from .claude/config/signature.html after the sign-off in every Gmail draft. Read the file and include verbatim. The signature already contains André's name, so never duplicate it above.
- Never start with "I hope this email finds you well" after the first exchange.

---

# 2. Tone by Audience

## Chinese suppliers (Transtek, Unique Scales, Finicare, Xinrui, Daxin, Ullwin, Yilai)
- Greeting: "Dear [Name]," (first email and formal) or "Hi [Name]," (established relationship, e.g. Queenie, Mika)
- Language: Simple, clear English. Short paragraphs. Avoid idioms and complex sentence structures.
- Be direct but polite. Chinese suppliers expect clarity over warmth.
- Use numbered lists for multiple questions. They respond better to structured requests.
- When asking for documents: "Could you please share..." or "Could you please provide..."
- When requesting action: "Please go ahead and..." or "Please proceed with..."
- When acknowledging: "Thank you for the detailed responses" or "Thank you for your prompt response"
- NEVER use slang, contractions, or overly casual language.

## Portuguese suppliers (Ribermold, Vangest, Uartronica, MCM, Quantal, Carfi)
- Write in Portuguese.
- Greeting: "Bom dia [Name]," or "Olá [Name],"
- Tone: direct, professional, slightly warm. Like a colleague, not a client.
- Sign-off: "Cumprimentos, André" or "Obrigado, André"

## Internal (Jorge, Anand, Pedro, Bianca, Miguel, Max, Caio)
- Casual but professional. First name basis.
- Greeting: "Hi [Name]," or just start with content if in a thread.
- Can use short-form: "Thanks", "Got it", "Will do"
- Jorge/Anand (management): numbers-driven, executive tone in reports. Casual in Slack/email.
- Pedro (engineering): technical, specific, include model numbers and BLE details.
- Bianca/João (regulatory): precise, reference FDA codes and classifications.
- Max/Caio (Kaia stakeholders): business-oriented, focus on costs and timelines.

## US suppliers (ProImprint, A&D Medical, IPADV)
- Standard professional English.
- Greeting: "Hi [Name],"
- Slightly more casual than CN suppliers but still professional.

---

# 3. Email Structure Patterns

## First outreach (RFQ)
```
Dear [Team/Name],

I hope this finds you well. My name is André Faria and I'm a Technical Sourcing Engineer at Sword Health, a digital health company focused on musculoskeletal and cardiometabolic care.

We are launching [program name], and are looking for a vendor partner to supply [devices]. We are looking at an initial volume of [X] units, with delivery to [location] during [timeline].

I've attached our device specifications document for your review.

I would love to set up a quick call to go over the requirements together. I'm flexible on timing.

Looking forward to connecting.

Best,
```

## Follow-up (requesting info)
```
Hi [Name],

Thank you for [what they sent/did].

A few follow-up questions:
1. [Question]
2. [Question]
3. [Question]

Best,
```

## Sample request
```
Dear [Name],

[Context if needed]

Could you please prepare samples of [models]? Once you provide the package dimensions, weight, and a proforma invoice for customs, we will arrange a DHL shipping label.

Best,
```

## Goodwill sample negotiation
```
Dear [Name],

As part of our standard evaluation process, Sword Health covers the international shipping costs by providing a prepaid DHL label. Given the significant cost of this shipment on our end, we ask our partners to provide the sample units at this stage as a gesture of goodwill and partnership.

If you are open to this arrangement, please share the exact dimensions and weight once the parcel is packed, and we will arrange the shipping label immediately.

Best,
```

## Technical question
```
Hi [Name],

Thank you for [context].

[Direct question with specific technical detail, model number, field name, etc.]

Could you confirm if [specific behavior/spec]?

Best,
```

## Acknowledgment (short)
```
Hi [Name],

Thank you for [what they provided]. I will [next action] and keep you posted.

Best,
```

## Document request (regulatory/compliance)
```
Dear [Name],

As part of our standard procurement process, we are collecting technical documentation for all devices under active evaluation.

For the [model], could you please share [specific documents]?

These documents are essential for our screening process.

Best,
```

---

# 4. Phrases André Uses Frequently

- "Thank you for the detailed response"
- "Thank you for your prompt response"
- "Could you please provide/share/confirm..."
- "As part of our standard evaluation/procurement process"
- "We appreciate the support from your team"
- "Please go ahead and..."
- "I will keep you updated on our progress"
- "I will share this information with the team"
- "Looking forward to hearing from you"
- "Please let me know if you need anything else from our side"
- "Your feedback and collaboration during this phase are very important to us"

---

# 5. Things André Never Says

- "ASAP" or "urgent" to suppliers (creates wrong dynamic)
- Prices from other suppliers (never reveal competitive quotes)
- Internal decision timelines ("we're deciding this week")
- Negative comments about other suppliers
- "We might not go with you" (keep all doors open)
- Overly enthusiastic language ("amazing!", "fantastic!")
- "Per my last email" or passive-aggressive phrasing

---

# 6. Slack Communication Strategy

Slack messages serve different purposes than emails. Approach them as internal coordination tools, not formal communications.

## General approach
- Always use `slack_send_message_draft`. André reviews the draft in Slack UI and sends manually. Live `slack_send_message` is only allowed after an explicit user phrase ("envia / send / posta / manda já / live") in the same turn or the immediately prior turn. See `.claude/safety.md` Core Rule 5b.
- Lead with the update or ask. No preamble.
- Keep it short. If it needs more than 5-6 lines, it probably belongs in an email or a Notion page.
- Match the channel's energy. #pulse-packagin-artwork is operational (BU visibility). #pulse-qara is technical (regulatory alignment). M-Band group DM is tactical (sourcing ops).

## Structure for channel updates
- **What changed**: one sentence on the event or new information.
- **Where to look**: embedded link to Drive, Notion, or thread. Never raw URLs, always `<URL|descriptive text>`.
- **What's next**: one line on pending actions or who's owning it.

## DMs and group DMs
- Conversational. Short messages. No sign-off needed.
- Jorge and Sofia: always in Portuguese.
- If relaying a decision or context from another channel, summarize, don't forward.

## Cross-channel posts
- When posting the same topic to multiple channels, tailor each message to that channel's audience and purpose. Don't copy-paste.
- Visibility channels (artwork, ISC): focus on what's happening and where to find files.
- Working channels (QARA, sourcing): focus on open questions, dependencies, and owners.

---

# 7. Notion Writing Rules

- All Notion content in English. No exceptions.
- Notes field: "TYPE (Location). Product + key differentiator. Flag." Max 2 lines.
- Outreach entries: see procedures/check-outreach.md for format and policy
- Daily log: prose bullets under project headers.
- Weekly report: executive tone, numbers-driven, scannable.
