---
name: activating-memories
description: Loads project-specific memories at session start and triggers onboarding for new projects. Use when starting a new coding session or when the user says "activate" or asks about project context.
---

- Check Memory Existence: Look in ./.{AGENT_NAME}/skills/memories/ for any existing memory skill files.
- If memory files are present and contain content:
  - Load each memory skill (e.g. project-overview, suggested-commands, etc.) so the agent can use them for context.
  - Proceed with normal operation (since the project has already been onboarded and memories are available).
- If no memory files exist, or if they are empty:
  - Initiate the onboarding process by invoking the onboarding skill.
  - Delegate all in-depth codebase analysis and memory generation to the onboarding skill (do not replicate that logic here).
- Note: This activation skill remains concise and defers detailed repository inspection to the onboarding process, avoiding any redundancy with onboarding logic.
