# Examples

Three decompositions across different domains. Each shows the model applied to a real product category, with different patterns of where value sits, where autoresearch applies, and where it doesn't.

---

# Example 1: PriceScope

A pricing intelligence tool for e-commerce.

---

## Client

E-commerce sellers managing products across multiple marketplaces.

## Value Expected

Always have the right price without spending hours checking competitors.

---

## Nodes

### Price scraper — Enrichment

Collects competitor prices from marketplaces and websites. Normalizes formats, currencies, variants.

| Field | Value |
|-------|-------|
| Layer | Enrichment |
| Evolution | commodity — dozens of scraping services exist |
| Metric | coverage (% competitors tracked), freshness (age of latest price in minutes) |
| Graduation | if coverage drops below 80% on a marketplace, build a custom scraper for it |
| Loop | N/A — buy the service, monitor the metric |
| Feeds | — |

### Product matcher — Enrichment

Matches competitor products to your SKUs. Handles variants, bundles, different naming.

| Field | Value |
|-------|-------|
| Layer | Enrichment |
| Evolution | custom — matching logic is specific to your catalog |
| Metric | accuracy (% correct matches on test set) |
| Graduation | when accuracy stable above 95% for 2 weeks on mature categories, replace with deterministic rules for those categories |
| Loop | autoresearch — change prompt/embedding approach, measure accuracy, keep or discard. 12 experiments/hour. |
| Feeds | — |

### Anomaly detector — Inference

Detects unusual price changes: a competitor dropping 40%, an upward trend across a category, a new player entering below market.

| Field | Value |
|-------|-------|
| Layer | Inference |
| Evolution | custom — which anomalies matter depends on your market |
| Metric | precision (% flagged anomalies that are real), recall (% real anomalies caught) |
| Graduation | when volume exceeds 10K monitored SKUs, move recurring patterns to rules and keep the model for novel cases only |
| Loop | autoresearch — change detection logic, measure against labeled anomaly dataset. Fast feedback. |
| Feeds | — |

### Price recommendation — Interpretation

Transforms "competitor X dropped 15%" into "lower to 24.90, maintain ranking, margin impact: -2%, estimated recovery in 3 days from additional volume."

| Field | Value |
|-------|-------|
| Layer | Interpretation |
| Evolution | genesis — this is the product's brain, nobody does it this way |
| Signal | recommendation acceptance rate, revenue delta at 7 days post-adoption |
| Graduation | when recommendations for a category follow the same pattern consistently, convert to automatic rules for that category |
| Loop | manual review — optimize prompt for clarity (measurable), but revenue impact requires human judgment (monthly) |
| Feeds | user modifies recommendation before acting → recommendation quality (the modification shows what was wrong or missing) |

### Alert dispatcher — Delivery

Sends the right insight through the right channel at the right time. Competitor crash: immediate push. Weekly trend: Monday email digest. Monthly report: dashboard.

| Field | Value |
|-------|-------|
| Layer | Delivery |
| Evolution | product — notification infrastructure is well understood, value is in the routing rules |
| Signal | time from alert to first user action, % alerts ignored (fatigue) |
| Graduation | when a channel exceeds 40% fatigue rate, revisit frequency and thresholds for that channel |
| Loop | manual review — observe fatigue and response signals, adjust routing rules |
| Feeds | accepted/ignored alerts → anomaly detector (precision tuning), action timing → alert dispatcher (routing rules) |

### Dashboard — Delivery

Overview of the price landscape, active recommendations, history, past decision performance.

| Field | Value |
|-------|-------|
| Layer | Delivery |
| Evolution | product |
| Signal | usage frequency, average time to find the information sought |
| Graduation | if 80% of users use only 2 views, the others are not earning their place |
| Loop | N/A |
| Feeds | searches without results → price scraper (coverage gaps), recommendation outcomes viewed → price recommendation (quality signal) |

---

## Where the automated loop runs

**Product matcher** and **anomaly detector** have clean metrics, test sets, and 5-minute experiments. Autoresearch applies directly. Change the approach, measure, keep or discard.

**Price recommendation** has a signal (acceptance rate) but slow feedback (days) and multiple dimensions. You can optimize the prompt for clarity, but actual revenue impact is judged manually every month.

