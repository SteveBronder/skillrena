# Design: Migrating from Serena MCP tools to “Skillrena” skills (no Serena)

## TL;DR

Today we rely on the Serena MCP server for “semantic” project tooling (symbol discovery, references, rename, etc.) and we ship Codex CLI skills that mostly act as wrappers around those Serena tools. This document proposes a migration to **Skillrena**: a skills-first system that replaces Serena MCP tool calls with **skills + a local, repo-scoped state directory** named **`.skillrena/`**.

Key points:
- **No Serena MCP server dependency** at runtime.
- **Per-tool skills remain** (same conceptual surface area as Serena tools).
- A **`.skillrena/` directory replaces `.serena/`** for project config, caches, and “memories”.
- For semantic operations, Skillrena uses a **pluggable backend**: LSP when available (for parity), tree-sitter/ctags/grep fallbacks when not.

---

## Background

### What Serena does (relevant pieces)

Serena is a code assistant framework with:
- A project/config layer (per-repo `.serena/` + global registered projects)
- Tool implementations for file operations, memory, and symbol-aware operations
- A semantic layer backed by Language Server Protocol (LSP) via SolidLSP

Concrete reference points in the upstream code we reviewed:
- Tools:
  - `serena/src/serena/tools/file_tools.py`
  - `serena/src/serena/tools/symbol_tools.py`
  - `serena/src/serena/tools/memory_tools.py`
  - `serena/src/serena/tools/config_tools.py`
  - `serena/src/serena/tools/cmd_tools.py`
  - `serena/src/serena/tools/workflow_tools.py`
- Project + state:
  - `.serena` is hard-coded via `SERENA_MANAGED_DIR_NAME = ".serena"` in `serena/src/serena/constants.py`
  - Per-project config/memories are managed in `serena/src/serena/project.py`
- Symbol model + retrieval:
  - `serena/src/serena/symbol.py` (name paths, symbol tree, reference collection)
- Editing:
  - `serena/src/serena/code_editor.py` (symbol-body replacement, insertion, LSP rename via workspace edits)

### What this repo currently provides

This repository currently contains one folder per Serena tool call we use (e.g. `serena-find_symbol/`), each with a `SKILL.md`. These skills are lightweight “how to use tool X” prompts and assume the Serena MCP server exists.

---

## Goals and non-goals

### Goals

1. Replace Serena MCP tool calls with Skillrena skills that achieve the same outcomes **without requiring Serena**.
2. Preserve the *intent* and (where reasonable) the *inputs/outputs* of existing Serena tools to minimize migration effort.
3. Maintain a per-repo, persisted state directory analogous to `.serena/`, renamed to **`.skillrena/`**.
4. Provide a path to semantic parity for:
   - `find_symbol`, `get_symbols_overview`, `find_referencing_symbols`
   - `rename_symbol`, `replace_symbol_body`, `insert_before/after_symbol`

### Non-goals (initially)

- Full multi-language parity with Serena on day 1 (Serena supports many LSPs).
- Reproducing Serena’s MCP server implementation (`serena/src/serena/mcp.py`) verbatim.
- JetBrains plugin integration parity (optional; see mapping).

---

## Proposed approach: Skillrena

Skillrena is not an MCP server. It is:

1. A **set of Codex CLI skills** (new `skillrena-*` folders) that replace `serena-*` usage.
2. A **local implementation layer** used by those skills, which can be either:
   - **A small CLI/utility package** (`skillrena`) invoked via shell commands, or
   - A “pure-skill” approach that uses Codex built-ins (`rg`, file edits) directly.

To reach functional parity with Serena’s symbol tools, the recommended architecture is the CLI/utility package approach, because it makes the behavior deterministic and testable.

### Architectural building blocks

**A. State + config**
- `.skillrena/project.yml`: per-repo settings (languages, encoding, ignore rules, defaults)
- `.skillrena/memories/*.md`: project memories (same idea as Serena)
- `.skillrena/cache/*`: semantic indexes and other caches

**B. Backends for symbol semantics**

Introduce a `SymbolBackend` interface with multiple implementations:

1. `LspBackend` (preferred for parity)
   - Uses installed language servers to implement:
     - document symbols → name paths, symbol ranges
     - references
     - rename (workspace edits)
2. `TreeSitterBackend` (fallback / MVP)
   - Uses tree-sitter parsers + queries to build a symbol tree with ranges.
   - References and rename become “best effort”.
