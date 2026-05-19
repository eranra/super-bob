#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BOB_SETTINGS="$HOME/.bob/settings"
BOB_COMMANDS="$HOME/.bob/commands"
BOB_RULES="$HOME/.bob/settings/rules"
DRY_RUN=false
UPDATE_MODE=false

# Parse command line arguments
for arg in "$@"; do
  case "$arg" in
    --dry-run)
      DRY_RUN=true
      ;;
    --update)
      UPDATE_MODE=true
      ;;
    *)
      echo "Unknown option: $arg"
      echo "Usage: $0 [--dry-run] [--update]"
      exit 1
      ;;
  esac
done

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
  if [[ -f "$dest" ]] && ! $UPDATE_MODE; then
    echo "  ! Skipping $fname (already exists — remove manually to reinstall)"
  else
    if [[ -f "$dest" ]] && $UPDATE_MODE; then
      echo "  ↻ Updating $fname"
    else
      echo "  + $fname"
    fi
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
echo "=== Verifying Installation ==="

# Verification flags
VERIFICATION_PASSED=true

# 1. Verify custom_modes.yaml exists and is valid
echo ""
echo "→ Checking custom_modes.yaml..."
if [[ -f "$MODES_DEST" ]]; then
  echo "  ✓ File exists: $MODES_DEST"
  
  # Check if Python is available for YAML validation
  if command -v python3 &> /dev/null; then
    # Check if PyYAML is installed
    if python3 -c "import yaml" 2>/dev/null; then
      if python3 -c "import yaml; yaml.safe_load(open('$MODES_DEST'))" 2>/dev/null; then
        echo "  ✓ YAML syntax is valid"
      else
        echo "  ✗ YAML syntax validation failed"
        VERIFICATION_PASSED=false
      fi
    else
      echo "  ⚠ PyYAML not installed, skipping YAML validation"
      echo "    (Install with: pip3 install pyyaml)"
    fi
  else
    echo "  ⚠ Python3 not found, skipping YAML validation"
  fi
else
  echo "  ✗ File not found: $MODES_DEST"
  VERIFICATION_PASSED=false
fi

# 2. Verify all commands are installed
echo ""
echo "→ Checking slash commands..."
EXPECTED_COMMANDS=("brainstorm.md" "debug.md" "execute-plan.md" "finish.md" "review.md" "tdd.md" "write-plan.md")
COMMANDS_FOUND=0

for cmd in "${EXPECTED_COMMANDS[@]}"; do
  if [[ -f "$BOB_COMMANDS/$cmd" ]]; then
    echo "  ✓ $cmd"
    COMMANDS_FOUND=$((COMMANDS_FOUND + 1))
  else
    echo "  ✗ $cmd (missing)"
    VERIFICATION_PASSED=false
  fi
done

echo "  Found $COMMANDS_FOUND of ${#EXPECTED_COMMANDS[@]} commands"

# 3. Verify workspace rules are installed
echo ""
echo "→ Checking workspace rules..."
if [[ -f "$BOB_RULES/superbob-workspace.md" ]]; then
  echo "  ✓ superbob-workspace.md"
else
  echo "  ✗ superbob-workspace.md (missing)"
  VERIFICATION_PASSED=false
fi

# Final status
echo ""
if $VERIFICATION_PASSED; then
  echo "=== ✓ Installation Verified Successfully ==="
  echo ""
  echo "Next Steps:"
  echo "  1. Restart IBM Bob to load the new modes"
  echo "  2. Try: /tdd to start test-driven development"
  echo "  3. Try: /write-plan to create an implementation plan"
  echo "  4. Try: /review to request code review"
  echo "  5. Read docs/QUICK_REFERENCE.md for a quick start guide"
  echo ""
  echo "For more information:"
  echo "  • README.md - Workflows and getting started"
  echo "  • docs/ARCHITECTURE.md - System design and quality gates"
  echo "  • docs/TESTING.md - Testing methodology"
  echo "  • docs/examples/ - Real-world usage examples"
  exit 0
else
  echo "=== ⚠ Installation Completed with Warnings ==="
  echo ""
  echo "Some verification checks failed. Please review the output above."
  echo "You may need to run the installer again or check file permissions."
  exit 1
fi
