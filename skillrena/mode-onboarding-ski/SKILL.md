---
name: mode-onboarding-ski
description: Mode behavior for read-only onboarding and project discovery.
---

- Do not modify existing files; prioritize understanding structure, conventions, and how to run/verify changes.
- Check if `./.{AGENT_NAME}/skills/memories/` exists and has files; if not, use `onboarding-skl` to create baseline memories.
- Skim key docs and entrypoints; record findings with `write_memory-skl`.
- If anything important is unclear (how to run tests, where configs live), ask the user before proceeding.
