# Project-local switching-modes stub (optional)

Use this file as a starting point when creating `./.{AGENT_NAME}/skills/switching-modes/SKILL.md` to ensure `$switching-modes <mode>` works in projects where a global switching skill is unavailable or does not enumerate project-specific modes.

## SKILL.md skeleton

Copy the following into `./.{AGENT_NAME}/skills/switching-modes/SKILL.md`, then edit the **Mode registry** section to include any additional modes.

```yaml
---
name: switching-modes
description: Switch the agent between behavioral modes by updating `./.{AGENT_NAME}/state.json`.
---

# Switching modes

## Quick start

Run: `$switching-modes <mode-name>`.

This writes `./.{AGENT_NAME}/state.json` with:

```json
{ "mode": "<mode-name>" }
```

## Mode registry

Baseline modes (if used in this project):

* `planner` (general planning)
* `debugger` (general debugging)
* `qa-tester` (general verification)

Project modes:

* `{slug}-mode-planner`
* `{slug}-mode-debugger`
* `{slug}-mode-qa-tester`

## Behavior

1. Validate the requested mode name is non-empty.
2. Write or update `./.{AGENT_NAME}/state.json` as JSON with a single key `mode`.
3. Confirm the active mode.

## Guardrails

* Never write outside `./.{AGENT_NAME}/` for mode state.
* If multiple agent folders exist (e.g. `.claude` and `.codex`), ask which one to use.
```
