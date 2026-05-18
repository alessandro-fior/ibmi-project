# 🎯 VISION - IBM i Repository Optimization

**Objective**: Transform current code to production-grade IBM i 7.5 with deterministic, reproducible output  
**Timeline**: 5 phases, ~3.5 hours  
**Compliance**: 100% AGENTS.md + CLAUDE.md + .skills/ibmi-rpg/*

---

## CURRENT STATE → TARGET STATE

### Current Problems
```
❌ Scattered constants       → ✅ globals.rpgleinc centralized
❌ snd-msg for logging       → ✅ logger_serv module
❌ No validation layer       → ✅ validator_serv module  
❌ SQL without SQLSTATE      → ✅ Complete error handling
❌ No testing structure      → ✅ t_cusserv + t_cusrepo
❌ Incomplete ctl-opt        → ✅ Standardized headers
❌ Legacy opcodes (SCAN)     → ✅ Modern BIF functions
❌ No documentation          → ✅ Architecture + README
```

---

## 5-PHASE ROADMAP

```
PHASE 1: FOUNDATION (30 min)
├── globals.rpgleinc      ← Central constants
├── logger_serv.rpgle     ← Logging module
└── validator_serv.rpgle  ← Validation module

        ↓ [All existing code builds on these]

PHASE 2: ARCHITECTURE (1h)
├── cus_main.rpgle        ← Refactor: use logger
├── cus_serv.rpgle        ← Refactor: use validator
└── cus_repo.sqlrpgle     ← Refactor: add SQLSTATE

        ↓ [Layer separation guaranteed]

PHASE 3: ERROR HANDLING (30 min)
├── ErrorResponse_t       ← Standard response structure
├── monitor/on-error      ← 100% SQL coverage
└── SQLSTATE tracking     ← Comprehensive diagnostics

        ↓ [Production-grade error handling]

PHASE 4: TESTING (1h)
├── t_cusserv.rpgle       ← Service layer tests
└── t_cusrepo.rpgle       ← Repository layer tests

        ↓ [Code quality verified]

PHASE 5: DOCUMENTATION (30 min)
├── Enhanced comments     ← Every procedure documented
├── README.md             ← Architecture guide
└── Deployment checklist  ← Sign-off ready
```

---

## ARCHITECTURE AFTER REFACTORING

### Layer Separation

```
┌─────────────────────────────────────────────┐
│         USER INPUT / REQUEST                 │
└────────────────────┬────────────────────────┘
                     │
        ╔════════════▼═════════════╗
        ║    CUS_MAIN              ║
        ║   (Orchestration)        ║
        ║  • Parse input           ║
        ║  • Call service layer    ║
        ║  • Return response       ║
        ║  • NO business logic     ║
        ║  • NO SQL                ║
        ╚════════════╤═════════════╝
                     │
        ╔════════════▼═════════════╗
        ║    CUS_SERV              ║
        ║  (Business Logic)        ║
        ║  • Validate input        ║
        ║  • Apply rules           ║
        ║  • Call repo layer       ║
        ║  • NO SQL                ║
        ║  • Uses VALIDATOR_SERV   ║
        ║  • Uses LOGGER_SERV      ║
        ╚════════════╤═════════════╝
                     │
        ╔════════════▼═════════════╗
        ║    CUS_REPO              ║
        ║   (DB2 Access)           ║
        ║  • Execute SQL           ║
        ║  • Parameterized always  ║
        ║  • Handle SQLCODE/STATE  ║
        ║  • NO business logic     ║
        ║  • Transaction control   ║
        ╚════════════╤═════════════╝
                     │
        ╔════════════▼═════════════╗
        ║     PRODDB.CUSTOMER      ║
        ║   (Physical Database)    ║
        ║  • Persisted data        ║
        ║  • Indexed queries       ║
        ║  • Commitment control    ║
        ╚═════════════════════════╝

UTILITY MODULES (Used by all):
  • globals.rpgleinc    → Constants
  • logger_serv.rpgle   → Logging
  • validator_serv.rpgle → Validation
```

---

## FILE DEPENDENCY GRAPH

```
                    globals.rpgleinc (foundation)
                    ↗               ↖
        logger_serv.rpgle      validator_serv.rpgle
                ↖                   ↗
                  ↖               ↙
                      cus_serv.rpgle
                            ↑
                    cus_repo.sqlrpgle
                            ↑
                        DB2 / i
```

---

## COMPLIANCE MATRIX

| Requirement | Current | After | Check |
|-------------|---------|-------|-------|
| Free-format RPG | ✓ | ✓ | ✓ |
| ctl-opt complete | ✗ | ✓ | ✓ |
| Centralized constants | ✗ | ✓ | ✓ |
| Parameterized SQL | ✓ | ✓ | ✓ |
| No SELECT * | ✓ | ✓ | ✓ |
| SQLSTATE handling | ✗ | ✓ | ✓ |
| Layer separation | ✓ | ✓ | ✓ |
| Modern BIFs | ~ | ✓ | ✓ |
| Error handling | ~ | ✓ | ✓ |
| Test coverage | ✗ | ✓ | ✓ |
| Documentation | ✗ | ✓ | ✓ |
| Deterministic output | ? | ✓ | ✓ |

---

## QUALITY METRICS

### Before Refactoring
```
Code Health:        🟠 MEDIUM
Architecture:       🟢 GOOD (layer separation exists)
Error Handling:     🔴 LOW (minimal)
Test Coverage:      🔴 NONE
Documentation:      🔴 MINIMAL
DB2 Optimization:   🟡 PARTIAL
SQL Safety:         🟢 GOOD (parameterized)
```

### After Refactoring
```
Code Health:        🟢 EXCELLENT
Architecture:       🟢 EXCELLENT (enforced via structure)
Error Handling:     🟢 COMPREHENSIVE
Test Coverage:      🟢 GOOD (for serv + repo)
Documentation:      🟢 COMPLETE
DB2 Optimization:   🟢 OPTIMIZED
SQL Safety:         🟢 GUARANTEED
```

---

## MODULES SUMMARY

| Module | Type | Purpose | LOC | Complexity |
|--------|------|---------|-----|-----------|
| **globals.rpgleinc** | Include | Constants & schema defs | 40 | LOW |
| **logger_serv** | Service | Centralized logging | 50 | LOW |
| **validator_serv** | Service | Data validation rules | 80 | LOW |
| **cus_main** | Main | Entry orchestration | 40 | LOW |
| **cus_serv** | Service | Business logic | 80 | MEDIUM |
| **cus_repo** | Repo | DB2 access | 120 | MEDIUM |
| **t_cusserv** | Test | Service tests | 80 | MEDIUM |
| **t_cusrepo** | Test | Repo tests | 100 | MEDIUM |

**Total**: ~590 LOC (well-organized, maintainable)

---

## KEY PRINCIPLES

### 1. DETERMINISM
```
Same Input → Always Same Output
├─ Naming consistent
├─ SQL patterns repeatable  
├─ Error codes standard
└─ Deterministic compilation (byte-for-byte identical on recompile)
```

### 2. REPRODUCIBILITY
```
New Dev Gets Same Result
├─ Clear layer separation
├─ Standard patterns
├─ Central constants
└─ Complete documentation
```

### 3. PRODUCTION-READY
```
Deploy with Confidence
├─ No legacy code
├─ Full error handling
├─ Complete test coverage
├─ Architecture validated
└─ Performance optimized
```

---

## SUCCESS CRITERIA

✅ All files compile with ZERO warnings  
✅ 100% architecture compliance  
✅ 100% parameterized SQL  
✅ 100% SQLSTATE coverage  
✅ Zero legacy opcodes  
✅ Deterministic byte-for-byte compilation  
✅ Test suite passes  
✅ Architecture documentation complete  
✅ Ready for production deployment  

---

## NEXT STEPS

| Step | Document | Action |
|------|----------|--------|
| 🔍 | REFACTORING_PLAN.md | Read full strategy |
| 📋 | FILE_STRUCTURE_TARGET.md | Understand module layout |
| 🚀 | EXECUTION_GUIDE.md | Follow step-by-step |
| ⚡ | QUICK_REFERENCE.md | Keep nearby while coding |

---

## RESOURCES

```
.skills/ibmi-rpg/
├── core.md                    (Priority rules)
├── service-architecture.md    (Layer patterns)
├── db2-for-i.md              (SQL optimization)
├── rpgle-rules.md            (Code standards)
├── coding-standards.md       (Naming/style)
├── error-handling.md         (Error patterns)
└── ai-enforcement.md         (AI behavior rules)

Root Directory:
├── AGENTS.md                 (IBM i compiler mode)
├── CLAUDE.md                 (Focus areas)
├── REFACTORING_PLAN.md       (This strategy)
├── EXECUTION_GUIDE.md        (Step-by-step)
├── FILE_STRUCTURE_TARGET.md  (Module details)
├── QUICK_REFERENCE.md        (Cheat sheet)
└── VISION.md                 (You are here)
```

---

## 📞 SUPPORT

**Questions during refactoring?**
1. Check QUICK_REFERENCE.md first (fastest)
2. Consult EXECUTION_GUIDE.md for step details
3. Read relevant .skills/ibmi-rpg/*.md file
4. Review AGENTS.md for mandatory rules

**Ready?** → Start with EXECUTION_GUIDE.md Step 1.1

---

**Version**: 1.0 | **Date**: May 18, 2026 | **Status**: READY TO EXECUTE

