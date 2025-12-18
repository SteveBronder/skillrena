---
name: switch_modes-skl
description: Switch the agent's active mode.
---

Input: `mode` (string) or `modes` (list of strings); common usage is `$switch_modes-skl <mode>`.

- Determine requested mode(s):
  - If the user provided a single mode name, treat it as `mode`.
  - If the user provided a list, treat it as `modes` and set `mode` to the first entry.
- Supported modes (and their mode-skill names):
  - `editing` -> `mode-editing-ski`
  - `interactive` -> `mode-interactive-ski`
  - `no-memories` -> `mode-no-memories-ski`
  - `no-onboarding` -> `mode-no-onboarding-ski`
  - `onboarding` -> `mode-onboarding-ski`
  - `one-shot` -> `mode-one-shot-ski`
  - `planning` -> `mode-planning-ski`
- Ensure `.skillrena/` exists.
- Write/overwrite `.skillrena/state.json` with:
  - `{ "mode": "<mode>", "modes": ["<mode>", ...] }`
- Reply with:
  - A 1-line confirmation of the active mode, and
  - A short list of available mode skills (the mapping above).
