---
name: activate-skl
description: Check onboarding and load memories.
---

<quick_start>
1) Check `./.{AGENT_NAME}/skills/memories/` for memory skill folders.
   - Each memory is a skill file at `./.{AGENT_NAME}/skills/memories/<name>-skl/SKILL.md`.
   - Example baseline set:
     - `project_overview-skl/SKILL.md`
     - `suggested_commands-skl/SKILL.md`
     - `style_and_conventions-skl/SKILL.md`
     - `task_completion_checklist-skl/SKILL.md`
2) If empty or missing, run `$onboarding-skl`.
3) Otherwise, read memories and proceed.
4) If you learn new info, update the relevant `<name>-skl/SKILL.md` via `write_memory-skl`.
</quick_start>

<decision_points>
- Memories missing/empty -> run $onboarding-skl.
</decision_points>

<quality_checklist>
- Each memory should be dense with high-signal, repo-specific facts.
- Prefer concrete evidence (paths, filenames, commands) over vague summaries.
- If a memory is sparse, expand it by scanning the repo and updating it.
</quality_checklist>

<failure_modes>
- `AGENT_NAME` unclear: list directories under `.` and choose the active one (e.g. `.codex/` or `.claude/`).
</failure_modes>
