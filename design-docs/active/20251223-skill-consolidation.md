# Design Doc: Skill Consolidation and Best Practices Alignment

> **Template**: feature
> **Created**: 2025-12-23
> **Status**: Draft

## 1. Identity and Lifecycle

| Field | Value |
|-------|-------|
| Author | Claude |
| Reviewers | Steve |
| Status | Draft |
| Last Updated | 2025-12-23 |

## 2. Context

### Current Architecture

Skillrena currently has 12 skills organized as standalone directories:

**Callable Skills (`-skl`):**
- `activate-skl` - Entry point, loads memories
- `onboarding-skl` - Creates baseline memories (helper for activate)
- `write_memory-skl` - Writes memory files
- `diary-skl` - Records session learnings
- `switch_modes-skl` - Changes agent operating mode
- `plan-plan-skl` - Bootstraps design-doc workflow
- `subplan-skl` - Converts design docs to XML

**Mode Skills (`-ski`):**
- `mode-editing-ski`
- `mode-interactive-ski`
- `mode-no-memories-ski`
- `mode-one-shot-ski`
- `mode-planning-ski`

### Affected Components

| Component | Impact |
|-----------|--------|
| `skillrena/` | Major restructure - consolidate 12 skills into ~5 |
| `scripts/cp_skills.sh` | Update to handle new directory structure |
| `scripts/remove_skills.sh` | Update to handle new directory structure |
| `.claude/skills/` | Updated installed structure |
| `.claude/skills/memories/` | Rename from `*-skl` to spec-compliant names |

## 3. Problem

Skillrena's skills violate the official [Agent Skills specification](../docs/specification.md) and [best practices](../docs/best-practices.md) in several ways:

### Naming Violations

1. **Suffix convention (`-skl`/`-ski`)**: The spec requires names use only lowercase letters, numbers, and hyphens. While technically compliant, the `-skl`/`-ski` suffixes:
   - Are not descriptive (what does "skl" mean to a new user?)
   - Don't follow the recommended **gerund form** (e.g., `processing-pdfs`)
   - Create artificial distinction between "callable" and "internal" skills
2. **Underscore usage**: `switch_modes-skl` uses underscore which violates spec (hyphens only).
### Structural Violations

1. **Mode skills as standalone**: The 5 mode skills (`mode-*-ski`) are internal implementation details of `switch_modes-skl`. Per best practices on **progressive disclosure**, these should be `assets/` files within the parent skill, loaded only when needed.

2. **Onboarding as standalone**: `onboarding-skl` is only ever called by `activate-skl`. It should be a reference file within `activate-skl`, not a standalone skill consuming metadata space.

3. **No progressive disclosure**: Skills like `plan-plan-skl` and `onboarding-skl` are large but don't use `references/` or `assets/` directories.

### Description Quality Issues

Current descriptions are too brief and don't follow the spec guidance:

| Skill | Current Description | Problem |
|-------|---------------------|---------|
| `activate-skl` | "Check onboarding and load memories." | Doesn't say WHEN to use it |
| `switch_modes-skl` | "Switch agent mode." | Too vague, no triggers |
| `write_memory-skl` | "Write a memory file with proper header." | Missing use cases |
### Token Budget Concerns

- All skill metadata is loaded at startup (~100 tokens each)
- Having 12 skills means ~1200 tokens just for metadata
- Consolidating to 5 skills saves ~700 metadata tokens
- Mode definitions moving to assets saves additional context

## 4. Goals

- **G1**: Rename all skills to follow Agent Skills spec (gerund form, no special suffixes)
- **G2**: Consolidate related functionality using progressive disclosure pattern
- **G3**: Improve all descriptions to include WHAT and WHEN
- **G4**: Reduce startup metadata token cost by ~50%
- **G5**: Update memory skill naming convention in documentation

### Non-Goals

