#!/bin/bash
# PostCompact hook: ログ記録 + 自動圧縮時の警告表示
# stdin: JSON {trigger: "manual|auto", compact_summary: "..."}

INPUT=$(cat)
TRIGGER=$(echo "$INPUT" | /opt/homebrew/bin/jq -r '.trigger // ""')
SUMMARY=$(echo "$INPUT" | /opt/homebrew/bin/jq -r '.compact_summary // ""')
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

# ログ記録（既存の動作を維持）
mkdir -p ~/.claude/logs
echo "[$TIMESTAMP] [POST_COMPACT] trigger:$TRIGGER | $SUMMARY" >> ~/.claude/logs/sessions.log

# 自動圧縮の場合に警告を stdout に出力
if [ "$TRIGGER" = "auto" ]; then
  echo ""
  echo "--- CONTEXT ROT WARNING ---"
  echo "自動圧縮が実行されました。会話の細かい文脈が失われた可能性があります。"
  echo "次回からは 65% 付近で /handover を実行し、セッション切り替えを検討してください。"
  echo "---"
  echo ""
fi
