---
name: switch_modes-skl
description: Persist active modes to `.skillrena/state.json` (prompt-only; no tool gating).
---

Input: `modes` (list of strings).
- Ensure `.skillrena/` exists.
- Write/overwrite `.skillrena/state.json` with `{ "modes": [...] }`.
- Reply with a 1-line confirmation listing active modes.
