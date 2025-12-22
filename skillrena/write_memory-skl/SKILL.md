---
name: write_memory-skl
description: Write a memory file with proper header.
---

# Write Memory

## Quick start
- Write to `./.{AGENT_NAME}/skills/memories/<name>.md`.
- Create the directory if needed.
- Prepend the required header if missing.

## Header template
```
---
type: memory
description: <brief description>
mutable: true
---
```

## Decision points
- Existing memory? Update if the info is the same topic; otherwise create a new file.
- Multiple small notes? Consolidate into one concise memory.

## Quality checklist
- Concise and actionable
- No duplication with other memories
- Sources or file paths included when relevant

## Failure modes
- Missing description: add a short, specific summary.
- Wrong path: keep memories under `./.{AGENT_NAME}/skills/memories/`.
