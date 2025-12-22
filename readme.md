# Skillrena

![Skillrena Logo](./img/skillrena-logo.png)

Like [Serena](https://github.com/codegate-ai/serena), but way fewer tokens. It mostly boils down to giving your AI coding agent project memory without burning half your context window on MCP server overhead.

## Why Though?

Serena is great - it gives agents deep project understanding through MCP servers. But that understanding costs tokens. A lot of tokens.

| Approach | Token Cost | Setup |
|----------|------------|-------|
| Serena | ~50k+ tokens | MCP server required |
| Skillrena | ~2.9k tokens (all skills) | Copy some files, done |

That's it. ~2,880 tokens for everything. Running `$activate-skl` to load your project memories adds about 9k more. Still leaves plenty of room for actual work.

### The Numbers

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

### Before/After Activation

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

So ~9k tokens and your agent knows everything about your project. Not bad, but not terrible.

## What You Need

Right now this works with:
- **[Claude Code](https://docs.anthropic.com/en/docs/claude-code)**
- **[Codex CLI](https://github.com/openai/codex)**

Get one of those installed first.

## Installation

```bash
./scripts/cp_skills.sh
```

That copies skills to `~/.claude/skills/` and `~/.codex/skills/`.

To remove the skills call the script below. This will delete all folders in `~/.{AGENT_NAME}/skills/memories`

```bash
./scripts/remove_skills.sh
```

**NOTE**: Codex doesn't do symlinks, so we have to hard copy. :(

## How To Use It

### Start Every Session With This

When entering a project, call `$activate-skl` to either have the agent write memory skills in `.{AGENT_NAME}/skills/memories` or to skim the memories if they already exist.

```
$activate-skl
```

The agent reads your codebase and creates memories about what the project does, how to build it, your coding style.

> **For the agents reading this**: `{AGENT_NAME}` in the skill files becomes `claude` or `codex` depending on which CLI is running. So `.{AGENT_NAME}/skills/memories/` turns into `.claude/skills/memories/` for Claude Code.

### Switch Modes When You Need To

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

### Save What You Learned (Optional)

Before you close out or the context gets compacted call the diary for the llm to leave a little note to the next agent.

```
$diary-skl
```

Writes down the gotchas, workarounds, and "oh that's how that works" moments for next time.

The diary skill is a weird experiment I found from someone on twitter (sadly I cannot find the tweet). But the ideas is to make long term memories out of writing and summarizing diary entries from the agent before compaction. Then after a certain amount of diary entries exist, the agent updates the memory files with the information from the diary entries and removes the old diary entries.

### Claude Code + Hookify

If you're on Claude Code, check out [hookify](https://github.com/anthropics/claude-code-plugins/tree/main/hookify). You can use a pre compact hook to have the agent write a diary entry before compaction.

Example - no commits without tests:

```
/hookify:hookify "Before compaction, add a hook that will call the diary-skl skill"
```


## The Skills

### Ones You Call

| Skill | What It Does |
|-------|--------------|
| `activate-skl` | Loads memories, runs onboarding if needed |
| `onboarding-skl` | Reads your project, creates memories |
| `switch_modes-skl` | Changes how the agent behaves |
| `write_memory-skl` | Updates memory files |
| `diary-skl` | Saves learnings before context dies |

### Mode Definitions (Internal)

| Mode | File |
|------|------|
| Editing | `mode-editing-ski` |
| Planning | `mode-planning-ski` |
| Interactive | `mode-interactive-ski` |
| One-shot | `mode-one-shot-ski` |
| No-memories | `mode-no-memories-ski` |


## Naming Convention

- `-skl` = skills you can call
- `-ski` = internal mode stuff
- Memory skills get `-skl` too

## Problems?

Open an issue: [GitHub](https://github.com/SteveBronder/skillrena/issues/new)
