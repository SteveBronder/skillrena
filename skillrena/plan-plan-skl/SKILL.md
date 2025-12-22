---
name: plan-plan
command: $plan-plan
description: Meta-skill that bootstraps the repo's design-doc workflow and generates a project-specific `$design-doc` skill plus templates under `design-docs/`.
---

<objective>
1. Create a repo-local `design-docs/` workspace (templates + active docs + index).
2. Generate a **project-specific** `$design-doc` skill for authoring feature design docs with:
   - explicit specs (interfaces, signatures, types)
   - mandatory test-data acquisition plan for ETL / HTTP / WebSocket work
   - enforceable guardrails against common agent failure modes
   - subtasks in a separate file for agent delegation
3. Support repeated runs to create additional templates (variants) without breaking existing docs.

This is a **joint user–agent process**: ask targeted questions when unsure; do not finalize templates without user review.
</objective>

<outputs>
Create (idempotent; do not overwrite without preserving history):

<file_list>
- `design-docs/README.md` — How design docs are written, reviewed, and used for delegated execution.
- `design-docs/templates/README.md` — Lists available templates and when to use them.
- `design-docs/templates/base.md` — Meta "base" design doc template (guardrails + structure).
- `design-docs/templates/<variant>.md` — Project-specific variants (e.g., `feature.md`, `etl_ingest.md`, `db_migration.md`).
- `.{AGENT_NAME}/skills/design-doc-skl/SKILL.md` — The generated `$design-doc` skill.
- `design-docs/agents/<design-doc-name>.xml` — Agent-executable subtasks (created after user approval).
</file_list>

<output_format>
**Design docs are written in markdown** — not XML. Markdown is easier for humans to read/edit and for agents to parse during collaboration. Agent-executable subtasks use XML in a separate file under `design-docs/agents/`.
</output_format>

<subtask_workflow>
Subtasks follow a **two-phase workflow**:

**Phase 1: Human-Readable Subtasks (in main design doc)**
- Add a "## Subtasks" section to the main design doc
- List tasks as a human-readable markdown checklist
- Collaborate with user to refine scope, order, and acceptance criteria
- User reviews and approves the subtask list

**Phase 2: Agent-Executable XML (after approval)**
- Once user approves subtasks, generate `design-docs/agents/<design-doc-name>.xml`
- XML file contains structured task definitions for agent delegation
- Agents read only the XML file when executing tasks

This separation allows:
- Human-friendly iteration during planning (Phase 1)
- Machine-parseable structure for execution (Phase 2)
- Clear approval gate before agent work begins
</subtask_workflow>

<agent_name_resolution>
Replace `{AGENT_NAME}` with the agent's config directory:
- `.aider/` — Aider
- `.claude/` — Claude Code
- `.codex/` — OpenAI Codex CLI
- `.copilot/` — GitHub Copilot
- `.cursor/` — Cursor

If the repo has an existing agent config directory, use it. If multiple exist, prefer the current agent's. If none exist, create one.
</agent_name_resolution>

<optional_output>
If the repo uses "memories":
- `.{AGENT_NAME}/memories/design_doc_conventions.md` — Repo-specific conventions discovered by scanning.
</optional_output>
</outputs>

<preconditions>
Before asking questions, scan the repo to ground defaults:

<scan_targets>
1. **Languages/frameworks/build**: `pyproject.toml`, `package.json`, `Cargo.toml`, `go.mod`, `CMakeLists.txt`, `Makefile`, `justfile`, `requirements*.txt`
2. **CI entrypoints**: `.github/workflows/*`, `tox.ini`, `noxfile.py`, `pytest.ini`, `ruff.toml`, `.pre-commit-config.yaml`
3. **Utility modules**: `src/**/utils*`, `lib/**`, `internal/**`, `pkg/**`
4. **DB/migrations**: `alembic`, `prisma`, `migrations/`, `db/`, `sql/`
5. **Style rules**: `CONTRIBUTING.md`, `docs/`, `STYLE*`, `README.md`
</scan_targets>

Use `rg`, `find`, `ls`, `cat` (or equivalent). Do not guess if the repo reveals the answer.
</preconditions>

<questioning_protocol>
Ask only questions that materially influence template contents.

<scan_first>
After scanning, present a "Detected Defaults Summary":
- Detected stack (language(s), frameworks)
- Detected test runner + primary local command(s)
- Detected formatter/linter + command(s)
- Detected CI gates (jobs / required checks)
- Detected DB/migrations tooling (if any)
- Detected network dependencies (HTTP/WS libs) and existing harness/fixtures patterns
- Notable existing utilities to reuse (paths + symbols if obvious)
</scan_first>

