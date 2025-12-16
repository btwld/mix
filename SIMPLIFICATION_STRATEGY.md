# mix_tailwinds Simplification Plan

## Background

A refactor occurred between commits `28667ab36` (Dec 11) and `f47b7fc26` (Dec 14) that introduced over-engineering. This plan captures lessons learned and provides a strategy for simplification.

### What Happened

| Metric | Before | After | Problem |
|--------|--------|-------|---------|
| Lines (lib/) | ~2,700 | ~4,400 | +63% bloat |
| Token type systems | 1 | 4 | Redundant cascade |
| Public exports | 3 | 7 | Over-exposed |
| Processing passes | 1 | 4 | Inefficient |

### What To Keep
- Test files (3→9) - valuable coverage
- Documentation (COMPARISON_TESTING.md, FUTURE_WORK.md)
- Clean module boundaries (7 files with clear SRP)
- `TransformAccum` / `BorderAccum` - legitimate accumulator pattern

---

## Part 1: Lessons Learned (Reference Document)

### Anti-Pattern 1: Multiple Representations of Same Data

**What happened:**
```dart
// Token represented 4 different ways:
String raw = "hover:p-4";                           // Form 1
ParsedToken parsed = extractToken(raw);             // Form 2
TwTokenParts parts = _parseTokenParts(raw, config); // Form 3
TwTokenKind kind = classifyToken(base, config);     // Form 4
```

**The fix:** TWO types max (parsing vs classification are legitimately separate concerns).
- `ParsedToken` - handles syntax (string → structure)
- `TokenKind` - handles semantics (structure → meaning)

**Verification question:** "Do these types change for different reasons?" If yes → keep separate. If no → merge.

---

### Anti-Pattern 2: Registry/Dispatch Patterns for Bounded Problems

**What happened:**
```dart
class TokenHandlerRegistry<S> {
  final Map<Type, TokenHandler<S, Object?>> _handlers = {};

  S apply(S styler, Object token, TwConfig config) {
    final handler = _handlers[token.runtimeType]; // Runtime lookup!
    return handler(styler, token, config);
  }
}
```

**The fix:** Direct pattern matching when you know all types at compile time.

```dart
// Replace 170 lines of registry with ~30 lines of pattern matching
FlexBoxStyler _applyToken(FlexBoxStyler s, TokenKind t, TwConfig c) {
  return switch (t) {
    SpacingToken(:final kind, :final value) => _applySpacing(s, kind, value),
    ColorToken(:final target, :final color) => _applyColor(s, target, color),
    // ... exhaustive, compiler-checked
  };
}
```

**Verification question:** "Will new types be added at runtime by users?" If no → direct calls.

---

### Anti-Pattern 3: Multi-Pass Processing

**What happened:**
```dart
// Pass 1: Group transforms (iterate all)
final transformGroups = groupTransformsByPrefix(parts, ...);
// Pass 2: Group borders (iterate all again)
final borderGroups = groupBordersByPrefix(parts, ...);
// Pass 3: Process remaining (iterate all, skip grouped)
for (final part in parts) {
  if (isTransformToken(base)) continue;
  if (isBorderToken(base)) continue;
  // process
}
// Pass 4: Apply grouped results
```

**The fix:** Single pass with inline accumulation.

```dart
final transforms = TransformAccum();
final borders = BorderAccum();
for (final part in parts) {
  if (isTransformToken(base)) { transforms.add(part); continue; }
  if (isBorderToken(base)) { borders.add(part); continue; }
  styler = _applyToken(styler, part);
}
styler = transforms.applyTo(styler);
styler = borders.applyTo(styler);
```

**Verification question:** "Am I iterating the same list multiple times?" If yes → merge passes.

---

### Anti-Pattern 4: Premature API Exposure

**What happened:**
```dart
// Exported "just in case" someone needs to extend:
export 'src/tw_tokens.dart';
export 'src/tw_classifier.dart' show classifyToken, AnimationTrigger;
export 'src/tw_transform.dart' show TransformAccum, BorderAccum;
export 'src/tw_responsive.dart' show TwFlexItemDecorator;
```

