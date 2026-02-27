# Anti-patterns (R)

## Always
- Prefer reproducible environments (e.g., `renv`) when present.
- Prefer tests for behavior changes when the repo supports them.

## Never
- Do not hide warnings/errors that indicate broken data or incorrect assumptions.
- Do not add silent fallbacks.

## Reuse before writing
- Search for existing utility functions/scripts before adding new ones.
