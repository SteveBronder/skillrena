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
