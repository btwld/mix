# mix_tailwinds Implementation Plan

**Status**: Phase 2 - P1 Fixes
**Last Updated**: 2025-11-03
**Related Document**: See `decisions.md` for full context and rationale

---

## Quick Reference

| Phase | Status | Items | Priority |
|-------|--------|-------|----------|
| Phase 1: POC | ✅ Complete | 6/6 | - |
| Phase 2: P1 Fixes | ✅ Complete | 5/5 | Critical |
| Phase 3: P2 Improvements | ⏳ Planned | 0/7 | High |
| Phase 4: P3 Enhancements | ⏳ Future | 0/5 | Low |

---

## Phase 1: Initial POC ✅ Complete

### Implementation Summary

#### 1. Configuration System ✅
**File**: `lib/src/tw_config.dart`

**Implemented**:
- `TwConfig` class with const constructor
- Cached singleton `TwConfig.standard()` returning const map data
- Helper methods: `spaceOf`, `radiusOf`, `borderWidthOf`, `breakpointOf`, `fontSizeOf`, `colorOf`

**Token Maps**:
```dart
static const TwConfig _standard = TwConfig(
  space: {
    '0': 0, 'px': 1, '0.5': 2, '1': 4, '1.5': 6, '2': 8, '2.5': 10,
    '3': 12, '3.5': 14, '4': 16, '5': 20, '6': 24, '8': 32, '10': 40,
    '12': 48, '16': 64, '20': 80, '24': 96, '32': 128, '40': 160,
    '48': 192, '56': 224, '64': 256,
  },
  radii: {
    'none': 0, '': 4, 'sm': 2, 'md': 6, 'lg': 8, 'xl': 12, '2xl': 16, 'full': 9999
  },
  borderWidths: {'': 1, '2': 2, '4': 4, '8': 8},
  breakpoints: {'sm': 640, 'md': 768, 'lg': 1024, 'xl': 1280},
  fontSizes: {
    'xs': 12, 'sm': 14, 'base': 16, 'lg': 18, 'xl': 20,
    '2xl': 24, '3xl': 30, '4xl': 36
  },
  colors: {
    'blue-50': Color(0xFFEFF6FF),
    'blue-100': Color(0xFFDBEAFE),
    'blue-500': Color(0xFF3B82F6),
    'blue-600': Color(0xFF2563EB),
    'blue-700': Color(0xFF1D4ED8),
    'gray-100': Color(0xFFF3F4F6),
    'gray-200': Color(0xFFE5E7EB),
    'gray-500': Color(0xFF6B7280),
    'gray-700': Color(0xFF374151),
    'red-500': Color(0xFFEF4444),
    'red-600': Color(0xFFDC2626),
    'black': Colors.black,
    'white': Colors.white,
    'transparent': Colors.transparent,
  },
);
```

---

#### 2. Parser System ✅
**File**: `lib/src/tw_parser_v2.dart`

**Implemented**:
- Token pipeline: tokenize → prefix handling → atomic mutators
- Prefix recursion supporting chained modifiers (`md:hover:bg-blue-500`)
- Public APIs: `parseFlex`, `parseBox`, `parseText`, `setTokens`, `wantsFlex`

**Prefix Support**:
- Pseudo-states: `hover:`, `focus:`, `active:`, `pressed:`, `disabled:`, `enabled:`
- Theme modes: `dark:`, `light:`
- Breakpoints: `sm:`, `md:`, `lg:`, `xl:`

**Atomic Token Coverage**:
- Layout: `flex`, `flex-row`, `flex-col`, `items-*`, `justify-*`
- Spacing: `gap-*`, `p-*`, `px-*`, `py-*`, `pt-*`, `pr-*`, `pb-*`, `pl-*`, `m-*`, `mx-*`, etc.
- Sizing: `w-*`, `h-*`, `full`, `screen`
- Decoration: `bg-*`, `border`, `border-*`, `rounded`, `rounded-*`, `shadow`, `shadow-md`, `shadow-lg`
- Typography: `text-*` (color/size), `font-*` (weight), `uppercase`, `lowercase`, `capitalize`

---

#### 3. Widget Layer ✅
**File**: `lib/src/tw_widget.dart`

**Implemented**:
- `Div` widget: bridges class strings to `FlexBox` or `Box`
- `Span` widget: bridges class strings to `StyledText`
- Optional `isFlex` override on `Div`
- Optional `onUnsupported` callback for diagnostics

