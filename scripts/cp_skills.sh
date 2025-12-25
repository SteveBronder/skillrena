#!/bin/bash
# Copy Skillrena skills to agent directories

SKILLS=(
  "activating-memories"
  "writing-memories"
  "recording-diary"
  "switching-modes"
  "bootstrapping-design-docs"
  "generating-subtasks"
)

# Codex: skills go in ~/.codex/skills/skillrena/
mkdir -p "$HOME/.codex/skills/skillrena"
for skill in "${SKILLS[@]}"; do
  if [ -d "skillrena/$skill" ]; then
    cp -r "skillrena/$skill" "$HOME/.codex/skills/skillrena/" 2>/dev/null || true
  fi
done

# Claude Code: skills go in ~/.claude/skills/ (flat structure)
mkdir -p "$HOME/.claude/skills"
for skill in "${SKILLS[@]}"; do
  if [ -d "skillrena/$skill" ]; then
    cp -r "skillrena/$skill" "$HOME/.claude/skills/" 2>/dev/null || true
  fi
done

echo "Skills installed to:"
echo "  - ~/.claude/skills/"
echo "  - ~/.codex/skills/skillrena/"
