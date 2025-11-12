# Mix Framework - Issue Dependency Graph

**Visual representation of all 51 issues and their dependencies**

---

## Sprint Flow Diagram

```
┌─────────────────────────────────────────────────────────────────────────┐
│                           SPRINT 1 (Week 1-2)                            │
│                         CRITICAL BUG FIXES                               │
│                                                                          │
│  ┌──────┐  ┌──────┐  ┌──────┐  ┌──────┐  ┌──────┐  ┌──────┐  ┌──────┐ │
│  │  #1  │  │  #2  │  │  #3  │  │  #4  │  │  #5  │  │  #6  │  │ #17  │ │
│  │Debug │  │ Null │  │ Off- │  │Memory│  │Type  │  │Deep  │  │Div/0 │ │
│  │ File │  │ Ptr  │  │by-One│  │ Leak │  │Casts │  │Equal │  │Check │ │
│  └───┬──┘  └───┬──┘  └───┬──┘  └───┬──┘  └───┬──┘  └───┬──┘  └───┬──┘ │
│      │         │         │         │         │         │         │    │
│      └─────────┴─────────┴─────────┴─────────┴─────────┴─────────┘    │
│                              ↓                                          │
│                     All must complete                                   │
└─────────────────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────────────────┐
│                           SPRINT 2 (Week 3-4)                            │
│                     DEAD CODE & DOCUMENTATION                            │
│                                                                          │
│  ┌─────────────────────┐                ┌──────────────────────┐        │
│  │   DEAD CODE TRACK   │                │  DOCUMENTATION TRACK │        │
│  │                     │                │                      │        │
│  │  #11.1 ─ 5 tests    │                │  #7  ─ Doc errors    │        │
│  │  #11.2 ─ ColorProp  │                │  #13 ─ Comments (5x) │        │
│  │  #11.3 ─ Typedefs   │                │  #14 ─ Skipped test  │        │
│  │  #19   ─ Placeholders│                │  #20 ─ Examples      │        │
│  │                     │                │  #21 ─ Logging       │        │
│  └─────────────────────┘                └──────────────────────┘        │
│           ↓                                        ↓                    │
│           └────────────────────┬───────────────────┘                    │
│                                ↓                                        │
│                        Both must complete                               │
└─────────────────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────────────────┐
│                           SPRINT 3 (Week 5-6)                            │
│                    CONSISTENCY & STANDARDS                               │
│                                                                          │
│  ┌────────┐  ┌────────┐  ┌────────┐  ┌────────┐  ┌────────┐  ┌──────┐ │
│  │ #12.1  │  │ #12.2  │  │ #12.3  │  │ #12.4  │  │ #12.5  │  │ #32  │ │
│  │ final  │  │Utility │  │Widget  │  │Diagn-  │  │Imports │  │Naming│ │
│  │BoxSpec │  │Classes │  │Naming  │  │osticable│  │       │  │Docs  │ │
│  └────────┘  └────────┘  └────────┘  └────────┘  └────────┘  └──────┘ │
│      │           │           │           │           │           │     │
│      └───────────┴───────────┴───────────┴───────────┴───────────┘     │
│                              ↓                                          │
│                  All can be done in parallel                            │
└─────────────────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────────────────┐
│                           SPRINT 4 (Week 7-8)                            │
│                     ARCHITECTURE PREPARATION                             │
│                                                                          │
│                        ┌──────────┐                                     │
│                        │   #23    │                                     │
│                        │Separation│                                     │
│                        │ of       │                                     │
│                        │Concerns  │                                     │
│                        └────┬─────┘                                     │
│                             │                                           │
│                             ↓                                           │
│      ┌─────────────────────────────────────────┐                       │
│      │                                         │                       │
│  ┌───▼────┐  ┌────────┐  ┌────────┐  ┌────────▼──┐                    │
│  │   #8   │  │  #25   │  │  #27   │  │   #28-29  │                    │
│  │Migr-   │  │Abstract│  │ Enum   │  │Animation  │                    │
│  │ation   │  │ Levels │  │ Utils  │  │ Polish    │                    │
│  └────────┘  └────────┘  └────────┘  └───────────┘                    │
│                                                                          │
│  #23 must complete first, then others can be parallel                   │
└─────────────────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────────────────┐
│                          SPRINT 5 (Week 9-10)                            │
│                   MAJOR ARCHITECTURE REFACTORING                         │
│                         ⚠️  HIGHEST RISK  ⚠️                              │
│                                                                          │
│                        ┌──────────┐                                     │
│                        │   #22    │◄────── MUST DO FIRST                │
│                        │  Prop/   │                                     │
│                        │   Mix    │                                     │
│                        │Decoupling│                                     │
│                        └────┬─────┘                                     │
│                             │                                           │
│                             ↓                                           │
│                        ┌────▼─────┐                                     │
│                        │   #24    │◄────── DEPENDS ON #22               │
│                        │  Deep    │                                     │
│                        │ Nesting  │                                     │
│                        │ helpers  │                                     │
│                        └────┬─────┘                                     │
│                             │                                           │
│             ┌───────────────┴───────────────┐                           │
│             │                               │                           │
│             ↓                               ↓                           │
│        ┌────▼─────┐                    ┌────▼─────┐                     │
│        │   #10    │◄────┐              │ #30-31   │                     │
│        │   God    │     │              │  Polish  │                     │
│        │  Class   │     │              └──────────┘                     │
│        │Refactor  │     │                                               │
│        └──────────┘     │                                               │
│                         │                                               │
│                    Also depends                                         │
│                    on #23 from                                          │
│                    Sprint 4                                             │
│                                                                          │
│  ⚠️  SEQUENTIAL EXECUTION CRITICAL  ⚠️                                   │
└─────────────────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────────────────┐
│                          SPRINT 6 (Week 11-12)                           │
│                  CODE GENERATION & FINAL POLISH                          │
│                                                                          │
│  ┌────────────┐          ┌────────────┐          ┌────────────┐        │
│  │    #16     │          │     #9     │          │    #15     │        │
│  │   Border   │          │ Animation  │          │  Public    │        │
│  │   Code     │          │Config Gen  │          │   API      │        │
│  │    Gen     │          │            │          │   Docs     │        │
│  └─────┬──────┘          └────────────┘          └────────────┘        │
│        │                                                                │
│        ↓                                                                │
│  ┌─────▼──────┐                                                         │
│  │    #26     │◄────── DEPENDS ON #16                                   │
│  │   Border   │                                                         │
│  │  Coupling  │                                                         │
│  └────────────┘                                                         │
│                                                                          │
│        ┌────────────────────────────┐                                   │
│        │   #33-41: Low Priority     │                                   │
│        │   (Fill remaining time)    │                                   │
│        └────────────────────────────┘                                   │
└─────────────────────────────────────────────────────────────────────────┘
                              ↓
                     ┌────────────────┐
                     │  🎉 COMPLETE   │
                     │  v2.0.0 Ready  │
                     └────────────────┘
```

