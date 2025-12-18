---
name: find_file-skl
description: Find files matching a glob under a path and return JSON.
---

Input: `file_mask` (glob), `relative_path="."`.
- Search under `relative_path`, skipping ignored files when possible.
Return JSON only: `{"files":[...]}` (repo-relative, sorted)
