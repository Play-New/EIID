# Design Craft

Craft is the accumulation of small decisions that determine whether a product feels designed or generated. These decisions happen at every touchpoint — not just screens. A prompt, a workflow, an agent response, a notification, a CLI output — every point where the product touches the user is a craft surface.

Every decision here traces back to strategy. The EIID mapping determines what needs attention. The target feeling determines the character. Craft serves strategy. Without that connection, a beautiful interface fails just as hard as an ugly one.

Read CLAUDE.md and `.superskills/design-system.md` before applying anything below.

---

## Part 1: Experience Craft (ALL modalities)

These sections apply to every product — visual, conversational, CLI, agent, workflow. Experience is not UI.

### Experience Craft

The difference between a product that works and a product that feels right. AI-generated products are functionally correct and experientially dead at every layer, not just the UI.

Experience craft is the WHY behind every behavior pattern. A prompt that leads with the answer exists because the product should feel respectful of the user's time. A loading message that says "Matching recipes from your pantry..." exists because the product should feel like it's working for you, not processing you.

**Feedback principles:**
- Every user action gets acknowledgment. The modality determines the form: visual surfaces use animation (100-200ms). Conversational channels use typing indicators and status messages. CLI uses progress bars. Notifications use delivery confirmation. The principle is universal — the implementation varies.
- Loading and processing states communicate WHAT the system is doing, not just THAT it is doing something. "Checking 3 sources..." not a spinner. "Matching against your pantry..." not "Processing...". This applies equally to a visual loading state, an agent's first message before delivering a result, and a CLI's progress output.
- Success feedback is proportional to achievement. A routine save is subtle. Completing a meaningful goal is a moment. This proportion applies in every modality: a WhatsApp agent's response to "I made the recipe!" should feel warmer than its response to "ok."

**Pacing principles:**
- The product has a rhythm that matches the target feeling. A precise operational tool is fast — answers first, details on demand. A warm reflective product is gentle — context before decision, space to think.
- In conversational flows: answer first, reasoning second. Lead with the insight, offer the "why" on request. Most AI agents dump their chain of thought. That's the agent's experience, not the user's.
- In workflows: communicate progress at each meaningful step, not just at completion. A 3-minute workflow that's silent until the end feels broken. One that says "Step 2/4: Checking availability..." feels alive.
- In prompts: the structure of the prompt shapes the structure of the response. A prompt that asks for a list gets a list. A prompt that asks for a story gets a story. The prompt IS the pacing tool.

**Voice and tone principles:**
- The product speaks with one voice across all surfaces. The same personality in error messages, success messages, agent responses, email subjects, WhatsApp replies, CLI output, and toast notifications. A warm product is warm when it fails too. A precise product doesn't suddenly get chatty in its onboarding email.
- Terminology is consistent across modalities. The dashboard says "3 vehicles need attention." The WhatsApp message says "3 vehicles need attention." Not "3 alerts detected" in one and "attention required for 3 assets" in the other.
- Error communication is actionable everywhere. "Photo too dark to read the receipt. Try with better lighting, or type the items instead" — not "Error: image processing failed." This applies to every error in every channel.

**Gratification principles:**
- Non-functional delight earns its place when it reinforces the target feeling. Visual: a progress ring that fills when the fleet is all-green. Conversational: an agent that remembers you made last week's recipe and asks how it went. CLI: a summary line that shows improvement over last run. Email: a subject line that IS the insight, not a notification label.
- First impressions have personality. The first thing a new user encounters — first screen, first agent message, first CLI output, first email — should embody the product's character.
- Discovery rewards across modalities. A keyboard shortcut hint. An agent that proactively surfaces something useful you didn't ask for. A CLI flag you didn't know about that appears when relevant.

**Restraint principles:**
- For every touchpoint, try removing it. If the feeling survives without it, remove it. This applies to words in a prompt, steps in a workflow, fields in a form, lines in a CLI output, sentences in an agent response.
- Silence is a pattern. Not every event needs a notification. Not every agent response needs an explanation. Not every workflow step needs a status update. The product should be quiet when nothing requires attention.
- In conversation: don't ask "Is there anything else?" after every answer. Don't front-load disclaimers. Don't repeat the question before answering.
- In prompts: every clause in a system prompt that doesn't change the output should be removed. Prompt bloat produces response bloat.

**The feeling test:** After building any touchpoint — a screen, a prompt, an agent flow, a notification template, a CLI output format — ask: does this feel like the same product? Does it carry the target feeling? A "calm control" product should feel calm in its WhatsApp messages as much as in its dashboard. If any touchpoint breaks the feeling, it breaks the product.

### Direction Spectrum

Not every product needs the same treatment. The direction places the product somewhere on these axes:

- **Density:** generous space (editorial, consumer) to packed information (admin, trading, ops dashboard). The user's task frequency and data volume determine this, not preference.
- **Temperature:** warm and organic (grain, rounded shapes, natural colors) to cold and precise (sharp edges, monospace, high contrast). The user's emotional context determines this.
- **Energy:** calm and restrained (reading, planning, reflection) to active and dynamic (monitoring, creating, responding). The task urgency determines this.
- **Complexity:** minimal surface (few elements, deep navigation) to maximal surface (many elements, shallow navigation). The information architecture determines this.

These are spectrums, not categories. Most products sit somewhere in the middle, leaning one direction. The point is to lean intentionally. These axes apply to all modalities: a CLI tool has density and energy. An agent has temperature and complexity.

