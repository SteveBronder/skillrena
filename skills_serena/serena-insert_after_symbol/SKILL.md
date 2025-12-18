---
name: serena-insert_after_symbol
description: Insert content immediately after a symbol definition; use to add related functions/classes in-place.
---

# Serena: insert_after_symbol

Use this for code insertions that should live directly after an existing symbol (e.g., helper function after the main function, sibling class, etc.).

## Workflow
1. Identify the correct symbol (`find_symbol` or `get_symbols_overview`).
2. Insert with `insert_after_symbol` using the exact `name_path` in the file.
3. Verify by re-reading the region or re-checking symbols.

## Tips
- Prefer symbol-based inserts over line-based edits to avoid line-number drift.

