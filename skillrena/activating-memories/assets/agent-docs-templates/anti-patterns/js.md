# Anti-patterns (JavaScript)

## Always
- Prefer tests for behavior changes; keep a focused test loop.
- Handle async failures explicitly (await promises; propagate errors).

## Never
- Do not swallow errors in `catch` without rethrowing/asserting/logging.
- Do not add silent fallbacks or "best-effort" code that hides failures.

## Reuse before writing
- Search for existing utilities/helpers first.
