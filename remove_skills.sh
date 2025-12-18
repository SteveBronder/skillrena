cd ./skills_skillrena/

for d in skills_skillrena/*/; do
  link="$HOME/.codex/skills/$(basename "$d")"
  echo $link
  if [ -L "$link" ]; then   # only touch it if it's a symlink
    unlink "$link"
  fi
done
