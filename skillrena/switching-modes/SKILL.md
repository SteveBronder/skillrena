---
name: switching-modes
description: Changes the agent's operating mode between editing, planning, interactive, one-shot, and no-memories modes. Use when the user requests a different collaboration style or says "switch mode".
---

<quick_start>
- Write `{ "mode": "<mode>" }` to `./.{AGENT_NAME}/state.json`.
- Read the appropriate mode behavior from `assets/<mode>.md`.
- Confirm the active mode.
</quick_start>

<configuration>
<mode_map>
- `editing`: minimal, precise edits -> read `assets/editing.md`
- `interactive`: step-by-step collaboration -> read `assets/interactive.md`
- `no-memories`: fully stateless -> read `assets/no-memories.md`
- `one-shot`: autonomous end-to-end -> read `assets/one-shot.md`
- `planning`: analysis-only, no edits -> read `assets/planning.md`
</mode_map>
</configuration>

<decision_points>
- Invalid mode -> list valid modes and ask to choose.
</decision_points>

<failure_modes>
- `AGENT_NAME` unclear: list directories under `.` and pick the active one.
- State file missing: create it.
</failure_modes>
