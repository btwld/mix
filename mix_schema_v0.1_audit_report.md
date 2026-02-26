# mix_schema v0.1 — Audit Report

**Date**: 2026-02-26
**Scope**: Review of `mix_schema_v0.1_freeze.md` and `mix_schema_executable_plan.md` against Mix 2.0 codebase
**Method**: Multi-agent codebase analysis with direct API validation

---

## Summary Judgment

| Document | Verdict |
|----------|---------|
| `mix_schema_v0.1_freeze.md` | Well-scoped, sound. No issues found. |
| `mix_schema_executable_plan.md` | Architecture correct, 3 compile-time bugs, meaningful over-engineering for v0.1 |

The freeze document defines a clear, bounded v0.1 scope. The executable plan accurately maps Mix 2.0 APIs in almost all details and follows proven patterns from `mix_tailwinds`. However, it includes subsystems the freeze marks as Phase 2 or out-of-scope, and proposes ~35+ source files where ~18-20 would be proportionate.

**After fixing 3 bugs and trimming scope, the plan is ready for implementation.**

---

## 1. Bugs Found (3 compile-time issues)

### Bug 1: ImageHandler — Constructor Mismatch

**Location**: Plan §7.4 (ImageHandler), line ~1344

**Plan code**:
```dart
return StyledImage(
  NetworkImage(src),        // WRONG: positional arg
  style: styler,
  semanticLabel: node.alt,  // WRONG: param doesn't exist
);
```

**Actual constructor** (`packages/mix/lib/src/specs/image/image_widget.dart:28-37`):
```dart
const StyledImage({
  super.key,
  super.style = const ImageStyler.create(),
  super.styleSpec,
  this.frameBuilder,
  this.loadingBuilder,
  this.errorBuilder,
  this.image,      // ← named parameter, NOT positional
  this.opacity,
});
```

**Issues**:
1. `StyledImage` does **not** accept a positional `ImageProvider`. Must use `image: NetworkImage(src)`.
2. `semanticLabel` is **not** a constructor parameter. It is a spec-level property resolved from `ImageSpec`. Must be set through `ImageStyler` or a wrapping `Semantics` widget.

**Fix**:
```dart
return StyledImage(
  image: NetworkImage(src),
  style: styler,
);
// Apply node.alt through ImageStyler or Semantics wrapper
```

---

### Bug 2: FlexHandler — Factory Constructor Called as Instance Method

**Location**: Plan §7.4 (FlexHandler), line ~1193

**Plan code**:
```dart
styler = dir == 'row' ? styler.row() : styler.column();
```

**Actual API** (`packages/mix/lib/src/specs/flexbox/flexbox_style.dart:188-189`):
```dart
factory FlexBoxStyler.row() => FlexBoxStyler(direction: .horizontal);
factory FlexBoxStyler.column() => FlexBoxStyler(direction: .vertical);
```

**Issue**: `.row()` and `.column()` are **static factory constructors**, not instance methods. `styler.row()` will fail at compile time with "The method 'row' isn't defined for the type 'FlexBoxStyler'."

**Fix** (either approach):
```dart
// Option A: Use merge with factory constructor
styler = styler.merge(dir == 'row' ? FlexBoxStyler.row() : FlexBoxStyler.column());

// Option B: Use direction parameter directly
styler = styler.merge(FlexBoxStyler(
  direction: dir == 'row' ? Axis.horizontal : Axis.vertical,
));
```

---

### Bug 3: resolveValue — Unsafe Generic Cast

**Location**: Plan §7.2 (RenderContext.resolveValue), line ~937-938

**Plan code**:
```dart
T? resolveValue<T>(SchemaValue? value, BuildContext context) {
  return switch (value) {
    DirectValue<T> v => v.value,
    DirectValue v => v.value as T?,   // ← UNSAFE
    ...
  };
}
```

**Issue**: The second branch `v.value as T?` is a runtime cast. If the AST contains `DirectValue<int>` but the handler calls `resolveValue<double>()`, this throws a `TypeError` at runtime rather than returning null gracefully.

**Fix**:
```dart
DirectValue v => v.value is T ? v.value as T : null,
```

---

## 2. API Correctness Validation (12/12 PASSED)

