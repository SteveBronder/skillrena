# Style and conventions (markdown)

## Formatting / lint / typechecking
- Format standard: CommonMark baseline plus GitHub Flavored Markdown extensions when needed.
- Tools:
  - `markdownlint` / `markdownlint-cli2` for style checks
  - `prettier` for stable formatting
- Config files:
  - No repo-level markdownlint/prettier config is currently present.

## Naming conventions
- Skill directory names use lowercase hyphen-case and must match frontmatter `name`.
- `description` should be third person and concise.
- Keep frontmatter minimal unless extra metadata is required.

## Project structure conventions
- One skill per directory: `skillrena/<skill>/SKILL.md`.
- Keep support files under that skill folder (`references/`, `assets/`, `scripts/`).
- Keep router/init docs at repo root (`AGENTS.md`, `CLAUDE.md`, `GEMINI.md`) and memory docs in `agent-docs/<lang>/`.

## Testing style
- Validate changed shell scripts with `bash -n`.
- For markdown/doc edits, use lints when available and run targeted checks first.

## Utility reuse map (IMPORTANT)
Before writing a new helper, search here first:
- `scripts/` (install/remove flows)
- `skillrena/activating-memories/assets/` (router/templates/skill templates)
- `docs/skills/specification.md` (format rules)

Examples of reusable helpers (with paths):
- `scripts/cp_skills.sh`
- `scripts/remove_skills.sh`
- `skillrena/activating-memories/assets/agent-docs-templates/`
- `skillrena/activating-memories/assets/skills/`
