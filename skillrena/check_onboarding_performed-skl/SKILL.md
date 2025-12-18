---
name: check_onboarding_performed-skl
description: Check whether `.skillrena/memories/` exists and is non-empty.
---

Check `.skillrena/memories/` and return JSON only:
- If missing/empty: `{ "onboarded": false, "memories": [] }`
- Else: `{ "onboarded": true, "memories": [...] }` (basenames, no `.md`, sorted)
