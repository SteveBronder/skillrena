---
name: write_memory-skl
description: Write `.{AGENT_NAME}/skills/memories/<name>.md`
---

Input: `memory_file_name`, `content`.

1. Normalize: strip trailing `.md`, then write to `./.{AGENT_NAME}/skills/memories/<name>.md` (e.g., `.claude/skills/memories/` for Claude, `.codex/skills/memories/` for Codex).

2. Create the directory if it doesn't exist: `mkdir -p .{AGENT_NAME}/skills/memories`

3. Ensure the file includes the **memory header format**:

```markdown
---
type: memory
description: <what this memory contains>
mutable: true
use: session
---

<content here>
```

If the provided `content` does not include a header, wrap it with the appropriate header.

4. Use `apply_patch` or appropriate file creation tools to create/overwrite.

Reply: `Memory written: <name>.`
