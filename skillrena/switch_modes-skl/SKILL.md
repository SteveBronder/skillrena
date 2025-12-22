---
name: switch_modes-skl
description: Switch agent mode.
---

# Switch Modes

## Quick start
- Write `{ "mode": "<mode>" }` to `./.{AGENT_NAME}/state.json`.
- Confirm the active mode.

## Mode map
- `editing`: minimal, precise edits
- `interactive`: step-by-step collaboration
- `no-memories`: fully stateless
- `one-shot`: autonomous end-to-end
- `planning`: analysis-only, no edits

## Decision points
- Invalid mode -> list valid modes and ask to choose.

## Failure modes
- `AGENT_NAME` unclear: list directories under `.` and pick the active one.
- State file missing: create it.