3. `GrepBackend` (last-resort)
   - Uses `rg` and heuristics; lowest precision.

Skillrena selects the best available backend per language/file.

**C. Editing engine**

Implement a small “code editor” layer inspired by `serena/src/serena/code_editor.py`:
- Operates on file content with byte/line/column ranges.
- Supports:
  - replace symbol body (range replacement)
  - insert before/after symbol definition (range insertion)
  - insert/replace/delete lines (line-based)
  - rename symbol:
    - LSP workspace edits when available
    - otherwise a bounded, reviewed refactor using backend-provided occurrence locations

---

## `.skillrena/` directory layout

Skillrena replaces `.serena/` with a near-identical shape, but with names that make it clear Serena is not required.

Proposed layout:

```
.skillrena/
  project.yml
  memories/
    project_overview.md
    suggested_commands.md
    style_and_conventions.md
    task_completion_checklist.md
    ... (user/project specific)
  cache/
    symbol_index.sqlite        # or json; stores name_path→locations, per language
    doc_symbols/              # optional per-file symbol cache
    lsp/                      # optional LSP session metadata
  state.json                  # optional “active modes”, last activation, etc.
```

### Migration from `.serena/`

Provide a migration step (script or manual) that:
1. Renames `.serena/` → `.skillrena/` (or copies, leaving the original as backup)
2. Updates any references in docs/scripts from `.serena` to `.skillrena`

If `.serena/project.yml` exists, Skillrena should be able to **read it as input** during migration and write the same schema to `.skillrena/project.yml` (the schema can remain compatible to reduce friction).

---

## Tool-to-skill mapping (Serena → Skillrena)

This section sketches the Skillrena replacement for each Serena MCP tool call currently represented in this repo.

Conventions:
- Serena tool names shown without the `serena-` prefix (e.g. `find_symbol`).
- New skill folders will be named `skillrena-<tool_name>`.
- For each tool we define:
  - **Skill name**
  - **Implementation** (pure skill vs `skillrena` CLI)
  - **Notes on parity**

### Skills we can implement with existing tools (no `skillrena` CLI)

These can be implemented as skills that use tools we already have (`rg`, `ls`, `mkdir`, and Codex file editing via `apply_patch`, plus reading/writing files).

- Project workflow/prompting: `skillrena-initial_instructions`, `skillrena-check_onboarding_performed`, `skillrena-onboarding`, `skillrena-think_about_collected_information`, `skillrena-think_about_task_adherence`, `skillrena-think_about_whether_you_are_done`, `skillrena-summarize_changes`, `skillrena-prepare_for_new_conversation`
- “Mode” prompt-state: `skillrena-switch_modes`
- Files + search: `skillrena-list_dir`, `skillrena-find_file`, `skillrena-read_file`, `skillrena-create_text_file`, `skillrena-delete_lines`, `skillrena-replace_lines`, `skillrena-insert_at_line`, `skillrena-search_for_pattern`
- Memories: `skillrena-write_memory`, `skillrena-read_memory`, `skillrena-list_memories`, `skillrena-delete_memory`
- Shell execution (via Codex shell tool): `skillrena-execute_shell_command`

### Skills that need a `skillrena` CLI for parity

These require a real implementation to be safe/deterministic (semantic LSP-backed operations, multi-file refactors, structured caches/state, and robust regex editing).

- Project activation/registry/state: `skillrena-activate_project`, `skillrena-get_current_config`, `skillrena-remove_project`, `skillrena-restart_language_server`
- Robust regex editing: `skillrena-replace_content`, `skillrena-edit_memory`
- Semantic symbol tooling: `skillrena-get_symbols_overview`, `skillrena-find_symbol`, `skillrena-find_referencing_symbols`, `skillrena-replace_symbol_body`, `skillrena-insert_after_symbol`, `skillrena-insert_before_symbol`, `skillrena-rename_symbol`
- Optional JetBrains integration: `skillrena-jet_brains_find_symbol`, `skillrena-jet_brains_find_referencing_symbols`

### Configuration / lifecycle tools

#### `activate_project`
- Skill: `skillrena-activate_project`
- Implementation: `skillrena` CLI (recommended) or pure-skill with minimal persistence
- Behavior:
  - Resolve `project` as either:
    - absolute/relative path → repo root
    - registered name → lookup in `~/.skillrena/config.yml`
  - Ensure `.skillrena/` exists
  - Ensure `.skillrena/project.yml` exists (autogenerate by scanning extensions + defaults)
  - Emit an activation summary (project name, path, detected languages, encoding)
