# Anti-patterns (markdown)

## Tests are truth
- If checks fail after your change, assume it's your fault until proven otherwise.
- Prefer TDD (red -> green -> refactor), even for doc/script changes.

## Never hide failures
- Do not suppress errors.
- Do not add fallback code that silently changes behavior.
- Fail fast and loudly so issues are observable.

## Markdown correctness
- Do not rely on renderer-specific quirks when standard markdown works.
- Keep heading levels consistent and avoid skipping levels without a reason.
- Avoid large pasted excerpts when a path/command reference is enough.

## Skill metadata correctness
- Do not mismatch skill directory name and frontmatter `name`.
- Do not write first-person or second-person `description`; keep third person.

## Reuse before writing
- Before new scripts or templates, search existing helpers:
  - `scripts/`
  - `skillrena/activating-memories/assets/`
  - `docs/skills/`

## Safety pitfalls
- Treat `scripts/remove_skills.sh` as destructive (`rm -rf` under `$HOME`).
- Keep Codex and Claude target paths aligned when modifying install/remove scripts.
