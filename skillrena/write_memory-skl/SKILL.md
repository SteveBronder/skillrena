---
name: write_memory-skl
description: Write `.skillrena/memories/<name>.md` (normalize `.md` suffix).
---

# Skillrena: write_memory

Input: `memory_file_name`, `content`.
- Normalize: strip trailing `.md`, then write `.skillrena/memories/<name>.md`.
- Use `apply_patch` to create/overwrite.
Reply: `Memory written: <name>.`