- **NG1**: Changing skill functionality or behavior
- **NG2**: Breaking changes to the workflow (users will still invoke similar commands)
- **NG3**: Changing the design-doc workflow

## 5. Requirements

### Functional Requirements

| ID | Requirement | Priority |
|----|-------------|----------|
| FR1 | All skill names comply with Agent Skills spec (lowercase, hyphens, no special suffixes) | Must |
| FR2 | Mode definitions moved to `switching-modes/assets/` directory | Must |
| FR3 | Onboarding content moved to `activating-memories/references/` directory | Must |
| FR4 | All descriptions include WHAT the skill does AND WHEN to use it | Must |
| FR5 | Scripts updated to handle new directory structure | Must |
| FR6 | Memory naming convention updated (remove `-skl` suffix) | Should |

### Non-Functional Requirements

| ID | Requirement | Priority |
|----|-------------|----------|
| NFR1 | Total metadata tokens reduced to <600 (from ~1200) | Should |
| NFR2 | Each main SKILL.md under 500 lines | Must |
| NFR3 | Clear migration path documented | Must |

## 6. Constraints and Invariants

### Agent Skills Specification (Official)

Per the [specification](../docs/specification.md):

**Name field requirements:**
- Max 64 characters
- Lowercase letters, numbers, and hyphens only (`a-z`, `0-9`, `-`)
- Must not start or end with hyphen
- Must not contain consecutive hyphens (`--`)
- Must match parent directory name

**Description field requirements:**
- Max 1024 characters
- Must describe WHAT the skill does AND WHEN to use it
- Write in **third person**
- Include keywords for discovery

### Backwards Compatibility

- **Impact on existing skills**: Complete rename required
- **Impact on installed skills**: Users must reinstall
- **Migration path**:
  1. Run `./scripts/remove_skills.sh`
  2. Pull new version
  3. Run `./scripts/cp_skills.sh`

### Invariants

- Skill functionality must remain identical
- Memory file format unchanged
- Design doc workflow unchanged

## 7. Proposed Design

### New Skill Structure

**Before (12 skills):**
```
skillrena/
├── activate-skl/SKILL.md
├── onboarding-skl/SKILL.md          # Standalone
├── write_memory-skl/SKILL.md
├── diary-skl/SKILL.md
├── switch_modes-skl/SKILL.md
├── mode-editing-ski/SKILL.md        # Standalone
├── mode-interactive-ski/SKILL.md    # Standalone
├── mode-no-memories-ski/SKILL.md    # Standalone
├── mode-one-shot-ski/SKILL.md       # Standalone
├── mode-planning-ski/SKILL.md       # Standalone
├── plan-plan-skl/SKILL.md
└── subplan-skl/SKILL.md
```

**After (5 skills with progressive disclosure):**
```
skillrena/
├── activating-memories/
│   ├── SKILL.md                     # Main instructions
│   └── references/
│       └── onboarding-guide.md      # Full onboarding instructions (was onboarding-skl)
├── writing-memories/
│   └── SKILL.md
├── recording-diary/
│   └── SKILL.md
├── switching-modes/
│   ├── SKILL.md                     # Main instructions (brief)
│   └── assets/
│       ├── editing.md               # Was mode-editing-ski
│       ├── interactive.md           # Was mode-interactive-ski
│       ├── no-memories.md           # Was mode-no-memories-ski
│       ├── one-shot.md              # Was mode-one-shot-ski
│       └── planning.md              # Was mode-planning-ski
├── bootstrapping-design-docs/
│   └── SKILL.md                     # Was plan-plan-skl
└── generating-subtasks/
│   └── SKILL.md                     # Was subplan-skl
```

### Skill Mapping

