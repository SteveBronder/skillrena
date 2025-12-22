for d in ./skillrena/*-skl/ ./skillrena/*-ski/; do
  [ -d "$d" ] || continue

  skill_name="$(basename "$d")"

  target_dir="$HOME/.codex/skills/$skill_name"
  if [ -d "$target_dir" ]; then
    echo "Removing: $target_dir"
    rm -rf -- "$target_dir"
  fi

  target_dir="$HOME/.claude/skills/$skill_name"
  if [ -d "$target_dir" ]; then
    echo "Removing: $target_dir"
    rm -rf -- "$target_dir"
  fi
done
