---
name: list_dir-skl
description: List dirs/files under a path (optionally recursive) and return JSON.
---

Input: `relative_path="."`, `recursive`, `skip_ignored_files=false`.
- If `skip_ignored_files`: prefer git-aware listing (exclude `.gitignore`d).
- Else: use `ls`/`find`.
Return JSON only: `{"dirs":[...],"files":[...]}` (repo-relative, sorted)