**Current Behavior**:
```dart
// Div chooses widget type based on tokens
final tokens = parser.setTokens(classNames);
final useFlex = isFlex ?? parser.wantsFlex(tokens);

if (useFlex) {
  return FlexBox(style: parsedStyle, children: children);
} else {
  return Box(style: parsedStyle, child: child ?? Row(children: children));
}
```

---

#### 4. Test Coverage ✅
**File**: `test/div_and_span_test.dart`

**Tests**:
- ✅ `Div` picks `FlexBox` when `flex` token present
- ✅ `Div` defaults to `Box` when flex tokens absent
- ✅ `Span` forwards text style tokens
- ✅ `flex-*` item tokens trigger unsupported callback

---

#### 5. Package Structure ✅
**Files**: `pubspec.yaml`, `lib/mix_tailwinds.dart`

**Structure**:
```yaml
name: mix_tailwinds
version: 0.1.0-dev.0
publish_to: "none"
dependencies:
  flutter: sdk
  mix: ^2.0.0-dev.5
```

```dart
library mix_tailwinds;

export 'src/tw_config.dart';
export 'src/tw_parser_v2.dart';
export 'src/tw_widget.dart';
```

---

## Phase 2: P1 Fixes ✅ Complete

**Goal**: Fix critical semantic issues and Flutter constraint violations before production use.

**Status**: 5/5 items complete

---

### P1.1: Fix Prefixed Flex Detection ✅ Complete

**File**: `lib/src/tw_parser_v2.dart`

**Problem**: `wantsFlex()` only checks root-level tokens. Misses `sm:flex`, `md:flex-row`.

**Current Code** (lines 26-30):
```dart
bool wantsFlex(Set<String> tokens) {
  return tokens.contains('flex') ||
      tokens.contains('flex-row') ||
      tokens.contains('flex-col');
}
```

**New Code**:
```dart
bool wantsFlex(Set<String> tokens) {
  for (final t in tokens) {
    final base = t.substring(t.lastIndexOf(':') + 1);
    if (base == 'flex' || base == 'flex-row' || base == 'flex-col') {
      return true;
    }
  }
  return false;
}
```

**Testing**:
```dart
test('wantsFlex detects prefixed flex tokens', () {
  final parser = TwParserV2();

  expect(parser.wantsFlex({'sm:flex'}), true);
  expect(parser.wantsFlex({'md:flex-row'}), true);
  expect(parser.wantsFlex({'lg:flex-col'}), true);
  expect(parser.wantsFlex({'md:hover:flex'}), true);
  expect(parser.wantsFlex({'bg-blue-500'}), false);
});
```

**Checklist**:
- [x] Update `wantsFlex()` method
- [x] Add unit tests for prefixed flex detection
- [x] Add widget test: `testWidgets('Div picks FlexBox for md:flex')`
- [x] Verify existing tests still pass

---

### P1.2: Change Non-Flex Layout to Column ✅ Complete

**File**: `lib/src/tw_widget.dart`

**Problem**: `Div` wraps multiple children in `Row` (horizontal). Should use `Column` (vertical) to match block-flow semantics.

**Current Code** (line 40-42):
```dart
final style = parser.parseBox(classNames);
return Box(
  style: style,
  child: child ?? (children.isNotEmpty ? Row(children: children) : null),
);
```

**New Code**:
```dart
final style = parser.parseBox(classNames);
Widget? resolvedChild = child ??
    (children.isNotEmpty ? Column(children: children) : null);

return Box(style: style, child: resolvedChild);
```

**Testing**:
```dart
testWidgets('Div wraps multiple children in Column', (tester) async {
  await tester.pumpWidget(
    Directionality(
      textDirection: TextDirection.ltr,
      child: Div(
        classNames: 'p-4',
        children: [
          const Text('First'),
          const Text('Second'),
        ],
      ),
    ),
  );

  expect(find.byType(Column), findsOneWidget);
  expect(find.byType(Row), findsNothing);
});
```

**Checklist**:
- [x] Replace `Row` with `Column` in non-flex path
- [x] Add widget test verifying Column usage
- [x] Update documentation if needed
- [x] Verify existing tests still pass

---

### P1.3: Restore Const Constructors ✅ Complete

