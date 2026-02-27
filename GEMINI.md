# Project context (Gemini)

This repo stores durable context in `./agent-docs/`.

## Start of session

If project-local skills are missing, run:
- `$activating-memories`

Otherwise load only the language anti-patterns you need:
- `$memories We will be working in <languages>`

If you are warned that memories exceed the line budget, run:
- `$compress-memories <languages>`

## Rules

- Prefer test-driven development.
- If tests fail after your change, assume it's your fault.
- Do not hide errors with silent fallbacks.
- Reuse existing utilities before creating new helpers.
