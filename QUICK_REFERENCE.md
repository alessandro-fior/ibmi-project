# QUICK REFERENCE - IBM i Refactoring Skills

**Cheat Sheet per Developer**  
**Print this** 📋

---

## ⚡ GOLDEN RULES

| Regola | ❌ Sbagliato | ✅ Corretto |
|--------|------------|-----------|
| **ctl-opt** | `ctl-opt dftactgrp(*no);` | `ctl-opt option(*nodebugio : *srcstmt : *nounref) datedit(*ymd);` |
| **SQL Columns** | `SELECT *` | `SELECT id, name, email` |
| **Table Names** | `CUSTOMER` | `PRODDB.CUSTOMER` |
| **SQL Params** | `WHERE name = 'John'` | `WHERE name = :inName` |
| **String Extract** | `SUBST(str, 1, 5)` | `%SUBST(str : 1 : 5)` |
| **String Search** | `SCAN('@' str)` | `%SCAN('@' : str)` |
| **Assignment** | `EVAL x = 5;` | `x = 5;` |
| **Error Check** | (none) | `IF SQLCODE <> 0;` |
| **Legacy Code** | `MOVE varA varB;` | `varB = varA;` |
| **Legacy Indicators** | `*IN01`, `*IN02` | Niente! Use `ind` variables |
| **GOTO** | `GOTO LABEL;` | Use procedure, never GOTO |
| **Logging** | `snd-msg 'text';` | `logInfo('text');` |

---

## 🔧 COMPILATION COMMANDS

### Compile Include (no exec)
```bash
# globals.rpgleinc - no compile, just reference
# Use via: /copy qrpglesrc/globals.rpgleinc
```

### Compile Regular RPGLE
```bash
CRTBNDRPG PGM(MYLIB/LOGGER_SERV) SRCFILE(MYLIB/QRPGLESRC) OPTION(*NONE)
CRTBNDRPG PGM(MYLIB/VALIDATOR_SERV) SRCFILE(MYLIB/QRPGLESRC) OPTION(*NONE)
CRTBNDRPG PGM(MYLIB/CUSSERV) SRCFILE(MYLIB/QRPGLESRC) OPTION(*NONE)
CRTBNDRPG PGM(MYLIB/CUSMAIN) SRCFILE(MYLIB/QRPGLESRC) OPTION(*NONE)
```

### Compile SQL RPGLE
```bash
CRTSQLRPGI OBJ(MYLIB/CUSREPO) SRCFILE(MYLIB/QRPGLESRC) COMMIT(*NONE) OPTION(*NONE)
```

### Compile Test
```bash
CRTBNDRPG PGM(MYLIB/T_CUSSERV) SRCFILE(MYLIB/QRPGLESRC) OPTION(*NONE)
CRTBNDRPG PGM(MYLIB/T_CUSREPO) SRCFILE(MYLIB/QRPGLESRC) OPTION(*NONE)
```

---

## 📦 LAYER RULES

```
MAIN Layer (*_main.rpgle)
  ├─ Orchestration ONLY
  ├─ Call service layer
  ├─ Return results to user
  └─ ERROR: No business logic, no SQL

SERVICE Layer (*_serv.rpgle)
  ├─ Business validation
  ├─ Apply rules
  ├─ Call repo layer
  └─ ERROR: No direct SQL, no file I/O

REPO Layer (*_repo.sqlrpgle)
  ├─ SQL queries ONLY
  ├─ Parameterized always
  ├─ Handle SQLCODE + SQLSTATE
  └─ ERROR: No business logic
```

**Call Chain**: main → serv → repo → DB2

---

## 🛡️ ERROR HANDLING TEMPLATE

### In _repo (SQL operations)
```rpgle
monitor;
  exec sql
    select name into :inName
    from PRODDB.CUSTOMER
    where id = :inId;
  end-exec;
on-error;
  outSuccess = *off;
endmon;

if sqlcode <> 0;
  outErrorMsg = 'SQLCODE: ' + %char(sqlcode) + 
                ' SQLSTATE: ' + SQLSTATE;
  outSuccess = *off;
endif;
```

### In _serv (validation)
```rpgle
if not validateEmail(inEmail);
  outSuccess = *off;
  outErrorMsg = 'Invalid email format';
  return;
endif;
```

### In _main (orchestration)
```rpgle
monitor;
  CusServ('REGISTER' : myCustomer : success : errorMsg);
on-error;
  logError(500, 'Service call failed');
  success = *off;
endmon;
```

---

## 📋 FILE CHECKLIST

Before committing each file:

