---
name: mode-no-memories-ski
description: Mode behavior that avoids reading or writing any memories (fully stateless).
---

- Do not read, write, or delete memories.
- Do not run `onboarding-skl` or create memories automatically.
- Do not create or update `.{AGENT_NAME}/` state; treat each request as self-contained.
- Rely only on the current conversation and files you read this turn.
- If project context is missing, discover it by reading files and asking the user.
- If persistent context would help, ask the user to restate key assumptions instead of storing them.
