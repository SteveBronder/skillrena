---
name: skillrena-check_onboarding_performed
description: Check whether `.skillrena/memories/` exists and is non-empty.
---

# Skillrena: check_onboarding_performed

Check `.skillrena/memories/`:
- If missing/empty: respond “Onboarding not performed; run `skillrena-onboarding`.”
- Else: return JSON list of memory basenames (no `.md`).