| Old Name | New Name | Change Type |
|----------|----------|-------------|
| `activate-skl` | `activating-memories` | Rename + consolidate |
| `onboarding-skl` | → `activating-memories/references/onboarding-guide.md` | Move to reference |
| `write_memory-skl` | `writing-memories` | Rename |
| `diary-skl` | `recording-diary` | Rename |
| `switch_modes-skl` | `switching-modes` | Rename + consolidate |
| `mode-editing-ski` | → `switching-modes/assets/editing.md` | Move to asset |
| `mode-interactive-ski` | → `switching-modes/assets/interactive.md` | Move to asset |
| `mode-no-memories-ski` | → `switching-modes/assets/no-memories.md` | Move to asset |
| `mode-one-shot-ski` | → `switching-modes/assets/one-shot.md` | Move to asset |
| `mode-planning-ski` | → `switching-modes/assets/planning.md` | Move to asset |
| `plan-plan-skl` | `bootstrapping-design-docs` | Rename |
| `subplan-skl` | `generating-subtasks` | Rename |

### Updated Descriptions

| Skill | New Description |
|-------|-----------------|
| `activating-memories` | Loads project-specific memories at session start and triggers onboarding for new projects. Use when starting a new coding session or when the user says "activate" or asks about project context. |
| `writing-memories` | Writes or updates memory files with proper YAML frontmatter in the agent's memories directory. Use when saving new project learnings or updating existing memory files. |
| `recording-diary` | Records session learnings and decisions before context compaction. Use before ending a long session or when the user asks to save session notes. |
| `switching-modes` | Changes the agent's operating mode between editing, planning, interactive, one-shot, and no-memories modes. Use when the user requests a different collaboration style or says "switch mode". |
| `bootstrapping-design-docs` | Creates design document infrastructure including templates, workflows, and the design-doc skill. Use when setting up design docs for a new project or when the user mentions "plan-plan". |
| `generating-subtasks` | Converts approved design documents into agent-executable XML subtasks. Use after a design doc is approved and ready for implementation. |

### Memory Naming Convention

Update memory naming from:
```
.claude/skills/memories/project_overview-skl/SKILL.md
```
To:
```
.claude/skills/memories/project-overview/SKILL.md
```

This aligns with the spec (hyphens, no special suffixes).

### File Changes

| File | Action | Description |
|------|--------|-------------|
| `skillrena/activating-memories/` | Create | New consolidated skill |
| `skillrena/activating-memories/references/onboarding-guide.md` | Create | Onboarding content |
| `skillrena/switching-modes/` | Create | New consolidated skill |
| `skillrena/switching-modes/assets/*.md` | Create | Mode definitions |
| `skillrena/writing-memories/` | Create | Renamed skill |
| `skillrena/recording-diary/` | Create | Renamed skill |
| `skillrena/bootstrapping-design-docs/` | Create | Renamed skill |
| `skillrena/generating-subtasks/` | Create | Renamed skill |
| `skillrena/activate-skl/` | Delete | Replaced |
| `skillrena/onboarding-skl/` | Delete | Consolidated |
| `skillrena/write_memory-skl/` | Delete | Replaced |
| `skillrena/diary-skl/` | Delete | Replaced |
| `skillrena/switch_modes-skl/` | Delete | Replaced |
| `skillrena/mode-*-ski/` | Delete | Consolidated |
| `skillrena/plan-plan-skl/` | Delete | Replaced |
| `skillrena/subplan-skl/` | Delete | Replaced |
| `scripts/cp_skills.sh` | Modify | Handle new structure |
| `scripts/remove_skills.sh` | Modify | Handle new structure |

### Data Flow

1. User invokes `$activating-memories`
2. Skill checks for memories in `.{AGENT_NAME}/skills/memories/`
3. If missing → reads `references/onboarding-guide.md` and executes onboarding
4. If present → loads memories

1. User invokes `$switching-modes editing`
2. Skill reads `assets/editing.md` for mode-specific behavior
3. Writes mode to state file
4. Agent adopts mode behavior

## 8. Alternatives Considered

### Alternative 1: Keep Current Naming, Only Fix Structure

- **Pros**:
  - Less migration effort
  - Existing users don't need to relearn names
