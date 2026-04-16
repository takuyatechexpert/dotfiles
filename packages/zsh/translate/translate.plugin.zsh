# translate.plugin.zsh — translate-shell ラッパー

# 英語 → 日本語（デフォルト）
ej() {
  local text
  if [[ $# -gt 0 ]]; then
    text="$*"
  elif [[ ! -t 0 ]]; then
    text=$(cat)
  else
    echo "usage: ej <text...>  or  echo 'text' | ej" >&2
    return 1
  fi
  trans -b en:ja "$text"
}

# 日本語 → 英語
je() {
  local text
  if [[ $# -gt 0 ]]; then
    text="$*"
  elif [[ ! -t 0 ]]; then
    text=$(cat)
  else
    echo "usage: je <text...>  or  echo 'text' | je" >&2
    return 1
  fi
  trans -b ja:en "$text"
}
