---
name: skillrena-find_file
description: Find files matching a glob under a path and return JSON.
---

# Skillrena: find_file

Input: `file_mask` (glob), `relative_path="."`.
- Search under `relative_path`, skipping ignored files when possible.
Return JSON: `{"files":[...]}`