- **Cons**:
  - Still violates spec recommendations on naming
  - `-skl`/`-ski` suffixes are not self-documenting
  - Doesn't align with broader ecosystem
- **Why not chosen**: Partial compliance is confusing; better to fully align

### Alternative 2: Minimal Changes (Fix Only `switch_modes-skl`)

- **Pros**:
  - Very small change
  - Low risk
- **Cons**:
  - Misses opportunity to align with best practices
  - Mode skills still waste metadata tokens
  - Onboarding still standalone
- **Why not chosen**: Doesn't address core token and structure issues

### Alternative 3: Do Nothing

- **Pros**: No effort required, no risk of breaking changes
- **Cons**:
  - Skills don't follow spec
  - Higher token usage than necessary
  - Poor example for users learning to write skills
- **Why not chosen**: Skillrena should exemplify best practices since it teaches skill authoring

## 9. Testing and Verification Strategy

### Manual Testing

1. [ ] Install new skills: `./scripts/cp_skills.sh`
2. [ ] Invoke `$activating-memories` in a fresh project → onboarding triggers
3. [ ] Invoke `$activating-memories` in existing project → memories load
4. [ ] Invoke `$switching-modes editing` → mode changes correctly
5. [ ] Invoke `$writing-memories` → memory file created with correct format
6. [ ] Invoke `$recording-diary` → diary entry created
7. [ ] Invoke `$bootstrapping-design-docs` → design doc infrastructure created
8. [ ] Invoke `$generating-subtasks` on approved doc → XML generated

### Verification Commands

```bash
# Check new skill installation
ls ~/.claude/skills/

# Expected output:
# activating-memories/
# writing-memories/
# recording-diary/
# switching-modes/
# bootstrapping-design-docs/
# generating-subtasks/

# Verify no old skills remain
ls ~/.claude/skills/*-skl 2>/dev/null && echo "ERROR: Old skills still present"
ls ~/.claude/skills/*-ski 2>/dev/null && echo "ERROR: Old mode skills still present"

# Check progressive disclosure structure
ls ~/.claude/skills/switching-modes/assets/
# Expected: editing.md interactive.md no-memories.md one-shot.md planning.md

ls ~/.claude/skills/activating-memories/references/
# Expected: onboarding-guide.md
```

### Acceptance Criteria

- [ ] All 6 new skills install without error
- [ ] No `-skl` or `-ski` suffixed directories remain
- [ ] Mode definitions are in `switching-modes/assets/`
- [ ] Onboarding content is in `activating-memories/references/`
- [ ] All descriptions include WHAT and WHEN
- [ ] Token count reduced (verify via `/context`)

## 10. Rollout and Migration

### Rollout Steps

1. [ ] Create new skill directories with content
2. [ ] Update `scripts/cp_skills.sh` for new structure
3. [ ] Update `scripts/remove_skills.sh` for new structure
4. [ ] Update `readme.md` with new skill names
5. [ ] Update memory documentation
6. [ ] Delete old skill directories
7. [ ] Test full workflow

### Migration Plan

**Before:**
```bash
$activate-skl
$switch_modes-skl editing
$write_memory-skl
$diary-skl
$plan-plan-skl
$subplan-skl
```

**After:**
```bash
$activating-memories
$switching-modes editing
$writing-memories
$recording-diary
$bootstrapping-design-docs
$generating-subtasks
```

**Migration command:**
```bash
# Remove old skills
./scripts/remove_skills.sh

# Pull latest
git pull

# Install new skills
./scripts/cp_skills.sh
```

### Backwards Compatibility

Old skill names will not be supported. This is a breaking change requiring users to:
1. Uninstall old skills
2. Install new skills
3. Update any personal scripts or muscle memory

## 11. Subtasks

### T1: Create New Skill Directory Structure

- **Summary**: Create the 6 new skill directories with proper structure
- **Scope**:
  - IN: Creating directories, writing SKILL.md files
  - OUT: Updating scripts, deleting old skills
