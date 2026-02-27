# Anti-patterns (Go)

## Always
- Keep error handling explicit; wrap errors with context.
- Prefer TDD and keep tests runnable locally (`go test ./...` plus focused runs).

## Never
- Do not ignore returned errors.
- Do not add silent fallbacks; prefer explicit failures with context.

## Reuse before writing
- Reuse existing helpers in `internal/`, `pkg/`, `tools/`, etc.
