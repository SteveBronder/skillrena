---
description: Get help with the orchestrator plugin
---

# Orchestrator Plugin Help

## Overview

The orchestrator plugin coordinates multi-agent design review and implementation of features for the Kalshi HFT trading system. It uses iterative loops with quality gates to ensure production-ready code.

## Commands

| Command | Description |
|---------|-------------|
| `/orchestrator:design <path>` | Run design doc review loop with human-in-the-loop approval |
| `/orchestrator:build <path>` | Run implementation loop to build and review subtasks |
| `/orchestrator:help` | Show this help message |
| `/orchestrator:cancel` | Cancel an active orchestrator loop |

## Two-Stage Workflow

### Stage 1: Design Review (`/orchestrator:design`)

```
/orchestrator:design design-docs/active/my-feature/
```

This runs the **Design Review Loop**:
1. Validates directory structure and subplan quality
2. Spawns 3 reviewers in parallel:
   - `design-doc-reviewer` - Requirements, completeness, constraints
   - `cpp-performance-expert` - Hot paths, memory, latency
   - `hft-system-architect` - Risk, reliability, architecture
3. Iterates until all reviewers score >= 0.96
4. Handles "Questions for Human" via AskUserQuestion
5. Generates XML subtasks and batch plan after approval
6. Outputs `<promise>DESIGN_DOC_APPROVED</promise>`

**Directory Structure:**
```
design-docs/active/my-feature/
├── overview.md           # Main design doc
├── subplans/             # Human-readable subtask plans
│   ├── 01-common-types.md
│   ├── 02-orderbook-manager.md
│   └── ...
├── subtasks/             # XML files (generated after approval)
├── design-reviews/       # Reviews from design loop
├── build-reviews/        # Reviews from build loop
└── plan/                 # DAG and batch groups (generated)
    ├── dag.md
    └── batches.md
```

### Stage 2: Implementation (`/orchestrator:build`)

```
/orchestrator:build design-docs/active/my-feature/
```

This runs the **Implementation Loop**:
1. Reads XML subtasks and batch plan
2. Creates worktrees for each subtask
3. Spawns 3 reviewers per subtask (max 2 subtasks concurrent):
   - `orchestrator-reviewer` - Code correctness, testing
   - `cpp-performance-expert` - Performance analysis
   - `hft-system-architect` - Architecture review
4. If scores < 0.96, spawns appropriate fixer
5. When all scores >= 0.96, creates PR
6. Continues until all subtasks have PRs
7. Outputs `<promise>ALL_SUBTASKS_PR_CREATED</promise>`

## State Files

| File | Purpose |
|------|---------|
| `.claude/orchestrator-loop.local.md` | Loop state (iteration, phase) |
| `design-docs/orchestration/pr_tracker.md` | Subtask status and PR links |
| `{path}/design-reviews/` | Reviews from design loop |
| `{path}/build-reviews/{subtask}/` | Reviews from build loop |
| `{path}/plan/` | DAG and batch execution plan |

## Monitoring

```bash
# Check current iteration
grep '^iteration:' .claude/orchestrator-loop.local.md

# Check loop type
grep '^current_loop:' .claude/orchestrator-loop.local.md

# View recent design reviews
ls -lt design-docs/active/*/design-reviews/

# View recent build reviews
ls -lt design-docs/active/*/build-reviews/*/
```

## Canceling

To stop an active loop:

```
/orchestrator:cancel
```

This removes the loop state file and allows the session to exit normally.

## Agents

### Design Reviewers (score 0-1)

| Agent | Focus |
|-------|-------|
| `design-doc-reviewer` | Requirements, design completeness, constraints |
| `cpp-performance-expert` | Hot paths, memory, concurrency, latency |
| `hft-system-architect` | Risk management, reliability, architecture |

### Implementation Reviewers (score 0-1)

| Agent | Focus |
|-------|-------|
| `orchestrator-reviewer` | Code correctness, testing, maintainability |
| `cpp-performance-expert` | Hot paths, memory, concurrency, latency |
| `hft-system-architect` | Risk management, reliability, architecture |

### Fixers

| Agent | Use Case |
|-------|----------|
| `orchestrator-builder` | New implementations, missing code |
| `orchestrator-fixer` | Bug fixes, test failures, code issues |
| `cpp-performance-expert` | Performance issues, optimizations |

## Scoring

| Score | Meaning |
|-------|---------|
| 0.96+ | Production ready, create PR |
| 0.90-0.95 | Good, minor issues |
| 0.80-0.89 | Acceptable, some work needed |
| < 0.80 | Significant issues |

## Human-in-the-Loop

The orchestrator emphasizes human involvement:

1. **Reviewer Questions**: Reviewers can request human clarification
   - Questions appear in review headers under "Questions for Human"
   - Orchestrator uses AskUserQuestion with multiple choice format
   - Orchestrator attempts to answer from codebase first

2. **Approval Gates**:
   - Design loop waits for human "approved" before generating subtasks
   - Build loop creates PRs for human review

3. **Stuck Handling**:
   - After 3+ iterations without progress, asks human what to do
   - Options: Skip, Simplify scope, or Debug together

## Context Management

The orchestrator protects its context by:
1. Reading only review headers (~500 tokens each)
2. Passing full review paths to fixers
3. Using `$recording-diary` before `/compact`
4. Checking `/context` before reading large outputs

## Subplan Requirements

Each subplan in `subplans/` must:
- Be < 20K tokens
- Represent 1-2 days work max
- Define testable acceptance criteria
- List dependencies explicitly

## Troubleshooting

**Loop won't stop**: Use `/orchestrator:cancel`

**Context overflow**: The orchestrator should auto-manage this, but if stuck, cancel and restart

**Subtask blocked**: Check `pr_tracker.md` for the reason, ask orchestrator to simplify or skip

**No XML subtasks**: Run `/orchestrator:design` first to generate them

**Reviews not found**: Ensure review directories exist in the design path

## Example Workflow

```bash
# 1. Create design directory structure
mkdir -p design-docs/active/my-feature/{subplans,subtasks,design-reviews,build-reviews,plan}

# 2. Write overview.md and subplans
vim design-docs/active/my-feature/overview.md
vim design-docs/active/my-feature/subplans/01-core.md

# 3. Run design review
/orchestrator:design design-docs/active/my-feature/

# 4. Wait for approval, say "approved" when ready

# 5. Run implementation
/orchestrator:build design-docs/active/my-feature/

# 6. Review and merge PRs as they're created
```
