---
description: Entry point. Takes any input — raw brief, pitch, idea, existing codebase — and produces a playbook decomposition with strategic challenge. The core of the plugin.
allowed-tools: Read, Glob, Grep, Write, Edit, WebSearch, WebFetch
---

# Strategy

Read `reference/concepts.md` for canonical definitions. Read `reference/example.md` to see a complete decomposition.

## Detect Mode

**1. Does a strategy exist?** Check for CLAUDE.md with a playbook mapping table.

**2. Route:**
- **No playbook mapping** -> run **init mode**
- **playbook mapping exists + user provided context about what changed** -> run **refresh mode**
- **playbook mapping exists + no context** -> "Strategy exists. Provide context about what changed to refresh it, or run `/playbook:review` to measure."

---

## Init Mode

### 1. Understand the Input

Scan the current directory for documents (md, txt, csv, json, pdf, images, docx, xlsx). Skip node_modules, .git, dist, build, .next, .vercel. If `.playbook/report.md` exists, read it — prior-run learnings inform this decomposition.

Adapt to what exists:
- **Brief or pitch deck?** Extract value proposition, client, market. Note what it claims vs assumes.
- **Existing codebase?** Read package.json, scan source, map existing code to layers, note the stack.
- **Just an idea?** Ask focused questions until the value is clear.
- **A mix?** Combine. Documents fill gaps the code doesn't explain.

### 2. Extract the Value

Three things must be clear before anything else:

1. **Who is the client** — who pays, who uses, their daily context.
2. **What value they expect** — the outcome user and product achieve together, in one sentence. Not features, not technology. What changes for them when this works.
3. **What accumulates from use** — what the product learns that the user teaches (knowingly or not) across hundreds of interactions, and what becomes the World Model that a competitor starting today could not replicate. If nothing accumulates, the product is replaceable by definition.

The folder scan already answered some of these. Ask only what's still missing. Reference what you found: "I see order data in the database and a WhatsApp integration — who is this for, what problem does it solve, and what should the product learn from every interaction?"

### 3. Research

Research does not confirm the brief. It tests it. Every search should produce evidence that directly feeds a field in the mapping. If a search doesn't change at least one node's evolution, metric, or graduation trigger, it was waste.

Run 5 searches in parallel, one per lens. Each lens feeds a specific part of the mapping. Interpolate variables from the brief into the queries — domain, technology, claimed asset, claimed market.

**Lens 1: Commodity check → feeds Evolution.**
For each technology or approach in the brief, search for how many providers, frameworks, or managed services exist. "RAG framework open source managed service comparison 2026" not "RAG overview." If there are 15+ providers, the node is commodity. If there's one paper and no product, it's genesis. The search must produce a number or a list, not a vibe.

**Lens 2: Adjacent products & gap → feeds Evolution + Challenge.**
Search for tools in the adjacent space. Not direct competitors — products solving a related problem. What do they do, and critically, what do they NOT do? The gap between what adjacent products offer and what the brief proposes is where the real value might be. If no gap exists, the brief is building something that already exists. Interpolate: "[domain] AI tool product what they do limitation gap [year]."

**Lens 3: Measurement patterns → feeds Metric/Signal + Loop.**
Search for how similar products in the domain measure quality. What metrics exist? Is feedback fast (automated, enables autoresearch) or slow (human judgment, manual review)? What acceptance rates or quality thresholds are published? If the domain is too new for published benchmarks, search adjacent domains for analogous metrics. Interpolate: "[domain] quality metric measurement acceptance rate feedback [year]."

**Lens 4: Graduation precedent → feeds Graduation.**
Search for cases where a similar approach transitioned from manual to automated, or from complex to simple. What triggered the transition? At what threshold? The brief may claim a node needs an ML model, but if evidence shows that rules work above 95% accuracy, that changes the graduation trigger. Interpolate: "[approach] transition manual automated threshold when to switch [year]."

**Lens 5: Asset & claim validation → feeds Challenge.**
The brief makes specific claims — a unique dataset, a market that exists, an asset that can't be replicated. Search for the specific claim, not the category. If the brief says "300+ titles," search for the actual catalog size. If it says "no one has this data," search for who might. One disconfirming fact is worth more than five confirming opinions.

**Lens 6: Regulatory posture → feeds Regulatory posture + Challenge + Annex.**
For EU-facing products, ground in current law. Perform the searches specified in `reference/regulatory-annex-template.md` §Required specific research (AI Act classification in the domain, competent DPA decisions, recent EDPB guidelines, CJEU case law, GPAI codes of practice, adequacy decisions status). Cite findings with dates — they populate the annex §12 Research table. If Lens 6 produces no evidence, flag in annex §10 as confidence defect.

After the first round, evaluate: which lenses produced evidence that feeds a mapping field? Which produced noise? Run a second round on the weak lenses only, with sharper queries informed by what the first round taught you. Stop when the results converge — additional searches return no new information.

If `.playbook/report.md` records research failures from a previous run (which lenses failed for this domain), skip those lenses and try alternatives.

### 4. Decompose into Nodes

