## `skillrena/data-storytelling-skl/SKILL.md`

```markdown
---
name: data-storytelling-skl
description: Turn analysis results into a stakeholder-ready narrative with a tight claim-evidence structure and explicit decisions.
---

Goal
- Convert raw analysis (tables/metrics/plots) into a compelling, decision-oriented story:
  - What is happening?
  - Why does it matter?
  - What should we do next?

Inputs
- One or more of:
  - a dataset path (CSV/Parquet/JSON)
  - an analysis notebook or script
  - a set of results (metrics, tables, plots)
  - a plain-English question or decision to support

Outputs
- `docs/story/<slug>/story_outline.md` containing:
  - audience, decision, core claim
  - 5–9 “beats” (mini-stories) with evidence pointers
  - risks/unknowns and what would change the decision
- `docs/story/<slug>/slide_script.md` (speaker-notes style) OR `docs/story/<slug>/one_pager.md`
- A short checklist: “What to verify before presenting”

Templates
- `story_outline.md`
  - Title:
  - Audience:
  - Decision:
  - Core claim:
  - Confidence:
  - Beats:
    - Beat 1: <headline>
      - Evidence:
      - So what:
      - Decision impact:
  - Alternatives considered:
  - Risks/unknowns:
  - What would change the decision:
- `slide_script.md` or `one_pager.md`
  - Opening:
  - Key evidence:
  - Recommendation:
  - Risks/mitigations:
  - Ask/next steps:

Constraints / Guardrails
- Do not invent metrics, results, or causal claims. If evidence isn’t present, mark it as unknown.
- Every claim must point to evidence using this format:
  - `path/to/file:line` or `notebook.ipynb#cell-12` or `query.sql#L10`.
- Keep content decision-first; avoid “data dump” sections.
- If this repo has existing docs templates, reuse them.

Procedure
1. Discover context
   - `ls docs/` and `rg -n "one[- ]pager|template|slides|ADR|decision" docs/`
   - Identify existing conventions (folder structure, voice, headings).
2. Identify audience and decision
   - Extract or infer:
     - audience (exec, eng, research, customer)
     - decision to be made (ship, rollback, invest, deprecate, change thresholds)
   - If decision is unclear, default to: “What action should we take next, given the evidence?”
3. Build the “core claim” (one sentence)
   - Format: “We should <action> because <most important evidence> (with <confidence>).”
4. Construct a beat map (5–9 beats)
   - Each beat must include:
     - headline (1 sentence)
     - 2–4 bullets of evidence
     - “so what” (1 bullet)
     - “decision impact” (1 bullet)
5. Create artifacts
   - Use `apply_patch` to create:
     - `docs/story/<slug>/story_outline.md`
     - `docs/story/<slug>/slide_script.md` (or `one_pager.md`)
6. Verification pass
   - Ensure every claim has evidence pointers.
   - Ensure you included:
     - alternatives considered
     - risks + mitigations
     - “what would change my mind” section

Decision rules
- `<slug>`: lowercase, hyphenated, derived from decision or question.
- Use `one_pager.md` for executive/brief updates; use `slide_script.md` for longer walkthroughs.

Acceptance Checklist
- [ ] Core claim is explicit and action-oriented.
- [ ] Every claim cites evidence (file/cell/query pointer).
- [ ] Beats are <10 and each has a clear “so what”.
- [ ] Unknowns are explicitly labeled (not implied away).
- [ ] Output matches repo doc conventions (headings, tone, location).

Notes
- If plots exist, reference their file paths; don’t embed unless repo convention supports it.
- If data is large, summarize with top-line metrics and link to deeper appendix.
```

---

## `skillrena/python-data-viz-skl/SKILL.md`

```markdown
---
name: python-data-viz-skl
description: Generate reproducible, repo-standard Python visualizations (static + optional interactive) with saved artifacts and a short readme.
---

Goal
- Create clear, correct visualizations from a dataset or analysis output and save them as artifacts (PNG/SVG and optionally HTML).

Inputs
- Dataset path(s) and the “question” the visualization should answer
- Optional: existing analysis script/notebook, or target columns/time window

