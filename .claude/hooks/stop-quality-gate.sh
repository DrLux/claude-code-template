#!/bin/bash
# .claude/hooks/stop-quality-gate.sh
# Esegue pytest prima che Claude concluda.
# CRITICO: controlla stop_hook_active per prevenire loop infiniti.

INPUT=$(cat)

if [ "$(echo "$INPUT" | jq -r '.stop_hook_active // false')" = "true" ]; then
  echo "Quality gate: secondo tentativo, rilascio il controllo."
  exit 0
fi

cd "$CLAUDE_PROJECT_DIR"

if [ ! -d "tests" ] && ! find . -name "test_*.py" -maxdepth 3 | grep -q .; then
  exit 0
fi

echo "Esecuzione pytest..."
PYTEST_OUT=$(uv run pytest --tb=short -q 2>&1)
PYTEST_EXIT=$?

if [ $PYTEST_EXIT -ne 0 ]; then
  echo "═══════════════════════════════════════"
  echo "QUALITY GATE: TEST FALLITI"
  echo "═══════════════════════════════════════"
  echo "$PYTEST_OUT"
  echo ""
  echo "Claude deve correggere i test prima di concludere."
  echo "═══════════════════════════════════════"
  exit 2
fi

echo "Tutti i test passano ($(echo "$PYTEST_OUT" | grep -oP '\d+ passed'))"
exit 0
