# Skillrena

![Skillrena Logo](./img/skillrena-logo.png)

A lightweight skills-based system for AI coding agents. Like [Serena](https://github.com/codegate-ai/serena), but optimized for **minimal token usage** - no MCP servers, just focused markdown prompts.

## Why Skillrena?

Serena provides powerful project understanding through MCP servers, but that comes with token overhead. Skillrena achieves similar benefits with a fraction of the tokens:

| Approach | Token Cost | Setup |
|----------|------------|-------|
| Serena | ~50k+ tokens | MCP server required |
| Skillrena | ~2.9k tokens (all skills) | Copy files, done |

**Total skill overhead**: ~2,880 tokens for all 10 skills. Running `$activate-skl` to load project memories adds only ~9k tokens to your context.

### Token Cost Breakdown

```
Skills and slash commands · /skills
└ activate-skl: 765 tokens
└ onboarding-skl: 596 tokens
└ write_memory-skl: 432 tokens
└ mode-one-shot-ski: 178 tokens
└ diary-skl: 169 tokens
└ mode-no-memories-ski: 161 tokens
└ mode-editing-ski: 156 tokens
└ mode-interactive-ski: 147 tokens
└ mode-planning-ski: 145 tokens
└ switch_modes-skl: 131 tokens
```

### Context Before/After Activation

```
> /context (before $activate-skl)
    Context Usage
   ⛁ ⛀ ⛁ ⛁ ⛁ ⛁ ⛁ ⛁ ⛁ ⛁   claude-opus-4-5-20251101 · 70k/200k tokens (35%)
   ⛁ ⛀ ⛁ ⛀ ⛶ ⛶ ⛶ ⛶ ⛶ ⛶
   ...
   ⛁ Messages: 345 tokens (0.2%)

> $activate-skl
> /context (after)
    Context Usage
   ⛁ ⛀ ⛁ ⛁ ⛁ ⛁ ⛁ ⛁ ⛁ ⛁   claude-opus-4-5-20251101 · 79k/200k tokens (39%)
   ⛁ ⛀ ⛁ ⛁ ⛁ ⛁ ⛁ ⛶ ⛶ ⛶
   ...
   ⛁ Messages: 8.8k tokens (4.4%)
```

Only ~9k tokens added to load full project context - leaving plenty of room for actual work.

## Prerequisites

Skillrena currently works with:
- **[Claude Code](https://docs.anthropic.com/en/docs/claude-code)** - Anthropic's CLI for Claude
- **[Codex CLI](https://github.com/openai/codex)** - OpenAI's coding agent

You need one of these installed before using Skillrena.

## Installation

Copy skills to your agent's config directory:

```bash
./scripts/cp_skills.sh
```

This installs skills to both `~/.claude/skills/` and `~/.codex/skills/`.

To remove:

```bash
./scripts/remove_skills.sh
```

> **Note**: Codex does not support symlinks for skills, so hard copies are required.

## Quick Start

### 1. Activate at Session Start

Run this at the start of every session:

```
$activate-skl
```

This tells the agent to:
1. Check for existing project memories in `.claude/skills/memories/` (or `.codex/skills/memories/`)
2. If none exist, run onboarding to analyze your project and create memories
3. If memories exist, load them and summarize key points

> **Note for agents**: The `{AGENT_NAME}` placeholder in skill files resolves to `claude` or `codex` based on which CLI is running. So `.{AGENT_NAME}/skills/memories/` becomes `.claude/skills/memories/` when using Claude Code.

### 2. Switch Modes as Needed

Change agent behavior for different tasks:

```
$switch_modes-skl <mode>
```

| Mode | Use When | Behavior |
|------|----------|----------|
| `editing` | Making code changes | Minimal diffs, precise patches |
| `planning` | Designing before coding | Read-only analysis, produces plans, no edits |
| `interactive` | Uncertain requirements | Step-by-step, asks clarifying questions |
| `one-shot` | Clear task, want autonomy | End-to-end execution without questions |
| `no-memories` | Stateless work, testing | Ignores all memories |

### 3. Record Learnings (Optional)

Before ending a session or context compaction:

```
$diary-skl
```

Records gotchas, workarounds, and useful discoveries for future sessions.

## Example: First Time on a New Project

```
You: $activate-skl

Agent: I'll check for existing memories in .claude/skills/memories/...
       No memories found. Running onboarding to analyze this project.

       Reading: readme.md, package.json, src/, docs/...

       Creating memories:
       ✓ project_overview-skl - React app with Express backend
       ✓ suggested_commands-skl - npm run dev, npm test, npm run build
       ✓ style_and_conventions-skl - TypeScript, Prettier, Jest
       ✓ task_completion_checklist-skl - Run tests before commits

       Ready! This is a React/Express e-commerce app. Key commands:
       - npm run dev: Start dev server
       - npm test: Run Jest tests
       How can I help?
```

## Example: Returning to a Project

```
You: $activate-skl

Agent: Loading memories from .claude/skills/memories/...

       Project Summary:
       - Purpose: React/Express e-commerce app
       - Commands: npm run dev, npm test
       - Style: TypeScript, Prettier
       - Checklist: Tests must pass before commits

       Ready to continue. What would you like to work on?
```

## Example: Switching Modes

```
You: $switch_modes-skl planning

Agent: Switched to planning mode. I will:
       - Analyze and plan without making edits
       - Produce detailed plans with evidence
       - Ask clarifying questions about requirements

You: I want to add user authentication

Agent: Let me analyze the codebase and create an auth implementation plan...

       [Reads existing code, identifies patterns]

       ## Authentication Plan

       ### Option A: JWT with httpOnly cookies
       - Pros: Stateless, works with your existing Express setup
       - Files to create: src/middleware/auth.ts, src/routes/auth.ts
       - Files to modify: src/app.ts, src/types/index.ts

       ### Option B: Session-based with Redis
       - Pros: Easy revocation, familiar pattern
       - Requires: Redis instance

       Which approach do you prefer?
```

## Available Skills

### Core Skills (`-skl` suffix, user-invocable)

| Skill | Purpose |
|-------|---------|
| `activate-skl` | Session entry point - loads memories, triggers onboarding if needed |
| `onboarding-skl` | Analyzes project and creates baseline memory skills |
| `switch_modes-skl` | Changes agent mode |
| `write_memory-skl` | Writes/updates memory files with proper format |
| `diary-skl` | Records session learnings before compaction |

### Mode Definitions (`-ski` suffix, internal)

| Mode | File |
|------|------|
| Editing | `mode-editing-ski` |
| Planning | `mode-planning-ski` |
| Interactive | `mode-interactive-ski` |
| One-shot | `mode-one-shot-ski` |
| No-memories | `mode-no-memories-ski` |

## How It Works

### Memory System

When you run `$activate-skl` on a new project, the agent creates four baseline memories:

- `project_overview-skl` - Purpose, architecture, key components
- `suggested_commands-skl` - Build, test, run commands
- `style_and_conventions-skl` - Code style, naming, patterns
- `task_completion_checklist-skl` - Verification steps

These are stored in `.claude/skills/memories/` (Claude Code) or `.codex/skills/memories/` (Codex).

### Directory Structure After Onboarding

```
your-project/
├── .claude/
│   └── skills/
│       └── memories/
│           ├── project_overview-skl/
│           │   └── SKILL.md
│           ├── suggested_commands-skl/
│           │   └── SKILL.md
│           ├── style_and_conventions-skl/
│           │   └── SKILL.md
│           └── task_completion_checklist-skl/
│               └── SKILL.md
└── ... your code ...
```

### Typical Workflow

```
Session 1 (New Project):
  $activate-skl → runs onboarding → creates memories

Session 2+:
  $activate-skl → loads memories → ready to work
  $switch_modes-skl editing → precise code changes
  $diary-skl → record what you learned
```

## Claude Code: Hookify Integration

For Claude Code users, you can enhance Skillrena with [hookify](https://github.com/anthropics/claude-code-plugins/tree/main/hookify) - a Claude Code plugin that creates hooks to prevent unwanted agent behaviors.

Example: Prevent the agent from committing without running tests:

```
/hookify:hookify "Block commits if tests haven't been run in this session"
```

Hookify complements Skillrena's mode system by adding guardrails that persist across sessions.

## Naming Conventions

- `-skl`: User-invocable skills (e.g., `activate-skl`)
- `-ski`: Internal mode definitions (e.g., `mode-editing-ski`)
- Memory skills also use `-skl` suffix

## Feedback

Report issues or suggestions on [GitHub](https://github.com/SteveBronder/skillrena/issues/new).
