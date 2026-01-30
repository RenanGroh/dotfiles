#!/usr/bin/env bash
# Wrapper to apply a selected image via hyprpaper 0.8 IPC
# Respeita o monitor selecionado no Waypaper (monitors = ...)
# Uso: set_wallpaper_both.sh /path/to/image [fit_mode]

set -euo pipefail

IMG_PATH=${1:-}
FIT_MODE=${2:-fill}

if [[ -z "$IMG_PATH" ]]; then
  echo "Usage: $0 /path/to/image [fit_mode]" >&2
  exit 1
fi

# expand ~ to $HOME if present
if [[ "$IMG_PATH" == ~* ]]; then
  IMG_PATH="${IMG_PATH/#\~/$HOME}"
fi

if [[ ! -f "$IMG_PATH" ]]; then
  echo "File not found: $IMG_PATH" >&2
  exit 2
fi

if ! command -v hyprctl >/dev/null 2>&1; then
  echo "hyprctl not found in PATH" >&2
  exit 3
fi

# Adapt as necessário aos seus nomes de monitores
MON1="DP-3"
MON2="HDMI-A-1"

# Ler config do Waypaper para identificar monitor selecionado e modo de preenchimento
CONFIG_FILE="${XDG_CONFIG_HOME:-$HOME/.config}/waypaper/config.ini"
if [[ -f "$CONFIG_FILE" ]]; then
  # Monitor selecionado: linha "monitors = ..."
  MON_SETTING=$(grep -E '^monitors[[:space:]]*=' "$CONFIG_FILE" | tail -n1 | cut -d= -f2- | sed 's/^\s*//;s/\s*$//') || MON_SETTING=""
  # Modo fill preferido do Waypaper
  FILL_SETTING=$(grep -E '^fill[[:space:]]*=' "$CONFIG_FILE" | tail -n1 | cut -d= -f2- | tr '[:upper:]' '[:lower:]' | sed 's/\s//g') || FILL_SETTING=""
  case "$FILL_SETTING" in
    fill)    FIT_MODE="fill" ;;
    tile)    FIT_MODE="tile" ;;
    fit|contain|center) FIT_MODE="contain" ;;
    cover)   FIT_MODE="cover" ;;
    stretch) FIT_MODE="fill" ;;
    ""|*)   : ;; # mantém o argumento/default
  esac
else
  MON_SETTING="All"
fi

# Normalizar MON_SETTING
MON_SETTING=${MON_SETTING:-All}
case "$MON_SETTING" in
  all|All|ALL|*) : ;; # mantém
esac

apply_to_mon() {
  local mon="$1"
  hyprctl hyprpaper wallpaper "$mon, $IMG_PATH, $FIT_MODE"
}

if [[ "$MON_SETTING" == "All" || "$MON_SETTING" == "ALL" || "$MON_SETTING" == "all" ]]; then
  apply_to_mon "$MON1"
  apply_to_mon "$MON2"
  echo "Applied $IMG_PATH ($FIT_MODE) to $MON1 and $MON2"
else
  # Quando um monitor específico é selecionado no Waypaper
  TARGET="$MON_SETTING"
  apply_to_mon "$TARGET"
  echo "Applied $IMG_PATH ($FIT_MODE) to $TARGET"
fi
