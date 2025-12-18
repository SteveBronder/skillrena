---
name: serena-find_file
description: Find files by name or glob under the project root; use to locate targets before reading/editing.
---

# Serena: find_file

Use this to locate candidate files quickly when you know a filename, extension, or glob pattern.

## Typical flow
1. `find_file` to get candidate paths.
2. `read_file` / `get_symbols_overview` / `search_for_pattern` to inspect and narrow.

## Tips
- Start with a narrow glob (e.g., `**/*.py`, `src/**/router*.ts`) to keep results manageable.

