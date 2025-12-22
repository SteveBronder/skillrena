---
name: onboarding-skl
description: Create baseline project memories under `.{AGENT_NAME}/skills/memories/`.
---

Goal: write short memories in `./.{AGENT_NAME}/skills/memories/` (e.g., `.claude/skills/memories/` for Claude, `.codex/skills/memories/` for Codex):

1. Create the directory if it doesn't exist: `mkdir -p .{AGENT_NAME}/skills/memories`

2. Create these memory files using the **memory header format**:

```markdown
---
type: memory
description: <what this memory contains>
mutable: true
use: session
---

<content here>
```

**Header fields:**
- `type: memory` - Identifies this as a mutable memory file (not a skill)
- `description` - Brief description of what this memory contains
- `mutable: true` - You can and should update this file when information changes
- `use: session` - Read this at session start and reference throughout

3. Create these baseline memories:

- `project_overview.md`
  - A high level overview of the project purpose, goals, and main components.
- `suggested_commands.md`
  - A list of commonly used commands for building, testing, linting, and running the project.
- `style_and_conventions.md`
  - Key coding style guidelines and conventions followed in the project.
- `task_completion_checklist.md`
  - A checklist of steps to verify when completing tasks (e.g. tests, docs, reviews).

Use `rg`/`ls`/`find` to scan docs/config; use `apply_patch` or appropriate file creation tools. Keep each memory compact.
