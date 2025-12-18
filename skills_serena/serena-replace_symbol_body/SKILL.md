---
name: serena-replace_symbol_body
description: Replace a symbol’s full definition; use for full rewrites after you’ve retrieved the current body.
---

# Serena: replace_symbol_body

Use this when you want to rewrite an entire function/class/method definition in one go.

## Workflow
1. Retrieve the symbol body first (e.g., `find_symbol` with body included).
2. Make a complete, self-contained replacement (signature + body).
3. Validate by re-checking symbols and running relevant tests.

## Notes
- Avoid using this if you’re unsure what the tool considers the “body”; use smaller edits instead.

