# Mix Framework - Issue Tracking Spreadsheet

**Use this document to track progress on all 51 audit issues**

---

## Sprint 1: Critical Bug Fixes (Week 1-2)

### P0 Issues

| # | Issue | File | Est | Assignee | Status | PR | Notes |
|---|-------|------|-----|----------|--------|----|----|
| 1 | Debug file writing | mix_generator.dart:270 | 1h | - | ⬜ TODO | - | Remove /tmp debug file |
| 2 | Null pointer in animation | widget_modifier_config.dart:720 | 3h | - | ⬜ TODO | - | Add null checks |
| 3 | Off-by-one error | mix_error.dart:10 | 1h | - | ⬜ TODO | - | Handle single type case |
| 4 | Memory leak animation | style_animation_driver.dart:257 | 4h | - | ⬜ TODO | - | Store & remove listener |
| 5 | Unsafe type casts (5×) | prop.dart, token_refs.dart | 6h | - | ⬜ TODO | - | Add type validation |
| 6 | Type error equality | deep_collection_equality.dart:69 | 3h | - | ⬜ TODO | - | Check type before cast |
| 17 | Division by zero | animation_config.dart:1016 | 1h | - | ⬜ TODO | - | Add duration check |
| 18 | Unsafe list access | deep_collection_equality.dart:34 | 2h | - | ⬜ TODO | - | Handle all iterables |

**Sprint 1 Progress: 0/8 complete (0%)**

**Status Legend:**
- ⬜ TODO
- 🟦 IN PROGRESS
- 🟨 IN REVIEW
- ✅ DONE
- ❌ BLOCKED

---

## Sprint 2: Dead Code & Documentation (Week 3-4)

### Dead Code Removal

| # | Issue | File | Est | Assignee | Status | PR | Notes |
|---|-------|------|-----|----------|--------|----|----|
| 11.1a | Dead test file 1 | spec_mixin_builder_test.dart | 0.5h | - | ⬜ TODO | - | 467 lines commented |
| 11.1b | Dead test file 2 | spec_attribute_builder_test.dart | 0.5h | - | ⬜ TODO | - | 203 lines commented |
| 11.1c | Dead test file 3 | spec_tween_builder_test.dart | 0.5h | - | ⬜ TODO | - | 252 lines commented |
| 11.1d | Dead test file 4 | type_registry_test.dart | 0.5h | - | ⬜ TODO | - | 286 lines commented |
| 11.1e | Dead test file 5 | dart_type_utils_test.dart | 0.5h | - | ⬜ TODO | - | 503 lines commented |
| 11.2 | Dead ColorProp class | color_mix.dart | 1h | - | ⬜ TODO | - | 203 lines commented |
| 11.3 | Unused typedefs | style_provider.dart:43,50 | 0.5h | - | ⬜ TODO | - | 2 typedefs |
| 19a | Placeholder test 1 | mixable_utility_generator_test.dart | 1h | - | ⬜ TODO | - | Dummy test |
| 19b | Placeholder test 2 | utility_metadata_test.dart | 1h | - | ⬜ TODO | - | Dummy test |
| 19c | Placeholder test 3 | utility_code_generator_test.dart | 1h | - | ⬜ TODO | - | Dummy test |
| 19d | Placeholder test 4 | utility_code_helpers_test.dart | 1h | - | ⬜ TODO | - | Dummy test |

### Documentation Fixes

| # | Issue | File | Est | Assignee | Status | PR | Notes |
|---|-------|------|-----|----------|--------|----|----|
| 7 | Wrong default value doc | helpers.dart:403 | 0.5h | - | ⬜ TODO | - | Fix doc comment |
| 13.1a | Wrong file path | edge_insets_geometry_util.dart:9 | 0.5h | - | ⬜ TODO | - | Correct path |
| 13.1b | Wrong file path | edge_insets_geometry_mix.dart:7 | 0.5h | - | ⬜ TODO | - | Correct path |
| 13.2 | JavaDoc style | scalar_util.dart:521 | 0.5h | - | ⬜ TODO | - | Use Dart style |
| 13.3 | Lowercase @deprecated | color_util.dart:115 | 0.5h | - | ⬜ TODO | - | Use annotation |
| 13.4 | Misleading comment | variant_util.dart:283 | 0.5h | - | ⬜ TODO | - | Clarify or remove |
| 13.5 | Wrong null comment | helper_util.dart:26 | 0.5h | - | ⬜ TODO | - | Correct description |
| 14 | Skipped test | style_builder_test.dart:103 | 2h | - | ⬜ TODO | - | Review & fix |
| 20a | Commented example 1 | simple_box.dart:28 | 0.5h | - | ⬜ TODO | - | Update example |
| 20b | Commented example 2 | utility_example.dart:109 | 0.5h | - | ⬜ TODO | - | Update example |
| 21 | Excessive logging | add_label.yml:34 | 1h | - | ⬜ TODO | - | 13 console.logs |

