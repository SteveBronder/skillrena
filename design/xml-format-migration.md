# SKILL.md XML Format Migration

## Problem Statement

Currently, Skillrena's SKILL.md files use markdown headers (`#`, `##`, `###`) to separate sections and subsections. This creates several issues:

### Issues with Current Markdown Format

1. **Semantic Ambiguity**: Markdown headers indicate hierarchy through symbol count, but don't convey semantic meaning. A `##` could be any type of section.

2. **Parsing Complexity**: Agents consuming skills must parse markdown hierarchy to understand document structure. This adds cognitive load and token usage.

3. **Inconsistent Nesting**: With 3-4 levels of nesting (especially in `onboarding-skl` and `activate-skl`), it becomes harder to visually distinguish section boundaries.

4. **Alignment with Agent Prompts**: System prompts and agent instructions use XML-style tags (`<name>`, `</name>`) to clearly delineate sections. Skills should match this convention for consistency.

5. **Limited Metadata**: Markdown headers can't carry attributes or metadata beyond their text content.

## Proposed Solution

Migrate SKILL.md files to use XML-style tags for section delineation while preserving:
- YAML frontmatter (unchanged)
- File name (`SKILL.md`)
- Markdown formatting within sections (lists, code blocks, emphasis)

### Key Principles

1. **Preserve YAML frontmatter**: Keep `---` delimited headers with `name` and `description`
2. **XML-style sections**: Replace `#` headers with `<section_name>` and `</section_name>` tags
3. **Semantic naming**: Use descriptive tag names that indicate purpose (e.g., `<quick_start>`, `<decision_points>`)
4. **Maintain readability**: Tags should enhance, not obscure, document structure
5. **Consistency**: All skills follow the same tagging convention

## XML Format Specification

### General Rules

1. **Section tags** replace markdown headers:
   - `# Section Name` → `<section_name>`
   - Content stays the same
   - Close with `</section_name>`

2. **Tag naming convention**:
   - Use snake_case for multi-word sections
   - Keep names concise and semantic
   - Examples: `<quick_start>`, `<decision_points>`, `<failure_modes>`

3. **Nesting**: Subsections nest within parent tags:
   ```xml
   <memory_templates>
     <project_overview>
       Content here
     </project_overview>
   </memory_templates>
   ```

