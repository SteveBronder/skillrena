# Design Doc Templates

Available templates for creating design documents in Skillrena.

## Template Index

| Template | When to Use |
|----------|-------------|
| `base.md` | Meta template - defines structure and guardrails for all templates |
| `skill.md` | Creating new skills (`*-skl` or `*-ski` files) |
| `feature.md` | General features, CLI work, infrastructure changes |

## Choosing a Template

### skill.md

Use when:
- Creating a new callable skill (`*-skl`)
- Creating a new mode/internal skill (`*-ski`)
- Modifying existing skill behavior significantly

Includes sections for:
- Skill naming and conventions
- SKILL.md format requirements
- Token budget considerations
- Manual testing + token count verification

### feature.md

Use when:
- Adding infrastructure (scripts, tooling)
- Documentation changes
- CLI development (future Skillrena CLI)
- Cross-cutting concerns affecting multiple skills

Includes sections for:
- Architecture impact analysis
- Backwards compatibility considerations
- Migration planning (if needed)

## Creating New Templates

If you need a template variant not listed here:

1. Copy `base.md` as your starting point
2. Add variant-specific sections
3. Update this README with the new template
4. Ensure guardrails section is preserved

All templates must include the "Engineering Guardrails for Agent Execution" section from `base.md`.