**Sprint 2 Progress: 0/22 complete (0%)**

---

## Sprint 3: Consistency & Standards (Week 5-6)

### Code Inconsistencies

| # | Issue | File | Est | Assignee | Status | PR | Notes |
|---|-------|------|-----|----------|--------|----|----|
| 12.1 | Missing `final` on BoxSpec | box_spec.dart:13 | 0.5h | - | ⬜ TODO | - | Add final keyword |
| 12.2a | Utility class - OnContext | on_context_variant_util.dart | 0.5h | - | ⬜ TODO | - | Add final |
| 12.2b | Utility class - Padding | padding_modifier_util.dart | 0.5h | - | ⬜ TODO | - | Add final |
| 12.2c | Utility class - Animation | animation_config_util.dart | 0.5h | - | ⬜ TODO | - | Add final |
| 12.2d | Utility class - Material | material_color_util.dart | 0.5h | - | ⬜ TODO | - | Add final |
| 12.2e | Utility class - Box | box_modifier_util.dart | 0.5h | - | ⬜ TODO | - | Add final |
| 12.2f | Utility classes (5+ more) | Various files | 1h | - | ⬜ TODO | - | Batch update |
| 12.3 | Widget naming | Box vs Styled* | 8h | - | ⬜ TODO | - | DECISION REQUIRED |
| 12.4a | Missing Diagnosticable | Various ModifierMix classes | 1h | - | ⬜ TODO | - | Add mixin |
| 12.4b | Missing Diagnosticable | Additional classes | 1h | - | ⬜ TODO | - | Add mixin |
| 12.5 | Import standardization | Multiple files | 4h | - | ⬜ TODO | - | Use widgets.dart |
| 12.6 | Error handling docs | CONTRIBUTING.md | 3h | - | ⬜ TODO | - | Document standards |
| 12.7 | @immutable annotation | All Spec classes | 2h | - | ⬜ TODO | - | Add consistently |
| 32 | Naming convention docs | CONTRIBUTING.md | 2h | - | ⬜ TODO | - | Document $ prefix |

**Sprint 3 Progress: 0/14 complete (0%)**

---

## Sprint 4: Architecture Preparation (Week 7-8)

### Architecture Foundation

| # | Issue | File | Est | Assignee | Status | PR | Notes |
|---|-------|------|-----|----------|--------|----|----|
| 23 | Separation of concerns | widget_modifier_config.dart:321 | 8h | - | ⬜ TODO | - | Extract strategy classes |
| 8 | Complete migration | mix_generator.dart:4 | 12h | - | ⬜ TODO | - | Update dependent files |
| 25 | Abstraction levels | directive.dart | 10h | - | ⬜ TODO | - | Split by concern |
| 27 | Enum utility duplication | enum_util.dart | 6h | - | ⬜ TODO | - | 614 lines |
| 28 | Magic numbers | animation code | 3h | - | ⬜ TODO | - | Extract constants |
| 29 | Null check animation | animation builder | 2h | - | ⬜ TODO | - | Add validation |

**Sprint 4 Progress: 0/6 complete (0%)**

**Dependencies:** #23 must complete before #8, #25, #27-29 can start

---

## Sprint 5: Major Architecture Refactoring (Week 9-10)

### High-Risk Architecture Changes

| # | Issue | File | Est | Assignee | Status | PR | Notes |
|---|-------|------|-----|----------|--------|----|----|
| 22 | Prop/Mix decoupling | prop.dart, Mix system | 20h | ALL | ⬜ TODO | - | ⚠️ CRITICAL - ALL DEVS |
| 24 | helpers.dart refactor | helpers.dart:192 | 12h | - | ⬜ TODO | - | Depends on #22 |
| 10 | God class refactor | widget_modifier_config.dart | 16h | - | ⬜ TODO | - | Depends on #22, #23, #24 |
| 30 | Custom equality | Use collection package | 4h | - | ⬜ TODO | - | Can parallel |
| 31 | Deprecation docs | Various | 3h | - | ⬜ TODO | - | Can parallel |

