---
name: write_memory-skl
description: Write a memory file with proper header.
---

Write to `./.{AGENT_NAME}/skills/memories/<name>.md`. Create directory if needed.

Prepend this header if missing:
```
---
type: memory
description: <brief description>
mutable: true
---
```

Reply: `Memory written: <name>.`
