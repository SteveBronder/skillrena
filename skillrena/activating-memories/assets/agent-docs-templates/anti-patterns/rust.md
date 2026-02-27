# Anti-patterns (Rust)

## Always
- Prefer explicit `Result` error handling with context.
- Prefer tests for behavior changes; keep a fast local loop (`cargo test`).

## Never
- Do not `unwrap()` / `expect()` in library code unless the invariant is truly guaranteed.
- Do not hide errors with silent fallbacks.

## Reuse before writing
- Prefer existing helpers/modules before creating new ones.
