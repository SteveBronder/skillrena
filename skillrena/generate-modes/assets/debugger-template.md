# Debugger mode template

> **Purpose:** Provide a project-specific debugging and hypothesis-testing operating procedure.
>
> This template is intended to be adapted into a mode skill named `{slug}-mode-debugger`.
> It is written as a neutral, general-purpose framework: it must not reference any benchmark, puzzle set, or toy domain.

## When to use

Use this mode when the task is primarily **diagnosing and fixing** a correctness or runtime problem, for example:

* A failing test or CI job
* An exception, crash, deadlock, performance regression, or memory leak
* Incorrect outputs or violated invariants
* Intermittent flakiness

## Operating loop

1. **Reproduce the failure (make it real)**
   - Identify the smallest reliable reproducer (a single test, command, or script).
   - Capture the *observed* vs *expected* behavior.
   - Record environment assumptions (OS, versions, flags) if relevant.

2. **Localize the problem (constrain the search space)**
   - Identify the subsystem(s) involved: modules, endpoints, data flows.
   - If multiple symptoms exist, pick one canonical failing signal.
   - Prefer bisectable signals (single test, specific assertion, deterministic log line).

3. **Generate hypotheses (plural) and prioritize**
   - List 3–7 plausible root causes.
   - For each, propose a cheap falsification test (logging, asserts, targeted unit test).
   - Prioritize by likelihood × impact × cost to test.

4. **Instrument and falsify**
   - Add minimal instrumentation (temporary logs, asserts, tracing) to discriminate hypotheses.
   - Run the reproducer and eliminate hypotheses quickly.
   - Keep notes: which hypothesis was tested, what evidence was observed.

5. **Implement the smallest correct fix**
   - Prefer changes that restore invariants and reduce future ambiguity.
   - Avoid collateral refactors unless necessary.
   - If the fix is risky, gate it (feature flag, config toggle) when appropriate.

6. **Verify and regress**
   - Run the reproducer, then the relevant broader test suite.
   - Add or update *tests* only to improve coverage or prevent recurrence (see guardrail).
   - Confirm no new regressions or broken interfaces.

7. **Post-fix hardening**
   - Remove temporary instrumentation.
   - Add a brief “why this happened” note (comment, doc, or memory) if the bug was subtle.
   - Identify any follow-up work (refactor, monitoring, additional tests).

## Working with prior attempts / partial solutions

If the repo contains prior partial fixes (stashed patches, WIP commits, previous PRs, or alternative implementations):

1. Identify the best candidate(s) and summarize their intent.
2. Compare their behavior against the reproducer.
3. Explain precisely why they fall short.
4. Produce a new fix that preserves what works and corrects what fails.

## Question protocol

Ask questions whenever ambiguity would change the diagnosis or the safe fix.

* **[blocking]**: missing repro steps, unclear expected behavior, unknown environment constraints.
* **[important]**: uncertain performance budgets, unclear backward compatibility expectations.
* Provide a recommended default assumption for each non-blocking question.

## Output discipline

**Always include:**

* **Acceptance criteria** (what must be true after the fix)
* **How to verify locally** (commands; specific signals to check)

**Tests guardrail:**

* Do **not** change, delete, or weaken existing tests without explicit user approval.
* Adding a new regression test is encouraged.
* If an existing test is wrong, propose the change and request approval before editing.

**Skill authoring guardrail (when the deliverable is a skill):**

* Follow the Agent Skills spec for frontmatter and structure.
* Keep `SKILL.md` under ~500 lines; move detail to `references/`.
* Prefer linking to project memories rather than duplicating them.

## Project context pointers (to be filled during adaptation)

Include links (relative to `./.{AGENT_NAME}/skills/{slug}-mode-debugger/`). Only link files that exist; omit missing pointers or create the relevant memory skill first:

Required (baseline memories):

* Project overview: `../memories/project_overview-skl/SKILL.md`
* Commands/workflows: `../memories/suggested_commands-skl/SKILL.md`
* Style/conventions: `../memories/style_and_conventions-skl/SKILL.md`
* Completion checklist: `../memories/task_completion_checklist-skl/SKILL.md`

Optional (if present in this repo’s memories):

* Testing guidance: `../memories/testing_guidance-skl/SKILL.md`
* Gotchas/invariants: `../memories/gotchas_and_invariants-skl/SKILL.md`

During adaptation, add pointers to the most relevant subsystems (entrypoints, configs, hot paths).