**Files**: `lib/src/tw_widget.dart` (both `Div` and `Span`)

**Problem**: Non-const constructors due to initializer defaulting `config`.

**Current Code** (Div, lines 8-16):
```dart
Div({
  super.key,
  required this.classNames,
  this.child,
  this.children = const [],
  this.isFlex,
  TwConfig? config,
  this.onUnsupported,
}) : config = config ?? TwConfig.standard();

final TwConfig config;
```

**New Code**:
```dart
const Div({
  super.key,
  required this.classNames,
  this.child,
  this.children = const [],
  this.isFlex,
  this.onUnsupported,
  this.config,
});

final TwConfig? config;

@override
Widget build(BuildContext context) {
  final cfg = config ?? TwConfig.standard();
  final parser = TwParserV2(config: cfg, onUnsupported: onUnsupported);
  // ... rest of build method
}
```

**Apply Same Pattern to `Span`** (lines 39-44):
```dart
const Span({
  super.key,
  required this.text,
  required this.classNames,
  this.config,
});

final TwConfig? config;

@override
Widget build(BuildContext context) {
  final cfg = config ?? TwConfig.standard();
  final style = TwParserV2(config: cfg).parseText(classNames);
  return StyledText(text, style: style);
}
```

**Testing**:
```dart
test('Div constructor is const', () {
  // Should compile without error
  const div = Div(classNames: 'flex');
  expect(div, isNotNull);
});

test('Span constructor is const', () {
  // Should compile without error
  const span = Span(text: 'Hello', classNames: 'text-blue-500');
  expect(span, isNotNull);
});
```

**Checklist**:
- [x] Make `Div` config field nullable
- [x] Move defaulting to `Div.build()`
- [x] Add `const` to `Div` constructor
- [x] Make `Span` config field nullable
- [x] Move defaulting to `Span.build()`
- [x] Add `const` to `Span` constructor
- [x] Add compile-time tests for const constructors
- [x] Verify existing tests still pass

---

### P1.4: Add w-full/h-full Constraint Guards ✅ Complete

**File**: `lib/src/tw_widget.dart`

**Problem**: `w-full` → `double.infinity` crashes in unbounded parents (`Row`, `ListView`).

**New Helper Function**:
```dart
Widget _constrainIfNeeded(Widget child, Set<String> tokens) {
  return LayoutBuilder(builder: (context, constraints) {
    var w = child;

    // Check for w-full (with or without prefixes)
    if (tokens.any((t) => t.endsWith(':w-full') || t == 'w-full')) {
      final tightW = constraints.hasBoundedWidth &&
                     constraints.maxWidth.isFinite;
      if (tightW) {
        w = SizedBox(width: constraints.maxWidth, child: w);
      }
    }

    // Check for h-full (with or without prefixes)
    if (tokens.any((t) => t.endsWith(':h-full') || t == 'h-full')) {
      final tightH = constraints.hasBoundedHeight &&
                     constraints.maxHeight.isFinite;
      if (tightH) {
        w = SizedBox(height: constraints.maxHeight, child: w);
      }
    }

    return w;
  });
}
```

**Integration in `Div.build()`**:
```dart
@override
Widget build(BuildContext context) {
  final cfg = config ?? TwConfig.standard();
  final parser = TwParserV2(config: cfg, onUnsupported: onUnsupported);
  final tokens = parser.setTokens(classNames);
  final shouldUseFlex = isFlex ?? parser.wantsFlex(tokens);

  if (shouldUseFlex) {
    final flexStyle = parser.parseFlex(classNames);
    final flexChildren = children.isNotEmpty
        ? children
        : (child != null ? <Widget>[child!] : const <Widget>[]);
    return FlexBox(style: flexStyle, children: flexChildren);
  }

  final boxStyle = parser.parseBox(classNames);
  Widget? resolvedChild =
      child ?? (children.isNotEmpty ? Column(children: children) : null);

  // Apply constraint guards
  if (resolvedChild != null) {
    resolvedChild = _constrainIfNeeded(resolvedChild, tokens);
  }

  return Box(style: boxStyle, child: resolvedChild);
}
```

