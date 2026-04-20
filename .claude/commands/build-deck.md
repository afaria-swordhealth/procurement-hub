---
description: "Build a presentation following Sword brand guidelines. Usage: /build-deck {topic}"
args: topic
model: opus
---

# Build Deck

**Agents:** analyst (data gathering), notion-ops (Notion content)

## Pre-flight
1. Read .claude/config/presentation-guidelines.md (brand, structure, content rules)
2. Extract assets from .claude/assets/sword-template.pptx (logo, gradient backgrounds). Check that `.claude/assets/sword-logo.png` exists — if missing, WARN André before proceeding: "sword-logo.png not found in .claude/assets/ — slides will have no logo. Add it manually or continue without."
3. Read .claude/config/writing-style.md Style Rules section (no em dashes, short sentences)
4. Read .claude/config/strategy.md for any data rules (FOB vs landed, baselines)

## Steps
1. Ask Andre for: audience, structure preference, key message, number of slides
2. Gather data from Notion (supplier DBs, test reviews, project pages) as needed
3. Build slide outline and present for approval before building
4. Build PPTX using pptxgenjs following guidelines exactly:
   - Montserrat font, bold:false
   - Sword color palette (no # in hex)
   - Shadow factory function (never reuse objects)
   - Logo top-left on all content slides
   - Tables: blue headers, alternating rows
   - Cards: white fill, shadow
5. Run QA: check LibreOffice is on PATH (`libreoffice --version`). If missing, WARN: "LibreOffice not found — PDF conversion skipped. Verify slides manually." Otherwise convert to PDF, verify no clipping, no dark slides.
6. Present to Andre for review

## Rules
- Follow CLAUDE.md Safety Rules and Writing Style sections.
- Every number must trace to a source.
- Never mix FOB and landed without a note (see config/strategy.md Cost Analysis Rules section).
- Decisions before detail.
- Functional colors only (green/red/orange sparingly).
- Source links at bottom of relevant slides (8pt, blue, italic).
