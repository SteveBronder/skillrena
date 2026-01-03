---
description: Read only the summary header from agent output to preserve orchestrator context
---

# Read Agent Summary

Use this skill when processing output from spawned agents. This ensures you only read the summary header and not the full output, preserving your context budget.

## When to Use

- After ANY Task tool returns output from a spawned agent
- Before reading any agent-generated files
- When evaluating scores from reviewers

## Agent Output Format

All orchestrator-spawned agents MUST return output in this format:

```
## Summary
[2-5 bullet points, max 100 tokens]

## Result
- Status: {success|partial|failed}
- Score: {0.00-1.00} (if applicable)
- Files: {comma-separated list of created/modified files}
- Next: {recommended next action}

---
[Full details below - DO NOT READ unless debugging]
```

## How to Parse

### For Task Tool Output

When a Task returns, the output appears in the function results. Parse it as follows:

```bash
# The Task output is in the response - extract summary only
# Look for content ABOVE the first "---" line

# If output is in a variable:
SUMMARY=$(echo "$AGENT_OUTPUT" | sed -n '1,/^---$/p' | head -20)
```

### For Agent-Generated Files

When agents write files (reviews, design docs), read only the header:

```bash
# Read only above the --- delimiter, max 60 lines
HEADER=$(sed -n '1,/^---$/p' "$FILE_PATH" | head -60)

# Verify we got a header (should contain Score or Status)
if ! echo "$HEADER" | grep -qE '(Score:|Status:)'; then
  echo "WARNING: File may not have proper header format"
fi
```

## Token Budget

- Summary section: ~50-100 tokens
- Result section: ~30-50 tokens
- Total header: **MAX 200 tokens**

If the header exceeds 200 tokens, something is wrong - the agent didn't follow the format.

## Example Valid Summary

```
## Summary
- Split overview.md into 5 subplans covering all requirements
- Each subplan is <15K tokens and represents 1-2 days work
- Dependencies form a DAG with no cycles
- Created validation criteria for each subplan

## Result
- Status: success
- Files: subplans/01-types.md, subplans/02-orderbook.md, subplans/03-risk.md, subplans/04-engine.md, subplans/05-infra.md
- Next: Run consistency review with all 3 reviewers

---
[Detailed breakdown of each subplan...]
```

## Error Handling

If agent output doesn't have a `---` delimiter:
1. Read only the first 20 lines
2. Log a warning about malformed output
3. Consider the agent may have failed

```bash
if ! grep -q '^---$' "$FILE_PATH"; then
  echo "WARNING: Agent output missing --- delimiter"
  HEAD=$(head -20 "$FILE_PATH")
else
  HEAD=$(sed -n '1,/^---$/p' "$FILE_PATH")
fi
```

## Critical Rules

1. **NEVER read below the `---` line** unless explicitly debugging
2. **NEVER read full agent output** into your context
3. **ALWAYS use this skill** after spawning any agent
4. If you need details from full output, spawn another agent to summarize it
