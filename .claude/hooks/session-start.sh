#!/bin/bash
# .claude/hooks/session-start.sh
# Inietta il contesto dinamico di progetto all'avvio della sessione.
# CLAUDE.md, CLAUDE.local.md e rules/ sono caricati nativamente da Claude Code.
# Qui carichiamo solo .claudememory che non ha caricamento nativo.

MEMORY_FILE="$CLAUDE_PROJECT_DIR/.claudememory"

if [ -f "$MEMORY_FILE" ]; then
  echo "=== PROJECT MEMORY (da .claudememory) ==="
  cat "$MEMORY_FILE"
  echo "========================================="
else
  echo "Nessun file .claudememory trovato."
fi

echo ""
echo "=== GIT STATUS ==="
git -C "$CLAUDE_PROJECT_DIR" log --oneline -5 2>/dev/null || echo "Nessuna commit history"
git -C "$CLAUDE_PROJECT_DIR" status --short 2>/dev/null
echo "=================="
