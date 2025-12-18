---
name: serena-get_symbols_overview
description: Get a high-level map of top-level symbols in a file; use before diving into unfamiliar code.
---

# Serena: get_symbols_overview

Use this as a fast “table of contents” for a file so you can navigate without reading the entire file.

## Workflow
1. Call `get_symbols_overview` with the file path.
2. Increase `depth` to include children (e.g., methods on a class).
3. Use `find_symbol` / `read_file` only after you’ve identified the relevant area.