- Parity notes:
  - Serena starts language servers lazily; Skillrena should not necessarily start anything at activation.

#### `get_current_config`
- Skill: `skillrena-get_current_config`
- Implementation: `skillrena` CLI
- Output:
  - Active project root, languages/backends available, ignore settings, and enabled “modes”.
  - Optionally list registered projects (global config).

#### `switch_modes`
- Skill: `skillrena-switch_modes`
- Implementation: pure-skill + `.skillrena/state.json`
- Behavior:
  - “Modes” are primarily prompt-level behavior. Skillrena stores active modes in `.skillrena/state.json` and prints the mode prompts.
- Parity notes:
  - Serena uses modes to change which tools are active; Skillrena’s equivalent is “skills discipline” + stored state.

#### `remove_project`
- Skill: `skillrena-remove_project`
- Implementation: `skillrena` CLI
- Behavior:
  - Removes project from `~/.skillrena/config.yml` (global registry).
  - Does not delete repo-local `.skillrena/` unless explicitly requested.

#### `restart_language_server`
- Skill: `skillrena-restart_language_server`
- Implementation: backend-specific
- Behavior:
  - If using LSP backend with long-lived processes: restart the LSP session(s) and clear `.skillrena/cache/lsp/*`.
  - If using per-command ephemeral LSP: this becomes a no-op that clears caches.

---

### File and search tools (straightforward parity)

These tools can be implemented without Serena using standard file operations + `rg` (or Python regex fallback).

#### `list_dir`
- Skill: `skillrena-list_dir`
- Implementation: pure-skill or `skillrena` CLI
- Behavior:
  - List dirs/files under a relative path
  - Respect ignore rules when `skip_ignored_files=true`
  - Return JSON `{ "dirs": [...], "files": [...] }`

#### `find_file`
- Skill: `skillrena-find_file`
- Implementation: pure-skill or `skillrena` CLI
- Behavior:
  - Glob match in-tree, skipping ignored
  - Return JSON `{ "files": [...] }`

#### `read_file`
- Skill: `skillrena-read_file`
- Implementation: pure-skill or `skillrena` CLI
- Behavior:
  - Read a file chunk by line range (`start_line`, `end_line`)
  - Enforce “path must be within repo” and optionally “not ignored”

#### `create_text_file`
- Skill: `skillrena-create_text_file`
- Implementation: pure-skill (`apply_patch` in Codex) or `skillrena` CLI
- Behavior:
  - Create/overwrite file content
  - Enforce “inside repo” safety checks

#### `replace_content`
- Skill: `skillrena-replace_content`
- Implementation: `skillrena` CLI recommended (safer); pure-skill possible with careful prompting
- Behavior:
  - Literal or regex replace, optional multiple occurrences
  - Same semantics as Serena’s `ReplaceContentTool` (`serena/src/serena/tools/file_tools.py`)

#### `delete_lines`
- Skill: `skillrena-delete_lines`
- Implementation: pure-skill or `skillrena` CLI
- Behavior:
  - Delete inclusive line range
  - In Skillrena, require pre-read verification (same “safety” guidance Serena uses)

#### `replace_lines`
- Skill: `skillrena-replace_lines`
- Implementation: pure-skill or `skillrena` CLI
- Behavior:
  - Replace inclusive line range with new content (ensure trailing newline)

#### `insert_at_line`
- Skill: `skillrena-insert_at_line`
- Implementation: pure-skill or `skillrena` CLI
- Behavior:
  - Insert content at line, pushing existing down

#### `search_for_pattern`
- Skill: `skillrena-search_for_pattern`
- Implementation: pure-skill (via `rg`) or `skillrena` CLI
- Behavior:
  - Regex substring search across files with include/exclude globs and context lines
  - Return JSON mapping `file → [display matches]`

---

### Memory tools (straightforward parity)

Skillrena reuses Serena’s core idea: memories are markdown files stored in the repo.

#### `write_memory`
- Skill: `skillrena-write_memory`
- Implementation: pure-skill (`apply_patch`) or `skillrena` CLI
- Behavior:
  - Write `.skillrena/memories/<name>.md` (normalize `.md` suffix)

