# Design for Shared Skills and Prompts (skillrena)

## Background

We want both Claude Code and Codex CLI agents to consume the same set of
skills and prompts. At present, skills are duplicated into each agent's
`.codex/skills` and `.claude/skills` directories, and prompts are
shoe‑horned into skills. Codex cannot load skills if they are symlinks,
so we need a mechanism that copies real files into the agents' expected
directories without manual duplication. This design defines a canonical
layout for skills/prompts under a global `~/.skillrena` repository, a
set of install scripts, and Makefile targets to keep Claude and Codex in
sync.

## Canonical Layout (`~/.skillrena`)

All content is stored in a user‑global directory named `~/.skillrena`.
For clarity we mirror agent‑specific concerns under separate folders.

    skillrena/
    ├── skills/                 # canonical skills, each a folder containing SKILL.md
    │   ├── switch-modes/
    │   │   └── SKILL.md
    │   ├── planner/
    │   │   └── SKILL.md
    │   └── …                  # additional skills
    ├── codex/
    │   └── prompts/           # codex-only prompts (custom slash commands)
    │       ├── planner.md
    │       ├── oneshot.md
    │       └── …
    ├── claude/
    │   └── commands/          # claude-only commands
    │       ├── planner.md
    │       ├── oneshot.md
    │       └── …
    ├── scripts/               # bash helpers and installers
    │   ├── install_codex.sh
    │   ├── install_claude.sh
    │   └── install_all.sh
    ├── .githooks/             # optional git hooks for auto‑install on pull
    │   ├── post-merge
    │   └── post-checkout
    └── Makefile

### Skills (`skills/…`)

-   Each skill lives in its own directory named after the skill
    (`<name>/`).
-   A `SKILL.md` file in that directory contains YAML front‑matter
    (`name:` and `description:`) followed by the skill content.
-   Skills may include additional assets (templates, scripts) inside
    their folder.
-   This directory is agent‑agnostic; both agents share the exact same
    skills.

### Codex prompts (`codex/prompts/…`)

-   Codex CLI supports "custom prompts" invoked via `/prompts:<name>`.
-   Place a single Markdown file named `<name>.md` in `codex/prompts/`
    for each custom prompt. The filename becomes the slash command name.
-   The file body contains only the prompt text; do not include YAML
    front‑matter.

### Claude commands (`claude/commands/…`)

-   Claude Code loads commands from `.claude/commands/<name>.md` and
    exposes them via slash commands.
-   For each mode or custom behaviour, create `<name>.md` in
    `claude/commands/`.
-   The file body contains only the command text; YAML front‑matter is
    optional but not recommended.

## Installation Scripts

Agents cannot follow symlinks inside their `skills` directories, so
installation must copy real files.

### `scripts/install_codex.sh`

    #!/usr/bin/env bash
    set -euo pipefail

    # Use CODEX_HOME if set; otherwise default to ~/.codex.
    CODEX_HOME="${CODEX_HOME:-$HOME/.codex}"

    mkdir -p "$CODEX_HOME/skills" "$CODEX_HOME/prompts"

    # Copy skills and dereference any symlinks (-L).
    rsync -aL --delete "$HOME/.skillrena/skills/" "$CODEX_HOME/skills/"

    # Copy prompts; only top‑level .md files matter.
    rsync -aL --delete "$HOME/.skillrena/codex/prompts/" "$CODEX_HOME/prompts/"

### `scripts/install_claude.sh`

    #!/usr/bin/env bash
    set -euo pipefail

    # Use CLAUDE_HOME if set; otherwise default to ~/.claude.
    CLAUDE_HOME="${CLAUDE_HOME:-$HOME/.claude}"

    mkdir -p "$CLAUDE_HOME/skills" "$CLAUDE_HOME/commands"

    # Skills can be symlinked for Claude, but we copy for consistency.
    rsync -aL --delete "$HOME/.skillrena/skills/" "$CLAUDE_HOME/skills/"

    # Copy commands (top‑level .md files only).
    rsync -aL --delete "$HOME/.skillrena/claude/commands/" "$CLAUDE_HOME/commands/"

### `scripts/install_all.sh`

    #!/usr/bin/env bash
    set -euo pipefail
    # Installs both codex and claude.
    "$(dirname "$0")/install_codex.sh"
    "$(dirname "$0")/install_claude.sh"

Make all scripts executable (`chmod +x scripts/*.sh`).

## Makefile

Expose simple targets so that users do not have to remember which script
to run. Example Makefile:

    .PHONY: install codex claude hooks uninstall

    # Default: install both codex and claude.
    install: codex claude

    codex:
        bash scripts/install_codex.sh

    claude:
        bash scripts/install_claude.sh

    # Optional: install git hooks that auto‑run make install after git pull/checkout.
    hooks:
        git config core.hooksPath .githooks
        @echo "Git hooks enabled; future merges and checkouts will run 'make install'."

    uninstall:
        rm -rf $$HOME/.codex/skills $$HOME/.codex/prompts
        rm -rf $$HOME/.claude/skills $$HOME/.claude/commands
        @echo "Removed installed skills/prompts."

## Git Hooks (Optional)

If you want automatic updates whenever the repository is pulled or
checked out, add the following to `.githooks/post-merge` and
`.githooks/post-checkout`:

    #!/usr/bin/env bash
    # Post‑merge or post‑checkout hook
    make install

After cloning the repo, run `make hooks` once to configure Git to use
the repo's `.githooks` directory.

## Mode Persistence

Both agents support switching into different "modes" (planner,
researcher, etc.) using a `switch‑modes` command. To persist the current
mode across sessions, each agent should write a `state.json` into their
own project‑level `.codex/` or `.claude/` directory. This design
deliberately does not manage `state.json` in the shared repository to
avoid cross‑agent interference; the file is written and read only by the
agent runtime.

## Adding New Skills and Prompts

1.  Add a new directory under `skills/` with a `SKILL.md` file. Use a
    descriptive directory name (lowercase, hyphens).
2.  If the skill requires a custom slash command or mode:
3.  For Codex, add a corresponding Markdown file under `codex/prompts/`.
4.  For Claude, add a corresponding Markdown file under
    `claude/commands/`.
5.  Run `make install` to propagate the changes to both agents.

## No Symlinks for Skills

Codex currently refuses to load skills if they are symlinks. Therefore
the installation scripts dereference any symlinks with `rsync -aL`.
Never commit symlinks into `skills/` or `codex/prompts/`; store real
files instead.

## Summary

By centralising skills and prompts in `~/.skillrena` and providing
deterministic install scripts, we eliminate duplication and ensure both
agents receive identical capabilities. Make targets and optional git
hooks make installation trivial for users. Mode state is handled
per‑agent via `state.json`, and no symlinks are used to avoid Codex
limitations.
