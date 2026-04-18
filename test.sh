#!/bin/bash
# Playbook plugin self-test. Run with: bash test.sh

PASS=0
FAIL=0
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

check() {
  local desc="$1"
  local result="$2"
  if [ "$result" -eq 0 ]; then
    echo -e "  ${GREEN}PASS${NC}  $desc"
    PASS=$((PASS + 1))
  else
    echo -e "  ${RED}FAIL${NC}  $desc"
    FAIL=$((FAIL + 1))
  fi
}

echo ""
echo "Playbook plugin self-test"
echo "====================="
echo ""

# --- Required files must exist ---
echo "Required files:"

for f in "reference/concepts.md" "reference/example.md" "reference/claude-md-template.md" "reference/regulatory-annex-template.md" "commands/strategy.md" "commands/build.md" "commands/review.md" "skills/playbook-awareness/SKILL.md" "skills/build-awareness/SKILL.md" "README.md" "hooks/hooks.json" ".claude-plugin/plugin.json" ".claude-plugin/marketplace.json"; do
  if [ -f "$f" ]; then
    check "$f exists" 0
  else
    check "$f exists" 1
  fi
done

echo ""

# --- Cross-references must be valid ---
echo "Cross-references:"

refs=$(grep -roh 'reference/[a-z-]*\.md' --include="*.md" . 2>/dev/null | sort -u)
for ref in $refs; do
  if [ -f "$ref" ]; then
    check "$ref exists (referenced)" 0
  else
    check "$ref exists (referenced)" 1
  fi
done

echo ""

# --- Node model consistency (5 fields) ---
echo "Node model (5 fields: Layer, Evolution, Metric, Graduation, Loop):"

for f in "reference/concepts.md" "reference/claude-md-template.md" "commands/strategy.md"; do
  has_layer=$(grep -ci "layer" "$f" 2>/dev/null)
  has_evolution=$(grep -ci "evolution" "$f" 2>/dev/null)
  has_metric=$(grep -ci "metric" "$f" 2>/dev/null)
  has_graduation=$(grep -ci "graduation" "$f" 2>/dev/null)
  has_loop=$(grep -ci "loop" "$f" 2>/dev/null)
  if [ "$has_layer" -gt 0 ] && [ "$has_evolution" -gt 0 ] && [ "$has_metric" -gt 0 ] && [ "$has_graduation" -gt 0 ] && [ "$has_loop" -gt 0 ]; then
    check "$f references all 5 node fields" 0
  else
    check "$f references all 5 node fields" 1
  fi
done

echo ""

# --- Core concepts must appear where needed ---
echo "Concept coverage:"

for concept in "context engineering\|context fidelity\|Context Engineering\|Context Fidelity"; do
  count=$(grep -rl "$concept" --include="*.md" . 2>/dev/null | grep -v test.sh | wc -l | tr -d ' ')
  if [ "$count" -ge 3 ]; then
    check "context engineering in 3+ files ($count found)" 0
  else
    check "context engineering in 3+ files ($count found)" 1
  fi
done

count=$(grep -rl "autoresearch" --include="*.md" . 2>/dev/null | grep -v test.sh | wc -l | tr -d ' ')
if [ "$count" -ge 5 ]; then
  check "autoresearch in 5+ files ($count found)" 0
else
  check "autoresearch in 5+ files ($count found)" 1
fi

count=$(grep -rl "does the interface learn\|Interface.*learn\|Interface.*sensor\|Interface.*signal" --include="*.md" . 2>/dev/null | grep -v test.sh | wc -l | tr -d ' ')
if [ "$count" -ge 4 ]; then
  check "interface learning principle in 4+ files ($count found)" 0
else
  check "interface learning principle in 4+ files ($count found)" 1
fi

count=$(grep -rl "World Model" --include="*.md" . 2>/dev/null | grep -v test.sh | wc -l | tr -d ' ')
if [ "$count" -ge 4 ]; then
  check "World Model concept in 4+ files ($count found)" 0
