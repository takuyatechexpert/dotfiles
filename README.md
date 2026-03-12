# dotfiles

macOS 環境の設定ファイルを [GNU Stow](https://www.gnu.org/software/stow/) で管理するリポジトリ。

## セットアップ

### 前提条件

- macOS
- Git
- SSH キーが GitHub に登録済み

### インストール

```sh
# 1. リポジトリをクローン
git clone git@github.com:takuyatechexpert/dotfiles.git ~/dotfiles

# 2. インストールスクリプトを実行
~/dotfiles/install

# --skip-apps を付けると Homebrew のアプリインストールをスキップ
~/dotfiles/install --skip-apps
```

`install` スクリプトは以下を実行する:

1. Homebrew をインストール（未インストールの場合）
2. `Brewfile` に定義されたパッケージ・アプリを一括インストール
3. `stow` で各パッケージのシンボリックリンクを `~` に作成
4. `asdf` でランタイムバージョンをインストール

## ディレクトリ構成

```
dotfiles/
├── install              # セットアップスクリプト
├── Brewfile             # Homebrew パッケージ定義
├── karabiner/           # Karabiner-Elements 設定（手動リンク）
├── vsCode/              # VS Code 設定（手動リンク）
└── packages/            # stow で管理するパッケージ群
    ├── asdf/            # .tool-versions（ランタイムバージョン管理）
    ├── claude/          # Claude Code 設定
    ├── hammerspoon/     # Hammerspoon 設定
    ├── neovim/          # Neovim 設定（LazyVim）
    ├── starship/        # Starship プロンプト設定
    ├── tmux/            # tmux 設定
    ├── vim/             # Vim 設定
    ├── wezterm/         # WezTerm 設定
    └── zsh/             # Zsh 設定
```

## 設定ファイルの編集方法

### 基本ルール

`packages/` 以下のファイルは `stow` によって `~` にシンボリックリンクされている。
**ファイルの編集は `~/dotfiles/packages/` 内で行う。**

```sh
# 例: zshrc を編集
vim ~/dotfiles/packages/zsh/.zshrc

# 例: neovim のプラグイン設定を編集
vim ~/dotfiles/packages/neovim/.config/nvim/lua/plugins.lua
```

### パッケージの追加・削除

```sh
# 新しいパッケージを stow でリンク
stow -v -d ~/dotfiles/packages -t ~ <パッケージ名>

# パッケージのリンクを解除
stow -vD -d ~/dotfiles/packages -t ~ <パッケージ名>
```

### Homebrew パッケージの管理

```sh
# Brewfile を編集
vim ~/dotfiles/Brewfile

# Brewfile の内容をインストール
brew bundle -v --file=~/dotfiles/Brewfile
```

### 手動リンクが必要なもの

以下は `stow` 管理外のため、必要に応じて手動でコピー・リンクする:

- `karabiner/karabiner.json` → `~/.config/karabiner/karabiner.json`
- `vsCode/settings.json` → VS Code の settings.json
