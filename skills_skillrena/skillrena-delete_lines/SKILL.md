---
name: skillrena-delete_lines
description: Delete a 0-based inclusive line range (after verifying with a read).
---

# Skillrena: delete_lines

Input: `relative_path`, `start_line`, `end_line` (0-based; inclusive).
- Read the same range (or a tiny window) first to confirm correctness.
- Delete via `apply_patch` using tight context.
Reply `Success.` only.