else
  check "World Model concept in 4+ files ($count found)" 1
fi

echo ""

# --- Playbook mapping table format ---
echo "Playbook mapping table:"

count=$(grep -c "| Node | Layer | Evolution | Metric" reference/claude-md-template.md 2>/dev/null)
check "template has mapping table header" "$( [ "$count" -gt 0 ] && echo 0 || echo 1 )"

count=$(grep -c "Graduation" reference/claude-md-template.md 2>/dev/null)
check "template includes Graduation column" "$( [ "$count" -gt 0 ] && echo 0 || echo 1 )"

count=$(grep -c "Loop" reference/claude-md-template.md 2>/dev/null)
check "template includes Loop column" "$( [ "$count" -gt 0 ] && echo 0 || echo 1 )"

echo ""

# --- Plugin naming ---
echo "Plugin naming:"

name=$(grep '"name"' .claude-plugin/plugin.json 2>/dev/null | head -1)
check "plugin.json name is 'playbook'" "$( echo "$name" | grep -q '"playbook"' && echo 0 || echo 1 )"

repo=$(grep '"repository"' .claude-plugin/plugin.json 2>/dev/null)
check "plugin.json repo points to Play-New/playbook" "$( echo "$repo" | grep -q 'Play-New/playbook' && echo 0 || echo 1 )"

url=$(grep '"url"' .claude-plugin/marketplace.json 2>/dev/null | grep -v "github.com/Play-New\"")
check "marketplace.json source URL points to Play-New/playbook" "$( echo "$url" | grep -q 'Play-New/playbook' && echo 0 || echo 1 )"

mkt_name=$(grep '"name"' .claude-plugin/marketplace.json 2>/dev/null | head -1)
check "marketplace.json name is 'playbook'" "$( echo "$mkt_name" | grep -q '"playbook"' && echo 0 || echo 1 )"

echo ""

# --- Textual coherence ---
echo "Textual coherence:"

count=$(grep "piece\b" commands/build.md 2>/dev/null | grep -v "Missing pieces" | wc -l | tr -d ' ')
check "build.md uses 'node' not 'piece'" "$count"

has_direction=$(grep "Graduation" reference/concepts.md 2>/dev/null | head -1 | grep -c "direction")
check "concepts.md Graduation says condition + direction" "$( [ "$has_direction" -gt 0 ] && echo 0 || echo 1 )"

has_signal=$(grep "Metric/Signal\|Metric / Signal" README.md 2>/dev/null | wc -l | tr -d ' ')
check "README uses Metric/Signal (not just Metric)" "$( [ "$has_signal" -ge 2 ] && echo 0 || echo 1 )"

count=$(grep -rn "autoresearch/manual/" --include="*.md" . 2>/dev/null | grep -v "manual review" | grep -v test.sh | wc -l | tr -d ' ')
check "Loop field uses 'manual review' not 'manual'" "$count"

count=$(grep -r "an playbook" --include="*.md" . 2>/dev/null | grep -v test.sh | wc -l | tr -d ' ')
check "no 'an playbook' grammar errors" "$count"

count=$(grep -c "## 5. Security\|### OWASP\|### Secrets\|### Blocking Rules" commands/review.md 2>/dev/null)
check "review.md has no security section" "$count"

example_count=$(grep -c "^# Example" reference/example.md 2>/dev/null)
check "example.md has 3+ examples ($example_count found)" "$( [ "$example_count" -ge 3 ] && echo 0 || echo 1 )"

echo ""

# --- Co-construction lens (user + machine co-construct the World Model) ---
# The foundational principle: the product is not a tool that serves; it is a partner
# that accumulates a World Model with its users. Every framing artifact must reflect this.
echo "Co-construction framing:"

# The Vision question in build.md must be bidirectional (user AND product as subjects)
vision_bidir=$(grep -c "user and product\|together when this works" commands/build.md 2>/dev/null)
check "build.md Vision question is bidirectional (user + product together)" "$( [ "$vision_bidir" -gt 0 ] && echo 0 || echo 1 )"