---

## Critical Path Analysis

### The Longest Dependency Chain (Critical Path)

```
Sprint 1: #2,#4,#5,#6,#17,#18 (Critical bugs)
    ↓
Sprint 2: Dead code cleanup
    ↓
Sprint 3: Consistency fixes
    ↓
Sprint 4: #23 (Separation of concerns)
    ↓
Sprint 5: #22 (Prop/Mix decoupling) ─→ CRITICAL PATH
    ↓
Sprint 5: #24 (helpers.dart refactor) ─→ CRITICAL PATH
    ↓
Sprint 5: #10 (God class refactor) ─→ CRITICAL PATH
    ↓
Sprint 6: Final polish
```

**Total Critical Path Duration:** 12 weeks

**Critical Path Issues:** #2, #4, #5, #6, #22, #24, #10

**Path Cannot Be Shortened Because:**
- Sprint 1 bugs must be fixed before major refactoring
- #22 requires stable foundation from Sprint 1-4
- #24 depends on #22 (uses refactored Prop/Mix)
- #10 depends on both #23 and #24

---

## Detailed Dependency Matrix

### Issue-by-Issue Dependencies

| Issue | Depends On | Blocks | Can Parallel With | Sprint |
|-------|-----------|---------|-------------------|--------|
| #1 | None | None | #2,#3,#4,#5,#6,#17,#18 | 1 |
| #2 | None | #9 (soft) | #1,#3,#4,#5,#6,#17,#18 | 1 |
| #3 | None | None | #1,#2,#4,#5,#6,#17,#18 | 1 |
| #4 | None | #9 (soft) | #1,#2,#3,#5,#6,#17,#18 | 1 |
| #5 | None | None | #1,#2,#3,#4,#6,#17,#18 | 1 |
| #6 | None | None | #1,#2,#3,#4,#5,#17,#18 | 1 |
| #17 | None | #9 (soft) | #1,#2,#3,#4,#5,#6,#18 | 1 |
| #18 | None | None | #1,#2,#3,#4,#5,#6,#17 | 1 |
| #7 | Sprint 1 | None | #11,#13,#14,#19-21 | 2 |
| #11.1-3 | Sprint 1 | None | #7,#13,#14,#19-21 | 2 |
| #13.x | Sprint 1 | None | #7,#11,#14,#19-21 | 2 |
| #14 | Sprint 1 | None | #7,#11,#13,#19-21 | 2 |
| #19 | Sprint 1 | None | #7,#11,#13,#14,#20-21 | 2 |
| #20 | Sprint 1 | None | #7,#11,#13,#14,#19,#21 | 2 |
| #21 | Sprint 1 | None | #7,#11,#13,#14,#19,#20 | 2 |
| #12.1-7 | Sprint 2 | None | All #12.x with each other | 3 |
| #32 | Sprint 2 | None | #12.x | 3 |
| #8 | Sprint 3 | Future work | #25,#27-29 | 4 |
| #23 | Sprint 3 | #10 | #8,#25,#27-29 | 4 |
| #25 | Sprint 3 | None | #8,#23,#27-29 | 4 |
| #27 | Sprint 3 | None | #8,#23,#25,#28-29 | 4 |
| #28-29 | Sprint 3 | None | #8,#23,#25,#27 | 4 |
| #22 | Sprint 4 | #24, #10 | #30-31 | 5 |
| #24 | #22 | #10 | #30-31 | 5 |
| #10 | #22, #23, #24 | None | #30-31 (after #24) | 5 |
| #30-31 | Sprint 4 | None | Can start early | 5 |
| #16 | Sprint 5 | #26 | #9, #15 | 6 |
| #26 | #16 | None | #9, #15 (after #16) | 6 |
| #9 | Sprint 5, #2,#4,#17 (soft) | None | #15, #16 | 6 |
| #15 | Sprint 5 | None | #9, #16 | 6 |
| #33-41 | Sprint 5 | None | Can fill gaps | 6 |

