---
name: activate-skl
description: Check onboarding and load memories.
---

Check `./.{AGENT_NAME}/skills/memories/` (e.g., `.claude/skills/memories/`).

**If memories exist**: Read them, summarize key points, proceed with request. Update via `write_memory-skl` when you learn new info.

**If empty/missing**: Run `onboarding-skl`, then read the created memories.