#### `read_memory`
- Skill: `skillrena-read_memory`
- Implementation: pure-skill or `skillrena` CLI

#### `list_memories`
- Skill: `skillrena-list_memories`
- Implementation: pure-skill or `skillrena` CLI

#### `delete_memory`
- Skill: `skillrena-delete_memory`
- Implementation: pure-skill or `skillrena` CLI
- Behavior:
  - Only delete on explicit user request (same policy as Serena)

#### `edit_memory`
- Skill: `skillrena-edit_memory`
- Implementation: `skillrena` CLI (safer)
- Behavior:
  - Regex/literal replacement within a memory file (equivalent to “replace_content but allow ignored”)

---

### Workflow/meta “thinking” tools (skills-only)

These are essentially prompt templates; Serena returns prompt strings from `PromptFactory` (see `serena/src/serena/tools/workflow_tools.py`). Skillrena can implement these as static skills.

#### `initial_instructions`
- Skill: `skillrena-initial_instructions`
- Implementation: pure-skill

#### `check_onboarding_performed`
- Skill: `skillrena-check_onboarding_performed`
- Implementation: pure-skill or `skillrena` CLI
- Behavior:
  - If `.skillrena/memories/` is empty → instruct to run onboarding

#### `onboarding`
- Skill: `skillrena-onboarding`
- Implementation: pure-skill
- Behavior:
  - Provide onboarding checklist and ask the agent to write `suggested_commands.md`, etc.

#### `think_about_collected_information`, `think_about_task_adherence`, `think_about_whether_you_are_done`
- Skills: `skillrena-think_about_collected_information`, etc.
- Implementation: pure-skill

#### `summarize_changes`
- Skill: `skillrena-summarize_changes`
- Implementation: pure-skill

#### `prepare_for_new_conversation`
- Skill: `skillrena-prepare_for_new_conversation`
- Implementation: pure-skill

---

### Semantic symbol tools (main migration challenge)

These are the Serena capabilities that most benefit from LSP and are hardest to replicate with only grep.

To get “close enough” parity, Skillrena should implement a semantic engine that can provide:
- Symbol trees and “name paths” (`Foo/bar`)
- Definition locations and body ranges
- References and rename edits

Recommended approach: implement an LSP-backed backend first for the languages we care about (e.g. Python/TypeScript), and add tree-sitter fallback.

#### `get_symbols_overview`
- Skill: `skillrena-get_symbols_overview`
- Implementation: `skillrena` CLI (semantic backend)
- Inputs: `relative_path`, `depth`, `max_answer_chars`
- Output: JSON list of top-level symbol dicts (keep Serena-like structure for compatibility)
- Implementation sketch:
  1. Determine backend for file (LSP if available, else tree-sitter)
  2. Produce a symbol tree with stable “name_path” identifiers
  3. Return sanitized dicts (similar to Serena’s `_sanitize_symbol_dict`)

#### `find_symbol`
- Skill: `skillrena-find_symbol`
- Implementation: `skillrena` CLI (semantic backend)
- Inputs: same as Serena (`name_path_pattern`, `depth`, `relative_path`, `include_body`, `include_kinds`, `exclude_kinds`, `substring_matching`, `max_answer_chars`)
- Output: JSON list of symbols with locations and optional body
- Notes:
  - MVP can ignore `include_kinds/exclude_kinds` beyond basic filtering.
  - Name path matching rules should be compatible with `serena/src/serena/tools/symbol_tools.py`.

#### `find_referencing_symbols`
- Skill: `skillrena-find_referencing_symbols`
- Implementation: `skillrena` CLI (semantic backend)
- Inputs: `name_path`, `relative_path` (file), `include_kinds`, `exclude_kinds`
- Output: JSON list of referencing symbol dicts plus `content_around_reference` (Serena adds 1 line before/after).
- Implementation sketch:
  - LSP backend: `textDocument/references` + map refs to containing symbols + add context snippet.
  - Tree-sitter fallback: identifier search + heuristic mapping to containing node.

#### `replace_symbol_body`
- Skill: `skillrena-replace_symbol_body`
- Implementation: `skillrena` CLI (semantic backend + edit engine)
- Behavior:
  1. Resolve a unique symbol by `name_path` in `relative_path`.
  2. Determine the exact “definition range” that constitutes the symbol body (signature + block).
  3. Replace that range with the provided `body` string.
