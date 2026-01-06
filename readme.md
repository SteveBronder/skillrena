# Skillrena

![Skillrena Logo](./img/skillrena-logo.png)

Like [Serena](https://github.com/codegate-ai/serena), but way fewer tokens. It mostly boils down to giving your AI coding agent project memory without burning half your context window on MCP server overhead.

## Why Though?

Serena is great - it gives agents deep project understanding through MCP servers. But that understanding costs tokens. A lot of tokens.

| Approach | Token Cost | Setup |
|----------|------------|-------|
| Serena | ~50k+ tokens | MCP server required |
| Skillrena | ~4.5k tokens (all skills) | Copy some files, done |

That's it. Running `$activating-memories` to load your project memories adds about ~7.6k tokens in total. Still leaves plenty of room for actual work.

While serana also comes with a language server, agent cli's like claude now come with their own language servers, so that means we can focus on just keeping track of memories surrounding the projects goals.
### The Numbers

Using claude's `/context` command we can get an idea of how many tokens these skils all require when each is read in full.

```
     User
     └ bootstrapping-design-docs: 2.6k tokens
     └ generating-subtasks: 764 tokens
     └ writing-memories: 477 tokens
     └ activating-memories: 279 tokens
     └ switching-modes: 203 tokens
     └ recording-diary: 189 tokens
```

The `bootstrapping-design-docs` and `activating-memories` skills are meta skills which will be used for a session for setup. Then it is assumed the user will clear the context after they are done.


### Before/After Activation

Here is a before and after of claude's `/context` when we activate skillrena via `$activating-memories`

```
> /context
      Context Usage
     ⛁ ⛀ ⛁ ⛁ ⛁ ⛁ ⛁ ⛁ ⛁ ⛁   claude-opus-4-5-20251101 · 70k/200k tokens (35%)
     ⛁ ⛀ ⛁ ⛀ ⛶ ⛶ ⛶ ⛶ ⛶ ⛶ 
     ⛶ ⛶ ⛶ ⛶ ⛶ ⛶ ⛶ ⛶ ⛶ ⛶   ⛁ System prompt: 3.1k tokens (1.5%)
     ⛶ ⛶ ⛶ ⛶ ⛶ ⛶ ⛶ ⛶ ⛶ ⛶   ⛁ System tools: 19.1k tokens (9.5%)
     ⛶ ⛶ ⛶ ⛶ ⛶ ⛶ ⛶ ⛶ ⛶ ⛶   ⛁ Custom agents: 2.6k tokens (1.3%)
     ⛶ ⛶ ⛶ ⛶ ⛶ ⛶ ⛶ ⛶ ⛶ ⛶   ⛁ Messages: 8 tokens (0.0%)
     ⛶ ⛶ ⛶ ⛶ ⛶ ⛶ ⛶ ⛶ ⛶ ⛶   ⛶ Free space: 130k (65.2%)
     ⛶ ⛶ ⛶ ⛶ ⛶ ⛶ ⛶ ⛝ ⛝ ⛝   ⛝ Autocompact buffer: 45.0k tokens (22.5%)
     ⛝ ⛝ ⛝ ⛝ ⛝ ⛝ ⛝ ⛝ ⛝ ⛝ 
     ⛝ ⛝ ⛝ ⛝ ⛝ ⛝ ⛝ ⛝ ⛝ ⛝ 
     

> $activating-memories
> /context
      Context Usage
     ⛁ ⛀ ⛁ ⛁ ⛁ ⛁ ⛁ ⛁ ⛁ ⛁   claude-opus-4-5-20251101 · 77k/200k tokens (39%)
     ⛁ ⛀ ⛁ ⛁ ⛁ ⛁ ⛁ ⛶ ⛶ ⛶ 
     ⛶ ⛶ ⛶ ⛶ ⛶ ⛶ ⛶ ⛶ ⛶ ⛶   ⛁ System prompt: 3.1k tokens (1.5%)
     ⛶ ⛶ ⛶ ⛶ ⛶ ⛶ ⛶ ⛶ ⛶ ⛶   ⛁ System tools: 19.1k tokens (9.5%)
     ⛶ ⛶ ⛶ ⛶ ⛶ ⛶ ⛶ ⛶ ⛶ ⛶   ⛁ Custom agents: 2.6k tokens (1.3%)
     ⛶ ⛶ ⛶ ⛶ ⛶ ⛶ ⛶ ⛶ ⛶ ⛶   ⛁ Messages: 7.6k tokens (3.8%)
     ⛶ ⛶ ⛶ ⛶ ⛶ ⛶ ⛶ ⛶ ⛶ ⛶   ⛶ Free space: 123k (61.3%)
     ⛶ ⛶ ⛶ ⛶ ⛶ ⛶ ⛶ ⛝ ⛝ ⛝   ⛝ Autocompact buffer: 45.0k tokens (22.5%)
     ⛝ ⛝ ⛝ ⛝ ⛝ ⛝ ⛝ ⛝ ⛝ ⛝ 
     ⛝ ⛝ ⛝ ⛝ ⛝ ⛝ ⛝ ⛝ ⛝ ⛝ 
```

So ~7.6k tokens and your agent knows everything about your project. Not great, but not terrible.

## What You Need

Right now this works with:
- **[Claude Code](https://docs.anthropic.com/en/docs/claude-code)**
- **[Codex CLI](https://github.com/openai/codex)**


## Installation

There is no nice way to share skills at the moment. So we provide a script to copy skills to `~/.claude/skills/` and `~/.codex/skills/`.

```bash
./scripts/cp_skills.sh
```


To remove the skills call the script below. This will delete all Skillrena skills from both agent directories.

```bash
./scripts/remove_skills.sh
```

## **NOTE**:
- Codex doesn't do symlinks, so we have to hard copy in the agent's folder. :(
- Once codex fixes that then we will just symlink the skills in this folder into the codex directory.
- While codex allows for subfolders in the skills folder, claude does not. So the directory structure for codex will differ.
    - `.codex/skills/skillrena/<skill-name>/`
    - `.claude/skills/<skill-name>/`

## Skill Overview

### `$activating-memories`: Give the agent background information

When entering a project, call `$activating-memories` to either have the agent write memory skills in `.{AGENT_NAME}/skills/memories` or to skim the memories if they already exist.

```
$activating-memories
```

The agent reads your codebase and creates memories about what the project does, how to build it, your coding style.

**For the agents reading this**: `{AGENT_NAME}` in the skill files becomes `claude` or `codex` depending on which CLI is running. So `.{AGENT_NAME}/skills/memories/` turns into `.claude/skills/memories/` for Claude Code.

### `$switching-modes`: Switch modes for certain tasks

```
$switching-modes <mode>
```

| Mode | When | What It Does |
|------|------|--------------|
| `editing` | Changing code | Small diffs and  patches |
| `planning` | Thinking before coding | Reads everything, writes nothing, makes plans |
| `interactive` | Not sure what you want | Asks questions, confirms before doing stuff |
| `one-shot` | You know exactly what you want | Whomst amonst us  |
| `no-memories` | Testing, one-off stuff | Forget everything and start fresh |

### `$recording-diary`: Save what the agent learned this session

Before you close out or the context gets compacted call the diary for the llm to leave a little note to the next agent.

```
$recording-diary
```

Writes down the gotchas, workarounds, and "oh that's how that works" moments for next time.

The diary skill is a weird experiment I found from someone on twitter (sadly I cannot find the tweet). But the ideas is to make long term memories out of writing and summarizing diary entries from the agent before compaction. Then after a certain amount of diary entries exist, the agent updates the memory files with the information from the diary entries and removes the old diary entries.

#### Claude Code + Hookify to automate diary entries

If you're on Claude Code, check out [hookify](https://github.com/anthropics/claude-code-plugins/tree/main/hookify). You can use a pre compact hook to have the agent write a diary entry before compaction.

Example - no commits without tests:

```
/hookify:hookify "Before compaction, add a hook that will call the recording-diary skill"
```

### `$bootstrapping-design-docs`: Write a design doc template for your project

For multi-file features or complex changes, use `$bootstrapping-design-docs` to bootstrap a design-doc workflow in your repo:

```
$bootstrapping-design-docs
```

This creates:
- `design-docs/` folder with templates and active docs
- A project-specific `$design-doc` skill for creating new design documents

**Why use design docs?**

Agents tend to dive into implementation without thinking through the full scope. Design docs force upfront planning and include guardrails against common agent failure modes:

- **Reuse-first**: Search existing code before creating new utilities
- **No destructive shortcuts**: Never delete data to pass tests
- **Alternatives requirement**: Evaluate 2+ approaches before committing
- **Uncertainty protocol**: Ask clarifying questions instead of assuming

**Two-phase subtask workflow:**

1. **Planning**: Write human-readable subtasks in the design doc (easy to review/iterate)
2. **Execution**: After you approve, the agent generates structured XML in `design-docs/agents/` for reliable task parsing

Best for: Multi-file features, refactors, anything touching external APIs/databases

Skip for: Quick fixes, single-file changes, exploratory work

### `$generating-subtasks`: Make agent friendly version of a design doc

This skill takes a design document made with `$design-doc` and translates it into an agent friendly set of subtasks.

Agents can parse markdown, but Anthropic has found that agents respond better to structured formats like XML or JSON.

The agent will write a new `design-docs/agent/{DESIGN_NAME}.xml` file which future agents will use to complete the design.

## Orchestrator Plugin

The `skillrena/orchestrator` is a Claude Code plugin that takes design documents and orchestrates multi-agent teams to implement them. Think of it as a project manager that coordinates multiple specialized agents to build features in parallel.

### What It Does

Instead of having one agent try to implement an entire design doc, the orchestrator:

1. **Reviews the design** - Spawns expert reviewers to validate the design before writing any code
2. **Breaks it down** - Converts human-readable subtasks into machine-readable XML
3. **Coordinates builders** - Creates isolated git worktrees and spawns agents to implement each subtask in parallel
4. **Enforces quality gates** - Each subtask gets reviewed by multiple experts; must score >= 0.96 to pass
5. **Creates PRs** - Automatically opens pull requests when work passes all reviews

### Installation

The orchestrator is a Claude Code plugin located in `skillrena/orchestrator/`. To use it, you need to install it as a plugin (not a skill).

### Two-Stage Workflow

The orchestrator splits work into two phases for better context management:

#### 1. Design Review Phase

```bash
/orchestrator:design design-docs/active/my-feature/
```

This phase:
- Spawns 3 reviewers: design-doc-reviewer, cpp-performance-expert, hft-system-architect
- Iterates until all reviewers score >= 0.96
- Asks clarifying questions through human-in-the-loop prompts
- Generates XML subtasks and execution plan after approval

#### 2. Implementation Phase

```bash
/orchestrator:build design-docs/active/my-feature/
```

This phase:
- Creates git worktrees for each subtask (max 2 concurrent)
- Spawns builder agents in isolated environments
- Spawns reviewers for each implementation
- Automatically fixes issues or escalates to humans
- Creates PRs when quality gates are met

### Why Use It?

**For complex features**: When you need multiple files changed across the codebase, the orchestrator ensures:
- Work happens in parallel where possible
- Each piece gets dedicated attention from specialized agents
- Quality is enforced before merging
- Human oversight at critical checkpoints

**Token efficiency**: By splitting work across agents in isolated contexts, you avoid burning tokens on loading the entire codebase repeatedly.

### Commands

| Command | What It Does |
|---------|--------------|
| `/orchestrator:design <path>` | Review and approve a design document |
| `/orchestrator:build <path>` | Implement approved design with multi-agent coordination |
| `/orchestrator:help` | Get detailed help and workflow info |
| `/orchestrator:cancel` | Stop an active orchestration loop |

### Requirements

- Claude Code
- Git with worktree support
- GitHub CLI (`gh`) for PR creation

For more details, see `skillrena/orchestrator/README.md`.

## Problems?

Open an issue: [GitHub](https://github.com/SteveBronder/skillrena/issues/new)
