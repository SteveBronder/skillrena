---
name: serena-summarize_changes
description: Generate a structured summary of changes made during the conversation; use right before final handoff.
---

# Serena: summarize_changes

Use this at the end of a task to produce a thorough, user-facing summary.

## Recommended workflow
1. Review the diff (e.g., via `git diff`) so you don’t miss anything.
2. Note test coverage: what you ran, what you didn’t, and why.
3. Call `summarize_changes` and follow its instructions.

