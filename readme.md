# Skillrena: Like Serena but less tokens

![Skillrena Logo](./img/skillrena-logo.png)

This is like Serena, but optimized for lower token usage. It uses a set of focused skills to guide the reasoning process with minimal overhead.

## Setup

Sadly, codex does not [allow symlinks](https://github.com/openai/codex/issues/7798) for skills, so you need to hard copy this folder into your skills directory.

I have a script to help with that:
```bash
./scripts/cp_skills.sh
# If you want to remove them
# ./scripts/remove_skills.sh
```

All skills for this project end with `-skl` to avoid conflicts with other skills.

When you first start working on a new project, run:

```bash
$activate-skl
```

This will tell the agent to check if onboarding has been performed, and if not, it will run onboarding to create memories about the project.

After that, you can switch modes as needed. For example, to switch to editing mode, run:

```bash
$switch_modes-skl planning
```

This will set the active mode to `planning`, which is suitable for analysis and planning tasks.

This is a new project, so please report any issues or suggestions on [GitHub](https://github.com/SteveBronder/skillrena/issues/new).
