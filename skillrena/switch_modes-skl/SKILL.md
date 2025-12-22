---
name: switch_modes-skl
description: Switch agent mode.
---

<quick_start>
- Write `{ "mode": "<mode>" }` to `./.{AGENT_NAME}/state.json`.
- Confirm the active mode.
</quick_start>

<configuration>
<mode_map>
- `editing`: minimal, precise edits
- `interactive`: step-by-step collaboration
- `no-memories`: fully stateless
- `one-shot`: autonomous end-to-end
- `planning`: analysis-only, no edits
</mode_map>
</configuration>

<decision_points>
- Invalid mode -> list valid modes and ask to choose.
</decision_points>

<failure_modes>
- `AGENT_NAME` unclear: list directories under `.` and pick the active one.
- State file missing: create it.
</failure_modes>
