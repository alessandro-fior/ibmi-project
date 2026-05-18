# Piano Ottimizzazione Repository per Refactoring IBM i

**Data**: May 18, 2026  
**Compliance**: IBM i 7.5 + AGENTS.md + CLAUDE.md + .skills/ibmi-rpg/

---

## ANALISI DELLO STATO ATTUALE

### ✅ CONFORME
- Architecture layer separation (_main, _serv, _repo)
- Uso corretto di `likeds()` per data structures
- Parameterized SQL queries in _repo
- `dcl-proc` con `dcl-pi` per tutte le procedure
- Free-format RPGLE

### ⚠️ VIOLAZIONI RILEVATE

| File | Violazione | Regola | Priorità |
|------|-----------|--------|----------|
| `cus_main.rpgle` | `snd-msg` per output | Usare modulo logger strutturato | ALTA |
| `cus_main.rpgle` | `ctl-opt` incompleto | Manca `*nounref`, `datedit(*ymd)` | ALTA |
| `cus_repo.sqlrpgle` | SQL senza monitoraggio SQLSTATE | Mandatory SQLSTATE + SQLCODE | ALTA |
| `cus_serv.rpgle` | Email validation inline | Estrarre in procedure dedicata | MEDIA |
| `cus_serv.rpgle` | Nessun error handling strutturato | Aggiungere monitor/on-error | MEDIA |
| Progetto | Mancano costanti globali | Creare file costanti centralizzate | MEDIA |
| Progetto | Nessun modulo test per _serv | Aggiungere t_cusserv_test.rpgle | MEDIA |

---

## FASE 1: FONDAZIONE (PREPARAZIONE)

### 1.1 Creare modulo costanti globalI
**File**: `qrpglesrc/globals.rpgleinc`
- Costanti DB2 (table names, schema)
- Costanti applicative (STATUS_ACTIVE, STATUS_INACTIVE, etc.)
- Costanti errore (ERR_* codes)
- Costanti configurazione

### 1.2 Creare modulo logger strutturato
**File**: `qrpglesrc/logger_serv.rpgle`
- Procedure: `logInfo(message varchar(256))`
- Procedure: `logError(errorCode int, message varchar(256))`
- Rispetta layer separation (_serv = business logic)

### 1.3 Creare modulo validatore utility
**File**: `qrpglesrc/validator_serv.rpgle`
- `validateEmail()` - centralizzata
- `validatePhone()` - per futuri usi
- `validateRequired()` - per campi obbligatori

---

## FASE 2: REFACTORING ARCHITETTURA

### 2.1 Standardizzare tutti i `ctl-opt`

```rpgle
**free
ctl-opt option(*nodebugio : *srcstmt : *nounref) 
        datedit(*ymd)
        main(EntryProc);  // se entry point
```

### 2.2 Audit SQL in cus_repo.sqlrpgle
- Aggiungere `SQLSTATE` handling (non solo SQLCODE)
- Verificare qualified table names
- Verificare isolation level se necessario
- Aggiungere commit/rollback strategy

### 2.3 Separare validazione da business logic

**PRIMA**: `cus_serv.rpgle` mescola validazione + logica  
**DOPO**: 
- `cus_serv.rpgle` → chiama `validator_serv.validateEmail()`
- `validator_serv.rpgle` → logica pura di validazione

---

## FASE 3: ERROR HANDLING

### 3.1 Implementare monitor/on-error ovunque
Tutti i punti critici devono avere:
```rpgle
monitor;
  // critical operation
on-error;
  // handle with SQLSTATE/SQLCODE
endmon;
```

### 3.2 Standardizzare error response
Creare `ErrorResponse_t` data structure:
```rpgle
dcl-ds ErrorResponse_t qualified;
  success ind;
  code int;        // error code
  message varchar(256);
  sqlstate char(5);  // per SQL errors
end-ds;
```

---

## FASE 4: TESTING

### 4.1 Creare test suite per `cus_serv`
**File**: `qrpglesrc/t_cusserv.rpgle`
- Test: `validateEmail('valid@email.com')` → *on
- Test: `validateEmail('invalid.email')` → *off
- Test: `registerCustomer()` con dati validi → success
- Test: `registerCustomer()` con nome vuoto → error

### 4.2 Creare test suite per `cus_repo`
**File**: `qrpglesrc/t_cusrepo.rpgle`
- Test: SELECT con ID inesistente → SQLCODE 100
- Test: INSERT con duplicate key → rollback
- Test: INSERT successo → retrieve generated ID

