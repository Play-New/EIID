---
description: Entry point. Takes any input — raw brief, pitch, idea, existing codebase — and produces a playbook decomposition with strategic challenge. The core of the plugin.
allowed-tools: Read, Glob, Grep, Write, Edit, WebSearch, WebFetch
---

# Strategy

Read `reference/concepts.md` for canonical definitions. Read `reference/example.md` to see a complete decomposition.

## Detect Mode

**1. Does a strategy exist?** Check for CLAUDE.md with an playbook mapping table.

**2. Route:**
- **No playbook mapping** -> run **init mode**
- **playbook mapping exists + user provided context about what changed** -> run **refresh mode**
- **playbook mapping exists + no context** -> "Strategy exists. Provide context about what changed to refresh it, or run `/playbook:review` to measure."

---

## Init Mode

### 1. Understand the Input

Scan the current directory for documents: md, txt, csv, json, pdf, images, docx, xlsx. Skip node_modules, .git, dist, build, .next, .vercel. Read every document found.

This is not a fixed questionnaire. Adapt to what exists:
- **Raw brief or pitch deck?** Read it. Extract the value proposition, the client, the market. Note what it claims vs what it assumes.
- **Existing codebase?** Read package.json, scan source files, understand what's built. Map existing code to layers. Note the stack: framework, database, auth, test runner, package manager. Generate technology constraints for detected tools ("Use pnpm, NOT npm/yarn").
- **Just an idea in conversation?** Ask focused questions until you understand the value.
- **A mix?** Combine what you find. Documents fill gaps the code doesn't explain.

### 2. Extract the Value

Two things must be clear before anything else:

1. **Who is the client** — who pays, who uses, their daily context.
2. **What value they expect** — the outcome in one sentence. Not features, not technology. What changes for them when this works.

The folder scan already answered some of these. Ask only what's still missing. Reference what you found: "I see order data in the database and a WhatsApp integration — who is this for and what problem does it solve?"

### 3. Research

Research does not confirm the brief. It tests it. Search for what would make the brief wrong.

**Validate the market.** The brief says the market exists. Search for evidence. If the client claims "PA needs visual communication," search for PA visual communication procurement, budgets, existing solutions in that specific market. Concrete: "pubblica amministrazione comunicazione visiva accessibile" not "visual translation AI tool."

**Find who else is close.** Not direct competitors — adjacent solutions. Who is solving a related problem? What do their users complain about? Where did they stop? Search around the brief, not inside it.

**Check the assumptions.** The brief claims something is unique, scarce, or new. Verify. If "no one has structured creative reasoning data," search for creative reasoning datasets, design decision corpora, tacit knowledge capture tools. Look for evidence the claim is wrong.

**Validate the asset.** If the brief claims a unique dataset, resource, or relationship: how large is it really? How diverse? Is it accessible? What would it take to structure it? Search for the specific asset, not the category.

**What changed in the last 6 months.** What was custom that is now a service? What new tools exist that the brief doesn't account for? This prevents building what's already commodity.

The goal is not 3 generic searches. It is 3-5 targeted searches that could change the decomposition. Every search should be specific enough that the results teach you something the brief didn't say.

### 4. Decompose into Nodes

From the folder scan, user context, and research, identify the components of the product. Work backward from the user need through what's required down to data sources.

For each node, determine five fields (see `reference/concepts.md`):

- **Layer** — which layer it serves (enrichment / inference / interpretation / delivery)
- **Evolution** — genesis, custom, product, or commodity. Use the research: how many providers exist? How standardized is the approach?
- **Metric or signal** — what you measure to know if this node works. Metric for quantifiable things with fast feedback. Signal for things that require human observation.
- **Graduation trigger** — when to change approach AND what to change to. "When accuracy exceeds 95% for 2 weeks, replace with deterministic rules." Both the condition and the direction.
- **Loop** — autoresearch (metric is clean, feedback is fast, automated optimization is possible), manual review (signal requires human judgment), or N/A (commodity node, just monitor).

Every node must trace to the user need. A node that exists because "products like this usually have it" does not belong.

### 5. Challenge

This is the most important step. For each node and for the decomposition as a whole, push back:

