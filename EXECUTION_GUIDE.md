# EXECUTION GUIDE - Refactoring IBM i Skills

**Modalità**: Step-by-step implementation  
**Compliance**: IBM i 7.5 + All .skills/ibmi-rpg rules  

---

## FASE 1️⃣ FONDAZIONE

### Step 1.1: Creare `globals.rpgleinc`

**Azione**: Creare file include con costanti centralizzate

**Posizione**: `qrpglesrc/globals.rpgleinc`

**Contenuto Pattern**:
```rpgle
**free
// Global Constants - IBM i 7.5
// Used by: all modules (via /copy)

// Database schema qualification
dcl-c SCHEMA 'PRODDB';
dcl-c TBL_CUSTOMER 'CUSTOMER';

// Status constants
dcl-c STATUS_ACTIVE 'A';

// Error codes
dcl-c ERR_VALIDATION 100;

// Validation rules
dcl-c EMAIL_MAX_LEN 100;
```

**Verifica**:
- [ ] No syntax errors in editor
- [ ] Can be included via `/copy qrpglesrc/globals.rpgleinc`

---

### Step 1.2: Creare `logger_serv.rpgle`

**Azione**: Creare modulo logging centralizzato

**Posizione**: `qrpglesrc/logger_serv.rpgle`

**Requisiti**:
- [ ] ctl-opt completo: `option(*nodebugio : *srcstmt : *nounref) datedit(*ymd)`
- [ ] Procedure `logInfo(message varchar(256) const)` con `export`
- [ ] Procedure `logError(code int, message varchar(256))` con `export`
- [ ] dcl-pi in ogni proc
- [ ] Nessun SELECT * 
- [ ] Nessun legacy opcode (MOVE, MOVEL, CAB*)

**Compilation**:
```bash
CRTBNDRPG PGM(MYLIB/LOGGER_SERV) SRCFILE(MYLIB/QRPGLESRC) OPTION(*NONE)
```

**Verifica**:
- [ ] Compila senza warning
- [ ] DSPBNDPGM MYLIB/LOGGER_SERV → mostra export symbols

---

### Step 1.3: Creare `validator_serv.rpgle`

**Azione**: Creare modulo validazione centralizzato

**Posizione**: `qrpglesrc/validator_serv.rpgle`

**Requisiti**:
- [ ] `/copy qrpglesrc/globals.rpgleinc` (per costanti)
- [ ] ctl-opt completo
- [ ] Procedure `validateEmail()` → ind export
- [ ] Procedure `validateRequired()` → ind export
- [ ] Usa `%scan()`, `%len()`, `%trim()` (moderni BIF)
- [ ] Non usa `SCAN`, `MOVE`, `MOVEL`
- [ ] Nessun monitor necessario (no SQL)

**Compilation**:
```bash
CRTBNDRPG PGM(MYLIB/VALIDATOR_SERV) SRCFILE(MYLIB/QRPGLESRC) OPTION(*NONE)
```

**Verifica**:
- [ ] Compila senza warning
- [ ] Chiamabile da `cus_serv`

---

### ✅ CHECKPOINT FASE 1

Eseguire comandi di verifica:

```bash
# List created objects
DSPOBJD OBJ(MYLIB/LOGGER_SERV) OBJTYPE(*PGM) DETAIL(*FULL)
DSPOBJD OBJ(MYLIB/VALIDATOR_SERV) OBJTYPE(*PGM) DETAIL(*FULL)

# Try to view includes
EDTF SRCFILE(MYLIB/QRPGLESRC) SRCMBR(GLOBALS) MBRTYPE(*INCLUDE)
```

**Success Criteria**:
- ✓ Entrambi i moduli compilano
- ✓ globals.rpgleinc è include-able
- ✓ Nessun errore di sintassi RPG

---

## FASE 2️⃣ REFACTOR ARCHITETTURA

### Step 2.1: Refactor `cus_main.rpgle`

**Azione**: Aggiornare entry point con nuove dipendenze

**Prima** (Stato attuale):
```rpgle
**free
ctl-opt dftactgrp(*no) actgrp(*new);
// snd-msg 'Customer registered successfully';
```

**Dopo** (Target):
```rpgle
**free
ctl-opt option(*nodebugio : *srcstmt : *nounref)
        datedit(*ymd)
        actgrp(*new);

/copy qrpglesrc/globals.rpgleinc
/copy qrpglesrc/logger_serv.rpgle

// Body con logInfo() al posto di snd-msg
```

