---
name: serena-activate_project
description: Activate a Serena project by name or path; do this before running other Serena tools.
---

# Serena: activate_project

Use this when you need Serena to “attach” to the correct repo so its file + symbol tools operate on the right codebase.

## Workflow
1. Call `activate_project` with the project name or absolute path.
2. Call `check_onboarding_performed`.
3. If onboarding is missing, run `onboarding` (and then `write_memory` as instructed).

## Tips
- Prefer activating by absolute path if multiple projects share the same name.
- After activation, use `get_current_config` to confirm the active project/modes.

