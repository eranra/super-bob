#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BOB_SETTINGS="$HOME/.bob/settings"
BOB_COMMANDS="$HOME/.bob/commands"
BOB_RULES="$HOME/.bob/settings/rules"
DRY_RUN=false

[[ "${1:-}" == "--dry-run" ]] && DRY_RUN=true

run() {
  if $DRY_RUN; then echo "[dry-run] $*"; else "$@"; fi
}

echo "=== SuperBob Installer ==="
$DRY_RUN && echo "(dry-run mode — no files will be written)"
echo ""

# 1. custom_modes.yaml
MODES_DEST="$BOB_SETTINGS/custom_modes.yaml"
MODES_SRC="$SCRIPT_DIR/custom_modes.yaml"

if [[ -f "$MODES_DEST" ]]; then
  if grep -q "customModes: \[\]" "$MODES_DEST" 2>/dev/null || [[ ! -s "$MODES_DEST" ]]; then
    echo "→ custom_modes.yaml is empty, replacing"
  else
    BACKUP="${MODES_DEST}.bak.$(date +%Y%m%d_%H%M%S)"
    echo "→ Backing up existing custom_modes.yaml to $(basename "$BACKUP")"
    run cp "$MODES_DEST" "$BACKUP"
  fi
fi

echo "→ Installing custom_modes.yaml → $MODES_DEST"
run mkdir -p "$BOB_SETTINGS"
run cp "$MODES_SRC" "$MODES_DEST"

# 2. commands
echo ""
echo "→ Installing slash commands → $BOB_COMMANDS/"
run mkdir -p "$BOB_COMMANDS"
shopt -s nullglob
for cmd in "$SCRIPT_DIR/commands/"*.md; do
  fname="$(basename "$cmd")"
  dest="$BOB_COMMANDS/$fname"
  if [[ -f "$dest" ]]; then
    echo "  ! Skipping $fname (already exists — remove manually to reinstall)"
  else
    echo "  + $fname"
    run cp "$cmd" "$dest"
  fi
done

# 3. workspace rules
echo ""
echo "→ Installing workspace rules → $BOB_RULES/"
run mkdir -p "$BOB_RULES"
run cp "$SCRIPT_DIR/rules/superbob-workspace.md" "$BOB_RULES/superbob-workspace.md"
echo "  + superbob-workspace.md"

echo ""
echo "=== Done. Restart IBM Bob to load the new modes. ==="
