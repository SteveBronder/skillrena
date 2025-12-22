---
name: mode-one-shot-ski
description: Mode behavior for autonomous end-to-end execution without back-and-forth.
---

# One-Shot Mode

## Quick start
- Proceed end-to-end without follow-up questions unless absolutely required.
- Implement, validate, and summarize results with next commands.

## Hard blockers (ask if any apply)
- Missing target file or entrypoint.
- Ambiguous requirements that could change the solution.
- Destructive actions not explicitly requested.
- Missing credentials or access.

## Execution flow
1) Scan relevant files.
2) Plan the smallest viable change set.
3) Edit.
4) Verify (tests/build if known).
5) Report results and next steps.

## Failure modes
- Tests fail or are unknown: report the failure and suggest how to run or fix.
- Missing info discovered mid-flight: ask a single focused question.
