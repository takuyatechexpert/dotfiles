#!/bin/bash
# Color constants and threshold-based color selection

GREEN='\033[32m'
YELLOW='\033[33m'
RED='\033[31m'
DIM='\033[2m'
RESET='\033[0m'

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