Outputs
- `reports/viz/<slug>/` containing:
  - `viz.py` (or `viz.ipynb` if repo prefers notebooks)
  - `figures/` with saved plots (PNG/SVG)
  - optional `dashboard.html` (Plotly/Bokeh) if requested/appropriate
  - `README.md` explaining how to reproduce

Templates
- `viz.py` skeleton (argparse, input/output paths, filters)
- `README.md`:
  - How to run
  - Data contract (schema + assumptions)
  - Figure list with purpose
  - Known limitations

Constraints / Guardrails
- Prefer repo-standard tooling (ruff/black, uv/poetry, etc.). Discover it—do not guess.
- Visual correctness over aesthetics:
  - labeled axes, units, timezones, sampling, and aggregation choices must be explicit.
- Do not silently change data (filters/joins); log transformations.
- Accessibility: readable fonts, colorblind-safe palettes, and legends.

Procedure
1. Detect repo standards
   - `ls` and check for `pyproject.toml`, `requirements.txt`, `uv.lock`, `poetry.lock`
   - `rg -n "matplotlib|plotly|bokeh|seaborn" -S .`
   - Determine formatting/testing commands from docs or CI config.
2. Load data safely
   - Implement explicit schema assumptions (dtypes, parsing dates).
   - Validate row counts and missingness; write a brief “data contract” section in README.
3. Choose plot types tied to the question
   - Distribution → histogram/ECDF/box
   - Relationship → scatter + trend / heatmap
   - Time series → line with rolling stats, event markers
   - Composition → stacked area or bar
4. Implement `viz.py`
   - Provide CLI flags:
     - input path, output dir, optional filters
   - Save figures to `reports/viz/<slug>/figures/`
   - Default DPI: 200+ and deterministic filenames.
5. Repro instructions
   - Write `README.md`:
     - how to run
     - what each figure means
     - key assumptions (aggregation, filters)
6. Validate
   - Run the script end-to-end.
   - If repo uses tests, add a lightweight smoke test that ensures artifacts are produced.

Decision rules
- Use Plotly/Bokeh only when interactivity provides clear value; otherwise matplotlib.
- If multiple toolchains exist, follow the one used in CI.

Acceptance Checklist
- [ ] All figures have titles/axes/units and readable legends where relevant.
- [ ] Transformations are explicit and documented.
- [ ] Outputs are saved to the specified folder (no “only shown inline”).
- [ ] Reproduction steps work with repo toolchain.
- [ ] Optional: smoke test included and passing.

Notes
- If performance is an issue, use Polars/Arrow and avoid loading full data when unnecessary.
- File naming: `<slug>_<figure-name>.(png|svg)`.
```

---

## `skillrena/data-cleaning-skl/SKILL.md`

```markdown
---
name: data-cleaning-skl
description: Build a repeatable data cleaning pipeline that logs decisions, validates quality, and outputs a clean dataset + report.
---

Goal
- Produce a cleaned dataset suitable for modeling/analysis, with a transparent log of every cleaning decision and QA checks.

Inputs
- Raw dataset path(s)
- Target schema (if available) or downstream requirements (columns, types, constraints)

Outputs
- `data/clean/<dataset_name>/` containing:
  - `clean.py` (or `pipeline.py`)
  - `cleaned.<format>` (parquet preferred when feasible)
  - `data_quality_report.md` (summary + stats)
  - `decisions.json` (machine-readable cleaning decisions)

Templates
- `decisions.json` schema:
  - dataset
  - run_id
  - steps[]: { name, reason, params, before_count, after_count, notes }
- `data_quality_report.md`:
  - Before/after row counts
  - Missingness table
  - Invalid value summary
  - Key invariants
  - Lineage note

Constraints / Guardrails
- Never drop/transform data silently. Every destructive step must be logged.
- Prefer reversible transformations; keep raw data untouched.
- If downstream constraints exist (db schema, model expectations), validate against them.

Procedure
1. Discover downstream constraints
   - Search for consumers:
     - `rg -n "<dataset_name>|table_name|read_parquet|read_csv" -S src/`
     - check db schemas/migrations if relevant
2. Profile the raw dataset
   - Compute:
     - row counts, unique keys, duplicates
     - missingness per column
     - type inference and invalid parses
     - outlier heuristics (domain-aware)