<question_tags>
Every question must be tagged:
- `[blocking]` — must be answered to generate correct template or enforce safety
- `[important]` — significantly improves template quality / reduces future rework
- `[optional]` — preference-level; safe defaults exist
</question_tags>

<question_budget>
- Max 10 questions total.
- Each question includes a one-line "why" tying to a template section, guardrail, or convention.
</question_budget>

<triggered_questions>
Ask only what applies based on scan:
- Migrations tooling detected → ask DB reset/backfill/rollback/testing policy
- HTTP/WS dependencies detected → ask record/replay + fixture storage constraints
- Multiple languages detected → ask which is authoritative for templates
- Monorepo structure detected → ask where templates live and how commands differ
- No tests/CI detected → ask what canonical verification commands should be
</triggered_questions>

<template_delta_preview>
Before writing files, show:
- Which variants will be created
- Repo-specific defaults that will be baked in
- Any tightened guardrails derived from project norms
- Any unresolved `[blocking]` items

Stop and ask for `[blocking]` answers before proceeding.
</template_delta_preview>
</questioning_protocol>

<common_questions>
Ask only what you cannot infer from the scan:

1. `[blocking]` **Template variants desired**
   - "Which templates do you want generated? (e.g., `feature`, `etl_http_ws`, `db_migration`, `refactor`)"
   - Why: determines `design-docs/templates/*.md` set.

2. `[blocking]` **Test integrity policy**
   - "What is your rule on mocks? (only mock boundaries; prefer record/replay; never mock core transforms)"
   - Why: populates guardrails + testing strategy.

3. `[blocking]` **Data capture constraints**
   - "Can we store captured payloads under `tests/fixtures/`? Any size/licensing/PII constraints?"
   - Why: populates test-data acquisition plan.

4. `[blocking]` **Destructive actions boundary**
   - "What DB reset patterns are allowed in tests? (transactions/temp schema/containers). Forbidden actions?"
   - Why: prevents unsafe "delete DB to pass tests" behavior.

5. `[important]` **Type discipline**
   - "What's your stance on Optional/None? (forbid unless justified; require invalid states unrepresentable)"
   - Why: shapes interface-contract requirements.

6. `[important]` **Review workflow**
   - "Stop at Template Delta Preview for approval, or write files and you review diffs?"
   - Why: controls collaboration checkpoint.
</common_questions>

<base_template_sections>
The base template MUST include these sections (in order):

1. Identity and lifecycle
2. Context
3. Problem
4. Goals / Non-goals
5. Requirements (FRs / NFRs)
6. Constraints and invariants (include DB + test integrity)
7. Proposed design (architecture, contracts, schemas, idempotency/retries)
8. Interface contracts (explicit signatures; Optional/None justification required)
9. Alternatives considered (>=2 + "do nothing")
10. Test data acquisition plan (mandatory for external I/O / ETL)
11. Testing and verification strategy (commands + CI gates + test integrity rules)
12. Rollout / migration / ops (flags, backfills, observability, runbook)
13. **Subtasks** (human-readable checklist for review)
14. Open questions / follow-ups

**Subtasks Section Format**:
```markdown
## Subtasks

### T1: [Task Title]
- **Summary**: One sentence objective
- **Scope**: What's in / what's out
- **Acceptance**: Binary pass/fail criteria
- **Status**: [ ] Not started / [~] In progress / [x] Complete

### T2: [Task Title]
...
```

After user approves subtasks, generate `design-docs/agents/<design-doc-name>.xml` with the full XML schema.
</base_template_sections>

<guardrails>
Include verbatim in base + project templates under "Engineering Guardrails for Agent Execution":

- **Reuse-first rule** (anti-duplication): search existing utilities; record decision per task.
- **No destructive shortcuts**: never delete dev/prod data to pass tests; destructive actions require confirmation.
- **Test integrity** (anti-mock-cheating): mock boundaries only; prefer record/replay; do not change tests without spec change approval.
- **Signature discipline** (anti-vagueness): explicit types/invariants; Optional/None requires justification and handling strategy.
- **Alternatives requirement**: evaluate >=2 alternatives + "do nothing".
- **Uncertainty protocol**: ask `[blocking]` questions when unsure; do not proceed.
</guardrails>

<subtask_schema>
Agent-executable subtasks go in `design-docs/agents/<design-doc-name>.xml`.

**This file is generated ONLY after the user approves the human-readable subtasks in the main design doc.**

