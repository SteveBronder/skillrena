---
name: diary-skl
description: Record session learnings before compaction.
---

**When**: Before context compaction or session end.

**Write** `diary_{YYYY-MM-DD_HH-MM}.md` to `./.{AGENT_NAME}/skills/memories/` with lessons learned:
- Gotchas, surprises, or non-obvious behaviors discovered
- Useful commands or workflows found
- Dead ends or approaches that didn't work
- Project quirks future agents should know

**Consolidation**: If >5 diary entries exist, merge them into one `diary_consolidated.md`, keeping the most valuable insights. Delete the old entries.

Use `write_memory-skl` for the diary file.
