#!/bin/bash
# .claude/hooks/pre-tool-security.sh
# Blocks potentially destructive shell commands.

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
      --arg reason "Command blocked by security gate: pattern '$pattern' detected." \
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