3. Implement a cleaning pipeline
   - Steps (apply only as justified):
     - de-duplication (define key)
     - structural normalization (trim, casefold categories, standardize codes)
     - missing data strategy (drop vs impute vs keep-null with downstream-safe handling)
     - outlier policy (keep unless clearly invalid; document rule)
4. Validate and QA
   - Add assertions:
     - schema: required columns + dtypes
     - invariants: monotonic time, positive quantities, etc.
     - referential integrity (if joins)
   - Produce `data_quality_report.md` with before/after tables.
5. Output artifacts
   - Save cleaned dataset and decisions log.
   - If repo uses tests, add a small test that runs the pipeline on a tiny fixture.

Decision rules
- Version outputs by date or hash to avoid overwriting.
- Use parquet unless a consumer requires CSV.

Acceptance Checklist
- [ ] Raw data remains untouched; cleaned output is separate.
- [ ] All destructive operations are logged with counts.
- [ ] Schema/invariant checks exist and are enforced.
- [ ] A human-readable quality report is generated.
- [ ] Pipeline is rerunnable and deterministic.

Notes
- If data is huge, implement chunking/streaming and summarize stats from samples + counts.
```

---

## `skillrena/unit-testing-skl/SKILL.md`

```markdown
---
name: unit-testing-skl
description: Add high-signal tests (unit + small integration) with fixtures and clear failure messages; enforce as a “definition of done”.
---

Goal
- Create tests that prevent regressions, support refactors, and encode expected behavior.

Inputs
- Target module/function(s) or a bug report/issue to regression-test
- Existing test framework details (pytest/unittest/etc.)

Outputs
- New/updated tests in the repo’s test location
- Optional: fixtures under `tests/fixtures/`
- A short `TESTPLAN.md` note (if repo convention supports) for non-obvious cases

Templates
- `TESTPLAN.md`:
  - Scope
  - Behaviors covered
  - Edge cases
  - Known gaps

Constraints / Guardrails
- Tests must be deterministic (no network/time randomness unless controlled).
- Tests should assert behavior, not implementation details, unless necessary.
- Prefer small, composable tests; avoid giant “everything” tests.

Procedure
1. Detect test conventions
   - Locate tests: `find . -maxdepth 4 -type d -name "tests" -o -name "test"`
   - Identify runner in CI/docs: `rg -n "pytest|unittest|tox|nox" -S .github docs/ pyproject.toml`
2. Identify behaviors to encode
   - For each target function:
     - nominal case
     - boundary cases
     - error cases (invalid inputs)
     - invariants (monotonicity, shape, idempotence, etc.)
3. Write tests
   - Use fixtures for shared setup.
   - Parameterize for edge-case coverage.
   - Use meaningful assertion messages.
4. Add a regression test for known bugs
   - Minimal reproducer (small input) that fails before and passes after the fix.
5. Run the suite locally
   - Execute repo-standard command(s); ensure no new flakiness.
6. Tighten feedback loop
   - If slow, mark expensive tests and keep unit tests fast.

Decision rules
- Place tests alongside existing test layout; if none exists, create `tests/` and `test_<module>.py`.
- Use snapshot tests only when output is large and stable.

Acceptance Checklist
- [ ] Tests cover nominal + edge + error cases.
- [ ] Tests are deterministic and do not depend on external services.
- [ ] Tests fail meaningfully when behavior changes.
- [ ] Suite passes locally with repo-standard command.

Notes
- If the repo favors TDD, write failing tests first, then implement the fix.
- Prefer a small number of high-signal tests over shallow “coverage padding”.
```

---

## `skillrena/code-refactoring-skl/SKILL.md`

```markdown
---
name: code-refactoring-skl
description: Refactor safely: establish a baseline, add/verify tests, perform behavior-preserving changes, and document rationale.
---

Goal
- Improve structure (readability, maintainability, extensibility) while preserving external behavior.

Inputs
- Target area (module/function/package)
- Motivation (performance, clarity, duplication, bug risk)

Outputs
- Refactored code
- Updated/added tests confirming unchanged behavior
- `docs/refactors/<slug>.md` (or similar) describing what changed and why

Templates
- Baseline capture:
  - Public APIs touched
  - Key inputs/outputs
  - Performance notes (if relevant)
