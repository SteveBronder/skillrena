# Orchestrator Plugin

Multi-agent orchestrator for implementing design documents in a high-performance C++ trading system.

## Overview

This plugin takes a design document, decomposes it into independent implementation tasks, and coordinates a fleet of sub-agents to implement, review, optimize, and land each task via GitHub pull requests.

## Features

- **Design Document Analysis**: Parses and understands design docs, asks clarifying questions
- **Subtask Decomposition**: Breaks down work into independent, parallelizable subtasks
- **Multi-Agent Coordination**: Spawns builder, reviewer, fixer, and performance agents
- **Quality Gates**: Enforces code review, testing, and performance requirements
- **PR Creation**: Automatically creates PRs with evidence and traceability

## Usage

```bash
/orchestrator <path-to-design-doc>
```

Example:
```bash
/orchestrator design-docs/websocket-client.md
```

## Workflow

1. **Phase 1: Analysis** - Read and understand the design document
2. **Phase 2: Clarification** - Ask questions until confidence >= 0.8
3. **Phase 3: Decomposition** - Create subtask design docs and orchestration plan
4. **Phase 4: Execution** - Spawn agents to implement, review, and fix
5. **Phase 5: Completion** - Generate summary report and clean up

## Agents

| Agent | Purpose |
|-------|---------|
| `orchestrator-builder` | Implements subtasks in isolated worktrees |
| `orchestrator-reviewer` | Reviews code for correctness, tests, thread safety |
| `orchestrator-fixer` | Fixes blocking issues from reviews |
| `design-doc-reviewer` | Reviews design docs before implementation |

## Artifacts

All orchestration artifacts are stored in:
- `design-docs/orchestration/` - Plans and subtask design docs
- `design-docs/orchestration/reviews/` - Code review reports
- `design-docs/orchestration/perf/` - Performance reports
- `.worktrees/` - Git worktrees for each subtask

## Constraints

- Maximum 2 concurrent subtasks (to limit context from 6 reviewer outputs)
- Sub-agents use 1-2 threads for builds
- Branch naming: `feat/<subtask-name>`
- All file operations use absolute paths within worktree

## Requirements

- Git with worktree support
- GitHub CLI (`gh`) for PR creation
- CMake + Ninja for C++ builds
