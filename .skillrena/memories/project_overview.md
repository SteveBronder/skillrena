# Project overview: skills

This repository hosts Codex CLI skill definitions for Serena MCP tools and the newer Skillrena replacements.

## Purpose
- Provide per-tool SKILL.md prompts for Serena (`skills_serena/`) and Skillrena (`skillrena/`) toolsets.
- Document the migration plan from Serena to Skillrena in `design/skillrena-migration.md`.

## Structure
- `skills_serena/skills.md`: install notes + catalog for Serena skills.
- `skills_serena/serena-*/SKILL.md`: Serena tool skill definitions.
- `skillrena/*-skl/SKILL.md`: Skillrena tool skill definitions.
- `.serena/`: legacy Serena project config/memories.
- `.skillrena/`: Skillrena state + memories (created by onboarding).
- `scripts/cp_skills.sh` / `scripts/remove_skills.sh`: helper scripts to install/remove Skillrena skills.
- `serena/`: local Serena checkout (ignored by git).

## Tech stack
- Markdown (`SKILL.md` with YAML front matter).
- Shell scripts for install/remove.