- Notes:
  - This is where tree-sitter can do well for many languages.
  - For Python, the “body” concept matches `def ...:` + indented block.

#### `insert_after_symbol` / `insert_before_symbol`
- Skills: `skillrena-insert_after_symbol`, `skillrena-insert_before_symbol`
- Implementation: `skillrena` CLI (semantic backend + edit engine)
- Behavior:
  - Find unique symbol, then insert content after its end or before its start.
  - Preserve/normalize newline counts (Serena counts leading/trailing newlines in `CodeEditor`).

#### `rename_symbol`
- Skill: `skillrena-rename_symbol`
- Implementation: `skillrena` CLI (semantic backend + edit engine)
- Preferred behavior (parity):
  - Use LSP rename (`textDocument/rename`) to obtain workspace edits and apply them.
- Fallback behavior:
  - Use reference locations from backend, apply identifier replacements at exact ranges.
  - If only grep is available, either:
    - Refuse (ask for LSP enablement), or
    - Require explicit user confirmation + show a preview list of candidate files/occurrences.

---

### Shell tool

#### `execute_shell_command`
- Skill: `skillrena-execute_shell_command`
- Implementation: pure-skill (Codex shell tool) with safety checklist
- Notes:
  - Keep Serena’s guardrails: no long-running processes, no interactive commands, avoid unsafe/dangerous commands unless explicitly requested.

---

### JetBrains tools (optional)

Serena implements JetBrains support via an HTTP client (`serena/src/serena/tools/jetbrains_plugin_client.py`) and wrapper tools (`serena/src/serena/tools/jetbrains_tools.py`).

Skillrena options:
1. **Defer** (recommended MVP): document as “not supported without JetBrains plugin”.
2. Re-implement the client in `skillrena` CLI (still “without Serena”).

Mappings:
- `jet_brains_find_symbol` → `skillrena-jet_brains_find_symbol`
- `jet_brains_find_referencing_symbols` → `skillrena-jet_brains_find_referencing_symbols`

---

## Migration plan (phased)

### Phase 0 — Documentation + scaffolding
- Add this design doc.
- Add `.skillrena/` spec and ignore rules (e.g., update `.gitignore` guidance).
- Create new `skillrena-*` skill folders mirroring the existing `serena-*` catalog.

### Phase 1 — Non-semantic parity (fast wins)
Implement the file/search/memory/workflow skills without Serena:
- `list_dir`, `read_file`, `create_text_file`, `replace_content`, `search_for_pattern`, memory tools, etc.

### Phase 2 — Semantic MVP (one or two languages)
Target the languages we most need (e.g. Python and TypeScript):
- Implement `skillrena` CLI with LSP backend support for those languages.
- Provide `get_symbols_overview`, `find_symbol`, and basic `replace_symbol_body`/insert ops.

### Phase 3 — Rename + references (full semantic loop)
- Implement `find_referencing_symbols` + `rename_symbol` using LSP workspace edits.
- Add tree-sitter fallback where LSP is not available.

### Phase 4 — Expand language coverage + harden
- Add additional language servers / backends as needed.
- Add tests for symbol range edits and rename correctness (snapshot tests similar in spirit to Serena’s).

### Phase 5 — Deprecate Serena skills
- Mark `serena-*` skills as deprecated, pointing to `skillrena-*`.
- Eventually remove Serena as a dependency from consuming systems.

---

## Risks and mitigations

### Risk: semantic parity is hard without LSP
- Mitigation: implement LSP backend early for core languages; tree-sitter is a fallback, not the primary.

### Risk: rename is especially dangerous without full reference resolution
- Mitigation: require LSP rename for `rename_symbol` unless user explicitly opts into a “best effort” mode.

### Risk: performance of symbol indexing
- Mitigation: cache symbol trees/indexes in `.skillrena/cache/` (SQLite preferred), invalidate by file mtime/hash.

### Risk: different “name path” semantics across languages/backends
- Mitigation: define a stable `name_path` spec in Skillrena (compatible with Serena where possible), and include backend-specific normalization rules.

---

## Appendix: recommended artifacts to add (future work)

1. `skillrena` CLI/package (separate repo or added alongside consuming codebase)
2. `scripts/migrate-serena-to-skillrena` (renames `.serena` → `.skillrena`)
3. `skillrena-*` skills (one folder per tool) replacing `serena-*`
