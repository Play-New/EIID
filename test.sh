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

for f in "reference/concepts.md" "reference/example.md" "reference/claude-md-template.md" "commands/strategy.md" "commands/build.md" "commands/review.md" "skills/playbook-awareness/SKILL.md" "skills/build-awareness/SKILL.md" "README.md" "hooks/hooks.json" ".claude-plugin/plugin.json" ".claude-plugin/marketplace.json"; do
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