**Alert dispatcher** and **dashboard** are measured with behavioral signals. No automated loop: observe, decide, adjust.

---

## Context engineering check

If an AI agent reads the CLAUDE.md generated from this decomposition tomorrow with no other context, it knows:
- The product has 6 nodes across all 4 layers
- The genesis node (price recommendation) is where the real value is — invest here
- Two nodes (product matcher, anomaly detector) can be optimized with autoresearch loops
- One node (price scraper) is commodity — buy, don't build
- Each node has a metric or signal with a target
- Each node has a graduation trigger that says when to change approach
- The Delivery layer feeds signal back: ignored alerts tune Inference, missing searches reveal Enrichment gaps

---

# Example 2: TalentVoice

AI-augmented recruiting language. Based on the Textio category (1B+ HR documents, 30+ specialized models, used by 25%+ of Fortune 500).

---

## Client

Enterprise HR teams managing 500+ job postings per quarter.

## Value Expected

Every job posting attracts the widest qualified talent pool without manual bias review.

---

## Nodes

### Document ingester — Enrichment

Ingests job descriptions, sourcing emails, employer brand copy from ATS and authoring tools. Normalizes formatting, extracts sections (requirements, benefits, company description).

| Field | Value |
|-------|-------|
| Layer | Enrichment |
| Evolution | commodity — document parsing and ATS integrations are solved |
| Metric | ingestion success rate (% docs parsed without manual intervention) |
| Graduation | if a new ATS format breaks extraction below 90%, build a custom parser for it |
| Loop | N/A — buy/integrate |
| Feeds | — |

### Outcome linker — Enrichment

Joins each job posting to its hiring outcome: application volume, demographic diversity of applicant pool, time-to-fill, offer acceptance rate. This is the feedback signal that makes the entire system learn.

| Field | Value |
|-------|-------|
| Layer | Enrichment |
| Evolution | custom — linking outcomes to specific language choices across ATS/HRIS boundaries is non-trivial |
| Metric | linkage rate (% postings matched to outcomes), outcome latency (days from posting to outcome data) |
| Graduation | when linkage rate exceeds 95% for a given ATS integration, freeze that connector |
| Loop | autoresearch — change matching heuristics, measure linkage rate against labeled set |
| Feeds | — |

### Bias pattern detector — Inference

Identifies language patterns correlated with exclusionary outcomes: gendered phrases, age-coded language, jargon density, requirement inflation ("10 years experience" for a junior role).

| Field | Value |
|-------|-------|
| Layer | Inference |
| Evolution | custom — which patterns matter depends on the organization's goals and role type |
| Metric | detection precision (% flagged patterns that correlate with measurable outcome difference), recall (% of outcome-affecting patterns caught) |
| Graduation | when a pattern becomes universally recognized (e.g., "rockstar" as gendered), move from model detection to a deterministic blocklist |
| Loop | autoresearch — change detection thresholds, measure against labeled outcome dataset |
| Feeds | — |

### Rewrite recommendation — Interpretation

Turns "this phrase correlates with 23% fewer women applicants" into a specific alternative: "Replace 'competitive environment' with 'collaborative team that delivers results' — expected impact: +15% women applicants based on 12K similar postings."

| Field | Value |
|-------|-------|
| Layer | Interpretation |
| Evolution | genesis — calibrated, context-specific rewrites with predicted outcome impact is the core IP |
| Signal | rewrite acceptance rate, actual outcome delta (diversity change) at 30/60/90 days |
| Graduation | when rewrites for a pattern category have >90% acceptance and stable outcome improvement, auto-apply as defaults |
| Loop | manual review — acceptance rate is fast, but actual outcome impact takes months |
| Feeds | user edits rewrite before accepting → rewrite quality (the edit shows what was wrong), user rejects rewrite entirely → rewrite was off-target for this context |

### Editor overlay — Delivery

Real-time sidebar in the authoring tool. Shows a score, highlights flagged phrases, offers rewrites inline as the recruiter types.