From the folder scan, user context, and research, identify the components of the product. Work backward from what user and product do together: user need, what the product must observe and learn, required inference, and down to data sources. Every interaction is delivery + enrichment — the decomposition should show where both flows live.

For each node, determine five fields (see `reference/concepts.md`):

- **Layer** — which layer it serves (enrichment / inference / interpretation / delivery)
- **Evolution** — genesis, custom, product, or commodity. Use the research: how many providers exist? How standardized is the approach? For Delivery nodes: a static dashboard is product, a conversational interface that composes itself from capabilities is genesis.
- **Metric or signal** — what you measure to know if this node works. Metric for quantifiable things with fast feedback. Signal for things that require human observation.
- **Graduation trigger** — when to change approach AND what to change to. "When accuracy exceeds 95% for 2 weeks, replace with deterministic rules." Both the condition and the direction.
- **Loop** — autoresearch (metric is clean, feedback is fast, automated optimization is possible), manual review (signal requires human judgment), or N/A (commodity node, just monitor).
Every node must trace to user value, product learning, or both — and the best nodes do both (they deliver to the user while generating signal for the product). A node that exists because "products like this usually have it" does not belong.

### 5. Challenge

This is the most important step. For each node and for the decomposition as a whole, push back:

- **Genesis treated as obvious.** "This is your biggest challenge. How do you validate it before building everything else?"
- **Commodity built custom.** "This exists as a service. Buy it."
- **Missing layer.** "There's no delivery. How does the value reach the user?" or "There's no inference. What patterns are you detecting?"
- **Value node without metric.** "This is your most valuable node and it has no way to know if it's working."
- **Implementation confused with strategy.** "RAG is how. What is the what?" or "You described a dashboard. What insight does it deliver that a notification couldn't?"
- **Enrichment/Inference node without autoresearch.** "This node has a clean metric. Why not optimize it automatically?"
- **No genesis nodes.** "Everything here is commodity or product. Where are you creating new value? Without genesis, there's no product — just integration."
- **Brief that's really a feature list.** "These are outputs. What is the input? Where does the data come from? What patterns do you detect? Start from enrichment."
- **Unvalidated market.** "The brief lists 7 markets. Which one has the most urgent need AND where your asset gives the strongest signal? Pick one."
- **Incumbent closes the genesis.** "Is the incumbent in the adjacent space moving toward your claimed genesis? Evidence from Lens 2: what they do today, what they've announced, what their roadmap suggests. If the incumbent will close the gap in 6-12 months, your launch timing is a strategic variable — moving faster or picking a different genesis, not ignoring the threat."
- **Asset that doesn't exist yet.** "The brief says the corpus is unique. But it isn't structured. The moat is the structured knowledge, not the raw material."
- **No World Model.** "Every capability here is replicable. Does the Interface capture what users accept, ignore, modify, and ask for? If the product pushes value out but captures nothing back, it builds no World Model — and without a World Model, there is no compound advantage."
- **Value flows one way.** "Every Delivery and Interpretation node has a downstream path to the user. Which of them has an upstream path back — signal from use feeding earlier layers? A node that only delivers, never observes, is a dead-end surface. The product is deaf there."
- **World Model scope.** "Where does accumulation live — per-user, per-org, aggregate, or a mix? Each produces a different compound dynamic (churn resistance, account stickiness, network effects). A World Model without a declared scope is designing the wrong defensibility."
- **Prohibited practice — hard stop.** "Does any node touch AI Act Art 5 prohibited practices? Emotion recognition in workplace/education (Art 5(1)(f)), biometric categorisation inferring sensitive attributes (Art 5(1)(g)), social scoring (Art 5(1)(c)), manipulative/subliminal techniques (Art 5(1)(a)), exploitation of vulnerabilities (Art 5(1)(b)), untargeted facial scraping (Art 5(1)(e)), real-time remote biometric ID (Art 5(1)(h)). A prohibited practice is not a tier upgrade with more obligations — it is a redesign-or-don't-build decision. Verify this before any tier discussion."
- **Role underestimated (provider vs deployer).** "Who is the AI Act role? Shipping a product under your own brand built on Claude/GPT/Gemini makes you **provider** of the AI system (Art 3(3)) and downstream provider of the GPAI-integrated system (Art 25, Art 53(1)(b)) — not deployer. Misidentifying misaligns every obligation below. Full test in annex §2.2."
- **Regulatory tier unspecified or underestimated.** "What AI Act tier? Annex III use cases (biometrics, critical infrastructure, education, HR/employment, essential services, law enforcement, migration, justice) trigger high-risk obligations. Discovering this at launch is the most expensive EU-market failure mode. Cite Lens 6 evidence or flag low confidence."
- **Accumulation without lawful basis.** "Under what GDPR Art 6 basis does the World Model accumulate? If consent — how withdrawn without breaking the product? If legitimate interest — three-part test documented? Art 9 if special categories? Art 22 if per-user scope drives decisions with legal/significant effects? No declared basis = the World Model is liability, not moat."
- **Unexplored optimization space.** "This node has a clean metric but nobody is running experiments on it. Autoresearch explores spaces too large for humans. Is there a 65% improvement hiding in a pipeline nobody profiled?"

