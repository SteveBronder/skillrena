# Project overview: skills

This repository is a collection of Codex CLI “skills” that document how to use Serena MCP tools.

## Purpose
- Provide per-tool skill prompts/instructions for Serena’s MCP toolset.

## Structure
- `skills.md`: high-level install instructions and a catalog of available skills.
- `serena-*/SKILL.md`: one folder per skill/tool; each `SKILL.md` contains the skill definition + usage guidance.
- `.serena/`: Serena project configuration/cache.

## Tech stack
- Markdown (`SKILL.md` files with YAML front matter).
- No application/runtime code (the only Python file in the root is empty).

## How it’s used
- These skill folders are intended to be copied into `~/.codex/skills/` for Codex CLI to discover and use them.
