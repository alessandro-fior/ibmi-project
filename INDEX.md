# 📖 INDICE - IBM i Repository Refactoring Suite

**Repository Optimization**: Customer Module + Core Architecture  
**Status**: ✅ **READY TO EXECUTE**  
**Date**: May 18, 2026  

---

## 🎯 START HERE

### If you have 2 minutes
→ Read [VISION.md](VISION.md) - Get the big picture

### If you have 15 minutes  
→ Read [VISION.md](VISION.md) + [QUICK_REFERENCE.md](QUICK_REFERENCE.md) - Understand scope + key rules

### If you have 1 hour
→ Read [VISION.md](VISION.md) + [REFACTORING_PLAN.md](REFACTORING_PLAN.md) - Full strategic understanding

### Ready to execute?
→ Follow [EXECUTION_GUIDE.md](EXECUTION_GUIDE.md) step-by-step - Implement Phase 1 through Phase 5

---

## 📚 DOCUMENT GUIDE

### 1. **VISION.md** ← **START HERE**
**What**: High-level overview  
**Why**: Understand the goal and architecture  
**Read Time**: 5 min  
**For**: Everyone  
```
Contains:
  • Current state → Target state transformation
  • 5-phase roadmap (visual)
  • Architecture diagram
  • Quality metrics
  • Success criteria
```

### 2. **REFACTORING_PLAN.md** ← **STRATEGY**
**What**: Detailed 5-phase implementation plan  
**Why**: Comprehensive understanding of approach  
**Read Time**: 15 min  
**For**: Project leads, architects  
```
Contains:
  • Detailed analysis of current violations
  • 5 phases with milestones
  • Dependency graph
  • Compilation commands
  • Success metrics
```

### 3. **EXECUTION_GUIDE.md** ← **EXECUTE THIS**
**What**: Step-by-step implementation instructions  
**Why**: Actually build the refactored code  
**Read Time**: Variable (follow along)  
**For**: Developers implementing the refactoring  
```
Contains:
  • Phase 1.1 → Phase 5.2 detailed steps
  • Exact file paths and commands
  • Compilation instructions
  • Checkpoints and validation
  • Common pitfalls & fixes
```

### 4. **FILE_STRUCTURE_TARGET.md** ← **REFERENCE**
**What**: Target file layout and content patterns  
**Why**: See code templates and structure  
**Read Time**: 10 min  
**For**: Developers, code reviewers  
```
Contains:
  • Directory tree post-refactoring
  • New file content templates
  • Compilation order
  • Size estimates
  • Quality gates
```

### 5. **QUICK_REFERENCE.md** ← **BOOKMARK IT**
**What**: Developer cheat sheet  
**Why**: Fast lookup during coding  
**Read Time**: On-demand lookup  
**For**: Developers writing/reviewing code  
```
Contains:
  • Golden rules (right vs wrong)
  • Compilation commands
  • Layer rules
  • Error handling templates
  • Common mistakes & fixes
  • Final deployment checklist
```

---

## 🗂️ DIRECTORY STRUCTURE

### New Documents (This Suite)
```
ibmi-project/
├── VISION.md                    ← Overview & roadmap
├── REFACTORING_PLAN.md          ← Strategy & phases
├── EXECUTION_GUIDE.md           ← Step-by-step tasks
├── FILE_STRUCTURE_TARGET.md     ← Module templates
├── QUICK_REFERENCE.md           ← Cheat sheet
├── INDEX.md                     ← You are here
│
└── (existing structure)
    ├── AGENTS.md
    ├── CLAUDE.md
    ├── .skills/ibmi-rpg/
    └── qrpglesrc/
        ├── cus_main.rpgle       ← Will be refactored
        ├── cus_serv.rpgle       ← Will be refactored
        ├── cus_repo.sqlrpgle    ← Will be refactored
        ├── customer_h.rpgleinc  ← (no change)
        │
        ├── globals.rpgleinc     ← NEW (Phase 1)
        ├── logger_serv.rpgle    ← NEW (Phase 1)
        ├── validator_serv.rpgle ← NEW (Phase 1)
        ├── t_cusserv.rpgle      ← NEW (Phase 4)
        └── t_cusrepo.rpgle      ← NEW (Phase 4)
```

