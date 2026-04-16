#!/bin/bash
input=$(cat)

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "${SCRIPT_DIR}/colors.sh"
source "${SCRIPT_DIR}/bars.sh"

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

LIMITS=""
if [ -n "$FIVE_H" ]; then
  PCT=$(printf '%.0f' "$FIVE_H")
  CLR=$(color_by_pct "$PCT")
  BAR=$(render_pct "$PCT")
  if [ "$MODE" = "compact" ]; then
    PART="${CLR}5h:${PCT}%${BAR}${RESET}"
  else
    PART="${CLR}5h:${PCT}%${RESET}${BAR}"
  fi
  [ -n "$FIVE_H_RESET" ] && PART="$PART${DIM}($(fmt_remaining "$FIVE_H_RESET"))${RESET}"
  LIMITS="$PART"
fi
if [ -n "$WEEK" ]; then
  PCT=$(printf '%.0f' "$WEEK")
  CLR=$(color_by_pct "$PCT")
  BAR=$(render_pct "$PCT")
  if [ "$MODE" = "compact" ]; then
    PART="${CLR}7d:${PCT}%${BAR}${RESET}"
  else
    PART="${CLR}7d:${PCT}%${RESET}${BAR}"
  fi
  [ -n "$WEEK_RESET" ] && PART="$PART${DIM}($(fmt_remaining "$WEEK_RESET"))${RESET}"
  LIMITS="${LIMITS:+$LIMITS  }$PART"
fi

CTX=$(echo "$input" | jq -r '.context_window.used_percentage // 0')
CTX_PART=""
if [ -n "$CTX" ]; then
  CTX_INT=$(printf '%.0f' "$CTX")
  BAR=$(render_pct "$CTX_INT")
  if [ "$MODE" = "compact" ]; then
    if [ "$CTX_INT" -ge 65 ]; then
      CTX_PART="${RED}ctx:${CTX_INT}%${BAR} !!${RESET}"
    elif [ "$CTX_INT" -ge 40 ]; then
      CTX_PART="${YELLOW}ctx:${CTX_INT}%${BAR}${RESET}"
    else
      CTX_PART="${GREEN}ctx:${CTX_INT}%${BAR}${RESET}"
    fi
  else
    if [ "$CTX_INT" -ge 65 ]; then
      CTX_PART="${RED}ctx:${CTX_INT}%${RESET}${BAR}${RED} !!${RESET}"
    elif [ "$CTX_INT" -ge 40 ]; then
      CTX_PART="${YELLOW}ctx:${CTX_INT}%${RESET}${BAR}"
    else
      CTX_PART="${GREEN}ctx:${CTX_INT}%${RESET}${BAR}"
    fi
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
