# Anti-patterns (C++)

## Always
- Prefer TDD: write/adjust a failing test first.
- Prefer strong types over loose primitives.
- Prefer modern C++ features allowed by this repo (e.g., C++23) over legacy patterns.
- Prefer templates + concepts (C++20+) when they improve safety/clarity.

## Never
- Do not use `std::optional`.
- Do not design nullable pointer APIs:
  - no pointer arguments with a default of null
  - no pointer returns that can be null
- Do not suppress errors or "make it pass" with silent fallbacks.
- Do not ignore failing tests; assume your change caused it.

## Error handling
- Prefer exceptions if the project allows them.
- Otherwise prefer `std::expected<T, E>` and explicit error types.
- Prefer references/value types for success paths.

## Reuse before writing
- Before creating a new helper, search common utility folders and reuse existing functions.
