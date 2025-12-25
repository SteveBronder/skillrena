# Design Documents

Design docs are written in markdown, reviewed by humans, and used for delegated agent execution.

## Workflow

1. **Create**: Run `$design-skill` to generate a new skill design doc from template
2. **Write**: Fill out the design doc in `design-docs/active/YYYYMMDD-slug.md`
3. **Review**: Get user approval on the subtasks section
4. **Generate**: Run `$generating-subtasks` to create agent-executable XML in `design-docs/agents/`
5. **Execute**: Agent executes subtasks, updating status as it progresses

## Directory Structure

```
design-docs/
├── README.md          # This file
├── active/            # In-progress design documents (markdown)
└── agents/            # Agent-executable subtasks (XML)
```

## Design Doc Naming

Format: `YYYYMMDD-slug.md`

Examples:
- `20251225-activating-memories.md`
- `20251225-pdf-processing.md`

## Approval Process

1. Author writes design doc following template
2. Reviewer checks:
   - Goals/non-goals are clear
   - Alternatives considered (≥2 + "do nothing")
   - Subtasks have binary acceptance criteria
   - Testing strategy validates against spec
3. User approves subtasks before XML generation

## Engineering Guardrails

All design docs must address:

- **Reuse-first rule**: Search existing utilities before creating new ones
- **No destructive shortcuts**: Never delete data to pass tests
- **Test integrity**: Mock boundaries only; prefer record/replay
- **Signature discipline**: Explicit types; Optional/None requires justification
- **Alternatives requirement**: Evaluate ≥2 alternatives + "do nothing"
- **Uncertainty protocol**: Ask blocking questions when unsure
