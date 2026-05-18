# File Structure - Post Refactoring

**Layout Target**: qrpglesrc/

## NUOVI FILE DA CREARE (Fase 1-2)

### 1. Fondazione - Costanti e Utilità

```
qrpglesrc/
├── globals.rpgleinc          [NEW] - Costanti globali
├── logger_serv.rpgle         [NEW] - Modulo logging
├── validator_serv.rpgle      [NEW] - Modulo validazione
│
├── customer_h.rpgleinc       [EXIST] - Data structures (non toccare)
├── order_h.rpgleinc          [EXIST] - Data structures (non toccare)
│
├── cus_main.rpgle            [REFACTOR] - Entry point
├── cus_serv.rpgle            [REFACTOR] - Business logic
├── cus_repo.sqlrpgle         [REFACTOR] - DB2 access
│
├── ord_serv.rpgle            [EXIST] - Business logic ordini
├── ord_repo.sqlrpgle         [EXIST] - DB2 access ordini
│
├── t_cusserv.rpgle           [NEW] - Test service customer
├── t_cusrepo.rpgle           [NEW] - Test repo customer
└── t_ordserv.rpgle           [FUTURE] - Test service ordini
```

---

## DETTAGLIO NUOVI FILE

### `globals.rpgleinc`

```rpgle
**free
// Global Constants and Configuration
// Used by: all modules

// ============ DATABASE SCHEMA ============
dcl-c SCHEMA 'PRODDB';
dcl-c TBL_CUSTOMER 'CUSTOMER';
dcl-c TBL_ORDER 'ORDERS';

// ============ CUSTOMER STATUS CODES ============
dcl-c STATUS_ACTIVE 'A';
dcl-c STATUS_INACTIVE 'I';
dcl-c STATUS_SUSPENDED 'S';

// ============ ERROR CODES ============
dcl-c ERR_VALIDATION 100;
dcl-c ERR_NOT_FOUND 101;
dcl-c ERR_DUPLICATE_KEY 102;
dcl-c ERR_DATABASE 500;
dcl-c ERR_UNKNOWN 999;

// ============ VALIDATION CONSTANTS ============
dcl-c EMAIL_MIN_LEN 5;
dcl-c EMAIL_MAX_LEN 100;
dcl-c NAME_MIN_LEN 2;
dcl-c NAME_MAX_LEN 100;

// ============ LOG LEVELS ============
dcl-c LOG_INFO 'INFO';
dcl-c LOG_WARN 'WARN';
dcl-c LOG_ERROR 'ERROR';
```

### `logger_serv.rpgle`

```rpgle
**free
ctl-opt option(*nodebugio : *srcstmt : *nounref)
        datedit(*ymd);

// Logging Service Module
// Purpose: Centralized logging for all application layers

dcl-proc logInfo export;
  dcl-pi *n;
    message varchar(256) const;
  end-pi;
  
  // TODO: Implement structured logging
  // For now: write to job log
  // In production: could write to QSYSPRT or database
  
  dsply ('INFO: ' + message);
end-proc;

dcl-proc logError export;
  dcl-pi *n;
    errorCode int const;
    message varchar(256) const;
  end-pi;
  
  // TODO: Implement structured error logging
  dsply ('ERROR ' + %char(errorCode) + ': ' + message);
end-proc;
```

### `validator_serv.rpgle`

```rpgle
**free
ctl-opt option(*nodebugio : *srcstmt : *nounref)
        datedit(*ymd);

/copy qrpglesrc/globals.rpgleinc

// Validation Service Module
// Purpose: Centralized data validation logic

dcl-proc validateEmail export;
  dcl-pi *n ind;
    email varchar(100) const;
  end-pi;
  
  dcl-s len int;
  dcl-s atPos int;
  
  len = %len(%trim(email));
  
  // Check length
  if (len < EMAIL_MIN_LEN or len > EMAIL_MAX_LEN);
    return *off;
  endif;
  
  // Check for @
  atPos = %scan('@' : email);
  if (atPos <= 1 or atPos >= len);
    return *off;
  endif;
  
  return *on;
end-proc;

dcl-proc validateRequired export;
  dcl-pi *n ind;
    value varchar(256) const;
  end-pi;
  
  if (%len(%trim(value)) = 0);
    return *off;
  endif;
  
  return *on;
end-proc;
```

---

## FILE DA REFACTORARE

### `cus_main.rpgle`
- [ ] Aggiornare `ctl-opt` completo
- [ ] Aggiungere `/copy qrpglesrc/globals.rpgleinc`
- [ ] Aggiungere `/copy qrpglesrc/logger_serv.rpgle`
- [ ] Sostituire `snd-msg` con `logInfo()`
- [ ] Aggiungere monitor/on-error per chiamate

