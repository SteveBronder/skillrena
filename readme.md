# Skillrena

![Skillrena Logo](./img/skillrena-logo.png)

Like [Serena](https://github.com/codegate-ai/serena), but way fewer tokens. It mostly boils down to giving your AI coding agent project memory without burning half your context window on MCP server overhead.

## Why Though?

Serena is great - it gives agents deep project understanding through MCP servers. But that understanding costs tokens. A lot of tokens.

| Approach | Token Cost | Setup |
|----------|------------|-------|
| Serena | ~50k+ tokens | MCP server required |
| Skillrena | ~9k tokens (all skills) | Copy some files, done |

That's it. Running `$activate-skl` to load your project memories adds about 9k more. Still leaves plenty of room for actual work.

While serana also comes with a language server, agent cli's like claude now come with their own language servers, so that means we can focus on just keeping track of memories surrounding the projects goals.
### The Numbers

Using claude's `/context` command we can get an idea of how many tokens these skils all require when each is read in full.

```
 activate-skl · ~791 tokens
 diary-skl · ~189 tokens
 mode-no-memories-ski · ~168 tokens
 mode-interactive-ski · ~161 tokens
 mode-one-shot-ski · ~180 tokens
 mode-planning-ski · ~158 tokens
 mode-editing-ski · ~165 tokens
 onboarding-skl · ~617 tokens
 plan-plan · ~3.1k tokens
 switch_modes-skl · ~150 tokens
 write_memory-skl · ~466 tokens
```

The `plan-plan` and `activate-skl` skills are meta skills which will be used for a session for setup. Then it is assumed the user will clear the context after they are done.


### Before/After Activation

Here is a before and after of claude's `/context` when we activate skillrena via `$activate-skl`

```
> /context
  ⎿
      Context Usage
     ⛁ ⛀ ⛁ ⛁ ⛁ ⛁ ⛁ ⛁ ⛁ ⛁   claude-opus-4-5-20251101 · 70k/200k tokens (35%)
     ⛁ ⛀ ⛁ ⛀ ⛶ ⛶ ⛶ ⛶ ⛶ ⛶
     ⛶ ⛶ ⛶ ⛶ ⛶ ⛶ ⛶ ⛶ ⛶ ⛶   ⛁ System prompt: 3.1k tokens (1.6%)
     ⛶ ⛶ ⛶ ⛶ ⛶ ⛶ ⛶ ⛶ ⛶ ⛶   ⛁ System tools: 19.0k tokens (9.5%)
     ⛶ ⛶ ⛶ ⛶ ⛶ ⛶ ⛶ ⛶ ⛶ ⛶   ⛁ Custom agents: 2.6k tokens (1.3%)
     ⛶ ⛶ ⛶ ⛶ ⛶ ⛶ ⛶ ⛶ ⛶ ⛶   ⛁ Messages: 345 tokens (0.2%)
     ⛶ ⛶ ⛶ ⛶ ⛶ ⛶ ⛶ ⛶ ⛶ ⛶   ⛶ Free space: 130k (65.0%)
     ⛶ ⛶ ⛶ ⛶ ⛶ ⛶ ⛶ ⛝ ⛝ ⛝   ⛝ Autocompact buffer: 45.0k tokens (22.5%)
     ⛝ ⛝ ⛝ ⛝ ⛝ ⛝ ⛝ ⛝ ⛝ ⛝
     ⛝ ⛝ ⛝ ⛝ ⛝ ⛝ ⛝ ⛝ ⛝ ⛝

> $activate-skl
> /context
  ⎿
      Context Usage
     ⛁ ⛀ ⛁ ⛁ ⛁ ⛁ ⛁ ⛁ ⛁ ⛁   claude-opus-4-5-20251101 · 79k/200k tokens (39%)
     ⛁ ⛀ ⛁ ⛁ ⛁ ⛁ ⛁ ⛶ ⛶ ⛶
     ⛶ ⛶ ⛶ ⛶ ⛶ ⛶ ⛶ ⛶ ⛶ ⛶   ⛁ System prompt: 3.1k tokens (1.6%)
     ⛶ ⛶ ⛶ ⛶ ⛶ ⛶ ⛶ ⛶ ⛶ ⛶   ⛁ System tools: 19.0k tokens (9.5%)
     ⛶ ⛶ ⛶ ⛶ ⛶ ⛶ ⛶ ⛶ ⛶ ⛶   ⛁ Custom agents: 2.6k tokens (1.3%)
     ⛶ ⛶ ⛶ ⛶ ⛶ ⛶ ⛶ ⛶ ⛶ ⛶   ⛁ Messages: 8.8k tokens (4.4%)
     ⛶ ⛶ ⛶ ⛶ ⛶ ⛶ ⛶ ⛶ ⛶ ⛶   ⛶ Free space: 121k (60.7%)
     ⛶ ⛶ ⛶ ⛶ ⛶ ⛶ ⛶ ⛝ ⛝ ⛝   ⛝ Autocompact buffer: 45.0k tokens (22.5%)
     ⛝ ⛝ ⛝ ⛝ ⛝ ⛝ ⛝ ⛝ ⛝ ⛝
     ⛝ ⛝ ⛝ ⛝ ⛝ ⛝ ⛝ ⛝ ⛝ ⛝
```

So ~9k tokens and your agent knows everything about your project. Not great, but not terrible.

## What You Need

Right now this works with:
- **[Claude Code](https://docs.anthropic.com/en/docs/claude-code)**
- **[Codex CLI](https://github.com/openai/codex)**


## Installation

There is no nice way to share skills at the moment. So we provide a script to copy skills to `~/.claude/skills/` and `~/.codex/skills/`.

```bash
./scripts/cp_skills.sh
```


To remove the skills call the script below. This will delete all folders in `~/.{AGENT_NAME}/skills/skillrena` and skills that end in `-skl`

```bash
./scripts/remove_skills.sh
```

## **NOTE**:
- Codex doesn't do symlinks, so we have to hard copy in the agent's folder. :(
- Once codex fixes that then we will just symlink the skills in this folder into the codex directory.
- While codex allows for subfolders in the skills folder, claude does not. So the directory structure for codex will differ.
    - `.codex/skills/skillrena/*-skl/`
    - `.claude/skills/*-skl/`

## Skill Overview

### `$activate-skl`: Give the agent background information

When entering a project, call `$activate-skl` to either have the agent write memory skills in `.{AGENT_NAME}/skills/memories` or to skim the memories if they already exist.

```
$activate-skl
```

The agent reads your codebase and creates memories about what the project does, how to build it, your coding style.

**For the agents reading this**: `{AGENT_NAME}` in the skill files becomes `claude` or `codex` depending on which CLI is running. So `.{AGENT_NAME}/skills/memories/` turns into `.claude/skills/memories/` for Claude Code.

### `$switch_modes-skl`: Switch modes for certain tasks

```
$switch_modes-skl <mode>
```

| Mode | When | What It Does |
|------|------|--------------|
| `editing` | Changing code | Small diffs and  patches |
| `planning` | Thinking before coding | Reads everything, writes nothing, makes plans |
| `interactive` | Not sure what you want | Asks questions, confirms before doing stuff |
| `one-shot` | You know exactly what you want | Whomst amonst us  |
| `no-memories` | Testing, one-off stuff | Forget everything and start fresh |

### `$diary-skl`: Save what the agent learned this session

Before you close out or the context gets compacted call the diary for the llm to leave a little note to the next agent.

```
$diary-skl
```

Writes down the gotchas, workarounds, and "oh that's how that works" moments for next time.

The diary skill is a weird experiment I found from someone on twitter (sadly I cannot find the tweet). But the ideas is to make long term memories out of writing and summarizing diary entries from the agent before compaction. Then after a certain amount of diary entries exist, the agent updates the memory files with the information from the diary entries and removes the old diary entries.

#### Claude Code + Hookify to automate diary entries

If you're on Claude Code, check out [hookify](https://github.com/anthropics/claude-code-plugins/tree/main/hookify). You can use a pre compact hook to have the agent write a diary entry before compaction.

Example - no commits without tests:

```
/hookify:hookify "Before compaction, add a hook that will call the diary-skl skill"
```

### `$plan-plan-skl`: Write a design doc template for your project

For multi-file features or complex changes, use `$plan-plan-skl` to bootstrap a design-doc workflow in your repo:

```
$plan-plan-skl
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

## Problems?

Open an issue: [GitHub](https://github.com/SteveBronder/skillrena/issues/new)
