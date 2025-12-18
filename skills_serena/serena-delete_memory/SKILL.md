---
name: serena-delete_memory
description: Delete a Serena project memory entry by name; only use when the user asks to remove/forget it.
---

# Serena: delete_memory

Use this only when the user explicitly requests that Serena “forget” something or when a memory is known-bad and the user wants it removed.

## Guidance
- List memories first (`list_memories`) to confirm the exact name.
- Prefer updating/correcting via `write_memory` when appropriate instead of deleting.

