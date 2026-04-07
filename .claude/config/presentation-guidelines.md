# Pulse Device Sourcing — Presentation Build Guide
## For use in a new Claude conversation

---

## 1. What This Presentation Is

A 14-slide deck for the BU (Kevin Wang, GM Pulse) presenting 7 weeks of device sourcing work for the Pulse cardiometabolic programme. Two devices: BPM + BIA Smart Scale for Q2 2026 launch.

**Audience:** BU leadership, not technical. They care about: what devices are recommended, how much it costs, what risks exist, and what they need to decide.

**Structure (final, v9):**
1. Cover (+ "BPM + BIA Scale | Q2 2026" subtitle)
2. Divider: The Market
3. Statement + Supply Chain map (merged, one slide)
4. Divider: The Journey
5. Scale funnel (5 suppliers, 12 devices, 1 selected)
6. BPM funnel (9 suppliers, 7 tested, 1+1 leader + alternative)
7. BPM Shortlist (2 cards: PRIMARY + ALTERNATIVE)
8. Divider: The Result
9. Competitive edge (3 verified statements on gradient)
10. Cost comparison (totals only, no BPM/Scale breakdown)
11. Risks & Gates (3 cards + lead time table)
12. Decisions (3 numbered items, all blue)
13. PLD vs Distributor (two columns, support slide)
14. Thank you

**What was removed (and why):**
- The Brief slide: BU already knows context. "20K" vs "5K initial order" creates confusion.
- Separate big statement slide: merged with supply chain map for tighter flow.
- 4th decision item (A&D fast-track): absorbed as note under item 01 after Transtek stock confirmed.
- Scale choice decision: already made by BU Apr 1.

---

## 2. Sword Brand Guidelines (extracted from template)

### Colors
```
bg:     "F5F3EE"   (cream, main background)
dark:   "1F222C"   (near-black, text and dark slides)
blue:   "7BA7D1"   (Sword blue, accent numbers and headers)
coral:  "E8A5A0"   (Sword coral/pink, accent bars and highlights)
accent: "5B8DB8"   (darker blue, used for Transtek box, chart bars)
light:  "E8E4DF"   (light cream, used for subtle backgrounds)
white:  "FFFFFF"
muted:  "A4AAB6"   (gray, secondary text and labels — NOT 8C8C8C)
green:  "4CAF7D"   (ONLY for: funnel "selected" bar, "PRIMARY" label)
red:    "D35D5D"   (ONLY for: single warning item, "RISK" text)
orange: "E5A34B"   (ONLY for: "ALTERNATIVE" label, "GATE" text on PLD)
tblAlt: "E4EEF8"   (alternating table row fill)
```

