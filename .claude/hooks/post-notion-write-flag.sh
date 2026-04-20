#!/bin/bash
# Phase A PostToolUse hook — touches a flag file when a Notion write happens.
# Paired with stop-changelog-guard.sh to surface missing change-log entries at session end.
# Fails open: any error silently exits 0 so normal operation is never blocked.

touch /tmp/claude-notion-write.flag 2>/dev/null || true
exit 0
