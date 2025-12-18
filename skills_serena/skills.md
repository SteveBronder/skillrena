# Serena MCP Skills for Codex CLI

This repo contains Codex CLI “skills” for Serena MCP tools (one folder per tool, each with a `SKILL.md`).

## Install

1. Enable skills in Codex config:

   ```toml
   [features]
   skills = true
   ```

2. Copy these skills into Codex’s skills directory:

   ```bash
   mkdir -p ~/.codex/skills
   cp -R serena-* ~/.codex/skills/
   ```

## Skills

- `serena-activate_project`: Activate a Serena project by name or path; do this before running other Serena tools.
- `serena-check_onboarding_performed`: Check whether Serena onboarding exists for the active project; run right after activate_project.
- `serena-create_text_file`: Create or overwrite a text file in the active project; use for new files or full-file rewrites.
- `serena-delete_lines`: Delete a range of lines in a file; use for precise removals when symbol tools aren’t a fit.
- `serena-delete_memory`: Delete a Serena project memory entry by name; only use when the user asks to remove/forget it.
- `serena-execute_shell_command`: Run a shell command in the project context; use for build/test/lint or quick inspection.
- `serena-find_file`: Find files by name or glob under the project root; use to locate targets before reading/editing.
- `serena-find_referencing_symbols`: Find references to a symbol; use for impact analysis before changing or deleting code.
- `serena-find_symbol`: Search for symbols across the project via language tooling; use to navigate and target edits safely.
- `serena-get_current_config`: Show Serena’s active project and configuration; use when you’re unsure what Serena is targeting.
- `serena-get_symbols_overview`: Get a high-level map of top-level symbols in a file; use before diving into unfamiliar code.
- `serena-initial_instructions`: Load the Serena toolbox manual; use at the start of a new Serena-enabled conversation.
- `serena-insert_after_symbol`: Insert content immediately after a symbol definition; use to add related functions/classes in-place.
- `serena-insert_at_line`: Insert text at a specific line number; use when symbol-based insertion can’t target the right spot.
- `serena-insert_before_symbol`: Insert content right before a symbol definition; use for imports, decorators, or prelude blocks.
- `serena-jet_brains_find_referencing_symbols`: Find symbol references via JetBrains indexing; use when LSP-based reference search is incomplete.
- `serena-jet_brains_find_symbol`: Find symbols using JetBrains IDE indexing; use when LSP symbol search is unavailable or inaccurate.
- `serena-list_dir`: List files and directories (optionally recursive); use to understand repo structure quickly.
- `serena-list_memories`: List available Serena memory entries for the active project; use to discover stored context.
- `serena-onboarding`: Perform Serena onboarding to learn project purpose, structure, and dev commands; use on first view of a repo.
- `serena-prepare_for_new_conversation`: Prepare Serena for a fresh chat while preserving needed context; use when you want to reset the conversation.
- `serena-read_file`: Read a file from the active project; use for targeted inspection and context gathering.
- `serena-read_memory`: Read a Serena memory entry by name; use to recall conventions, commands, or prior onboarding results.
- `serena-remove_project`: Remove a project from Serena configuration; use only when the user wants to stop tracking it.
- `serena-rename_symbol`: Rename a symbol across the codebase using language-server refactoring; use for safe project-wide renames.
- `serena-replace_lines`: Replace a specific range of lines with new content; use for controlled edits when symbol tools can’t target.
- `serena-replace_content`: Replace content in a file (literal or regex); use for repetitive edits but apply cautiously.
- `serena-replace_symbol_body`: Replace a symbol’s full definition; use for full rewrites after you’ve retrieved the current body.
- `serena-restart_language_server`: Restart Serena’s language server; use when symbol search/refactoring results are stale or incorrect.
- `serena-search_for_pattern`: Search the project for a regex substring; use to find usages, configs, or strings across many files.
- `serena-summarize_changes`: Generate a structured summary of changes made during the conversation; use right before final handoff.
- `serena-switch_modes`: Activate one or more Serena modes; use to change behavior according to available mode configs.
- `serena-think_about_collected_information`: Assess whether you’ve gathered enough relevant context; use after searching/reading before deciding next steps.
- `serena-think_about_task_adherence`: Verify you’re still aligned with the user’s request; use right before making code changes.
- `serena-think_about_whether_you_are_done`: Final completion check: correctness, tests, docs, and next steps; use before you respond “done”.
- `serena-write_memory`: Write project-specific Serena memory entries; use to persist commands, conventions, and decisions for future chats.

