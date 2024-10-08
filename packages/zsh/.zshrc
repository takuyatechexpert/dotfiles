eval "$(starship init zsh)"

# 補完機能を有効にする
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

# zsh autosuggerstions プラグインを有効化
source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# laravel sailのエイリアス
alias sail=vendor/bin/sail

# taskのエイリアス
alias run=./Taskfile

# kitty
# 画像表示のエイリアス
alias icat="kitty +kitten icat"
# ssh コマンド
alias kssh="TERM=xterm /usr/bin/ssh"

# nvm
export NVM_DIR="$HOME/.nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && . "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && . "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion

set PKG_CONFIG_PATH /usr/local/opt/icu4c/lib/pkgconfig /usr/local/opt/krb5/lib/pkgconfig /usr/local/opt/libedit/lib/pkgconfig /usr/local/opt/libxml2/lib/pkgconfig /usr/local/opt/openssl@1.1/lib/pkgconfig $PKG_CONFIG_PATH
set PATH /usr/local/opt/bison/bin $PATH

# phpbrew
[[ -e ~/.phpbrew/bashrc ]] && source ~/.phpbrew/bashrc

export PATH=/opt/homebrew/bin:/opt/phpbrew/bin:/usr/local/bin:$PATH

# tmux
alias tnew='tmux new -s'
alias tatt='tmux attach -t'
alias tkill='tmux kill-session -t'
alias tlist='tmux list-sessions'

# export LANG=jp_JP.UTF-8
# export LC_ALL=jp_JP.UTF-8
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8


[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# memo
function memo() {
    # フォルダを指定（必要に応じて変更してください）
    local folder_path="$HOME/memos"
    mkdir -p "$folder_path"

    # 現在の日時を取得し、ファイル名の基礎を作成 (Ymd_ 形式)
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
}

# 関数を簡単に呼び出せるようにエイリアスを設定
alias memo="memo"