# The old monodirectional Vision phrasing must not be present
old_vision=$(grep -c "What does the user see, feel, do?" commands/build.md 2>/dev/null)
check "build.md old monodirectional Vision question removed" "$old_vision"

# README must not say "gets smarter from use" (monodirectional "it")
gets_smarter=$(grep -c "does it get smarter from use\|it get smarter from use" README.md 2>/dev/null)
check "README.md no 'it gets smarter' monodirectional phrasing" "$gets_smarter"

# README tagline must include user+machine or World Model
tagline_bidir=$(grep -c "user and machine\|user and product compound\|World Model no competitor" README.md 2>/dev/null)
check "README.md tagline frames co-construction (user + machine compound)" "$( [ "$tagline_bidir" -gt 0 ] && echo 0 || echo 1 )"

# CLAUDE.md template must include a World Model field
wm_field=$(grep -c "^\*\*World Model:" reference/claude-md-template.md 2>/dev/null)
check "claude-md-template.md has World Model field" "$( [ "$wm_field" -gt 0 ] && echo 0 || echo 1 )"

# Strategic Assessment in strategy.md must include "Where learning happens"
learning_item=$(grep -c "Where learning happens" commands/strategy.md 2>/dev/null)
check "strategy.md Strategic Assessment has 'Where learning happens' item" "$( [ "$learning_item" -gt 0 ] && echo 0 || echo 1 )"

# Strategy Extract the Value must have 3 items, including "accumulates from use"
accumulates=$(grep -c "accumulates from use\|What accumulates from use" commands/strategy.md 2>/dev/null)
check "strategy.md Extract the Value includes 'accumulates from use'" "$( [ "$accumulates" -gt 0 ] && echo 0 || echo 1 )"

# Strategy challenge list must include "Value flows one way"
one_way=$(grep -c "Value flows one way" commands/strategy.md 2>/dev/null)
check "strategy.md challenge list includes 'Value flows one way'" "$( [ "$one_way" -gt 0 ] && echo 0 || echo 1 )"

# Build Vision challenges must include "Missing learning loop"
learning_loop_challenge=$(grep -c "Missing learning loop" commands/build.md 2>/dev/null)
check "build.md Vision has 'Missing learning loop' challenge" "$( [ "$learning_loop_challenge" -gt 0 ] && echo 0 || echo 1 )"

# Build test examples must include co-construction tests (learn, capture, feeds)
coconstruct_tests=$(grep -cE "test\('.*(edit is captured|alert is ignored|searches for an untracked)" commands/build.md 2>/dev/null)
check "build.md test examples include co-construction tests" "$( [ "$coconstruct_tests" -ge 2 ] && echo 0 || echo 1 )"

# Four Layers intro in concepts.md must mention signal flowing back (bidirectional)
four_layers_bidir=$(grep -c "signal flows from use back\|signal flows back" reference/concepts.md 2>/dev/null)
check "concepts.md Four Layers intro is bidirectional (signal flows back)" "$( [ "$four_layers_bidir" -gt 0 ] && echo 0 || echo 1 )"

# Delivery definition must mention signal capture (not just one-way)
delivery_bidir=$(grep -A2 "^\*\*Delivery\*\*" reference/concepts.md 2>/dev/null | grep -c "captures signal\|also captures\|what the surface observes")
check "concepts.md Delivery definition mentions signal capture" "$( [ "$delivery_bidir" -gt 0 ] && echo 0 || echo 1 )"

# concepts.md must have "Plugin World Model" section (renamed from Plugin Learning)
plugin_wm=$(grep -c "^## Plugin World Model" reference/concepts.md 2>/dev/null)
check "concepts.md has 'Plugin World Model' section (not 'Plugin Learning')" "$( [ "$plugin_wm" -gt 0 ] && echo 0 || echo 1 )"

# No remaining "Plugin Learning" references anywhere
plugin_learning=$(grep -r "Plugin Learning\|## Plugin Learning" --include="*.md" . 2>/dev/null | grep -v test.sh | wc -l | tr -d ' ')
check "no 'Plugin Learning' references remain (renamed to Plugin World Model)" "$plugin_learning"

