---
name: serena-create_text_file
description: Create or overwrite a text file in the active project; use for new files or full-file rewrites.
---

# Serena: create_text_file

Use this to create a new file or replace the entire contents of an existing file in one operation.

## When to use
- Creating a new module/config/doc file.
- Replacing a generated file or template wholesale.

## Guidance
- Confirm the destination path is correct; this tool typically overwrites.
- For small edits, prefer `insert_at_line` / `replace_lines` / symbol-based insert/replace tools.

