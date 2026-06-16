# RPGLE Rules (IBM i 7.5)

## Mandatory Source Header
- Every RPGLE and SQLRPGLE source member MUST start with an operations header.
- The header MUST include `BUILD`, `RUN`, `DEPENDS`, and `NOTES`.
- Compile commands MUST be executable IBM i command strings, using the standard placeholders from `compilation-rouse.md`.
- Runtime examples MUST be kept in the source header when they are needed in production.
- Do not rely on Git comments, commit messages, or pull request notes for production build instructions.

## Mandatory (Control Options)
- Always include `ctl-opt`:
  - `option(*nodebugio : *srcstmt : *nounref)`
  - `datedit(*ymd)`
  - `main(EntryProc)` for non-linear modules

## Data Structures
- Use `dcl-ds` with `qualified` and `template` where appropriate.
- Prefer `likeds` over repeating definitions.

## Procedures & Logic
- Use `dcl-proc` for all logic blocks.
- Mandatory `dcl-pi` (Procedure Interface).
- Use `overload` for polymorphic procedures if applicable (IBM i 7.4+).
- Use `monitor` / `on-error` for all critical operations.

## Preferred Opcodes
- `exec sql`
- `iter`, `leave`

## Modern ILE Style (Mandatory)
- Use Built-In Functions (BIFs) for all string and data manipulation.
- **Conversion Table (Legacy/OpCode -> Modern BIF):**
  - `SUBST` -> `%SUBST`
  - `SCAN` -> `%SCAN`
  - `CHECK` -> `%CHECK`
  - `XLATE` -> `%XLATE`
  - `REPLACE` -> `%REPLACE`
  - `LOOKUP` -> `%LOOKUP`
  - `EQUAL` (in comparisons) -> use `==` or `=`
- **Assignments:**
  - Avoid `EVAL`. Use `variable = expression;`.
  - Use `+=`, `-=`, `*=`, `/=` for arithmetic updates.

## Avoid / Forbidden
- Legacy indicators (*IN01-*IN99).
- `CABxx` opcodes.
- `MOVE`, `MOVEL`, `Z-ADD`.
- `GOTO`.
- Fixed-format RPG.

