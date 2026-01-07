# Onboarding

This guide helps an agent analyze a new codebase and create repo-local "memory" skills under `./.{AGENT_NAME}/skills/memories/` for future sessions.

## Core memories created

Each memory is written to `./.{AGENT_NAME}/skills/memories/<name>/SKILL.md`:

- `project-overview`
- `suggested-commands`
- `style-and-conventions`
- `task-completion-checklist`
- `testing-guidance`

If the repository is large or complex, create additional (optional) memories for distinct components/domains.

## Guidelines (apply to all memories)

- Use pointers, not quotes: prefer file names/paths/line numbers over large excerpts.
- Ask for missing info: if key details aren't in-repo, use `$ask-user` instead of guessing.
- High signal, low noise: include concrete, repo-specific facts (important modules, key scripts, config entry points).
- Avoid destructive actions: onboarding should only read files; flag any destructive scripts/commands you find.
- Avoid secrets: never copy credentials/keys into memories; just note where configuration lives.

## Step 1: Preliminary repository scan (shared)

- Read top-level docs and entry points (`README*`, `docs/`, install guides, `Makefile`, etc.).
- Identify configuration and environment requirements (`.env*`, YAML/JSON configs, `settings.*`, etc.).
- Determine languages/frameworks from build files (e.g., `pyproject.toml`, `package.json`, `pom.xml`, `go.mod`) and locate primary entry points (CLI main, server entry, Dockerfile `ENTRYPOINT`, etc.).
- Map the high-level structure (major directories like `src/`, `tests/`, `docs/`, `scripts/`).
- Gauge complexity (monorepo/multi-service) and decide whether extra memories are warranted.
  - Examples:
    - A monorepo with multiple services may benefit from separate memories for each service.
    - A complex application with distinct modules may require individual memories for each module's context.
    - A project with that works over databases may need a specific `database-overview` or `database-utils` memory.
    - Projects with multiple languages may need specific `project-overview`, `suggested-commands`, `style-and-conventions`, and `testing-guidance`
      - For example, If a package has `C++` and `python` you should create the following files
        - `project-overview`,
        - `cpp-project-overview`
        - `cpp-suggested-commands`
        - `cpp-style-and-conventions`
        - `cpp-testing-guidance`
        - `python-project-overview`
        - `python-suggested-commands`
        - `python-style-and-conventions`
        - `python-testing-guidance`
- If purpose/how-to-run is unclear, stop and ask: `$ask-user: What is the main purpose of this project and how do you run it locally?`

## Memory: `project-overview`

Goal: give a newcomer (or future agent) a durable, high-level understanding of what the project is and how it's organized.

Include:

- **Project purpose & domain**: what it does (paraphrase README).
- **Architecture & key components**: major modules/layers and how they interact; point to key directories/files.
- **Tech stack & dependencies**: major frameworks/libraries and notable versions (when discoverable).
- **Notable patterns/decisions**: e.g. repo pattern, retry wrappers, plugin system; point to where it's implemented.
- **Golden paths** (use repo-specific examples):
  - Adding a feature (what files typically change, where to add new code)
  - Fixing a bug/failing test (where tests live, how to trace failures, when to add a new test)
  - Performance work (hot spots, profiling/benchmarks if present)
  - CLI extension (if applicable) or another common repo workflow
- **Failure awareness**: fragile areas, external integrations, concurrency/complex logic, "DO NOT run in prod" sections, destructive scripts.

Save to `./.{AGENT_NAME}/skills/memories/project-overview/SKILL.md`.

## Memory: `suggested-commands`

Goal: provide a quick reference for setup/dev/test/build/deploy commands.

Include:

- **Setup & dev**: install deps, bootstrap steps (db init/migrate/seed), start dev server, required env vars.
- **Testing**: unit/integration/e2e commands; lint/format; typecheck/static analysis; other QA tools.
- **Build & deploy**: build/package commands, docker build/run, release/deploy scripts, migration commands (with safety notes).
- **Utilities**: docs generation, dev shells, cache clearing, cleanup scripts.

