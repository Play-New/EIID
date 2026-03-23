# Design Init Guide

Detailed process for each step of `/super:design` init mode. The command file defines the flow. This file defines the execution.

Steps 1-5 are problem-solving. They apply to ALL products. Step 6 detects the UI framework (non-visual products skip it and jump to step 13). Steps 7-12 are visual execution and apply only to visual layers.

## Interface Modality Assessment

Read the EIID mapping from CLAUDE.md. For each layer, determine the interface modality:

**Enrichment:** How does data enter the system? If users contribute through existing channels (chat messages, email, photos, voice), the design problem is input format and confirmation, not web forms. If enrichment requires manual configuration (API keys, polling rules, source selection), that configuration needs a visual settings surface.

**Inference:** Where do patterns surface? If inference is an internal pipeline with no user-facing controls, no interface is needed. If users configure rules, thresholds, or models, that configuration needs a visual surface. If inference produces real-time status that users monitor, that needs a visual dashboard.

**Interpretation:** How do users consume insights? Self-contained statements that fit in a message (a number, a verdict, a recommendation) work conversationally. Spatial understanding (charts, maps, timelines, multi-variable comparison) requires a visual surface. Most products have both: headline conversational, detail visual.

**Delivery:** List every output channel. For each: input-only, output-only, or bidirectional? What format constraints does the channel impose?

Produce the EIID Interface Map table (see `reference/design-system-template.md`).

**Routing:**
- If ALL layers are conversational, notification, or embedded: no graphical interface is needed. Steps 7-12 are skipped entirely. The design system covers experience patterns, message structure, channel formatting, and agent interaction patterns. This is a valid, complete outcome.
- If SOME layers need a visual surface: proceed with visual design steps, scoped to those layers only.
- If ALL layers need a visual surface: proceed with the full visual design process.

## Explore the Product's World

> This section applies to ALL products, not just visual ones. A WhatsApp-only product, a CLI tool, an agent — all have a world, a voice, a signature. Skip only the visual-specific items (color world, spatial composition, atmosphere) for non-visual products.

Read CLAUDE.md for business context and EIID mapping. Before choosing any direction, explore:

**How should they feel?** This is the foundational question. Read the target feeling from CLAUDE.md (set during strategy). Everything that follows — every direction choice, every token, every message pattern, every prompt, every agent behavior — serves this feeling. If strategy defined "calm control", every design decision is tested against: does this contribute to calm control, or does it create noise?

**Who interacts with this product?** Not "users" — the actual person. Where are they? What's on their mind? What device, what channel, what moment? A fleet manager getting a WhatsApp alert between site visits is not a developer reading CLI output at their desk.

**What must they accomplish?** The verb. Grade submissions. Find the broken deployment. Approve the payment. Choose what to cook.

**What should this feel like?** Translate the target feeling into sensory and behavioral terms. Not "clean and modern" — that means nothing. For visual products: warm like a notebook? Dense like a trading floor? For conversational products: concise like a colleague? Warm like a friend? For CLI: precise like a surgical tool? For agents: knowledgeable like an expert? Proactive like an assistant?

Then produce:

- **Domain concepts:** 5+ metaphors and vocabulary from this product's world. Not features — territory. These apply to naming, voice, terminology across all modalities.
- **Color world:** (visual products only) 5+ colors that exist naturally in this product's domain.
- **Signature:** One element that could only exist for THIS product. Can be visual (a unique component), behavioral (an agent that proactively surfaces relevant info), conversational (a distinctive way of presenting insights), structural (a CLI output format that makes data scannable in a unique way).
- **Defaults to reject:** 3 obvious choices you will NOT use. Name them explicitly. This applies to all modalities — "no generic chatbot greeting" is as valid as "no generic card grid."

For visual products, also consider:

- **Spatial composition:** asymmetry, overlap, density variation, grid-breaking as intentional choices.
- **Atmosphere:** backgrounds as environments. Gradient, grain, texture that matches the direction.
- **Anti-convergence:** if another AI given similar prompts would produce substantially identical output, the design has failed.

Do not propose a direction until domain concepts, signature, and defaults to reject are produced.

## Direction Assessment

Present findings from the exploration to the user. Then collect input in a single block. The user answers what they want, skips what they don't.

**References:**
"Any references for how this product should feel? URLs of products you admire, screenshots, brand names, designers, or design studios. These can be non-visual too: 'the tone of Stripe's error messages', 'the pacing of GitHub Copilot's suggestions.' Even from different domains, as long as something about them feels right for this product."