### `cus_serv.rpgle`
- [ ] Aggiornare `ctl-opt` completo
- [ ] Aggiungere `/copy qrpglesrc/globals.rpgleinc`
- [ ] Aggiungere `/copy qrpglesrc/validator_serv.rpgle`
- [ ] Sostituire `%scan()` con `validateEmail()`
- [ ] Aggiungere monitor/on-error

### `cus_repo.sqlrpgle`
- [ ] Aggiornare `ctl-opt` completo
- [ ] Aggiungere `/copy qrpglesrc/globals.rpgleinc`
- [ ] Aggiungere SQLSTATE handling in tutte le exec sql
- [ ] Aggiungere monitor/on-error
- [ ] Usare schema-qualified table names

---

## TEST FILE STRUCTURE

### `t_cusserv.rpgle`

```rpgle
**free
ctl-opt option(*nodebugio : *srcstmt : *nounref)
        datedit(*ymd)
        main(TestMain);

// Customer Service Test Module
// Tests: registerCustomer, validateInput

dcl-proc TestMain;
  // Test 1: Valid email
  testValidEmail();
  
  // Test 2: Invalid email
  testInvalidEmail();
  
  // Test 3: Register with valid data
  testRegisterSuccess();
  
  // Test 4: Register with missing name
  testRegisterMissingName();
  
  *inlr = *on;
end-proc;

dcl-proc testValidEmail;
  // TODO: Assert validateEmail('john@example.com') = *on
end-proc;

dcl-proc testInvalidEmail;
  // TODO: Assert validateEmail('invalid.email') = *off
end-proc;

dcl-proc testRegisterSuccess;
  // TODO: Setup test customer, call registerCustomer, assert success
end-proc;

dcl-proc testRegisterMissingName;
  // TODO: Setup customer with empty name, assert failure
end-proc;
```

### `t_cusrepo.rpgle`

```rpgle
**free
ctl-opt option(*nodebugio : *srcstmt : *nounref)
        datedit(*ymd)
        main(TestMain);

// Customer Repo Test Module
// Tests: getCustomer, createCustomer, error handling

dcl-proc TestMain;
  // Test 1: Get existing customer
  testGetExistingCustomer();
  
  // Test 2: Get non-existing customer
  testGetNonExistingCustomer();
  
  // Test 3: Create new customer
  testCreateNewCustomer();
  
  // Test 4: Duplicate insert (should fail)
  testDuplicateInsert();
  
  *inlr = *on;
end-proc;

dcl-proc testGetExistingCustomer;
  // TODO: Verify SQLCODE = 0
  // TODO: Verify data retrieved correctly
end-proc;

dcl-proc testGetNonExistingCustomer;
  // TODO: Verify SQLCODE = 100 (not found)
end-proc;

dcl-proc testCreateNewCustomer;
  // TODO: Verify insert succeeds, SQLCODE = 0
  // TODO: Verify ID generated
end-proc;

dcl-proc testDuplicateInsert;
  // TODO: Verify insert fails with duplicate key error
end-proc;
```

---

## COMPILATION ORDER

Post-refactoring, compilare in quest'ordine:

```
1. globals.rpgleinc       (no compile - include only)
2. logger_serv.rpgle      (dependency foundation)
3. validator_serv.rpgle   (dependency foundation)
4. cus_repo.sqlrpgle      (DB2 layer - uses globals)
5. cus_serv.rpgle         (Business layer - uses logger, validator, repo)
6. cus_main.rpgle         (Entry - uses serv, logger)
7. t_cusserv.rpgle        (Test)
8. t_cusrepo.rpgle        (Test)
```

---

## SIZE ESTIMATES

| File | Lines | Type | Est. Complexity |
|------|-------|------|-----------------|
| globals.rpgleinc | ~40 | Include | LOW |
| logger_serv.rpgle | ~50 | Service | LOW |
| validator_serv.rpgle | ~80 | Service | LOW |
| cus_main.rpgle (refact) | ~40 | Main | LOW |
| cus_serv.rpgle (refact) | ~80 | Service | MEDIUM |
| cus_repo.sqlrpgle (refact) | ~120 | Repo | MEDIUM |
| t_cusserv.rpgle | ~80 | Test | MEDIUM |
| t_cusrepo.rpgle | ~100 | Test | MEDIUM |

**Total Added**: ~550 LOC  
**Total Refactored**: ~240 LOC  
**Estimated Effort**: 6-8 hours (thorough)

---

## QUALITY GATES

Before moving to next phase:
- ✓ No compilation errors
- ✓ No unused variables (NOUNREF)
- ✓ Parameterized SQL only
- ✓ No legacy RPG opcodes
- ✓ Proper error handling
- ✓ Deterministic output

