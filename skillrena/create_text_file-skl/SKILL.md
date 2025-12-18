---
name: create_text_file-skl
description: Create/overwrite a text file using apply_patch.
---

# Skillrena: create_text_file

Input: `relative_path`, `content`.
- Create parent dirs as needed.
- Use `apply_patch` (Add File / Update File).
Reply: `File created: <relative_path>.` (mention overwrite if applicable).
