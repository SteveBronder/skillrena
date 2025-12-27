# Golden examples: generated mode skills

These examples show the *target shape* of the three generated mode skills after adapting the templates.

Notes:
- Replace verification commands with the project’s canonical ones (use `../memories/suggested_commands-skl/SKILL.md` as the source of truth).
- Keep these mode skills short; link to memories instead of pasting them.

## Example: `{slug}-mode-planner` (filled)

```markdown
---
name: myrepo-mode-planner
description: Behavioral mode for planning and design work in myrepo. Use when scoping changes, producing design docs, or deciding between approaches.
---

# myrepo planner mode

## When to use

Use this mode when the task is primarily planning/design/scoping (before editing code), especially for multi-file changes.

## Operating loop

1. Restate the brief and constraints (compatibility, performance, security).
2. Read project memories and skim the relevant entrypoints/configs.
3. Propose 2–4 approaches with risks + rollback.
4. Recommend one approach and justify tradeoffs.
5. Define acceptance criteria and a local verification plan.
6. Break work into safe increments (each with a verification step).

## Question protocol

Ask questions when ambiguity changes the plan:
- **[blocking]**: cannot proceed responsibly without this answer
- **[important]**: proceed with a default, but risk rework

## Output discipline

Always include:
- Acceptance criteria (explicit, testable)
- How to verify locally (commands + expected green signals)

Tests guardrail:
- Do not change/delete/weaken existing tests without explicit user approval.

## Project context pointers

- Project overview: `../memories/project_overview-skl/SKILL.md`
- Commands/workflows: `../memories/suggested_commands-skl/SKILL.md`
- Style/conventions: `../memories/style_and_conventions-skl/SKILL.md`
- Completion checklist: `../memories/task_completion_checklist-skl/SKILL.md`
```

## Example: `{slug}-mode-debugger` (filled)

```markdown
---
name: myrepo-mode-debugger
description: Behavioral mode for debugging and hypothesis testing in myrepo. Use when diagnosing failures, crashes, regressions, or incorrect outputs.
---

# myrepo debugger mode

## When to use

Use this mode when the task is diagnosis + fixing: failing tests/CI, exceptions, flakiness, performance regressions, or violated invariants.

## Operating loop

1. Reproduce: smallest reliable reproducer; observed vs expected; env assumptions.
2. Localize: narrow to subsystem(s) and a single canonical failing signal.
3. Hypothesize: list multiple plausible root causes + cheap falsification checks.
4. Instrument and falsify quickly (temporary logs/asserts/tracing as needed).
5. Implement the smallest correct fix (avoid collateral refactors).
6. Verify: repro + relevant suite; add regression test when useful.
7. Remove temporary instrumentation; note subtle “why” if needed.

## Output discipline

Always include:
- Acceptance criteria
- How to verify locally (specific commands + signals)

Tests guardrail:
- Do not change/delete/weaken existing tests without explicit user approval.
- Adding a regression test is encouraged.

## Project context pointers

- Project overview: `../memories/project_overview-skl/SKILL.md`
- Commands/workflows: `../memories/suggested_commands-skl/SKILL.md`
- Style/conventions: `../memories/style_and_conventions-skl/SKILL.md`
- Completion checklist: `../memories/task_completion_checklist-skl/SKILL.md`
```

## Example: `{slug}-mode-qa-tester` (filled)

```markdown
---
name: myrepo-mode-qa-tester
description: Behavioral mode for quality, tests, and verification in myrepo. Use when adding tests, validating changes, or building a release verification checklist.
---

# myrepo QA tester mode

## When to use

Use this mode when the task is primarily verifying correctness: adding tests, improving coverage, validating a change, or assessing merge/release risk.

## Operating loop

1. Clarify the contract: intended behavior, invariants, examples; ask questions if unclear.
2. Derive test cases: examples + edge cases; prioritize by risk.
3. Choose test levels: unit/integration/e2e; cheapest level that proves the contract.
4. Make tests deterministic and diagnostic (avoid sleeps; good assertions).
5. Run smallest relevant subset first, then expand to broader suites.
6. Close gaps: highest-risk paths + regression tests for reported bugs.

## Output discipline

Always include:
- Acceptance criteria
- How to verify locally (commands; which subsets; expected green signals)

Tests guardrail:
- Do not change/delete/weaken existing tests without explicit user approval.
- Adding new tests is encouraged.

## Project context pointers

- Project overview: `../memories/project_overview-skl/SKILL.md`
- Commands/workflows: `../memories/suggested_commands-skl/SKILL.md`
- Style/conventions: `../memories/style_and_conventions-skl/SKILL.md`
- Completion checklist: `../memories/task_completion_checklist-skl/SKILL.md`
```
