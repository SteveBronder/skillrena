---
name: activate-skl
description: Activate Skillrena; check onboarding and read memories.
---

Run `if [ -d .skillrena/memories ] && [ "$(ls -A .skillrena/memories 2>/dev/null | wc -l)" -gt 0 ]; then echo 'onboarded=true'; ls -1 .skillrena/memories; else echo 'onboarded=false'; if [ -d .skillrena ]; then echo '.skillrena exists'; ls -la .skillrena; fi; fi`

2) If onboarded (`onboarded: true`)
- Use `list_memories-skl` to get the memory names.
- Read the memories (via `read_memory-skl`) and skim for: project purpose, key folders, common commands, and conventions.
- Reply with a short recap of what you learned and proceed with the user’s request.

3) If not onboarded (`onboarded: false`)
- If `.skillrena/` does not exist, create `.skillsrena/` (as requested) and then run `onboarding-skl` (which writes to `.skillrena/memories/`).
- After onboarding completes, skim the newly created memories (step 2) before proceeding.
