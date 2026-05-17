# RPGLE Rules (IBM i 7.5)

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
- `eval` (implicit)
- `iter`, `leave`

## Avoid / Forbidden
- Legacy indicators (*IN01-*IN99).
- `CABxx` opcodes.
- `MOVE`, `MOVEL`, `Z-ADD`.
- `GOTO`.
- Fixed-format RPG.