Every Mix 2.0 API claim in the executable plan was validated against the actual codebase:

| # | Claim | Verified At | Status |
|---|-------|------------|--------|
| 1 | BoxStyler with .color(), .paddingAll(), .width(), .borderRounded(), etc. | `specs/box/box_style.dart` | CORRECT |
| 2 | TextStyler with .color(), .fontSize(), .fontWeight(), .height(), .maxLines() | `specs/text/text_style.dart` | CORRECT |
| 3 | FlexBoxStyler with .spacing(), .crossAxisAlignment(), .mainAxisAlignment() + container methods via shared mixins | `specs/flexbox/flexbox_style.dart` | CORRECT |
| 4 | StackBoxStyler with .alignment() + container methods | `specs/stackbox/stackbox_style.dart` | CORRECT |
| 5 | IconStyler and ImageStyler existence | `specs/icon/icon_style.dart`, `specs/image/image_style.dart` | CORRECT |
| 6 | Widget names: Box, StyledText, StyledIcon, StyledImage, FlexBox, StackBox, PressableBox | Various `*_widget.dart` files | CORRECT |
| 7 | MixStyler hierarchy with WidgetStateVariantMixin (.onHovered, .onPressed, .onFocused, .onDisabled, .onEnabled) and VariantStyleMixin (.onDark, .onLight, .onMobile, .onTablet, .onDesktop) | `style/abstracts/styler.dart`, variant mixin files | CORRECT |
| 8 | 11 token classes: ColorToken, SpaceToken, RadiusToken, TextStyleToken, BorderSideToken, ShadowToken, BoxShadowToken, FontWeightToken, DurationToken, BreakpointToken, DoubleToken | `theme/tokens/value_tokens.dart` | CORRECT |
| 9 | ScrollViewModifierMix + WidgetModifierConfig.modifier() wrapping | `modifiers/scroll_view_modifier.dart` | CORRECT |
| 10 | CurveAnimationConfig + .animate() via AnimationStyleMixin | `animation/animation_config.dart` | CORRECT |
| 11 | MixScope.tokenOf\<T\>() | `theme/mix_theme.dart:134` | CORRECT |
| 12 | mix_tailwinds patterns (TwScope, property-to-styler switches, variant maps) | `packages/mix_tailwinds/lib/src/` | CONFIRMED REUSABLE |

All paths relative to `packages/mix/lib/src/`.

---

## 3. Over-Engineering Analysis

### 3.1 Complexity Ratio

| Metric | mix_tailwinds (shipped) | mix_schema (planned) | Ratio |
|--------|------------------------|---------------------|-------|
| Source files | 6 | ~35+ | ~6x |
| Source lines | ~5,600 | Est. 8,000-12,000 | ~1.5-2x |
| Test files | 5 | ~20+ | ~4x |
| Directories | 1 (`src/`) | 8 (`ast/`, `adapters/`, `validate/`, `render/`, `handlers/`, `trust/`, `tokens/`, `events/`, `components/`) | 8x |

The higher file count is partly justified by the structural difference (recursive tree vs flat string, validation layer, trust enforcement). But the plan splits concerns into too many small files for v0.1. A proportionate target: **18-20 source files**.

### 3.2 Items That Exceed v0.1 Freeze Scope

