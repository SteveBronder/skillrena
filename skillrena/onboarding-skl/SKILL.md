---
name: onboarding-skl
description: Discover project and create baseline memory skills.
---

# Onboarding

## Quick start
- Read docs, configs, and entrypoints.
- Create the baseline memory skills via `write_memory-skl`.
  - Each memory is a skill file at `./.{AGENT_NAME}/skills/memories/<name>-skl/SKILL.md`.
  - Example baseline set:
    - `project_overview-skl/SKILL.md`
    - `suggested_commands-skl/SKILL.md`
    - `style_and_conventions-skl/SKILL.md`
    - `task_completion_checklist-skl/SKILL.md`

## Discovery checklist
- `readme.md` and top-level docs
- `docs/` or `design/` folders
- `scripts/` (build/test/run)
- Primary entrypoints (e.g., main files)
- Key config files (e.g., package/pyproject/Makefile)

## Memory templates (verbose)
If any section is unknown, note it and add where to find it.

### project_overview-skl/SKILL.md
- Purpose/goal (what this repo exists to do)
- Users/stakeholders (who uses it and why)
- Primary workflows (top 3 paths a user follows)
- Architecture (high-level components and how they interact)
- Key entrypoints (main files, CLIs, services)
- Data flow (inputs -> transformations -> outputs)
- External dependencies (services/APIs/datastores)
- Repo map (top-level folders and what they contain)
- Known risks/constraints (performance, security, domain rules)

### suggested_commands-skl/SKILL.md
- Build commands (with expected outputs)
- Test commands (unit/integration/e2e)
- Lint/format commands
- Run/deploy commands (local, staging, prod)
- Environment setup (env vars, tooling versions, bootstrap)
- Helpful scripts (what they do and when to use them)

### style_and_conventions-skl/SKILL.md
- Code style (formatters, linters, naming)
- Language/framework conventions (idioms, patterns)
- File/dir conventions (where new code/tests/docs go)
- Testing style (fixtures, naming, structure)
- Error handling/logging conventions
- Documentation conventions (doc locations, templates)

### task_completion_checklist-skl/SKILL.md
- Preconditions (inputs to confirm with user)
- Required checks (tests/lint/build)
- Review points (risk areas to double-check)
- Output validation (where to verify results)
- Rollback/recovery notes (if applicable)

## Decision points
- Missing docs -> ask the user for purpose and goals, then note gaps.
- Multiple entrypoints -> capture the primary ones and why.

## Failure modes
- Overlong memories: keep them compact and task-focused.
- Unclear structure: document assumptions explicitly.
