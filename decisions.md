# mix_tailwinds Decisions & Context

## Status: Review Complete - Implementation Phase

**Last Updated**: 2025-11-03
**Package Version**: 0.1.0-dev.0
**Review Status**: ✅ POC validated, P1 fixes identified

---

## Workspace Snapshot

- **Repo root**: `/Users/leofarias/Forks/mix/.conductor/kathmandu`
- **Active branch**: `plan-review-package`
- **SDK constraints**: Dart `>=3.9.0 <4.0.0`, Flutter `>=3.35.0`
- **Melos**: Workspace already configured via `melos.yaml`; new package requires `melos bootstrap` to wire local path overrides.

---

## Goal

Validate a Tailwind-inspired utility layer for Mix 2.0 by implementing a standalone package that converts Tailwind-like class strings into concrete Mix stylers and widgets.

**Success Criteria**:
- ✅ Core parser translates Tailwind classes to Mix stylers
- ✅ Widget layer (`Div`, `Span`) bridges class strings to Mix components
- ✅ Prefix support for breakpoints, pseudo-states, and theme modes
- ⚠️ P1 fixes needed for production readiness
- 🔄 P2/P3 improvements for broader Tailwind parity

---

## Package Overview

- **Location**: `packages/mix_tailwinds`
- **Pubspec**: `mix_tailwinds`, version `0.1.0-dev.0`, non-publish (`publish_to: none`), depends on `mix: ^2.0.0-dev.5`
- **Exports**: `mix_tailwinds.dart` re-exports config, parser, and widget APIs under a lightweight library

---

## Core Components

### 1. Configuration (`lib/src/tw_config.dart`)

**Status**: ✅ Implemented, ⚠️ Needs expansion

- Defines `TwConfig`, a Tailwind token map for spacing, radii, borders, breakpoints, font sizes, and colors
- Provides cached singleton `TwConfig.standard()` returning const map data
- Helper lookups: `spaceOf`, `radiusOf`, `borderWidthOf`, `breakpointOf`, `fontSizeOf`, `colorOf`

**Implemented Token Maps**:
- **Spacing**: 0, px, 0.5–64 (subset of Tailwind scale)
- **Radii**: none, sm, md, lg, xl, 2xl, full
- **Borders**: default (1px), 2, 4, 8
- **Breakpoints**: sm (640), md (768), lg (1024), xl (1280)
- **Font Sizes**: xs–4xl
- **Colors**: Blue, gray, red scales (minimal set)

**P3 Enhancement**: Expand spacing to include 7, 9, 11, 14, 28, 36, 72, 80, 96 for broader Tailwind compatibility.

---

### 2. Parser (`lib/src/tw_parser_v2.dart`)

**Status**: ✅ Core implemented, ⚠️ P1 fixes required

#### Architecture
- Token pipeline: tokenize → apply prefix handling (breakpoints, pseudo states) → atomic mutators
- Prefix recursion supports chaining (e.g., `md:hover:bg-blue-500`)

#### Public APIs
- `parseFlex(String)` → `FlexBoxStyler`
- `parseBox(String)` → `BoxStyler`
- `parseText(String)` → `TextStyler`
- `setTokens(String)` / `wantsFlex(Set<String>)` for detection and overrides

#### Prefix Support
- **Pseudo-states**: `hover:`, `focus:`, `active:`, `pressed:`, `disabled:`, `enabled:`
- **Theme modes**: `dark:`, `light:`
- **Breakpoints**: `sm:`, `md:`, `lg:`, `xl:`

#### Atomic Coverage Implemented
- **Layout**: `flex`, `flex-row`, `flex-col`, `items-*`, `justify-*`
- **Spacing**: `gap-*`, padding (`p-*`, `px-*`, `py-*`, `pt-*`, etc.), margin (`m-*`, `mx-*`, etc.)
- **Sizing**: `w-*`, `h-*`, `full`, `screen` (maps to `double.infinity`)
- **Decoration**: `bg-*`, `border`, `border-*`, `rounded`, `rounded-*`, `shadow`, `shadow-md`, `shadow-lg`
- **Typography**: `text-*` (color/size), `font-*` (weight), `uppercase`, `lowercase`, `capitalize`

