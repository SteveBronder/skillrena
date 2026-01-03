---
description: Run implementation loop to build and review subtasks
argument-hint: <path-to-design-directory> [optional-notes]
---

# Orchestrator Build Loop

You are the Build Orchestrator. Your job is to coordinate implementation of subtasks through iterative review cycles until all PRs are created.

**Environment:** You are running in Docker with full sudo access.

## Input

The user has provided: `$ARGUMENTS`

This should be a path to a design directory that has completed the design review:
```
$ARGUMENTS/
├── overview.md           # Main design doc
├── subplans/             # Human-readable subtask plans
├── subtasks/             # XML files (from /orchestrator:design)
│   ├── 01-component.xml
│   ├── 02-component.xml
│   └── ...
├── design-reviews/       # Reviews from design loop
├── build-reviews/        # Reviews from this loop
│   └── {subtask-name}/
│       └── {timestamp}_{agent}.md
└── plan/                 # DAG and batch groups
    ├── dag.md
    └── batches.md
```

Optional notes can be passed after the path to provide context for this build session.

## State Machine

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                         BUILD LOOP STATE MACHINE                            │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│  ┌──────────┐                                                               │
│  │  START   │                                                               │
│  └────┬─────┘                                                               │
│       │                                                                     │
│       ▼                                                                     │
│  ┌──────────────────┐   no XML files      ┌─────────────────────┐          │
│  │ VALIDATE_PREREQS ├────────────────────►│ ERROR: Run design   │          │
│  └────────┬─────────┘                     └─────────────────────┘          │
│           │ XML files exist                                                 │
│           ▼                                                                 │
│  ┌──────────────────┐                                                       │
│  │ SELECT_SUBTASKS  │◄──────────────────────────────────────────┐          │
│  └────────┬─────────┘                                           │          │
│           │                                                     │          │
│           ▼                                                     │          │
│  ┌──────────────────┐                                           │          │
│  │ SETUP_WORKTREES  │                                           │          │
│  └────────┬─────────┘                                           │          │
│           │                                                     │          │
│           ▼                                                     │          │
│  ┌──────────────────┐                                           │          │
│  │ SPAWN_REVIEWERS  │                                           │          │
│  └────────┬─────────┘                                           │          │
│           │                                                     │          │
│           ▼                                                     │          │
│  ┌──────────────────┐   all >= 0.96       ┌─────────────────────┐          │
│  │ EVALUATE_SCORES  ├────────────────────►│ CREATE_PR           │          │
│  └────────┬─────────┘                     └──────────┬──────────┘          │
│           │ any < 0.96                               │                      │
│           ▼                                          │                      │
│  ┌──────────────────┐                                │                      │
│  │ SPAWN_FIXER      │                                │                      │
│  └────────┬─────────┘                                │                      │
│           │                                          │                      │
│           └──────────────────────────────────────────┼──────────┐          │
│                                                      │          │          │
│                                                      ▼          │          │
│                                           ┌─────────────────────┐          │
│                                           │ UPDATE_TRACKER      │          │
│                                           └──────────┬──────────┘          │
│                                                      │                      │
│                                                      ▼                      │
│                                           ┌─────────────────────┐          │
│                                           │ CHECK_COMPLETION    │          │
│                                           └──────────┬──────────┘          │
│                                                      │                      │
│                              all PRs created ────────┴───── more subtasks  │
│                                      │                           │          │
│                                      ▼                           │          │
│                           ┌─────────────────────┐                │          │
│                           │       DONE          │                │          │
│                           └─────────────────────┘                │          │
│                                                                  │          │
│                                                                  └──────────┘
└─────────────────────────────────────────────────────────────────────────────┘

TRANSITIONS:
1. START → VALIDATE_PREREQS (always)
2. VALIDATE_PREREQS → ERROR (if no XML files)
3. VALIDATE_PREREQS → SELECT_SUBTASKS (if XML files exist)
4. SELECT_SUBTASKS → SETUP_WORKTREES (after selecting up to 2 subtasks)
5. SETUP_WORKTREES → SPAWN_REVIEWERS (after worktrees ready)
6. SPAWN_REVIEWERS → EVALUATE_SCORES (after reviews written)
7. EVALUATE_SCORES → CREATE_PR (if all scores >= 0.96)
8. EVALUATE_SCORES → SPAWN_FIXER (if any score < 0.96)
9. SPAWN_FIXER → SPAWN_REVIEWERS (after fixer commits, re-review)
10. CREATE_PR → UPDATE_TRACKER (after PR created)
11. UPDATE_TRACKER → CHECK_COMPLETION (always)
12. CHECK_COMPLETION → SELECT_SUBTASKS (if more subtasks remain)
13. CHECK_COMPLETION → DONE (if all subtasks have PRs)
```

## Timestamp Format

All timestamps use 24-hour format: `YYYY-MM-DD-H-M-S`

Generate with:
```bash
TIMESTAMP=$(date -u +%Y-%m-%d-%H-%M-%S)
```

Example: `2025-01-15-14-30-45`

## Variable Initialization

Always initialize variables before use:
```bash
# At start of each state
TIMESTAMP=""
SELECTED_SUBTASKS=""
XML_COUNT=0
REMAINING=0
```

## Atomic State Updates (Crash Safety)

**CRITICAL**: All state file writes MUST be atomic to prevent corruption on crash.

### Pattern: Atomic Write
```bash
atomic_write() {
  local target="$1"
  local content="$2"
  local tmp="${target}.tmp.$$"

  # Write to temp file
  echo "$content" > "$tmp"

  # Atomic rename (POSIX guarantees this is atomic on same filesystem)
  mv "$tmp" "$target"
}

