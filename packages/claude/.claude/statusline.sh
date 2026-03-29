#!/bin/bash
input=$(cat)

# Colors
GREEN='\033[32m'
YELLOW='\033[33m'
RED='\033[31m'
DIM='\033[2m'
RESET='\033[0m'

# Mini bar: 8-level block character for percentage
mini_bar() {
  local pct=$1
  local blocks=(▁ ▂ ▃ ▄ ▅ ▆ ▇ █)
  local idx=$(( pct * 8 / 101 ))
  echo "${blocks[$idx]}"
}

MODEL=$(echo "$input" | jq -r '.model.display_name')
FIVE_H=$(echo "$input" | jq -r '.rate_limits.five_hour.used_percentage // empty')
FIVE_H_RESET=$(echo "$input" | jq -r '.rate_limits.five_hour.resets_at // empty')
WEEK=$(echo "$input" | jq -r '.rate_limits.seven_day.used_percentage // empty')
WEEK_RESET=$(echo "$input" | jq -r '.rate_limits.seven_day.resets_at // empty')

NOW=$(date +%s)

fmt_remaining() {
  local reset=$1
  local diff=$(( reset - NOW ))
  [ "$diff" -le 0 ] && echo "soon" && return
  local h=$(( diff / 3600 ))
  local m=$(( (diff % 3600) / 60 ))
  if [ "$h" -gt 0 ]; then
    printf '%dh%02dm' "$h" "$m"
  else
    printf '%dm' "$m"
  fi
}

# Color based on percentage threshold
color_by_pct() {
  local pct=$1
  if [ "$pct" -ge 80 ]; then
    echo "$RED"
  elif [ "$pct" -ge 50 ]; then
    echo "$YELLOW"
  else
    echo "$GREEN"
  fi
}

LIMITS=""
if [ -n "$FIVE_H" ]; then
  PCT=$(printf '%.0f' "$FIVE_H")
  CLR=$(color_by_pct "$PCT")
  BAR=$(mini_bar "$PCT")
  PART="${CLR}5h:${PCT}%${BAR}${RESET}"
  [ -n "$FIVE_H_RESET" ] && PART="$PART${DIM}($(fmt_remaining "$FIVE_H_RESET"))${RESET}"
  LIMITS="$PART"
fi
if [ -n "$WEEK" ]; then
  PCT=$(printf '%.0f' "$WEEK")
  CLR=$(color_by_pct "$PCT")
  BAR=$(mini_bar "$PCT")
  PART="${CLR}7d:${PCT}%${BAR}${RESET}"
  [ -n "$WEEK_RESET" ] && PART="$PART${DIM}($(fmt_remaining "$WEEK_RESET"))${RESET}"
  LIMITS="${LIMITS:+$LIMITS  }$PART"
fi

CTX=$(echo "$input" | jq -r '.context_window.used_percentage // 0')
CTX_PART=""
if [ -n "$CTX" ]; then
  CTX_INT=$(printf '%.0f' "$CTX")
  BAR=$(mini_bar "$CTX_INT")
  if [ "$CTX_INT" -ge 65 ]; then
    CTX_PART="${RED}ctx:${CTX_INT}%${BAR} !!${RESET}"
  elif [ "$CTX_INT" -ge 40 ]; then
    CTX_PART="${YELLOW}ctx:${CTX_INT}%${BAR}${RESET}"
  else
    CTX_PART="${GREEN}ctx:${CTX_INT}%${BAR}${RESET}"
  fi
fi

PARTS=""
[ -n "$CTX_PART" ] && PARTS="$CTX_PART"
[ -n "$LIMITS" ] && PARTS="${PARTS:+$PARTS  }$LIMITS"

if [ -n "$PARTS" ]; then
  echo -e "$MODEL │ $PARTS"
else
  echo "$MODEL"
fi
