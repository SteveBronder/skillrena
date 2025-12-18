---
name: serena-jet_brains_find_referencing_symbols
description: Find symbol references via JetBrains indexing; use when LSP-based reference search is incomplete.
---

# Serena: jet_brains_find_referencing_symbols

Use this when `find_referencing_symbols` misses usages (common in polyglot repos, generated code, or weak language server support).

## Guidance
- Start with `jet_brains_find_symbol` to identify the exact entity.
- Use JetBrains-based references to confirm refactor impact before renames or deletions.