The XML file wraps all tasks in a root element and follows this schema:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<design-doc-tasks>
  <metadata>
    <design-doc>YYYYMMDD-slug.md</design-doc>
    <created>YYYY-MM-DD</created>
    <approved-by>user</approved-by>
  </metadata>

  <task id="T1-slug" owner="unassigned" status="planned">
  <summary>One sentence objective.</summary>

  <scope>
    <in>Concrete inclusions.</in>
    <out>Concrete exclusions.</out>
  </scope>

  <reuse_check>
    <search_terms>
      <term>...</term>
    </search_terms>
    <existing_utilities>
      <candidate>path::symbol</candidate>
    </existing_utilities>
    <decision>reuse|extend|new</decision>
    <justification>Required if decision != reuse.</justification>
  </reuse_check>

  <interfaces>
    <exports>
      <function name="...">
        <signature>...</signature>
        <types>
          <param name="...">...</param>
          <returns>...</returns>
        </types>
        <invariants>
          <invariant>...</invariant>
        </invariants>
        <optionals>
          <allowed>false|true</allowed>
          <justification>Required if Optional/None exists.</justification>
        </optionals>
      </function>
    </exports>
  </interfaces>

  <implementation_plan>
    <step>...</step>
  </implementation_plan>

  <test_data>
    <required>true|false</required>
    <source>http|websocket|file|db|synthetic</source>
    <gap_analysis>What is missing vs required.</gap_analysis>
    <plan>Record/replay, generator, or harness.</plan>
    <fixture_paths>
      <path>tests/fixtures/...</path>
    </fixture_paths>
    <validation>
      <check>schema validation</check>
      <check>golden aggregates</check>
    </validation>
  </test_data>

  <tests>
    <add>
      <test_file>tests/.../test_*.py</test_file>
      <assertion>What this test proves.</assertion>
    </add>
    <update>
      <test_file>...</test_file>
      <change>...</change>
    </update>
  </tests>

  <commands>
    <cmd>...</cmd>
  </commands>

  <acceptance>
    <criterion>Binary "passes when …".</criterion>
  </acceptance>
  <task_completed_status>
  false
  </task_completed_status>
  <safety>
    <destructive_actions>false</destructive_actions>
    <notes>Any risk or confirmation requirements.</notes>
  </safety>
</task>

  <!-- Additional tasks follow the same structure -->
  <task id="T2-slug" owner="unassigned" status="planned">
    ...
  </task>

</design-doc-tasks>
```
</subtask_schema>

<generation_steps>
1. **Create folder structure** (if missing):
   - `design-docs/`
   - `design-docs/templates/`
   - `design-docs/active/`
   - `design-docs/agents/`

2. **Write base docs**:
   - `design-docs/README.md` (workflow + approvals)
   - `design-docs/templates/README.md` (template index)
   - `design-docs/templates/base.md` (meta template with guardrails)

3. **Run Adaptive Questioning Protocol**:
   - Produce "Detected Defaults Summary"
   - Ask triggered questions

4. **Show Template Delta Preview**:
   - Stop for `[blocking]` answers before proceeding

5. **Generate project-specific template variant(s)**:
   - Insert repo-specific commands (tests, lint, format, typecheck)
   - Insert repo-specific DB migration/testing norms (if applicable)
   - Add "Common utilities" section referencing discovered paths/patterns
   - Encode variant-specific sections (e.g., ETL templates emphasize fixtures)

6. **Generate the `$design-doc` skill** at `.{AGENT_NAME}/skills/design-doc-skl/SKILL.md`:
   - Prompts user to select a template variant
   - Creates main doc at `design-docs/active/YYYYMMDD-<slug>.md` with human-readable subtasks section
   - Enforces guardrails
   - Requires test-data plan for external I/O
   - Includes uncertainty protocol
   - **After user approves subtasks**: generates `design-docs/agents/<design-doc-name>.xml`

7. **Idempotency**:
   - Never overwrite existing templates without timestamped backup
   - Add new variants to `design-docs/templates/README.md`
</generation_steps>

<completion_criteria>
- `design-docs/` exists with README + templates index + `agents/` subdirectory
- `base.md` includes guardrails and human-readable subtasks section format
- At least one project-specific template variant exists with repo-specific test commands
- `$design-doc` skill exists and references templates correctly
- Skill workflow: human-readable subtasks in main doc → user approval → XML in `design-docs/agents/`
</completion_criteria>

<decision_points>
- No existing config directory → create one for current agent
- Multiple templates requested → generate each as separate variant file
- User wants immediate write vs preview → honor preference from question 6
</decision_points>

<failure_modes>
- Scan finds nothing → ask user for stack/commands explicitly
- Conflicting conventions → note in template as "resolve before use"
- Overwriting existing templates → create backup with timestamp first
</failure_modes>
