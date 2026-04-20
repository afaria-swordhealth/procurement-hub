#!/bin/bash
# Phase A SessionStart hook — injects runtime context so Claude does not re-derive.
# Kills 3-4 re-derivations per session (date, week, active project).
# Additive to existing SessionStart hooks; multiple additionalContext strings merge.

set -e

TODAY=$(date +%Y-%m-%d)
WEEK_ISO=$(date +%G-W%V)

ACTIVE_PROJECT=""
if [ -d "$CLAUDE_PROJECT_DIR/context" ]; then
  MOST_RECENT=$(ls -t "$CLAUDE_PROJECT_DIR"/context/*/suppliers.md 2>/dev/null | head -1)
  if [ -n "$MOST_RECENT" ]; then
    ACTIVE_PROJECT=$(basename "$(dirname "$MOST_RECENT")")
  fi
fi

CONTEXT="Session env: CURRENT_DATE=${TODAY} CURRENT_WEEK_ISO=${WEEK_ISO} ACTIVE_PROJECT=${ACTIVE_PROJECT:-unknown}"

printf '{"hookSpecificOutput":{"hookEventName":"SessionStart","additionalContext":"%s"}}\n' "$CONTEXT"
