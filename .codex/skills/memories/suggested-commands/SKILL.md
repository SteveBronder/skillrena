---
name: suggested-commands
description: Common commands for installing and checking skills
---

## Install and remove (writes to home directory)

- Install skills and plugin: `./scripts/cp_skills.sh` (copies into `~/.codex/skills/skillrena/`, `~/.claude/skills/`, and `~/.claude/plugins/`)
- Remove installed skills and plugin: `./scripts/remove_skills.sh` (uses `rm -rf` on the above targets; read it first)

## Quick repo navigation

- List skills: `find skillrena -maxdepth 2 -name SKILL.md -print`
- Search skill frontmatter: `rg -n '^name:|^description:' skillrena`
- Find referenced docs/assets: `rg -n 'references/|assets/|scripts/' skillrena`

## Safe sanity checks

- Bash syntax check: `bash -n scripts/cp_skills.sh scripts/remove_skills.sh`
- Orchestrator hook/manual tests: follow `skillrena/orchestrator/TESTING.md`
