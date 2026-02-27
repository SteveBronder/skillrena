# Project agent instructions (router)

This repo stores durable, repo-local context in `./agent-docs/`.

## Start of session

If project-local skills are not present yet, run:
- `$activating-memories`

Otherwise load only the language anti-patterns you need:
- `$memories We will be working in <languages>`
  - Example: `$memories We will be working in C++ and Python`

If you are warned that memories exceed the line budget, run:
- `$compress-memories <languages>`

## Non-negotiable rules

- Work test-first whenever possible (red → green → refactor).
- If tests fail after your change, assume it's your fault until proven otherwise.
- Do not hide errors with silent fallbacks; fail fast and loudly.
- Reuse existing utilities before writing new helper functions.
- Per-language docs: `agent-docs/<lang>/...`