---

## 🔄 READING SEQUENCE

**For Project Managers/Leads**:
```
1. VISION.md (5 min)
2. REFACTORING_PLAN.md (15 min)
3. QUICK_REFERENCE.md (5 min for key metrics)
```

**For Developers Starting Implementation**:
```
1. VISION.md (5 min)
2. QUICK_REFERENCE.md (10 min for rules)
3. EXECUTION_GUIDE.md (follow each step)
4. FILE_STRUCTURE_TARGET.md (reference as needed)
```

**For Code Reviewers**:
```
1. QUICK_REFERENCE.md (rules to check)
2. FILE_STRUCTURE_TARGET.md (expected structure)
3. REFACTORING_PLAN.md (architecture requirements)
```

**For QA/Testing**:
```
1. VISION.md (understand changes)
2. REFACTORING_PLAN.md (test requirements)
3. FILE_STRUCTURE_TARGET.md (test module locations)
4. QUICK_REFERENCE.md (validation checklist)
```

---

## 🎯 QUICK FACTS

| Metric | Value |
|--------|-------|
| **Total Phases** | 5 |
| **Estimated Time** | 3.5 hours |
| **New Files Created** | 3 (globals, logger, validator) |
| **Existing Files Refactored** | 3 (main, serv, repo) |
| **Test Files Added** | 2 |
| **Documentation Files** | 5 (this suite) |
| **Total New LOC** | ~550 |
| **Total Refactored LOC** | ~240 |
| **Compilation Commands** | ~10 |
| **Architecture Layers** | 3 (main → serv → repo) |
| **Compliance Score** | 8/10 → 10/10 |

---

## ✅ PHASE OVERVIEW

### Phase 1: Foundation (30 min)
- Create globals.rpgleinc
- Create logger_serv.rpgle
- Create validator_serv.rpgle

### Phase 2: Architecture Refactoring (1h)
- Refactor cus_main.rpgle
- Refactor cus_serv.rpgle
- Refactor cus_repo.sqlrpgle

### Phase 3: Error Handling (30 min)
- Create ErrorResponse_t structure
- Add monitor/on-error everywhere
- Add SQLSTATE handling

### Phase 4: Testing (1h)
- Create t_cusserv.rpgle test suite
- Create t_cusrepo.rpgle test suite
- Validate compilation

### Phase 5: Documentation (30 min)
- Update inline comments
- Create architecture README
- Prepare deployment checklist

---

## 🚀 HOW TO GET STARTED

### Option A: Guided Path (Recommended)
```
1. Open VISION.md (5 min overview)
2. Open EXECUTION_GUIDE.md 
3. Follow Step 1.1 → Step 5.2
4. Keep QUICK_REFERENCE.md open nearby
```

### Option B: Deep Dive Path
```
1. Read REFACTORING_PLAN.md (full strategy)
2. Read FILE_STRUCTURE_TARGET.md (technical details)
3. Review QUICK_REFERENCE.md (rules)
4. Execute EXECUTION_GUIDE.md
```

### Option C: Executive Summary Path
```
1. Read VISION.md (overview)
2. Check QUICK_REFERENCE.md for metrics
3. Review compliance matrix in REFACTORING_PLAN.md
4. Approve and delegate to developers
```

---

## 📋 COMPLIANCE CHECKLIST

Before starting, verify you have:

