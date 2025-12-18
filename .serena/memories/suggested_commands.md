# Suggested commands

## Install into Codex CLI
- Enable skills in Codex config (example):
  - Add to your Codex config: `[features]\nskills = true`
- Copy skills into Codex’s skills directory:
  - `mkdir -p ~/.codex/skills`
  - `cp -R serena-* ~/.codex/skills/`

## Repo navigation
- List skills: `ls -1 serena-*`
- List all skill definition files: `find . -name SKILL.md -maxdepth 2`
- Search within skills: `rg "^description:" serena-*/SKILL.md`

## Editing workflow helpers
- Check the catalog: `sed -n '1,120p' skills.md`
- When adding/renaming skills, update both the folder name and the YAML front matter (`name:` / `description:`).