**The fix:** Private by default. Export only when a user asks for it.

**Verification question:** "Is there a GitHub issue or user request for this?" If no → keep private.

---

### Anti-Pattern 5: Storing Redundant Information

**What happened:**
```dart
return (
  prefixes: parsed.prefixes,    // List<String> - the raw prefixes
  modifiers: modifiers,         // List<PrefixModifier> - same info, typed!
);
```

**The fix:** Store one form. Derive the other when needed.

**Verification question:** "Can I delete this field and compute it?" If yes → delete it.

---

## Part 2: Simplification Strategy (3 Phases)

> **Key insight from review:** The original 5-phase plan was itself over-engineered.
> Phases 2-4 are interdependent and MUST be atomic. Collapsed to 3 phases.

### Revised Target Metrics

| Metric | Current | Target | Rationale |
|--------|---------|--------|-----------|
| Lines (lib/) | ~4,400 | ~3,200 | 27% reduction realistic |
| Source files | 8 | 7 | Each has legitimate SRP |
| Token types | 4 | 2 | Keep parsing/classification separation |
| Processing passes | 4 | 1 | Single pass with accumulators |
| Public exports | 7 | 4 | Core + debug (user-facing) |

### Phase Dependencies

```
Phase 1 (API) ──────────────── Independent, low risk
         │
         ▼
Phase 2 (Core Simplification) ─ ATOMIC (registry + types + single-pass)
         │                      Must be one commit
         ▼
Phase 3 (Cleanup) ───────────── Optional, YAGNI until needed
```

---

### Phase 1: Reduce Public API Surface

**Risk:** LOW | **Impact:** HIGH | **Duration:** 15 minutes

**Goal:** Export only what users need

**File:** [lib/mix_tailwinds.dart](packages/mix_tailwinds/lib/mix_tailwinds.dart)

**Changes:**
```dart
// KEEP (user-facing):
export 'src/tw_config.dart';
export 'src/tw_parser.dart';
export 'src/tw_widget.dart';
export 'src/tw_debug.dart';  // Debugging is user-facing

// REMOVE (internal):
// export 'src/tw_tokens.dart';
// export 'src/tw_classifier.dart';
// export 'src/tw_transform.dart';
// export 'src/tw_responsive.dart';
```

**LOC Impact:** -4 lines (exports only)

**Verification:**
```bash
cd packages/mix_tailwinds && flutter test  # All pass unchanged
```

**Commit:** `refactor(mix_tailwinds): reduce public API to core exports`

---

### Phase 2: Core Simplification (ATOMIC)

**Risk:** MEDIUM-HIGH | **Impact:** VERY HIGH | **Duration:** 3-4 hours

**Goal:** Remove registry pattern, consolidate token types, single-pass processing

> **CRITICAL:** Execute all sub-steps as ONE commit. Breaking mid-refactor creates unstable state.

**Files:**
- [lib/src/tw_parser.dart](packages/mix_tailwinds/lib/src/tw_parser.dart) - Main changes
- [lib/src/tw_classifier.dart](packages/mix_tailwinds/lib/src/tw_classifier.dart) - Simplify
- [lib/src/tw_tokens.dart](packages/mix_tailwinds/lib/src/tw_tokens.dart) - Remove redundancy
- [lib/src/tw_transform.dart](packages/mix_tailwinds/lib/src/tw_transform.dart) - Update accumulators

#### Sub-step 2a: Replace Registry with Pattern Matching

**Target:** Lines 14-33, 74-213 in tw_parser.dart (~170 lines → ~30 lines)

**Before:**
```dart
final TokenHandlerRegistry<FlexBoxStyler> _flexRegistry = _buildFlexRegistry();

TokenHandlerRegistry<FlexBoxStyler> _buildFlexRegistry() {
  final registry = TokenHandlerRegistry<FlexBoxStyler>();
  registry.register<AtomicToken>(...);
  registry.register<SpacingToken>(...);
  // ... 140 more lines
}

// Usage:
return _flexRegistry.apply(styler, classified, config);
```

