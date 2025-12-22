# Design Doc: [Feature Name]

> **Template**: feature
> **Created**: YYYY-MM-DD
> **Status**: Draft | In Review | Approved | Implemented | Deprecated

## 1. Identity and Lifecycle

| Field | Value |
|-------|-------|
| Author | |
| Reviewers | |
| Status | Draft |
| Last Updated | YYYY-MM-DD |

## 2. Context

_What is the current state? What background does the reader need?_

### Current Architecture

_Relevant parts of the current system._

### Affected Components

| Component | Impact |
|-----------|--------|
| `skillrena/` | |
| `scripts/` | |
| `.claude/skills/` | |

## 3. Problem

_What specific problem are we solving? Why does it need to be solved now?_

## 4. Goals

_What does success look like? Be specific and measurable._

- Goal 1
- Goal 2

### Non-Goals

_What are we explicitly NOT trying to do?_

- Non-goal 1

## 5. Requirements

### Functional Requirements

| ID | Requirement | Priority |
|----|-------------|----------|
| FR1 | | Must |
| FR2 | | Should |

### Non-Functional Requirements

| ID | Requirement | Priority |
|----|-------------|----------|
| NFR1 | | Must |

## 6. Constraints and Invariants

### Skillrena Conventions

- Skills use `-skl` (callable) or `-ski` (mode/internal) naming
- SKILL.md files require YAML frontmatter with `name` and `description`
- Per-project memories go to `.{AGENT_NAME}/skills/memories/`

### Backwards Compatibility

_How will existing users/skills be affected?_

- Impact on existing skills:
- Impact on installed skills (`~/.claude/skills/`):
- Migration path if breaking:

### Invariants

- Invariant 1

## 7. Proposed Design

### Architecture

_High-level structure and component relationships._

### Key Components

_Describe each component and its responsibility._

| Component | Responsibility |
|-----------|----------------|
| | |

### File Changes

_What files will be created, modified, or deleted?_

| File | Action | Description |
|------|--------|-------------|
| | Create | |
| | Modify | |

### Interfaces and Contracts

_Explicit signatures, types, and invariants._

### Data Flow

_How data moves through the system._

## 8. Alternatives Considered

### Alternative 1: [Name]

- **Pros**:
- **Cons**:
- **Why not chosen**:

### Alternative 2: [Name]

- **Pros**:
- **Cons**:
- **Why not chosen**:

### Alternative 3: Do Nothing

- **Pros**: No effort required, no risk of breaking changes
- **Cons**: Problem remains unsolved
- **Why not chosen**:

## 9. Testing and Verification Strategy

### Manual Testing

_Steps to verify the feature works correctly._

1. [ ] Step 1
2. [ ] Step 2

### Verification Commands

```bash
# Check skill installation
ls ~/.claude/skills/*-skl ~/.claude/skills/*-ski 2>/dev/null

# Check memories
ls .claude/skills/memories/*/SKILL.md 2>/dev/null

# Run installation script
./scripts/cp_skills.sh
```

### Acceptance Criteria

- [ ] Criterion 1
- [ ] Criterion 2

## 10. Rollout and Migration

### Rollout Steps

1. [ ] Step 1
2. [ ] Step 2

### Migration Plan

_If this is a breaking change, how do users migrate?_

- Before:
- After:
- Migration command/steps:

### Backwards Compatibility

_How long will old behavior be supported?_

## 11. Open Questions

| Question | Status | Answer |
|----------|--------|--------|
| | Open | |

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
