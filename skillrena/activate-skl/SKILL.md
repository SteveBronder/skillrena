---
name: activate-skl
description: Check onboarding and load memories.
---

# Activate

## Quick start
1) Check `./.{AGENT_NAME}/skills/memories/` for memory skill folders.
   - Each memory is a skill file at `./.{AGENT_NAME}/skills/memories/<name>-skl/SKILL.md`.
   - Example baseline set:
     - `project_overview-skl/SKILL.md`
     - `suggested_commands-skl/SKILL.md`
     - `style_and_conventions-skl/SKILL.md`
     - `task_completion_checklist-skl/SKILL.md`
2) If empty or missing, run `onboarding-skl`.
3) Otherwise, read memories, summarize key points, proceed.
4) If you learn new info, update the relevant `<name>-skl/SKILL.md` via `write_memory-skl`.

## Decision points
- Memories missing/empty -> run onboarding.
- Memories present but stale -> refresh the relevant `<name>-skl/SKILL.md` via `write_memory-skl`.
- User requests stateless work -> ask whether to switch to `mode-no-memories-ski`.

## Summary template
Use this to summarize what you read before proceeding.
- Purpose/goal:
- Main components:
- Key commands:
- Style/conventions:
- Verification checklist:

## Memory quality bar
- Each memory should be dense with high-signal, repo-specific facts.
- Prefer concrete evidence (paths, filenames, commands) over vague summaries.
- If a memory is sparse, expand it by scanning the repo and updating it.

## Memory templates (verbose)
These are the expected contents when you update or create memory skills (`./.{AGENT_NAME}/skills/memories/<name>-skl/SKILL.md`). If any section is unknown, note it and add where to find it.

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

## Failure modes
- `AGENT_NAME` unclear: list directories under `.` and choose the active one (e.g. `.codex/` or `.claude/`).
- Memories too long: summarize only the parts relevant to the current task.
