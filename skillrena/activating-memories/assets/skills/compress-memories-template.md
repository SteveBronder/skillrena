---
name: compress-memories
description: Compresses ./agent-docs memories for language(s) to stay under 500 lines, merging optional docs into core docs and deleting optional files. Use when memories exceed budget or context feels heavy.
---

<inputs>
- `$ARGUMENTS`: free-form language list (e.g., "C++ and Python").
</inputs>

<quick_start>
1) Parse languages from `$ARGUMENTS`.
   - If no language is clear, ask the user to restate which language(s) they want compressed.

2) For each language `<lang>`, compute total lines across:
   - `agent-docs/L/*.md`
   If total <= 500, skip compression for `<lang>`.

3) If total > 500 for any `<lang>`, ask the user:
   - "Memories for {L} exceed 500 lines. Compress to <= 500 lines (and delete optional files)?"

4) If user says yes, compress language `<lang>` first:
   - Core files (must always remain):
     - `project-overview.md`
     - `suggested-commands.md`
     - `style-and-conventions.md`
     - `testing-guidance.md`
     - `anti-patterns.md`
   - Optional files = any other `agent-docs/L/*.md`.

   Compression procedure:
   a) Read optional files and extract only durable, high-signal facts.
   b) Merge into the most appropriate core file:
      - Commands -> `suggested-commands.md`
      - Testing workflows -> `testing-guidance.md`
      - Code placement/style -> `style-and-conventions.md`
      - Architecture/navigation -> `project-overview.md`
      - "Never do this" rules -> `anti-patterns.md`
   c) Tighten the core files:
      - De-duplicate repeated facts.
      - Prefer references, not excerpts (paths/commands, not pasted blocks).
      - Preserve TDD guidance and the fastest single-test loop.
   d) Delete the optional files after successful merge (git history is the archive).

6) After any successful compression, recommend the user start a new session.
</quick_start>

<quality_checklist>
- Never delete the 5 core per-language files.
- Keep anti-patterns explicit: no silent failures, no error suppression, no fallback code.
- Keep docs scannable: bullets, short sections, clear commands.
- Preserve the TDD fast loop: "run one test" commands must remain.
</quality_checklist>
