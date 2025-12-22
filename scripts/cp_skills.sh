mkdir -p "$HOME/.codex/skills/skillrena"
cp -r skillrena/*-skl skillrena/*-ski "$HOME/.codex/skills/skillrena" 2>/dev/null || true
mkdir -p "$HOME/.claude/skills"
cp -r skillrena/*-skl skillrena/*-ski "$HOME/.claude/skills" 2>/dev/null || true