**Testing**:
```dart
testWidgets('w-full does not crash inside Row', (tester) async {
  await tester.pumpWidget(
    MaterialApp(
      home: Row(
        children: [
          Div(
            classNames: 'w-full bg-blue-500',
            child: const Text('Should not crash'),
          ),
        ],
      ),
    ),
  );

  expect(tester.takeException(), isNull);
  expect(find.text('Should not crash'), findsOneWidget);
});

testWidgets('h-full does not crash inside Column', (tester) async {
  await tester.pumpWidget(
    MaterialApp(
      home: Column(
        children: [
          Div(
            classNames: 'h-full bg-blue-500',
            child: const Text('Should not crash'),
          ),
        ],
      ),
    ),
  );

  expect(tester.takeException(), isNull);
  expect(find.text('Should not crash'), findsOneWidget);
});

testWidgets('md:w-full is also guarded', (tester) async {
  await tester.pumpWidget(
    MaterialApp(
      home: Row(
        children: [
          Div(
            classNames: 'md:w-full',
            child: const Text('Prefixed w-full'),
          ),
        ],
      ),
    ),
  );

  expect(tester.takeException(), isNull);
});
```

**Checklist**:
- [ ] Add `_constrainIfNeeded` helper function
- [ ] Integrate constraint guards in `Div.build()`
- [ ] Add test: `w-full` in `Row` doesn't crash
- [ ] Add test: `h-full` in `Column` doesn't crash
- [ ] Add test: Prefixed `w-full` is also guarded
- [ ] Verify existing tests still pass

---

### P1.5: Expand Unknown-Token Diagnostics ✅ Complete

**File**: `lib/src/tw_parser_v2.dart`

**Problem**: Only `flex-*` warns. Typos like `bg-blu-500` or unimplemented `z-10` are silently ignored.

**Pattern for Each `_apply*Atomic` Method**:
```dart
FlexBoxStyler _applyFlexAtomic(FlexBoxStyler styler, String token) {
  var handled = false;

  // Direction
  if (token == 'flex' || token == 'flex-row') {
    handled = true;
    return styler.row();
  }
  if (token == 'flex-col') {
    handled = true;
    return styler.column();
  }

  // Alignment
  if (token == 'items-start') {
    handled = true;
    return styler.crossAxisAlignment(CrossAxisAlignment.start);
  }
  // ... (set handled = true for each branch)

  // Warn about unknown tokens
  if (!handled && token.isNotEmpty) {
    onUnsupported?.call(token);
  }

  return styler;
}
```

**Apply to**:
1. `_applyFlexAtomic` (line 168)
2. `_applyBoxAtomic` (line 311)
3. `_applyTextAtomic` (line 435)

**Testing**:
```dart
test('Unknown tokens trigger onUnsupported callback', () {
  final seen = <String>[];
  final parser = TwParserV2(onUnsupported: seen.add);

  parser.parseBox('w-4 unknown-token bg-blue-500');

  expect(seen, contains('unknown-token'));
  expect(seen, isNot(contains('w-4')));  // Known token, not reported
  expect(seen, isNot(contains('bg-blue-500')));  // Known token
});

test('Typos are reported', () {
  final seen = <String>[];
  final parser = TwParserV2(onUnsupported: seen.add);

  parser.parseBox('bg-blu-500');  // Typo: blu instead of blue

  expect(seen, contains('bg-blu-500'));
});

test('Unimplemented tokens are reported', () {
  final seen = <String>[];
  final parser = TwParserV2(onUnsupported: seen.add);

  parser.parseBox('z-10 opacity-50');  // z-index and opacity not implemented

  expect(seen, containsAll(['z-10', 'opacity-50']));
});
```

**Checklist**:
- [x] Add `handled` tracking to `_applyFlexAtomic`
- [x] Set `handled = true` in all branches of `_applyFlexAtomic`
- [x] Add warning for unhandled tokens in `_applyFlexAtomic`
- [x] Add `handled` tracking to `_applyBoxAtomic`
- [x] Set `handled = true` in all branches of `_applyBoxAtomic`
- [x] Add warning for unhandled tokens in `_applyBoxAtomic`
- [x] Add `handled` tracking to `_applyTextAtomic`
- [x] Set `handled = true` in all branches of `_applyTextAtomic`
- [x] Add warning for unhandled tokens in `_applyTextAtomic`
- [x] Add unit tests for unknown token warnings
- [x] Verify existing tests still pass

---

## Phase 3: P2 Improvements ⏳ Planned

**Goal**: Enhance token coverage and developer experience.

**Status**: 0/7 items complete