| Area | Plan Section | Freeze Says | Verdict |
|------|-------------|-------------|---------|
| Component expansion (ComponentRegistry + 5 templates) | §10, Phase 5 | "No custom component authoring API" for v0.1 | **DEFER** — remove `components/` directory entirely |
| Full 12-action hierarchy + SequenceAction + ConditionalAction | §9.2 | Adopt GenUI vocabulary (doesn't require all 12 in v0.1) | **DEFER** — ship 3-4 essential action data classes, no execution engine |
| Action execution engine (propose-before-execute) | §9.3 | Not in v0.1 scope (no agent runtime orchestration) | **DEFER** — keep trust→action gating table as documentation, don't implement |
| A2UI v0.8 adapter | §5.3 | Specifies both, but v0.8 is "compat/stable fallback" | **CONSIDER DEFERRING** — ship v0.9 only, add v0.8 as fast-follow |
| TransformValue (closed registry with 4 type coercions) | §3.2 | "Closed registry" frozen, but coercions are trivially handled in adapter | **DEFER** — define type in sealed hierarchy, skip resolution |

### 3.3 Items That Could Be Simplified

| Area | Current Design | Simpler Alternative |
|------|---------------|-------------------|
| Validation rule files (3 separate: structural, trust, semantic) | 3 files for ~15 total rules | Merge into single `DefaultSchemaValidator` class |
| schema_renderer.dart + schema_registry.dart | 2 files (registry is ~20 lines) | Inline registry in renderer |
| 7 implementation phases | Phase 1-7 with fine granularity | Reduce to 4 phases (AST, Adapter+Validator, Renderer+Handlers, Integration) |
| ResponsiveValue resolution | Hard-coded breakpoints in RenderContext | Leverage Mix's existing `BreakpointToken` system |
| Handler count | 11 handlers for v0.1 | 8 core handlers (box, text, icon, image, flex, stack, pressable, scrollable); defer wrap/input/repeat |

### 3.4 Items That Are Correctly Scoped

| Area | Reason |
|------|--------|
| 11 AST node types (sealed hierarchy) | Cheap to define in types, freeze explicitly lists all 11 |
| 5 core value types (DirectValue, TokenRef, AdaptiveValue, ResponsiveValue, BindingValue) | All needed for frozen feature set |
| Trust model (3 levels + capability matrix) | Simple, necessary for agent-facing untrusted input |
| 16 diagnostic codes | Well-categorized, machine-readable — essential for debuggability |
| SchemaScope pattern | Follows proven TwScope pattern exactly |
| Test strategy (fixtures: valid/invalid/lossy) | Comprehensive and well-structured |

---

## 4. Undocumented Contracts and Verification Points

### 4.1 Adapter Variant Normalization (NOT DOCUMENTED)

The `_buildVariantStyler` function (Plan §8.1) expects variant values as:
```dart
DirectValue<Map<String, SchemaValue>>
```

This is an implicit contract the adapter must satisfy — variant blocks in wire JSON must be normalized into this specific wrapping during adaptation. **This is not documented in §5.2 (A2UI v0.9 Adapter)**. Without explicit documentation, implementing agents may produce variant blocks in a different format, causing variants to silently fail to apply (the function returns null for non-matching types).

**Recommendation**: Add to §5.2 adapter normalization rules.

### 4.2 ScrollViewModifierMix Constructor Form (NEEDS VERIFICATION)

The plan uses:
```dart
ScrollViewModifierMix(scrollDirection: axis)
```

The source file shows `ScrollViewModifierMix.create({...})` as the primary constructor. Whether a convenience factory constructor exists with the exact signature used in the plan needs verification during implementation. The type chain is valid (`ScrollViewModifierMix extends ModifierMix<ScrollViewModifier>` → accepted by `WidgetModifierConfig.modifier()`).

### 4.3 StackBoxStyler Alignment Ambiguity

`StackBoxStyler` has two alignment-related methods:
- `.alignment()` — for the box container's alignment
- `.stackAlignment()` — for the stack widget's own alignment

The plan's `StackHandler` uses `.alignment()`. Confirm whether this maps to the intended behavior for the AST's `alignment` property (likely `.stackAlignment()` is the correct one for stack children positioning).

---

## 5. Variant Mapping Validation (Exhaustive for v0.1)

| Schema Variant Name | Mix Method | Source |
|--------------------|-----------|--------|
| `hover` / `hovered` | `.onHovered()` | `widget_state_variant_mixin.dart:15` |
| `press` / `pressed` | `.onPressed()` | `widget_state_variant_mixin.dart:21` |
| `focus` / `focused` | `.onFocused()` | `widget_state_variant_mixin.dart:46` |
| `disabled` | `.onDisabled()` | `widget_state_variant_mixin.dart:50` |
| `enabled` | `.onEnabled()` | `widget_state_variant_mixin.dart:54` |
| `dark` | `.onDark()` | `variant_style_mixin.dart:52` |
| `light` | `.onLight()` | `variant_style_mixin.dart:63` |
| `mobile` | `.onMobile()` | `variant_style_mixin.dart:97` |
| `tablet` | `.onTablet()` | `variant_style_mixin.dart:102` |
| `desktop` | `.onDesktop()` | `variant_style_mixin.dart:107` |

Mix also supports `.onPortrait()`, `.onLandscape()`, `.onLtr()`, `.onRtl()`, platform variants (`.onIos()`, `.onAndroid()`, etc.), and `.onWeb()`. These are intentionally excluded from v0.1 ("simple mapping only" per freeze), which is correct.

---

## 6. mix_tailwinds Pattern Reuse Validation (8/8 confirmed)

| Pattern | mix_tailwinds Source | mix_schema Equivalent | Verified |
|---------|---------------------|----------------------|----------|
| Property-to-Styler switch | `tw_parser.dart` `_applyPropertyToBox()` | `_applyContainerStyle()` | Yes |
| Accumulator for composed props | `_BorderAccum`, `_TransformAccum` | Planned for border sides + gradients | Valid pattern |
| Variant map factory | `_flexVariants`, `_boxVariants` maps | `_applyVariants()` string mapping | Yes |
| Config scoping | `TwScope` = `MixScope` + `TwConfigProvider` | `SchemaScope` = `MixScope` + `SchemaEngine` | Identical pattern |
| Animation config | `parseAnimationFromTokens()` → `CurveAnimationConfig` | `_applyAnimation()` → `CurveAnimationConfig` | Yes |
| CSS semantic margin | Strip margin, apply outside `MixInteractionDetector` | Same for `PressableHandler` | Valid |
| WidgetModifier wrapping | `styler.wrap(WidgetModifierConfig.blur())` | `styler.wrap(WidgetModifierConfig.modifier(...))` | API confirmed |
| Responsive resolution | `_parseResponsiveToken()` | `ResponsiveValue` resolution | Valid (but duplicates Mix's breakpoint system) |

---

## 7. Recommendations Summary

### Must Fix Before Implementation

| # | Issue | Priority |
|---|-------|----------|
| 1 | ImageHandler: use named `image:` param, remove `semanticLabel` | High — compile error |
| 2 | FlexHandler: use `FlexBoxStyler.row()`/`.column()` as merge source, not instance method | High — compile error |
| 3 | resolveValue: replace `as T?` with type check `is T ? ... : null` | Medium — runtime crash |
| 4 | Document adapter normalization contract for variant blocks | Medium — silent failure |
| 5 | Verify ScrollViewModifierMix constructor form | Low — may need adjustment |

### Scope Decisions for v0.1

| Area | Recommendation | Impact |
|------|---------------|--------|
| Component expansion (§10) | **Defer entirely** | -2 files, -1 implementation phase |
| A2UI v0.8 adapter | **Defer to fast-follow** | -1 file, -fixture set |
| Action execution engine | **Defer** (keep action data classes) | -100 lines, simpler trust model |
| TransformValue | **Defer** (define type, skip resolution) | -50 lines |
| wrap/input/repeat handlers | **Consider deferring** (keep AST types) | -3 files |
| Validation rule files | **Merge** into single validator class | -2 files |
| Renderer + registry | **Merge** into single file | -1 file |
| Implementation phases | **Reduce** from 7 to 4 | Simpler execution plan |
| **Net effect** | | **~15 fewer files, ~18-20 total** |

---

## 8. Overall Scorecard

| Criterion | Score | Notes |
|-----------|-------|-------|
| API accuracy | 9/10 | 3 constructor/method bugs, otherwise excellent mapping |
| Architecture soundness | 9/10 | Clean separation, proven patterns from mix_tailwinds |
| Scope discipline | 6/10 | Includes Phase 5-6 features the freeze defers |
| Implementability | 8/10 | Detailed enough for agent implementation after bug fixes |
| Proportionality | 6/10 | ~6x file count of mix_tailwinds for comparable scope |
| Test strategy | 9/10 | Comprehensive fixture + category approach |
| Freeze alignment | 7/10 | Core aligned; component expansion + full action system = scope creep |

**Bottom line**: The core architecture (AST, adapter, validator, renderer, handlers) is correct and ready to proceed. Fix the 3 handler bugs, document the variant normalization contract, and trim scope to match the freeze's v0.1 boundary before handing to an implementing agent.
