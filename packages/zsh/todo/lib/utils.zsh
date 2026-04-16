# utils.zsh — ID生成、日付ユーティリティ

typeset -g TODO_DIR="${HOME}/.todo"
typeset -g TODO_TASKS="${TODO_DIR}/tasks.ndjson"
typeset -g TODO_OUTBOX="${TODO_DIR}/outbox.ndjson"
typeset -g TODO_CONFIG="${TODO_DIR}/config.json"
typeset -g TODO_STATE="${TODO_DIR}/state.json"
typeset -g TODO_LOG="${TODO_DIR}/logs/todo.log"

_todo_ensure_dir() {
  [[ -d "$TODO_DIR" ]] && return
  mkdir -p "$TODO_DIR/logs"
  touch "$TODO_TASKS"
  touch "$TODO_OUTBOX"
  echo '{}' > "$TODO_STATE"
}

_todo_check_deps() {
  if ! command -v jq &>/dev/null; then
    echo "error: jq が必要です。brew install jq でインストールしてください。" >&2
    return 1
  fi
}

# ランダム(hex 8桁) + epoch秒(hex 8桁) = 16文字
# ランダムが先頭なので短縮ID(7文字)の一意性が高い
# 時系列ソートは created_at フィールドで行う
_todo_gen_id() {
  local rand=$(od -An -tx1 -N4 /dev/urandom | tr -d ' \n')
  local ts=$(printf '%08x' $(date +%s))
  echo "${rand}${ts}"
}

_todo_now_iso() {
  date -u +"%Y-%m-%dT%H:%M:%SZ"
}

_todo_today() {
  date +"%Y-%m-%d"
}

_todo_log() {
  local msg="$1"
  echo "[$(date +"%Y-%m-%dT%H:%M:%S")] $msg" >> "$TODO_LOG"
}

# 次の連番を取得
_todo_next_seq() {
  if [[ ! -f "$TODO_TASKS" ]] || [[ ! -s "$TODO_TASKS" ]]; then
    echo 1
    return
  fi
  local max_seq
  max_seq=$(jq -r '.seq // 0' "$TODO_TASKS" 2>/dev/null | sort -n | tail -1)
  echo $(( ${max_seq:-0} + 1 ))
}

# ID解決（数値→seq検索、それ以外→hex ID前方一致）
_todo_resolve_id() {
  local partial="$1"
  if [[ -z "$partial" ]]; then
    echo "error: IDを指定してください" >&2
    return 1
  fi

  local matches

  # 数値の場合はseqで検索
  if [[ "$partial" =~ ^[0-9]+$ ]]; then
    matches=$(jq -r --argjson s "$partial" 'select(.seq == $s) | .id' "$TODO_TASKS" 2>/dev/null)
    if [[ -z "$matches" ]]; then
      echo "error: #$partial に一致するタスクがありません" >&2
      return 1
    fi
    echo "$matches"
    return 0
  fi

  # hex IDの前方一致で検索
  matches=$(jq -r --arg p "$partial" 'select(.id | startswith($p)) | .id' "$TODO_TASKS" 2>/dev/null)
  local count=$(echo "$matches" | grep -c .)
  if [[ $count -eq 0 ]]; then
    echo "error: ID '$partial' に一致するタスクがありません" >&2
    return 1
  elif [[ $count -gt 1 ]]; then
    echo "error: ID '$partial' に複数一致します。もう少し長いIDを指定してください:" >&2
    echo "$matches" | head -5 >&2
    return 1
  fi
  echo "$matches"
}

# ID短縮表示（先頭7文字）
_todo_short_id() {
  echo "${1:0:7}"
}

# duration文字列をISO8601日時に変換（現在時刻 + duration）
# 対応: 30m, 2h, 3d, 1w
_todo_parse_duration() {
  local dur="$1"
  local num="${dur%[mhdw]}"
  local unit="${dur##*[0-9]}"

  if [[ -z "$num" || -z "$unit" ]]; then
    echo "error: 不正なduration形式です（例: 2h, 3d, 1w）" >&2
    return 1
  fi

  local seconds=0
  case "$unit" in
    m) seconds=$((num * 60)) ;;
    h) seconds=$((num * 3600)) ;;
    d) seconds=$((num * 86400)) ;;
    w) seconds=$((num * 604800)) ;;
    *)
      echo "error: 不正な単位 '$unit'（m/h/d/w）" >&2
      return 1
      ;;
  esac

  local future=$(( $(date +%s) + seconds ))
  date -u -r "$future" +"%Y-%m-%dT%H:%M:%SZ"
}