- Refactor report:
  - Intent
  - Non-goals
  - Before/after structure
  - Risks

Constraints / Guardrails
- No behavior change unless explicitly requested; if behavior changes, it must be documented and tested.
- Refactor must be test-backed. If tests are missing, add them first.
- Keep diffs reviewable: prefer a sequence of small commits/patches.

Procedure
1. Establish baseline
   - Identify existing tests and run them.
   - Capture a baseline “before”:
     - key outputs, performance metrics (if relevant), public API surface.
2. Add missing characterization tests
   - If behavior is not documented, write tests that capture current behavior.
3. Refactor in small steps
   - Techniques:
     - extract method/function
     - rename for clarity
     - remove duplication
     - isolate side effects
     - separate pure logic from IO
4. Maintain compatibility
   - Keep public interfaces stable (function signatures, CLI flags, module paths).
   - If you must change APIs, add a deprecation layer and document it.
5. Verify continuously
   - Run tests after each meaningful change.
   - If performance matters, rerun benchmarks.
6. Document refactor
   - Write `docs/refactors/<slug>.md`:
     - intent, non-goals, before/after structure, risks.

Decision rules
- Separate formatting-only changes from logic changes when possible.
- Inventory public APIs before refactor; avoid breaking changes.

Acceptance Checklist
- [ ] Tests pass; refactor is behavior-preserving (or behavior change is explicit + tested).
- [ ] Diff is reviewable; changes are logically grouped.
- [ ] Complexity is reduced (measurably or clearly: fewer branches, smaller functions, less duplication).
- [ ] Documentation exists for rationale and future maintenance.

Notes
- Prefer “characterization tests” for legacy code before altering structure.
- Avoid mixing formatting-only changes with logic changes unless repo conventions require it.
```

---

## `skillrena/secure-code-review-skl/SKILL.md`

```markdown
---
name: secure-code-review-skl
description: Perform a manual secure code review and produce a prioritized findings report with concrete remediation steps.
---

Goal
- Identify security risks that automated tools may miss and provide actionable fixes.

Inputs
- Scope: file paths/modules, service boundaries, or “entire repo”
- Threat context (web app, CLI, trading system, data pipeline, etc.)

Outputs
- `security/reviews/<date>-<slug>/report.md` containing:
  - scope and methodology
  - findings table (severity, impact, likelihood, evidence)
  - concrete remediation steps
  - “quick wins” vs “structural fixes”
- Optional: patch implementing quick fixes + tests

Templates
- Threat model:
  - Assets, actors, entrypoints, trust boundaries
- Finding format:
  - Title, Severity, Impact, Evidence, Exploit scenario, Remediation

Constraints / Guardrails
- Do not claim vulnerabilities without evidence (code pointers).
- Prefer least-privilege, explicit validation, and secure defaults.
- If repo already has a security policy/template, use it.

Procedure
1. Determine entry points and trust boundaries
   - Identify:
     - network handlers, parsers, deserializers
     - authn/authz checks
     - secrets handling
     - data sinks (db writes, shell commands, file writes)
2. Manual review checklist (adapt to repo)
   - Input validation and output encoding
   - Injection risks (SQL, shell, template)
   - Authn/authz correctness and bypass paths
   - Secret handling (env files, logs, key storage)
   - Cryptography usage (algorithms, key management, randomness)
   - Error handling (leaks, stack traces, sensitive logs)
3. Evidence collection
   - For each issue:
     - file path + line numbers
     - exploit scenario
     - recommended fix
4. Prioritize
   - Severity rubric:
     - Critical: remote exploit/data exfil/priv escalation
     - High: auth bypass, injection with constraints
     - Medium: leakage, weak defaults
     - Low: hardening
5. Produce report
   - Create folder and report using `apply_patch`.
6. Optional remediation patch
   - Implement “quick wins” with tests (input validation, sanitize logging, tighten permissions).

Decision rules
- For large repos, add a lightweight dataflow sketch before deep diving.
- Flag likely false positives and note validation steps.

Acceptance Checklist
- [ ] Report includes scope, methodology, and assumptions.
- [ ] Every finding includes evidence and a remediation plan.
- [ ] Findings are prioritized with a consistent rubric.
- [ ] Quick wins are patched (if feasible) with tests.

