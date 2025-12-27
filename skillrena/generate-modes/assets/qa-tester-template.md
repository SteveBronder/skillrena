# QA tester mode template

> **Purpose:** Provide a project-specific quality, testing, and verification operating procedure.
>
> This template is intended to be adapted into a mode skill named `{slug}-mode-qa-tester`.

## When to use

Use this mode when the task is primarily **proving correctness**, improving test coverage, or validating a change, for example:

* Writing new tests for a feature or bugfix
* Assessing risk before merging a change
* Building a verification checklist for a release
* Investigating test flakiness as a quality issue

## Operating loop

1. **Clarify the contract**
   - Identify the intended behavior (requirements, API contract, invariants, examples).
   - Separate “must have” from “nice to have.”
   - If expected behavior is unclear, ask questions.

2. **Derive test cases from examples and edge conditions**
   - Start from known examples (bug report steps, usage snippets, fixtures).
   - Enumerate edge cases: boundaries, empty inputs, large inputs, error paths, concurrency, time.
   - Prioritize by risk and likelihood.

3. **Choose test level(s)**
   - Unit vs integration vs end-to-end.
   - Prefer the cheapest level that still validates the contract.
   - Use existing test harnesses and conventions.

4. **Make tests deterministic and diagnostic**
   - Avoid sleeps, races, and external dependencies when possible.
   - Use stable fixtures; isolate randomness.
   - Ensure failures explain *why* (good assertions, helpful diffs).

5. **Run locally and interpret results**
   - Run the smallest relevant subset first.
   - Expand to the broader suite relevant to the change.
   - If failures occur, summarize the failure signals and likely causes.

6. **Close gaps**
   - Add missing coverage for the highest-risk paths.
   - Add regression tests for reported bugs.
   - If behavior differs from expectations, escalate as a question rather than “fixing the test.”

## Question protocol

Ask questions whenever uncertainty would change what “correct” means.

* **[blocking]**: missing acceptance criteria, unclear expected outputs, unknown required environments.
* **[important]**: performance/latency budgets, backward compatibility requirements.
* Provide a recommended default assumption for each non-blocking question.

## Output discipline

**Always include:**

* **Acceptance criteria** (explicit, testable)
* **How to verify locally** (commands; which subsets to run; expected green signals)

**Tests guardrail:**

* Do **not** change, delete, or weaken existing tests without explicit user approval.
* Adding new tests (including regression tests) is encouraged.
* Refactoring tests for clarity is allowed only when behavior is preserved; request approval if it might change semantics.

**Skill authoring guardrail (when the deliverable is a skill):**

* Follow the Agent Skills spec for frontmatter and structure.
* Keep `SKILL.md` under ~500 lines; move detail to `references/`.
* Prefer linking to project memories rather than duplicating them.

## Project context pointers (to be filled during adaptation)

Include links (relative to `./.{AGENT_NAME}/skills/{slug}-mode-qa-tester/`). Only link files that exist; omit missing pointers or create the relevant memory skill first:

Required (baseline memories):

* Project overview: `../memories/project_overview-skl/SKILL.md`
* Commands/workflows: `../memories/suggested_commands-skl/SKILL.md`
* Style/conventions: `../memories/style_and_conventions-skl/SKILL.md`
* Completion checklist: `../memories/task_completion_checklist-skl/SKILL.md`

Optional (if present in this repo’s memories):

* Testing guidance: `../memories/testing_guidance-skl/SKILL.md`
* Gotchas/invariants: `../memories/gotchas_and_invariants-skl/SKILL.md`

During adaptation, add pointers to the test harness docs and any CI-specific constraints.
