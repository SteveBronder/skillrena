# Project overview (markdown)

## Purpose
- Skillrena provides reusable agent skills with low token overhead compared with MCP-heavy setups.
- This repository primarily stores skill instructions and supporting references/assets.

## Repo map
- Key directories:
  - `skillrena/`: source skills, one folder per skill, each with `SKILL.md`
  - `scripts/`: install/remove scripts for Codex and Claude skill/plugin locations
  - `docs/skills/`: skill format spec and authoring best practices
  - `docs/claude/`, `docs/codex/`: agent-specific docs
  - `img/`: images used by docs
- Key entry points:
  - `readme.md`
  - `scripts/cp_skills.sh`
  - `scripts/remove_skills.sh`

## Architecture notes
- Skills are authored in-repo under `skillrena/<skill-name>/`.
- Installation copies skills into agent home directories (`~/.codex/skills/skillrena/`, `~/.claude/skills/`).
- `activating-memories` bootstraps repo-local memory docs in `agent-docs/<lang>/` and project-local memory skills in `.{AGENT_NAME}/skills/`.

## Golden paths

### Add a feature
- Typical files to touch: `skillrena/<skill-name>/SKILL.md`, optionally `references/`, `assets/`, `scripts/` under that skill.
- Required checks: validate frontmatter shape and run script syntax checks if scripts changed.

### Fix a bug / failing check
- Where checks live: script syntax (`scripts/*.sh`), skill file shape (`skillrena/*/SKILL.md`), referenced paths in skills.
- Fast loop: run one target check first (for example one script with `bash -n`).

### Performance work
- Not a core concern in this repo; keep docs concise to reduce context/token load.

## Safety / fragile areas
- `scripts/remove_skills.sh` performs `rm -rf` under `$HOME`; treat as destructive.
- Keep Codex and Claude destination paths in sync when editing install/remove behavior.