---

## Dependency Types Explained

### Hard Dependencies (MUST complete first)
- **#22 → #24:** helpers.dart uses refactored Prop/Mix system
- **#24 → #10:** God class depends on extracted helper functions
- **#23 → #10:** God class depends on separation patterns
- **#16 → #26:** Border coupling needs generated border classes

### Soft Dependencies (RECOMMENDED to complete first)
- **#2,#4,#17 → #9:** Fix animation bugs before generating animation code
- **Sprint 1 → Sprint 2:** Stable foundation before cleanup
- **Sprint 3 → Sprint 4:** Consistency before architecture changes

### Sprint Dependencies (Sequential)
- Sprint 1 must complete before Sprint 2 starts
- Sprint 2 must complete before Sprint 3 starts
- etc.

### No Dependencies (Can do anytime)
- #1, #3, #5, #6, #18: Isolated bug fixes
- #7, #13.x, #20, #21, #32: Documentation fixes
- #11, #19: Dead code removal
- #30-31: Minor improvements

---

## Parallel Work Opportunities

### Maximum Parallelization by Sprint

**Sprint 1: Up to 3 developers in parallel**
```
Dev 1: #1, #3, #17       (3 hours)
Dev 2: #2, #4            (7 hours)
Dev 3: #5, #6, #18       (11 hours)
```

**Sprint 2: Up to 3 developers in parallel**
```
Dev 1: #11.1, #11.2, #11.3, #21  (4.5 hours)
Dev 2: #19, #14                   (7 hours)
Dev 3: #7, #13.x, #20             (5 hours)
```

**Sprint 3: Up to 3+ developers in parallel**
```
Dev 1: #12.1, #12.2, #12.4, #12.7  (7.5 hours)
Dev 2: #12.3                        (8 hours)
Dev 3: #12.5, #12.6, #32            (9 hours)
Any: #12.x items can be split further
```

**Sprint 4: Initial sequential, then parallel**
```
Week 1:
  All Devs: #23 (must complete first)

Week 2 (after #23):
  Dev 1: #27
  Dev 2: #8, #28-29
  Dev 3: #25
```

**Sprint 5: STRICTLY SEQUENTIAL (highest risk)**
```
Week 1, Days 1-3:
  ALL DEVS: #22 (mob programming or paired)

Week 1, Days 4-5:
  Dev 2: #24
  Dev 3: #30-31 (can start early)

Week 2, Days 1-4:
  Dev 1: #10
  Dev 3: Continue #30-31

Week 2, Day 5:
  ALL DEVS: Integration testing
```

**Sprint 6: Up to 3 developers in parallel**
```
Week 1:
  Dev 1: #16
  Dev 2: #9
  Dev 3: #15

Week 2 (after #16):
  Dev 1: #26
  Dev 2: Continue #9 if needed
  Dev 3: Continue #15
  All: #33-41 to fill time
```

---

## Bottleneck Analysis

### Primary Bottlenecks

**1. Issue #22 (Prop/Mix Decoupling)**
- **Why:** Blocks #24 and #10 (15 total story points)
- **Duration:** 20 hours
- **Risk:** High complexity, touches core architecture
- **Mitigation:**
  - Allocate all developers for first 3 days
  - Use mob/pair programming
  - Can extend Sprint 5 to 3 weeks if needed

