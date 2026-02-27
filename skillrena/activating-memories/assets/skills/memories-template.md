---
name: memories
description: Loads repo-local memory docs from ./agent-docs for the language(s) described in $ARGUMENTS. Use at session start, when switching languages, or when you need project context.
---

<inputs>
- `$ARGUMENTS`: free-form language list (e.g., "C++ and Python", "Go + TypeScript").
</inputs>

<quick_start>
1) Parse languages from `$ARGUMENTS`.
   - If no language is clear, ask the user to restate which language(s) they will use.
   - Folder mapping (examples): `C++ -> cpp`, `Python -> python`, `Go -> go`, `JavaScript -> js`, `TypeScript -> ts`, `Rust -> rust`, `R -> r`.

2) Load anti-patterns only (minimum viable context):
   - For each selected language `L`, read: `agent-docs/L/anti-patterns.md`

3) Use progressive disclosure for everything else:
   - Need to run/build/test? Read: `agent-docs/L/suggested-commands.md`
   - Writing/debugging tests (TDD loop)? Read: `agent-docs/L/testing-guidance.md`
   - Adding/changing code style or structure? Read: `agent-docs/L/style-and-conventions.md`
   - Navigating architecture? Read: `agent-docs/L/project-overview.md`

4) If any required file is missing (e.g., `agent-docs/L/anti-patterns.md`), run onboarding:
   - `$activating-memories`

5) While working, when you learn durable repo-specific info, record it via:
   - `$write-memory <short description>`
</quick_start>

<decision_points>
- Missing language -> ask user.
- Missing `agent-docs/` or missing per-language folder -> run `$activating-memories`.
- If you are warned memories exceed the line budget -> run `$compress-memories <languages>`.
</decision_points>

<quality_checklist>
- Always apply the anti-pattern rules first.
- Prefer TDD (red → green → refactor).
- If tests fail after your change, assume it's your fault until proven otherwise.
- Reuse existing utilities before creating new helper functions.
</quality_checklist>
