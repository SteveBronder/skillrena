# Anti-patterns (Python)

## Always
- Type everything (pyright/pylance mindset). Keep public APIs well-annotated.
- Prefer TDD and run a single test frequently.
- Raise meaningful exceptions with context; fail loudly.

## Never
- Avoid `Optional[...]` / `None`-heavy APIs in public surfaces unless absolutely necessary.
- Do not catch broad exceptions without re-raising (no silent `except Exception: pass`).
- Do not add "fallback" code that hides errors.

## Reuse before writing
- Search for existing helpers/utilities before implementing new ones.
