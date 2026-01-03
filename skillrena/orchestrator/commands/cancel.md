---
description: Cancel an active orchestrator loop
---

# Cancel Orchestrator Loop

Canceling the orchestrator loop...

```bash
if [ -f .claude/orchestrator-loop.local.md ]; then
  echo "Current loop state:"
  echo ""
  head -15 .claude/orchestrator-loop.local.md
  echo ""

  # Extract loop type for informative message
  LOOP_TYPE=$(grep '^current_loop:' .claude/orchestrator-loop.local.md | sed 's/current_loop: *//' | sed 's/^"\(.*\)"$/\1/')
  ITERATION=$(grep '^iteration:' .claude/orchestrator-loop.local.md | sed 's/iteration: *//')

  rm .claude/orchestrator-loop.local.md

  echo "Orchestrator loop canceled."
  echo "  Loop type: $LOOP_TYPE"
  echo "  Iteration: $ITERATION"
  echo ""
  echo "The session can now exit normally."
  echo ""
  echo "To restart:"
  echo "  Design review: /orchestrator:design <path>"
  echo "  Implementation: /orchestrator:build <path>"
else
  echo "No active orchestrator loop found."
  echo ""
  echo "State file not present: .claude/orchestrator-loop.local.md"
fi
```

## What This Does

1. Removes the orchestrator loop state file (`.claude/orchestrator-loop.local.md`)
2. The Stop hook will no longer intercept session exit
3. You can now exit normally or start a fresh loop

## After Canceling

Your work is preserved:
- Worktrees remain in `.worktrees/`
- Design reviews remain in `{path}/design-reviews/`
- Build reviews remain in `{path}/build-reviews/`
- `pr_tracker.md` retains current status
- Any commits made by agents are preserved
- Generated XML subtasks remain in `{path}/subtasks/`
- Batch plan remains in `{path}/plan/`

To resume later:
1. Update `pr_tracker.md` with current status if needed
2. Run `/orchestrator:design <path>` or `/orchestrator:build <path>` to restart

## Caution

Canceling mid-iteration means:
- Current reviewer/fixer work may be lost
- You may need to manually update `pr_tracker.md`
- Uncommitted changes in worktrees should be checked

```bash
# Check for uncommitted changes in worktrees
for wt in .worktrees/*/; do
  if [ -d "$wt" ]; then
    echo "=== $(basename $wt) ==="
    cd "$wt" && git status --short && cd - > /dev/null
  fi
done
```
