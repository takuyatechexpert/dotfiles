#!/bin/bash
# PostToolUse hook for Read tool
# Only logs reads of knowledge files from ~/dotlogs/knowledge/
FILE_PATH=$(echo "$CLAUDE_TOOL_INPUT" | /opt/homebrew/bin/jq -r '.file_path // ""')
if [[ "$FILE_PATH" == *"dotlogs/knowledge/"* ]]; then
  BASENAME=$(basename "$FILE_PATH")
  mkdir -p ~/.claude/logs
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] [KNOWLEDGE] READ ${BASENAME}" >> ~/.claude/logs/knowledge.log
fi
