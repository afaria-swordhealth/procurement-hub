#!/bin/bash
# Phase A Stop hook — advisory (non-blocking).
# If Notion writes happened this session but change-log.md was not updated,
# emit an additionalContext reminder. Does NOT block session stop.
# Promotion to blocking is Phase B after observation.

FLAG=/tmp/claude-notion-write.flag
CHANGELOG="$CLAUDE_PROJECT_DIR/outputs/change-log.md"

if [ ! -f "$FLAG" ]; then
  exit 0
fi

if [ -f "$CHANGELOG" ] && [ "$CHANGELOG" -nt "$FLAG" ]; then
  rm -f "$FLAG"
  exit 0
fi

rm -f "$FLAG"

echo '{"hookSpecificOutput": {"hookEventName": "Stop", "additionalContext": "REMINDER: Notion writes happened this session but outputs/change-log.md was not updated. Add an entry before wrap-up so nothing is lost."}}'
exit 0