#### Known Limitations
- **Unsupported tokens**: `flex-*` item-level utilities trigger optional `Warn` callback
- **Size fallback**: Tokens without config entries resolve to `0`
- **⚠️ P1 Issue**: `wantsFlex()` doesn't detect prefixed flex tokens (e.g., `sm:flex`)
- **⚠️ P1 Issue**: Unknown tokens (except `flex-*`) are silently ignored

---

### 3. Widgets (`lib/src/tw_widget.dart`)

**Status**: ✅ Core implemented, ⚠️ P1 fixes required

#### `Div` Widget
- Stateless widget bridging class strings to Mix widgets
- Optional `isFlex` override; falls back to `parser.wantsFlex` to choose between `FlexBox` and `Box`
- **⚠️ P1 Issue**: Non-flex layouts wrap multiple children in `Row` (should be `Column` for block-flow semantics)
- **⚠️ P1 Issue**: Constructors are non-const due to initializer defaulting
- **⚠️ P1 Issue**: No constraint guards for `w-full`/`h-full` (can crash in tight parents)
- Accepts optional `onUnsupported` passthrough

#### `Span` Widget
- Stateless text widget calling `parser.parseText` and rendering `StyledText`
- **⚠️ P1 Issue**: Non-const constructor

---

### 4. Tests (`test/div_and_span_test.dart`)

**Status**: ✅ Basic coverage, 🔄 P1 tests needed

#### Current Test Coverage
- ✅ `Div` selects `FlexBox` when `flex` token present
- ✅ `Div` defaults to `Box` when flex tokens absent
- ✅ `Span` reflects text color/weight tokens
- ✅ `TwParserV2` records unsupported `flex-*` tokens via callback

#### Missing Test Coverage (P1)
- ❌ Prefixed flex detection (`md:flex` should trigger FlexBox)
- ❌ Column fallback for multiple children
- ❌ Constraint guards for `w-full` in tight parents
- ❌ Unknown token warnings
- ❌ Prefix chains (`md:hover:bg-blue-500`)
- ❌ Token precedence (`px-4 p-2` should yield x=16, y=8)

---

## Review Findings

### Overall Assessment
**Verdict**: Solid POC. Parser and widget boundary need surgical P1 fixes to match Tailwind semantics and avoid Flutter constraint traps.

---

## Priority 1 Fixes (Required for Production)

### P1.1: Fix Flex Detection Across Prefixes

**Problem**: `wantsFlex()` only detects root-level `flex` tokens. Misses `sm:flex`, `md:flex-row`, etc.

**Impact**: Critical. Responsive flex layouts won't work.

**Solution**:
```dart
// In TwParserV2
bool wantsFlex(Set<String> tokens) {
  for (final t in tokens) {
    final base = t.substring(t.lastIndexOf(':') + 1);
    if (base == 'flex' || base == 'flex-row' || base == 'flex-col') return true;
  }
  return false;
}
```

**Rationale**: Tailwind allows display to change at breakpoints. Current architecture cannot switch widget type responsively, so default to FlexBox if any breakpoint requests flex.

**Files**: `lib/src/tw_parser_v2.dart:26-30`

**Decision**: ✅ **Approved** - Implement this fix

---

### P1.2: Change Default Non-Flex Layout to Column

**Problem**: `Div` wraps multiple children in `Row`. Diverges from Tailwind's block-flow default.

**Impact**: High. Unexpected horizontal layout surprises developers.

**Solution**:
```dart
// In Div.build()
- final resolvedChild =
-     child ?? (children.isNotEmpty ? Row(children: children) : null);
+ final resolvedChild =
+     child ?? (children.isNotEmpty ? Column(children: children) : null);
```

**Files**: `lib/src/tw_widget.dart:40`

**Decision**: ✅ **Approved** - Column matches HTML block flow

**Alternative Considered**: Configurable via static property. **Rejected** - Adds complexity without clear use case. Can revisit if users request it.

---

### P1.3: Restore Const Constructors

**Problem**: `config = config ?? TwConfig.standard()` in initializer forces non-const constructors.

**Impact**: Medium. Breaks Flutter const optimization and developer expectations.

**Solution**: Defer defaulting to `build()` and keep config field nullable:
```dart
class Div extends StatelessWidget {
  const Div({
    super.key,
    required this.classNames,
    this.child,
    this.children = const [],
    this.isFlex,
    this.onUnsupported,
    this.config,  // Now nullable
  });

  final TwConfig? config;  // Nullable field

  @override
  Widget build(BuildContext context) {
    final cfg = config ?? TwConfig.standard();  // Default here
    final parser = TwParserV2(config: cfg, onUnsupported: onUnsupported);
    ...
  }
}
```

