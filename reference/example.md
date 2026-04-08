# Example: PriceScope

A complete EIID decomposition showing the model in action.

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

### Product matcher — Enrichment

Matches competitor products to your SKUs. Handles variants, bundles, different naming.

| Field | Value |
|-------|-------|
| Layer | Enrichment |
| Evolution | custom — matching logic is specific to your catalog |
| Metric | accuracy (% correct matches on test set) |
| Graduation | when accuracy stable above 95% for 2 weeks on mature categories, replace with deterministic rules for those categories |
| Loop | autoresearch — change prompt/embedding approach, measure accuracy, keep or discard. 12 experiments/hour. |

### Anomaly detector — Inference

Detects unusual price changes: a competitor dropping 40%, an upward trend across a category, a new player entering below market.

| Field | Value |
|-------|-------|
| Layer | Inference |
| Evolution | custom — which anomalies matter depends on your market |
| Metric | precision (% flagged anomalies that are real), recall (% real anomalies caught) |
| Graduation | when volume exceeds 10K monitored SKUs, move recurring patterns to rules and keep the model for novel cases only |
| Loop | autoresearch — change detection logic, measure against labeled anomaly dataset. Fast feedback. |

### Price recommendation — Interpretation

Transforms "competitor X dropped 15%" into "lower to 24.90, maintain ranking, margin impact: -2%, estimated recovery in 3 days from additional volume."

| Field | Value |
|-------|-------|
| Layer | Interpretation |
| Evolution | genesis — this is the product's brain, nobody does it this way |
| Signal | recommendation acceptance rate, revenue delta at 7 days post-adoption |
| Graduation | when recommendations for a category follow the same pattern consistently, convert to automatic rules for that category |
| Loop | manual review — optimize prompt for clarity (measurable), but revenue impact requires human judgment (monthly) |

### Alert dispatcher — Delivery

Sends the right insight through the right channel at the right time. Competitor crash: immediate push. Weekly trend: Monday email digest. Monthly report: dashboard.

| Field | Value |
|-------|-------|
| Layer | Delivery |
| Evolution | product — notification infrastructure is well understood, value is in the routing rules |
| Signal | time from alert to first user action, % alerts ignored (fatigue) |
| Graduation | when a channel exceeds 40% fatigue rate, revisit frequency and thresholds for that channel |
| Loop | manual review — observe fatigue and response signals, adjust routing rules |

### Dashboard — Delivery

Overview of the price landscape, active recommendations, history, past decision performance.

| Field | Value |
|-------|-------|
| Layer | Delivery |
| Evolution | product |
| Signal | usage frequency, average time to find the information sought |
| Graduation | if 80% of users use only 2 views, the others are not earning their place |
| Loop | N/A |

---

## Where the automated loop runs

**Product matcher** and **anomaly detector** have clean metrics, test sets, and 5-minute experiments. Autoresearch applies directly. Change the approach, measure, keep or discard.

**Price recommendation** has a signal (acceptance rate) but slow feedback (days) and multiple dimensions. You can optimize the prompt for clarity, but actual revenue impact is judged manually every month.

**Alert dispatcher** and **dashboard** are measured with behavioral signals. No automated loop: observe, decide, adjust.

---

## Context engineering check

If an AI agent reads the CLAUDE.md generated from this decomposition tomorrow with no other context, it knows:
- The product has 6 nodes across all 4 EIID layers
- The genesis node (price recommendation) is where the real value is — invest here
- Two nodes (product matcher, anomaly detector) can be optimized with autoresearch loops
- One node (price scraper) is commodity — buy, don't build
- Each node has a metric or signal with a target
- Each node has a graduation trigger that says when to change approach