The challenge is not hostile. It sharpens the strategy. Acknowledge what's strong, then point to what's missing or misplaced.

### 6. Write

Strategy produces three outputs: one for the people deciding, one for the agents building, one for the lawyers reviewing.

**For the people: Strategic Assessment.** Present to the user before writing any file:

1. **What this product is** — one paragraph that restates what user and product do together, in clearer terms than the brief.
2. **Where the value is** — which node is genesis, why it matters, what makes it defensible.
3. **Where the challenge is** — which node is the weakest, what breaks if it fails.
4. **Where learning happens** — which surfaces are sensors, what signal they capture, where the World Model compounds across interactions. A product that delivers value but accumulates nothing is replicable regardless of how good its features are.
5. **Regulatory posture** — AI Act tier with reasoning, GDPR basis for the World Model accumulation, Art 22 implications, DPIA determination. If high-risk with no safeguards plan, this is the blocker before all other work. The full analysis is in the Regulatory Annex; this item summarises the top-line posture and flags blockers.
6. **What to do first** — the first concrete milestone, not the full roadmap. What validates the biggest challenge with the least investment.
7. **What not to do** — what the brief proposes that should be delayed, cut, or bought instead.
8. **Open questions** — what the research couldn't answer, what needs human judgment (product + regulatory).

This is the challenge translated into action. The user reads this and knows what to do next.

**For the agents: CLAUDE.md.** Use `reference/claude-md-template.md`. An agent reading it tomorrow with zero context must know: value location (genesis nodes), what the product accumulates (World Model), regulatory posture (role, tier, basis), what to build first, what to measure, when to change approach, which nodes auto-optimise. If any is unclear, rewrite. Show the user, confirm, then write.

**For the lawyers: Regulatory Annex.** Use `reference/regulatory-annex-template.md` for structure. Produce when EU-facing AND any of: personal data processed by us as controller/processor, Art 50 transparency obligations triggered (chatbot/deepfake/emotion/biometric), Annex III high-risk category, Art 22 automated decisions, special categories (Art 9), cross-border transfers, or user requests. **Skip the annex** when the strategy determines minimal-risk AI + no controller-side processing (e.g., fully local inference, no data leaving the user's device) — and document that determination in §5 of the Strategic Assessment with the reasoning. Skipping is itself a strategic choice that must be stated, not silent. The template carries the generation rules — cite articles, reason per determination, ground in Lens 6 research with dated sources, include the disclaimer, flag confidence. Show the user before writing. Write to `.playbook/regulatory-annex.md`.

If there are non-obvious choices worth logging, append them to `.playbook/report.md` under a Decisions section with date, reasoning, and which node they affect.

### 7. What's Next

Tell the user: run `/playbook:build` to start constructing from the strategy, or `/playbook:review` to measure an existing product against the mapping.

---

## Refresh Mode

The mapping exists but something changed: business pivot, new users, new data sources, market shift.

### 1. Load Context

Read CLAUDE.md and `.playbook/report.md` (if they exist). If report.md has context fidelity findings from a previous review, use those as input — the user may not know what drifted, but review does.

### 2. Change Assessment

Show the user the current strategy (key elements: client, value expected, World Model, playbook mapping). If review flagged drift, show it: "Review found these mismatches: [list]. Let's update the mapping." If the user provided context about what changed, use that instead. Skip questions already answered.

### 3. Research

Search the web focused on what changed. Same approach as init step 3: search for what would make the current strategy wrong, not for confirmation.

### 4. Update Mapping

For each node:
- **Still valid?** Keep.
- **Evolution changed?** Something that was genesis might now be commodity (others caught up). Reclassify.
- **New nodes?** New data sources, new inference patterns, new delivery channels.
- **Dead nodes?** Components that no longer serve user value, product learning, or both. Remove.

Check graduation triggers: have any fired? Should any node's approach change?

Check autoresearch results: have optimized nodes converged? Should they graduate to a simpler implementation?

**Check the World Model.** Has what the product accumulates changed? New sensors, scope expanded, or an expected accumulation that never materialized? Update the field to reflect reality.

### 5. Write

Show updated strategic assessment. Highlight what changed. Then show updated CLAUDE.md. Ask for confirmation. Write.

Log the refresh in `.playbook/report.md`.

---

## Rules

- One conversation, then write. Do not iterate endlessly.
- Concrete items: "Gmail inbox" not "email data."
- Uncertain items get a question mark. The user refines later.
- Mark inferences as inferences.
- Research tests the brief, it does not confirm it. Search for what would make the strategy wrong.
- Three outputs: strategic assessment (for people), CLAUDE.md (for agents), regulatory annex (for lawyers, when EU-facing or personal data is processed). All serve the same decomposition through different lenses.
- CLAUDE.md is strategic context (stable). `.playbook/report.md` is operational state (volatile). Don't duplicate between them.
- The user answers questions or confirms inferences. The decomposition, evolution classification, World Model articulation, and challenge — you bring those from research and analysis.
