#!/bin/bash
# stdin のテキストからシークレットと思われる値をマスクして stdout に出力
# 用途: フックの jq 出力をパイプして使う
#
# 適用順序が重要: キー名ベースのルールを先に、値ベースのルールを後に

sed -E \
  -e 's/(api[_-]?key|apikey|access[_-]?token|secret[_-]?key)("?)[[:space:]]*[:=][[:space:]]*"?[A-Za-z0-9._-]{8,}/\1\2=[MASKED]/g' \
  -e 's/(password|passwd|pwd)("?)[[:space:]]*[:=][[:space:]]*"?[^[:space:]"'\'',}{]{3,}/\1\2=[MASKED]/gi' \
  -e 's/Bearer [A-Za-z0-9._-]{10,}/Bearer [MASKED]/g' \
  -e 's/Authorization:[[:space:]]*[A-Za-z0-9._-]{10,}/Authorization: [MASKED]/g' \
  -e 's/eyJ[A-Za-z0-9_-]{20,}\.[A-Za-z0-9_-]{20,}\.[A-Za-z0-9_-]{20,}/[MASKED_JWT]/g' \
  -e 's/(^|[[:space:]",:={}(])(sk_live_|sk_test_|sk-)[A-Za-z0-9_-]{10,}/\1\2[MASKED]/g' \
  -e 's/([?&](token|key|secret|api_key|access_token|auth)=)[^&"[:space:]]{8,}/\1[MASKED]/g'
