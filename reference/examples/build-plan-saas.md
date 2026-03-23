# FleetPulse — Build Plan

Visual-heavy SaaS. All code/buy. Dense operational product.

## What This Product Needs (derived from strategy)

- **Auth:** yes — fleet managers log in, drivers contribute via WhatsApp (no login)
- **Schema:** yes — vehicles, alerts, maintenance records. Four core tables matching the IA.
- **Layout shell:** yes — sidebar with 5 nav items. Dense, operational feel from line one.
- **Settings:** yes — polling frequency, alert thresholds, notification channels. Compact, deep.
- **Visual surfaces:** yes — the web interface is where fleet managers see what WhatsApp can't show: maps, charts, trends.
- **Prompt management:** no — no LLM calls in this product.

## What This Product Does NOT Need

- User onboarding wizard. Fleet managers are set up by admin. One config, done.
- Dashboard builder / customization. The attention count and fleet map are fixed. They work because the design chose them, not because the user arranges widgets.
- Export as a feature. It's a button on Reports, not a screen.
- Notification preferences page. Thresholds and channels are in Settings. One place.

## Build Order

1. **Scaffold + schema** — 4 tables: vehicles, alerts, maintenance_records, routes. RLS per fleet. Types generated.
2. **Auth + layout** — Supabase Auth, middleware, 240px sidebar. The attention count (signature) is in the header from day one.
3. **Enrichment** — telematics polling (Inngest cron), email receipt parsing, WhatsApp media intake. Three connectors, each independent.
4. **Inference** — fuel baseline calculation, maintenance prediction, idle detection. Pure code, no agents.
5. **Interpretation** — insight formatting: comparison to fleet average, 4-week trend, recommended action. Output is structured data, not natural language.
6. **Delivery** — WhatsApp alerts (business hours), email daily summary. Both follow conversational patterns from design system.
7. **Visual surfaces** — Fleet Overview (attention count, map, vehicle list), Vehicle Detail, Alerts, Maintenance, Reports. Each screen has one focal point. Dense tables, amber sparks, the control room feel.
8. **Settings** — polling config, alert thresholds, user roles. Constrained form, deep nav.

## Key Design Decisions in Build

- The attention count appears before any other screen is built. It's the signature — present from the first commit.
- Table rows are 36px, not 48px. This is a dense product. The design system says so.
- No card-heavy dashboard. The IA says Fleet Overview's focal point is the attention count + map. Not 6 equal cards.
- Amber for "needs attention", not red. Red is reserved for emergencies. This distinction is baked into every component.