**Checklist**:
- [ ] ctl-opt include `*nodebugio`, `*srcstmt`, `*nounref`, `datedit(*ymd)`
- [ ] Non più `snd-msg` - usa `logInfo()`
- [ ] Aggiunto `/copy qrpglesrc/globals.rpgleinc`
- [ ] Aggiunto `/copy qrpglesrc/logger_serv.rpgle`
- [ ] Qualsiasi CALL a `CusServ()` ha monitor/on-error

**Compilation**:
```bash
CRTBNDRPG PGM(MYLIB/CUSMAIN) SRCFILE(MYLIB/QRPGLESRC) BNDDIR(*LIBL) OPTION(*NONE)
```

---

### Step 2.2: Refactor `cus_serv.rpgle`

**Azione**: Separare validazione da logica, aggiungere error handling

**Cambiamenti**:
1. Aggiungi `/copy qrpglesrc/validator_serv.rpgle`
2. Sostituisci:
   ```rpgle
   // PRIMA:
   if not %scan('@' : ioCustomer.email) > 0;
   
   // DOPO:
   if not validateEmail(ioCustomer.email);
   ```
3. Aggiungi monitor/on-error:
   ```rpgle
   monitor;
     CusRepo('CREATE' : ioCustomer : outSuccess : outErrorMsg);
   on-error;
     outSuccess = *off;
     outErrorMsg = 'Database error';
   endmon;
   ```

**Checklist**:
- [ ] `/copy validator_serv.rpgle` aggiunto
- [ ] `%scan()` sostituito con `validateEmail()`
- [ ] Tutte le chiamate a repo/procedure hanno monitor/on-error
- [ ] ctl-opt completo
- [ ] Nessun legacy opcode

**Compilation**:
```bash
CRTBNDRPG PGM(MYLIB/CUSSERV) SRCFILE(MYLIB/QRPGLESRC) BNDDIR(*LIBL) OPTION(*NONE)
```

---

### Step 2.3: Refactor `cus_repo.sqlrpgle`

**Azione**: Aggiungere SQLSTATE, monitor/on-error, schema qualification

**Cambiamenti**:

1. Aggiungi SQLSTATE handling:
   ```rpgle
   exec sql
     select name, email, status
     into :ioCustomer.name, :ioCustomer.email, :ioCustomer.status
     from PRODDB.CUSTOMER      -- schema-qualified
     where id = :ioCustomer.id;
   
   if sqlcode <> 0;
     outSuccess = *off;
     outErrorMsg = 'SQLCODE: ' + %char(sqlcode) + 
                   ' SQLSTATE: ' + SQLSTATE;
   endif;
   ```

2. Aggiungi monitor/on-error:
   ```rpgle
   monitor;
     exec sql ...
     END-EXEC;
   on-error;
     outSuccess = *off;
   endmon;
   ```

3. Aggiungi `/copy globals.rpgleinc` per table names

**SQL Audit Checklist**:
- [ ] Nessun `SELECT *` → specifici column names
- [ ] Tutti i table names schema-qualified (`PRODDB.CUSTOMER`)
- [ ] Tutte le query usano host variables (`:variable`)
- [ ] SQLCODE e SQLSTATE controllati
- [ ] INSERT/UPDATE con commit strategy definita

**Compilation**:
```bash
CRTSQLRPGI OBJ(MYLIB/CUSREPO) SRCFILE(MYLIB/QRPGLESRC) COMMIT(*NONE) OPTION(*NONE)
```

---

### ✅ CHECKPOINT FASE 2

Compilare in ordine:
```bash
CRTBNDRPG PGM(MYLIB/CUSREPO) ...
CRTBNDRPG PGM(MYLIB/CUSSERV) ...
CRTBNDRPG PGM(MYLIB/CUSMAIN) ...
```

**Success Criteria**:
- ✓ Tutti compilano senza warning
- ✓ CUSMAIN chiama CUSSERV
- ✓ CUSSERV chiama CUSREPO
- ✓ No SQL errors nella repository

---

## FASE 3️⃣ ERROR HANDLING

### Step 3.1: Creae ErrorResponse_t struttura

**Azione**: Standardizzare risposta errori

**Posizione**: Aggiungere a `customer_h.rpgleinc` o nuovo file

```rpgle
dcl-ds ErrorResponse_t qualified;
  success ind;
  errorCode int;
  message varchar(256);
  sqlstate char(5);
end-ds;
```

### Step 3.2: Aggiornare tutte le procedure

**Azione**: Usare ErrorResponse_t instead of scattered params

