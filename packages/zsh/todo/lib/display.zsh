# display.zsh — 表示・フォーマット

# ステータス表示用アイコン
_todo_status_icon() {
  case "$1" in
    todo)    echo "[ ]" ;;
    doing)   echo "[>]" ;;
    done)    echo "[x]" ;;
    snooze)  echo "[z]" ;;
    dropped) echo "[-]" ;;
    *)       echo "[?]" ;;
  esac
}

# タスク一覧をテーブル表示
_todo_display_list() {
  local tasks="$1"

  if [[ -z "$tasks" ]]; then
    echo "タスクがありません"
    return 0
  fi

  local reset="\033[0m"
  local dim="\033[2m"
  local red="\033[31m"
  local yellow="\033[33m"
  local blue="\033[34m"

  # ヘッダー
  printf "${dim}%-5s %-5s %-4s %-3s %-10s %s${reset}\n" "#" "ST" "PRI" "SEC" "DUE" "TITLE"
  printf "${dim}%-5s %-5s %-4s %-3s %-10s %s${reset}\n" "-----" "-----" "----" "---" "----------" "-----"

  # jqで一括整形して1行ずつ区切り文字(␟)で出力
  local formatted
  formatted=$(printf '%s\n' "$tasks" | jq -r '[
    (.seq // 0 | tostring),
    (.status // "todo"),
    (.priority // "P2"),
    (if .due_at and .due_at != null then .due_at[0:10] else "" end),
    (.title // .raw // ""),
    (if .secret == true then "s" else "" end),
    (.next_action // "")
  ] | join("\u001f")')

  echo "$formatted" | while IFS=$'\x1f' read -r seq st pri due title secret next_action; do
    [[ -z "$seq" ]] && continue

    local icon=""
    local color=""
    case "$st" in
      todo)    icon="[ ]" ;;
      doing)   icon="[>]" ;;
      done)    icon="[x]" ;;
      snooze)  icon="[z]" ;;
      dropped) icon="[-]" ;;
      *)       icon="[?]" ;;
    esac
    case "$pri" in
      P0) color="$red" ;;
      P1) color="$yellow" ;;
      P2) color="$blue" ;;
      *)  color="$reset" ;;
    esac

    local secret_col=""
    [[ "$secret" == "s" ]] && secret_col="*"

    printf "${color}%-5s ${icon} %-4s %-3s %-10s %s${reset}\n" \
      "$seq" "$pri" "$secret_col" "$due" "$title"

    if [[ -n "$next_action" ]]; then
      printf "${dim}      → NA: %s${reset}\n" "$next_action"
    fi
  done

  local total=$(printf '%s\n' "$tasks" | grep -c .)
  echo ""
  printf "${dim}合計: %d件${reset}\n" "$total"
}