| Field | Value |
|-------|-------|
| Layer | Delivery |
| Evolution | product — real-time editor overlays are well-understood |
| Signal | time from flag to action, % suggestions dismissed without reading |
| Graduation | if >50% of suggestions in a category are auto-accepted without reading, that category can move to auto-apply |
| Loop | manual review — observe interaction patterns, adjust suggestion priority |
| Feeds | accepted rewrites with edits → rewrite recommendation (the edit IS the training signal — what the recruiter changed reveals what the system got wrong), dismissed suggestions → bias pattern detector (false positive signal) |

---

## What makes this different from PriceScope

**The feedback loop is structurally slow.** PriceScope's inference nodes get feedback in minutes. TalentVoice's core signal — did the rewrite actually change hiring outcomes? — takes 30-90 days. The genesis node cannot use autoresearch for its most important metric. The system must split: optimize prompt clarity fast (autoresearch-eligible), validate outcome calibration slow (quarterly manual).

**Most value is in Enrichment, not Interpretation.** The outcome linker is the hidden strategic node. Without reliable linkage between language and outcomes, the entire system is guessing. The real moat is linked outcome data — an Enrichment asset, not an Inference asset. PriceScope's Enrichment is commodity; TalentVoice's is where the data advantage lives.

**The editor overlay is the hidden training loop.** When a recruiter accepts a rewrite but edits it first, the edit is the richest signal in the system — it shows exactly what the recommendation got wrong. Dismissed suggestions feed back to the bias pattern detector as false positive signal. The Delivery node is product-stage infrastructure, but the signal it captures is what makes the genesis node (rewrite recommendation) improvable.

---

## Context engineering check

If an AI agent reads the CLAUDE.md generated from this decomposition:
- The genesis node (rewrite recommendation) has slow feedback — don't expect fast iteration
- The real moat is the outcome linker in Enrichment — protect this data asset
- Two autoresearch-eligible nodes, but the one that matters most (rewrite recommendation) is not one of them
- Acceptance rate alone is an insufficient metric for the genesis node — it tells you if recruiters liked the suggestion, not if it worked

---

# Example 3: BrandLens

AI content governance and brand voice compliance. Based on the Acrolinx category (linguistic analytics across 6 languages, used by Microsoft, Adobe, Siemens).

---

## Client

Global enterprise marketing teams producing 1000+ content pieces/month across 10+ channels and multiple languages.

## Value Expected

Every published piece sounds like the brand, without a human reviewer reading every word.

---

## Nodes

### Content collector — Enrichment

Ingests published content from all channels: website CMS, email platform, social media, product docs, support knowledge base. Normalizes format, extracts text, tags with channel/author/date.

| Field | Value |
|-------|-------|
| Layer | Enrichment |
| Evolution | commodity — CMS connectors and API integrations are solved |
| Metric | coverage (% channels connected), freshness (hours since last sync) |
| Graduation | if a new channel has no API, build a custom scraper; revisit when an official connector appears |
| Loop | N/A — buy/integrate |
| Feeds | — |

### Style guide encoder — Enrichment

Digitizes the brand's style guide, terminology, tone rules, and compliance requirements into a machine-readable ruleset. Brand lexicon, tone parameters, regulatory constraints.

| Field | Value |
|-------|-------|
| Layer | Enrichment |
| Evolution | custom — every brand's rules are different, encoding them requires human-AI collaboration |
| Metric | rule coverage (% of style guide sections encoded), rule conflict rate (% rules that contradict each other) |
| Graduation | when conflicts drop to zero and new rules are added less than once per quarter, the encoding is stable |
| Loop | manual review — encoding requires brand team validation |
| Feeds | — |

### Compliance scorer — Inference

Analyzes each content piece against the encoded ruleset. Checks terminology, tone, reading level, inclusivity. Produces a per-piece score and per-dimension breakdown.

| Field | Value |
|-------|-------|
| Layer | Inference |
| Evolution | product — Acrolinx, Grammarly Business, Writer all offer scoring engines |
| Metric | scoring accuracy (agreement with expert human reviewers), false positive rate (% flags that experts dismiss) |
| Graduation | when false positive rate exceeds 15%, simplify the ruleset. When accuracy exceeds 95%, reduce review sample frequency |
| Loop | autoresearch — change scoring weights, measure against expert-labeled test set |
| Feeds | — |