### Conversational and Notification Craft

Skip this section if all EIID layers use visual or automated modality.

Non-visual channels deserve the same design attention as visual ones.

**Message structure:** Lead with insight, not context. The recipient knows what happened in the first line, why it matters in the second. Context follows, never leads.

**Information density per channel:**
- SMS: one fact, one action, 160 characters. No formatting available.
- WhatsApp / Slack / Telegram: headline + 2-3 context lines + action. Use native formatting (bold, lists, code blocks where supported).
- Email: full narrative with header, key metrics, recommended action, deep link to visual layer for detail.

**Interaction patterns:** Native to each channel. Reply-based for chat. Button-based where supported (Slack Block Kit, WhatsApp interactive messages). Link-based for email. Forcing web interaction patterns into chat creates friction.

**Formatting as hierarchy:** Bold for headline, plain for context, monospace for IDs and numbers, links for drill-down. The same three-tier hierarchy as visual typography, different tools.

**Timing as design:** When a message arrives is a design decision. Batching low-priority updates into a morning summary is good. A 3am alert for a non-urgent threshold crossing is bad. Delivery cadence communicates priority.

**Cross-channel coherence:** Same numbers, same terms, same framing across dashboard and message. The dashboard shows more detail, but the core statement is identical.

### Agent Interaction Craft

Skip this section if no EIID layer has a user-facing agent.

When an agent is part of the user experience, how it communicates is a design decision.

- **Transparency:** show what the agent is doing. "Checking 3 sources..." is better than a spinner. Users tolerate latency when they understand the work.
- **Progressive disclosure:** answer first, reasoning second. Lead with the result. Offer the chain of thought on request, not by default.
- **Clarification patterns:** ask specific questions with sensible defaults. "Thai or Japanese? default: Thai based on your pantry" beats "What cuisine would you like?"
- **Handoff agent → UI:** when text is not enough, link to the visual surface. The agent knows when a table or chart would serve better than a paragraph.
- **Tool use visibility:** describe actions semantically, not technically. "Checked your pantry" not "get_ingredients(user_123)".
- **Error communication:** honest and actionable. "Photo too dark to read the receipt. Try with better lighting, or type the items instead."

---

## Part 2: Visual Craft (visual layers only)

These sections apply only to products with layers mapped to a visual modality. They are execution details — the problem-solving (feeling, experience patterns, voice, pacing) is already defined in Part 1.

### Spatial Composition

Layout communicates before content does. Where things sit, how much space they get, and what breaks the grid tells the user what matters.

- **Density variation:** dense areas (data tables, metrics) signal "scan this." Open areas (hero sections, key actions) signal "focus here." The contrast creates rhythm.
- **Asymmetry:** intentional asymmetry (wider left panel, offset hero, unequal grid columns) creates visual interest and hierarchy. Use it where the content justifies it.
- **Overlap and layering:** elements can overlap, break out of containers. Use sparingly, at focal points.
- **Grid-breaking:** one element per screen that breaks the grid creates visual tension.
- **Negative space as element:** large margins = "this is important." Tight margins = "these belong together."

Spatial decisions follow the information architecture. Focal points get the most spatial weight.

### Typography Character

The font choice is the single biggest signal of whether a product was designed or generated.

**The default test:** if the font ships with the framework, it is not a design decision.

**Selection by character:** what does this product sound like? Browse foundries (Google Fonts, Fontshare, Atipo, fonts.bunny.net) with the product's character in mind.

**Type as structure:** typography hierarchy should work without color. Three levels minimum. Line heights: tighter for headings, generous for body. Monospace for data that needs alignment.

### Visual Identity

**Signature element:** one choice that could only exist for THIS product. FleetPulse's amber attention count. A reading app's page-turn animation. Emerges from the domain, not forced.

**Committed direction:** half-measures produce generic results. Commit to the direction fully.

**Decorative elements with purpose:** each earns its place. Disconnected from the direction = noise.

**The palette test:** can someone guess what kind of product this is from the palette alone?

### Subtle Layering

Surfaces that layer like paper, not colored blocks.

- **Lightness shifts:** small steps between adjacent levels. Felt, not counted.
- **Border opacity:** foreground color at low opacity instead of fixed gray.
- **Shadow progression:** same angle, same hue, increasing spread per level.
- **Dark mode:** surfaces get lighter as they elevate.

Pick one depth strategy and apply it everywhere.

### Atmosphere

Backgrounds are environments, not fill colors. Gradient, grain, or texture that matches the direction. Optional — absence of atmosphere is also a choice.

### Motion

Motion communicates state change, not decoration.

**Duration scale:** instant → responsive → snappy → smooth → deliberate. Each level should feel distinct.

**Easing:** enter (fast start, gentle land), exit (gentle start, fast disappear), move (smooth both ends).

**Orchestration:** one coordinated page load beats 15 independent animations. Stagger with consistent delay.

**Reduced motion:** wrap all animation in `@media (prefers-reduced-motion: no-preference)`.

### Color Intent

Every color has a job. Document the job, not just the value.

- **Foreground hierarchy:** primary, secondary, muted. Three levels.
- **Surface hierarchy:** base, card/panel, recessed, inset. Four levels.
- **Semantic:** success, warning, error, info. Never change meaning.
- **Interactive:** primary action, secondary action, destructive action.
- **Data:** 4-6 chart colors distinguishable in all forms of color blindness.

**Rule:** if two elements use the same color for different purposes, one needs a new token.