**Prima**:
```rpgle
dcl-pi *n;
  outSuccess ind;
  outErrorMsg varchar(100);
end-pi;
```

**Dopo**:
```rpgle
dcl-pi *n;
  outResponse likeds(ErrorResponse_t);
end-pi;
```

---

## FASE 4️⃣ TESTING

### Step 4.1: Creare `t_cusserv.rpgle`

**Posizione**: `qrpglesrc/t_cusserv.rpgle`

**Test Coverage**:
- [ ] validateEmail valid case
- [ ] validateEmail invalid case
- [ ] registerCustomer success
- [ ] registerCustomer validation failure

**Compilation**:
```bash
CRTBNDRPG PGM(MYLIB/T_CUSSERV_TEST) SRCFILE(MYLIB/QRPGLESRC) BNDDIR(*LIBL) OPTION(*NONE)
```

---

### Step 4.2: Creare `t_cusrepo.rpgle`

**Posizione**: `qrpglesrc/t_cusrepo.rpgle`

**Test Coverage**:
- [ ] getCustomer existing
- [ ] getCustomer not found (SQLCODE 100)
- [ ] createCustomer success
- [ ] createCustomer error handling

**Compilation**:
```bash
CRTSQLRPGI OBJ(MYLIB/T_CUSREPO_TEST) SRCFILE(MYLIB/QRPGLESRC) COMMIT(*NONE) OPTION(*NONE)
```

---

## FASE 5️⃣ DOCUMENTAZIONE

### Step 5.1: Aggiornare commenti nei file

**Pattern per ogni proc**:
```rpgle
// Purpose: Register a new customer
// Input:   inCustomer (Customer_t) - customer data to register
// Output:  outSuccess (ind) - operation result
//          outErrorMsg (varchar) - error message if failed
// Errors:  ERR_VALIDATION - if validation fails
//          ERR_DATABASE - if SQL fails
dcl-proc registerCustomer;
```

### Step 5.2: Creare README architettura

**Posizione**: `qrpglesrc/README.md`

```markdown
# Customer Module Architecture

## Layer Structure
- **cus_main**: Entry point (orchestration only)
- **cus_serv**: Business logic (validation, rules)
- **cus_repo**: DB2 access (queries only)

## Data Flow
```
User Input
   ↓
cus_main (orchestration)
   ↓
cus_serv (validate via validator_serv)
   ↓
cus_repo (execute SQL)
   ↓
Response

## Utility Modules
- logger_serv: Logging across all layers
- validator_serv: Centralized validations
- globals.rpgleinc: Constants
```

---

## 🎯 SUMMARY DI PROGRESSO

| Fase | Task | Stato | Est. Tempo |
|------|------|-------|-----------|
| 1 | Creare globals, logger, validator | TODO | 30 min |
| 2 | Refactor main, serv, repo | TODO | 1h |
| 3 | Error handling structures | TODO | 30 min |
| 4 | Test modules | TODO | 1h |
| 5 | Documentation | TODO | 30 min |
| ✅ | **TOTALE** | | **3h 30 min** |

---

## 🚀 DEPLOY READY CHECKLIST

Before deploying to production:

- [ ] Tutte le fasi completate
- [ ] Nessun compilation warning
- [ ] All test modules pass
- [ ] SQL audit completato
- [ ] Architecture validation ok
- [ ] Naming conventions coerenti
- [ ] SQLSTATE/SQLCODE handling in 100% operazioni DB2
- [ ] Determinism test: ricompilare 2x, byte-identical output

---

## ⚠️ COMMON PITFALLS

| Pitfall | Fix |
|---------|-----|
| Dimenticare `/copy globals` | Aggiungere in FIRST in file |
| SELECT * in SQL | Explicit column list sempre |
| Legacy opcode (MOVE/MOVEL) | Usar `=` assignment |
| No SQLSTATE handling | Aggiungere in AFTER ogni exec sql |
| Procedure senza dcl-pi | dcl-pi MANDATORY |
| Schema non qualified | Usare PRODDB.TABLENAME |
| snd-msg instead logInfo | Call logInfo() invece |

---

## 📝 NOTES

- **Determinism**: Stesso input → stesso bytecode. Non varia tra run.
- **Production-Ready**: Ogni modulo deve essere deploy-safe
- **No Breaking Changes**: Logica di business rimane identica
- **Parameterized SQL**: Mai concatenare stringhe in SQL

**Next**: Iniziare Step 1.1 - Creare `globals.rpgleinc`

