# Regulatory Annex Template

Strategy generates this file alongside the Strategic Assessment and CLAUDE.md when the product is EU-facing or the user requests regulatory analysis. It is the lawyer-readable regulatory posture of the product: cited, reasoned, flagged where uncertain, written to support legal review — not to replace it.

Scope: GDPR (Regulation (EU) 2016/679) and the AI Act (Regulation (EU) 2024/1689). National transpositions and sector rules (e.g., DSA, DMA, NIS2, ePrivacy, national DPA guidance) are flagged as out-of-scope items for legal counsel.

**AI Act phased application** (Art 113):
- **2 February 2025** — Chapter I (general provisions) and Chapter II (prohibited AI practices under Art 5) apply.
- **2 August 2025** — Chapter V (GPAI models, Art 51-56), Chapter III Section 4 (notified bodies), Chapter VII (governance), Chapter XII (penalties) apply; Commission develops codes of practice.
- **2 August 2026** — General application date. Most high-risk obligations (Chapter III Section 2), transparency obligations (Art 50), post-market monitoring apply.
- **2 August 2027** — High-risk systems that are safety components of products covered by Annex I sectoral legislation (e.g., medical devices, machinery) must comply.

Products being designed today must be compliance-ready for the tier that applies at their launch date. When in doubt, design for the strictest tier plausibly reachable.

Written to `.playbook/regulatory-annex.md`.

---

