---
name: write-memory
description: Records a memory-worthy event into ./agent-docs with an event header. Use when you learn something durable about this repo such as a command, convention, decision, pitfall, or reusable utility location.
---

<inputs>
- `$ARGUMENTS`: free-form description of what to remember.
</inputs>

<quick_start>
1) Decide which doc(s) to update.
   - Cross-language agent behavior -> `agent-docs/<lang>/anti-patterns.md`
   - Language-specific -> update one or more of:
     - `agent-docs/<lang>/project-overview.md`
     - `agent-docs/<lang>/suggested-commands.md`
     - `agent-docs/<lang>/style-and-conventions.md`
     - `agent-docs/<lang>/testing-guidance.md`
     - `agent-docs/<lang>/anti-patterns.md`

2) Add an event header (required).
   - Format:
     - `## YYYY-MM-DD — <short title>`
     - 1–3 bullets:
       - What happened / what changed
       - Why it matters
       - Evidence (paths, commands, config keys)

3) Prefer integrating into existing sections.
   - If the doc already has a "Commands" or "Gotchas" section, place the event there.
   - Do not append long narratives; keep it scannable.

4) Enforce the hard rules while writing:
   - If tests fail after your change, assume it's your fault.
   - No silent fallback code. Do not suppress errors.
   - Prefer strong typing where possible.
   - Reuse utilities before writing new helpers; record the helper path so future agents reuse it.

5) Safety:
   - Never write secrets (tokens/keys/credentials). Note *where* config lives, not values.

6) If you suspect docs are getting large, suggest:
   - `$compress-memories <languages>`
</quick_start>

<quality_checklist>
- References, not excerpts: paths and commands over pasted code.
- TDD-focused: if the event was a bugfix, include the test name/path + how to run it.
- Reuse-focused: include the reusable utility path.
</quality_checklist>
