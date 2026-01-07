---
name: style-and-conventions
description: Conventions for skills markdown and repo structure
---

## Skills structure

- Each skill is a directory with `SKILL.md` at `skillrena/<skill-name>/SKILL.md`.
- `SKILL.md` uses YAML frontmatter plus Markdown body (spec in `docs/skills/specification.md`).
- Skill names are lowercase with hyphens and must match the directory name (see `docs/skills/specification.md`).
- Optional support dirs commonly used here: `references/`, `assets/` (examples under `skillrena/generate-modes/` and `skillrena/activating-memories/`).

## Project memory files

- Repo-local memories live at `./.codex/skills/memories/<memory-name>/SKILL.md` (or `.claude/...` when running Claude Code).
- Memory `SKILL.md` frontmatter should be minimal: `name` and `description` only (rules in `skillrena/writing-memories/SKILL.md`).
  - `description` should stay on one line and avoid extra colons.

## Cross-agent install paths

- Codex: `~/.codex/skills/skillrena/<skill-name>/` (nested)
- Claude: `~/.claude/skills/<skill-name>/` (flat)
- Install script behavior is defined in `scripts/cp_skills.sh`.

## Bash conventions in this repo

- Scripts use `#!/bin/bash` and generally prefer safe bash patterns (example: `skillrena/orchestrator/hooks/orchestrator-stop-hook.sh` uses `set -euo pipefail`).
