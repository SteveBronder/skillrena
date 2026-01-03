---
description: Orchestrate multi-agent implementation (use /orchestrator:design or /orchestrator:build instead)
argument-hint: <path-to-design-directory>
---

# Orchestrator (Deprecated)

This command has been split into two separate commands for clarity:

## For Design Review

```
/orchestrator:design <path-to-design-directory>
```

Runs the design doc review loop:
- Validates subplan quality
- Spawns reviewers (design-doc-reviewer, cpp-performance-expert, hft-system-architect)
- Iterates until all score >= 0.96
- Handles human-in-the-loop questions
- Generates XML subtasks after approval

## For Implementation

```
/orchestrator:build <path-to-design-directory>
```

Runs the implementation loop:
- Reads XML subtasks and batch plan
- Creates worktrees for each subtask
- Spawns reviewers per subtask
- Spawns fixers for scores < 0.96
- Creates PRs when scores >= 0.96

## Other Commands

- `/orchestrator:help` - Get detailed help
- `/orchestrator:cancel` - Cancel an active loop

## Migration

If you were using the combined `/orchestrator` command:

1. Run `/orchestrator:design <path>` first
2. Wait for design approval
3. Run `/orchestrator:build <path>` for implementation

This separation allows:
- Better context management (two smaller prompts)
- Clearer human-in-the-loop checkpoints
- Ability to run design review without implementation
