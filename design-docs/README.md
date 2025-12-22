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
- Create a tasks file at `design-docs/active/YYYYMMDD-<slug>-tasks.md`

### 2. Fill Out the Document

Complete all required sections in the main design doc:
- Context and problem statement
- Goals and non-goals
- Proposed design with explicit interfaces
- Alternatives considered (minimum 2 + "do nothing")
- Verification strategy

### 3. Define Subtasks

Add subtasks to the `-tasks.md` file using the pseudo-XML schema. Each task should have:
- Clear scope (in/out)
- Reuse check (search existing utilities first)
- Explicit interfaces and types
- Acceptance criteria

### 4. Review and Approval

Before implementation:
- [ ] All `[blocking]` questions resolved
- [ ] Design reviewed by stakeholder (if applicable)
- [ ] Tasks are atomic and independently verifiable

### 5. Execute

Agents can read the tasks file and execute subtasks. Each task includes:
- Scope boundaries
- Reuse-first checks
- Verification commands
- Acceptance criteria

## Directory Structure

```
design-docs/
├── README.md              # This file
├── templates/
│   ├── README.md          # Template index
│   ├── base.md            # Meta template with guardrails
│   ├── skill.md           # Skill creation template
│   └── feature.md         # General feature template
└── active/
    ├── YYYYMMDD-slug.md       # Main design doc
    └── YYYYMMDD-slug-tasks.md # Subtasks for agent execution
```

## Guardrails

All design docs enforce these engineering guardrails:

1. **Reuse-first rule**: Search existing utilities before creating new ones
2. **No destructive shortcuts**: Never delete data to pass tests
3. **Signature discipline**: Explicit types and invariants required
4. **Alternatives requirement**: Evaluate >=2 alternatives + "do nothing"
5. **Uncertainty protocol**: Ask `[blocking]` questions when unsure

## Naming Convention

- Main doc: `YYYYMMDD-<slug>.md` (e.g., `20251222-new-diary-skill.md`)
- Tasks file: `YYYYMMDD-<slug>-tasks.md` (e.g., `20251222-new-diary-skill-tasks.md`)
- Slug: lowercase, hyphen-separated, descriptive (e.g., `auth-mode-skill`, `cli-refactor`)
