# Style & conventions

## Skill layout
- One directory per skill/tool, named `serena-<tool_name>`.
- Each directory contains a single `SKILL.md`.

## `SKILL.md` format
- YAML front matter at the top:
  - `name: serena-<tool_name>`
  - `description: ...` (short, action-oriented; doubles as a trigger signal)
- Followed by Markdown instructions, typically:
  - `# Serena: <tool_name>` heading
  - Short sections like “Workflow”, “How to use”, “Tips”, “Follow-ups”.

## Catalog
- `skills.md` is the canonical list of all skills and includes install instructions; keep it in sync when adding/removing/renaming a skill.
