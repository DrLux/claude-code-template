#!/bin/bash
# .claude/hooks/stop-quality-gate.sh
# Runs pytest before Claude finishes.
# CRITICAL: checks stop_hook_active to prevent infinite loops.

INPUT=$(cat)

if [ "$(echo "$INPUT" | jq -r '.stop_hook_active // false')" = "true" ]; then
  echo "Quality gate: second attempt, releasing control."
  exit 0
fi

cd "$CLAUDE_PROJECT_DIR"

if [ ! -d "tests" ] && ! find . -name "test_*.py" -maxdepth 3 | grep -q .; then
  exit 0
fi

echo "Running pytest..."
PYTEST_OUT=$(uv run pytest --tb=short -q 2>&1)
PYTEST_EXIT=$?

if [ $PYTEST_EXIT -ne 0 ]; then
  echo "═══════════════════════════════════════"
  echo "QUALITY GATE: TESTS FAILED"
  echo "═══════════════════════════════════════"
  echo "$PYTEST_OUT"
  echo ""
  echo "Claude must fix the failing tests before finishing."
  echo "═══════════════════════════════════════"
  exit 2
fi

echo "All tests pass ($(echo "$PYTEST_OUT" | grep -oP '\d+ passed'))"
exit 0
