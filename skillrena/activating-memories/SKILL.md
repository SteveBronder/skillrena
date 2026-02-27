---
name: activating-memories
description: Bootstraps and loads repo-local project memories from ./agent-docs and project-local skills. Use at session start or when the user says "activate" or asks for project context.
---

<objective>
- Ensure repo-local memory docs exist under `./agent-docs/`.
- Ensure the repo has thin init/router files (`CLAUDE.md`, `AGENTS.md`, `GEMINI.md`).
- Ensure project-local skills exist (`$memories`, `$compress-memories`, `$write-memory`).
- Load only the minimum context needed for the session (anti-patterns for the language(s) in use).
</objective>

<agent_name_resolution>
Replace `{AGENT_NAME}` with the agent config directory:
- `.claude/` - Claude Code
- `.codex/` - OpenAI Codex CLI
- `.cursor/` - Cursor
- `.copilot/` - GitHub Copilot
- `.aider/` - Aider

If multiple exist, prefer the current agent's. If none exist, create one.
</agent_name_resolution>

<quick_start>
1) Resolve `{AGENT_NAME}` (see <agent_name_resolution>).

2) Check for repo-local memories:
   - Required directory: `./agent-docs/`
   - If `agent-docs/` is missing or empty, read `references/onboarding-guide.md` and run onboarding.

3) Check for required router files at repo root:
   - `CLAUDE.md`
   - `AGENTS.md`
   - `GEMINI.md`
   If any are missing, run onboarding (it will create them from templates).

4) Check for required project-local skills:
   - `./.{AGENT_NAME}/skills/memories/SKILL.md`
   - `./.{AGENT_NAME}/skills/compress-memories/SKILL.md`
   - `./.{AGENT_NAME}/skills/write-memory/SKILL.md`
   If any are missing, read `references/onboarding-guide.md` and run onboarding.

5) Determine the language(s) for this session.
   - If already stated by the user, reuse that.
   - Otherwise ask: "Which languages are we working in (e.g., 'C++ and Python', 'Go + TypeScript')?"

6) Before loading, check whether the relevant memories are over budget.
   - For each selected language `<lang>`, compute total lines across:
     - `agent-docs/<lang>/*.md`
   - If total > 500 lines for any `<lang>`, tell the user to run:
     - `$compress-memories <their language list>`
     - (After compression, recommend starting a new session.)

7) Load minimal memories for the session:
   - Run: `$memories <their language list>`

8) Continue work.
   - Use test-driven development by default (red → green → refactor).
   - If tests fail after your change, assume it's your fault until proven otherwise.
   - Reuse existing utilities before writing new helper functions.
   - When you learn durable repo-specific info, record it via: `$write-memory <short description>`.
</quick_start>

<decision_points>
- `agent-docs/` missing/empty -> read `references/onboarding-guide.md` and onboard.
- Router files missing -> onboard.
- Project-local skills missing -> onboard.
- Languages unclear -> ask user.
- Any `<lang>` memory set > 500 lines -> tell user to run `$compress-memories`.
</decision_points>

<quality_checklist>
- Load only what you need (anti-patterns first; other docs on demand).
- Prefer references, not excerpts: store file paths/commands, not large pasted blocks.
- TDD-first: tests are the default verification gate.
- Fail fast: do not suppress errors or add silent fallback code.
- Reuse-first: search common utility dirs (`utils/`, `common/`, `shared/`, `lib/`, `internal/`, `include/`) before creating new helpers.
</quality_checklist>

<failure_modes>
- `{AGENT_NAME}` unclear: list directories under `.` and choose the active one (e.g. `.codex/` or `.claude/`).
- Memories exist but language folder missing: run onboarding for that language (or ask the user to confirm the intended language name).
</failure_modes>
