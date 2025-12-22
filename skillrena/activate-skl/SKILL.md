---
name: activate-skl
description: Activate Skillrena; check onboarding and read memories.
---

Look for your local memories folder at `./.{AGENT_NAME}/skills/memories/` (e.g., `.claude/skills/memories/` for Claude, `.codex/skills/memories/` for Codex).

Example check:
```bash
AGENT_DIR=".{AGENT_NAME}"  # Replace with your agent name (e.g., .claude or .codex)
if [ -d "$AGENT_DIR/skills/memories" ] && [ "$(ls -A "$AGENT_DIR/skills/memories" 2>/dev/null | wc -l)" -gt 0 ]; then
  echo 'onboarded=true'
  ls -1 "$AGENT_DIR/skills/memories"
else
  echo 'onboarded=false'
fi
```

## Understanding Memory Files

Memory files have this header format:
```markdown
---
type: memory
description: <what this memory contains>
mutable: true
use: session
---
```

**What the header fields mean for you:**
- `type: memory` - This is a memory file, not a skill instruction
- `mutable: true` - You can and should update this file when you learn new information
- `use: session` - Reference this throughout your session; it contains context you need

## If onboarded (`onboarded: true`)
- List files in `./.{AGENT_NAME}/skills/memories/` to get the memory names.
- Read each memory file directly and skim for: project purpose, key folders, common commands, and conventions.
- Keep memories in mind throughout the session; update them via `write_memory-skl` when you discover new information.
- Reply with a short recap of what you learned and proceed with the user's request.

## If not onboarded (`onboarded: false`)
- Create `./.{AGENT_NAME}/skills/memories/` directory if it doesn't exist.
- Run `onboarding-skl` to generate baseline memories.
- After onboarding completes, skim the newly created memories before proceeding.
