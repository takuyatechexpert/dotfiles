# todo.plugin.zsh — メインエントリポイント

# プラグインのルートディレクトリ
typeset -g TODO_PLUGIN_DIR="${0:A:h}"

# ライブラリ読み込み
source "${TODO_PLUGIN_DIR}/lib/utils.zsh"
source "${TODO_PLUGIN_DIR}/lib/core.zsh"
source "${TODO_PLUGIN_DIR}/lib/display.zsh"

# メインコマンド
t() {
  # 依存チェック
  _todo_check_deps || return 1

  local subcmd="${1:-help}"

  case "$subcmd" in
    add)
      shift
      _todo_add "$@"
      ;;
    ls|list)
      shift
      _todo_ensure_dir
      local tasks
      tasks=$(_todo_list "$@")
      _todo_display_list "$tasks"
      ;;
    now)
      shift
      _todo_ensure_dir
      local tasks
      tasks=$(_todo_now_tasks "${1:-10}")
      _todo_display_list "$tasks"
      ;;
    snooze)
      shift
      _todo_snooze "$1" "$2"
      ;;
    done)
      shift
      _todo_done "$@"
      ;;
    edit)
      shift
      _todo_edit "$1"
      ;;
    na)
      shift
      _todo_na "$@"
      ;;
    help|--help|-h)
      _todo_help
      ;;
    *)
      # サブコマンドなし → add のショートハンド
      _todo_add "$@"
      ;;
  esac
}

_todo_help() {
  cat << 'EOF'
usage: t <command> [args]

commands:
  <text...>           タスク追加（add のショートハンド）
  add [-s] <text...>  タスク追加（-s: secret）
  ls [options]        タスク一覧
    --all, -a           完了・破棄含む全件表示
    --project <name>    プロジェクトでフィルタ
    --tag <name>        タグでフィルタ
  now                 今日のタスク（優先度順 上位10件）
  done <id...>        タスク完了
  snooze <id> <dur>   スヌーズ（2h/3d/1w）
  edit <id>           タスク編集（$EDITOR）
  na <id> [text]      Next Action 設定（text省略で解除）
  help                このヘルプ
EOF
}
