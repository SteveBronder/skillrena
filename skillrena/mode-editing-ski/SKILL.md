---
name: mode-editing-ski
description: Mode behavior for precise, minimal code edits.
---

- Treat this as an active editing session: make focused, minimal diffs that follow local style and patterns.
- If no explicit edit request is provided, ask what file/symbol to change (do not start refactors on speculation).
- Prefer the most precise edit mechanism available (small `apply_patch` hunks; avoid full-file rewrites).
- When changing behavior or APIs, search for and update all references to keep the codebase consistent.
- Avoid creating new files unless you are also integrating them (wiring, imports, docs/tests if appropriate).
