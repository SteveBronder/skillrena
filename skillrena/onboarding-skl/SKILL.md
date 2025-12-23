---
name: onboarding-skl
description: Discover project and create baseline memory skills.
---

<quick_start>
Task: Write skills in your local agent folder that will summarize key information about the project that will be high signal and ensure task success for future agents that use the skills.
The information you write must give future agents enough information to confidently understand the project in its completeness.
- Read docs, configs, entrypoints, and other important files.
- Create the baseline memory skills via `$write_memory-skl`.
  - Each memory is a skill file at `./.{AGENT_NAME}/skills/memories/<name>-skl/SKILL.md`.
  - Example baseline set:
    - `project_overview-skl/SKILL.md`
    - `suggested_commands-skl/SKILL.md`
    - `style_and_conventions-skl/SKILL.md`
    - `task_completion_checklist-skl/SKILL.md`
    - `testing_guidance-skl/SKILL.md`
- It is a **great idea** to think of other skills that would be relevant to this project
- Read as many files as you need to clearly understand the project.
</quick_start>

<must_read_files>
- Key config files (e.g., files used to compile or run the project like pyproject.toml, CMake, Make, etc.)
- `readme.md/agent.md/claude.md` at all levels of the project
- Primary entrypoints (e.g., main files)
- Dependencies for main files that are written in this project
- doc, design, and testing folders
- It is imperative you understand the testing process for the project
- Locations of common utilities used in the project.
</must_read_files>

<templates>
<memory>
<guidance>
Below are example templates you can use for the main memories.
These are non-exhaustive. You should think clearly about how to modify these to align with the overall project.
</guidance>
<project_overview>
- Purpose/goal (what this repo exists to do)
- Techstack used
- Users/stakeholders (who uses it and why)
- Primary workflows (top 3 paths a user follows)
- Architecture (high-level components and how they interact)
- Key entrypoints (main files, CLIs, services)
- Data flow (inputs -> transformations -> outputs)
- External dependencies (services/APIs/datastores)
- Repo map (top-level folders, subfolders, and what they contain)
- Known risks/constraints (performance, security, domain rules)
- common utilities
</project_overview>

<suggested_commands>
- Build commands (with expected outputs)
- Test commands (unit/integration/e2e)
- Lint/format/lsp commands
- Run/deploy commands (local, staging, prod)
- Environment setup (env vars, virtual environments, tooling versions, bootstrap)
- Helpful scripts (what they do and when to use them)
</suggested_commands>

<style_and_conventions>
- Code style (formatters, linters, naming)
- Language/framework conventions (idioms, patterns)
- File/dir conventions (where new code/tests/docs go)
- Testing style (fixtures, naming, structure)
- Error handling/logging conventions
- Documentation conventions (doc locations, templates)
</style_and_conventions>

<task_completion_checklist>
- Preconditions (inputs to confirm with user)
- Required checks (tests/lint/build)
- Review points (risk areas to double-check)
- Output validation (where to verify results)
- Rollback/recovery notes (if applicable)
</task_completion_checklist>

<testing_guidance>
- Where tests are located
- How to run tests
- Common testing patterns
- where common and shared data and fixtures for tests are located
</testing_guidance>
</memory>
</templates>

<decision_points>
- Missing docs -> ask the user for purpose and goals, then note gaps.
- Multiple entrypoints -> capture the primary ones and why.
</decision_points>

<failure_modes>
- Overlong memories: keep them compact and task-focused.
- Unclear structure: document assumptions explicitly.
</failure_modes>
