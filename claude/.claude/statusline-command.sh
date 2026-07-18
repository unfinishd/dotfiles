#!/bin/bash
# Claude Code custom statusline — colored, with model, repo, branch, cost, context bar.
# Receives JSON via stdin from Claude Code. Outputs a single ANSI-colored line.

INPUT=$(cat)

# Parse all fields from JSON via jq (single invocation for speed)
eval "$(echo "$INPUT" | jq -r '
  @sh "MODEL=\(.model.display_name // "?")",
  @sh "PROJECT_DIR=\(.cwd // .workspace.current_dir // .workspace.project_dir // "")",
  @sh "COST=\(.cost.total_cost_usd // 0)",
  @sh "CTX_PCT=\(.context_window.used_percentage // 0)",
  @sh "CTX_SIZE=\(.context_window.context_window_size // 0)",
  @sh "INPUT_TOKENS=\(.context_window.current_usage.input_tokens // 0)",
  @sh "CACHE_CREATE=\(.context_window.current_usage.cache_creation_input_tokens // 0)",
  @sh "CACHE_READ=\(.context_window.current_usage.cache_read_input_tokens // 0)"
' 2>/dev/null)" 2>/dev/null || { echo "[Claude]"; exit 0; }

# --- Colors ---
R='\033[0m'       # reset
B='\033[1m'       # bold
D='\033[2m'       # dim
CYAN='\033[36m'
YEL='\033[33m'
GRN='\033[32m'
MAG='\033[35m'
RED='\033[31m'
WHT='\033[37m'

# --- Separator ---
SEP="${D}${WHT} | ${R}"

# --- Context color (green / yellow / red) ---
if [ "$CTX_PCT" -ge 80 ]; then
  CC="${B}${RED}"
elif [ "$CTX_PCT" -ge 50 ]; then
  CC="${YEL}"
else
  CC="${GRN}"
fi

# --- Format token counts (3k, 120k, 1.0M) ---
fmt_tokens() {
  local t=$1
  if [ "$t" -ge 1000000 ]; then
    printf '%.1fM' "$(echo "scale=1; $t / 1000000" | bc)"
  elif [ "$t" -ge 1000 ]; then
    printf '%dk' "$(( t / 1000 ))"
  else
    printf '%d' "$t"
  fi
}

# --- Build smooth context bar (10 cells, 8 sub-positions each = 80 steps) ---
# Uses Unicode block elements: █ ▉ ▊ ▋ ▌ ▍ ▎ ▏ for sub-cell resolution
BAR_WIDTH=10
PARTIALS=( "" "▏" "▎" "▍" "▌" "▋" "▊" "▉" )
FULL="█"
EMPTY_CHAR="░"

STEPS=$(( CTX_PCT * BAR_WIDTH * 8 / 100 ))
FULL_CELLS=$(( STEPS / 8 ))
FRAC=$(( STEPS % 8 ))
EMPTY_CELLS=$(( BAR_WIDTH - FULL_CELLS - (FRAC > 0 ? 1 : 0) ))

BAR=""
for ((i=0; i<FULL_CELLS; i++)); do BAR="${BAR}${FULL}"; done
if [ "$FRAC" -gt 0 ]; then BAR="${BAR}${PARTIALS[$FRAC]}"; fi
EMPTY_PART=""
for ((i=0; i<EMPTY_CELLS; i++)); do EMPTY_PART="${EMPTY_PART}${EMPTY_CHAR}"; done

# --- Tokens ---
USED_TOKENS=$(( INPUT_TOKENS + CACHE_CREATE + CACHE_READ ))
USED_FMT=$(fmt_tokens "$USED_TOKENS")
SIZE_FMT=$(fmt_tokens "$CTX_SIZE")

# --- Assemble ---
OUT=""

# Model (bold cyan)
OUT="${OUT}${B}${CYAN}${MODEL}${R}"

# Repo (yellow) + branch (green)
if [ -n "$PROJECT_DIR" ]; then
  REPO=$(basename "$PROJECT_DIR")
  OUT="${OUT}${SEP}${YEL}${REPO}${R}"
  BRANCH=$(git -C "$PROJECT_DIR" rev-parse --abbrev-ref HEAD 2>/dev/null)
  if [ -n "$BRANCH" ]; then
    OUT="${OUT}${D}${WHT}:${R}${GRN}${BRANCH}${R}"
  fi
fi

# Cost (magenta)
COST_FMT=$(printf '%.2f' "$COST")
OUT="${OUT}${SEP}${MAG}\$${COST_FMT}${R}"

# Context bar + tokens + percentage
OUT="${OUT}${SEP}${CC}${BAR}${R}${D}${EMPTY_PART}${R} ${CC}${USED_FMT}/${SIZE_FMT} (${CTX_PCT}%)${R}"

echo -e "$OUT"