4. **Content formatting**: Markdown formatting continues to work within tags:
   - Bullet lists (`-`)
   - Code blocks (` ``` `)
   - Emphasis (`**bold**`, `*italic*`)
   - File paths, commands, etc.

### Standard Section Tags

Based on analysis of all 10 existing skills, these sections appear frequently and should use standardized tags:

#### Universal Tags (Required in all skills)
- `<quick_start>` - Initial steps to use the skill (10/10 skills have this)
- `<failure_modes>` - Edge cases and error handling (10/10 skills have this)

#### Common Tags (Use when applicable)
- `<decision_points>` - Conditional logic for the agent (9/10 skills have this)
- `<templates>` - Reusable content templates (appears as: plan_template, step_update_template, summary_template, header_template)
- `<workflow>` - Sequential process steps (appears as: execution_flow, discovery_protocol, precision_ladder, discovery_checklist)
- `<quality_checklist>` - Validation criteria (appears as: quality_checklist, quality_bar)
- `<configuration>` - Settings and options (appears as: mode_map, file_format, header_rules)

#### Mapping of Existing Headers to Standard Tags

Current markdown headers that should be consolidated under standard tags:

**Templates** (use `<templates>` with nested sections):
- `## Template` → `<templates>`
- `## Plan template` → `<templates><plan>...</plan></templates>`
- `## Step update template` → `<templates><step_update>...</step_update></templates>`
- `## Summary template` → `<templates><summary>...</summary></templates>`
- `## Header template` → `<templates><header>...</header></templates>`
- `## Memory templates (verbose)` → `<templates><memory>...</memory></templates>`

**Workflows** (use `<workflow>` with descriptive nesting):
- `## Execution flow` → `<workflow>`
- `## Discovery protocol` → `<workflow>`
- `## Discovery checklist` → `<workflow>`
- `## Precision ladder` → `<workflow>`

**Configuration** (use `<configuration>` with nested sections):
- `## Mode map` → `<configuration><mode_map>...</mode_map></configuration>`
- `## File format` → `<configuration><file_format>...</file_format></configuration>`
- `## Header rules` → `<configuration><header_rules>...</header_rules></configuration>`

**Quality/Validation** (use `<quality_checklist>` or keep as distinct section):
- `## Quality checklist` → `<quality_checklist>`
- `## Memory quality bar` → `<quality_checklist>`

**Other specialized sections**:
- `## Hard blockers (ask if any apply)` → `<blockers>` (specific to one-shot mode)
- `## Consolidation` → `<consolidation>` (specific to diary-skl)
### File Structure Template

This template demonstrates the XML format structure without prescribing specific sections. Skills can use any sections appropriate to their purpose, though universal tags (`<quick_start>` and `<failure_modes>`) should be included when applicable.

```markdown
---
name: skill-name-skl
description: Brief description
---

<section_one>
- Step 1
- Step 2
</section_one>

<section_two>
Content here with **markdown** formatting.

<subsection_two>
- Bullet lists work
- Code blocks work
</subsection_two>
</section_two>

<section_three>
- Condition 1 -> action
- Condition 2 -> action
</section_three>

<section_four>
- Error case: resolution
</section_four>
```

**Key points**:
- Section names should be descriptive and use snake_case
- Content formatting (lists, code blocks, emphasis) remains unchanged
- Nesting is explicit through opening and closing tags
- No requirement to use specific sections (except universal tags when applicable)

## Migration Example: onboarding-skl

The `onboarding-skl` skill is the most complex in Skillrena, with 4+ levels of nesting and multiple subsections. This makes it the ideal candidate to demonstrate the XML format migration.

### Before (Current Markdown Format)

```markdown
---
name: onboarding-skl
description: Discover project and create baseline memory skills.
---

# Onboarding

## Quick start
- Read docs, configs, and entrypoints.
- Create the baseline memory skills via `write_memory-skl`.
  - Each memory is a skill file at `./.{AGENT_NAME}/skills/memories/<name>-skl/SKILL.md`.
  - Example baseline set:
    - `project_overview-skl/SKILL.md`
    - `suggested_commands-skl/SKILL.md`
    - `style_and_conventions-skl/SKILL.md`
    - `task_completion_checklist-skl/SKILL.md`

## Discovery checklist
- `readme.md` and top-level docs
- `docs/` or `design/` folders
- `scripts/` (build/test/run)
- Primary entrypoints (e.g., main files)
- Key config files (e.g., package/pyproject/Makefile)

## Memory templates (verbose)
If any section is unknown, note it and add where to find it.

### project_overview-skl/SKILL.md
- Purpose/goal (what this repo exists to do)
- Users/stakeholders (who uses it and why)
- Primary workflows (top 3 paths a user follows)
- Architecture (high-level components and how they interact)
- Key entrypoints (main files, CLIs, services)
- Data flow (inputs -> transformations -> outputs)
- External dependencies (services/APIs/datastores)
- Repo map (top-level folders and what they contain)
- Known risks/constraints (performance, security, domain rules)

### suggested_commands-skl/SKILL.md
- Build commands (with expected outputs)
- Test commands (unit/integration/e2e)
- Lint/format commands
- Run/deploy commands (local, staging, prod)
- Environment setup (env vars, tooling versions, bootstrap)
- Helpful scripts (what they do and when to use them)

### style_and_conventions-skl/SKILL.md
- Code style (formatters, linters, naming)
- Language/framework conventions (idioms, patterns)
- File/dir conventions (where new code/tests/docs go)
- Testing style (fixtures, naming, structure)
- Error handling/logging conventions
- Documentation conventions (doc locations, templates)

### task_completion_checklist-skl/SKILL.md
- Preconditions (inputs to confirm with user)
- Required checks (tests/lint/build)
- Review points (risk areas to double-check)
- Output validation (where to verify results)
- Rollback/recovery notes (if applicable)

## Decision points
- Missing docs -> ask the user for purpose and goals, then note gaps.
- Multiple entrypoints -> capture the primary ones and why.

## Failure modes
- Overlong memories: keep them compact and task-focused.
- Unclear structure: document assumptions explicitly.
```

### After (XML Format)

```markdown
---
name: onboarding-skl
description: Discover project and create baseline memory skills.
---

<quick_start>
- Read docs, configs, and entrypoints.
- Create the baseline memory skills via `write_memory-skl`.
  - Each memory is a skill file at `./.{AGENT_NAME}/skills/memories/<name>-skl/SKILL.md`.
  - Example baseline set:
    - `project_overview-skl/SKILL.md`
    - `suggested_commands-skl/SKILL.md`
    - `style_and_conventions-skl/SKILL.md`
    - `task_completion_checklist-skl/SKILL.md`
</quick_start>

<discovery_checklist>
- `readme.md` and top-level docs
- `docs/` or `design/` folders
- `scripts/` (build/test/run)
- Primary entrypoints (e.g., main files)
- Key config files (e.g., package/pyproject/Makefile)
</discovery_checklist>

<memory_templates>
If any section is unknown, note it and add where to find it.

<project_overview>
- Purpose/goal (what this repo exists to do)
- Users/stakeholders (who uses it and why)
- Primary workflows (top 3 paths a user follows)
- Architecture (high-level components and how they interact)
- Key entrypoints (main files, CLIs, services)
- Data flow (inputs -> transformations -> outputs)
- External dependencies (services/APIs/datastores)
- Repo map (top-level folders and what they contain)
- Known risks/constraints (performance, security, domain rules)
</project_overview>

<suggested_commands>
- Build commands (with expected outputs)
- Test commands (unit/integration/e2e)
- Lint/format commands
- Run/deploy commands (local, staging, prod)
- Environment setup (env vars, tooling versions, bootstrap)
- Helpful scripts (what they do and when to use them)
</suggested_commands>

<style_and_conventions>
- Code style (formatters, linters, naming)
- Language/framework conventions (idioms, patterns)
- File/dir conventions (where new code/tests/docs go)
- Testing style (fixtures, naming, structure)
- Error handling/logging conventions
- Documentation conventions (doc locations, templates)
</style_and_conventions>

<task_completion_checklist>
- Preconditions (inputs to confirm with user)
- Required checks (tests/lint/build)
- Review points (risk areas to double-check)
- Output validation (where to verify results)
- Rollback/recovery notes (if applicable)
</task_completion_checklist>

</memory_templates>

<decision_points>
- Missing docs -> ask the user for purpose and goals, then note gaps.
- Multiple entrypoints -> capture the primary ones and why.
</decision_points>

<failure_modes>
- Overlong memories: keep them compact and task-focused.
- Unclear structure: document assumptions explicitly.
</failure_modes>
```

### Key Improvements Demonstrated

1. **Clear Semantic Structure**:
   - `<memory_templates>` immediately signals "this contains templates"
   - Nested tags like `<project_overview>` show it's a template subsection

2. **Easier Parsing**:
   - No need to count `#` symbols
   - Opening/closing tags provide clear boundaries
   - Nesting is explicit, not inferred

3. **Alignment with Agent Conventions**:
   - Matches the XML-style used in system prompts
   - Agents already understand this tag structure

4. **Preserved Readability**:
   - Content remains unchanged
   - Markdown formatting still works
   - Visual structure is arguably clearer

## Migration Strategy

### Phase 1: Core Skills (Immediate)
Migrate the foundational skills first:
1. `onboarding-skl` ✓ (example above)
2. `activate-skl`
3. `write_memory-skl`

### Phase 2: Mode Skills
4. `mode-editing-ski`
5. `mode-planning-ski`
6. `mode-interactive-ski`
7. `mode-one-shot-ski`
8. `mode-no-memories-ski`

### Phase 3: Utility Skills
9. `diary-skl`
10. `switch_modes-skl`

### Phase 4: Memory Templates
Update memory skill templates in:
- `.claude/skills/memories/`
- `.codex/skills/memories/`

## Validation Checklist

After migrating each skill, verify:
- [ ] YAML frontmatter intact (name, description)
- [ ] All sections wrapped in appropriate XML tags
- [ ] Tags use snake_case naming
- [ ] Opening and closing tags match
- [ ] Content formatting preserved (lists, code blocks, etc.)
- [ ] No markdown headers (`#`) remain in body
- [ ] File still named `SKILL.md`

## Backward Compatibility

**Breaking change**: This is a format change that affects how agents parse skills.

**Migration note**: All skills must be migrated together to maintain consistency. Agents will need to understand the new XML format.

**Documentation updates needed**:
- `readme.md` - update format examples
- `style_and_conventions-skl` memory - document XML tag conventions
- Any external documentation referencing skill format

## Benefits Summary

1. **Semantic clarity**: Tags convey meaning, not just hierarchy
2. **Parsing efficiency**: Agents can target specific sections by tag name
3. **Consistency**: Aligns with broader agent prompt conventions
4. **Maintainability**: Easier to validate structure and catch errors
5. **Extensibility**: Tags can carry attributes if needed in future
6. **Readability**: Clear boundaries between sections