```markdown
# Regulatory Annex — [Product Name]

**Date:** [YYYY-MM-DD]
**Prepared by:** /playbook:strategy (Playbook plugin, Claude Code)
**Status:** First-pass analysis for legal review.

> **Disclaimer.** This annex is a structured first-pass regulatory analysis produced by an AI-assisted strategy tool to support legal review. It is not legal advice and does not constitute a Data Protection Impact Assessment. A qualified DPO or legal counsel must review, complete, and sign off before implementation. Findings flagged "confidence: low" or listed in §9 require definitive legal determination.

## 1. Product description (regulatory frame)

[One paragraph written from a processing/decision-making lens, not a feature lens. Must answer: what the product does, who the users are, what personal data flows through it, what automated decisions it makes, where data is stored/processed, which countries/users are in scope.]

## 2. AI Act classification (Regulation (EU) 2024/1689)

### 2.1 In scope

Is this an "AI system" under AI Act Art 3(1) — a machine-based system with autonomy, adaptability, and the ability to infer from inputs how to generate outputs such as predictions, recommendations, or decisions?

**Determination:** [yes / no]. **Reasoning:** [which nodes satisfy the definition; if no, why not].

### 2.2 Role (provider / deployer / both)

Obligations cascade from role. Determine before tier.

- **Provider** (Art 3(3)): develops an AI system (or has it developed) and places it on the market or puts it into service under its own name or trademark, for payment or free of charge.
- **Deployer** (Art 3(4)): uses an AI system under its authority, except in a personal non-professional activity.
- **Both:** the team builds an AI system and also uses it internally under its authority — carries both sets of obligations.
- **Downstream provider of GPAI-integrated system** (Art 25, Art 53(1)(b)): builds an AI system on top of a general-purpose AI model (e.g., Claude, GPT, Gemini) — is the provider of the resulting AI system; must obtain and retain the GPAI upstream provider's information; the GPAI provider carries Art 53+ obligations separately.
- **Substantial modification** (Art 25): a deployer that modifies an AI system substantially, applies its own trademark, or changes the intended purpose becomes a provider for the modified system.

**Determination:** [provider / deployer / both / downstream provider of GPAI]. **Reasoning:** [who develops, who markets under what name, who uses, which GPAI if any, any Art 25 trigger].

**Implication:** if provider (or both), the provider obligations listed in §2.6 apply; if deployer only, the lighter Art 26 + FRIA Art 27 obligations apply — §2.6 should reflect the applicable set.

### 2.3 Prohibited practices (Art 5)

Per node, verify none of the following apply:
- Subliminal / manipulative / deceptive techniques materially distorting behaviour (Art 5(1)(a))
- Exploitation of vulnerabilities due to age, disability, socio-economic situation (Art 5(1)(b))
- Social scoring by public/private actors (Art 5(1)(c))
- Risk assessment of criminality based solely on profiling (Art 5(1)(d))
- Untargeted scraping of facial images to build databases (Art 5(1)(e))
- Emotion inference in workplace/education (Art 5(1)(f))
- Biometric categorisation inferring sensitive attributes (Art 5(1)(g))
- Real-time remote biometric identification in public spaces for law enforcement (Art 5(1)(h))

**Determination:** [none / flagged — cite node + article].

> **HARD STOP — if any point above is triggered:** a prohibited practice is not a tier upgrade with more obligations. The product cannot be placed on the EU market or put into service under this design. Two paths forward: (i) **redesign** the affected node so the prohibition no longer applies (e.g., bound video analysis to visible job-relevant cues without emotional or affective inference), documenting the boundary explicitly in §2.3 and in the technical documentation (Art 11); or (ii) **drop** the feature. Do not proceed with compliance architecture for other sections until the prohibited-practice determination is "none". Legal counsel sign-off on the boundary is required before the determination flips from "flagged" to "none".

### 2.4 High-risk (Annex III)

Does the product (or a node) fall in Annex III categories?
- Biometrics and biometric-based categorisation (point 1)
- Critical infrastructure (point 2)
- Education and vocational training (point 3)
- Employment, workers management, access to self-employment — incl. recruitment, CV-screening, promotion/termination, task allocation, performance monitoring (point 4)
- Access to essential private and public services (credit scoring, public benefits eligibility, emergency response, life/health insurance pricing) (point 5)
- Law enforcement (point 6)
- Migration, asylum, border control (point 7)
- Administration of justice and democratic processes (point 8)

**Determination:** [not high-risk / high-risk under Annex III point N]. **Reasoning:** [map the product's primary decisions to the Annex category].

### 2.5 Limited-risk (Art 50 transparency obligations)

Does the product:
- Interact directly with natural persons as a chatbot/conversational AI? → inform the user they are interacting with an AI (Art 50(1)).
- Generate or manipulate image/audio/video that is a deep fake? → disclose as artificially generated (Art 50(4)).
- Perform emotion recognition or biometric categorisation? → inform affected persons (Art 50(3)).
- Generate synthetic text published to inform the public? → disclose (Art 50(4)).

**Determination:** [applicable obligations listed].

### 2.6 Obligations triggered (split by role)

Obligations depend on the role determined in §2.2. List only those that apply.

**If provider of a high-risk AI system** (Chapter III Section 2):
- Risk management system across lifecycle (Art 9)
- Data governance — training/validation/testing data quality, relevance, bias management (Art 10)
- Technical documentation (Art 11, Annex IV)
- Automatic record-keeping / logs (Art 12)
- Transparency and information to deployers — instructions for use (Art 13)
- Human oversight by design (Art 14)
- Accuracy, robustness, cybersecurity (Art 15)
- Quality management system (Art 17)
- Conformity assessment (Art 43), EU declaration of conformity (Art 47), CE marking (Art 48), registration in EU database (Art 49, Art 71)
- Post-market monitoring plan (Art 72), serious incident reporting (Art 73)
- Cooperation with competent authorities (Art 74)

**If deployer of a high-risk AI system** (Art 26):
- Use in accordance with provider's instructions for use (Art 26(1))
- Assign human oversight to natural persons with competence, training, authority (Art 26(2))
- Ensure relevance and representativeness of input data insofar as controlled by deployer (Art 26(4))
- Monitor operation; suspend and inform provider on serious incident or risk (Art 26(5))
- Keep logs automatically generated by the system for the statutory period (Art 26(6))
- Inform workers' representatives and affected workers before workplace deployment (Art 26(7))
- Cooperate with competent authorities (Art 26(8))
- Inform natural persons subject to decisions based on the high-risk AI system (Art 26(11))
- Fundamental Rights Impact Assessment (Art 27) — for specific deployers: bodies governed by public law, private operators providing public services, deployers using Annex III point 5(b)/(c) (credit, insurance) systems — before first use.

**If limited-risk (Art 50):** transparency obligations apply to both providers and deployers as relevant — disclose AI interaction to the user, label deepfakes, disclose emotion recognition / biometric categorisation, label AI-generated public-interest text.

**If both provider and deployer:** carry both sets, plus align internal roles (often DPO, AI compliance officer, product owner, operations) to avoid dropped obligations.

Map each applicable obligation to a node or process owner. Flag gaps.

### 2.7 General-Purpose AI / foundation-model component (Chapter V)

Does the product integrate a GPAI model (own or third-party)?
- Providers of GPAI: Art 53 obligations (technical documentation, information to downstream, copyright policy, training data summary).
- Providers of GPAI with systemic risk: Art 55 additional obligations (evaluations, adversarial testing, incident reporting, cybersecurity).
- Deployers using third-party GPAI: inherit transparency/information chain.

**Determination:** [none / uses X as deployer / is provider of GPAI].

## 3. GDPR processing analysis (Regulation (EU) 2016/679)

### 3.1 Controller / joint-controller / processor

**Role:** [controller / joint controller with X / processor for X]. **Reasoning:** [who determines purposes and means of each processing].

### 3.2 Processing activities

One row per distinct processing purpose. The World Model accumulation and Interface signal capture are separate processing activities from feature delivery and must be listed separately.

| # | Processing activity | Data categories | Data subjects | Purpose | Art 6 basis | Art 9 basis (if special cat.) | Retention | Recipients |
|---|---------------------|-----------------|---------------|---------|-------------|------------------------------|-----------|------------|
| 1 | [e.g. World Model accumulation — per-user] | [e.g. behavioural, preferences, content] | [users] | [accumulation enabling co-construction] | [consent / contract / legitimate interest / legal obligation / vital / public task] | [N/A or Art 9(2)(a)/(h)/...] | [period + deletion trigger] | [internal / processors / third parties] |
| 2 | [Interface signal capture — accept/ignore/modify events] | [...] | [...] | [...] | [...] | [...] | [...] | [...] |
| 3 | [Feature delivery] | [...] | [...] | [...] | [...] | [...] | [...] | [...] |

### 3.3 Legitimate interest balancing (for any LI basis)

Per activity with LI basis, perform the three-part test (EDPB Guidelines 1/2024 on processing based on Art 6(1)(f), consolidating WP29 Opinion 06/2014):
1. **Purpose test.** What legitimate interest is pursued? Is it real, specific, lawful (not contrary to law), clearly articulated?
2. **Necessity test.** Is the processing necessary to achieve the interest? Is there a less intrusive means that would serve the same purpose?
3. **Balancing test.** Weighed against rights and freedoms of the data subject — reasonable expectations of the subject, nature of data, severity and likelihood of impact, relationship between subject and controller, safeguards applied (pseudonymisation, aggregation, opt-out, transparency).

Document the three tests in writing. Store the reasoning — it must be produced on DPA request (accountability, Art 5(2)).

**Conclusion per activity:** LI [holds — document reasoning / does not hold — must shift to another Art 6 basis such as consent].

### 3.4 Special categories (Art 9)

Does any activity process special categories — health, racial/ethnic origin, political opinions, religious/philosophical beliefs, trade-union membership, genetic, biometric for unique ID, sex life, sexual orientation?

**Determination:** [no / yes — list activities and Art 9(2) basis].

### 3.5 Automated decision-making / profiling (Art 22)

Does the product make decisions based solely on automated processing (including profiling) that produce legal effects or similarly significantly affect the data subject?

**Determination:** [no / yes]. **Reasoning:** [which node produces which decision; what effects].

If yes:
- Basis under Art 22(2): (a) necessary for contract / (b) authorised by EU or MS law / (c) explicit consent. Which one? Reasoning.
- Safeguards (Art 22(3)): right to obtain human intervention, to express point of view, to contest the decision. Describe implementation.
- Special categories + Art 22: only Art 9(2)(a) explicit consent or (g) substantial public interest. Check applicability.

### 3.6 Data subject rights implementation

| Right | Article | Implementation surface | SLA |
|-------|---------|------------------------|-----|
| Information | Art 13/14 | [privacy notice location, update cadence] | at collection |
| Access | Art 15 | [self-service / request channel] | 1 month (extendable to 3) |
| Rectification | Art 16 | [self-service / request channel] | 1 month |
| Erasure | Art 17 | [mechanism, incl. from World Model accumulation] | 1 month |
| Restriction | Art 18 | [mechanism] | 1 month |
| Portability | Art 20 | [export format, scope] | 1 month |
| Objection | Art 21 | [channel, incl. objection to LI processing and direct marketing] | 1 month |
| Not subject to solely automated decisions | Art 22 | [human-review channel] | per contract |

**Gap analysis:** [rights that lack a surface — must be built before launch].

### 3.7 Data minimisation (Art 5(1)(c))

Per processing activity, is the data collected the minimum necessary for the declared purpose? The World Model is the highest-risk area — co-construction incentivises maximising accumulation; minimisation requires the opposite. Document the reasoning for each category retained.

### 3.8 Cross-border transfers (Chapter V)

Are personal data transferred outside EEA? If yes:
- Country / recipient
- Basis: Art 45 adequacy decision / Art 46 SCCs or BCRs / Art 49 derogation
- Transfer Impact Assessment (post-Schrems II) status for non-adequate countries
- Flag US cloud dependencies (Data Privacy Framework status at date of writing)

### 3.9 Retention schedule

Per activity, retention period + deletion trigger + exceptions (legal hold). The World Model accumulation typically cannot be "kept forever" — define the graceful degradation (anonymisation, aggregation, purge).

## 4. DPIA determination (Art 35)

A DPIA is required when processing is likely to result in high risk to rights and freedoms. Indicators (Art 35(3) + WP29/EDPB criteria):

| Indicator | Applies? | Reasoning |
|-----------|---------|-----------|
| Systematic + extensive profiling with legal/significant effects (35(3)(a)) | | |
| Large-scale processing of special categories / criminal data (35(3)(b)) | | |
| Systematic monitoring of publicly accessible areas (35(3)(c)) | | |
| Evaluation/scoring | | |
| Automated decision-making with legal effect | | |
| Matching/combining datasets | | |
| Vulnerable data subjects (children, employees, patients) | | |
| Innovative use of technology (e.g. AI) | | |
| Preventing data subjects from exercising a right / using a service | | |
| Processing on national DPA mandatory-DPIA list (e.g. Garante, CNIL) | | |

**Two or more indicators → DPIA required.**

**Determination:** [required / not required]. If required: schedule DPIA, identify DPO consultation, plan for prior consultation with DPA if residual high risk (Art 36).

## 5. Records of Processing Activities (ROPA) — Art 30

Seeds for the DPO to formalise:
- Controller identity and contact + DPO (if designated under Art 37)
- Purposes of processing
- Categories of data subjects and data
- Categories of recipients
- Transfers outside EEA
- Retention periods
- Security measures (ref. §6)

## 6. Security measures (Art 32 GDPR + Art 15 AI Act for high-risk)

- Encryption at rest / in transit
- Access controls (principle of least privilege, MFA, role separation)
- Audit logs (retention + tamper-evidence)
- Pseudonymisation where applicable
- Backup and recovery testing
- Incident response plan
- Breach notification: 72h to DPA (Art 33), notification to subjects without undue delay if high risk (Art 34)

For high-risk AI Act systems additionally:
- Accuracy thresholds declared and monitored
- Robustness tested against adversarial inputs
- Cybersecurity against AI-specific attacks (adversarial examples, poisoning, model extraction)

## 7. Human oversight (AI Act Art 14, if high-risk)

Describe the human oversight mechanism — per node, who oversees, when (pre-decision review / post-decision audit / real-time monitoring), with what authority (veto / override / escalation), and what information (decision rationale, confidence, model metadata).

## 8. Transparency (AI Act Art 13 for high-risk + Art 50 limited-risk)

- Instructions for use / information to deployers (high-risk)
- User-facing disclosure at interaction point (chatbot/deepfake/emotion/biometric)
- Privacy notice + AI disclosure integration

## 9. Open regulatory questions

Items where the analysis cannot be definitive and requires legal counsel:
- [e.g. "Is the per-user World Model a 'profile' under Art 22 when it only influences UI ordering, not decisions?" Legal view needed.]
- [e.g. "Does this fall under Annex III point 5 — essential private services — given the contractual context?" Legal view needed.]

## 10. Confidence summary

| Section | Confidence | What would change the analysis |
|---------|-----------|-------------------------------|
| 2.3 Annex III | [high/medium/low] | [e.g. pivot to HR adjacent domain] |
| 3.5 Art 22 | [high/medium/low] | [e.g. decision becomes consequential for users] |
| 4 DPIA | [high/medium/low] | [e.g. scale threshold crossed] |
| ... | | |

## 11. Out of scope

Flagged for legal counsel — not covered in this annex:
- National transpositions and sector-specific rules (ePrivacy, DSA, DMA, NIS2, DORA for finance, MDR for medical, etc.)
- Employment law obligations beyond data protection (works councils, collective agreements, monitoring consent regimes)
- Consumer law obligations (unfair commercial practices, dark patterns under DSA)
- IP / copyright — particularly training data and GPAI Art 53(1)(c) copyright policy
- Liability regime (AI Liability Directive, revised Product Liability Directive)
- Non-EU regulations (UK DPA, Swiss FADP, US state laws) if product also serves those markets

## 12. Research performed

All sources consulted during this analysis, with date of access. The analysis is valid as of the most recent source date; regulation and guidance evolve — re-run before material decisions are taken more than 6 months later.

| Source | Type | Date accessed | URL/citation | What it informed |
|--------|------|---------------|--------------|------------------|
| [e.g. EDPB Guidelines 02/2023 on Technical Scope of Art 5(3) ePrivacy] | EDPB guidance | [YYYY-MM-DD] | [URL] | [which section] |
| [e.g. Garante Privacy provvedimento n. X/2025 on AI chatbots] | National DPA decision | [YYYY-MM-DD] | [URL] | [which section] |
| [e.g. CJEU Case C-xxx/xx] | Case law | [YYYY-MM-DD] | [citation] | [which section] |
| [e.g. AI Act Code of Practice for GPAI, v1.0] | Commission soft law | [YYYY-MM-DD] | [URL] | [which section] |
```

