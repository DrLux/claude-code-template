#!/bin/bash
# .claude/hooks/post-tool-lint.sh
# Runs ruff and mypy on every Python file written by Claude.

INPUT=$(cat)
FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // .tool_input.path // ""')

if [[ "$FILE_PATH" != *.py ]]; then
  exit 0
fi

if [ ! -f "$FILE_PATH" ]; then
  exit 0
fi

cd "$CLAUDE_PROJECT_DIR"

ERRORS=""

RUFF_OUT=$(uv run ruff check --fix "$FILE_PATH" 2>&1)
if [ $? -ne 0 ]; then
  ERRORS="$ERRORS\n[ruff] $RUFF_OUT"
fi

uv run ruff format "$FILE_PATH" 2>/dev/null

MYPY_OUT=$(uv run mypy "$FILE_PATH" --ignore-missing-imports --no-error-summary 2>&1)
if [ $? -ne 0 ]; then
  ERRORS="$ERRORS\n[mypy] $MYPY_OUT"
fi

if [ -n "$ERRORS" ]; then
  jq -n --arg ctx "$(echo -e "$ERRORS")" \
    '{
      hookSpecificOutput: {
        hookEventName: "PostToolUse",
        additionalContext: $ctx
      }
    }'
fi

exit 0