- **Acceptance**: All 6 skills exist with correct structure; `ls skillrena/` shows new names
- **Status**: [ ] Not started

### T2: Migrate Mode Skills to Assets

- **Summary**: Move 5 mode-*-ski skills to switching-modes/assets/
- **Scope**:
  - IN: Creating assets/*.md files with mode behavior
  - OUT: Modifying mode behavior
- **Acceptance**: `ls skillrena/switching-modes/assets/` shows 5 .md files
- **Status**: [ ] Not started

### T3: Migrate Onboarding to Reference

- **Summary**: Move onboarding-skl content to activating-memories/references/
- **Scope**:
  - IN: Creating onboarding-guide.md reference file
  - OUT: Modifying onboarding behavior
- **Acceptance**: `activating-memories/references/onboarding-guide.md` exists with full content
- **Status**: [ ] Not started

### T4: Update Installation Scripts

- **Summary**: Update cp_skills.sh and remove_skills.sh for new structure
- **Scope**:
  - IN: Modifying scripts to handle new names and subdirectories
  - OUT: Changing script behavior beyond skill names
- **Acceptance**: Scripts correctly install/remove new skill structure
- **Status**: [ ] Not started

### T5: Update Documentation

- **Summary**: Update readme.md and AGENTS.md with new skill names
- **Scope**:
  - IN: Updating skill references in docs
  - OUT: Changing design doc workflow
- **Acceptance**: All skill references use new names
- **Status**: [ ] Not started

### T6: Delete Old Skills

- **Summary**: Remove all *-skl and *-ski directories
- **Scope**:
  - IN: Deleting old skill directories
  - OUT: Modifying git history
- **Acceptance**: `ls skillrena/*-skl skillrena/*-ski` returns no results
- **Status**: [ ] Not started

### T7: Update Memory Naming Convention

- **Summary**: Update documentation and examples to use hyphen-only memory names
- **Scope**:
  - IN: Updating docs, onboarding templates
  - OUT: Migrating existing user memories (users handle themselves)
- **Acceptance**: All examples show `project-overview` not `project_overview-skl`
- **Status**: [ ] Not started

---

**Subtask Approval Checkpoint**

- [ ] User has reviewed all subtasks
- [ ] Scope and acceptance criteria are clear
- [ ] Ready to generate `design-docs/agents/20251223-skill-consolidation.xml`

## 12. Open Questions

| Question | Status | Answer |
|----------|--------|--------|
| [blocking] Should we provide a migration script for existing user memories (rename `*-skl` folders)? | Open | |
> No not necessary
| [important] Do we want to keep backward-compatible aliases (old names pointing to new)? | Open | |
> No, better to enforce new names
| [optional] Should `bootstrapping-design-docs` be shortened to `bootstrapping-docs`? | Open | |
> No, keep full name for clarity
---

## Engineering Guardrails for Agent Execution

**These guardrails are mandatory for all agent-executed tasks.**

### Reuse-First Rule (Anti-Duplication)

Before creating new utilities/scripts:
1. Search `scripts/` for existing functionality
2. Search `skillrena/` for patterns that can be reused
3. Record the search and decision in the task's `<reuse_check>` section

### No Destructive Shortcuts

- Never delete user data or installed skills without explicit confirmation
- `remove_skills.sh` pattern: warn before destructive operations
- Document any destructive operations in task's `<safety>` section

### Signature Discipline (Anti-Vagueness)

- Script arguments must be documented
- Error conditions must be handled explicitly
- File paths must use consistent conventions

### Alternatives Requirement

- Every significant decision must evaluate >=2 alternatives + "do nothing"
- Document pros/cons and reasoning for chosen approach

### Uncertainty Protocol

When unsure about:
- Impact on existing skills or users
- Backwards compatibility implications
- File structure or naming conventions

Ask a `[blocking]` question before proceeding.
