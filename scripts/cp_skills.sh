#!/bin/bash
# Copy Skillrena skills and plugins to agent directories

SKILLS=(
  "activating-memories"
  "bootstrapping-design-docs"
  "generate-modes"
  "generating-subtasks"
  "recording-diary"
  "writing-memories"
)

PLUGINS=(
  "orchestrator"
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

# Claude Code: plugins go in ~/.claude/plugins/
mkdir -p "$HOME/.claude/plugins"
for plugin in "${PLUGINS[@]}"; do
  if [ -d "skillrena/$plugin" ]; then
    cp -r "skillrena/$plugin" "$HOME/.claude/plugins/" 2>/dev/null || true
  fi
done

echo "Skills installed to:"
echo "  - ~/.claude/skills/"
echo "  - ~/.codex/skills/skillrena/"
echo ""
echo "Plugins installed to:"
echo "  - ~/.claude/plugins/"
