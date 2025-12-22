# Design Doc: [Title]

> **Template**: base
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

_Hard boundaries that cannot be violated._

- Constraint 1
- Invariant 1

## 7. Proposed Design

### Architecture

_High-level structure and component relationships._

### Key Components

_Describe each component and its responsibility._

### Interfaces and Contracts

_Explicit signatures, types, and invariants._

```
# Example interface definition
function_name(param: Type) -> ReturnType
  Invariants:
    - invariant 1
    - invariant 2
  Errors:
    - ErrorType: when condition
```

**Optional/None Policy**: Any use of Optional types or None values must include:
- Justification for why the value can be absent
- Handling strategy (default, error, propagate)

### Data Flow

_How data moves through the system._

## 8. Alternatives Considered

_Minimum 2 alternatives + "do nothing"._

### Alternative 1: [Name]

- **Pros**:
- **Cons**:
- **Why not chosen**:

### Alternative 2: [Name]

- **Pros**:
- **Cons**:
- **Why not chosen**:

### Alternative 3: Do Nothing

- **Pros**: No effort required
- **Cons**: Problem remains unsolved
- **Why not chosen**:

## 9. Testing and Verification Strategy

_How will we verify the implementation is correct?_

### Verification Steps

- [ ] Step 1
- [ ] Step 2

### Acceptance Criteria

_Binary pass/fail criteria._

- Passes when: ...
- Passes when: ...

## 10. Rollout and Migration

_How will this be deployed/released?_

- [ ] Rollout step 1
- [ ] Rollout step 2

### Backwards Compatibility

_Impact on existing users/systems._

## 11. Open Questions

_Unresolved issues that need answers before or during implementation._

| Question | Status | Answer |
|----------|--------|--------|
| | Open | |

---

## Engineering Guardrails for Agent Execution

**These guardrails are mandatory for all agent-executed tasks.**

### Reuse-First Rule (Anti-Duplication)

Before creating new code/components:
1. Search existing utilities in `skillrena/`, `scripts/`, and `.claude/skills/`
2. Record the search and decision in the task's `<reuse_check>` section
3. If similar functionality exists, extend rather than duplicate

### No Destructive Shortcuts

- Never delete dev/prod data to pass tests
- Destructive actions require explicit user confirmation
- Document any destructive operations in task's `<safety>` section

### Signature Discipline (Anti-Vagueness)

- All interfaces must have explicit types and invariants
- Optional/None requires justification and handling strategy
- Document error conditions and edge cases

### Alternatives Requirement

- Every significant decision must evaluate >=2 alternatives + "do nothing"
- Document pros/cons and reasoning for chosen approach

### Uncertainty Protocol

When unsure about any of the following, ask a `[blocking]` question:
- Requirements interpretation
- Design choices with significant impact
- Safety implications
- Scope boundaries

Do not proceed with assumptions on blocking items.
