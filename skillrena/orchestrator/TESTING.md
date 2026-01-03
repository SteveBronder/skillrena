# Testing the Orchestrator Plugin

## Testing Layers

### 1. Hook Mechanism (Unit Test)

Test that the Stop hook correctly:
- Detects active loop state
- Increments iteration
- Detects completion promises
- Returns correct JSON

```bash
# Create a mock state file
mkdir -p .claude
cat > .claude/orchestrator-loop.local.md <<'EOF'
---
active: true
iteration: 1
max_iterations: 10
current_loop: "implementation"
design_doc_promise: "DESIGN_DOC_APPROVED"
implementation_promise: "ALL_SUBTASKS_PR_CREATED"
started_at: "2025-01-01T00:00:00Z"
input_path: "test"
---

Test orchestrator loop
EOF

# Create a mock transcript with assistant message
mkdir -p /tmp/test-transcript
cat > /tmp/test-transcript/transcript.jsonl <<'EOF'
{"role":"assistant","message":{"content":[{"type":"text","text":"Working on subtask..."}]}}
EOF

# Test the hook (should block and return JSON)
echo '{"transcript_path":"/tmp/test-transcript/transcript.jsonl"}' | \
  /workspaces/stonks/orchestrator/hooks/orchestrator-stop-hook.sh

# Check iteration was incremented
grep 'iteration:' .claude/orchestrator-loop.local.md

# Clean up
rm -rf .claude/orchestrator-loop.local.md /tmp/test-transcript
```

### 2. Completion Promise Detection

```bash
# Test with completion promise in output
mkdir -p .claude /tmp/test-transcript

cat > .claude/orchestrator-loop.local.md <<'EOF'
---
active: true
iteration: 5
max_iterations: 0
current_loop: "implementation"
design_doc_promise: "DESIGN_DOC_APPROVED"
implementation_promise: "ALL_SUBTASKS_PR_CREATED"
started_at: "2025-01-01T00:00:00Z"
input_path: "test"
---

Test loop
EOF

# Transcript with completion promise
cat > /tmp/test-transcript/transcript.jsonl <<'EOF'
{"role":"assistant","message":{"content":[{"type":"text","text":"All done! <promise>ALL_SUBTASKS_PR_CREATED</promise>"}]}}
EOF

# Should exit 0 and remove state file
echo '{"transcript_path":"/tmp/test-transcript/transcript.jsonl"}' | \
  /workspaces/stonks/orchestrator/hooks/orchestrator-stop-hook.sh

# State file should be removed
ls .claude/orchestrator-loop.local.md 2>/dev/null || echo "State file correctly removed"

# Clean up
rm -rf /tmp/test-transcript
```

### 3. Agent Response Format (Manual)

Test each agent returns the correct format:

```
# Spawn a reviewer and check output format
Task(
  subagent_type: "orchestrator:orchestrator-reviewer",
  prompt: "WORKING_DIRECTORY: /workspaces/stonks/.worktrees/01-common-types
           SUBTASK_DESIGN_DOC: design-docs/agents/01-common-types.xml
           REVIEW_OUTPUT_PATH: /tmp/test-review.md

           Review this implementation. This is a TEST - just create a sample review file."
)

# Check the review file structure
head -20 /tmp/test-review.md  # Should have SCORE: at top
```

### 4. End-to-End Dry Run

Test the full flow with a small subtask:

```bash
# 1. Create a minimal test design doc
cat > /tmp/test-design-doc.md <<'EOF'
# Test Feature

## Problem
Need a test function.

## Requirements
- FR1: Function returns "hello"

## Design
```cpp
std::string hello() { return "hello"; }
```

## Tests
- Unit test for hello()
EOF

# 2. Start orchestrator (will enter design review loop)
# /orchestrator /tmp/test-design-doc.md

# 3. Watch the iteration counter
# watch -n 5 'grep iteration: .claude/orchestrator-loop.local.md'

# 4. Cancel when satisfied
# /orchestrator:cancel
```

### 5. Integration Test with Existing Subtask

Use an existing worktree that has some implementation:

```bash
# Check existing worktrees
ls -la .worktrees/

# Run orchestrator on existing subtasks (skip design review)
# /orchestrator design-docs/agents/

# This will:
# 1. Check for existing worktrees
# 2. Spawn reviewers for each
# 3. Show scores
# 4. If < 0.96, spawn fixers
```

## Test Matrix

| Test | What it validates | How to run |
|------|-------------------|------------|
| Hook unit test | Stop hook mechanics | Bash script above |
| Promise detection | Completion detection | Bash script above |
| Agent format | Review file structure | Manual Task spawn |
| Dry run | Full loop flow | `/orchestrator` on test doc |
| Integration | Real subtask flow | `/orchestrator` on real subtasks |

## Known Limitations for Testing

1. **Context management** hard to test without actually filling context
2. **Diary/compact** integration requires real compaction triggers
3. **PR creation** requires GitHub auth and real branches
4. **Multi-iteration** tests are time-consuming

## Suggested Test Order

1. ✅ Hook mechanism (bash scripts)
2. ✅ Cancel command works
3. ⏳ Single agent spawning and format
4. ⏳ Full loop with test design doc
5. ⏳ Integration with real worktree

## Mocking for Faster Tests

For faster iteration, you can mock:

```bash
# Mock review file (instead of waiting for agent)
mkdir -p design-docs/orchestration/review/test-subtask
cat > design-docs/orchestration/review/test-subtask/2025-01-01T00-00-00_reviewer.md <<'EOF'
# Review: test-subtask
## SCORE: 0.85

## Summary (for orchestrator)
- Completeness: 0.90 - Most features implemented
- Testing: 0.80 - Missing edge case tests

### Key Issues
- Missing test for error path (High)

### Recommended Fixer
orchestrator-fixer

---
## Full Review (for fixer agent)
...detailed review...
EOF
```
