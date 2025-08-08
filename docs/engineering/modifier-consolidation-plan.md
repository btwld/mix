# Modifier Consolidation Plan

## Objective
Unify the current two-piece modifier system (WidgetModifier + WidgetModifierMix) into a single “Modifier” concept that:
- Stores Prop/MixProp values
- Resolves values inside its build method
- Maintains merge ordering and reset behavior
- Avoids incremental migration (single cohesive refactor)

Also:
- Rename WidgetModifierConfig → ModifierConfig
- Rename core/widget_modifier.dart → core/modifier.dart
- Use name “Modifier” for all concrete modifiers (no “Widget” or “Mix” in names)

---

## High-level Design

- Single abstract base: Modifier
  - Has build(BuildContext context, Widget child)
  - Implements Equatable-style props
  - Supports merge semantics (mergeKey by type)

- Remove WidgetModifier and WidgetModifierMix
  - Each concrete modifier becomes one class (e.g., OpacityModifier)
  - Holds Prop/MixProp fields and resolves them inside build

- Config and utilities operate on List<Modifier>
  - ModifierConfig merges and orders modifiers; resolve(context) only reorders

- Rendering
  - RenderWidgetModifiers iterates List<Modifier> and calls build(context, child)

- Reset behavior preserved
  - Reset acts as a merge sentinel (clears accumulated modifiers), not rendered

---

## Renames (Required)

- File: packages/mix/lib/src/core/widget_modifier.dart → packages/mix/lib/src/core/modifier.dart
- Class: WidgetModifierConfig → ModifierConfig (same file renamed to modifier_config.dart)
- File: packages/mix/lib/src/modifiers/widget_modifier_config.dart → packages/mix/lib/src/modifiers/modifier_config.dart
- Class: WidgetModifierUtility → ModifierUtility (and file widget_modifier_util.dart → modifier_util.dart)
- All concrete “...WidgetModifier” and “...WidgetModifierMix” → single “...Modifier”

---

## Detailed Changes by Area

### 1) Core Base and Renderer
- Create/rename base
  - core/modifier.dart
  - abstract class Modifier with:
    - build(BuildContext context, Widget child)
    - Equatable props

- Update renderer
  - modifiers/internal/render_modifier.dart
    - Accept List<Modifier>
    - Call modifier.build(context, current) in order

- Update imports across codebase to use core/modifier.dart

### 2) Style Pipeline Integration
- core/style.dart
  - Fields/types:
    - $modifier: ModifierConfig?
    - ResolvedStyle.widgetModifiers: List<Modifier>?
  - Remove WidgetModifierMix base and related references
  - CompoundStyle.create:
    - Stop special handling of WidgetModifierMix
    - Modifiers only collected via ModifierConfig
  - Style.build():
    - $modifier?.resolve(context) returns ordered List<Modifier>

- No changes to non-modifier Spec pipeline

### 3) ModifierConfig (formerly WidgetModifierConfig)
- modifiers/modifier_config.dart
  - class ModifierConfig
    - Fields:
      - List<Modifier>? $modifiers
      - List<Type>? $orderOfModifiers
    - merge(ModifierConfig other):
      - Merge by mergeKey (type)
      - If ResetModifier encountered in other, clear accumulated and continue
    - resolve(BuildContext context):
      - Return ordered List<Modifier> (no Prop resolution)
    - reorderModifiers(List<Modifier>):
      - Maintain current ordering logic

  - Update all factory constructors to return concrete Modifier instances:
    - opacity, padding, align, aspectRatio, clip variants, transform, sizedBox, fractionallySizedBox, defaultTextStyle, iconTheme, visibility, intrinsicWidth/Height, rotatedBox, flexible, etc.

  - Update _defaultOrder to the new class names:
    - FlexibleModifier, VisibilityModifier, IconThemeModifier, DefaultTextStyleModifier
    - SizedBoxModifier, FractionallySizedBoxModifier, IntrinsicHeightModifier, IntrinsicWidthModifier, AspectRatioModifier
    - RotatedBoxModifier, AlignModifier, PaddingModifier
    - TransformModifier
    - ClipOvalModifier, ClipRRectModifier, ClipPathModifier, ClipTriangleModifier, ClipRectModifier
    - OpacityModifier

### 4) Utilities and Style Mixin
- modifiers/modifier_util.dart
  - class ModifierUtility<T extends Style<Object?>>
  - Returns Modifier instances directly
  - Keep convenience methods (scale, rotate, intrinsicWidth/Height) to build the right Modifier objects

- StyleWidgetModifierMixin
  - wrap(ModifierConfig value)
  - Update all wrap helpers (wrapOpacity, wrapPadding, wrapClip*, wrapVisibility, wrapAspectRatio, etc.) to use ModifierConfig factories

### 5) Concrete Modifiers (per file)
- For each file in src/modifiers:
  - Remove “...WidgetModifier” and “...WidgetModifierMix”
  - Create a single “...Modifier” class:
    - Fields: Prop<T>/MixProp<T> where applicable
    - merge(other): combine fields via MixOps.merge (preserve list strategies where needed)
    - props: include fields for equality
    - build(BuildContext, Widget): resolve fields and return the wrapped Flutter widget

- Reset
  - Replace ResetWidgetModifierMix with ResetModifier (merge sentinel)
  - Ensure ModifierConfig.merge handles reset (clear) and does not include ResetModifier in final render list

