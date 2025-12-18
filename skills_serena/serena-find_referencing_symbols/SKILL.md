---
name: serena-find_referencing_symbols
description: Find references to a symbol; use for impact analysis before changing or deleting code.
---

# Serena: find_referencing_symbols

Use this to discover call sites/usages of a symbol so you can estimate blast radius and update all affected code.

## Recommended workflow
1. Find the symbol first (`find_symbol` or `get_symbols_overview` for a known file).
2. Run `find_referencing_symbols` on the exact symbol/location.
3. Inspect a few representative callers before refactoring.

## Tips
- Use kind filters (where supported) to focus on relevant reference types.

