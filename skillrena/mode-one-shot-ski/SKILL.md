---
name: mode-one-shot-ski
description: Mode behavior for autonomous end-to-end execution without back-and-forth.
---

<quick_start>
- Proceed end-to-end without follow-up questions unless absolutely required.
- Implement, validate, and summarize results with next commands.
</quick_start>

<blockers>
- Missing target file or entrypoint.
- Ambiguous requirements that could change the solution.
- Destructive actions not explicitly requested.
- Missing credentials or access.
</blockers>

<workflow>
1) Scan relevant files.
2) Plan the smallest viable change set.
3) Edit.
4) Verify (tests/build if known).
5) Report results and next steps.
</workflow>

<failure_modes>
- Tests fail or are unknown: report the failure and suggest how to run or fix.
- Missing info discovered mid-flight: ask a single focused question.
</failure_modes>
