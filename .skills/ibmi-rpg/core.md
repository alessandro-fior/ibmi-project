# IBM i AI Rule Engine - Core

This folder defines deterministic rules for AI code generation.

## Priority order

1. GEMINI.md (highest priority - system master)
2. AGENTS.md (global project governance)
3. .skills/ibmi-rpg/core.md
4. .skills/ibmi-rpg/db2-for-i.md
5. .skills/ibmi-rpg/rpgle-rules.md
6. .skills/ibmi-rpg/coding-standards.md

---

## AI enforcement rule

AI MUST:
- Read ALL files in .skills/ibmi-rpg before generating code
- Never override DB2 or RPG rules
- Prefer modernization but never break business logic

---

## Determinism rule

Given same input, AI must produce:
- same structure
- same naming conventions
- same SQL patterns
- same production source header structure
- same IBM i compile command string pattern

---

## Production source rule

Build, run, dependency, and deployment notes required in production MUST live at
the top of the source member.

Git-only comments are not production documentation.





