---
name: Bjola Open Source
description: A working ledger of small software, experiments, and build notes.
colors:
  workbench-paper: "#F3EFE5"
  ledger-paper: "#FFFDF7"
  workshop-ink: "#171715"
  graphite: "#5C5A54"
  rule: "#B8B1A1"
  instrument-cobalt: "#164A9B"
  safety-orange: "#A43F13"
  signal-yellow: "#F2B84B"
typography:
  display:
    fontFamily: "Archivo, Arial, sans-serif"
    fontSize: "clamp(3rem, 8vw, 7rem)"
    fontWeight: 800
    lineHeight: 0.92
    letterSpacing: "-0.055em"
  headline:
    fontFamily: "Archivo, Arial, sans-serif"
    fontSize: "clamp(2rem, 5vw, 4.5rem)"
    fontWeight: 750
    lineHeight: 1
    letterSpacing: "-0.04em"
  body:
    fontFamily: "Literata, Georgia, serif"
    fontSize: "1rem"
    fontWeight: 400
    lineHeight: 1.72
  label:
    fontFamily: "Azeret Mono, Consolas, monospace"
    fontSize: "0.75rem"
    fontWeight: 600
    lineHeight: 1.3
    letterSpacing: "0.06em"
rounded:
  mark: "2px"
  control: "6px"
  image: "10px"
spacing:
  xs: "4px"
  sm: "8px"
  md: "16px"
  lg: "24px"
  xl: "40px"
  xxl: "64px"
components:
  button-primary:
    backgroundColor: "{colors.instrument-cobalt}"
    textColor: "{colors.ledger-paper}"
    typography: "{typography.label}"
    rounded: "{rounded.mark}"
    padding: "12px 16px"
  button-secondary:
    backgroundColor: "{colors.ledger-paper}"
    textColor: "{colors.workshop-ink}"
    typography: "{typography.label}"
    rounded: "{rounded.mark}"
    padding: "12px 16px"
  status-label:
    backgroundColor: "{colors.signal-yellow}"
    textColor: "{colors.workshop-ink}"
    typography: "{typography.label}"
    rounded: "{rounded.mark}"
    padding: "5px 8px"
---

# Design System: Bjola Open Source

## Overview

**Creative North Star: "The Annotated Workbench"**

The physical scene is a well-used electronics workbench after lunch: an open
lab notebook, labelled drawers, one cobalt instrument panel, and evidence of
real work rather than staged decoration. The composition behaves like a project
ledger. Rules, sequence numbers, annotations, and status labels create the
structure; restrained irregularity supplies the human layer.

This is not a fake control panel. Decoration never interrupts reading order,
and the blog remains editorial and calm. The site explicitly rejects generic
SaaS landing pages, fake terminals, neon AI imagery, glassmorphism, gradients,
corporate portfolio theatre, and a visual clone of Bjola.ca.

**Key Characteristics:**

- Paper, ink, cobalt, and one safety accent.
- One dominant project followed by ledger rows, never an equal card wall.
- Visible status language and compact technical metadata.
- Quiet article typography with generous reading measure.
- Flat surfaces, hard rules, and almost no ornamental motion.

## Colors

The palette combines workshop paper and black ink with a committed cobalt panel
and small, functional safety accents.

### Primary

- **Instrument Cobalt:** The working colour for the masthead, primary actions,
  selected states, and the featured-project field.

### Secondary

- **Safety Orange:** Used sparingly for registration marks, links on light
  surfaces, and small points of emphasis. It is never the only status signal.
- **Signal Yellow:** A high-visibility label ground for compact status text.

### Neutral

- **Workbench Paper:** The page ground, warm enough to feel physical without
  lowering contrast.
- **Ledger Paper:** Reading surfaces, project rows, and article pages.
- **Workshop Ink:** Primary text, borders, and strong interaction states.
- **Graphite:** Secondary text and metadata when full ink would dominate.
- **Rule:** Dividers and inactive outlines.