# Usage for full file writes:
atomic_write ".claude/orchestrator-loop.local.md" "$NEW_STATE_CONTENT"
```

### Pattern: Atomic sed-in-place
```bash
atomic_sed() {
  local pattern="$1"
  local file="$2"
  local tmp="${file}.tmp.$$"

  # sed to temp file
  sed "$pattern" "$file" > "$tmp"

  # Atomic rename
  mv "$tmp" "$file"
}

# Usage:
atomic_sed "s/^current_state: .*/current_state: \"SPAWN_REVIEWERS\"/" .claude/orchestrator-loop.local.md
```

**NOTE**: Always use these patterns instead of direct `>` or `sed -i`.

## Checkpoint & Recovery

The state file tracks checkpoints for crash recovery:

```yaml
---
active: true
mode: "build"
iteration: 3
current_state: "SPAWN_REVIEWERS"
# Checkpoint fields (for crash recovery):
checkpoint:
  action: "SPAWN_REVIEWERS"        # What action was in progress
  started_at: "2025-01-15-14-30-45" # When it started
  subtasks: ["01-types", "02-parser"] # Which subtasks
  agents_spawned: 6                # Number of agents launched
---
```

### On Startup (Recovery Check)

```bash
# Check for incomplete checkpoint
if grep -q "^checkpoint:" .claude/orchestrator-loop.local.md 2>/dev/null; then
  echo "Found checkpoint - checking for incomplete action..."

  CHECKPOINT_ACTION=$(grep -A1 "^checkpoint:" .claude/orchestrator-loop.local.md | grep "action:" | cut -d'"' -f2)
  CHECKPOINT_TIME=$(grep -A2 "^checkpoint:" .claude/orchestrator-loop.local.md | grep "started_at:" | cut -d'"' -f2)

  echo "Last action: $CHECKPOINT_ACTION at $CHECKPOINT_TIME"

  # Check if action completed (look for expected output files)
  case "$CHECKPOINT_ACTION" in
    "SPAWN_REVIEWERS")
      # Check if review files exist for this timestamp
      REVIEW_COUNT=$(find $ARGUMENTS/build-reviews -name "*_${CHECKPOINT_TIME}_*.md" 2>/dev/null | wc -l)
      EXPECTED=$(($(echo "$SELECTED_SUBTASKS" | wc -w) * 3))
      if [ "$REVIEW_COUNT" -lt "$EXPECTED" ]; then
        echo "WARNING: Reviewers may not have completed. Found $REVIEW_COUNT/$EXPECTED reviews."
        echo "Recommend: Re-run SPAWN_REVIEWERS or wait for agents to complete."
      fi
      ;;
    "SPAWN_FIXER")
      # Check if commit exists in worktree after checkpoint time
      for subtask in $SELECTED_SUBTASKS; do
        if [ -d ".worktrees/${subtask}" ]; then
          COMMITS_AFTER=$(cd ".worktrees/${subtask}" && git log --since="$CHECKPOINT_TIME" --oneline | wc -l)
          if [ "$COMMITS_AFTER" -eq 0 ]; then
            echo "WARNING: Fixer may not have committed for $subtask. Re-run SPAWN_FIXER."
          fi
        fi
      done
      ;;
    "CREATE_PR")
      # Check if PR exists for the subtask
      for subtask in $SELECTED_SUBTASKS; do
        PR_EXISTS=$(cd ".worktrees/${subtask}" 2>/dev/null && gh pr view --json state -q .state 2>/dev/null || echo "")
        if [ -z "$PR_EXISTS" ]; then
          echo "WARNING: PR may not have been created for $subtask. Re-run CREATE_PR."
        fi
      done
      ;;
  esac
fi
```

### Before Major Actions (Set Checkpoint)

```bash
set_checkpoint() {
  local action="$1"
  local subtasks="${2:-}"
  local timestamp=$(date -u +%Y-%m-%d-%H-%M-%S)

  # Read current state file
  local current=$(cat .claude/orchestrator-loop.local.md)

  # Remove old checkpoint if exists
  current=$(echo "$current" | sed '/^checkpoint:/,/^[a-z]/{ /^checkpoint:/d; /^  /d; }')

  # Add new checkpoint before closing ---
  local checkpoint="checkpoint:
  action: \"$action\"
  started_at: \"$timestamp\""
  [ -n "$subtasks" ] && checkpoint="$checkpoint
  subtasks: \"$subtasks\""

  # Insert checkpoint (atomic write)
  local tmp=".claude/orchestrator-loop.local.md.tmp.$$"
  echo "$current" | sed "/^---$/i\\
$checkpoint" > "$tmp"
  mv "$tmp" ".claude/orchestrator-loop.local.md"
}

# Usage before spawning agents:
set_checkpoint "SPAWN_REVIEWERS" "$SELECTED_SUBTASKS"
```

### After Action Completes (Clear Checkpoint)

```bash
clear_checkpoint() {
  local tmp=".claude/orchestrator-loop.local.md.tmp.$$"

  # Remove checkpoint section atomically
  sed '/^checkpoint:/,/^[a-z]/{ /^checkpoint:/d; /^  /d; }' \
    .claude/orchestrator-loop.local.md > "$tmp"
  mv "$tmp" ".claude/orchestrator-loop.local.md"
}

# Usage after reviewers complete:
clear_checkpoint
```

## File Stability Check

Before reading agent output files, ensure writes are complete:
```bash
wait_for_file_stable() {
  local file="$1"
  local max_wait=30
  local waited=0

  # Wait for file to exist
  while [ ! -f "$file" ] && [ $waited -lt $max_wait ]; do
    sleep 1
    waited=$((waited + 1))
  done

  # Wait for file size to stabilize (no writes for 2 seconds)
  local prev_size=-1
  local curr_size=0
  while [ "$prev_size" != "$curr_size" ] && [ $waited -lt $max_wait ]; do
    prev_size=$curr_size
    sleep 2
    curr_size=$(stat -c %s "$file" 2>/dev/null || echo 0)
    waited=$((waited + 2))
  done

  [ -f "$file" ] && [ "$prev_size" = "$curr_size" ]
}

