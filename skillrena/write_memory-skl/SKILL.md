---
name: write_memory-skl
description: Write a memory file with proper header.
---

# Write Memory

## Quick start
- Write to `./.{AGENT_NAME}/skills/memories/<name>-skl/SKILL.md`.
- Create the directory if needed.
- Prepend the required header if missing.

## File format
- Path: `./.{AGENT_NAME}/skills/memories/<name>-skl/SKILL.md`
- The `<name>-skl` is the skill/memory name with `-skl` suffix (e.g., `project_overview-skl`, `suggested_commands-skl`)
- The file must be named `SKILL.md` (uppercase)

## Header template
Every `SKILL.md` file **must** have this exact header format:
```
---
name: <skill-name>
description: <brief description without colons>
---
```

Example:
```
---
name: project_overview-skl
description: Skillrena repo purpose and structure
---
```

## Header rules
- The header uses YAML frontmatter (between `---` delimiters)
- **Required fields:**
  - `name` - the skill name with `-skl` suffix (must match the folder name)
  - `description` - brief description of what this skill does and when to use it
- The `description` field must NOT contain colons (`:`) after the initial one
  - Good: `description: Brief summary of project structure`
  - Bad: `description: Project structure: components and layout`
- Keep the description on a single line
- Do NOT add extra fields like `type` or `mutable` - only `name` and `description` are required

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
