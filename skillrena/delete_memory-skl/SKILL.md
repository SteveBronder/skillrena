---
name: delete_memory-skl
description: Delete a memory file (only on explicit user request).
---

Input: `memory_file_name` (strip `.md` if present).
- Only proceed if the user explicitly asked to delete/forget it.
- Delete `.skillrena/memories/<name>.md` via `apply_patch`.
Reply: `Deleted: <name>.`
