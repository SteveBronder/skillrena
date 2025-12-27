# Planner mode template

> **Purpose:** Provide a project-specific planning and design operating procedure.
>
> This template is intended to be adapted into a mode skill named `{slug}-mode-planner`.


## When to use

Use this mode when the task is primarily **planning, design, or scoping**, for example:

* Creating or updating a design doc / technical proposal
* Choosing between architecture options
* Breaking a large change into safe, reviewable steps
* Defining acceptance criteria and a verification plan before coding

## Operating loop

1. **Inventory the brief**
   - Restate the task in one paragraph.
   - List explicit constraints (performance, correctness, backwards compatibility, security, deadlines).
   - Identify missing information.

2. **Inspect project reality**
   - Read the relevant project memories (see “Project context pointers”).
   - Skim the key entry points, configs, and existing patterns.
   - Note conventions that the plan must respect.

3. **Generate candidate approaches**
   - Produce 2–4 viable approaches.
   - For each: expected complexity, risks, dependencies, and rollback strategy.
   - Prefer simpler approaches first.

4. **Select an approach and justify it**
   - Make a clear recommendation.
   - Explain why alternatives were rejected.
   - Call out the highest-risk assumptions.

5. **Specify acceptance criteria and verification**
   - Define observable acceptance criteria (behavior, APIs, performance bounds).
   - Provide a concrete local verification plan (tests + commands).
   - Include a “definition of done” checklist.

6. **Plan the implementation as safe increments**
   - Break into small commits/PRs.
   - For each increment: intent, files likely touched, and verification step.
   - Identify required migrations, feature flags, and compatibility constraints.

7. **Pre-mortem**
   - List likely failure modes.
   - Add mitigations (instrumentation, canaries, logs, guardrails).

## Question protocol

Ask questions whenever ambiguity would change the plan materially.

* Mark questions as **[blocking]** if you cannot proceed responsibly.
* Mark questions as **[important]** if you can proceed with defaults but risk rework.
* Provide a recommended default assumption for each non-blocking question.

## Output discipline

**Always include:**

* **Acceptance criteria** (explicit, testable)
* **How to verify locally** (commands; what “good” looks like)

**Tests guardrail:**

* Do **not** change, delete, or weaken existing tests without explicit user approval.
* If a test appears incorrect, propose the change and request approval before editing.

**Skill authoring guardrail (when the deliverable is a skill):**

* Follow the Agent Skills spec for frontmatter and structure.
* Keep `SKILL.md` under ~500 lines; move detail to `references/`.
* Prefer linking to project memories rather than duplicating them.

## Project context pointers (to be filled during adaptation)

Include links (relative to `./.{AGENT_NAME}/skills/{slug}-mode-planner/`). Only link files that exist; omit missing pointers or create the relevant memory skill first:

Required (baseline memories):

* Project overview: `../memories/project_overview-skl/SKILL.md`
* Commands/workflows: `../memories/suggested_commands-skl/SKILL.md`
* Style/conventions: `../memories/style_and_conventions-skl/SKILL.md`
* Completion checklist: `../memories/task_completion_checklist-skl/SKILL.md`

Optional (if present in this repo’s memories):

* Testing guidance: `../memories/testing_guidance-skl/SKILL.md`
* Gotchas/invariants: `../memories/gotchas_and_invariants-skl/SKILL.md`

During adaptation, also add any project-specific “must read” files (entry points, configs, ADRs).