# review.md Status values must include "enriching"
enriching_status=$(grep -c "enriching" commands/review.md 2>/dev/null)
check "review.md Node Metrics Status includes 'enriching'" "$( [ "$enriching_status" -gt 0 ] && echo 0 || echo 1 )"

# review.md Interface & World Model section must come before Node Metrics (foundational check first)
iwm_line=$(grep -n "^### Interface & World Model" commands/review.md 2>/dev/null | head -1 | cut -d: -f1)
nm_line=$(grep -n "^### Node Metrics" commands/review.md 2>/dev/null | head -1 | cut -d: -f1)
if [ -n "$iwm_line" ] && [ -n "$nm_line" ] && [ "$iwm_line" -lt "$nm_line" ]; then
  check "review.md Interface & World Model section comes before Node Metrics" 0
else
  check "review.md Interface & World Model section comes before Node Metrics" 1
fi

# example.md must have a World Model section per example (3 examples → 3 World Model sections)
wm_sections=$(grep -c "^## World Model" reference/example.md 2>/dev/null)
check "example.md has World Model section in every example (3 total)" "$( [ "$wm_sections" -ge 3 ] && echo 0 || echo 1 )"

# skills must have Interface check among first 3 items (not buried at the end)
# build-awareness
bawareness_pos=$(grep -nE "^[0-9]+\. \*\*Interface" skills/build-awareness/SKILL.md 2>/dev/null | head -1 | sed 's/^\([0-9]*\)\..*/\1/' | cut -d'.' -f1)
# the above cuts the line number, then we need the item number in the list
bawareness_item=$(grep -E "^[0-9]+\. \*\*Interface" skills/build-awareness/SKILL.md 2>/dev/null | head -1 | sed 's/\. \*\*.*//')
if [ -n "$bawareness_item" ] && [ "$bawareness_item" -le 3 ]; then
  check "build-awareness Interface check is among first 3 items" 0
else
  check "build-awareness Interface check is among first 3 items" 1
fi

pawareness_item=$(grep -E "^[0-9]+\. \*\*Interface" skills/playbook-awareness/SKILL.md 2>/dev/null | head -1 | sed 's/\. \*\*.*//')
if [ -n "$pawareness_item" ] && [ "$pawareness_item" -le 3 ]; then
  check "playbook-awareness Interface check is among first 3 items" 0
else
  check "playbook-awareness Interface check is among first 3 items" 1
fi

# Risk → challenge replacement: no "riskiest" or "Where the risk is" in strategy/build/README
# (keep the word "risk" only where it belongs — e.g. no strategic use)
residual_risk=$(grep -rn "riskiest\|Where the risk is\|low risk," --include="*.md" . 2>/dev/null | grep -v test.sh | wc -l | tr -d ' ')
check "no residual strategic 'risk' language (replaced by 'challenge')" "$residual_risk"

# README /build description must mirror build.md's bidirectional framing
build_desc_bidir=$(grep -c "what do user and product do together\|user and product do together" README.md 2>/dev/null)
check "README /build description is bidirectional" "$( [ "$build_desc_bidir" -gt 0 ] && echo 0 || echo 1 )"

# README Delivery row in the Layer table must mention signal/observation (not just one-way)
delivery_row_bidir=$(grep -c "observes how the user responds\|signal flows back" README.md 2>/dev/null)
check "README Delivery row mentions signal flowing back" "$( [ "$delivery_row_bidir" -gt 0 ] && echo 0 || echo 1 )"

# strategy.md CLAUDE.md verification check mentions World Model
claude_check_wm=$(grep -c "what the product accumulates (World Model)\|World Model field" commands/strategy.md 2>/dev/null)
check "strategy.md CLAUDE.md verification mentions World Model" "$( [ "$claude_check_wm" -gt 0 ] && echo 0 || echo 1 )"

