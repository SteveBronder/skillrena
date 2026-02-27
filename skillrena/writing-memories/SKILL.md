---
name: writing-memories
description: Deprecated. Memories are now stored as markdown docs under ./agent-docs and updated via the project-local $write-memory skill created by $activating-memories.
---

<quick_start>
- Do not create memory *skills* under `./.{AGENT_NAME}/skills/memories/`.
  - That directory is now reserved for the project-local `$memories` skill.
- To update durable project memories, use:
  - `$write-memory <what to remember>`
- To record session notes, use:
  - `$recording-diary` (writes to `agent-docs/diary/`).
</quick_start>

<decision_points>
- If `agent-docs/` is missing, run `$activating-memories` to onboard.
</decision_points>

<failure_modes>
- If a tool or user workflow still expects old memory skills, migrate their content into `agent-docs/<lang>/*.md` and delete the old memory skill folders.
</failure_modes>