**Files**: `lib/src/tw_widget.dart` (`Div` and `Span`)

**Decision**: ✅ **Approved** - Restore const for Flutter optimization

---

### P1.4: Add Constraint Guards for w-full / h-full

**Problem**: `w-full` → `double.infinity` crashes inside `Row`, `ListView`, or any unbounded parent.

**Impact**: Critical. Runtime crashes in common layouts.

**Solution**: Wrap resolved widget with `LayoutBuilder` to detect tight constraints:
```dart
Widget _constrainIfNeeded(Widget child, Set<String> tokens) {
  return LayoutBuilder(builder: (context, constraints) {
    var w = child;
    if (tokens.any((t) => t.endsWith(':w-full') || t == 'w-full')) {
      final tightW = constraints.hasBoundedWidth && constraints.maxWidth.isFinite;
      if (tightW) w = SizedBox(width: constraints.maxWidth, child: w);
    }
    if (tokens.any((t) => t.endsWith(':h-full') || t == 'h-full')) {
      final tightH = constraints.hasBoundedHeight && constraints.maxHeight.isFinite;
      if (tightH) w = SizedBox(height: constraints.maxHeight, child: w);
    }
    return w;
  });
}

// In Div.build()
Widget? resolvedChild =
    child ?? (children.isNotEmpty ? Column(children: children) : null);
if (resolvedChild != null) {
  resolvedChild = _constrainIfNeeded(resolvedChild, tokens);
}
return Box(style: boxStyle, child: resolvedChild);
```

**Files**: `lib/src/tw_widget.dart`

**Decision**: ✅ **Approved** - Always on. Overhead is conditional (only when `w-full`/`h-full` present)

---

### P1.5: Expand Unknown-Token Diagnostics

**Problem**: Only `flex-*` warns. Typos and unimplemented tokens are silently ignored.

**Impact**: Medium. Developer confusion during development.

**Solution**: Track "handled" flag in each `_apply*Atomic` method. If no handler matched, call `onUnsupported?.call(token)`.

**Implementation**:
```dart
FlexBoxStyler _applyFlexAtomic(FlexBoxStyler styler, String token) {
  var handled = false;

  if (token == 'flex' || token == 'flex-row') {
    handled = true;
    return styler.row();
  }
  // ... (rest of handlers set handled = true)

  if (!handled && token.isNotEmpty) {
    onUnsupported?.call(token);
  }
  return styler;
}
```

**Files**: `lib/src/tw_parser_v2.dart` (all three `_apply*Atomic` methods)

**Decision**: ✅ **Approved** - Implement for better DX

---

## Priority 2 Improvements (Next Iteration)

### P2.1: Responsive Display Semantics

**Problem**: Current model picks single widget type at build. Can't truly switch `Box` ↔ `FlexBox` at runtime based on breakpoints.

**Options**:
1. **Short-term**: If any token across prefixes is `flex*`, always render `FlexBox` and use direction variants at breakpoints (document limitation)
2. **Long-term**: Introduce `TwView` wrapper that switches between `Box` and `FlexBox` based on current conditions

**Decision**: 🔄 **Deferred** - Start with option 1, add documentation. Revisit option 2 if users request it.

---

### P2.2: Fractional Sizes (w-1/2, w-2/3, h-1/4)

**Goal**: Support Tailwind fractional width/height tokens.

**Implementation**: Parse `n/d` fractions and wrap with `FractionallySizedBox`:
```dart
double? _tryFraction(String s) {
  final p = s.split('/');
  if (p.length == 2) {
    final n = double.tryParse(p[0]);
    final d = double.tryParse(p[1]);
    if (n != null && d != null && d != 0) return n / d;
  }
  return null;
}

// In Div.build() after computing tokens:
final wFrac = tokens.map((t)=>t.split(':').last).firstWhere(
  (t) => t.startsWith('w-') && _tryFraction(t.substring(2)) != null,
  orElse: () => '',
);
if (wFrac.isNotEmpty) {
  final f = _tryFraction(wFrac.substring(2))!;
  resolved = FractionallySizedBox(widthFactor: f, child: resolved);
}
```

