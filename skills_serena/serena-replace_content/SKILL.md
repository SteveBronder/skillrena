---
name: serena-replace_content
description: Replace content in a file (literal or regex); use for repetitive edits but apply cautiously.
---

# Serena: replace_content

Use this for batch changes within a file (or when the tool supports multiple files) where line-based edits are too manual.

## Safety tips
- Prefer literal matching when possible; regex replacements are easy to over-apply.
- Keep patterns non-greedy and avoid `.*` at the start/end unless necessary.
- Re-read/spot-check after replacement and run tests if the change is risky.

