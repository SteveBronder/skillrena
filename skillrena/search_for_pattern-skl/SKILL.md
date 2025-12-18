---
name: search_for_pattern-skl
description: Regex search via rg and return grouped matches as JSON.
---

# Skillrena: search_for_pattern

Input: `substring_pattern` (regex), optional `relative_path="."`, `paths_include_glob=""`, `paths_exclude_glob=""`, `context_lines_before=0`, `context_lines_after=0`.
- Use `rg -n` and restrict scope/globs when possible.
- If results are large, tighten the query (don’t dump huge outputs).
Return JSON: `{ "path": ["  > line:match", ...], ... }`
