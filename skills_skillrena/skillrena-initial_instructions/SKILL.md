---
name: skillrena-initial_instructions
description: Minimal Skillrena rules: search with rg, edit with apply_patch, keep outputs small.
---

# Skillrena: initial_instructions

- Prefer `rg` for search; restrict to files/dirs.
- Prefer `apply_patch` for edits (small diffs; avoid full-file dumps).
- Read only what you need; avoid large file pastes.
- When structured output is requested, return only that structure (no extra prose).