**After:**
```dart
FlexBoxStyler _applyFlexToken(FlexBoxStyler s, TokenKind t, TwConfig c) {
  return switch (t) {
    AtomicToken(:final name) => _applyFlexAtomicToken(s, name),
    SpacingToken(:final kind, :final value) => _applySpacing(s, kind, value),
    ColorToken(target: ColorTarget.background, :final color) => s.color(color),
    RadiusToken(:final kind, :final radius) => _applyRadius(s, kind, radius),
    UnknownToken() => s,
    _ => s,
  };
}
```

**LOC Impact:** -140 lines

#### Sub-step 2b: Remove Redundant Token Fields

**Target:** tw_tokens.dart TwTokenParts typedef

**Before:**
```dart
typedef TwTokenParts = ({
  String raw,
  String base,
  List<String> prefixes,         // REDUNDANT
  List<PrefixModifier> modifiers, // Same info, typed
});
```

**After:**
```dart
typedef ParsedToken = ({
  String raw,
  String base,
  List<PrefixModifier> modifiers,
});
```

**LOC Impact:** -20 lines (field + all usages)

#### Sub-step 2c: Single-Pass Processing

**Target:** parseFlexFromParts, parseBoxFromParts in tw_parser.dart

**Before:**
```dart
final transformGroups = groupTransformsByPrefix(parts, ...);  // Pass 1
final borderGroups = groupBordersByPrefix(parts, ...);        // Pass 2
for (final part in parts) {                                   // Pass 3
  if (isTransformToken(base)) continue;
  if (isBorderToken(base)) continue;
  styler = _applyFlexToken(styler, part);
}
styler = applyBordersToFlex(styler, borderGroups, ...);       // Pass 4
styler = applyTransformsToFlex(styler, transformGroups, ...);
```

**After:**
```dart
final transforms = TransformAccum();
final borders = BorderAccum();
for (final part in parts) {                                   // Single pass
  if (isTransformToken(base)) { transforms.add(part); continue; }
  if (isBorderToken(base)) { borders.add(part); continue; }
  styler = _applyFlexToken(styler, part);
}
styler = borders.applyTo(styler);
styler = transforms.applyTo(styler);
```

**LOC Impact:** -150 lines (remove grouping functions)

#### Sub-step 2d: Simplify Token Type Cascade

**Keep:**
- `ParsedToken` (parsing concern) - string → structure
- `TokenKind` sealed class (classification concern) - structure → semantics

**Remove:**
- `TwTokenParts` intermediate type (merge into ParsedToken)
- Redundant `prefixes` field

**LOC Impact:** -100 lines

#### Phase 2 Summary

| Sub-step | Lines Removed | Risk |
|----------|---------------|------|
| 2a: Registry → Pattern Match | -140 | Medium |
| 2b: Remove Redundant Fields | -20 | Low |
| 2c: Single-Pass Processing | -150 | Medium |
| 2d: Simplify Token Types | -100 | Medium |
| **Total** | **-410 to -510** | Medium |

**Verification (after ALL sub-steps):**
```bash
flutter test                    # All tests pass
wc -l lib/src/*.dart | tail -1  # Confirm reduction
cd example && flutter run       # Visual check
```

**Commit:** `refactor(tw_parser): remove registry pattern, consolidate to single-pass`

---

### Phase 3: File Consolidation (OPTIONAL - YAGNI)

**Risk:** LOW | **Impact:** LOW | **Duration:** 30 minutes if needed

**Decision criteria:** Only execute if post-Phase-2 any file is:
- < 100 lines AND
- Imported by only one other file

**Current expectation:** All 7 files likely remain >100 lines with distinct responsibilities.

**If criteria met:**
```bash
# Measure after Phase 2
wc -l lib/src/*.dart
# If any file < 100 lines, consider merging
```

