#!/bin/bash
# Phase A PostToolUse hook — appends a machine-readable event when a Notion page
# status is changed. Feeds the event-log schema (see .claude/procedures/event-log.md).
# Fires on any notion-update-page with a Status select change.
# Silently exits when Status is absent or JSON parsing fails (fail open).

set +e

INPUT=$(cat 2>/dev/null)
if [ -z "$INPUT" ]; then
  exit 0
fi

EXTRACTED=$(printf '%s' "$INPUT" | python -c "
import sys, json
try:
    d = json.load(sys.stdin)
    ti = d.get('tool_input', {}) or {}
    print(ti.get('page_id', '') or '')
    props = ti.get('properties', {}) or {}
    status = (props.get('Status', {}) or {}).get('select', {}) or {}
    print(status.get('name', '') or '')
except Exception:
    print('')
    print('')
" 2>/dev/null)

PAGE_ID=$(printf '%s\n' "$EXTRACTED" | sed -n '1p')
STATUS=$(printf '%s\n' "$EXTRACTED" | sed -n '2p')

if [ -z "$STATUS" ] || [ -z "$PAGE_ID" ]; then
  exit 0
fi

CHANGELOG="$CLAUDE_PROJECT_DIR/outputs/change-log.md"
if [ ! -f "$CHANGELOG" ]; then
  exit 0
fi

SHORT_ID=$(printf '%s' "$PAGE_ID" | tr -d -)
SHORT_ID=${SHORT_ID:0:13}
TS=$(date +%Y-%m-%dT%H:%M)

if ! grep -q "^### Hook events" "$CHANGELOG"; then
  printf "\n### Hook events\n" >> "$CHANGELOG"
fi
printf "[EVENT: STATUS_CHANGE page=%s status=%s ts=%s]\n" "$SHORT_ID" "$STATUS" "$TS" >> "$CHANGELOG"
exit 0
