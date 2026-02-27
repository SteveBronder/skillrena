# Testing guidance (markdown)

## How to run tests
- Unit: N/A (no dedicated unit test harness in this repo).
- Integration: N/A.
- Practical validation checks:
  - `bash -n scripts/cp_skills.sh scripts/remove_skills.sh`
  - `find skillrena -maxdepth 2 -name SKILL.md -print`
  - `rg -n 'references/|assets/|scripts/' skillrena`

## Fast loop: run a single test
- Use one-file checks during editing:
  - `bash -n scripts/cp_skills.sh`
  - `rg -n '^name:|^description:' skillrena/<skill>/SKILL.md`

## Framework + config
- Framework: manual shell/script checks plus markdown lint tools if installed.
- Config files: none required; optional tool defaults apply.

## Test organization
- Script checks target `scripts/*.sh`.
- Skill integrity checks target `skillrena/*/SKILL.md` and referenced paths.

## Writing new tests (TDD)
- Preferred pattern (red -> green -> refactor):
  - Introduce failing check (or identify an existing failing check).
  - Apply minimal change.
  - Re-run targeted check, then full check set.
- Fixtures/utilities: rely on existing `scripts/` and skill templates before adding new tooling.

## Debugging failures
- Verbose reruns:
  - `bash -x scripts/cp_skills.sh`
  - `bash -x scripts/remove_skills.sh`
- Match CI locally: no CI workflow is present; use the same shell and commands documented here.

## Safety
- Do not run remove/install scripts against unintended environments.
- Ensure tests/checks do not touch external systems beyond local `$HOME` skill/plugin directories.