**Sprint 5 Progress: 0/5 complete (0%)**

**CRITICAL:** Must follow sequence: #22 → #24 → #10

---

## Sprint 6: Code Generation & Polish (Week 11-12)

### Code Generation

| # | Issue | File | Est | Assignee | Status | PR | Notes |
|---|-------|------|-----|----------|--------|----|----|
| 16 | Border code generation | shape_border_mix.dart | 12h | - | ⬜ TODO | - | 824 lines, 8 classes |
| 26 | Border coupling | border_mix.dart | 8h | - | ⬜ TODO | - | Depends on #16 |
| 9 | Animation duplication | animation_config.dart | 14h | - | ⬜ TODO | - | 1067 lines, 47+ factories |
| 15 | Public API docs | Enable lint rule | 16h | - | ⬜ TODO | - | Document all public APIs |

### Low Priority Polish

| # | Issue | Description | Est | Assignee | Status | PR | Notes |
|---|-------|-------------|-----|----------|--------|----|----|
| 33 | Naming conventions | Inconsistent $ prefix | 2h | - | ⬜ TODO | - | Document in guide |
| 34 | Verbose docs | Acceptable verbosity | 1h | - | ⬜ TODO | - | Review if needed |
| 35 | Generic test names | Standard convention | 1h | - | ⬜ TODO | - | Optional improvement |
| 36 | Dummy text in examples | Appropriate | 0.5h | - | ⬜ TODO | - | Skip or improve |
| 37 | Mock classes | Properly placed | 0.5h | - | ⬜ TODO | - | Review location |
| 38 | Conceptual examples | Intentional | 0.5h | - | ⬜ TODO | - | Keep as is |
| 39 | UnimplementedError | Intentional | 0.5h | - | ⬜ TODO | - | Document rationale |
| 40-41 | Additional polish | Various minor items | 4h | - | ⬜ TODO | - | Fill spare time |

**Sprint 6 Progress: 0/12 complete (0%)**

---

## Overall Progress Summary

### By Priority

| Priority | Total | Complete | In Progress | Remaining | % Done |
|----------|-------|----------|-------------|-----------|---------|
| P0 (Critical) | 10 | 0 | 0 | 10 | 0% |
| P1 (High) | 28 | 0 | 0 | 28 | 0% |
| P2 (Medium) | 5 | 0 | 0 | 5 | 0% |
| P3 (Low) | 8 | 0 | 0 | 8 | 0% |
| **TOTAL** | **51** | **0** | **0** | **51** | **0%** |

### By Sprint

| Sprint | Issues | Complete | % Done | Status |
|--------|--------|----------|--------|--------|
| Sprint 1 | 8 | 0 | 0% | ⬜ NOT STARTED |
| Sprint 2 | 22 | 0 | 0% | ⬜ NOT STARTED |
| Sprint 3 | 14 | 0 | 0% | ⬜ NOT STARTED |
| Sprint 4 | 6 | 0 | 0% | ⬜ NOT STARTED |
| Sprint 5 | 5 | 0 | 0% | ⬜ NOT STARTED |
| Sprint 6 | 12 | 0 | 0% | ⬜ NOT STARTED |
| **TOTAL** | **51** | **0** | **0%** | |

### By Category

| Category | Issues | Complete | % Done |
|----------|--------|----------|--------|
| Crash Bugs | 8 | 0 | 0% |
| Memory Leaks | 1 | 0 | 0% |
| Dead Code | 12 | 0 | 0% |
| Documentation | 10 | 0 | 0% |
| Consistency | 14 | 0 | 0% |
| Architecture | 5 | 0 | 0% |
| Code Generation | 3 | 0 | 0% |
| Polish | 8 | 0 | 0% |

---

## Detailed Progress Tracking

### How to Use This Tracker

1. **Update status daily:**
   - Change ⬜ TODO to 🟦 IN PROGRESS when starting
   - Change 🟦 IN PROGRESS to 🟨 IN REVIEW when PR created
   - Change 🟨 IN REVIEW to ✅ DONE when merged
   - Use ❌ BLOCKED if stuck