- [ ] Read AGENTS.md (IBM i compiler mode)
- [ ] Read CLAUDE.md (refactoring focus)
- [ ] Read .skills/ibmi-rpg/core.md (mandatory rules)
- [ ] Read .skills/ibmi-rpg/service-architecture.md (layers)
- [ ] Read .skills/ibmi-rpg/db2-for-i.md (SQL rules)
- [ ] Read .skills/ibmi-rpg/rpgle-rules.md (code standards)
- [ ] Access to IBM i system (for compilation)
- [ ] MYLIB library created
- [ ] QRPGLESRC source file available

---

## 🆘 TROUBLESHOOTING

**What if I'm confused about the architecture?**
→ Look at VISION.md, Architecture Diagram section

**What if I don't know the exact RPG syntax?**
→ Check QUICK_REFERENCE.md, Golden Rules table

**What if compilation fails?**
→ Review EXECUTION_GUIDE.md, Checkpoint section for your phase

**What if I'm not sure what a file should contain?**
→ See FILE_STRUCTURE_TARGET.md for content templates

**What if I need to verify compliance?**
→ Use QUICK_REFERENCE.md, FILE CHECKLIST section

---

## 📞 KEY RESOURCES

### Stored in Repository
- `.skills/ibmi-rpg/core.md` - Core rules
- `.skills/ibmi-rpg/service-architecture.md` - Layer patterns
- `.skills/ibmi-rpg/db2-for-i.md` - SQL optimization
- `.skills/ibmi-rpg/rpgle-rules.md` - RPG standards
- `.skills/ibmi-rpg/coding-standards.md` - Naming conventions
- AGENTS.md - IBM i mode
- CLAUDE.md - Refactoring focus

### In This Suite
- QUICK_REFERENCE.md - Fast lookup (bookmark this!)
- EXECUTION_GUIDE.md - How to implement
- FILE_STRUCTURE_TARGET.md - Technical specs
- REFACTORING_PLAN.md - Strategy docs
- VISION.md - Big picture

---

## 🎓 LEARNING PATH

### Beginner
```
1. VISION.md (understand what we're doing)
2. QUICK_REFERENCE.md (learn the rules)
3. EXECUTION_GUIDE.md Step 1 (try Phase 1)
```

### Intermediate
```
1. REFACTORING_PLAN.md (understand the strategy)
2. FILE_STRUCTURE_TARGET.md (see the design)
3. EXECUTION_GUIDE.md (execute full phases)
```

### Advanced
```
1. Review .skills/ibmi-rpg/* (deep standards)
2. REFACTORING_PLAN.md Phase analysis
3. Mentor others through EXECUTION_GUIDE.md
```

---

## ✨ NEXT STEP

### Ready? 
👉 **Open [VISION.md](VISION.md) - 5 minute overview**

### Then?
👉 **Follow [EXECUTION_GUIDE.md](EXECUTION_GUIDE.md) - Step 1.1**

### Keep Handy?
👉 **Bookmark [QUICK_REFERENCE.md](QUICK_REFERENCE.md) - Developer cheat sheet**

---

## 📝 DOCUMENT STATUS

| Document | Status | Last Updated |
|----------|--------|--------------|
| VISION.md | ✅ Complete | May 18, 2026 |
| REFACTORING_PLAN.md | ✅ Complete | May 18, 2026 |
| EXECUTION_GUIDE.md | ✅ Complete | May 18, 2026 |
| FILE_STRUCTURE_TARGET.md | ✅ Complete | May 18, 2026 |
| QUICK_REFERENCE.md | ✅ Complete | May 18, 2026 |
| INDEX.md | ✅ Complete | May 18, 2026 |

---

## 🏁 SUCCESS CHECKLIST

After completing all phases:

- [ ] All 3 new foundation modules created and compiled
- [ ] All 3 existing modules refactored and compiled
- [ ] All tests pass (t_cusserv, t_cusrepo)
- [ ] Zero compilation warnings
- [ ] Architecture validated
- [ ] Documentation complete
- [ ] Ready for production deployment

---

**Welcome to the IBM i Refactoring Suite! 🚀**  
**Start with [VISION.md](VISION.md)**

