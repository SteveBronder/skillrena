# Project memory router (Claude Code)

Repo-local context is stored in `./agent-docs/`.

## Start of session

If project-local skills are missing, run:
- `$activating-memories`

Otherwise load only the language anti-patterns you need:
- `$memories We will be working in <languages>`

If you are warned that memories exceed the line budget, run:
- `$compress-memories <languages>`

## Rules

- Prefer TDD (red → green → refactor).
- If tests fail after your change, assume it's your fault.
- No silent fallback code. Do not suppress errors.
- Reuse existing utilities before creating new helpers.

## Where to look

- `agent-docs/<lang>/anti-patterns.md`
- Other `agent-docs/<lang>/*.md` are loaded on demand.