---

## Generation rules (for the strategy agent)

When writing this annex:

1. **Cite articles, don't paraphrase.** "Art 6(1)(f)" not "legitimate interest basis". A lawyer must be able to verify.
2. **Reason, then conclude.** Every determination carries its reasoning. Single-word answers are defects.
3. **Flag uncertainty explicitly.** Anything that is not straightforwardly verifiable from the brief + research goes in §9 or gets a "low" confidence in §10.
4. **Match the CLAUDE.md World Model and scope fields.** The GDPR analysis and the World Model must be internally consistent — same activities, same categories, same scope.
5. **Do not overclaim.** If the product might be high-risk, write "likely high-risk" with reasoning, not "high-risk confirmed". Under-claiming is also a defect — if it's clearly Annex III, say so.
6. **Keep the disclaimer visible.** Never produce this annex without the top disclaimer.

### Required specific research (§12 must not be empty)

The analysis cannot rest on general knowledge. Before writing, the strategy agent performs targeted searches and cites findings with dates. Minimum search set:

**Regulatory baselines — verify these are the latest consolidated versions:**
- Current consolidated GDPR text and any recent amendments (e.g., EDPB guidelines adopted within 24 months).
- AI Act consolidated text (OJ L, 2024/1689) and delegated/implementing acts adopted since entry into force (2 August 2024). Check Commission register for new acts.
- AI Act Codes of Practice (GPAI — published by the AI Office) and the status of the related Commission endorsement.
- EDPB guidelines and opinions issued in the past 24 months that touch the product's domain (AI-specific, profiling, legitimate interest, children, biometrics, etc.).

