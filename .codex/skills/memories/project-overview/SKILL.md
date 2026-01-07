---
name: project-overview
description: Skillrena repo purpose and layout
---

## Purpose

Skillrena is a small collection of agent “skills” intended to provide project memory and workflows without MCP server overhead (overview in `readme.md`).

## What lives where

- Skills (source): `skillrena/<skill-name>/SKILL.md`
  - Core skills: `skillrena/activating-memories/`, `skillrena/writing-memories/`, `skillrena/recording-diary/`, `skillrena/bootstrapping-design-docs/`, `skillrena/generating-subtasks/`, `skillrena/generate-modes/`
- Install/remove scripts: `scripts/cp_skills.sh`, `scripts/remove_skills.sh`
- Docs: `docs/skills/` (format/spec), `docs/claude/` (hooks/plugins refs), `docs/codex/` (slash commands)
- Assets: `img/`

## Agent integration details

- Codex install target: `~/.codex/skills/skillrena/<skill-name>/` (nested directory structure)
- Claude Code install target: `~/.claude/skills/<skill-name>/` (flat directory structure)
- The installer uses `cp -r` (see `scripts/cp_skills.sh`); Codex doesn’t currently support symlink-based skills (noted in `readme.md`)

## Orchestrator plugin

`skillrena/orchestrator/` is a Claude Code plugin:
- Metadata: `skillrena/orchestrator/.claude-plugin/plugin.json`
- Slash commands: `skillrena/orchestrator/commands/` (use `/orchestrator:design` and `/orchestrator:build`; `commands/orchestrator.md` is deprecated)
- Agents: `skillrena/orchestrator/agents/`
- Hooks: `skillrena/orchestrator/hooks/` (Stop hook script: `hooks/orchestrator-stop-hook.sh`)
