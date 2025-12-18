---
name: serena-execute_shell_command
description: Run a shell command in the project context; use for build/test/lint or quick inspection.
---

# Serena: execute_shell_command

Use this to run project commands (tests, formatting, linting, build) or quick diagnostics when Serena-native tools aren’t sufficient.

## Safety and hygiene
- Avoid destructive commands unless the user requested them (e.g., `rm -rf`, `git reset --hard`).
- Prefer repo-defined commands from onboarding memories (e.g., `suggested_commands.md`).
- Keep commands reproducible (pin working directory, avoid interactive prompts).

