---
name: skillrena-insert_at_line
description: Insert content at a 0-based line index (push existing lines down).
---

# Skillrena: insert_at_line

Input: `relative_path`, `line` (0-based), `content`.
- Read a small window around `line` to anchor the patch.
- Insert via `apply_patch`; ensure `content` ends with `\n`.
Reply `Success.` only.
