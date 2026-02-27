# Onboarding (agent-docs)

This guide helps an agent analyze a new repository and create **repo-local memory documents** under `./agent-docs/`.

These docs are intentionally modular so the agent only reads what it needs (anti-patterns first; other docs on demand).

## What gets created

### 1) Repo-root init/router files (thin)

Create these at repo root if missing:
- `CLAUDE.md`
- `AGENTS.md`
- `GEMINI.md`

Templates live in:
- `assets/router-CLAUDE.md`
- `assets/router-AGENTS.md`
- `assets/router-GEMINI.md`

### 2) Repo-local memory docs

Per-language folder (created for each language in use):
- `agent-docs/<lang>/project-overview.md`
- `agent-docs/<lang>/suggested-commands.md`
- `agent-docs/<lang>/style-and-conventions.md`
- `agent-docs/<lang>/testing-guidance.md`
- `agent-docs/<lang>/anti-patterns.md`

Defaults we always support:
- `cpp`, `python`, `go`, `js`, `ts`, `rust`, `r`

If the user names another language, web-search best practices for that language (error handling, typing, test tooling, formatting) and create the same 5 core files.

Templates live in:
- `assets/agent-docs-templates/`

### 3) Project-local skills (written into the repo)

Create these under `./.{AGENT_NAME}/skills/`:
- `./.{AGENT_NAME}/skills/memories/SKILL.md`
- `./.{AGENT_NAME}/skills/compress-memories/SKILL.md`
- `./.{AGENT_NAME}/skills/write-memory/SKILL.md`

Templates live in:
- `assets/skills/memories-template.md`
- `assets/skills/compress-memories-template.md`
- `assets/skills/write-memory-template.md`

## Global rules

- **References, not excerpts**: store file paths, command lines, config file names, and tiny summaries. Do not paste large blocks of code into `agent-docs`.
- **TDD-first**: prefer red → green → refactor. Tests are the default verification gate.
- **Assume failing tests are your fault** until proven otherwise.
- **Fail fast**: do not suppress errors or add silent fallback code.
- **Reuse-first**: before adding helpers, search for existing utilities (`utils/`, `common/`, `shared/`, `lib/`, `internal/`, `include/`, `pkg/`, `tools/`). Record where reusable utilities live.
- **No destructive actions during onboarding**: onboarding should only read files.
- **No secrets**: never copy credentials/keys into docs.

## Step 0: Resolve `{AGENT_NAME}`

Pick the agent config dir for this repo:
- `.claude/`, `.codex/`, `.cursor/`, `.copilot/`, `.aider/`

If multiple exist, prefer the current agent. If none exist, create one.

## Legacy migration (from memory-skill folders)

If the repo already has the old-style memory skill folders under `./{AGENT_NAME}/skills/memories/` (e.g. `project-overview/SKILL.md`), migrate them:

1) Read the legacy SKILL.md files and extract only durable facts (paths, commands, conventions, pitfalls).
2) Merge the content into the new `agent-docs` core files for the appropriate language(s).
3) Delete the legacy memory-skill folders after successful migration (git history is the archive).

Then proceed with the steps below.

## Step 1: Confirm the language(s)

If the user hasn’t already said, ask:
- `$ask-user: Which languages are we working in for this repository (e.g., 'C++ and Python', 'Go + TypeScript')?`

Parse the user response into one or more language folders:
- `C++` → `cpp`
- `Python` → `python`
- `Go` → `go`
- `JavaScript` → `js`
- `TypeScript` → `ts`
- `Rust` → `rust`
- `R` → `r`

If the language is unfamiliar, web-search best practices and seed the 5 core files anyway.

## Step 2: Create repo-root router files

If missing, create:
- `AGENTS.md` from `assets/router-AGENTS.md`
- `CLAUDE.md` from `assets/router-CLAUDE.md`
- `GEMINI.md` from `assets/router-GEMINI.md`

Keep them short.

## Step 3: Create `agent-docs/` structure

Create:
- `agent-docs/<lang>/` for each selected language

Seed `agent-docs/<lang>/anti-patterns.md` from:
- `assets/agent-docs-templates/anti-patterns/general.md`

For each language folder, create the 5 core docs:
- `project-overview.md` from `assets/agent-docs-templates/project-overview.md`
- `suggested-commands.md` from `assets/agent-docs-templates/suggested-commands.md`
- `style-and-conventions.md` from `assets/agent-docs-templates/style-and-conventions.md`
- `testing-guidance.md` from `assets/agent-docs-templates/testing-guidance.md`
- `anti-patterns.md` from the matching language template in `assets/agent-docs-templates/anti-patterns/`

Idempotency:
- If a target file already exists, update/merge rather than overwriting.

## Step 4: Create project-local skills

Create directories:
- `./.{AGENT_NAME}/skills/memories/`
- `./.{AGENT_NAME}/skills/compress-memories/`
- `./.{AGENT_NAME}/skills/write-memory/`

Copy the templates into place as `SKILL.md`.

Idempotency:
- If a `SKILL.md` already exists, do not overwrite silently.

## Step 5: Repo scan (read-only) to fill docs

Scan, in this order:
1) Top-level docs: `README*`, `docs/`, `CONTRIBUTING*`, `design/`, `Makefile`, `justfile`.
2) Build + dependency files:
   - C++: `CMakeLists.txt`, `meson.build`, `conanfile.*`, `vcpkg.json`
   - Python: `pyproject.toml`, `requirements*.txt`, `tox.ini`, `noxfile.py`
   - Go: `go.mod`
   - JS/TS: `package.json`, `tsconfig.json`, lockfiles
   - Rust: `Cargo.toml`
   - R: `DESCRIPTION`, `renv.lock`
3) CI config: `.github/workflows/`, etc. (best source of canonical commands)
4) Tests layout + runners: `tests/`, `test/`, `spec/` and framework configs
5) Utility folders: `utils/`, `common/`, `shared/`, `lib/`, `internal/`, `include/`, `pkg/`, `tools/`

If the purpose or how to run tests locally is unclear:
- `$ask-user: What is the main purpose of this project and how do you run tests locally?`

## Step 6: Populate the 5 core docs per language

Minimum requirements:
- `suggested-commands.md` MUST include:
  - how to run *all tests*
  - how to run a *single test fast* (tight TDD loop)
  - lint/format/typecheck commands (when applicable)
- `testing-guidance.md` MUST include:
  - test framework + where config lives
  - how to reproduce CI failures locally
  - safety notes (avoid touching prod/external systems)
- `style-and-conventions.md` MUST include:
  - formatting/lint/typecheck tools
  - naming conventions
  - **utility reuse map**: where to find existing helpers (with concrete paths)
- `anti-patterns.md` MUST be tailored:
  - C++: note allowed C++ standard (e.g. C++23) and enforce repo-specific constraints
  - Python: emphasize strict typing workflow (pyright/pylance)

## Step 7: Wrap up

- Run `$memories <language list>` to load only anti-patterns.
- If `agent-docs/<lang>/*.md` exceeds 500 lines, tell the user to run:
  - `$compress-memories <language list>`
- After heavy onboarding or compression, recommend starting a new session.
