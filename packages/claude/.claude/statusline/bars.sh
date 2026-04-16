#!/bin/bash
# Bar rendering functions for statusline
# Requires: colors.sh to be sourced first

# Mode: "compact" (1-char mini bar), "bar" (10-char block bar), "dot" (10-char dot bar)
MODE="${CLAUDE_STATUSLINE_MODE:-compact}"

# Mini bar: 8-level block character for percentage
mini_bar() {
  local pct=$1
  local blocks=(▁ ▂ ▃ ▄ ▅ ▆ ▇ █)
  local idx=$(( pct * 8 / 101 ))
  echo "${blocks[$idx]}"
}

# Block bar: single color based on percentage threshold
block_bar() {
  local pct=$1
  local width=10
  local filled=$(( pct * width / 100 ))
  local empty=$(( width - filled ))
  local clr
  clr=$(color_by_pct "$pct")

  local bar="${clr}"
  [ "$filled" -gt 0 ] && bar="${bar}$(printf '█%.0s' $(seq 1 "$filled"))"
  [ "$empty" -gt 0 ]  && bar="${bar}${DIM}$(printf '░%.0s' $(seq 1 "$empty"))"
  bar="${bar}${RESET}"
  echo "${bar}"
}

# Dot bar: ●●●○○○○○○○ style
dot_bar() {
  local pct=$1
  local width=10
  local filled=$(( pct * width / 100 ))
  local empty=$(( width - filled ))
  local clr
  clr=$(color_by_pct "$pct")

  local bar="${clr}"
  [ "$filled" -gt 0 ] && bar="${bar}$(printf '●%.0s' $(seq 1 "$filled"))"
  [ "$empty" -gt 0 ]  && bar="${bar}${DIM}$(printf '○%.0s' $(seq 1 "$empty"))"
  bar="${bar}${RESET}"
  echo "${bar}"
}

# Render percentage indicator based on mode
render_pct() {
  local pct=$(printf '%.0f' "$1")
  case "$MODE" in
    bar)  block_bar "$pct" ;;
    dot)  dot_bar "$pct" ;;
    *)    mini_bar "$pct" ;;
  esac
}
