# Anti-patterns (TypeScript)

## Always
- Keep typechecking strict; prefer precise types over wide unions.
- Prefer tests + typecheck as completion gates.

## Never
- Do not introduce `any` or suppress TS errors to "make it compile".
- Do not swallow errors or add silent fallbacks.

## Reuse before writing
- Search for existing types/utilities first.
