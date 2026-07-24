#!/usr/bin/env bash
# Claude Code status line
# Format: <model> | Context xx% (<tokens>) | Session xx% (resets Xh Ym)
# Session block is hidden when rate_limits.five_hour is unavailable.

# Force C locale so awk uses "." as decimal separator (not "," under it_IT).
export LC_ALL=C

input=$(cat)

# 256-color codes, muted enough to stay readable on light and dark themes.
RESET=$'\033[0m'
DIM=$'\033[2m'
GRAY=$'\033[38;5;245m'
WHITE=$'\033[38;5;255m'
RED=$'\033[38;5;167m'
AMBER=$'\033[38;5;179m'
MODEL=$'\033[1;38;5;61m' # bold, #5f5faf
SEP="${DIM} | ${RESET}"

pct_color() {
	local p="$1"
	if ((p >= 80)); then
		echo "$RED"
	elif ((p >= 50)); then
		echo "$AMBER"
	else
		echo "$WHITE"
	fi
}

format_tokens() {
	local n="$1"
	[[ -z $n ]] && return
	awk -v n="$n" 'BEGIN {
        if (n >= 1000) { printf "%.1fk", n/1000 } else { printf "%d", n }
    }'
}

round_pct() {
	local p="$1"
	[[ -z $p ]] && return
	awk -v p="$p" 'BEGIN { printf "%d", p + 0.5 }'
}

model=$(echo "$input" | jq -r '.model.display_name // empty')
line=""
[[ -n $model ]] && line="${MODEL}${model}${RESET}"

ctx_pct=$(echo "$input" | jq -r '.context_window.used_percentage // empty')
ctx_tokens=$(echo "$input" | jq -r '.context_window.total_input_tokens // empty')

if [[ -n $ctx_pct ]]; then
	pct=$(round_pct "$ctx_pct")
	line+="${SEP}${GRAY}Context $(pct_color "$pct")${pct}%${RESET}${DIM} ($(format_tokens "$ctx_tokens"))${RESET}"
fi

session_pct=$(echo "$input" | jq -r '.rate_limits.five_hour.used_percentage // empty')
session_resets=$(echo "$input" | jq -r '.rate_limits.five_hour.resets_at // empty')

# resets_at may be epoch seconds or an ISO8601 timestamp.
if [[ -n $session_resets && $session_resets == *[!0-9]* ]]; then
	session_resets=$(date -d "$session_resets" +%s 2>/dev/null)
fi

if [[ -n $session_pct && -n $session_resets ]]; then
	now=$(date +%s)
	diff=$((session_resets - now))
	((diff < 0)) && diff=0
	pct=$(round_pct "$session_pct")
	line+="${SEP}${GRAY}Session $(pct_color "$pct")${pct}%${RESET}${DIM} (resets $((diff / 3600))h $((diff % 3600 / 60))m)${RESET}"
fi

printf '%s\n' "$line"
