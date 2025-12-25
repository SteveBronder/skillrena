#!/bin/bash
# Remove Skillrena skills from agent directories

SKILLS=(
  "activating-memories"
  "writing-memories"
  "recording-diary"
  "switching-modes"
  "bootstrapping-design-docs"
  "generating-subtasks"
)

for skill in "${SKILLS[@]}"; do
  # Remove from Codex
  target_dir="$HOME/.codex/skills/skillrena/$skill"
  if [ -d "$target_dir" ]; then
    echo "Removing: $target_dir"
    rm -rf -- "$target_dir"
  fi

  # Remove from Claude Code
  target_dir="$HOME/.claude/skills/$skill"
  if [ -d "$target_dir" ]; then
    echo "Removing: $target_dir"
    rm -rf -- "$target_dir"
  fi
done

# Also remove old-style skills if present (for migration)
for d in "$HOME/.codex/skills/skillrena/"*-skl "$HOME/.codex/skills/skillrena/"*-ski \
         "$HOME/.claude/skills/"*-skl "$HOME/.claude/skills/"*-ski; do
  if [ -d "$d" ]; then
    echo "Removing old skill: $d"
    rm -rf -- "$d"
  fi
done

echo "Skills removed."