# concepts.md Node definition must mention signal capture as a unit
node_signal=$(grep -A3 "^## Node$" reference/concepts.md 2>/dev/null | grep -c "signal capture")
check "concepts.md Node definition mentions signal capture" "$( [ "$node_signal" -gt 0 ] && echo 0 || echo 1 )"

# concepts.md Context Engineering must mention "what the product accumulates"
context_eng_wm=$(grep -A5 "^## Context Engineering$" reference/concepts.md 2>/dev/null | grep -c "accumulates from use\|World Model")
check "concepts.md Context Engineering mentions World Model" "$( [ "$context_eng_wm" -gt 0 ] && echo 0 || echo 1 )"

# review.md section ordering: Interface & World Model must be section 2 (not later)
review_s2=$(grep -c "^## 2\. Interface & World Model" commands/review.md 2>/dev/null)
check "review.md section 2 is 'Interface & World Model'" "$( [ "$review_s2" -gt 0 ] && echo 0 || echo 1 )"

# Build Vision must bridge to the CLAUDE.md World Model field (loop iteration #1 fix)
vision_bridge=$(grep -c "read the \*\*World Model\*\* field\|Your CLAUDE.md says the product accumulates" commands/build.md 2>/dev/null)
check "build.md Vision bridges to CLAUDE.md World Model field" "$( [ "$vision_bridge" -gt 0 ] && echo 0 || echo 1 )"

# Strategy challenge list must include "World Model scope" (loop iteration #2 fix)
wm_scope=$(grep -c "World Model scope" commands/strategy.md 2>/dev/null)
check "strategy.md challenge list includes 'World Model scope'" "$( [ "$wm_scope" -gt 0 ] && echo 0 || echo 1 )"

# Strategy Update Mapping includes Check the World Model
update_wm_check=$(grep -c "Check the World Model" commands/strategy.md 2>/dev/null)
check "strategy.md Update Mapping includes 'Check the World Model' step" "$( [ "$update_wm_check" -gt 0 ] && echo 0 || echo 1 )"

# Build Loop step 2 references World Model AND regulatory posture together as build context
build_step2=$(awk '/^### 3\. Build Loop/,/^### 4\./' commands/build.md 2>/dev/null)
build_has_wm=$(echo "$build_step2" | grep -c "World Model")
build_has_reg=$(echo "$build_step2" | grep -c "regulatory posture")
if [ "$build_has_wm" -gt 0 ] && [ "$build_has_reg" -gt 0 ]; then
  check "build.md Build Loop step 2 includes World Model + regulatory posture as context" 0
else
  check "build.md Build Loop step 2 includes World Model + regulatory posture as context" 1
fi

# Review metrics check includes growth-from-use
growing_check=$(grep -c "Is it growing from use?" commands/review.md 2>/dev/null)
check "review.md metrics check includes 'Is it growing from use?'" "$( [ "$growing_check" -gt 0 ] && echo 0 || echo 1 )"

echo ""

# === EU regulatory integration (GDPR + AI Act) ===
echo "Regulatory by-design (GDPR + AI Act):"

# Regulatory annex template exists
if [ -f "reference/regulatory-annex-template.md" ]; then
  check "reference/regulatory-annex-template.md exists" 0
else
  check "reference/regulatory-annex-template.md exists" 1
fi

# Annex template cites both regulations by number
annex_gdpr=$(grep -c "Regulation (EU) 2016/679" reference/regulatory-annex-template.md 2>/dev/null)
annex_aia=$(grep -c "Regulation (EU) 2024/1689" reference/regulatory-annex-template.md 2>/dev/null)
if [ "$annex_gdpr" -gt 0 ] && [ "$annex_aia" -gt 0 ]; then
  check "annex template cites GDPR and AI Act by regulation number" 0
else
  check "annex template cites GDPR and AI Act by regulation number" 1
fi

# Annex template includes AI Act phased application dates
annex_dates=$(grep -c "2 February 2025\|2 August 2025\|2 August 2026\|2 August 2027" reference/regulatory-annex-template.md 2>/dev/null)
check "annex template documents AI Act phased application dates" "$( [ "$annex_dates" -ge 3 ] && echo 0 || echo 1 )"