2. **Fill in details:**
   - Assignee: Developer name
   - PR: Link to pull request
   - Notes: Any important context

3. **Track time:**
   - Est: Estimated hours
   - Actual: Actual hours spent (add new column)

4. **Update summaries:**
   - Recalculate percentages weekly
   - Update sprint progress bars

---

## Burn-Down Chart Data

### Sprint 1

| Day | Remaining | Completed | Total | Velocity |
|-----|-----------|-----------|-------|----------|
| Day 0 | 21h | 0h | 21h | - |
| Day 1 | 21h | 0h | 21h | 0h/day |
| Day 2 | 21h | 0h | 21h | 0h/day |
| Day 3 | 21h | 0h | 21h | 0h/day |
| Day 4 | 21h | 0h | 21h | 0h/day |
| Day 5 | 21h | 0h | 21h | 0h/day |
| Day 6 | 21h | 0h | 21h | 0h/day |
| Day 7 | 21h | 0h | 21h | 0h/day |
| Day 8 | 21h | 0h | 21h | 0h/day |
| Day 9 | 21h | 0h | 21h | 0h/day |
| Day 10 | 0h | 21h | 21h | 2.1h/day |

**Target: 21h over 10 days = 2.1h/day per developer**

### Sprint 2

| Day | Remaining | Completed | Total | Velocity |
|-----|-----------|-----------|-------|----------|
| Day 0 | 16.5h | 0h | 16.5h | - |
| ... | | | | |

---

## Risk Register

### Active Risks

| Risk | Probability | Impact | Status | Mitigation | Owner |
|------|------------|---------|--------|------------|-------|
| Sprint 5 overruns | High | High | ⚠️ | Buffer week, can extend | - |
| Breaking changes | Medium | High | ⚠️ | Deprecation period | - |
| External dependencies | Low | Medium | ✅ | Contacted maintainers | - |
| Team availability | Medium | Medium | ⚠️ | Cross-training | - |
| Performance regression | Medium | High | ⚠️ | Benchmark continuously | - |

### Resolved Risks

| Risk | Resolution | Date |
|------|------------|------|
| - | - | - |

---

## Blockers

### Current Blockers

| Issue # | Blocker | Blocked By | Since | Owner | Resolution ETA |
|---------|---------|------------|-------|-------|----------------|
| - | - | - | - | - | - |

### Resolved Blockers

| Issue # | Blocker | Resolution | Date Resolved |
|---------|---------|------------|---------------|
| - | - | - | - |

---

## Pull Requests

### Open PRs

| PR # | Title | Issue | Author | Reviewers | Status | Age |
|------|-------|-------|--------|-----------|--------|-----|
| - | - | - | - | - | - | - |

### Merged PRs

| PR # | Title | Issue | Author | Merged | Lines Changed |
|------|-------|-------|--------|--------|---------------|
| - | - | - | - | - | - |

---

## Milestones

### Completed Milestones

| Milestone | Date | Issues | Notes |
|-----------|------|--------|-------|
| - | - | - | - |

### Upcoming Milestones

| Milestone | Target Date | Issues | Status |
|-----------|-------------|--------|--------|
| Sprint 1 Complete | Week 2 | #1-6, #17-18 | ⬜ |
| Sprint 2 Complete | Week 4 | #7, #11, #13-14, #19-21 | ⬜ |
| Sprint 3 Complete | Week 6 | #12, #32 | ⬜ |
| Sprint 4 Complete | Week 8 | #8, #23, #25, #27-29 | ⬜ |
| Sprint 5 Complete | Week 10 | #10, #22, #24, #30-31 | ⬜ |
| Sprint 6 Complete | Week 12 | #9, #15-16, #26, #33-41 | ⬜ |
| v2.0.0 Release | Week 13 | All 51 issues | ⬜ |

---

## Team Velocity

### By Sprint

| Sprint | Planned (h) | Actual (h) | Variance | Efficiency |
|--------|------------|-----------|----------|------------|
| Sprint 1 | 21h | 0h | - | - |
| Sprint 2 | 16.5h | 0h | - | - |
| Sprint 3 | 28.5h | 0h | - | - |
| Sprint 4 | 41h | 0h | - | - |
| Sprint 5 | 55h | 0h | - | - |
| Sprint 6 | 68h | 0h | - | - |
| **Total** | **230h** | **0h** | **-** | **-** |

