# Anti-patterns (general)

## Tests are truth
- If tests fail after your change, assume it's your fault until proven otherwise.
- Prefer TDD (red → green → refactor).

## Never hide failures
- Do not suppress errors.
- Do not add "fallback" code that silently changes behavior or masks a bug.
- Fail fast and loudly so problems can be debugged.

## Strong typing when possible
- Prefer strong types / explicit interfaces in every language you touch.

## Reuse before writing
- Before writing a new helper, search for existing utilities (`utils/`, `common/`, `shared/`, `lib/`, `internal/`, `include/`, `pkg/`, `tools/`).
- If you add a new utility, make it discoverable and add tests.

## Keep memories lean
- Prefer references (paths/commands) over pasted excerpts.