# Annex template has disclaimer
annex_disclaimer=$(grep -c "not legal advice" reference/regulatory-annex-template.md 2>/dev/null)
check "annex template includes 'not legal advice' disclaimer" "$( [ "$annex_disclaimer" -gt 0 ] && echo 0 || echo 1 )"

# Annex template requires dated research citations (§12 Research performed)
annex_research=$(grep -c "^## 12\. Research performed" reference/regulatory-annex-template.md 2>/dev/null)
check "annex template has §12 Research performed section" "$( [ "$annex_research" -gt 0 ] && echo 0 || echo 1 )"

# Annex template requires currency check
annex_currency=$(grep -c "Currency check\|Analysis valid as of" reference/regulatory-annex-template.md 2>/dev/null)
check "annex template includes currency/validity requirement" "$( [ "$annex_currency" -gt 0 ] && echo 0 || echo 1 )"

# Annex template covers Annex III high-risk categories
annex_annex_iii=$(grep -c "Annex III" reference/regulatory-annex-template.md 2>/dev/null)
check "annex template covers AI Act Annex III (high-risk)" "$( [ "$annex_annex_iii" -ge 3 ] && echo 0 || echo 1 )"

# Annex template covers Art 22 automated decisions
annex_art22=$(grep -c "Art 22\|Art 22 " reference/regulatory-annex-template.md 2>/dev/null)
check "annex template covers GDPR Art 22 (automated decisions)" "$( [ "$annex_art22" -ge 2 ] && echo 0 || echo 1 )"

# strategy.md has Lens 6 for regulatory
strategy_lens6=$(grep -c "^\*\*Lens 6: Regulatory posture" commands/strategy.md 2>/dev/null)
check "strategy.md Research has Lens 6 (Regulatory posture)" "$( [ "$strategy_lens6" -gt 0 ] && echo 0 || echo 1 )"

# Annex template names competent DPAs for specific research
annex_dpa=$(grep -c "Garante\|garanteprivacy\|CNIL" reference/regulatory-annex-template.md 2>/dev/null)
check "annex template names competent DPAs (Garante, CNIL, etc.)" "$( [ "$annex_dpa" -ge 2 ] && echo 0 || echo 1 )"

# strategy.md challenge list includes regulatory tier challenge
strategy_ch_tier=$(grep -c "Regulatory tier unspecified or underestimated" commands/strategy.md 2>/dev/null)
check "strategy.md challenge list includes 'Regulatory tier' challenge" "$( [ "$strategy_ch_tier" -gt 0 ] && echo 0 || echo 1 )"

# strategy.md challenge list includes lawful basis challenge
strategy_ch_basis=$(grep -c "Accumulation without lawful basis" commands/strategy.md 2>/dev/null)
check "strategy.md challenge list includes 'Accumulation without lawful basis'" "$( [ "$strategy_ch_basis" -gt 0 ] && echo 0 || echo 1 )"

# strategy.md Strategic Assessment has Regulatory posture item
strategy_assess_reg=$(grep -c "^5\. \*\*Regulatory posture\*\*" commands/strategy.md 2>/dev/null)
check "strategy.md Strategic Assessment has 'Regulatory posture' item" "$( [ "$strategy_assess_reg" -gt 0 ] && echo 0 || echo 1 )"

# strategy.md declares two human-readable docs (strategic + regulatory) + CLAUDE.md as agent context
strategy_two_docs=$(grep -c "two human-readable documents" commands/strategy.md 2>/dev/null)
check "strategy.md declares two human-readable docs + CLAUDE.md as agent context" "$( [ "$strategy_two_docs" -gt 0 ] && echo 0 || echo 1 )"

# strategy.md references the annex template
strategy_annex_ref=$(grep -c "regulatory-annex-template.md" commands/strategy.md 2>/dev/null)
check "strategy.md references regulatory-annex-template.md" "$( [ "$strategy_annex_ref" -gt 0 ] && echo 0 || echo 1 )"

