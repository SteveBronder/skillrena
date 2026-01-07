---
name: task-completion-checklist
description: Checklist for making safe repo changes
---

## Before editing

- Identify whether you’re changing a skill (`skillrena/<skill>/`) vs install scripts (`scripts/`) vs docs (`docs/`) vs orchestrator plugin (`skillrena/orchestrator/`).

## When changing a skill

- Keep `skillrena/<skill>/SKILL.md` frontmatter valid (`name` matches directory, description is third person).
- If the skill references files (e.g. `references/...`), ensure paths exist and stay within the skill folder.
- Keep instructions concise and pointer-heavy (prefer file paths over large quotes).

## When changing install/remove scripts

- Verify Codex vs Claude targets remain correct (`scripts/cp_skills.sh`, `scripts/remove_skills.sh`).
- Treat `rm -rf` paths as dangerous; keep them explicit and prefixed with `$HOME`.
- Run `bash -n` on modified scripts.

## When changing the orchestrator plugin

- Update docs and metadata together (`skillrena/orchestrator/.claude-plugin/plugin.json`, `skillrena/orchestrator/commands/`).
- Keep hook dependencies in mind (`skillrena/orchestrator/hooks/orchestrator-stop-hook.sh` requires `jq` and uses `perl` for promise parsing).

## Wrap up

- `rg` for broken references after renames/moves (common patterns: `references/`, `assets/`, `scripts/`).
