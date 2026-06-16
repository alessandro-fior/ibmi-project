\# IBM i Compilation Rules

\## Source header rule

Every production source member MUST start with a reproducible operations header.

The header MUST be inside the source member itself, not only in Git commit
messages, pull request notes, or external documentation.

The header MUST include:

\- object name
\- source member and source file
\- object type
\- compile command
\- runtime command or entry command when applicable
\- required overrides, bindings, or dependencies
\- deployment notes needed by operations

\---

\## Standard header format

Use this block at the top of RPGLE, SQLRPGLE, CLLE, DDS, and SQL sources:

```
//  BUILD:
//    <IBM i compile command>
//  RUN:
//    <CALL / command / not applicable>
//  DEPENDS:
//    <files, service programs, printer files, SQL objects>
//  NOTES:
//    <production notes required to rebuild or operate the object>
```

For DDS or SQL sources use the native comment marker for that source type.

\---

\## Command string standards

Simple RPG program:

```
CRTBNDRPG PGM(&LIB/&PGM) SRCFILE(&LIB/QRPGLESRC) SRCMBR(&MBR) DBGVIEW(*SOURCE) OPTION(*EVENTF)
```

SQL RPG program:

```
CRTSQLRPGI OBJ(&LIB/&PGM) SRCFILE(&LIB/QRPGLESRC) SRCMBR(&MBR) OBJTYPE(*PGM) COMMIT(*NONE) DBGVIEW(*SOURCE) OPTION(*EVENTF)
```

RPG module:

```
CRTRPGMOD MODULE(&LIB/&MOD) SRCFILE(&LIB/QRPGLESRC) SRCMBR(&MBR) DBGVIEW(*SOURCE) OPTION(*EVENTF)
```

SQL RPG module:

```
CRTSQLRPGI OBJ(&LIB/&MOD) SRCFILE(&LIB/QRPGLESRC) SRCMBR(&MBR) OBJTYPE(*MODULE) COMMIT(*NONE) DBGVIEW(*SOURCE) OPTION(*EVENTF)
```

Program from modules:

```
CRTPGM PGM(&LIB/&PGM) MODULE(&LIB/&MOD1 &LIB/&MOD2) BNDSRVPGM(&LIB/&SRVPGM)
```

DDS printer file:

```
CRTPRTF FILE(&LIB/&FILE) SRCFILE(&LIB/QDDSSRC) SRCMBR(&MBR)
```

SQL scripts:

```
RUNSQLSTM SRCFILE(&LIB/QSQLSRC) SRCMBR(&MBR) COMMIT(*NONE) NAMING(*SQL)
```

\---

\## Determinism

Command strings MUST use placeholders only when the production library or
environment is intentionally variable.

Use these placeholders consistently:

\- `&LIB` for target library
\- `&PGM` for program object
\- `&MOD` for module object
\- `&SRVPGM` for service program
\- `&FILE` for file object
\- `&MBR` for source member

Do not invent alternate placeholder names.

\---


\## RPG compilation



\- Use CRTBNDRPG for simple programs

\- Use CRTRPGMOD + CRTPGM for service programs



\---



\## SQL compilation



\- Use RUNSQLSTM for scripts

\- Validate syntax before deployment



\---



\## Error handling



Compilation errors must be:

\- logged

\- not ignored

\- surfaced to AI context when possible

