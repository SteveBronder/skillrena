---
name: serena-replace_lines
description: Replace a specific range of lines with new content; use for controlled edits when symbol tools can’t target.
---

# Serena: replace_lines

Use this to rewrite a known line span while keeping the rest of the file intact.

## Best practices
- Read context before replacing (`read_file`) and confirm the line numbers.
- Keep replacements minimal and well-scoped.
- Re-read after replacement to verify formatting and correctness.