**The Instrument Panel Rule.** Cobalt may own one large region or a few controls,
but never every surface on the page.

**The Written Status Rule.** Colour may reinforce a status label; the words must
carry the meaning by themselves.

## Typography

**Display Font:** Archivo (with Arial fallback)

**Body Font:** Literata (with Georgia fallback)

**Label/Mono Font:** Azeret Mono (with Consolas fallback)

**Character:** Archivo supplies practical industrial weight, Literata keeps long
notes humane and readable, and Azeret Mono gives labels and measurements the
feel of real annotations rather than terminal cosplay.

### Hierarchy

- **Display** (800, fluid 3–7rem, 0.92): The homepage statement only.
- **Headline** (750, fluid 2–4.5rem, 1): Section and article titles.
- **Title** (700, 1.35–2rem, 1.1): Project names and note-list titles.
- **Body** (400, 1rem, 1.72): Descriptions and articles, constrained to 68ch.
- **Label** (600, 0.75rem, 0.06em tracking): Status, sequence, language, dates,
  and navigation annotations.

**The Three Voices Rule.** Archivo speaks names, Literata explains, and Azeret
Mono labels. Never assign a fourth personality to the page.

## Elevation

The system is flat by default and uses no ambient shadows. Depth comes from
tonal paper layers, one-pixel rules, overlapping registration marks, and a
two-pixel hard offset on active controls. Article images may sit above the page
through contrast alone.

**The Flat Workbench Rule.** If a soft shadow is needed to separate two surfaces,
the hierarchy or border is wrong.

## Components

### Buttons

- **Shape:** Nearly square with a slight easing at the corners (2px radius).
- **Primary:** Cobalt field, ledger-paper text, and compact label typography.
- **Hover / Focus:** A two-pixel hard ink offset on hover; a three-pixel yellow
  focus outline with a two-pixel gap on keyboard focus.
- **Secondary:** Ledger paper with a one-pixel ink border and the same dimensions.

### Chips

- **Style:** Written status labels on yellow or neutral paper, always bordered.
- **State:** Static labels do not imitate controls; interactive filters are not
  part of the initial site.

### Cards / Containers

- **Corner Style:** Project ledger rows are square; images use a gentle 10px
  radius only when their photographic edges need containment.
- **Background:** Ledger paper over workbench paper; the lead project may use
  cobalt as a full field.
- **Shadow Strategy:** None at rest.
- **Border:** One-pixel ink or rule lines define rows and groups.
- **Internal Padding:** 24px on small screens and 40px on wide screens.

### Navigation

Navigation is a visible workbench header, not a floating pill. Labels use mono
type, an underline or colour shift on hover, and the same explicit focus ring as
buttons. Mobile navigation wraps into two clean rows rather than hiding behind a
menu.

### Project Ledger

Each project entry includes sequence, name, observable status, short purpose,
implementation language, and repository/demo actions. The lead entry may show a
small process diagram; all later entries retain the same semantic order.

## Do's and Don'ts

### Do:

- **Do** let one featured project carry most of the visual weight.
- **Do** write every status in plain text and define the vocabulary once.
- **Do** retain a 68ch maximum for article prose and generous line height.
- **Do** use one-pixel rules, sequence numbers, and annotations to create rhythm.
- **Do** make every repository, demo, feed, and note reachable by keyboard.

### Don't:

- **Don't** build a generic SaaS landing page with a hero slogan, equal feature
  cards, and repeated calls to action.
- **Don't** use corporate portfolio theatre or inflated claims about reach and
  maturity.
- **Don't** use fake terminals, decorative dashboards, neon AI imagery,
  glassmorphism, or gradients used as a substitute for hierarchy.
- **Don't** turn Notes into a content-heavy magazine or make publishing a short
  note ceremonial.
- **Don't** make a visual clone of Bjola.ca. The two sites are siblings, not
  duplicates.
- **Don't** use orange text below normal-text contrast or colour alone to encode
  status.
