# Task completion checklist (this repo)

When you finish a change:
- Ensure any new/renamed skill has:
  - matching folder name (`serena-...`)
  - matching YAML `name:` field
  - a clear `description:` that matches intended trigger behavior
- Update `skills.md` catalog entries to reflect additions/removals/renames.
- Do a quick repo-wide search to confirm references are consistent (e.g. `rg "serena-<name>"`).

There is no known automated test/lint setup in this repo; verification is primarily by review + consistency checks.
