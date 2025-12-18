---
name: serena-restart_language_server
description: Restart Serena’s language server; use when symbol search/refactoring results are stale or incorrect.
---

# Serena: restart_language_server

Use this when Serena’s LSP-backed operations behave inconsistently (missing symbols, wrong references) after external edits or tool crashes.

## When to use
- After large edits made outside Serena tooling.
- When `find_symbol` results look obviously outdated.

