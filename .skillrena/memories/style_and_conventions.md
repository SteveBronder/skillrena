# Style & conventions

## Skill layout
- One directory per skill: `skills_serena/serena-<tool>/` and `skillrena/<tool>-skl/`.
- Each directory contains a single `SKILL.md`.

## `SKILL.md` format
- YAML front matter with `name:` and `description:`.
- `name:` matches the folder name (including the `serena-` prefix or `-skl` suffix).
- `description:` is short, action-oriented, and should match trigger behavior.
- Markdown body starts with `# Serena: <tool>` or `# Skillrena: <tool>` and gives brief workflow guidance.

## Catalogs/docs
- `skills_serena/skills.md` is the canonical Serena skill list; keep it in sync with Serena changes.
- Keep Skillrena updates aligned with the intent captured in `design/skillrena-migration.md` when relevant.