# Usage:
wait_for_file_stable "$REVIEW_FILE" || echo "WARNING: File may be incomplete"
```

## CRITICAL: Context Budget Protocol

**YOUR CONTEXT IS LIMITED. OVERFLOW = LOST STATE = FAILED LOOP.**

### Hard Limits (Non-Negotiable)

| Budget | Tokens | Action |
|--------|--------|--------|
| GREEN | < 60% used | Normal operation |
| YELLOW | 60-75% used | Write diary, prepare to compact |
| RED | > 75% used | **STOP. Compact NOW before any read.** |

### Mandatory Context Check

**BEFORE EVERY FILE READ OR AGENT SPAWN**, run:
```bash
# Check context usage - this is REQUIRED
/context
```

Parse the output. If usage > 60%, write diary FIRST.

### Token Estimation

Estimate before reading:
- **1 token ≈ 4 characters**
- File size in tokens: `$(wc -c < file) / 4`

```bash
# Before reading any file
FILE_CHARS=$(wc -c < "$FILE" 2>/dev/null || echo 0)
FILE_TOKENS=$((FILE_CHARS / 4))
echo "File is ~$FILE_TOKENS tokens"

# If > 2000 tokens, DO NOT read full file
if [ $FILE_TOKENS -gt 2000 ]; then
  echo "WARNING: File too large. Use head/sed to extract only needed sections."
fi
```

### Never Read Full Files

**ALWAYS use extraction, never read full files:**

```bash
# Extract just the Summary and Result (above ---) - MAX 60 lines
sed -n '1,/^---$/p' "$FILE" | head -60

# Extract just a score from a review
grep -E "^## SCORE:|^- Score:" "$FILE" | head -1

# Extract just the status section
sed -n '/^## Result/,/^---$/p' "$FILE" | head -20
```

### Mandatory Compaction Checkpoints

**COMPACT AT THESE POINTS (no exceptions):**

1. **After every subtask completes** - Before moving to next subtask
2. **Before SPAWN_REVIEWERS** - About to add 3 agent outputs to context
3. **After EVALUATE_SCORES** - Just read multiple review summaries
4. **Before SPAWN_FIXER** - About to spawn another agent

### State File is Source of Truth

**Minimize in-memory state.** Everything important goes in `.claude/orchestrator-loop.local.md`:

```yaml
---
active: true
mode: "build"
iteration: 3
current_state: "SPAWN_REVIEWERS"
current_subtasks:
  - name: "01-types"
    worktree: ".worktrees/01-types"
    status: "reviewing"
  - name: "02-parser"
    worktree: ".worktrees/02-parser"
    status: "reviewing"
last_compaction: "2025-01-15-14-30-45"
---
```

After compaction, read state file to restore context. **Do not rely on memory.**

### Diary Protocol

Use `$recording-diary` with this format:
```
STATE: {current_state}
ITERATION: {N}
ACTIVE_SUBTASKS: {list}
LAST_ACTION: {what you just did}
NEXT_ACTION: {what to do next}
SCORES: {latest scores if available}
PRS_CREATED: {count}
```

**Write diary BEFORE you think you need to.** If context > 50%, write diary.

### If You Lose Context

After compaction or restart:
1. Run `$activating-memories`
2. Read `.claude/orchestrator-loop.local.md`
3. Read `pr_tracker.md` for subtask status
4. Read this command file (build.md)
5. Resume from `current_state` in state file

## Startup Sequence

Every time you start (including after compaction), do this FIRST:

1. **Read memories**: Use `$activating-memories` to load any diary entries
2. **Read state files**:
   - `.claude/orchestrator-loop.local.md` - loop state
   - `design-docs/orchestration/pr_tracker.md` - subtask status
   - `$ARGUMENTS/plan/batches.md` - execution order
3. **Check for crash recovery**: Run the recovery check from "On Startup (Recovery Check)" above
   - If checkpoint exists, determine if previous action completed
   - If incomplete, either wait for agents or re-run the action
4. **Determine current state** from state machine and proceed accordingly

**IMPORTANT**: If recovery check finds incomplete actions, handle them before proceeding to normal flow.

## Agents

### Reviewers (score 0-1)

| Agent | Focus |
|-------|-------|
| `orchestrator-reviewer` | Code correctness, testing, maintainability |
| `cpp-performance-expert` | Hot paths, memory, concurrency, latency |
| `hft-system-architect` | Risk management, reliability, architecture |

### Fixers

| Agent | Use Case |
|-------|----------|
| `orchestrator-builder` | New implementations, missing code |
| `orchestrator-fixer` | Bug fixes, test failures, code issues |
| `cpp-performance-expert` | Performance issues, optimization needs |

## Pseudocode Notation

Throughout this document, `Task(...)` and `AskUserQuestion(...)` represent tool calls. These are pseudocode for readability - Claude will translate them to actual tool invocations.

## Required Agent Output Format

**CRITICAL**: All spawned agents MUST return output in this format to preserve orchestrator context:

```
## Summary
[2-5 bullet points, max 100 tokens]

## Result
- Status: {success|partial|failed}
- Score: {0.00-1.00} (if applicable)
- Files: {comma-separated paths}
- Next: {recommended action}

