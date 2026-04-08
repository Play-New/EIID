#!/bin/bash
# EIID plugin self-test. Run with: bash test.sh
# Every check that was caught manually during review is now automated.

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
echo "EIID plugin self-test"
echo "====================="
echo ""

# --- Removed concepts must not appear ---
echo "Removed concepts:"

count=$(grep -ri "rule zero" --include="*.md" --include="*.json" . 2>/dev/null | grep -v test.sh | wc -l | tr -d ' ')
check "no 'rule zero' references" "$count"

count=$(grep -ri "target feeling" --include="*.md" --include="*.json" . 2>/dev/null | grep -v test.sh | wc -l | tr -d ' ')
check "no 'target feeling' references" "$count"

count=$(grep -ri "experience pattern" --include="*.md" --include="*.json" . 2>/dev/null | grep -v test.sh | wc -l | tr -d ' ')
check "no 'experience pattern' references" "$count"

count=$(grep -ri "prompt visibility" --include="*.md" --include="*.json" . 2>/dev/null | grep -v test.sh | wc -l | tr -d ' ')
check "no 'prompt visibility' references" "$count"

count=$(grep -rE "automate.*differentiate.*innovate|Automate.*Differentiate" --include="*.md" . 2>/dev/null | grep -v test.sh | wc -l | tr -d ' ')
check "no classification taxonomy" "$count"

count=$(grep -rE "LLM call.*workflow.*agent.*code.*buy" --include="*.md" . 2>/dev/null | grep -v test.sh | wc -l | tr -d ' ')
check "no implementation levels taxonomy" "$count"

echo ""

# --- Old naming must not appear ---
echo "Old naming:"

count=$(grep -r "superskills\|SuperSkills" --include="*.md" --include="*.json" . 2>/dev/null | grep -v test.sh | grep -v .git | wc -l | tr -d ' ')
check "no 'superskills' references" "$count"

count=$(grep -rE "/super:" --include="*.md" --include="*.json" . 2>/dev/null | grep -v test.sh | wc -l | tr -d ' ')
check "no '/super:' command references" "$count"

count=$(grep -r "\.superskills" --include="*.md" --include="*.json" . 2>/dev/null | grep -v test.sh | wc -l | tr -d ' ')
check "no '.superskills' directory references" "$count"

echo ""

# --- Deleted files must not be referenced ---
echo "Deleted file references:"

for ref in "design-critique" "design-system-template" "report-template" "decisions-template" "design-awareness" "stop-tests" "decisions.md" "build-plan.md" "design-system.md"; do
  count=$(grep -r "$ref" --include="*.md" --include="*.json" . 2>/dev/null | grep -v test.sh | wc -l | tr -d ' ')
  check "no '$ref' references" "$count"
done

echo ""

# --- Required files must exist ---
echo "Required files:"

for f in "reference/concepts.md" "reference/example.md" "reference/claude-md-template.md" "commands/strategy.md" "commands/build.md" "commands/review.md" "skills/eiid-awareness/SKILL.md" "skills/build-awareness/SKILL.md" "README.md" "hooks/hooks.json" ".claude-plugin/plugin.json" ".claude-plugin/marketplace.json"; do
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

# --- Node model consistency ---
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

# --- Key concepts must appear where needed ---
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

echo ""

# --- EIID mapping table format ---
echo "EIID mapping table format:"

count=$(grep -c "| Node | Layer | Evolution | Metric" reference/claude-md-template.md 2>/dev/null)
check "template has EIID mapping table header" "$( [ "$count" -gt 0 ] && echo 0 || echo 1 )"

count=$(grep -c "Graduation" reference/claude-md-template.md 2>/dev/null)
check "template table includes Graduation column" "$( [ "$count" -gt 0 ] && echo 0 || echo 1 )"

count=$(grep -c "Loop" reference/claude-md-template.md 2>/dev/null)
check "template table includes Loop column" "$( [ "$count" -gt 0 ] && echo 0 || echo 1 )"

echo ""

# --- Plugin naming ---
echo "Plugin naming:"

name=$(grep '"name"' .claude-plugin/plugin.json 2>/dev/null | head -1)
check "plugin.json name is 'eiid'" "$( echo "$name" | grep -q '"eiid"' && echo 0 || echo 1 )"

repo=$(grep '"repository"' .claude-plugin/plugin.json 2>/dev/null)
check "plugin.json repo points to Play-New/EIID" "$( echo "$repo" | grep -q 'Play-New/EIID' && echo 0 || echo 1 )"

url=$(grep '"url"' .claude-plugin/marketplace.json 2>/dev/null | grep -v "github.com/Play-New\"")
check "marketplace.json source URL points to EIID" "$( echo "$url" | grep -q 'Play-New/EIID' && echo 0 || echo 1 )"

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
