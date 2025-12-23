# Design Docs

This directory contains design documents for Skillrena features and skills.

## Workflow

### 1. Create a Design Doc

Run the `$design-doc` skill to create a new design document:

```
$design-doc
```

The skill will:
- Ask you to select a template (`skill` or `feature`)
- Create a main doc at `design-docs/active/YYYYMMDD-<slug>.md`

### 2. Fill Out the Document

Complete all required sections in the main design doc:
- Context and problem statement
- Goals and non-goals
- Proposed design with explicit interfaces
- Alternatives considered (minimum 2 + "do nothing")
- Verification strategy
- **Subtasks** (human-readable checklist)

### 3. Define Subtasks (Human-Readable)

Add subtasks to the "## Subtasks" section using this format:

```markdown
## Subtasks

### T1: [Task Title]
- **Summary**: One sentence objective
- **Scope**: What's in / what's out
- **Acceptance**: Binary pass/fail criteria
- **Status**: [ ] Not started / [~] In progress / [x] Complete

### T2: [Task Title]
...
```

### 4. Review and Approval

Before implementation:
- [ ] All `[blocking]` questions resolved
- [ ] Design reviewed by stakeholder (if applicable)
- [ ] Subtasks reviewed and approved by user

### 5. Generate Agent-Executable XML

After the user approves the subtasks, the agent generates:
```
design-docs/agents/<design-doc-name>.xml
```

This XML file contains structured task definitions that agents can parse and execute.

### 6. Execute

Agents read the XML file in `design-docs/agents/` and execute subtasks. Each task includes:
- Scope boundaries
- Reuse-first checks
- Verification commands
- Acceptance criteria

## Directory Structure

```
design-docs/
├── README.md              # This file
├── active/
│   └── YYYYMMDD-slug.md   # Main design doc (with human-readable subtasks)
└── agents/
    └── YYYYMMDD-slug.xml  # Agent-executable subtasks (after approval)
```

**Templates**: Bundled with the `$design-doc-skl` skill at `.claude/skills/design-doc-skl/templates/`

## Two-Phase Subtask Workflow

| Phase | Location | Purpose |
|-------|----------|---------|
| 1. Planning | `active/*.md` (Subtasks section) | Human-readable, easy to iterate |
| 2. Execution | `agents/*.xml` | Machine-parseable, for agent delegation |

This separation ensures:
- Humans can easily review and edit subtasks during planning
- Agents get structured data they can reliably parse
- Clear approval gate before agent work begins

## Guardrails

All design docs enforce these engineering guardrails:

1. **Reuse-first rule**: Search existing utilities before creating new ones
2. **No destructive shortcuts**: Never delete data to pass tests
3. **Signature discipline**: Explicit types and invariants required
4. **Alternatives requirement**: Evaluate >=2 alternatives + "do nothing"
5. **Uncertainty protocol**: Ask `[blocking]` questions when unsure

## Naming Convention

- Main doc: `YYYYMMDD-<slug>.md` (e.g., `20251222-new-diary-skill.md`)
- Agent XML: `YYYYMMDD-<slug>.xml` (e.g., `20251222-new-diary-skill.xml`)
- Slug: lowercase, hyphen-separated, descriptive
