---
name: skillrena-replace_lines
description: Replace a 0-based inclusive line range with new content (after verifying).
---

# Skillrena: replace_lines

Input: `relative_path`, `start_line`, `end_line` (0-based; inclusive), `content`.
- Read the range first to confirm.
- Replace via `apply_patch`; ensure `content` ends with `\n`.
Reply `Success.` only.
