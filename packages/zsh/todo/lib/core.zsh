# core.zsh — NDJSON CRUD操作

# タスク追加
_todo_add() {
  local secret=false

  # オプション解析
  while [[ $# -gt 0 ]]; do
    case "$1" in
      -s|--secret) secret=true; shift ;;
      *) break ;;
    esac
  done

  local raw="$*"
  if [[ -z "$raw" ]]; then
    echo "error: タスクの内容を入力してください" >&2
    return 1
  fi

  _todo_ensure_dir

  local id=$(_todo_gen_id)
  local seq=$(_todo_next_seq)
  local now=$(_todo_now_iso)

  local task_json
  task_json=$(jq -n -c \
    --arg id "$id" \
    --argjson seq "$seq" \
    --arg raw "$raw" \
    --arg now "$now" \
    --argjson secret "$secret" \
    '{
      id: $id,
      seq: $seq,
      raw: $raw,
      title: $raw,
      description: null,
      status: "todo",
      priority: "P2",
      project: null,
      tags: [],
      secret: $secret,
      next_action: null,
      due_at: null,
      remind_at: null,
      created_at: $now,
      updated_at: $now,
      posted: {},
      meta: {}
    }')

  echo "$task_json" >> "$TODO_TASKS"
  _todo_log "add: #$seq $id $raw"
  local label="追加"
  [[ "$secret" == true ]] && label="追加(secret)"
  echo "$label: #$seq $raw"
}

# タスク更新（IDでフィールドを上書き）
_todo_update() {
  local target_id="$1"
  shift
  local patch="$1"  # jq filter string

  local resolved_id
  resolved_id=$(_todo_resolve_id "$target_id") || return 1

  local now=$(_todo_now_iso)
  local tmpfile="${TODO_TASKS}.tmp.$$"

  jq -c --arg id "$resolved_id" --arg now "$now" \
    "if .id == \$id then ($patch) | .updated_at = \$now else . end" \
    "$TODO_TASKS" > "$tmpfile" 2>/dev/null

  if [[ $? -ne 0 ]]; then
    rm -f "$tmpfile"
    echo "error: タスクの更新に失敗しました" >&2
    return 1
  fi

  mv "$tmpfile" "$TODO_TASKS"
  _todo_log "update: $resolved_id"
}

# タスク完了
_todo_done() {
  if [[ $# -eq 0 ]]; then
    echo "error: 完了するタスクのIDを指定してください" >&2
    return 1
  fi

  local id
  for id in "$@"; do
    local resolved_id
    resolved_id=$(_todo_resolve_id "$id") || continue

    local now=$(_todo_now_iso)
    _todo_update "$resolved_id" ".status = \"done\" | .done_at = \"$now\""
    if [[ $? -eq 0 ]]; then
      local info
      info=$(jq -r --arg id "$resolved_id" 'select(.id == $id) | "#\(.seq // "?") \(.title)"' "$TODO_TASKS" 2>/dev/null)
      echo "完了: $info"
    fi
  done
}

# タスク一覧取得（jqフィルタを返す）
_todo_list() {
  local show_all=false
  local project=""
  local tag=""

  while [[ $# -gt 0 ]]; do
    case "$1" in
      --all|-a)   show_all=true; shift ;;
      --project)  project="$2"; shift 2 ;;
      --tag)      tag="$2"; shift 2 ;;
      *)          shift ;;
    esac
  done

  if [[ ! -f "$TODO_TASKS" ]] || [[ ! -s "$TODO_TASKS" ]]; then
    return 0
  fi

  local filter="."
  if [[ "$show_all" == false ]]; then
    filter='select(.status != "done" and .status != "dropped")'
  fi
  if [[ -n "$project" ]]; then
    filter="$filter | select(.project == \"$project\")"
  fi
  if [[ -n "$tag" ]]; then
    filter="$filter | select(.tags | index(\"$tag\"))"
  fi

  jq -c "$filter" "$TODO_TASKS" 2>/dev/null
}

# IDでタスクを1件取得
_todo_get() {
  local target_id="$1"
  local resolved_id
  resolved_id=$(_todo_resolve_id "$target_id") || return 1
  jq -c --arg id "$resolved_id" 'select(.id == $id)' "$TODO_TASKS" 2>/dev/null
}

