---
description: Entry point. Takes any input — raw brief, pitch, idea, existing codebase — and produces an EIID decomposition with strategic challenge. The core of the plugin.
allowed-tools: Read, Glob, Grep, Write, Edit, WebSearch, WebFetch
---

# Strategy

Read `reference/concepts.md` for canonical definitions. Read `reference/example.md` to see a complete decomposition.

## Detect Mode

**1. Does a strategy exist?** Check for CLAUDE.md with an EIID mapping table.

**2. Route:**
- **No EIID mapping** -> run **init mode**
- **EIID mapping exists + user provided context about what changed** -> run **refresh mode**
- **EIID mapping exists + no context** -> "Strategy exists. Provide context about what changed to refresh it, or run `/eiid:review` to measure."

---

## Init Mode

### 1. Understand the Input

Scan the current directory for documents: md, txt, csv, json, pdf, images, docx, xlsx. Skip node_modules, .git, dist, build, .next, .vercel. Read every document found.

This is not a fixed questionnaire. Adapt to what exists:
- **Raw brief or pitch deck?** Read it. Extract the value proposition, the client, the market. Note what it claims vs what it assumes.
- **Existing codebase?** Read package.json, scan source files, understand what's built. Map existing code to EIID layers. Note the stack: framework, database, auth, test runner, package manager. Generate technology constraints for detected tools ("Use pnpm, NOT npm/yarn").
- **Just an idea in conversation?** Ask focused questions until you understand the value.
- **A mix?** Combine what you find. Documents fill gaps the code doesn't explain.

### 2. Extract the Value

Two things must be clear before anything else:

1. **Who is the client** — who pays, who uses, their daily context.
2. **What value they expect** — the outcome in one sentence. Not features, not technology. What changes for them when this works.

The folder scan already answered some of these. Ask only what's still missing. Reference what you found: "I see order data in the database and a WhatsApp integration — who is this for and what problem does it solve?"

### 3. Research

Research depth adapts to the input. A raw idea needs broad exploration. A detailed pitch needs targeted validation. An existing codebase needs market positioning.

At minimum, three angles:

**How this problem gets solved today.** What products, workflows, and solutions exist? What's good, what's broken?

**Who does it well.** The 2-3 best existing solutions. Their approach, pricing, limitations, user complaints. Where do they fall short?

**What changed recently.** What was custom six months ago that's now a service? What services shut down? This prevents building what's already commodity.

Go deeper when the input demands it. A brief that mentions specific data sources: research those sources, their APIs, their pricing. A pitch that claims a unique dataset: verify the claim, search for competitors with similar data. A codebase with integrations: check if those integrations are still the best option.

Use the research to classify each node's evolution in step 4.

### 4. Decompose into Nodes

From the folder scan, user context, and research, identify the components of the product. Work backward from the user need through what's required down to data sources.

For each node, determine five fields (see `reference/concepts.md`):

- **Layer** — which EIID layer it serves (enrichment / inference / interpretation / delivery)
- **Evolution** — genesis, custom, product, or commodity. Use the research: how many providers exist? How standardized is the approach?
- **Metric or signal** — what you measure to know if this node works. Metric for quantifiable things with fast feedback. Signal for things that require human observation.
- **Graduation trigger** — when to change approach AND what to change to. "When accuracy exceeds 95% for 2 weeks, replace with deterministic rules." Both the condition and the direction.
- **Loop** — autoresearch (metric is clean, feedback is fast, automated optimization is possible), manual review (signal requires human judgment), or N/A (commodity node, just monitor).

Every node must trace to the user need. A node that exists because "products like this usually have it" does not belong.

### 5. Challenge

This is the most important step. For each node and for the decomposition as a whole, push back:

- **Genesis treated as obvious.** "This is your riskiest node. How do you validate it before building everything else?"
- **Commodity built custom.** "This exists as a service. Buy it."
- **Missing EIID layer.** "There's no delivery. How does the value reach the user?" or "There's no inference. What patterns are you detecting?"
- **Value node without metric.** "This is your most valuable node and it has no way to know if it's working."
- **Implementation confused with strategy.** "RAG is how. What is the what?" or "You described a dashboard. What insight does it deliver that a notification couldn't?"
- **Enrichment/Inference node without autoresearch.** "This node has a clean metric. Why not optimize it automatically?"
- **No genesis nodes.** "Everything here is commodity or product. Where are you creating new value? Without genesis, there's no product — just integration."
- **Brief that's really a feature list.** "These are outputs. What is the input? Where does the data come from? What patterns do you detect? Start from enrichment."

The challenge is not hostile. It sharpens the strategy. Acknowledge what's strong, then point to what's missing or misplaced.

### 6. Context Engineering Check

Before writing, verify: if an AI agent reads this CLAUDE.md tomorrow with zero context, does it know:
- Where the value is (which nodes are genesis, which are commodity)?
- What to build first (the nodes with clearest value and highest risk)?
- What to measure (every node has a metric or signal)?
- When to change approach (graduation triggers)?
- Which nodes can be optimized automatically (loop field)?

If any of these are unclear, the context is not ready. Rewrite until it is.

### 7. Write

**Show the user the full CLAUDE.md before writing.** Use `reference/claude-md-template.md` for structure. Ask for confirmation. Incorporate feedback. Only write after approval.

Create CLAUDE.md. If there are non-obvious choices worth logging, append them to `.eiid/report.md` under a Decisions section with date, reasoning, and which node they affect.

### 8. What's Next

Tell the user: run `/eiid:build` to start constructing from the strategy, or `/eiid:review` to measure an existing product against the mapping.

---

## Refresh Mode

The mapping exists but something changed: business pivot, new users, new data sources, market shift.

### 1. Load Context

Read CLAUDE.md and `.eiid/report.md` (if they exist). If report.md has context fidelity findings from a previous review, use those as input — the user may not know what drifted, but review does.

### 2. Change Assessment

Show the user the current strategy (key elements: client, value expected, EIID mapping). If review flagged drift, show it: "Review found these mismatches: [list]. Let's update the mapping." If the user provided context about what changed, use that instead. Skip questions already answered.

### 3. Research

Search the web focused on what changed. Same approach as init step 3, scoped to the delta.

### 4. Update Mapping

For each node:
- **Still valid?** Keep.
- **Evolution changed?** Something that was genesis might now be commodity (others caught up). Reclassify.
- **New nodes?** New data sources, new inference patterns, new delivery channels.
- **Dead nodes?** Components that no longer serve the user need. Remove.

Check graduation triggers: have any fired? Should any node's approach change?

Check autoresearch results: have optimized nodes converged? Should they graduate to a simpler implementation?

### 5. Write

Show updated CLAUDE.md. Highlight what changed. Ask for confirmation. Write.

Log the refresh in `.eiid/report.md`.

---

## Rules

- One conversation, then write. Do not iterate endlessly.
- Concrete items: "Gmail inbox" not "email data."
- Uncertain items get a question mark. The user refines later.
- Mark inferences as inferences.
- CLAUDE.md is strategic context (stable). `.eiid/report.md` is operational state (volatile). Don't duplicate between them.
- The user answers questions or confirms inferences. The decomposition, evolution classification, and challenge — you bring those from research and analysis.