### Color restraint rules (learned v9)
- **Default everything to dark (#1F222C) or muted (#A4AAB6).**
- Green, red, orange are functional only. Never decorative.
- No filled badge rectangles. Use colored text instead.
- No accent bars/lines on cards. White cards with shadow only.
- Bullet lists: dark text. Only highlight a single warning item in red.
- Numbered items (decisions): all blue. No color-coding by priority.
- Pros/cons on comparison slides: green/red is acceptable on shortlist cards (S7), but NOT on PLD comparison (S13).

### Typography
- **Font:** Montserrat (embedded in template: Montserrat, Montserrat Medium, Montserrat SemiBold)
- **Titles:** 24pt bold:false (Montserrat Medium), color dark (#1F222C)
- **Subtitles/labels:** 11pt, color muted (#A4AAB6)
- **Body text:** 9-11pt
- **Big statements:** 18-20pt bold:false on gradient background
- **Stat numbers:** 24-26pt bold:false, blue

### Layout Patterns (from template)
- **Logo:** Sword logo at top-left (x: 0.55", y: 0.35", w: 1.08", h: 0.26") on all content slides
- **Title area:** Subtitle at y: 1.0", title at y: 1.25" (below logo)
- **Content starts:** y: 2.0" on most slides
- **Slide dimensions:** 10" x 5.625" (16:9)
- **Margins:** minimum 0.5" from edges
- **Cards:** white fill with subtle shadow (blur: 4, offset: 1, opacity: 0.04). NO accent bars.
- **Divider slides:** gradient backgrounds extracted from template. Left-aligned text at y: 2.2".
- **No dark slides.** Template uses gradient backgrounds (cream-to-blue, cream-to-pink), never solid dark.
- **Tables:** blue text headers (#7BA7D1), alternating white/blue rows (#E4EEF8), 0.5pt light borders.

### Assets Required
- **Sword logo:** extracted from template as PNG (442x108px, RGBA). Store as base64 in assets/logo.b64.
- **Gradient backgrounds:** extracted from template slides (cover, dividers, competitive edge, thank you). Each stored as assets/Slide-N-image-1.png.b64.
- **Icons:** react-icons (Font Awesome set) rendered as PNG via sharp. Use sparingly. Colors match brand palette.

---

## 3. Technical Approach

### Tool: pptxgenjs (Node.js)
Created from scratch, NOT from template XML editing.

### Dependencies
```bash
npm install -g pptxgenjs react react-dom react-icons sharp
pip install Pillow numpy --break-system-packages
```

### Icon Rendering
```javascript
const React = require("react");
const ReactDOMServer = require("react-dom/server");
const sharp = require("sharp");

async function iconToBase64Png(Icon, color, size = 256) {
  const svg = ReactDOMServer.renderToStaticMarkup(
    React.createElement(Icon, { color, size: String(size) })
  );
  const buf = await sharp(Buffer.from(svg)).png().toBuffer();
  return "image/png;base64," + buf.toString("base64");
}
```

### Shadow Helper (NEVER reuse objects in pptxgenjs)
```javascript
const mkShadow = () => ({
  type: "outer", blur: 4, offset: 1, angle: 135,
  color: "000000", opacity: 0.04
});
```

### Slide Header Helper
```javascript
function addLogo(slide) {
  slide.addImage({ data: LOGO_B64, x: 0.55, y: 0.35, w: 1.08, h: 0.26 });
}
function addHeader(slide, sub, title) {
  addLogo(slide);
  slide.addText(sub, { x: 0.55, y: 1.0, w: 8, h: 0.3,
    fontFace: "Montserrat", fontSize: 11, color: "A4AAB6", margin: 0 });
  slide.addText(title, { x: 0.55, y: 1.25, w: 8, h: 0.6,
    fontFace: "Montserrat", fontSize: 24, color: "1F222C", bold: false, margin: 0 });
}
```

### Asset Preparation (run before building slides)
1. Extract logo from template: `ppt/media/image1.png` -> base64
2. Extract gradient backgrounds from template slides -> base64
3. Store all assets in assets/ directory

### QA Process
```bash
soffice --headless --convert-to pdf output.pptx
pdftoppm -jpeg -r 150 output.pdf slide
# Then view each slide-XX.jpg
```

### Common Pitfalls Fixed During Build
- **Slide overflow:** Content pushed below 5.625" height. Always verify y + h < 5.5" for bottom elements.
- **pptxgenjs shadow mutation:** NEVER reuse shadow objects. Use factory function.
- **No "#" in hex colors:** pptxgenjs corrupts files if you use "#FF0000".
- **bold: false not bold: true.** Template uses Montserrat Medium, which in pptxgenjs = bold:false.
- **Muted color is A4AAB6, NOT 8C8C8C.** This was a critical correction from template analysis.
- **No dark slides.** Every "statement" slide uses a gradient bg from the template, not solid dark.
- **Tables near bottom edge:** Need row heights of 0.2" max and verify last row doesn't clip.
- **FOB vs landed mixing:** Never compare FOB and landed prices in the same visual without a note.
- **Unverifiable claims:** Every number on a slide must trace to a source. "$1 more" was wrong. Use exact prices.

---

## 4. Content Decisions Made (v9 final)

### What the BU wants to see
1. Start with the market insight ("one factory"), not with the brief
2. Show the journey as a funnel, not a timeline
3. Competitive edge before cost (qualitative value first, then numbers)
4. Cost as totals only (no BPM/Scale breakdown to avoid exposing that Transtek BPM > A&D BPM)
5. Decisions as direct questions, all blue numbers
6. PLD as support/reference slide AFTER decisions (not 3 consecutive PLD mentions)

### What was cut
- The Brief slide (20K vs 5K confusion)
- Week-by-week timeline
- BPM/Scale cost breakdown (Transtek BPM is $12K more than A&D BPM at 20K; savings come from scale)
- "$1 more than weight-only" claim (unverifiable)
- "Half the price of A&D" claim (mixes FOB/landed)
- Filled badge rectangles (GATE/RISK)
- Accent bars on cards
- Green/red bullet colors on PLD slide
- 4th decision item (A&D fast-track)

### Key narrative beats
1. "One factory makes nearly every BP monitor" (surprise/credibility)
2. Funnel visualizations show the work without explaining it
3. Competitive edge: first RPM with BIA, same OEM as competitors
4. Cost: 24% saving driven by scale sourcing
5. Decisions before PLD detail (action first, reference after)

---

## 5. Data Sources

All data was gathered from:
- **Notion:** Project hub, Suppliers DB, Testing pages, Market Investigation pages
- **Gmail:** 381 emails (Feb 19 - Apr 7, 2026)
- **Slack:** Cross-functional messages
- **WhatsApp:** Transtek (Mika Lu) inventory confirmation

### Key numbers in the presentation
- 13 suppliers identified (from Suppliers DB)
- 12 BIA scales tested, 1 selected (from BIA Testing page)
- 7 BPMs tested, 1 leader + 1 alternative (from BPM Testing page)
- 381 emails (from Gmail search)
- $547K recommended combo (BB2284-AE01 + CF635BLE)
- $535K fallback (UA-651BLE + CF635BLE)
- $720K A&D baseline

### Notion links embedded in slides
- S3: BPM Market Investigation, Scale Market Investigation, FDA Regulatory Landscape
- S5: BIA Scale Testing & Evaluation
- S6: BPM Testing & Evaluation
- S13: IFU / Labeling

---

## 6. Files

- **Template:** `Copy_of_Sword_Deck_Template_2024.pptx` (upload to new conversation for asset extraction)
- **Build guide:** This file (PRESENTATION_BUILD_GUIDE.md)
- **Briefing doc:** `pulse_sourcing_briefing_v3.md` (speaker notes, full narrative)
- **Final deck:** `Pulse_Device_Sourcing_v9.pptx` (14 slides, current version)
- **Assets:** extracted to assets/ directory (logo.b64, gradient PNGs)

---

## 7. What to Do in a New Conversation

1. Upload the template PPTX (for asset extraction)
2. Upload this build guide
3. Say: "Build a presentation following this guide. The topic is [X]."
4. For iterations: upload the current PPTX and say "iterate on this"

### Key reminders for any Claude conversation
- Never use em dashes
- Short sentences
- Write like a colleague, not a consultant
- No filler words
- All Notion content in English
- Verify every claim before putting it on a slide
- QA every build visually (soffice + pdftoppm)
- Color restraint: dark + muted + blue. Green/red/orange only where functional.