**Domain-specific — interpolate the product's domain:**
- National DPA decisions and guidance — specifically the competent DPA for the user's establishment and for any country where the product is offered. For Italy: Garante per la protezione dei dati personali (garanteprivacy.it, search "provvedimenti"). For France: CNIL. For Ireland: DPC. For Germany: federal BfDI + Länder DPAs.
- Professional body and sector regulator guidance for the product's domain. For Italy examples: CNDCEC for commercialisti, FNOMCeO for medici, CNF for avvocati, Consob/Banca d'Italia for finance, AIFA for farmaceutico, AGCOM for telco/media. These bodies often publish domain-specific privacy/AI guidance that materially changes the design baseline.
- Recent fines/decisions in the product's domain: search "[DPA] [domain] fine 2025" and "[DPA] [domain] provvedimento 2026" (or current year).
- CJEU case law in the domain — check for decisions on automated decision-making (post-OQ C-634/21 SCHUFA), on legitimate interest, on transfers (Schrems II C-311/18 and subsequent).
- If the product is deployed in an employment context: ILO / Garante Lavoro guidance, national monitoring regimes.
- If GPAI is integrated: AI Office guidance, providers' transparency disclosures, standards bodies (CEN-CENELEC JTC 21) outputs.

**Cross-border / Schrems II posture:**
- Current status of the EU-US Data Privacy Framework (adequacy decision 10 July 2023) — verify it has not been invalidated.
- Status of adequacy decisions for other relevant jurisdictions (UK, Switzerland, Japan, etc.).

Each search result that informs a determination must be cited in §12 with date and URL. A finding without a dated citation is a defect.

### Currency check

Stamp a validity note at the top: "Analysis valid as of [YYYY-MM-DD] against the state of the law at that date." Mark any finding that depends on pending legislation or draft guidance as such in §9. Any annex older than 6 months must be regenerated before material decisions are taken.
