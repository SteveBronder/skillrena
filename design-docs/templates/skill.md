# Design Doc: [Skill Name]

> **Template**: skill
> **Created**: YYYY-MM-DD
> **Status**: Draft | In Review | Approved | Implemented | Deprecated

## 1. Identity and Lifecycle

| Field | Value |
|-------|-------|
| Skill Name | `<name>-skl` or `<name>-ski` |
| Author | |
| Reviewers | |
| Status | Draft |
| Last Updated | YYYY-MM-DD |

### Skill Type

- [ ] Callable skill (`-skl`) - User invokes directly via `$skill-name`
- [ ] Mode/internal skill (`-ski`) - Used by other skills or mode system

## 2. Context

_What is the current state? What gap does this skill fill?_

### Related Skills

_List existing skills that interact with or are similar to this one._

| Skill | Relationship |
|-------|--------------|
| | |

## 3. Problem

_What specific problem does this skill solve? Why is a skill the right solution?_

## 4. Goals

_What does the skill accomplish when invoked?_

- Goal 1
- Goal 2

### Non-Goals

_What is explicitly outside this skill's scope?_

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
| NFR1 | Token budget: skill should be < X tokens | Must |
| NFR2 | | Should |

## 6. Constraints and Invariants

### Skillrena Conventions

- Skill folder: `skillrena/<skill-name>/`
- Skill file: `SKILL.md`
- YAML frontmatter required: `name`, `description` (no colons in description after the first)
- Naming: `-skl` for callable, `-ski` for modes/internal

### Token Budget

_Target token count and rationale._

- Target: ~XXX tokens
- Rationale: ...

### Invariants

- Invariant 1 (e.g., "Skill must not modify files without user consent")

## 7. Proposed Design

### SKILL.md Structure

```markdown
---
name: skill-name-skl
description: Brief description without colons after the initial one
---

# Skill Title

## Quick Start
- Key steps to use this skill

## Section Name
- Content organized by purpose

## Decision Points
- Conditional logic for the agent

## Failure Modes
- How to handle edge cases
```

### Key Sections

_Describe each section and its purpose._

| Section | Purpose |
|---------|---------|
| Quick Start | Minimal steps for common use |
| Decision Points | Branching logic for the agent |
| Failure Modes | Error handling guidance |

### Agent Behavior

_How should the agent behave when this skill is invoked?_

1. Step 1
2. Step 2

### Interfaces with Other Skills

_How does this skill interact with other skills?_

| Skill | Interaction |
|-------|-------------|
| | |

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

- **Pros**: No additional complexity
- **Cons**: Problem/gap remains
- **Why not chosen**:

## 9. Testing and Verification Strategy

### Manual Testing

_Steps to verify the skill works correctly._

1. [ ] Invoke skill: `$skill-name`
2. [ ] Verify behavior: ...
3. [ ] Check edge case: ...

### Token Count Verification

_Verify the skill stays within token budget._

1. [ ] Run `/context` before invoking skill
2. [ ] Note "Skills and slash commands" token count
3. [ ] Verify skill is < target tokens

### Acceptance Criteria

- [ ] Skill invokes without error
- [ ] Agent follows expected behavior flow
- [ ] Token count is within budget
- [ ] YAML frontmatter is valid
- [ ] Naming convention followed (`-skl` or `-ski`)

## 10. Subtasks

_Human-readable task list for review. After approval, agent generates XML in `design-docs/agents/`._

### T1: [Task Title]

- **Summary**: One sentence objective
- **Scope**: What's in / what's out
- **Acceptance**: Binary pass/fail criteria
- **Status**: [ ] Not started

### T2: [Task Title]

- **Summary**: One sentence objective
- **Scope**: What's in / what's out
- **Acceptance**: Binary pass/fail criteria
- **Status**: [ ] Not started

---

**Subtask Approval Checkpoint**

- [ ] User has reviewed all subtasks
- [ ] Scope and acceptance criteria are clear
- [ ] Ready to generate `design-docs/agents/<design-doc-name>.xml`

## 11. Rollout

### Installation

1. [ ] Add skill folder to `skillrena/`
2. [ ] Run `./scripts/cp_skills.sh` to install
3. [ ] Verify skill appears in `/skills` output

### Documentation

- [ ] Update `readme.md` if skill is user-facing
- [ ] Add to skill tables in documentation

## 12. Open Questions

| Question | Status | Answer |
|----------|--------|--------|
| | Open | |

---

## Engineering Guardrails for Agent Execution

**These guardrails are mandatory for all agent-executed tasks.**

### Reuse-First Rule (Anti-Duplication)

Before creating new skill logic:
1. Search existing skills in `skillrena/` for similar functionality
2. Check if an existing skill can be extended instead
3. Record the search and decision in the task's `<reuse_check>` section

### No Destructive Shortcuts

- Skills should not modify or delete files without explicit user consent
- Document any file operations in the skill's behavior description

### Signature Discipline (Anti-Vagueness)

- Skill inputs/outputs must be clearly documented
- Decision points must cover all expected cases
- Failure modes must be explicit

### Alternatives Requirement

- Every skill design must evaluate >=2 alternatives + "do nothing"
- Document why a new skill is preferred over extending existing ones

### Uncertainty Protocol

When unsure about:
- Skill scope or boundaries
- Interaction with other skills
- Naming conventions

Ask a `[blocking]` question before proceeding.