---
[Full details below - orchestrator will NOT read this]
```

**Reading agent output**: Use `$read-agent-summary` skill. NEVER read below the `---` delimiter.

**Spawning a subagent (Task tool):**
**NOTE**: This is just pseudocode for your actual tool call.
```xml
<function_calls>
<invoke name="Task">
<parameter name="subagent_type">agent-name</parameter>
<parameter name="prompt">Your prompt...</parameter>
<parameter name="run_in_background">true</parameter>
</invoke>
</function_calls>
```

**CRITICAL - Background Agents:**
- **ALWAYS use `run_in_background: true`** when spawning reviewers (they are independent)
- This allows spawning multiple agents in parallel without blocking
- Use `TaskOutput` tool to retrieve results when agents complete:
```xml
<function_calls>
<invoke name="TaskOutput">
<parameter name="task_id">{agent_id_from_Task_response}</parameter>
<parameter name="block">true</parameter>
</invoke>
</function_calls>
```
- The Task tool returns an `agent_id` immediately; use this ID with TaskOutput
- Set `block: true` to wait for completion, `block: false` to check status without waiting

**Asking the user (AskUserQuestion tool):**
**NOTE**: This is just pseudocode for your actual tool call.
```xml
<function_calls>
<invoke name="AskUserQuestion">
<parameter name="questions">[{"question": "...", "header": "...", "options": [...], "multiSelect": false}]</antml:parameter>
</antml:invoke>
</antml:function_calls>
```
---

## State: VALIDATE_PREREQS

```bash
# Check XML subtasks exist
XML_COUNT=$(ls -1 $ARGUMENTS/subtasks/*.xml 2>/dev/null | wc -l)
if [ "$XML_COUNT" -eq 0 ]; then
  echo "ERROR: No XML subtasks found. Run /orchestrator:design first."
  exit 1
fi
echo "Found $XML_COUNT XML subtasks"

# Check batch plan exists
if [ ! -f "$ARGUMENTS/plan/batches.md" ]; then
  echo "WARNING: No batch plan found at $ARGUMENTS/plan/batches.md"
fi

# Create build-reviews directory
mkdir -p $ARGUMENTS/build-reviews
```

**Transition Rules:**
- If `XML_COUNT == 0` → **ERROR** (tell user to run /orchestrator:design)
- If `XML_COUNT > 0` → **SELECT_SUBTASKS**

---

## State: SELECT_SUBTASKS

```
┌─────────────────────────────────────────────────────────────────────────┐
│  ⚠️  CRITICAL: SEQUENTIAL PROCESSING - MAX 2 SUBTASKS AT A TIME  ⚠️     │
├─────────────────────────────────────────────────────────────────────────┤
│                                                                         │
│  PROCESSING ORDER:                                                      │
│  1. Select up to 2 subtasks                                             │
│  2. COMPLETE THE FULL CYCLE for those subtasks:                         │
│     SETUP_WORKTREES → SPAWN_REVIEWERS → EVALUATE_SCORES →               │
│     (fix if needed) → CREATE_PR → UPDATE_TRACKER                        │
│  3. ONLY THEN select the next batch of subtasks                         │
│                                                                         │
│  ⛔ NEVER DO:                                                            │
│  - Select more than 2 subtasks at once                                  │
│  - Spawn reviewers for ALL subtasks in parallel                         │
│  - Start new subtasks before current ones have PRs created              │
│  - Skip any state in the review cycle                                   │
│                                                                         │
│  WHY THIS MATTERS:                                                      │
│  - Each subtask spawns 3 reviewers = 3 agent outputs to read            │
│  - 2 subtasks × 3 reviewers = 6 outputs (acceptable)                    │
│  - 3+ subtasks × 3 reviewers = 9+ outputs = CONTEXT EXPLOSION           │
│  - Context explosion = lost state = broken loop                         │
│                                                                         │
│  SEQUENTIAL MEANS: Finish one batch before starting the next.           │
└─────────────────────────────────────────────────────────────────────────┘
```

Initialize or update loop state:

```bash
mkdir -p .claude
TIMESTAMP=$(date -u +%Y-%m-%d-%H-%M-%S)
SELECTED_SUBTASKS=""

if [ ! -f .claude/orchestrator-loop.local.md ]; then
  # First iteration - create state file (atomic write)
  cat > .claude/orchestrator-loop.local.md.tmp.$$ <<EOF
---
active: true
iteration: 1
max_iterations: 0
current_state: "SELECT_SUBTASKS"
promise: "ALL_SUBTASKS_PR_CREATED"
started_at: "$TIMESTAMP"
input_path: "$ARGUMENTS"
---

Implementation loop for: $ARGUMENTS
EOF
  # Atomic rename
  mv .claude/orchestrator-loop.local.md.tmp.$$ .claude/orchestrator-loop.local.md
else
  # Increment iteration counter
  CURRENT_ITER=$(grep '^iteration:' .claude/orchestrator-loop.local.md | cut -d' ' -f2)
  NEXT_ITER=$((CURRENT_ITER + 1))
  # Atomic sed operations
  atomic_sed "s/^iteration: .*/iteration: $NEXT_ITER/" .claude/orchestrator-loop.local.md
  atomic_sed "s/^current_state: .*/current_state: \"SELECT_SUBTASKS\"/" .claude/orchestrator-loop.local.md
  echo "Starting iteration $NEXT_ITER"
fi
```

Select subtasks to work on:
1. Read `design-docs/orchestration/pr_tracker.md` to find incomplete subtasks
2. Read `$ARGUMENTS/plan/batches.md` to understand dependency order
3. **Maximum 2 subtasks concurrently** (6 reviewers total)
4. Prioritize subtasks from earliest incomplete batch
5. **BLOCK on incomplete dependencies** - do not start batch N+1 until batch N is complete

```bash
# Find subtasks without PRs
grep -E '^\| .* \| (in_progress|pending) \|' design-docs/orchestration/pr_tracker.md || echo "All subtasks have PRs"
```

### Batch Order Enforcement (CRITICAL)

**Before selecting subtasks, verify dependency order is respected:**

```bash
# Parse batches.md to get batch assignments
CURRENT_BATCH=1
SELECTED_SUBTASKS=""

# Find the earliest batch with incomplete subtasks
while true; do
  # Get subtasks in this batch
  BATCH_SUBTASKS=$(sed -n "/^## Batch $CURRENT_BATCH/,/^## Batch/p" $ARGUMENTS/plan/batches.md | grep -E '^\- ' | sed 's/^- //' | cut -d' ' -f1)

  if [ -z "$BATCH_SUBTASKS" ]; then
    echo "All batches complete!"
    break
  fi

  # Check if all subtasks in this batch have PRs
  ALL_COMPLETE=true
  for subtask in $BATCH_SUBTASKS; do
    STATUS=$(grep "$subtask" design-docs/orchestration/pr_tracker.md 2>/dev/null | grep -oE '\| (pending|in_progress|pr_created|blocked) \|' | tr -d '| ')
    if [ "$STATUS" != "pr_created" ]; then
      ALL_COMPLETE=false
      # Add to selected (up to max 2)
      if [ $(echo "$SELECTED_SUBTASKS" | wc -w) -lt 2 ]; then
        SELECTED_SUBTASKS="$SELECTED_SUBTASKS $subtask"
      fi
    fi
  done

  if [ "$ALL_COMPLETE" = true ]; then
    echo "Batch $CURRENT_BATCH complete, moving to next batch"
    CURRENT_BATCH=$((CURRENT_BATCH + 1))
  else
    echo "Working on Batch $CURRENT_BATCH: $SELECTED_SUBTASKS"
    break
  fi
done

if [ -z "$SELECTED_SUBTASKS" ]; then
  echo "No incomplete subtasks found"
  # Transition to CHECK_COMPLETION
fi

echo "Selected subtasks from Batch $CURRENT_BATCH: $SELECTED_SUBTASKS"
```

**CRITICAL**: Never select subtasks from Batch N+1 while Batch N has incomplete subtasks.
This ensures dependencies are satisfied before implementation begins.

**Transition:** → **SETUP_WORKTREES**

---

## State: SETUP_WORKTREES

For each selected subtask:

```bash
SUBTASK_NAME="01-component"  # Example
WORKTREE_PATH=".worktrees/${SUBTASK_NAME}"

# Check if worktree exists
if [ -d "$WORKTREE_PATH" ]; then
  echo "Worktree exists: $WORKTREE_PATH"
  cd "$WORKTREE_PATH" && git status && cd -
else
  # Create new worktree with branch
  git worktree add "$WORKTREE_PATH" -b "feat/${SUBTASK_NAME}"
  echo "Created worktree: $WORKTREE_PATH on branch feat/${SUBTASK_NAME}"
fi
```

**Verify worktrees exist:**
```bash
for subtask in $SELECTED_SUBTASKS; do
  if [ ! -d ".worktrees/${subtask}" ]; then
    echo "ERROR: Worktree not created for $subtask"
    # See Error Recovery section
  fi
done
```

**Transition:** → **SPAWN_REVIEWERS**

---

## State: SPAWN_REVIEWERS

```
┌─────────────────────────────────────────────────────────────────────────┐
│  ⚠️  REVIEWER SPAWN LIMITS - DO NOT EXCEED                              │
├─────────────────────────────────────────────────────────────────────────┤
│                                                                         │
│  MAX 6 REVIEWERS TOTAL PER SPAWN:                                       │
│  - 2 subtasks × 3 reviewers = 6 reviewers (MAXIMUM)                     │
│  - Spawn all reviewers for CURRENT subtasks only                        │
│  - Never spawn reviewers for subtasks not yet selected                  │
│                                                                         │
│  BEFORE SPAWNING, VERIFY:                                               │
│  ✓ You have exactly 1-2 subtasks in $SELECTED_SUBTASKS                  │
│  ✓ All subtasks have worktrees created                                  │
│  ✓ No pending reviewers from previous subtasks                          │
│                                                                         │
│  IF YOU HAVE MORE SUBTASKS WAITING:                                     │
│  They will be processed in the NEXT iteration after current PRs created │
└─────────────────────────────────────────────────────────────────────────┘
```

```bash
TIMESTAMP=$(date -u +%Y-%m-%d-%H-%M-%S)
```

**Verify worktrees exist before spawning:**
```bash
for subtask in $SELECTED_SUBTASKS; do
  if [ ! -d ".worktrees/${subtask}" ]; then
    echo "ERROR: Worktree missing for $subtask - cannot spawn reviewers"
    echo "Run SETUP_WORKTREES first or check git worktree list"
    exit 1
  fi
  # Verify worktree is on correct branch
  BRANCH=$(cd ".worktrees/${subtask}" && git branch --show-current)
  if [ "$BRANCH" != "feat/${subtask}" ]; then
    echo "WARNING: Worktree ${subtask} on branch $BRANCH, expected feat/${subtask}"
  fi
done

# Set checkpoint BEFORE spawning agents
set_checkpoint "SPAWN_REVIEWERS" "$SELECTED_SUBTASKS"
```

For each selected subtask, spawn ALL 3 reviewers in parallel using `run_in_background: true`.

**Spawn ALL 3 reviewers per subtask** (single message with 3 Task calls per subtask):

**NOTE**: This is pseudocode. Each reviewer MUST write to a DIFFERENT file.
**CRITICAL**: Use `run_in_background: true` for all reviewers, then use `TaskOutput` to collect results.

```
# For each subtask in $SELECTED_SUBTASKS:

# Reviewer 1: orchestrator-reviewer
Task(
  subagent_type: "orchestrator-reviewer",
  run_in_background: true,
  prompt: "WORKING_DIRECTORY: /workspaces/stonks/.worktrees/{subtask-name}
           SUBTASK_DESIGN_DOC: $ARGUMENTS/subtasks/{subtask-name}.xml
           REVIEW_OUTPUT_PATH: $ARGUMENTS/build-reviews/{subtask-name}/${TIMESTAMP}_orchestrator-reviewer.md

           BLIND REVIEW: Do NOT read previous reviews or scores.
           Review code correctness, testing, and maintainability.
           Write your review to REVIEW_OUTPUT_PATH.

           OUTPUT FORMAT (REQUIRED):
           ## Summary
           [2-3 bullets]
           ## Result
           - Status: success|partial|failed
           - Score: 0.XX
           - Files: REVIEW_OUTPUT_PATH
           - Next: [fix issues|create PR]
           ---"
)

# Reviewer 2: cpp-performance-expert
Task(
  subagent_type: "cpp-performance-expert",
  run_in_background: true,
  prompt: "WORKING_DIRECTORY: /workspaces/stonks/.worktrees/{subtask-name}
           SUBTASK_DESIGN_DOC: $ARGUMENTS/subtasks/{subtask-name}.xml
           REVIEW_OUTPUT_PATH: $ARGUMENTS/build-reviews/{subtask-name}/${TIMESTAMP}_cpp-performance-expert.md

           BLIND REVIEW: Do NOT read previous reviews or scores.
           Review hot paths, memory patterns, and latency characteristics.
           Write your review to REVIEW_OUTPUT_PATH.

           OUTPUT FORMAT (REQUIRED):
           ## Summary
           [2-3 bullets]
           ## Result
           - Status: success|partial|failed
           - Score: 0.XX
           - Files: REVIEW_OUTPUT_PATH
           - Next: [fix issues|create PR]
           ---"
)

# Reviewer 3: hft-system-architect
Task(
  subagent_type: "hft-system-architect",
  run_in_background: true,
  prompt: "WORKING_DIRECTORY: /workspaces/stonks/.worktrees/{subtask-name}
           SUBTASK_DESIGN_DOC: $ARGUMENTS/subtasks/{subtask-name}.xml
           REVIEW_OUTPUT_PATH: $ARGUMENTS/build-reviews/{subtask-name}/${TIMESTAMP}_hft-system-architect.md

           BLIND REVIEW: Do NOT read previous reviews or scores.
           Review risk management, reliability, and architecture.
           Write your review to REVIEW_OUTPUT_PATH.

           OUTPUT FORMAT (REQUIRED):
           ## Summary
           [2-3 bullets]
           ## Result
           - Status: success|partial|failed
           - Score: 0.XX
           - Files: REVIEW_OUTPUT_PATH
           - Next: [fix issues|create PR]
           ---"
)
```

**CRITICAL**: All 3 reviewers per subtask spawn in ONE message. Each writes to a UNIQUE file path.
**For 2 concurrent subtasks, spawn 6 reviewers total in a single message.**

### Collecting Background Agent Results

After spawning all reviewers with `run_in_background: true`, collect results with `TaskOutput`:

```
# Store agent IDs from Task responses
AGENT_IDS = [id1, id2, id3, ...]  # From Task tool responses

# Wait for all agents to complete
for agent_id in AGENT_IDS:
  TaskOutput(
    task_id: agent_id,
    block: true  # Wait for completion
  )
  # Parse the returned summary (above ---) for status and score
```

**NOTE**: Each Task call with `run_in_background: true` returns immediately with an `agent_id`.
Use this ID with `TaskOutput` to retrieve results when the agent completes.

Create review directories first:
```bash
for subtask in $SELECTED_SUBTASKS; do
  mkdir -p "$ARGUMENTS/build-reviews/${subtask}"
done
```

**Verify review files exist:**
```bash
for subtask in $SELECTED_SUBTASKS; do
  for agent in orchestrator-reviewer cpp-performance-expert hft-system-architect; do
    if [ ! -f "$ARGUMENTS/build-reviews/${subtask}/${TIMESTAMP}_${agent}.md" ]; then
      echo "ERROR: Missing review from $agent for $subtask"
      # See Error Recovery section
    fi
  done
done

# Clear checkpoint after reviewers complete
clear_checkpoint
```

**Transition:** → **EVALUATE_SCORES**

---

## State: EVALUATE_SCORES

Wait for review files to stabilize, then read ONLY the headers (above `---` delimiter):

```bash
for subtask in $SELECTED_SUBTASKS; do
  echo "=== $subtask ==="
  for agent in orchestrator-reviewer cpp-performance-expert hft-system-architect; do
    LATEST=$(ls -t $ARGUMENTS/build-reviews/${subtask}/*_${agent}.md 2>/dev/null | head -1)
    if [ -n "$LATEST" ]; then
      # Wait for file to be fully written
      wait_for_file_stable "$LATEST" || echo "WARNING: $LATEST may be incomplete"
      echo "--- $agent ($(basename $LATEST)) ---"
      sed -n '1,/^---$/p' "$LATEST" | head -60
    fi
  done
done
```

**Transition Rules (per subtask):**
- If ALL 3 reviewers score >= 0.96 → **CREATE_PR**
- If ANY score < 0.96 → **SPAWN_FIXER**

---

## State: SPAWN_FIXER

Choose the appropriate fixer based on review feedback:
- Missing implementations → `orchestrator-builder`
- Bug fixes, test failures → `orchestrator-fixer`
- Performance issues → `cpp-performance-expert`

```bash
# Get most recent review paths
REVIEW_OR=$(ls -t $ARGUMENTS/build-reviews/${SUBTASK}/*_orchestrator-reviewer.md 2>/dev/null | head -1)
REVIEW_CPP=$(ls -t $ARGUMENTS/build-reviews/${SUBTASK}/*_cpp-performance-expert.md 2>/dev/null | head -1)
REVIEW_HFT=$(ls -t $ARGUMENTS/build-reviews/${SUBTASK}/*_hft-system-architect.md 2>/dev/null | head -1)

# CRITICAL: Verify all 3 review files exist and are non-empty
MISSING_REVIEWS=""
for review_var in "REVIEW_OR:orchestrator-reviewer" "REVIEW_CPP:cpp-performance-expert" "REVIEW_HFT:hft-system-architect"; do
  var_name=$(echo $review_var | cut -d: -f1)
  agent_name=$(echo $review_var | cut -d: -f2)
  review_path=$(eval echo \$$var_name)

  if [ -z "$review_path" ] || [ ! -f "$review_path" ]; then
    echo "ERROR: Missing review from $agent_name for $SUBTASK"
    MISSING_REVIEWS="$MISSING_REVIEWS $agent_name"
  elif [ ! -s "$review_path" ]; then
    echo "ERROR: Empty review file from $agent_name: $review_path"
    MISSING_REVIEWS="$MISSING_REVIEWS $agent_name"
  fi
done

if [ -n "$MISSING_REVIEWS" ]; then
  echo "Cannot spawn fixer - missing reviews from:$MISSING_REVIEWS"
  echo "Re-run SPAWN_REVIEWERS to get missing reviews"
  # Transition back to SPAWN_REVIEWERS instead of continuing
  exit 1
fi

echo "All 3 review files verified for $SUBTASK"

# Set checkpoint BEFORE spawning fixer
set_checkpoint "SPAWN_FIXER" "$SUBTASK"
```
**NOTE**: This is just pseudocode for your actual tool call.
```xml
<function_calls>
<invoke name="Task">
<parameter name="subagent_type">orchestrator-fixer</antml:parameter>
<parameter name="prompt">WORKING_DIRECTORY: /workspaces/stonks/.worktrees/{subtask-name}
           SUBTASK_DESIGN_DOC: $ARGUMENTS/subtasks/{subtask-name}.xml
           REVIEW_FILES:
           - ${REVIEW_OR}
           - ${REVIEW_CPP}
           - ${REVIEW_HFT}

           Read ALL review files and fix the issues identified.
           Focus on issues from the FULL REVIEW section (below ---).
           Make a git commit with your changes.

           OUTPUT FORMAT (REQUIRED):
           ## Summary
           [2-3 bullets on fixes applied]

           ## Result
           - Status: success|partial|failed
           - Files: [modified files]
           - Commit: {hash}
           - Next: Re-run reviewers

           ---</antml:parameter>
</antml:invoke>
</antml:function_calls>
```

**Verify commit was made:**
```bash
cd .worktrees/${SUBTASK} && LAST_COMMIT=$(git log -1 --oneline) && cd -
echo "Last commit in ${SUBTASK}: $LAST_COMMIT"
if [ -z "$LAST_COMMIT" ]; then
  echo "WARNING: No commit found - fixer may have failed"
else
  # Clear checkpoint after successful commit
  clear_checkpoint
fi
```

**Transition:** → **SPAWN_REVIEWERS** (re-review after fixes)

---

## State: CREATE_PR

When all 3 reviewers score >= 0.96:

```bash
# Set checkpoint BEFORE creating PR
set_checkpoint "CREATE_PR" "{subtask-name}"

cd .worktrees/{subtask-name}

# Ensure we're up to date
git status

# Push branch first
git push -u origin feat/{subtask-name}

# Create PR
gh pr create \
  --title "feat({subtask-name}): Brief description from design doc" \
  --body "$(cat <<'EOF'
## Summary
{from subtask XML design section}

## Review Scores
- orchestrator-reviewer: {score}
- cpp-performance-expert: {score}
- hft-system-architect: {score}

## Evidence
- Reviews: $ARGUMENTS/build-reviews/{subtask-name}/

## Testing
- Unit tests: {passing count}
- Integration tests: {passing count}
- Benchmarks: {status}

## Related
- Design doc: $ARGUMENTS/subtasks/{subtask-name}.xml
- Subplan: $ARGUMENTS/subplans/{subtask-name}.md

🤖 Generated with [Claude Code](https://claude.com/claude-code)
EOF
)"

cd -
```

**Verify PR was created:**
```bash
PR_URL=$(cd .worktrees/{subtask-name} && gh pr view --json url -q .url 2>/dev/null)
if [ -z "$PR_URL" ]; then
  echo "ERROR: PR creation may have failed"
  # See Error Recovery section
else
  echo "PR created: $PR_URL"
  # Clear checkpoint after successful PR creation
  clear_checkpoint
fi
```

**Transition:** → **UPDATE_TRACKER**

---

## State: UPDATE_TRACKER

Update `pr_tracker.md` with PR link:

```bash
# Update status for completed subtask (atomic sed)
# Find the line for this subtask and update it
atomic_sed "s/| ${SUBTASK_NAME} .* | in_progress |/| ${SUBTASK_NAME} | ... | pr_created | ${PR_URL} |/" design-docs/orchestration/pr_tracker.md

# Count completed
COMPLETED=$(grep -c "pr_created" design-docs/orchestration/pr_tracker.md || echo 0)
echo "Subtasks with PRs: $COMPLETED"
```

**MANDATORY: Context cleanup before next subtask**

```bash
# Check context usage
/context

# If > 50% used, compact NOW before selecting next subtask
# Write diary first:
```

Use `$recording-diary` with:
```
STATE: UPDATE_TRACKER
JUST_COMPLETED: ${SUBTASK_NAME}
PR_URL: ${PR_URL}
TOTAL_PRS: ${COMPLETED}
NEXT_ACTION: CHECK_COMPLETION then SELECT_SUBTASKS if more remain
```

Then run `/compact` if context > 50%.

**Transition:** → **CHECK_COMPLETION**

---

## State: CHECK_COMPLETION

Check if all subtasks have PRs:

```bash
# Count remaining subtasks without PRs
REMAINING=$(grep -cE '^\| .* \| (in_progress|pending|blocked) \|' design-docs/orchestration/pr_tracker.md || echo "0")
echo "Remaining subtasks: $REMAINING"
```

**Transition Rules:**
- If `REMAINING == 0` → Output `<promise>ALL_SUBTASKS_PR_CREATED</promise>` → **DONE**
- If `REMAINING > 0` → **SELECT_SUBTASKS** (continue with next batch)

---

## Error Recovery
**NOTE**: This is just pseudocode for your actual tool call.
### Agent Timeout/Failure
```xml
<function_calls>
<invoke name="AskUserQuestion">
<parameter name="questions">[{
    "header": "Agent Failed",
    "question": "Agent {name} failed for subtask {subtask}. What should we do?",
    "options": [
      {"label": "Retry", "description": "Try the agent one more time"},
      {"label": "Skip review", "description": "Continue without this reviewer"},
      {"label": "Manual", "description": "I'll handle this manually"}
    ],
    "multiSelect": false
  }]</antml:parameter>
</antml:invoke>
</antml:function_calls>
```

### Worktree Creation Failed
```bash
if [ ! -d "$WORKTREE_PATH" ]; then
  echo "ERROR: Failed to create worktree at $WORKTREE_PATH"
  # Check if branch already exists
  git branch -a | grep "feat/${SUBTASK_NAME}" && echo "Branch exists, try: git worktree add $WORKTREE_PATH feat/${SUBTASK_NAME}"
fi
```

### PR Creation Failed
```bash
if [ -z "$PR_URL" ]; then
  echo "Attempting to diagnose PR creation failure..."
  cd .worktrees/{subtask-name}
  git status
  git log -3 --oneline
  gh auth status
  cd -
  # Retry or ask human
fi
```

### Stuck Loop (No Progress)
If scores don't improve after 3 iterations:
**NOTE**: This is just pseudocode for your actual tool call.
```xml
<function_calls>
<invoke name="AskUserQuestion">
<parameter name="questions">[{
    "header": "Stuck",
    "question": "Subtask {name} stuck after {N} iterations. Scores not improving. What should we do?",
    "options": [
      {"label": "Skip", "description": "Mark as blocked, continue with others"},
      {"label": "Simplify", "description": "Reduce scope of this subtask"},
      {"label": "Debug", "description": "Let's debug the specific issue together"}
    ],
    "multiSelect": false
  }]</antml:parameter>
</antml:invoke>
</antml:function_calls>
```

If marked as blocked, update tracker:
```bash
atomic_sed "s/| ${SUBTASK_NAME} .* | in_progress |/| ${SUBTASK_NAME} | ... | blocked | - | {reason} |/" design-docs/orchestration/pr_tracker.md
```

---

## Reading Review Headers

Reviews have this structure:
```markdown
# Review: {subtask-name}

## Summary (for orchestrator)
- Implementation status and key findings
- Testing coverage assessment
- Performance observations

### Key Issues
- [List of issues by severity]

### Recommended Fixer
orchestrator-fixer

## Result
- Score: 0.XX (INTERNAL - do not share with other agents)

---
## Full Review (for fixer agent)
[Detailed content below - DO NOT READ THIS SECTION]
```

**Only read above the `---` delimiter** (~500 tokens).

**CRITICAL**: Scores are for orchestrator decision-making only. Never pass scores to:
- Reviewers (would bias future reviews)
- Fixers (only need issues, not scores)
- Any re-review iteration

---

## State Files

| File | Purpose |
|------|---------|
| `.claude/orchestrator-loop.local.md` | Loop state (iteration, current_state) |
| `design-docs/orchestration/pr_tracker.md` | Subtask status and PR links |
| `$ARGUMENTS/plan/batches.md` | Execution order |
| `$ARGUMENTS/build-reviews/{subtask}/` | Review files by subtask |

## Completion Promise

Output `<promise>ALL_SUBTASKS_PR_CREATED</promise>` ONLY when:
1. ALL subtasks from ALL batches have PRs created
2. All PRs pass the review threshold (>= 0.96)

**CRITICAL**: Only output a promise when it is TRUE. Do not lie to exit the loop.

## Constraints

### Sequential Processing (CRITICAL)
1. **MAX 2 SUBTASKS AT A TIME** - never select more
2. **COMPLETE FULL CYCLE** before selecting more subtasks:
   - SELECT → SETUP_WORKTREES → SPAWN_REVIEWERS → EVALUATE → FIX → CREATE_PR → UPDATE_TRACKER
3. **NEVER spawn reviewers for all subtasks at once** - this causes context explosion
4. **WAIT for current batch PRs** before moving to next batch

### Reviewer Limits
- **Maximum 6 reviewers per spawn** (2 subtasks × 3 reviewers)
- Each reviewer writes to a UNIQUE file path (includes agent name)
- Read only above `---` delimiter (~500 tokens per review)

### Resource Management
- Sub-agents use 1-2 threads for builds
- Worktrees in `.worktrees/{subtask-name}/`
- Branch naming: `feat/{subtask-name}`
- Reviews in `$ARGUMENTS/build-reviews/{subtask-name}/`

### Context Preservation
- **ALWAYS write diary at end of each iteration**
- **COMPACT after each subtask gets PR** (before SELECT_SUBTASKS picks next)
- **Never read full files** - use sed/head to extract only needed sections
- **Always verify files/worktrees exist after operations**

## Now: Determine Your Action

1. Read your memories with `$activating-memories`
2. Read state files (loop state + pr_tracker)
3. Determine current state from state machine
4. Execute the appropriate state's actions
5. Follow transition rules to next state
6. Use `$recording-diary` before stopping