# CLAUDE.md template has Regulatory posture field
tmpl_reg=$(grep -c "^\*\*Regulatory posture:" reference/claude-md-template.md 2>/dev/null)
check "claude-md-template.md has Regulatory posture field" "$( [ "$tmpl_reg" -gt 0 ] && echo 0 || echo 1 )"

# concepts.md has Regulatory posture section
concepts_reg=$(grep -c "^## Regulatory posture$" reference/concepts.md 2>/dev/null)
check "concepts.md has 'Regulatory posture' section" "$( [ "$concepts_reg" -gt 0 ] && echo 0 || echo 1 )"

# review.md Interface & World Model section has regulatory drift bullet
review_reg_drift=$(grep -c "Regulatory drift" commands/review.md 2>/dev/null)
check "review.md Interface & WM section has 'Regulatory drift' bullet" "$( [ "$review_reg_drift" -gt 0 ] && echo 0 || echo 1 )"

# README declares 2 human-readable docs + CLAUDE.md technical context
readme_two_docs=$(grep -c "two human-readable documents" README.md 2>/dev/null)
readme_annex=$(grep -c "Regulatory Annex" README.md 2>/dev/null)
if [ "$readme_two_docs" -gt 0 ] && [ "$readme_annex" -gt 0 ]; then
  check "README declares 2 human-readable docs (strategic + regulatory) + CLAUDE.md" 0
else
  check "README declares 2 human-readable docs (strategic + regulatory) + CLAUDE.md" 1
fi

# Annex template has dedicated Role section (provider vs deployer)
annex_role=$(grep -c "^### 2\.2 Role " reference/regulatory-annex-template.md 2>/dev/null)
check "annex template has §2.2 Role (provider/deployer)" "$( [ "$annex_role" -gt 0 ] && echo 0 || echo 1 )"

# Annex template distinguishes provider and deployer obligations
annex_prov_obl=$(grep -c "If provider of a high-risk AI system" reference/regulatory-annex-template.md 2>/dev/null)
annex_dep_obl=$(grep -c "If deployer of a high-risk AI system" reference/regulatory-annex-template.md 2>/dev/null)
if [ "$annex_prov_obl" -gt 0 ] && [ "$annex_dep_obl" -gt 0 ]; then
  check "annex template splits obligations by role (provider vs deployer)" 0
else
  check "annex template splits obligations by role (provider vs deployer)" 1
fi

# Annex template flags downstream provider of GPAI (Art 25, Art 53)
annex_downstream=$(grep -c "Downstream provider\|downstream provider" reference/regulatory-annex-template.md 2>/dev/null)
check "annex template covers downstream provider of GPAI-integrated system" "$( [ "$annex_downstream" -gt 0 ] && echo 0 || echo 1 )"

# Annex template cites Art 25 substantial modification
annex_art25=$(grep -c "Art 25" reference/regulatory-annex-template.md 2>/dev/null)
check "annex template cites Art 25 (substantial modification)" "$( [ "$annex_art25" -ge 2 ] && echo 0 || echo 1 )"

# Strategy challenge list includes 'Role underestimated'
strategy_role_ch=$(grep -c "Role underestimated" commands/strategy.md 2>/dev/null)
check "strategy.md challenge list includes 'Role underestimated'" "$( [ "$strategy_role_ch" -gt 0 ] && echo 0 || echo 1 )"

# CLAUDE.md template Regulatory posture field includes AI Act role
tmpl_role=$(grep -c "AI Act role" reference/claude-md-template.md 2>/dev/null)
check "claude-md-template.md Regulatory posture includes AI Act role" "$( [ "$tmpl_role" -gt 0 ] && echo 0 || echo 1 )"

# concepts.md Regulatory posture describes role distinction
concepts_role=$(grep -c "^\*\*AI Act role\.\*\*" reference/concepts.md 2>/dev/null)
check "concepts.md Regulatory posture covers role (provider vs deployer)" "$( [ "$concepts_role" -gt 0 ] && echo 0 || echo 1 )"

