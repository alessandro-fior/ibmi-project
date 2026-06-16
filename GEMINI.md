\# IBM i 7.5 - GEMINI ENTERPRISE MODE (v2)



This repository is a controlled IBM i 7.5 RPGLE + DB2 for i system.



AI MUST strictly follow these rules. No exceptions.



\---



\# 1. SYSTEM PRIORITY ORDER (CRITICAL)



AI must apply rules in this order:



1\. GEMINI.md (this file) ← HIGHEST PRIORITY

2\. AGENTS.md (root project governance)

3\. .skills/ibmi-rpg/core.md

4\. .skills/ibmi-rpg/db2-for-i.md

5\. .skills/ibmi-rpg/rpgle-rules.md

6\. .skills/ibmi-rpg/coding-standards.md



If rules conflict:

→ GEMINI.md ALWAYS wins



\---



\# 2. ARCHITECTURE ENFORCEMENT (NON-NEGOTIABLE)



All RPG objects MUST follow naming rules:



\- \*\_repo   → DB2 access layer (SQLRPGLE only)

\- \*\_serv   → business logic layer

\- \*\_main   → entry point program

\- \*\_t\_\*    → test programs ONLY



Invalid naming = reject output.



\---



\# 3. FILE PLACEMENT RULES (STRICT)



\- RPGLE programs → /qrpglesrc

\- SQL scripts    → /qsqlsrc

\- DDS sources    → /qddssrc

\- CL programs    → /qcllesrc (if exists)



SQL inside RPG folders is INVALID unless embedded SQLRPGLE.



\---



\# 4. DB2 FOR I RULES (CRITICAL)



\- SELECT \* is FORBIDDEN

\- All queries must use explicit column lists

\- All queries must be parameterized (host variables only)

\- No string concatenation in SQL

\- All SQL must be optimized for IBM i indexes



\---



\# 5. RPGLE RULES



\- Free-format RPGLE ONLY

\- No legacy indicators unless explicitly required

\- No GOTO, no MOVE, no MOVEL (except migration legacy review)

\- Use procedures (dcl-proc) wherever possible

\- Use MONITOR/ON-ERROR for error handling



\---



\# 6. MODERNIZATION RULES



When refactoring legacy RPG:



AI MUST:



1\. Explain legacy logic first

2\. Convert to SQLRPGLE if possible

3\. Preserve 100% business logic

4\. Improve DB2 performance only if safe

5\. Never remove or change business rules

6\. MANDATORY: Use ILE Built-In Functions (%) instead of opcodes (e.g., %SUBST vs SUBST)

7\. MANDATORY: Prefer direct assignment (A = B) over EVAL (eval A = B) unless required for clarity in complex expressions.



\---



\# 7. AI BEHAVIOR CONTRACT



AI MUST:



\- Validate repository structure before generating code

\- Normalize naming inconsistencies mentally before output

\- Refuse to generate code if rules are violated

\- Suggest fixes instead of guessing



AI MUST NOT:



\- Invent new naming conventions

\- Mix architecture layers (repo/serv/main)

\- Ignore DB2 optimization rules

\- Modify business logic without explicit request



\---



\# 8. SELF-CHECK (MANDATORY BEFORE OUTPUT)



Before responding, AI must verify:



✔ correct folder placement  

✔ correct naming convention  

✔ SQL compliance (no SELECT \*)  

✔ RPG free-format compliance  

✔ architecture separation (repo/serv/main)



If any check fails:

→ output correction plan instead of code



\---



\# 9. OUTPUT FORMAT STANDARD



When generating or refactoring code:



1\. Analysis

2\. Proposed structure

3\. Code (IBM i compliant)

4\. DB2 notes

5\. Risk assessment



\---



\# 10. QUALITY LEVEL



All output must be:



\- production-ready IBM i 7.5 code

\- deterministic (same input → same structure)

\- enterprise-grade (not tutorial code)


PRINTER FILE RULES:

- All PRTF must be in QDDSSRC
- PRTF is NOT a DS or RPG structure
- No printer logic inside RPG data structures
- Use DDS record formats (HEADER / DETAIL / FOOTER)



REPORTING STANDARDS:

- Mandatory header logic: `if firstRecord or *inof; write HEADER; *inof = *off; endif;`
- Header record DDS must include `SKIPB(001)`
- Logic must reside in `*_report_serv.rpgle` layer