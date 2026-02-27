# Suggested commands (markdown)

## Setup
- `cd /home/sbronder/open_source/skillrena`
- Optional tooling:
  - `npm i -D markdownlint-cli2 prettier`

## Develop / run
- List skills: `find skillrena -maxdepth 2 -name SKILL.md -print`
- Find references that may break after moves: `rg -n 'references/|assets/|scripts/' skillrena`

## Testing

### Run all tests
- `bash -n scripts/cp_skills.sh scripts/remove_skills.sh`
- `find skillrena -maxdepth 2 -name SKILL.md -print`
- `rg -n '^name:|^description:' skillrena/*/SKILL.md`
- Optional markdown lint if installed:
  - `markdownlint-cli2 "**/*.md"`
  - `prettier --check "**/*.md"`

### Run a single test (fast loop)
- Single script syntax: `bash -n scripts/cp_skills.sh`
- Single skill metadata check: `rg -n '^name:|^description:' skillrena/activating-memories/SKILL.md`

### Lint / format / typecheck
- Lint markdown (optional): `markdownlint-cli2 "**/*.md"`
- Format check markdown (optional): `prettier --check "**/*.md"`

## Build / package
- Install skills/plugins locally: `./scripts/cp_skills.sh`

## Safety notes
- Destructive command: `./scripts/remove_skills.sh` (uses `rm -rf` on `$HOME` subpaths).
