---
name: testing-guidance
description: How to sanity-check Skillrena scripts and skills
---

## What testing looks like here

This repo is mostly Markdown skills plus a few Bash scripts; there’s no dedicated automated test harness in-tree.

## Basic checks

- Bash syntax: `bash -n scripts/cp_skills.sh scripts/remove_skills.sh`
- Optional: run `shellcheck` if available (not bundled here)
- Skill integrity:
  - `SKILL.md` exists for each skill directory (`find skillrena -maxdepth 2 -name SKILL.md -print`)
  - Frontmatter `name` matches directory (spec: `docs/skills/specification.md`)

## Orchestrator plugin checks

- Hook behavior tests (manual): `skillrena/orchestrator/TESTING.md`
- Stop hook implementation: `skillrena/orchestrator/hooks/orchestrator-stop-hook.sh`
  - Requires `jq` (parsing hook input + transcript JSONL)
  - Uses `perl` for `<promise>...</promise>` extraction
