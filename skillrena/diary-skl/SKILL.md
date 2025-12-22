---
name: diary-skl
description: Record session learnings before compaction.
---

# Diary

## Quick start
- Before compaction or session end, write `diary_{YYYY-MM-DD_HH-MM}.md` to `./.{AGENT_NAME}/skills/memories/` via `write_memory-skl`.

## Template
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

## Consolidation
If more than 5 diary entries exist, merge them into `diary_consolidated.md`, keeping only high-signal items. Delete the older entries after consolidation.

## Decision points
- Nothing new learned -> skip the diary.
- Many related notes -> consolidate immediately.

## Failure modes
- Time format unclear: use local time or `date` output.
- Memory dir missing: create it before writing.
