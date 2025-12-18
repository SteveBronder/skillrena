---
name: serena-delete_lines
description: Delete a range of lines in a file; use for precise removals when symbol tools aren’t a fit.
---

# Serena: delete_lines

Use this to remove specific line ranges (e.g., dead code blocks) when a symbol-level edit is not practical.

## Best practices
- Read nearby context first (`read_file`) so you delete the correct range.
- Prefer deleting the smallest range possible to minimize line-number drift.
- After deletion, re-read the surrounding section to verify formatting/indentation.

