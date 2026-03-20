#!/bin/bash
# FLOW Telemetry — logs /flow-* skill invocations
# Hook: UserPromptSubmit — fires when user submits any prompt
# Writes per-user-per-device log files to avoid git merge conflicts
#
# Log format: TIMESTAMP | /skill-name | user@email | device-name | OS | project
# File pattern: .flow/telemetry/{email}__{device}.log

INPUT=$(cat)
PROMPT=$(echo "$INPUT" | jq -r '.prompt // empty' 2>/dev/null)

# Only log /flow* commands
if echo "$PROMPT" | grep -qE '^/flow'; then
  SKILL=$(echo "$PROMPT" | sed 's/ .*//' | head -1)
  TIMESTAMP=$(date '+%Y-%m-%d %H:%M')
  CWD=$(echo "$INPUT" | jq -r '.cwd // empty' 2>/dev/null)
  PROJECT=$(basename "$CWD" 2>/dev/null)

  # User identity
  USER_EMAIL=$(cd "$CWD" 2>/dev/null && git config user.email 2>/dev/null || echo "unknown")

  # Device identity
  DEVICE_NAME=$(hostname -s 2>/dev/null || echo "unknown")
  OS_TYPE=$(uname -s 2>/dev/null || echo "unknown")

  # Sanitize for filename: @ → _at_ , . → _
  SAFE_EMAIL=$(echo "$USER_EMAIL" | sed 's/@/_at_/g; s/\./_/g')
  LOG_ID="${SAFE_EMAIL}__${DEVICE_NAME}"

  # Write to project-level telemetry (per-user-per-device file)
  if [ -d "$CWD/.flow" ]; then
    mkdir -p "$CWD/.flow/telemetry"
    echo "$TIMESTAMP | $SKILL | $USER_EMAIL | $DEVICE_NAME | $OS_TYPE | $PROJECT" >> "$CWD/.flow/telemetry/$LOG_ID.log"
  fi
fi

exit 0
