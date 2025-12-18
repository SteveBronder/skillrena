mkdir -p "$HOME/.codex/skills"

for d in skills_skillrena/*/; do
  [ -d "$d" ] || continue

  skill_name="$(basename "$d")"
  target_dir="$HOME/.codex/skills/$skill_name"

  # Create the directory structure
  mkdir -p "$target_dir"

  # Hard link all files recursively
  find "$d" -type f | while read -r file; do
    rel_path="${file#$d}"
    target_file="$target_dir/$rel_path"

    # Create parent directories if needed
    mkdir -p "$(dirname "$target_file")"

    # Create hard link to the file
    ln -f "$file" "$target_file"
  done
done
