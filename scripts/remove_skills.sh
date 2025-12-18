
for d in ./skillrena/*/; do
  [ -d "$d" ] || continue

  skill_name="$(basename "$d")"
  target_dir="$HOME/.codex/skills/skillrena/$skill_name"

  if [ -d "$target_dir" ]; then
    echo "Removing hardlink tree: $target_dir"
    rm -rf -- "$target_dir"
  fi
done