### P2.1: Responsive Display Semantics

**Status**: Deferred - Document limitation instead

**Action**: Add documentation explaining that responsive display changes require consistent widget types.

---

### P2.2: Fractional Sizes (w-1/2, w-2/3, h-1/4)

**Status**: Approved for P2

**Implementation**: Add `_tryFraction` helper and wrap with `FractionallySizedBox`.

**Files**: `lib/src/tw_widget.dart`

---

### P2.3: Token Table Instead of If-Chains

**Status**: Approved for P2

**Implementation**: Refactor atomic handlers to use regex-based token specs.

**Files**: `lib/src/tw_parser_v2.dart`

---

### P2.4: Enhanced Test Coverage

**Status**: Required with P1 fixes

**Missing Tests**:
- Prefixed flex detection
- Column fallback
- Prefix chains (`md:hover:bg-blue-500`)
- Token precedence
- Constraint guards
- Unknown token warnings

---

### P2.5: Directional Borders and Radii

**Status**: Approved for P2

**Tokens**: `border-t`, `border-b`, `border-x`, `border-y`, `rounded-t-md`, `rounded-bl-lg`

**Files**: `lib/src/tw_parser_v2.dart`

---

### P2.6: Enhanced Shadow Scale

**Status**: Approved for P2

**Tokens**: `shadow-sm`, `shadow-xl`, `shadow-2xl`

**Files**: `lib/src/tw_parser_v2.dart`, `lib/src/tw_config.dart`

---

### P2.7: Gap Variants (gap-x, gap-y)

**Status**: Approved for P2

**Tokens**: `gap-x-*`, `gap-y-*`

**Files**: `lib/src/tw_parser_v2.dart`

---

## Phase 4: P3 Enhancements ⏳ Future

**Goal**: Advanced features and optimizations.

**Status**: 0/5 items complete

### P3.1: Config Extensibility
### P3.2: Arbitrary Values
### P3.3: Performance Optimization
### P3.4: Expand Spacing Map
### P3.5: Negative Margins

---

## Implementation Workflow

### For Each P1 Fix

1. **Create Feature Branch**
   ```bash
   git checkout -b fix/p1-[issue-name]
   ```

2. **Implement Fix**
   - Update source files
   - Add/update tests
   - Run tests: `flutter test`

3. **Verify**
   - All existing tests pass
   - New tests pass
   - No regressions

4. **Commit**
   ```bash
   git add .
   git commit -m "fix: [descriptive message]"
   ```

5. **Repeat** for next fix

6. **Final Integration**
   - Run full test suite
   - Update `code_context.local.md` if needed
   - Update this plan with ✅ checkmarks

---

## Progress Tracking

### Phase 2 Checklist

- [x] P1.1: Fix prefixed flex detection (4/4 tasks)
- [x] P1.2: Change Row → Column (4/4 tasks)
- [x] P1.3: Restore const constructors (8/8 tasks)
- [x] P1.4: Add constraint guards (6/6 tasks)
- [x] P1.5: Expand diagnostics (10/10 tasks)

**Total**: 32/32 P1 tasks complete

---

## Testing Strategy

### Unit Tests
- Parser logic (tokenization, prefix handling, atomic handlers)
- Configuration helpers
- Token detection (`wantsFlex`, diagnostics)

### Widget Tests
- Widget type selection (`FlexBox` vs `Box`)
- Layout behavior (Column fallback)
- Constraint guards (no crashes)
- Styling application

### Integration Tests (Future)
- Real-world UI examples
- Performance benchmarks
- Theme switching

---

## Definition of Done

### For P1 Phase
- [ ] All 5 P1 fixes implemented
- [ ] All existing tests pass
- [ ] New tests added and passing
- [ ] No breaking API changes
- [ ] Documentation updated
- [ ] decisions.md updated with results
- [ ] code_context.local.md updated

### For P2 Phase
- [ ] All 7 P2 improvements implemented
- [ ] Comprehensive test coverage
- [ ] README with usage examples
- [ ] Known limitations documented

---

## References

- **Decisions Document**: `decisions.md` - Full context, rationale, and decisions
- **Code Context**: `code_context.local.md` - Complete code extraction
- **Review Source**: Comprehensive review (2025-11-03)
- **Mix 2.0 Docs**: https://fluttermix.com
- **Tailwind CSS Docs**: https://tailwindcss.com