### Cross-channel consistency analyzer — Inference

Measures whether the brand sounds the same across channels. Detects drift: social media team uses casual tone while product docs are formal; German site uses terms the English style guide bans.

| Field | Value |
|-------|-------|
| Layer | Inference |
| Evolution | genesis — per-piece scoring is product-stage; cross-channel consistency measurement with multi-language tone equivalence is unsolved |
| Metric | consistency score (variance of tone/terminology across channels), drift detection latency (days to flag a diverging channel) |
| Graduation | when a channel pair's consistency is stable above target for 6 months, reduce monitoring frequency for that pair |
| Loop | autoresearch — change consistency measurement approach, measure against expert-labeled channel pairs. Medium feedback speed (weekly) |
| Feeds | — |

### Writer guidance — Delivery

Real-time sidebar in the authoring tool. Highlights non-compliant phrases, suggests alternatives, shows score updating live. Pre-publication quality gate: content below threshold cannot be published.

| Field | Value |
|-------|-------|
| Layer | Delivery |
| Evolution | product — real-time editor overlays are well-understood |
| Signal | time from flag to correction, % suggestions accepted, gate pass rate |
| Graduation | if pass rate exceeds 95%, writers have internalized the rules — relax the gate to advisory mode |
| Loop | manual review — observe writer behavior, adjust suggestion priority |
| Feeds | corrections before system flags → compliance scorer (system is late, thresholds too lax), rejected suggestions → style guide encoder (rule may be wrong or context-dependent), writer rewrites that avoid flagged patterns → consistency analyzer (new compliant patterns to learn) |

### Governance dashboard — Delivery

Executive view: content quality trends across channels, compliance rates by team/region/language, drift alerts.

| Field | Value |
|-------|-------|
| Layer | Delivery |
| Evolution | product |
| Signal | usage frequency, time from drift alert to corrective action |
| Graduation | if 80% of users check only 2 views, the others are noise — remove them |
| Loop | N/A |
| Feeds | drift alerts without corrective action → consistency analyzer (alert fatigue or false alarm), filter patterns → content collector (which channels executives actually care about) |

---

## What makes this different from PriceScope and TalentVoice

**The genesis node is in Inference, not Interpretation.** PriceScope and TalentVoice both have genesis in Interpretation. BrandLens's genesis is the cross-channel consistency analyzer — an Inference node. The unique value is not in what it recommends but in what it detects: brand drift across channels and languages that no human reviewer could catch at scale. The detection itself is the insight.

**Enrichment requires permanent human judgment.** PriceScope's Enrichment is commodity. TalentVoice's has one automatable Enrichment node. BrandLens's style guide encoder is custom and permanently requires human collaboration — you cannot auto-encode a brand's voice. This makes one Enrichment node permanently manual-review.

**Two-speed autoresearch.** Both Inference nodes are autoresearch-eligible, but at different speeds. The compliance scorer runs experiments in minutes (change weights, score test set). The consistency analyzer runs experiments weekly (need enough content across channels to measure drift). PriceScope's two autoresearch nodes both run at similar speeds.

**No genesis in Interpretation or Delivery.** The entire Delivery layer is product-stage. Differentiation is purely in detection quality. A competitor could replicate the delivery layer trivially; the moat is in Enrichment (encoded brand rules) and Inference (cross-channel detection).

**The Delivery layer is the densest sensor.** Writer guidance feeds three nodes: compliance scorer (corrections before flags mean the system is late), style guide encoder (rejected suggestions mean the rule is wrong), consistency analyzer (new compliant patterns to learn). The governance dashboard feeds two more. Despite being product-stage, Delivery is where the system learns fastest — it runs production autoresearch at the speed of every writer's keystroke.

---

## Context engineering check

If an AI agent reads the CLAUDE.md generated from this decomposition:
- The genesis node is in Inference (cross-channel consistency), not Interpretation — invest detection quality, not recommendation quality
- One Enrichment node (style guide encoder) will always need human input — budget for it
- Two autoresearch loops at different speeds: compliance scorer (minutes), consistency analyzer (weekly)
- No genesis in Delivery — the presentation layer is replaceable, but it is the densest sensor (writer guidance feeds 3 nodes)
