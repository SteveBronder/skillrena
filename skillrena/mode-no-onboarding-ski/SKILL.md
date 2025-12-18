---
name: mode-no-onboarding-ski
description: Mode behavior that disables onboarding while allowing normal work.

- Do not call `check_onboarding_performed-skl` or `onboarding-skl`.
- If project context is missing, discover it by reading files and asking the user; do not attempt to auto-onboard.