---

## FASE 5: DOCUMENTAZIONE

### 5.1 Aggiornare commenti nei file
Ogni procedure deve avere:
```rpgle
// Purpose: [descrizione]
// Input:   [parametri in]
// Output:  [parametri out]
// Errors:  [SQLCODE/error codes]
dcl-proc nomeProcedura;
```

### 5.2 Creare README.md per architettura
```
# Customer Module Architecture

## Layer Structure
- cus_main.rpgle   → Entry point (orchestration)
- cus_serv.rpgle   → Business logic (validation, rules)
- cus_repo.rpgle   → DB2 access (queries only)

## Data Flow
User → cus_main → cus_serv (validate) → cus_repo (persist) → response
```

---

## CHECKLIST DI IMPLEMENTAZIONE

### Fase 1: Fondazione
- [ ] Creare `globals.rpgleinc` con costanti
- [ ] Creare `logger_serv.rpgle` con logging
- [ ] Creare `validator_serv.rpgle` con validazioni centralizzate

### Fase 2: Refactoring
- [ ] Aggiornare `ctl-opt` in tutti i file .rpgle
- [ ] Audit SQL in cus_repo.sqlrpgle
- [ ] Separare validazione da logica in cus_serv.rpgle
- [ ] Aggiungere monitor/on-error in cus_repo.sqlrpgle

### Fase 3: Error Handling
- [ ] Implementare ErrorResponse_t data structure
- [ ] Aggiornare tutti i proc per usare ErrorResponse_t
- [ ] Aggiungere SQLSTATE handling in SQL operations

### Fase 4: Testing
- [ ] Creare t_cusserv_test.rpgle
- [ ] Creare t_cusrepo_test.rpgle
- [ ] Validare compilazione di tutti i moduli test

### Fase 5: Documentazione
- [ ] Aggiornare commenti in tutti i file
- [ ] Creare README.md architettura
- [ ] Documentare error codes centralizzati

---

## DIPENDENZE TRA FASI

```
Fase 1 (Fondazione)
    ↓
Fase 2 (Refactoring Architettura)
    ↓
Fase 3 (Error Handling)
    ├→ Fase 4 (Testing)
    └→ Fase 5 (Documentazione)
```

---

## COMANDI COMPILAZIONE POST-REFACTORING

```bash
# Compile globals include (no executable)
CRTSQLRPGI OBJ(MYLIB/GLOBALS) SRCFILE(MYLIB/QRPGLESRC)

# Compile service modules
CRTBNDRPG PGM(MYLIB/LOGGER_SERV) SRCFILE(MYLIB/QRPGLESRC)
CRTBNDRPG PGM(MYLIB/VALIDATOR_SERV) SRCFILE(MYLIB/QRPGLESRC)

# Compile business layer
CRTBNDRPG PGM(MYLIB/CUSSERV) SRCFILE(MYLIB/QRPGLESRC)

# Compile data layer
CRTSQLRPGI OBJ(MYLIB/CUSREPO) SRCFILE(MYLIB/QRPGLESRC)

# Compile entry point
CRTBNDRPG PGM(MYLIB/CUSMAIN) SRCFILE(MYLIB/QRPGLESRC)

# Test compilation
CRTBNDRPG PGM(MYLIB/T_CUSSERV_TEST) SRCFILE(MYLIB/QRPGLESRC)
CRTBNDRPG PGM(MYLIB/T_CUSREPO_TEST) SRCFILE(MYLIB/QRPGLESRC)
```

---

## METRICHE DI SUCCESSO

✓ Tutti i file compilano senza warning  
✓ Nessuna violazione di architettura layer  
✓ SQL sempre parameterizzato  
✓ Error handling con SQLSTATE in 100% procedute DB2  
✓ Test suite per _serv e _repo  
✓ Naming conventions coerente (inX_, outX_)  
✓ Nessun legacy indicator (*IN*)  
✓ Nessun GOTO, MOVE, MOVEL  

---

## NOTE IMPORTANTI

1. **Non rompere la logica di business**: Il refactoring è strutturale, la logica rimane intatta
2. **Determinismo**: Ogni run di compilazione deve produrre stesso bytecode
3. **Produzione-ready**: Ogni modulo deve passare validation prima di deploy
4. **Parameterized SQL**: Nessuna eccezione - sempre host variables

---

**Next Step**: Eseguire Fase 1 - Creare fondazione con globals, logger, validator
