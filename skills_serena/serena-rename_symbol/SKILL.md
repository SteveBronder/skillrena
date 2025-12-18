---
name: serena-rename_symbol
description: Rename a symbol across the codebase using language-server refactoring; use for safe project-wide renames.
---

# Serena: rename_symbol

Use this for refactors where you need all definitions and references updated consistently.

## Workflow
1. Locate the exact symbol (`find_symbol`) and ensure you’re targeting the right overload/definition.
2. Run `rename_symbol` with the correct `name_path` and `relative_path`.
3. Re-run `find_symbol`/`find_referencing_symbols` to confirm the rename landed everywhere.
4. Run the project’s tests/linters if available.

## Tips
- Avoid renaming public APIs without user confirmation; it can be breaking.

