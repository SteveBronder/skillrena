---
name: check_onboarding_performed-skl
description: Check whether `.skillrena/memories/` exists and is non-empty.
---

# Skillrena: check_onboarding_performed

Check `.skillrena/memories/`:
- If missing/empty: respond “Onboarding not performed; run `onboarding-skl`.”
- Else: return JSON list of memory basenames (no `.md`).
