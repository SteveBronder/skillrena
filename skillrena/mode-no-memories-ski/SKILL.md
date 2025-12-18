---
name: mode-no-memories-ski
description: Mode behavior that avoids reading or writing any memories.
---

- Do not read/write/delete memories and do not run onboarding; rely only on the current conversation and files you read this turn.
- Avoid creating or updating `.skillrena/` state; treat each request as self-contained.
- If persistent context would help, ask the user to restate key assumptions instead of storing them.
