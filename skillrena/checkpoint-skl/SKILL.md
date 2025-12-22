---
name: checkpoint-skl
description: Quick reflection checkpoint at different stages of work.
---

Input: `stage` - one of `info`, `before_edit`, `completion`

## Stage: `info` (Do we have enough information?)

Answer briefly:
- What's still unknown?
- Can we get it via search or targeted reads?
- If not, ask the user the smallest clarifying question.

## Stage: `before_edit` (Are we aligned with the request?)

Before editing:
- Restate the requested outcome in 1 sentence.
- List assumptions/constraints.
- Confirm planned edits match scope; otherwise ask.

## Stage: `completion` (Are we done?)

Confirm:
- Requirements satisfied?
- Any tests/format/lint commands to run?
- Any follow-ups or risks to mention?
