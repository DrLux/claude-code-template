#!/bin/bash
# .claude/hooks/post-batch-check.sh
# Dopo un batch di scritture, verifica la coerenza degli import.

cd "$CLAUDE_PROJECT_DIR"

CHANGED_FILES=$(git diff --name-only HEAD 2>/dev/null | grep '\.py$')

if [ -z "$CHANGED_FILES" ]; then
  exit 0
fi

MYPY_OUT=$(uv run mypy src/ --ignore-missing-imports --no-error-summary 2>&1 | grep "error:" | head -20)

if [ -n "$MYPY_OUT" ]; then
  jq -n --arg ctx "Errori mypy cross-file dopo il batch:\n$MYPY_OUT" \
    '{
      hookSpecificOutput: {
        hookEventName: "PostToolBatch",
        additionalContext: $ctx
      }
    }'
fi

exit 0
