#!/bin/bash

# Orchestrator Stop Hook
# Prevents session exit when an orchestrator loop is active
# Supports two loops: design_review and implementation
# Feeds the orchestrator prompt back as input to continue the loop

set -euo pipefail

# Read hook input from stdin (advanced stop hook API)
HOOK_INPUT=$(cat)

# Check if orchestrator loop is active
ORCHESTRATOR_STATE_FILE=".claude/orchestrator-loop.local.md"

if [[ ! -f "$ORCHESTRATOR_STATE_FILE" ]]; then
  # No active loop - allow exit
  exit 0
fi

# Parse markdown frontmatter (YAML between ---) and extract values
FRONTMATTER=$(sed -n '/^---$/,/^---$/{ /^---$/d; p; }' "$ORCHESTRATOR_STATE_FILE")
ACTIVE=$(echo "$FRONTMATTER" | grep '^active:' | sed 's/active: *//')
ITERATION=$(echo "$FRONTMATTER" | grep '^iteration:' | sed 's/iteration: *//')
MAX_ITERATIONS=$(echo "$FRONTMATTER" | grep '^max_iterations:' | sed 's/max_iterations: *//')
CURRENT_LOOP=$(echo "$FRONTMATTER" | grep '^current_loop:' | sed 's/current_loop: *//' | sed 's/^"\(.*\)"$/\1/')
PROMISE=$(echo "$FRONTMATTER" | grep '^promise:' | sed 's/promise: *//' | sed 's/^"\(.*\)"$/\1/')

# Check if loop is inactive
if [[ "$ACTIVE" != "true" ]]; then
  exit 0
fi

# Validate numeric fields
if [[ ! "$ITERATION" =~ ^[0-9]+$ ]]; then
  echo "Warning: Orchestrator loop state file corrupted (invalid iteration: '$ITERATION')" >&2
  rm "$ORCHESTRATOR_STATE_FILE"
  exit 0
fi

if [[ ! "$MAX_ITERATIONS" =~ ^[0-9]+$ ]]; then
  echo "Warning: Orchestrator loop state file corrupted (invalid max_iterations: '$MAX_ITERATIONS')" >&2
  rm "$ORCHESTRATOR_STATE_FILE"
  exit 0
fi

# Check if max iterations reached
if [[ $MAX_ITERATIONS -gt 0 ]] && [[ $ITERATION -ge $MAX_ITERATIONS ]]; then
  echo "Orchestrator loop: Max iterations ($MAX_ITERATIONS) reached."
  rm "$ORCHESTRATOR_STATE_FILE"
  exit 0
fi

# Get transcript path from hook input
TRANSCRIPT_PATH=$(echo "$HOOK_INPUT" | jq -r '.transcript_path')

if [[ ! -f "$TRANSCRIPT_PATH" ]]; then
  echo "Warning: Orchestrator loop: Transcript file not found" >&2
  rm "$ORCHESTRATOR_STATE_FILE"
  exit 0
fi

# Read last assistant message from transcript (JSONL format)
if ! grep -q '"role":"assistant"' "$TRANSCRIPT_PATH"; then
  echo "Warning: Orchestrator loop: No assistant messages found in transcript" >&2
  rm "$ORCHESTRATOR_STATE_FILE"
  exit 0
fi

LAST_LINE=$(grep '"role":"assistant"' "$TRANSCRIPT_PATH" | tail -1)
if [[ -z "$LAST_LINE" ]]; then
  echo "Warning: Orchestrator loop: Failed to extract last assistant message" >&2
  rm "$ORCHESTRATOR_STATE_FILE"
  exit 0
fi