Notes
- If automated scanners exist in CI, incorporate their output but do not rely on it alone.
- Treat parsing and deserialization code as high-risk by default.
```

---

## `skillrena/documentation-docstrings-skl/SKILL.md`

```markdown
---
name: documentation-docstrings-skl
description: Enforce consistent docstrings and docs: add missing docstrings, standardize format, and generate minimal usage docs for public APIs.
---

Goal
- Improve maintainability by ensuring public APIs are documented consistently and discoverably.

Inputs
- Target package/module (or repo-wide)
- Repo doc conventions (if present)

Outputs
- Updated source files with standardized docstrings
- `docs/api/<module>.md` (optional) summarizing public API usage
- A small “doc compliance” checklist for future changes

Templates
- Docstring template (adapt to repo style):
  - Summary
  - Args/Parameters
  - Returns
  - Raises
  - Examples

Constraints / Guardrails
- Docstrings must describe behavior and constraints, not internal implementation.
- Do not lie in documentation; if behavior is unclear, verify by reading tests or running examples.
- Match existing style (Google/Numpy/Sphinx) if repo already uses one—detect it.

Procedure
1. Detect conventions
   - Find doc tooling: `rg -n "sphinx|mkdocs|pdoc|pydocstyle|ruff.*D" -S pyproject.toml docs/`
   - Find docstring style examples in repo and follow them.
2. Inventory public API
   - Identify exported modules/classes/functions.
   - Flag missing/weak docstrings.
3. Write/upgrade docstrings
   - For each public callable:
     - one-line summary
     - parameters (types/meaning)
     - returns
     - raises (exceptions)
     - invariants/units/timezones where relevant
     - small example when non-obvious
4. Generate minimal API docs (optional)
   - Create `docs/api/<module>.md`:
     - quickstart snippet
     - common use cases
     - gotchas
5. Add checks (optional)
   - If repo uses ruff/pydocstyle, ensure doc rules pass.
   - Optionally add a CI step if missing and repo wants enforcement.

Decision rules
- Public API detection: exports, `__all__`, or re-exports in `__init__.py`.
- Verify behavior via tests or small repros before documenting.

Acceptance Checklist
- [ ] Public APIs have docstrings in the repo’s preferred style.
- [ ] Docstrings match actual behavior (verified via tests/examples).
- [ ] Any new docs are discoverable under `docs/` and follow existing structure.
- [ ] Lint/doc checks pass (if present).

Notes
- For fast-moving code, focus docstrings on contracts and invariants rather than details.
- Prefer documenting “what can go wrong” (raises, edge cases) in addition to happy path.
```

---

## `skillrena/cicd-pipeline-skl/SKILL.md`

```markdown
---
name: cicd-pipeline-skl
description: Design or modify CI/CD so every change runs lint/tests/build, produces artifacts, and fails fast with actionable logs.
---

Goal
- Create a reliable CI pipeline (and optional CD) aligned to repo standards, with fast feedback and reproducible environments.

Inputs
- Current CI system (if any) and desired triggers (push, PR, release)
- Required checks: lint, typecheck, unit tests, integration tests, build, packaging

Outputs
- Updated CI config (e.g., `.github/workflows/*.yml`)
- `docs/ci.md` explaining:
  - what runs when
  - how to run locally
  - how to debug failures
- Optional: caching, matrices, artifact uploads

Templates
- Pipeline stages:
  - checkout
  - setup runtime
  - install deps
  - lint/typecheck
  - unit tests
  - integration tests
  - build/package
  - upload artifacts

Constraints / Guardrails
- Do not invent commands. Derive them from:
  - `pyproject.toml`, Makefile, scripts/, docs, or existing CI.
- Prefer fail-fast stages: lint/typecheck before long tests.
- Keep pipelines readable and maintainable.

Procedure
1. Discover current CI/CD
   - `ls .github/workflows || true`
   - `rg -n "pytest|ruff|mypy|poetry|uv|npm|cargo|go test|cmake" -S .github/workflows docs/ Makefile pyproject.toml`
