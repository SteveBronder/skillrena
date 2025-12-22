---
name: diary-skl
description: Record session learnings before compaction.
---

<quick_start>
- Before compaction or session end, write `diary_{YYYY-MM-DD_HH-MM}.md` to `./.{AGENT_NAME}/skills/memories/` via `write_memory-skl`.
</quick_start>

<templates>
<diary>
Gotchas:
-
Workarounds:
-
Useful commands:
-
Dead ends:
-
Project quirks:
-
Open questions:
-
</diary>
</templates>

<consolidation>
If more than 5 diary entries exist, merge them into `diary_consolidated.md`, keeping only high-signal items. Delete the older entries after consolidation.
</consolidation>

<decision_points>
- Nothing new learned -> skip the diary.
- Many related notes -> consolidate immediately.
</decision_points>

<failure_modes>
- Time format unclear: use local time or `date` output.
- Memory dir missing: create it before writing.
</failure_modes>
