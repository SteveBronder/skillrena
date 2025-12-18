---
name: serena-check_onboarding_performed
description: Check whether Serena onboarding exists for the active project; run right after activate_project.
---

# Serena: check_onboarding_performed

Use this immediately after `activate_project` to decide whether you need to run `onboarding`.

## Workflow
1. Call `check_onboarding_performed`.
2. If onboarding is not complete, call `onboarding`.
3. Once onboarding is done, follow its instructions to persist findings via `write_memory`.

## Notes
- Rerun onboarding if the repo structure or build/test workflow changes significantly.