### 6) Exports
- mix.dart
  - Export core/modifier.dart
  - Export refactored modifier files
  - Remove export of core/widget_modifier.dart and old widget_modifier_util/config

### 7) Tests
- Update modifier tests:
  - Remove .resolve() tests for Mix classes
  - Add tests for:
    - merge behavior on the new Modifier class
    - build(BuildContext, child) producing correct Flutter widget and values
    - order-of-modifiers behavior via ModifierConfig
    - reset behavior clearing modifiers

- Update core/style_builder tests:
  - Ensure ResolvedStyleBuilder wraps with RenderWidgetModifiers using List<Modifier>
  - Integration tests asserting composed widget trees remain correct

### 8) Docs
- website/pages/docs/guides/widget-modifiers.mdx
  - Update narrative to single-class “Modifier” model
  - Update examples to use ModifierConfig/ModifierUtility
  - Emphasize resolution happening within build

### 9) Cleanup and Cross-Package
- Search/replace references:
  - WidgetModifier, WidgetModifierMix, WidgetModifierConfig, WidgetModifierUtility
  - widget_modifier.dart, widget_modifier_config.dart, widget_modifier_util.dart

- Check mix_generator references/tests:
  - Update any hardcoded references to WidgetModifierSpec/Mix if they exist in fixtures/tests
  - Ensure generators/tests still pass or are updated accordingly

---

## File Checklist (Non-exhaustive but Concrete)

- core/modifier.dart (new) replacing widget_modifier.dart
- modifiers/internal/render_modifier.dart
- core/style.dart (update fields, types, and remove WidgetModifierMix base)
- modifiers/modifier_config.dart (rename, rewrite to Modifier-based)
- modifiers/modifier_util.dart (rename, return Modifier)
- All modifiers under src/modifiers/*.dart:
  - align_modifier.dart
  - aspect_ratio_modifier.dart
  - clip_modifier.dart
  - default_text_style_modifier.dart
  - flexible_modifier.dart
  - fractionally_sized_box_modifier.dart
  - icon_theme_modifier.dart
  - intrinsic_modifier.dart
  - mouse_cursor_modifier.dart
  - opacity_modifier.dart
  - padding_modifier.dart
  - rotated_box_modifier.dart
  - scroll_view_modifier.dart
  - sized_box_modifier.dart
  - transform_modifier.dart
  - visibility_modifier.dart
  - internal/reset_modifier.dart (special sentinel)
- mix.dart (exports)
- Tests: packages/mix/test/** (modifiers, style builder, integration)
- Docs: website/pages/docs/guides/widget-modifiers.mdx
- mix_generator (if any references)

---

## Task Execution Plan

1) Core rename and API
- Rename widget_modifier.dart → modifier.dart
- Define abstract Modifier with build(BuildContext, Widget) + Equatable
- Update imports

2) Renderer update
- Update RenderWidgetModifiers to List<Modifier> and call build(context, child)

3) Style/ResolvedStyle updates
- Update $modifier: ModifierConfig?
- Update ResolvedStyle.widgetModifiers: List<Modifier>?
- Remove WidgetModifierMix base and references
- Adjust CompoundStyle.create and Style.build to route through ModifierConfig

4) ModifierConfig conversion
- Rename/convert WidgetModifierConfig → ModifierConfig
- Implement merge, resolve (ordering only), reset handling, factories for all modifiers
- Update _defaultOrder type names

5) Utilities and mixin
- Rename WidgetModifierUtility → ModifierUtility
- Update StyleWidgetModifierMixin.wrap and convenience wrap methods

6) Convert modifiers
- For each modifier:
  - Create single …Modifier with Prop fields, merge, props, build(context, child)
  - Remove …WidgetModifier and …WidgetModifierMix
  - Adjust any local utilities/factories to return …Modifier

7) Exports and references
- Update mix.dart exports and purge old exports
- Global search/replace to clean references to old names

8) Tests
- Update and re-run modifier tests, style builder tests, and integration tests
- Add/adjust reset and ordering tests
- Fix generator-related tests if applicable

9) Docs
- Update the widget-modifiers guide to the new model and examples

10) Validation
- Run analyzer, dart fix, tests
- Verify sample compositions (opacity + padding + clip + align etc.) render as expected

---

## Acceptance Criteria

- No remaining references to WidgetModifier, WidgetModifierMix, WidgetModifierConfig, or widget_modifier.dart
- All modifiers exist as single …Modifier classes with build(BuildContext, Widget)
- ModifierConfig merges and orders modifiers correctly; reset clears prior modifiers
- RenderWidgetModifiers composes child widgets by iterating List<Modifier>
- Tests pass for merge behavior, build output, ordering, reset, and style builder integration
- Docs updated to reflect single-class model

---

## Risks and Mitigations

- Large refactor scope: mitigate with systematic search, focused tests, and isolated commits per area
- mix_generator coupling: scan and update any references; adjust tests/fixtures
- Breaking changes: bump major version; provide migration notes

---

## Migration Notes (for release)
- Replace imports of core/widget_modifier.dart with core/modifier.dart
- Replace WidgetModifierConfig with ModifierConfig
- Replace any …WidgetModifier/…WidgetModifierMix references with …Modifier
- No .resolve() on modifiers; resolution happens inside build(BuildContext, child)
- Utilities and wrap methods continue to work via ModifierConfig and ModifierUtility with updated names/types
