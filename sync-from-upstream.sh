#!/usr/bin/env bash
# Sync superpowers skills from upstream obra/superpowers.
# Usage: ./sync-from-upstream.sh [path-to-upstream]
set -euo pipefail

UPSTREAM="${1:-/home/eranra/go/src/github.com/obra/superpowers}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILLS_DIR="$SCRIPT_DIR/skills"

if [[ ! -d "$UPSTREAM/skills" ]]; then
  echo "Error: upstream skills directory not found at $UPSTREAM/skills"
  echo "Usage: $0 [path-to-upstream]"
  exit 1
fi

echo "=== Syncing from upstream: $UPSTREAM ==="
echo ""

# 11 skills copied verbatim
VERBATIM_SKILLS=(
  brainstorming
  dispatching-parallel-agents
  finishing-a-development-branch
  receiving-code-review
  requesting-code-review
  systematic-debugging
  test-driven-development
  using-git-worktrees
  verification-before-completion
  writing-plans
  writing-skills
)

# 2 skills with TodoWrite → markdown checklist patch
PATCHED_SKILLS=(
  executing-plans
  subagent-driven-development
)

# 1 skill that is a Bob-specific rewrite — never overwritten by sync
MANUAL_SKILLS=(
  using-superpowers
)

echo "→ Copying verbatim skills..."
for skill in "${VERBATIM_SKILLS[@]}"; do
  src="$UPSTREAM/skills/$skill/SKILL.md"
  dest="$SKILLS_DIR/$skill/SKILL.md"
  if [[ ! -f "$src" ]]; then
    echo "  ! WARNING: $skill/SKILL.md not found in upstream — skipping"
    continue
  fi
  mkdir -p "$SKILLS_DIR/$skill"
  cp "$src" "$dest"
  echo "  ✓ $skill"
done

echo ""
echo "→ Copying and patching TodoWrite skills..."
for skill in "${PATCHED_SKILLS[@]}"; do
  src="$UPSTREAM/skills/$skill/SKILL.md"
  dest="$SKILLS_DIR/$skill/SKILL.md"
  if [[ ! -f "$src" ]]; then
    echo "  ! WARNING: $skill/SKILL.md not found in upstream — skipping"
    continue
  fi
  mkdir -p "$SKILLS_DIR/$skill"
  sed \
    -e 's/Create TodoWrite and proceed/Create a markdown checklist and proceed/g' \
    -e 's/create TodoWrite/create a task checklist/g' \
    -e 's/Create TodoWrite/Create a task checklist/g' \
    -e 's/Mark task complete in TodoWrite/Mark task complete in the plan file/g' \
    -e 's/mark task complete in TodoWrite/mark task complete in the plan file/g' \
    "$src" > "$dest"
  echo "  ✓ $skill (patched)"
done

echo ""
echo "→ Skipping Bob-specific rewrites (manual review required):"
for skill in "${MANUAL_SKILLS[@]}"; do
  echo "  ~ $skill"
  echo "    Check upstream for changes: $UPSTREAM/skills/$skill/SKILL.md"
  echo "    Apply relevant changes manually to: $SKILLS_DIR/$skill/SKILL.md"
done

echo ""
echo "=== Sync complete. Changes: ==="
echo ""
git -C "$SCRIPT_DIR" diff --stat 2>/dev/null || echo "(not a git repo or no changes)"
