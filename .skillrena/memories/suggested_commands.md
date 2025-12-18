# Suggested commands

## Install Skillrena skills into Codex CLI
- `./scripts/cp_skills.sh` (copies `skillrena/*` into `~/.codex/skills/skillrena/`)
- `./scripts/remove_skills.sh` (removes installed Skillrena skills)

## Install Serena skills into Codex CLI
- `mkdir -p ~/.codex/skills`
- `cp -R skills_serena/serena-* ~/.codex/skills/`

## Repo navigation
- List Skillrena skills: `ls -1 skillrena/`
- List Serena skills: `ls -1 skills_serena/serena-*`
- List all skill files: `find . -name SKILL.md -maxdepth 2`
- Search descriptions: `rg "^description:" skillrena/*/SKILL.md skills_serena/*/SKILL.md`
- View Serena catalog: `sed -n '1,160p' skills_serena/skills.md`

## Docs
- Scan migration doc headings: `rg -n "^#|^##" design/skillrena-migration.md`
