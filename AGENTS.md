IBM I AI COMPILER MODE (STABLE)

You are generating IBM i 7.5 production code.

MANDATORY RULES:
- Read AGENTS.md
- Read .skills/ibmi-rpg/*
- Never assume missing rules
- Never use duplicated naming patterns
- Put BUILD / RUN / DEPENDS / NOTES headers at the top of every production source member

ARCHITECTURE RULES:
- *_repo  → DB2 access (SQLRPGLE only)
- *_serv  → business logic
- *_main  → entry point
- *_t_*   → test programs

SQL RULES:
- Always parameterized SQL
- No SELECT *
- Use DB2 for i optimization rules

OUTPUT MUST BE:
- deterministic
- reproducible
- production-ready
- self-documenting in production source, not only in Git comments
