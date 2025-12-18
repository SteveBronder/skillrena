# Task completion checklist (this repo)

When you finish a change:
- For any added/renamed skill, ensure folder name, YAML `name:`, and prefix/suffix (`serena-` or `-skl`) match.
- Confirm the `description:` matches trigger behavior and is concise.
- If a Serena skill changed, update `skills_serena/skills.md`.
- Do a quick consistency scan (e.g. `rg "serena-<name>|<name>-skl"` or `rg "^description:"`).
- No automated tests are known; rely on review and quick command checks.