### For ALL .rpgle files
- [ ] Free-format (`**free` first line)
- [ ] `ctl-opt option(*nodebugio : *srcstmt : *nounref) datedit(*ymd);`
- [ ] `/copy qrpglesrc/globals.rpgleinc` if using constants
- [ ] No legacy opcodes (MOVE, MOVEL, CAB*, GOTO)
- [ ] No fixed-format RPG
- [ ] No `*IN` indicators
- [ ] Use `%BIF()` for string ops (SUBST → %SUBST)
- [ ] dcl-pi in every proc
- [ ] No EVAL, use `variable = expression;`

### For _repo.sqlrpgle files
- [ ] Qualified table names (`SCHEMA.TABLE`)
- [ ] Explicit column lists (no SELECT *)
- [ ] All params as `:hostVariable`
- [ ] SQLCODE check after every exec sql
- [ ] SQLSTATE available for error handling
- [ ] monitor/on-error around critical SQL
- [ ] No business logic - pure data access

### For _serv.rpgle files
- [ ] Imports validator_serv for validations
- [ ] Calls repo for data access
- [ ] monitor/on-error for external calls
- [ ] No embedded SQL
- [ ] Pure business logic

### For _main.rpgle files
- [ ] Entry point proc or main(ProcName) in ctl-opt
- [ ] Imports logger_serv for messaging
- [ ] Calls service layer procs
- [ ] monitor/on-error for service calls
- [ ] Return results to caller/user

---

## 🔍 VALIDATION BEFORE COMMIT

### 1. Syntax Check
```bash
CRTBNDRPG PGM(MYLIB/TEST_MODULE) SRCFILE(MYLIB/QRPGLESRC) OPTION(*NONE)
# 0 errors = ✓ OK
```

### 2. Architecture Check
```
Count SQL in _main?      → Should be 0
Count SQL in _serv?      → Should be 0  
Count SQL in _repo?      → Should be 100%
Count MOVE opcodes?      → Should be 0
Count EVAL statements?   → Should be 0
Count SELECT * in SQL?   → Should be 0
```

### 3. Naming Check
```
Parameters in _serv start with "in" or "out"?  → YES
Constants in globals?                          → ALL
Error codes in globals?                         → ALL
Table names qualified?                         → YES
Status values as constants?                    → YES
```

### 4. Error Handling Check
```
SQLCODE check in SQL procs?     → YES, 100%
SQLSTATE handling?              → YES, in errors
monitor/on-error in critical sections? → YES
```

---

## 🎯 PRIORITY ORDER

If limited on time, do in this order:

1. **MUST HAVE** (30 min)
   - [ ] Create globals.rpgleinc
   - [ ] Update ctl-opt in all files
   - [ ] Remove all legacy opcodes
   
2. **SHOULD HAVE** (1h 30 min)
   - [ ] Create logger_serv
   - [ ] Create validator_serv
   - [ ] Add SQLSTATE to _repo

3. **NICE TO HAVE** (1h)
   - [ ] Error handling refactor
   - [ ] Test modules
   - [ ] Documentation

---

## 🚨 COMMON MISTAKES

| Mistake | Why Bad | How Fix |
|---------|---------|---------|
| `MOVE x y;` | Legacy | `y = x;` |
| `/copy` after code | Include placement | `/copy` at TOP after `**free` |
| `SELECT *` | No audit, hard to debug | Explicit columns |
| No SQLSTATE | Can't diagnose errors | Add after every exec sql |
| Business logic in _main | Violates architecture | Move to _serv |
| SQL in _serv | Violates layer separation | Move to _repo |
| `snd-msg` for logging | Deprecated | Use logInfo() |
| No monitor/on-error | Unhandled exceptions | Wrap in monitor block |
| EVAL statement | Legacy | Use `=` assignment |
| Fixed-format RPG | Harder to maintain | Use free-format always |

---

## 📞 QUICK CONTACTS

- Architecture Question? → Read `.skills/ibmi-rpg/service-architecture.md`
- SQL Question? → Read `.skills/ibmi-rpg/db2-for-i.md`
- RPG Syntax? → Read `.skills/ibmi-rpg/rpgle-rules.md`
- Naming? → Read `.skills/ibmi-rpg/coding-standards.md`

---

## ✅ FINAL DEPLOYMENT SIGN-OFF

Before moving to production:

```
Refactoring Completion Checklist:
[ ] All files compile (0 errors, 0 warnings)
[ ] No legacy RPG opcodes remain
[ ] 100% parameterized SQL
[ ] 100% schema-qualified tables  
[ ] 100% SQLSTATE handling in repo
[ ] 100% monitor/on-error coverage
[ ] Naming standards consistent
[ ] Architecture layers separated
[ ] Test modules pass
[ ] Documentation updated
[ ] Determinism verified (recompile = same bytes)

Approved for Production: ___________  Date: _______
```

---

**Print & Keep Near Your Desk! 📌**