For each reference provided:
- URLs: fetch the page, analyze the relevant patterns (visual: layout density, palette, typography; conversational: message structure, tone, pacing; CLI: output format, information density)
- Screenshots/images: view the image, same analysis
- Figma URLs: get design context via Figma tools, same analysis
- Brand names: search for the brand's identity and communication style, then analyze
- Designers or design studios: research their body of work, philosophy, signature patterns, and decision-making principles. Apply their perspective as a lens throughout the design process. Not "copy their style" but "how would they approach this problem for this product."

**Anti-references:**
"Anything you've seen and actively don't want? Products, styles, tones, or patterns that would be wrong here."

**Existing assets:**
"Any brand material? Logo, colors, fonts, illustration style, tone guide. Even a rough sketch."

For existing assets: analyze and incorporate as constraints. Brand colors become the palette foundation. Brand fonts skip the typography selection step. A logo's character informs the direction. A tone guide constrains the voice.

**Direction check:**
"The exploration produced this direction: [summary]. Does this match? Anything to push further, pull back, or change entirely?"

**Constraints:**
"Hard constraints? Required colors, mandated fonts, accessibility targets beyond AA, platform requirements."

Process all inputs. For each reference and anti-reference, extract concrete patterns:
- What to borrow: specific and named ("the tight sidebar density from Linear", "the conversational pacing from Notion AI")
- What to avoid: specific and named ("the generic card grid from that SaaS site", "the explanation dumps from ChatGPT")

Produce a reference summary: 3-7 distilled patterns across all references.

Revise the direction based on assessment answers. If the user provided nothing, proceed with the exploration direction as-is.

Store the reference summary in `.superskills/design-system.md` under a References section.

---

## Visual Execution Steps (7-12)

> These steps apply only to layers mapped to a visual modality. Skip all for non-visual products. The problem-solving is done — steps 1-5 defined what the product needs, how it should feel, and how it speaks. These steps define how it looks.

## Style Direction

For shadcn projects, run `npx shadcn@latest init` to see available styles. Pick the one that matches the product's character. Present the recommendation to the user with reasoning.

Three dimensions to decide:
- **Density:** tight (data-heavy, admin) vs. generous (consumer, editorial)
- **Shape:** sharp/boxy (technical) vs. rounded/pill (approachable)
- **Weight:** compact (efficiency-first) vs. spacious (comfort-first)

For non-shadcn projects, skip this step — the equivalent decisions are encoded directly in the theme file.

## Typography Scale

Ask the user if they have brand fonts first. If they do, use those.

If not, read `reference/design-craft.md` Typography Character section. Choose based on the product's character, not popularity. **The default test:** if the font ships with the framework, it's not a design decision.

Determine how many type voices this product needs. Some products need one font at different weights. Some need a display font + body font pair. Some need three (display, body, mono). The number of typefaces is a design decision, not a rule.

Expand from font choice to a full type scale. Define every level from Display through Mono: size, weight, line height, tracking, and usage. Apply the hierarchy test: strip color. If hierarchy collapses, add more size or weight contrast.

## Layout Architecture

Define the spatial structure. Decisions flow from IA.

**Grid:** column count, gutter size, system. Not every product needs 12 columns.
**Breakpoints:** pixel values and what shifts at each.
**Container:** max-width strategy for different screen types.
**Page patterns:** 3-5 recurring layout structures, each mapped to screen types from the IA.

## Composition Rules

Five decisions between layout and tokens:

**Hierarchy:** how primary/secondary/tertiary are distinguished. Must work without color.
**Density map:** which zones are dense, which are generous, why.
**Section rhythm:** three numbers (major sections / groups / items).
**Proportion:** focal point vs supporting content size.
**Whitespace:** page margins, breathing room, grouping vs separating gaps.

## Token Generation

All aesthetic choices become design tokens. No creative decision lives in component code.

**Extract before propose:** if existing UI code is present, scan for repeated values first. Count occurrences, propose a token set that formalizes them. Ask the user to confirm.

**For shadcn + Tailwind:**
- CSS custom properties in OKLCH (Tailwind v4) or HSL. Both `:root` and `.dark`
- Token names should evoke the product's world
- Set up cn() utility: `npm install clsx tailwind-merge`
- Initialize: `npx shadcn init`
- Add only the components this product actually needs (derived from IA and screen map)

**For Chakra/MUI/Mantine:** Create theme.ts with full token set. Wrap app in the framework's provider.

**For Tailwind only:** Create globals.css with CSS variables. Configure tailwind.config.ts extending from variables.

**Key rule:** the token file IS the aesthetic. Strip all components and rebuild from tokens alone — the product should still look the same.