# 今日やるべきタスクをスコア順で取得
_todo_now_tasks() {
  if [[ ! -f "$TODO_TASKS" ]] || [[ ! -s "$TODO_TASKS" ]]; then
    return 0
  fi

  local today=$(_todo_today)
  local max_items=${1:-10}

  jq -c --arg today "$today" '
    select(.status == "todo" or .status == "doing") |
    . + {
      _score: (
        (if .status == "doing" then 100 else 0 end) +
        (if .due_at and .due_at != null and (.due_at[0:10] <= $today) then 200 else 0 end) +
        (if .remind_at and .remind_at != null and (.remind_at[0:10] <= $today) then 50 else 0 end) +
        (if .priority == "P0" then 30 elif .priority == "P1" then 20 else 10 end)
      )
    }
  ' "$TODO_TASKS" 2>/dev/null \
    | jq -s -c 'sort_by(-._score) | .[0:'"$max_items"'] | .[] | del(._score)'
}

# スヌーズ
_todo_snooze() {
  local target_id="$1"
  local duration="$2"

  if [[ -z "$target_id" ]]; then
    echo "error: IDを指定してください" >&2
    echo "usage: t snooze <id> <duration>  (例: 2h, 3d, 1w)" >&2
    return 1
  fi
  if [[ -z "$duration" ]]; then
    echo "error: durationを指定してください（例: 2h, 3d, 1w）" >&2
    return 1
  fi

  local remind_at
  remind_at=$(_todo_parse_duration "$duration") || return 1

  local resolved_id
  resolved_id=$(_todo_resolve_id "$target_id") || return 1

  _todo_update "$resolved_id" ".status = \"snooze\" | .remind_at = \"$remind_at\""
  if [[ $? -eq 0 ]]; then
    local info
    info=$(jq -r --arg id "$resolved_id" 'select(.id == $id) | "#\(.seq // "?") \(.title)"' "$TODO_TASKS" 2>/dev/null)
    echo "スヌーズ: $info → ${remind_at:0:10}"
  fi
}

# 外部出力用タスク一覧（secret タスクを除外）
_todo_list_public() {
  _todo_list "$@" | jq -c 'select(.secret != true)'
}

# 外部出力用 now タスク（secret タスクを除外）
_todo_now_tasks_public() {
  _todo_now_tasks "$@" | jq -c 'select(.secret != true)'
}

# タスク編集（$EDITORで開く）
_todo_edit() {
  local target_id="$1"
  local resolved_id
  resolved_id=$(_todo_resolve_id "$target_id") || return 1

  local task_json
  task_json=$(_todo_get "$resolved_id")
  if [[ -z "$task_json" ]]; then
    echo "error: タスクが見つかりません" >&2
    return 1
  fi

  local tmpfile=$(mktemp /tmp/todo_edit.XXXXXX.json)
  echo "$task_json" | jq '.' > "$tmpfile"

  ${EDITOR:-nvim} "$tmpfile"

  if ! jq '.' "$tmpfile" &>/dev/null; then
    echo "error: JSONが不正です。変更を破棄しました。" >&2
    rm -f "$tmpfile"
    return 1
  fi

  local edited
  edited=$(jq -c '.' "$tmpfile")
  rm -f "$tmpfile"

  local now=$(_todo_now_iso)
  local new_tmpfile="${TODO_TASKS}.tmp.$$"

  jq -c --arg id "$resolved_id" --arg now "$now" --argjson edited "$edited" \
    'if .id == $id then $edited | .updated_at = $now else . end' \
    "$TODO_TASKS" > "$new_tmpfile" 2>/dev/null

  mv "$new_tmpfile" "$TODO_TASKS"
  local edit_info
  edit_info=$(jq -r --arg id "$resolved_id" 'select(.id == $id) | "#\(.seq // "?")"' "$TODO_TASKS" 2>/dev/null)
  _todo_log "edit: $resolved_id"
  echo "更新: $edit_info"
}

# Next Action 設定
_todo_na() {
  local target_id="$1"
  if [[ -z "$target_id" ]]; then
    echo "error: IDを指定してください" >&2
    echo "usage: t na <id> [text]  (text省略で解除)" >&2
    return 1
  fi
  shift

  local text="$*"
  local resolved_id
  resolved_id=$(_todo_resolve_id "$target_id") || return 1

  if [[ -z "$text" ]]; then
    _todo_update "$resolved_id" '.next_action = null'
  else
    _todo_update "$resolved_id" ".next_action = \"$text\""
  fi

  if [[ $? -eq 0 ]]; then
    local info
    info=$(jq -r --arg id "$resolved_id" 'select(.id == $id) | "#\(.seq // "?") \(.title)"' "$TODO_TASKS" 2>/dev/null)
    if [[ -z "$text" ]]; then
      echo "NA解除: $info"
    else
      echo "NA設定: $info → $text"
    fi
  fi
}
