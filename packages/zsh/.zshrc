# ============================================================
# 環境変数 (Environment Variables)
# ============================================================
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export EDITOR=nvim

export PATH=/opt/homebrew/bin:/opt/phpbrew/bin:/usr/local/bin:$PATH
export PATH="$PATH:$HOME/.local/bin"
export PATH="$HOME/private-projects/claude-monitor/bin:$PATH"
export PATH="$PATH:$HOME/private-projects/db-pilot.nvim/bin"

### MANAGED BY RANCHER DESKTOP START (DO NOT EDIT)
export PATH="$HOME/.rd/bin:$PATH"
### MANAGED BY RANCHER DESKTOP END (DO NOT EDIT)

set PKG_CONFIG_PATH /usr/local/opt/icu4c/lib/pkgconfig /usr/local/opt/krb5/lib/pkgconfig /usr/local/opt/libedit/lib/pkgconfig /usr/local/opt/libxml2/lib/pkgconfig /usr/local/opt/openssl@1.1/lib/pkgconfig $PKG_CONFIG_PATH
set PATH /usr/local/opt/bison/bin $PATH


# ============================================================
# プロンプト (Prompt)
# ============================================================
eval "$(starship init zsh)"


# ============================================================
# 補完設定 (Completion)
# ============================================================
autoload -Uz compinit
compinit -u
if [ -e /usr/local/share/zsh-completions ]; then
  fpath=(/usr/local/share/zsh-completions $fpath)
fi
# 補完で小文字でも大文字にマッチさせる
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
# 補完候補を詰めて表示
setopt list_packed
# 補完候補一覧をカラー表示
zstyle ':completion:*' list-colors ''


# ============================================================
# プラグイン・ツール初期化 (Plugin / Tool Initialization)
# ============================================================
# zoxide
eval "$(zoxide init zsh)"

# zsh-autosuggestions / zsh-syntax-highlighting
source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
# vi insert モードに emacs スタイルのキーバインドを追加
# カーソル移動
bindkey -M viins "^A" beginning-of-line
bindkey -M viins "^E" end-of-line
bindkey -M viins "^F" autosuggest-accept
bindkey -M viins "^B" backward-char
# 履歴
bindkey -M viins "^P" up-line-or-history
bindkey -M viins "^N" down-line-or-history
bindkey -M viins "^R" history-incremental-search-backward
# 削除
bindkey -M viins "^D" delete-char-or-list
bindkey -M viins "^H" backward-delete-char
bindkey -M viins "^K" kill-line
bindkey -M viins "^U" backward-kill-line
bindkey -M viins "^W" backward-kill-word
# その他
bindkey -M viins "^Y" yank
bindkey -M viins "^L" clear-screen
bindkey -M viins "^T" transpose-chars

# mise
eval "$(mise activate zsh)"

# phpbrew
[[ -e ~/.phpbrew/bashrc ]] && source ~/.phpbrew/bashrc

# fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# todo plugin
source "${HOME}/todo/todo.plugin.zsh"

# translate plugin
source "${HOME}/dotfiles/packages/zsh/translate/translate.plugin.zsh"


# ============================================================
# エイリアス (Aliases)
# ============================================================
# laravel sail
alias sail=vendor/bin/sail

# task
alias run=./Taskfile

# kitty
alias icat="kitty +kitten icat"
alias kssh="TERM=xterm /usr/bin/ssh"

# tmux
alias tnew='tmux new -s'
alias tatt='tmux attach -t'
alias tkill='tmux kill-session -t'
alias tlist='tmux list-sessions'

# claude
alias cclaude="claude --continue"
alias rclaude="claude --resume"
alias agentcc="claude --dangerously-skip-permissions"
alias claude-monitor='claude-monitor.sh'


# ============================================================
# 関数 (Functions)
# ============================================================
# yazi (終了時にyaziで最後にいたディレクトリにcdする)
function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		builtin cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}

# memo
function memo() {
    local folder_path="$HOME/memos"
    local subcommand="${1:-new}"

    case "$subcommand" in
        new)
            # 新しいメモを作成
            mkdir -p "$folder_path"

            local base_name=$(date +"%Y%m%d_")
            local index=1
            local file_path=""

            # インデックスが付与された新しいファイル名を探す
            while true; do
                file_path="${folder_path}/${base_name}$(printf "%02d" $index).md"
                if [ ! -f "$file_path" ]; then
                    break
                fi
                index=$((index + 1))
            done

            # ファイルを作成し、nvimで開く
            nvim "$file_path"
            ;;

        list|ls)
            # メモの一覧を表示（最新20件）
            if [ ! -d "$folder_path" ]; then
                echo "メモディレクトリが存在しません: $folder_path"
                return 1
            fi
            ls -lt "$folder_path"/*.md 2>/dev/null | head -20
            ;;

        search)
            # メモを検索
            if [ -z "$2" ]; then
                echo "使い方: memo search <キーワード>"
                return 1
            fi
            if [ ! -d "$folder_path" ]; then
                echo "メモディレクトリが存在しません: $folder_path"
                return 1
            fi
            grep -r --color=always -n "$2" "$folder_path"
            ;;

        help|--help|-h)
            # ヘルプメッセージ
            cat << EOF
使い方: memo [サブコマンド] [引数]

サブコマンド:
  new           新しいメモを作成（デフォルト）
  list, ls      メモの一覧を表示（最新20件）
  search <word> メモを検索
  help          このヘルプメッセージを表示

例:
  memo              # 新しいメモを作成
  memo new          # 新しいメモを作成
  memo list         # メモ一覧を表示
  memo search TODO  # "TODO"を含むメモを検索
EOF
            ;;

        *)
            echo "不明なサブコマンド: $subcommand"
            echo "使い方: memo help でヘルプを表示"
            return 1
            ;;
    esac
}

# claude-monitor
export PATH="$HOME/private-projects/claude-monitor/bin:$PATH"
