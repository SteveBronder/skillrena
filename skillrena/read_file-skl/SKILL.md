---
name: read_file-skl
description: Read a file (optionally a 0-based inclusive line range).
---

Input: `relative_path`, `start_line=0`, `end_line=null` (0-based; `end_line` inclusive).
- Read only the requested range (smallest chunk that works).
Return the chunk as plain text (no extra commentary).