For each command, add a brief "what it does" description. Source commands from `README*`, `Makefile`, `package.json` scripts, CI config, and `scripts/`.

If an expected command is missing/unclear, ask: `$ask-user: I didn't find a test/build command. How do you run it here?`

Save to `./.{AGENT_NAME}/skills/memories/suggested-commands/SKILL.md`.

## Memory: `style-and-conventions`

Goal: help future changes match existing project style.

Include:

- Formatting tools and configs (e.g. Prettier/ESLint, Black/Flake8, gofmt, rustfmt).
- Naming conventions (classes/functions/files/constants).
- Project structure conventions (where new code should go; file suffixes/patterns).
- Commenting/doc conventions (docstrings/JSDoc/Sphinx/etc.).
- Git/workflow conventions (branching/commit style) if explicitly documented.
- Testing conventions (naming/layout) from a style perspective.
- Framework-specific conventions (Django/Rails/etc.) if relevant.

Prefer pointers to examples (e.g. "see `CONTRIBUTING.md` for commit rules", "pattern matches files X/Y"). If you're unsure, note uncertainty or ask `$ask-user`.

Save to `./.{AGENT_NAME}/skills/memories/style-and-conventions/SKILL.md`.

## Memory: `task-completion-checklist`

Goal: a project-tailored "done" checklist for features/bugfixes.

Start with a checklist like:

- Testing: run existing tests; add/update tests for changes.
- Code quality: run linters/formatters/typecheck.
- Docs: update `README`/docs/docstrings/CHANGELOG as needed.
- Versioning/release: bump version/changelog if applicable.
- Review: self-review for correctness/security/perf/maintainability.
- Deploy/ops: migrations, env var changes, cache clears, etc.
- Backup/rollback: plan for risky changes (feature flag, rollback steps).

Make items imperative (and consider `- [ ]` checkboxes). Tailor to the repo (e.g., CI requirements).

Save to `./.{AGENT_NAME}/skills/memories/task-completion-checklist/SKILL.md`.

## Memory: `testing-guidance`

Goal: teach future agents how to run/write tests safely in this repo.

Include:

- How to run tests (exact commands; tiers like unit/integration/e2e).
- Testing framework/tools and where config lives (`pytest.ini`, `jest.config.js`, custom runners, etc.).
- Test organization (folders/layout) and example tests to follow.
- Writing new tests: shared fixtures/utilities, edge cases, coverage expectations if present.
- Test environment/data: DB/docker-compose/test env vars, mocks/stubs preferred for external services.
- Debugging failures: verbose reruns, debugging tips, checking history (`git blame`), matching CI locally.
- Safety: ensure tests don't touch production data or real external systems; call out destructive scripts/tests if present.
- Optional: perf/load/security testing practices if the repo has them.

Save to `./.{AGENT_NAME}/skills/memories/testing-guidance/SKILL.md`.

## Optional: additional memories

If the repo has distinct subsystems (monorepo services, complex domains), add extra memories (e.g. `frontend-overview`, `database-schema`, `api-endpoints`) when they add real navigation value.

- Avoid overlap with `project-overview`; cross-reference instead.
- Keep the count small; ask if you're unsure: `$ask-user: Would you like a dedicated memory for <topic>?`

Save to `./.{AGENT_NAME}/skills/memories/<topic>/SKILL.md`.

## Wrap up

- Review each memory for accuracy and clarity; ensure all promised details are included.
- Re-check for sensitive information (don't include secrets).
- Do a final sweep for docs you missed (`CONTRIBUTING.md`, developer guides, etc.).
- Confirm all files exist under `./.{AGENT_NAME}/skills/memories/<name>/SKILL.md`.
- Output a short completion message listing created memories.