**2. Issue #10 (God Class Refactoring)**
- **Why:** Depends on #22, #23, #24
- **Duration:** 16 hours
- **Risk:** Large refactor, many usage sites
- **Mitigation:**
  - Can be split across Sprint 5 and 6 if needed
  - Incremental approach with feature flags
  - Parallel implementation (old and new coexist)

**3. Sprint 5 Overall**
- **Why:** Highest risk sprint, sequential dependencies
- **Duration:** 55 hours
- **Mitigation:**
  - Buffer week available (can extend to Week 11)
  - Can defer #30-31 to Sprint 6
  - Daily progress reviews

### Secondary Bottlenecks

**1. Issue #23 (Separation of Concerns)**
- **Why:** Blocks #10
- **Duration:** 8 hours
- **Impact:** Medium (only blocks one issue)

**2. Issue #16 (Border Code Gen)**
- **Why:** Blocks #26
- **Duration:** 12 hours
- **Impact:** Low (only blocks one issue, Sprint 6)

---

## Fast-Track Opportunities

### If Timeline Needs Compression

**Option 1: Overlap Sprint 5 and 6 (Save 1 week)**
```
Week 9-10: Do Sprint 5 as planned
Week 11: Start Sprint 6 code generation in parallel
  - #9 and #16 don't depend on Sprint 5
  - Can save 1 week
```

**Option 2: Defer Low Priority (Save 1 week)**
```
Move #33-41 (low priority) to post-v2.0.0
  - Still launch with 45/51 issues fixed
  - Save ~10 hours in Sprint 6
```

**Option 3: Parallel Sprints 2 and 3 (Save 2 weeks)**
```
If you have 6+ developers:
  - Team A: Sprint 2 (dead code)
  - Team B: Sprint 3 (consistency)
  - No dependencies between them
  - Could save 2 weeks
```

---

## Risk-Adjusted Timeline

### Best Case (All Goes Well)
- Sprint 1: 2 weeks
- Sprint 2: 2 weeks
- Sprint 3: 2 weeks
- Sprint 4: 2 weeks
- Sprint 5: 2 weeks
- Sprint 6: 2 weeks
**Total: 12 weeks**

### Expected Case (Minor Issues)
- Sprint 1: 2 weeks
- Sprint 2: 2 weeks
- Sprint 3: 2 weeks
- Sprint 4: 2 weeks
- Sprint 5: **3 weeks** (extended due to complexity)
- Sprint 6: 2 weeks
**Total: 13 weeks**

### Worst Case (Major Blockers)
- Sprint 1: 2.5 weeks (critical bugs harder than expected)
- Sprint 2: 2 weeks
- Sprint 3: 2 weeks
- Sprint 4: 2.5 weeks (migration complications)
- Sprint 5: **4 weeks** (architecture refactor requires iteration)
- Sprint 6: 2.5 weeks (code gen issues)
**Total: 15.5 weeks**

---

## Recommended Mitigation: Buffer Week Strategy

**Recommendation:** Plan for 13 weeks, communicate 15 weeks externally

**Buffer Allocation:**
- 1 buffer week after Sprint 4 (before high-risk Sprint 5)
- 1 buffer week after Sprint 5 (if needed)
- Use buffer only if truly needed
- If not used, early completion bonus!

---

## Dependency Graph Legend

```
┌────────┐
│ Issue  │  = Individual issue
└────────┘

    ↓      = Hard dependency (MUST complete first)
    ⇢      = Soft dependency (RECOMMENDED first)
    │      = Can be parallel
    ═      = Critical path
```

---

## Decision Points

### Sprint 3: Widget Naming Decision
**Decision Required:** Keep "Box" or rename to "StyledBox"?

**Options:**
1. **Keep Both:** Box and StyledBox as aliases (6 months deprecation)
2. **Rename All:** Migrate all to use "Styled" prefix
3. **Keep Different:** Box is different, Icon/Text use Styled

**Timeline Impact:**
- Option 1: +2 hours (create aliases)
- Option 2: +8 hours (migration effort)
- Option 3: +1 hour (document rationale)

**Recommendation:** Option 3 (document rationale) - least disruptive

---

### Sprint 5: Rollback Decision Point

**Day 5 of Week 1 (Sprint 5):** Critical checkpoint

**If #22 (Prop/Mix) is not 80% complete by end of Week 1:**
- **Option A:** Extend Sprint 5 to 3 weeks
- **Option B:** Defer #10 to Sprint 6
- **Option C:** Request additional resources (contractors)

**Pre-determined criteria:**
- Tests passing rate < 70% → Extend sprint
- Blockers not resolved → Request help
- Scope too large → Defer #10

---

*This dependency graph should be referenced during sprint planning and daily standups.*
