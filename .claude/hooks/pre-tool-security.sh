#!/bin/bash
# .claude/hooks/pre-tool-security.sh
# Blocca comandi shell potenzialmente distruttivi.

INPUT=$(cat)
COMMAND=$(echo "$INPUT" | jq -r '.tool_input.command // ""')

BLOCKED_PATTERNS=(
  "rm -rf /"
  "rm -rf ~"
  "rm -rf \$HOME"
  "> /dev/sda"
  "mkfs"
  "dd if=/dev/zero"
  "chmod -R 777 /"
  "git push --force origin main"
  "git push --force origin master"
  "DROP TABLE"
  "DROP DATABASE"
)

for pattern in "${BLOCKED_PATTERNS[@]}"; do
  if echo "$COMMAND" | grep -qF "$pattern"; then
    jq -n \
      --arg reason "Comando bloccato dal security gate: pattern '$pattern' rilevato." \
      '{
        hookSpecificOutput: {
          hookEventName: "PreToolUse",
          permissionDecision: "deny",
          permissionDecisionReason: $reason
        }
      }'
    exit 0
  fi
done

exit 0