**Decision**: 🔄 **Approved for P2** - High value for real UIs

---

### P2.3: Token Table Instead of If-Chains

**Goal**: Reduce drift across `Box`/`Flex`/`Text` atomics by introducing a registry.

**Implementation**:
```dart
typedef Apply<S> = S Function(S, Match, TwConfig);
class TokenSpec<S> {
  final RegExp re;
  final Apply<S> apply;
  const TokenSpec(this.re, this.apply);
}

final boxSpecs = <TokenSpec<BoxStyler>>[
  TokenSpec(RegExp(r'^w-(full|screen|\d+(?:\.\d+)?)$'),
    (s, m, c) => s.width(_sizeFrom(m.group(1)!))),
  // ...
];
```

**Benefits**:
- Eliminates code duplication
- Makes adding tokens mechanical
- Enables default "unknown" branch

**Decision**: 🔄 **Approved for P2** - Refactor after P1 fixes

---

### P2.4: Enhanced Test Coverage

**Missing Tests**:
1. Prefixed flex detection (`md:flex`)
2. Column fallback for multiple children
3. Prefix chains (`md:hover:bg-blue-500`)
4. Token precedence (`border-2 border-blue-500`)
5. Constraint guards (`w-full` inside tight parent)
6. Unknown token warnings

**Decision**: ✅ **Required with P1 fixes**

---

### P2.5: Directional Borders and Radii

**Goal**: Support `border-t`, `border-b`, `border-x`, `border-y`, `rounded-t-md`, `rounded-bl-lg`.

**Implementation**: Map to side-specific Mix APIs (`borderTop`, `borderRoundedTopLeft`, etc.). If Mix lacks helpers, extend stylers.

**Decision**: 🔄 **Approved for P2**

---

### P2.6: Enhanced Shadow Scale

**Goal**: Add `shadow-sm`, `shadow-xl`, `shadow-2xl` to match Tailwind.

**Decision**: 🔄 **Approved for P2** - Low effort, high fidelity

---

### P2.7: Gap Variants (gap-x, gap-y)

**Goal**: Add `gap-x-*` and `gap-y-*`.

**Implementation**: Map to `spacingX`/`spacingY` if Mix supports them. Otherwise distribute into per-child `Padding`.

**Decision**: 🔄 **Approved for P2**

---

## Priority 3 Enhancements (Future)

### P3.1: Config Extensibility

**Goal**: Allow teams to extend `TwConfig` with custom tokens.

**Options**:
1. Add `TwConfig merge(TwConfig overrides)` that overlays maps
2. JSON ingestion for tokens (if shipping themes)

**Decision**: 🔄 **Deferred** - Wait for user demand

---

### P3.2: Arbitrary Values

**Goal**: Support Tailwind arbitrary values (`w-[37px]`, `bg-[#1f2937]`).

**Scope**: Start with bracket syntax for color hex and pixel sizes. Ignore complex arbitrary values.

**Decision**: 🔄 **Deferred** - Nice to have, not critical

---

### P3.3: Performance Optimization

**Goal**: Tokenize once, pass token list to parsers to avoid re-splitting.

**Decision**: 🔄 **Deferred** - Micro-optimization, measure first

---

### P3.4: Expand Spacing Map

**Goal**: Add common Tailwind steps: 7, 9, 11, 14, 28, 36, 72, 80, 96.

**Decision**: 🔄 **Approved for P3** - Low effort

---

### P3.5: Negative Margins

**Goal**: Support negative margin tokens (`-m-4`, `-mt-2`).

**Decision**: 🔄 **Deferred** - Wait for user request

---

## Implementation Progress

### Phase 1: Initial POC (✅ Complete)
- [x] Configuration with standard token maps
- [x] Parser with prefix recursion
- [x] FlexBox/Box/Text styler generation
- [x] Div/Span widgets
- [x] Basic test coverage
- [x] Package structure and exports

### Phase 2: P1 Fixes (🔄 In Progress)
- [ ] Fix prefixed flex detection
- [ ] Change Row → Column for non-flex
- [ ] Restore const constructors
- [ ] Add w-full/h-full constraint guards
- [ ] Expand unknown-token diagnostics
- [ ] Add P1 test coverage