### By Developer

| Developer | Sprint 1 | Sprint 2 | Sprint 3 | Sprint 4 | Sprint 5 | Sprint 6 | Total |
|-----------|----------|----------|----------|----------|----------|----------|-------|
| Dev 1 | 0h | 0h | 0h | 0h | 0h | 0h | 0h |
| Dev 2 | 0h | 0h | 0h | 0h | 0h | 0h | 0h |
| Dev 3 | 0h | 0h | 0h | 0h | 0h | 0h | 0h |
| **Total** | **0h** | **0h** | **0h** | **0h** | **0h** | **0h** | **0h** |

---

## Quality Metrics

### Test Coverage

| Sprint | Before | After | Change | Goal |
|--------|--------|-------|--------|------|
| Sprint 1 | - | - | - | 95% |
| Sprint 2 | - | - | - | 95% |
| Sprint 3 | - | - | - | 95% |
| Sprint 4 | - | - | - | 95% |
| Sprint 5 | - | - | - | 95% |
| Sprint 6 | - | - | - | 95% |

### Code Quality

| Metric | Before | Current | Goal | Status |
|--------|--------|---------|------|--------|
| Lines of Code | ~50K | - | ~46K (-4K) | ⬜ |
| Code Duplication | ~3K lines | - | <500 lines | ⬜ |
| Cyclomatic Complexity | High | - | <10 per method | ⬜ |
| Circular Dependencies | 15 | - | 0 | ⬜ |
| Analyzer Warnings | ? | - | 0 | ⬜ |
| Dead Code | 1,700+ lines | - | 0 | ⬜ |

### Performance

| Metric | Before | Current | Goal | Status |
|--------|--------|---------|------|--------|
| Build Time | - | - | ≤ baseline | ⬜ |
| Test Suite Time | - | - | ≤ baseline | ⬜ |
| Example App Startup | - | - | ≤ baseline | ⬜ |
| Memory Usage | - | - | ≤ baseline | ⬜ |

---

## Sprint Retrospectives

### Sprint 1

**What Went Well:**
- (To be filled after sprint)

**What Could Improve:**
- (To be filled after sprint)

**Action Items:**
- (To be filled after sprint)

### Sprint 2

**What Went Well:**
- (To be filled after sprint)

**What Could Improve:**
- (To be filled after sprint)

**Action Items:**
- (To be filled after sprint)

### Sprint 3-6

(To be filled after each sprint)

---

## External Dependencies

### Waiting On

| Dependency | Needed For | Status | ETA | Owner |
|------------|------------|--------|-----|-------|
| - | - | - | - | - |

### External Reviews

| Review Type | For | Reviewer | Status | Completed |
|-------------|-----|----------|--------|-----------|
| - | - | - | - | - |

---

## Notes and Decisions

### Sprint 1

- (Add notes and decisions here)

### Sprint 2

- (Add notes and decisions here)

### Sprint 3

- **DECISION REQUIRED:** Widget naming (Box vs StyledBox)
  - Date Needed: Before Sprint 3 starts
  - Options: Keep both, rename all, keep different
  - Decision: (TBD)

### Sprint 4-6

(Add notes and decisions as they arise)

---

## Quick Commands

### Update Progress

```bash
# Mark issue as in progress
# Change: | 1 | Debug file | ... | - | ⬜ TODO |
# To:     | 1 | Debug file | ... | Dev1 | 🟦 IN PROGRESS |

# Mark issue as complete
# Change: | 1 | Debug file | ... | Dev1 | 🟦 IN PROGRESS |
# To:     | 1 | Debug file | ... | Dev1 | ✅ DONE | #123 |
```

### Generate Summary

```bash
# Count completed issues
grep "✅ DONE" MIX_ISSUE_TRACKER.md | wc -l

# Count in-progress issues
grep "🟦 IN PROGRESS" MIX_ISSUE_TRACKER.md | wc -l

# List blockers
grep "❌ BLOCKED" MIX_ISSUE_TRACKER.md
```

---

**Last Updated:** 2025-11-12
**Next Update:** Daily during sprints

---

*Copy this template and update it as you progress through the sprints!*