# Case-study-driven improvements:

# A. strategy.md documents when to SKIP the annex (minimal-risk + no processing)
annex_skip=$(grep -c "Skip the annex" commands/strategy.md 2>/dev/null)
check "strategy.md documents when to skip the annex" "$( [ "$annex_skip" -gt 0 ] && echo 0 || echo 1 )"

# B. strategy.md challenge list has dedicated Prohibited practice hard stop
prohibited_ch=$(grep -c "Prohibited practice — hard stop" commands/strategy.md 2>/dev/null)
check "strategy.md challenge list includes 'Prohibited practice — hard stop'" "$( [ "$prohibited_ch" -gt 0 ] && echo 0 || echo 1 )"

# C. annex template §2.3 has visible Hard Stop block
annex_hardstop=$(grep -c "HARD STOP" reference/regulatory-annex-template.md 2>/dev/null)
check "annex template §2.3 has visible HARD STOP block" "$( [ "$annex_hardstop" -gt 0 ] && echo 0 || echo 1 )"

# Real-run improvements (from FiscalCopilot live run):

# D. CLAUDE.md template Regulatory posture includes GDPR role (controller/processor)
tmpl_gdpr_role=$(grep -c "GDPR role (controller/processor" reference/claude-md-template.md 2>/dev/null)
check "claude-md-template Regulatory posture includes GDPR role" "$( [ "$tmpl_gdpr_role" -gt 0 ] && echo 0 || echo 1 )"

# E. annex template Lens 6 prompts for professional body / sector regulator guidance
annex_prof_body=$(grep -ci "professional body\|sector regulator\|CNDCEC\|FNOMCeO" reference/regulatory-annex-template.md 2>/dev/null)
check "annex template names professional body/sector regulator guidance" "$( [ "$annex_prof_body" -gt 0 ] && echo 0 || echo 1 )"

# F. strategy.md challenge list has 'Incumbent closes the genesis'
incumbent_ch=$(grep -c "Incumbent closes the genesis" commands/strategy.md 2>/dev/null)
check "strategy.md challenge list includes 'Incumbent closes the genesis'" "$( [ "$incumbent_ch" -gt 0 ] && echo 0 || echo 1 )"

# README strategic alignment (post real-run pass):

# README §1 has 4 strategic failure modes (regulatory is not a failure mode, separate dimension)
readme_four=$(grep -c "^Four failure modes:" README.md 2>/dev/null)
check "README §1 has 4 strategic failure modes" "$( [ "$readme_four" -gt 0 ] && echo 0 || echo 1 )"

# README challenges list surfaces strategic additions (regulatory referenced separately)
readme_ch_loop=$(grep -c "Missing learning loop" README.md 2>/dev/null)
readme_ch_incumbent=$(grep -c "Incumbent closes the genesis" README.md 2>/dev/null)
readme_reg_pointer=$(grep -c "additional regulatory challenges apply" README.md 2>/dev/null)
if [ "$readme_ch_loop" -gt 0 ] && [ "$readme_ch_incumbent" -gt 0 ] && [ "$readme_reg_pointer" -gt 0 ]; then
  check "README challenges list: strategic items + pointer to regulatory in strategy.md" 0
else
  check "README challenges list: strategic items + pointer to regulatory in strategy.md" 1
fi

# README declares compound loop explicitly
readme_compound=$(grep -c "compound loop" README.md 2>/dev/null)
check "README declares strategy→build→review compound loop" "$( [ "$readme_compound" -gt 0 ] && echo 0 || echo 1 )"

echo ""

# --- Summary ---
TOTAL=$((PASS + FAIL))
echo "====================="
if [ "$FAIL" -eq 0 ]; then
  echo -e "${GREEN}ALL $TOTAL CHECKS PASSED${NC}"
else
  echo -e "${RED}$FAIL FAILED${NC} / $TOTAL total"
fi
echo ""
exit $FAIL
