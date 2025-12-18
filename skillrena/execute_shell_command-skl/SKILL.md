---
name: execute_shell_command-skl
description: Run a short, safe shell command and return its output.
---

- Only run short, non-interactive commands.
- Avoid destructive commands unless explicitly requested.
- Prefer repo root as `cwd`; validate `cwd` exists.
- Return stdout (and stderr if relevant) with minimal commentary.