LAST_OUTPUT=$(echo "$LAST_LINE" | jq -r '
  .message.content |
  map(select(.type == "text")) |
  map(.text) |
  join("\n")
' 2>&1)

if [[ $? -ne 0 ]] || [[ -z "$LAST_OUTPUT" ]]; then
  echo "Warning: Orchestrator loop: Failed to parse assistant message" >&2
  rm "$ORCHESTRATOR_STATE_FILE"
  exit 0
fi

# Check for completion promises
PROMISE_TEXT=$(echo "$LAST_OUTPUT" | perl -0777 -pe 's/.*?<promise>(.*?)<\/promise>.*/\1/s; s/^\s+|\s+$//g; s/\s+/ /g' 2>/dev/null || echo "")

# Check if the promise matches the expected completion promise
if [[ -n "$PROMISE_TEXT" ]] && [[ "$PROMISE_TEXT" = "$PROMISE" ]]; then
  if [[ "$CURRENT_LOOP" == "design_review" ]]; then
    echo "Orchestrator: Design review complete - <promise>$PROMISE</promise>"
    echo "Waiting for human approval. Say 'approved' to generate subtasks."
    # Update loop state to waiting_approval
    TEMP_FILE="${ORCHESTRATOR_STATE_FILE}.tmp.$$"
    sed "s/^current_loop: .*/current_loop: \"waiting_approval\"/" "$ORCHESTRATOR_STATE_FILE" > "$TEMP_FILE"
    mv "$TEMP_FILE" "$ORCHESTRATOR_STATE_FILE"
    exit 0
  elif [[ "$CURRENT_LOOP" == "implementation" ]]; then
    echo "Orchestrator: All subtasks complete - <promise>$PROMISE</promise>"
    rm "$ORCHESTRATOR_STATE_FILE"
    exit 0
  fi
fi

# Handle waiting_approval state - check if human said "approved"
if [[ "$CURRENT_LOOP" == "waiting_approval" ]]; then
  # Look for "approved" in user messages
  if grep -q '"role":"user"' "$TRANSCRIPT_PATH"; then
    LAST_USER=$(grep '"role":"user"' "$TRANSCRIPT_PATH" | tail -1)
    USER_TEXT=$(echo "$LAST_USER" | jq -r '
      .message.content |
      if type == "array" then
        map(select(.type == "text")) | map(.text) | join("\n")
      elif type == "string" then
        .
      else
        ""
      end
    ' 2>/dev/null || echo "")

    if echo "$USER_TEXT" | grep -iq "approved"; then
      echo "Orchestrator: Human approved. Generating subtasks..."
      # Transition to subtask generation (orchestrator will handle this)
      TEMP_FILE="${ORCHESTRATOR_STATE_FILE}.tmp.$$"
      sed "s/^current_loop: .*/current_loop: \"generating_subtasks\"/" "$ORCHESTRATOR_STATE_FILE" > "$TEMP_FILE"
      mv "$TEMP_FILE" "$ORCHESTRATOR_STATE_FILE"
    fi
  fi
fi

# Not complete - continue loop with SAME PROMPT
NEXT_ITERATION=$((ITERATION + 1))

# Extract prompt (everything after the closing ---)
PROMPT_TEXT=$(awk '/^---$/{i++; next} i>=2' "$ORCHESTRATOR_STATE_FILE")

if [[ -z "$PROMPT_TEXT" ]]; then
  echo "Warning: Orchestrator loop state file corrupted (no prompt text)" >&2
  rm "$ORCHESTRATOR_STATE_FILE"
  exit 0
fi

# Update iteration in frontmatter
TEMP_FILE="${ORCHESTRATOR_STATE_FILE}.tmp.$$"
sed "s/^iteration: .*/iteration: $NEXT_ITERATION/" "$ORCHESTRATOR_STATE_FILE" > "$TEMP_FILE"
mv "$TEMP_FILE" "$ORCHESTRATOR_STATE_FILE"

# Build system message with iteration count and current loop info
case "$CURRENT_LOOP" in
  "design_review")
    SYSTEM_MSG="Orchestrator iteration $NEXT_ITERATION [Design Review] | Complete: <promise>$PROMISE</promise>"
    ;;
  "implementation")
    SYSTEM_MSG="Orchestrator iteration $NEXT_ITERATION [Implementation] | Complete: <promise>$PROMISE</promise>"
    ;;
  "waiting_approval")
    SYSTEM_MSG="Orchestrator iteration $NEXT_ITERATION [Waiting for Approval] | Say 'approved' to proceed"
    ;;
  "generating_subtasks")
    SYSTEM_MSG="Orchestrator iteration $NEXT_ITERATION [Generating Subtasks] | Generate XML files and batch plan"
    ;;
  *)
    SYSTEM_MSG="Orchestrator iteration $NEXT_ITERATION"
    ;;
esac

# Output JSON to block the stop and feed prompt back
jq -n \
  --arg prompt "$PROMPT_TEXT" \
  --arg msg "$SYSTEM_MSG" \
  '{
    "decision": "block",
    "reason": $prompt,
    "systemMessage": $msg
  }'

exit 0