2. Define the pipeline contract
   - Identify mandatory stages:
     - source checkout
     - dependency install (pinned)
     - static checks (lint/typecheck)
     - tests (unit → integration)
     - build/package
     - artifact upload (if relevant)
3. Implement or update workflows
   - Use matrices only when valuable (OS, Python versions).
   - Add caching keyed to lockfiles.
   - Ensure logs are clear and steps are named.
4. Add local parity
   - Document “run locally” commands in `docs/ci.md`.
   - Ensure CI uses the same commands as local scripts.
5. Verify
   - Run the workflow logic locally if possible (or at least run the underlying commands).
   - Confirm checks are required on PRs if repo policy expects it.

Decision rules
- Cache key: hash of lockfiles and toolchain version.
- Secrets: do not expose on PRs from forks; use restricted contexts.

Acceptance Checklist
- [ ] CI runs lint/typecheck/tests on PRs.
- [ ] Commands match repo tooling and are documented.
- [ ] Pipeline fails fast and provides actionable logs.
- [ ] Artifacts (if any) are saved in predictable locations.
- [ ] Caching does not risk stale/incorrect builds (keyed to lockfiles).

Notes
- If CD is included, require explicit release/tag triggers and add a rollback story.
- Prefer incremental hardening: get green baseline first, then optimize.
```

---

## `skillrena/exception-logging-skl/SKILL.md`

```markdown
---
name: exception-logging-skl
description: Implement robust error handling and structured logging: explicit exception taxonomy, avoid catch-all, preserve context, and add tests.
---

Goal
- Improve system reliability and debuggability by:
  - defining an application-specific error taxonomy,
  - handling exceptions narrowly,
  - preserving causal context,
  - adding structured logs and tests.

Inputs
- Target module/service (or cross-cutting error handling)
- Current logging approach (if any)

Outputs
- New/updated exception classes (e.g., `src/<pkg>/errors.py`)
- Updated code paths with precise try/except and structured logs
- Tests validating:
  - correct exception types
  - preservation of context
  - correct logging behavior (where testable)
- `docs/errors.md` describing the error taxonomy and handling guidance

Templates
- Error taxonomy table:
  - Error name, code, retryable, description
- Log fields:
  - event, error_code, message, context, trace_id, retryable, severity

Constraints / Guardrails
- Never add blanket `except Exception:` unless there is a documented, reviewed boundary (top-level process boundary).
- Do not swallow exceptions without logging and/or returning a typed error.
- Preserve original exception as cause (`raise X from e` in Python) where appropriate.

Procedure
1. Discover existing patterns
   - `rg -n "except Exception|try:|logger\\.|logging\\." -S src/`
   - Look for existing `errors.py`, `exceptions.py`, `Result` types, or error enums.
2. Define an error taxonomy
   - Typical categories:
     - ValidationError
     - ConfigurationError
     - ExternalServiceError
     - DataIntegrityError
     - AuthorizationError
     - NotFoundError
     - RetryableError vs NonRetryableError
3. Implement errors module
   - Create base `AppError` and typed subclasses.
   - Include fields that help debugging (code, context, retryable).
4. Replace catch-alls with narrow handlers
   - Catch only expected exceptions at the right boundaries.
   - Add context and re-raise with cause when needed.
5. Logging strategy
   - Use structured logs (key/value) where supported.
   - Ensure secrets are never logged.
   - Log once at the appropriate boundary (avoid duplicate spam).
6. Tests
   - Add tests for:
     - mapping of low-level exceptions to typed errors
     - retry classification
     - message/context integrity
7. Documentation
   - Write `docs/errors.md`:
     - error classes and when to use them
     - retry/backoff guidance
     - examples

Decision rules
- Place logging at boundaries (request handler, job runner), not in deep helpers.
- Use `caplog` or equivalent to test log output when available.

Acceptance Checklist
- [ ] No new blanket catch-alls without explicit justification.
- [ ] Typed exceptions exist and are used consistently.
- [ ] Error context is preserved (cause chains where appropriate).
- [ ] Logs are actionable and do not leak secrets.
- [ ] Tests cover error mapping and boundary behavior.

Notes
- For services: pair this skill with a “health checks + metrics” skill if you want SLO-grade robustness.
- For pipelines: ensure failures are surfaced with enough context to replay/debug.
```
