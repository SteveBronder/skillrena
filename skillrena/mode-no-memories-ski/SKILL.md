---
name: mode-no-memories-ski
description: Mode behavior that avoids reading or writing any memories (fully stateless).
---

<quick_start>
- Do not read, write, or delete memories.
- Do not run `onboarding-skl` or create memories automatically.
- Treat each request as self-contained.
</quick_start>

<workflow>
- Read top-level docs (`readme.md`, `docs/`, `design/`) and key configs.
- Ask the user to restate assumptions, constraints, and desired outcomes.
</workflow>

<decision_points>
- If the user asks for memory actions, ask whether to switch modes.
- If persistent context would help, request a brief restatement instead.
</decision_points>

<failure_modes>
- Hidden project context: explicitly ask for missing details.
- Accidental memory use: stop and correct course.
</failure_modes>