- **Genesis treated as obvious.** "This is your riskiest node. How do you validate it before building everything else?"
- **Commodity built custom.** "This exists as a service. Buy it."
- **Missing layer.** "There's no delivery. How does the value reach the user?" or "There's no inference. What patterns are you detecting?"
- **Value node without metric.** "This is your most valuable node and it has no way to know if it's working."
- **Implementation confused with strategy.** "RAG is how. What is the what?" or "You described a dashboard. What insight does it deliver that a notification couldn't?"
- **Enrichment/Inference node without autoresearch.** "This node has a clean metric. Why not optimize it automatically?"
- **No genesis nodes.** "Everything here is commodity or product. Where are you creating new value? Without genesis, there's no product — just integration."
- **Brief that's really a feature list.** "These are outputs. What is the input? Where does the data come from? What patterns do you detect? Start from enrichment."
- **Unvalidated market.** "The brief lists 7 markets. Which one has the most urgent need AND where your asset gives the strongest signal? Pick one."
- **Asset that doesn't exist yet.** "The brief says the corpus is unique. But it isn't structured. The moat is the structured knowledge, not the raw material."

The challenge is not hostile. It sharpens the strategy. Acknowledge what's strong, then point to what's missing or misplaced.

### 6. Write

Strategy produces two outputs: one for the people deciding, one for the agents building.

**For the people: Strategic Assessment.** Present to the user before writing any file:

1. **What this product is** — one paragraph that restates the value in clearer terms than the brief.
2. **Where the value is** — which node is genesis, why it matters, what makes it defensible.
3. **Where the risk is** — which node is the weakest, what breaks if it fails.
4. **What to do first** — the first concrete milestone, not the full roadmap. What validates the riskiest assumption with the least investment.
5. **What not to do** — what the brief proposes that should be delayed, cut, or bought instead.
6. **Open questions** — what the research couldn't answer, what needs human judgment.

This is the challenge translated into action. The user reads this and knows what to do next.

**For the agents: CLAUDE.md.** Use `reference/claude-md-template.md` for structure. Before showing the user, verify: if an AI agent reads this CLAUDE.md tomorrow with zero context, does it know where the value is (which nodes are genesis), what to build first, what to measure (every node has a metric or signal), when to change approach (graduation triggers), and which nodes can be optimized automatically (loop field)? If any of these are unclear, rewrite until they are. Then show the user. Ask for confirmation. Only write after approval.

If there are non-obvious choices worth logging, append them to `.playbook/report.md` under a Decisions section with date, reasoning, and which node they affect.

### 7. What's Next

Tell the user: run `/playbook:build` to start constructing from the strategy, or `/playbook:review` to measure an existing product against the mapping.

---

## Refresh Mode

The mapping exists but something changed: business pivot, new users, new data sources, market shift.

### 1. Load Context

Read CLAUDE.md and `.playbook/report.md` (if they exist). If report.md has context fidelity findings from a previous review, use those as input — the user may not know what drifted, but review does.

### 2. Change Assessment

Show the user the current strategy (key elements: client, value expected, playbook mapping). If review flagged drift, show it: "Review found these mismatches: [list]. Let's update the mapping." If the user provided context about what changed, use that instead. Skip questions already answered.

### 3. Research

Search the web focused on what changed. Same approach as init step 3: search for what would make the current strategy wrong, not for confirmation.

### 4. Update Mapping

For each node:
- **Still valid?** Keep.
- **Evolution changed?** Something that was genesis might now be commodity (others caught up). Reclassify.
- **New nodes?** New data sources, new inference patterns, new delivery channels.
- **Dead nodes?** Components that no longer serve the user need. Remove.

Check graduation triggers: have any fired? Should any node's approach change?

Check autoresearch results: have optimized nodes converged? Should they graduate to a simpler implementation?

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
- Two outputs: strategic assessment (for people) and CLAUDE.md (for agents). Both serve the same decomposition, different audiences.
- CLAUDE.md is strategic context (stable). `.playbook/report.md` is operational state (volatile). Don't duplicate between them.
- The user answers questions or confirms inferences. The decomposition, evolution classification, and challenge — you bring those from research and analysis.
