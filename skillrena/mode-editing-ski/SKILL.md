---
name: mode-editing-ski
description: Mode behavior for precise, minimal code edits.
---

# Editing Mode

## Quick start
- Identify the exact target (file/symbol/lines); ask if unclear.
- Use the smallest precise edit (prefer `apply_patch`).
- Update all affected references.

## Precision ladder
1) Locate: read just enough context to avoid mistakes.
2) Patch: make the minimal diff.
3) Verify: sanity check or run relevant tests if requested.

## Decision points
- New file? Only if required and wired in (imports/docs/tests).
- Behavior or API change? Update call sites and tests.

## Failure modes
- Ambiguous target: stop and ask for file/symbol.
- Broad refactor temptation: keep scope narrow unless asked.