**Likely outcome:** SKIP (YAGNI)

---

## Part 3: Verification & Consistency

### Pre-Execution Checklist

```bash
# Baseline measurements
cd packages/mix_tailwinds
flutter test --coverage
wc -l lib/src/*.dart | tail -1  # Record: ~4,400
grep "^export" lib/mix_tailwinds.dart | wc -l  # Record: 7
```

### After Each Phase

```bash
# 1. Tests pass
flutter test

# 2. Example works
cd example && flutter run

# 3. Line count decreased
wc -l lib/src/*.dart | tail -1

# 4. Exports reduced
grep "^export" lib/mix_tailwinds.dart | wc -l
```

### Stop Conditions

**STOP and reassess if:**
- Tests fail and fix isn't obvious (< 5 minutes)
- LOC doesn't decrease after Phase 2
- Code becomes harder to understand
- New abstractions are being created to "fix" simplification

### Final Validation

| Metric | Before | After Phase 1 | After Phase 2 |
|--------|--------|---------------|---------------|
| Lines | ~4,400 | ~4,396 | ~3,200 |
| Exports | 7 | 4 | 4 |
| Token types | 4 | 4 | 2 |
| Passes | 4 | 4 | 1 |

---

## Part 4: Architectural Guidance

### What To KEEP (Good Abstractions)

✅ **TransformAccum / BorderAccum**
- Legitimate accumulator pattern
- Clear SRP (accumulate before applying)
- Well-tested

✅ **7-File Structure**
- Each file has distinct responsibility
- Changes independently
- Low coupling, high cohesion

✅ **TokenKind Sealed Class**
- Enables exhaustive pattern matching
- Compiler enforces handling all cases
- Clear semantic meaning

✅ **Separation of tw_classifier.dart**
- Classification logic (456 lines) is substantial
- Different change driver than parsing
- Can test independently

### What To REMOVE (Over-Engineering)

❌ **TokenHandlerRegistry**
- 170 lines for 6 compile-time-known types
- No runtime extension use case
- Replace with 30 lines of pattern matching

❌ **Multi-Pass Iteration**
- 4x iteration overhead
- Single pass achieves same result
- Accumulators handle grouping inline

❌ **Redundant Data Storage**
- `prefixes` AND `modifiers` in same record
- Store one, derive other if needed

❌ **Premature API Exports**
- No external usage
- Export when requested

---

## Part 5: When To Break These Rules

These rules can be broken when:

1. **Performance requires it** - Measured, not assumed
2. **User explicitly requests API** - With GitHub issue
3. **Tests require exposure** - Mark with `@visibleForTesting`
4. **Framework convention demands it** - Match Flutter/Dart idioms

Document the exception:
```dart
// EXCEPTION: Multi-pass required because [reason]. See issue #123.
```

---

## Execution Checklist

- [ ] **Phase 1:** Reduce exports (lib/mix_tailwinds.dart)
  - [ ] Comment out internal exports
  - [ ] Run tests
  - [ ] Commit

- [ ] **Phase 2:** Core simplification (ATOMIC)
  - [ ] 2a: Replace registry with pattern matching
  - [ ] 2b: Remove redundant token fields
  - [ ] 2c: Convert to single-pass processing
  - [ ] 2d: Simplify token type cascade
  - [ ] Run ALL tests
  - [ ] Verify line count reduction
  - [ ] Commit (single commit for all sub-steps)

- [ ] **Phase 3:** File consolidation (if criteria met)
  - [ ] Measure file sizes
  - [ ] Apply <100 line rule
  - [ ] Likely: SKIP

---

## Reference Commits

- **Pre-refactor state:** `28667ab36` (Dec 11, 11:56) - Revert target
- **Refactor started:** `d7cbd43d1` (Dec 11, 12:14) - "Initial phase of improvements - 0"
- **Current state:** `f47b7fc26` (Dec 14, 16:07) - "consolidate package from 17 to 8 files"
