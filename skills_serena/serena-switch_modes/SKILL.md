---
name: serena-switch_modes
description: Activate one or more Serena modes; use to change behavior according to available mode configs.
---

# Serena: switch_modes

Use this to enable modes that alter Serena’s behavior (available modes depend on your Serena installation/config).

## Workflow
1. Use `get_current_config` to see what modes are available/active.
2. Call `switch_modes` with a list of mode names.
3. Re-check `get_current_config` to confirm activation.

## Notes
- Modes are defined by Serena config files (often YAML) and may be version-specific.