### Phase 3: P2 Improvements (⏳ Planned)
- [ ] Fractional sizes (w-1/2, etc.)
- [ ] Token table refactor
- [ ] Directional borders/radii
- [ ] Enhanced shadow scale
- [ ] Gap-x/gap-y support
- [ ] Comprehensive test coverage

### Phase 4: P3 Enhancements (⏳ Future)
- [ ] Config extensibility
- [ ] Arbitrary values (brackets)
- [ ] Performance profiling/optimization
- [ ] Expanded spacing map
- [ ] Negative margins

---

## Coverage Roadmap (Toward Tailwind Parity)

### High Priority (Unlocks Most Real UIs)
- **Layout**: `flex-wrap`, `basis-*`, `grow`/`shrink`, `order-*`
- **Spacing**: negative margins, `space-x`/`space-y` between siblings
- **Sizing**: fractions, `min-w-*`, `max-w-*`, `min-h-*`, `max-h-*`, `aspect-*`

### Medium Priority
- **Borders**: sides, styles, colors with opacity
- **Typography**: `leading-*`, `tracking-*`, `line-clamp-*`
- **Effects**: full shadow scale, `opacity-*`, `ring-*`, `outline-*`

### Lower Priority
- **Backgrounds**: opacity, `bg-gradient-to-*`, images (out of scope)
- **Transforms/Transitions**: basic transition, `duration-*`, `ease-*` mapped to animated Mix variants
- **Grid**: `grid`, `grid-cols-*`, `grid-rows-*`, `col-span-*`

---

## Validation Performed

- ✅ `flutter test` inside `packages/mix_tailwinds` (all green)
- ✅ Dependency fetch succeeded (28 dependencies)
- ✅ Prefix recursion verified (supports chaining)
- ✅ Core token mappings correct (alignment, sizing, colors, borders)
- ⚠️ Production readiness blocked by P1 fixes

---

## Decisions Log

### Decision 1: Default Layout Strategy
**Question**: Should non-flex `Div` with multiple children use `Row` or `Column`?

**Options**:
- A) `Row` (horizontal) - Current implementation
- B) `Column` (vertical) - Matches HTML block flow
- C) Configurable via static property

**Decision**: **B** - `Column`
**Rationale**: Matches Tailwind/HTML block-flow semantics. Less surprising for web developers.
**Date**: 2025-11-03

---

### Decision 2: Const Constructor Strategy
**Question**: How to support const constructors with config defaulting?

**Options**:
- A) Keep non-const, default in initializer (current)
- B) Nullable config field, default in build()
- C) Require explicit config parameter

**Decision**: **B** - Nullable field, default in build()
**Rationale**: Preserves Flutter const optimization without breaking API ergonomics.
**Date**: 2025-11-03

---

### Decision 3: Constraint Guard Strategy
**Question**: Should w-full/h-full guards be always-on or opt-in?

**Options**:
- A) Always-on via LayoutBuilder
- B) Opt-in via constructor flag
- C) No guards (document limitation)

**Decision**: **A** - Always-on
**Rationale**: Prevents crashes in common layouts. Overhead is conditional. Safety > micro-optimization.
**Date**: 2025-11-03

---

### Decision 4: Responsive Display Strategy
**Question**: How to handle display changes at breakpoints (e.g., `block md:flex`)?

**Options**:
- A) Always use FlexBox if any breakpoint has flex (document limitation)
- B) Build TwView wrapper that switches Box ↔ FlexBox at runtime

**Decision**: **A** - Document limitation, defer B to P3
**Rationale**: Option A is simple and covers 90% of use cases. Option B is complex and may not be needed.
**Date**: 2025-11-03

---

## Hand-off Notes

### For Implementation Team
1. **P1 Fixes**: Apply diffs provided in review (see plan.md)
2. **Testing**: Add missing test coverage before marking P1 complete
3. **Documentation**: Update README with known limitations (responsive display)

### For Research Team
- Focus areas: Tailwind utility coverage priorities, Flutter constraint best practices
- When expanding tokens: Include parser tests AND widget tests
- Profile parser performance with large class strings (P3)

---

## References

- **Review Document**: Attached comprehensive review (2025-11-03)
- **Mix 2.0 Docs**: [Mix Documentation](https://fluttermix.com)
- **Tailwind CSS Docs**: [Tailwind CSS](https://tailwindcss.com)
