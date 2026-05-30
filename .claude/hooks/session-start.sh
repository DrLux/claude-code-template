#!/bin/bash
# .claude/hooks/session-start.sh
# Injects dynamic project context at session start.
# CLAUDE.md, CLAUDE.local.md and rules/ are loaded natively by Claude Code.
# Here we only load .claudememory which has no native loading.

MEMORY_FILE="$CLAUDE_PROJECT_DIR/.claudememory"

if [ -f "$MEMORY_FILE" ]; then
  echo "=== PROJECT MEMORY (from .claudememory) ==="
  cat "$MEMORY_FILE"
  echo "============================================"
else
  echo "No .claudememory file found."
fi

echo ""
echo "=== GIT STATUS ==="
git -C "$CLAUDE_PROJECT_DIR" log --oneline -5 2>/dev/null || echo "No commit history"
git -C "$CLAUDE_PROJECT_DIR" status --short 2>/dev/null
echo "=================="
