---
name: mix
description: >-
  Use when building or maintaining Flutter UI with the Mix styling framework:
  Mix specs and stylers, BoxStyler, TextStyler, Pressable, FlexBox, WrapBox,
  GridBox, StackBox, responsive layouts, fluent chaining, Prop values, Mix
  annotations and mix_generator code generation, dot shorthand, variants,
  animations, design tokens and MixScope, widget modifiers, directives, style
  mixins, or the Mix monorepo packages (mix, mix_annotations, mix_generator,
  mix_lint, mix_protocol, mix_winds, and mix_chart). Also trigger for UI work in
  a project that already depends on `mix`. Do not trigger for generic Flutter
  work when Mix is neither present nor requested.
---

# Mix Framework

Type-safe styling system for Flutter that separates style semantics from widgets.

## Set Up Mix

Inspect the consuming project's `pubspec.yaml` or lockfile before assuming Mix
is available or applying version-specific APIs.

```bash
flutter pub add mix
```

```dart
import 'package:mix/mix.dart';
```

In the Mix repository, read `packages/mix/pubspec.yaml` for the current SDK,
Flutter, and package versions. In a consumer repository, follow its resolved
version; older releases may not expose newer primitives such as `WrapBox` and
`GridBox`.

## Source of Truth

When working on Mix code, resolve ambiguity in this order:

1. **Local source code** — always highest priority when the repo is present
2. **Dart MCP tools** (`hover`, `signature_help`, `resolve_workspace_symbol`) — if connected and dependencies resolved
3. **Version-pinned docs** — [Mix website](https://www.fluttermix.com), [pub.dev/packages/mix](https://pub.dev/packages/mix)
4. **This skill** — patterns, invariants, and workflows documented here
5. **If still unclear** — state uncertainty and ask the user to confirm

## Core Mental Model

```
Spec (immutable resolved data) ← Styler (fluent builder with Prop<V>) → Widget (renders Spec)
```

Resolution pipeline: `StyleWidget` → `StyleBuilder` → merge active variants → resolve `Prop<V>` fields (tokens, Mix types, directives) → produce `StyleSpec<S>` → animate → `widget.build(context, spec)` → provide `StyleSpec` → apply widget modifiers.

## Widget Reference

| Styler | Spec | Widget | Flutter Equivalent |
|--------|------|--------|--------------------|
| `BoxStyler` | `BoxSpec` | `Box` | `Container` |
| `TextStyler` | `TextSpec` | `StyledText` | `Text` |
| `FlexStyler` | `FlexSpec` | — (layout) | `Flex`/`Row`/`Column` |
| `FlexBoxStyler` | `FlexBoxSpec` | `FlexBox`/`RowBox`/`ColumnBox` | `Column`/`Row` + `Container` |
| `WrapStyler` | `WrapSpec` | — (layout) | `Wrap` |
| `WrapBoxStyler` | `WrapBoxSpec` | `WrapBox` | `Wrap` + `Container` |
| `GridBoxStyler` | `GridBoxSpec` | `GridBox` | Fixed/`fr` columns; fixed/`fr`/auto rows |
| `StackStyler` | `StackSpec` | — (layout) | `Stack` |
| `StackBoxStyler` | `StackBoxSpec` | `StackBox` | `Stack` + `Container` |
| `IconStyler` | `IconSpec` | `StyledIcon` | `Icon` |
| `ImageStyler` | `ImageSpec` | `StyledImage` | `Image` |

Interactive: `Pressable` (gesture + focus + mouse), `PressableBox` (Pressable + Box).

`GridBox` is a Mix-owned layout primitive, but unlike `FlexBox`, `WrapBox`, and `StackBox`, it does not include outer `Box` decoration or padding. Compose it inside `Box` when the grid itself needs chrome.

## Key Patterns

### Write Mix, Not Raw Flutter

When styling a Mix surface, keep visual semantics in Stylers instead of nesting raw Flutter widgets for styling concerns.

| Instead of | Write |
|------------|-------|
| `Container(color: ..., padding: ..., child: ...)` | `Box(style: BoxStyler().color(...).padding(.all(...)), child: ...)` |
| `Text('Label', style: TextStyle(...))` | `StyledText('Label', style: TextStyler().fontSize(...).color(...))` |
| `Icon(Icons.star, color: ..., size: ...)` | `StyledIcon(icon: Icons.star, style: IconStyler().color(...).size(...))` |
| `Theme.of(context).colorScheme.primary` in styles | `ColorToken` values from `MixScope`, then `BoxStyler().color($primary())` |
| `Theme.of(context).textTheme.bodyMedium` in styles | `TextStyleToken` values from `MixScope`, then `TextStyler().style($body.mix())` |
| Nested `Padding` / `Align` for a styled widget | Styler methods such as `.padding(.all(16))` and `.alignment(Alignment.center)` |

### Choose the Layout Primitive

| Need | Use |
|------|-----|
| One child with size, padding, or decoration | `Box` |
| One non-wrapping row or column | `RowBox`, `ColumnBox`, or `FlexBox` |
| Chips, tags, or intrinsic items that flow onto new runs | `WrapBox` |
| Dashboards, card catalogs, and galleries with explicit two-dimensional tracks | `GridBox` |
| Overlays or positioned layers | `StackBox` |

Use `GridBoxStyler.onConstraints` when grid geometry should react to the space offered by its parent. Use `onBreakpoint` when a style should react to viewport size through `MediaQuery`. See `references/layout.md` for the complete layout decision guide, responsive Grid patterns, constraints, animation rules, and current limitations.

### Top-Level Rule

Start ordinary top-level declarations with the relevant concrete Styler constructor (`BoxStyler()`, `TextStyler()`, `IconStyler()`, etc.), then chain. Static factories are valid API but usually discouraged as top-level entry points. Grid declarations are the deliberate exception: use an explicit `GridBoxStyler` type with `.equalColumns(...)` or `.columns(...)` so the required track topology is visible. In typed nested contexts (variants, state callbacks, constraint patches), use bare shorthand `.method()`. See `references/styler-api-policy.md` for the complete policy.

### Fluent Chaining (recommended)

```dart
final style = BoxStyler()
    .color(Colors.blue)
    .size(100, 100)
    .padding(.all(16))
    .borderRadius(.circular(8));

Box(style: style, child: child)
```

### Variants (context-aware styling)

```dart
// Bare shorthand in nested typed contexts
final style = BoxStyler()
    .color(Colors.white)
    .onDark(.color(Colors.black))
    .onHovered(.color(Colors.blue));
```

### Implicit Animation

```dart
final style = BoxStyler()
    .color(Colors.black)
    .onHovered(.color(Colors.blue).scale(1.2))
    .animate(.easeInOut(300.ms));
```

### Composition via Merge

```dart
final base = BoxStyler().padding(.all(16)).borderRadius(.circular(8));
final elevated = BoxStyler().elevation(ElevationShadow(4));
final combined = base.merge(elevated);
```

## Critical Rules

- **Specs are immutable** — always `@immutable final class`, use `copyWith()` for changes
- **Styler value fields generally use `$` prefix** — `$padding`, `$alignment`, etc. with `Prop<V>?`; exceptions include directives, variants, modifier, and animation metadata
- **Generated Stylers have `.create()` and default constructors** — many also expose generated factory constructors
- **Prefer `@MixableSpec(target: Widget.new)`** — `@MixableStyler` is legacy/deprecated
- **Use `@MixWidget` for generated widgets from style factories** — it wraps top-level `Style<S>` variables or functions
- **Widget targets can be plain Widgets** — `@MixableSpec(target:)` and `@MixWidget(target:)` need a compatible named `style` parameter; neither requires `StyleWidget`
- **Use `@MixableModifier` for generated modifiers** — it emits the modifier contract mixin and `ModifierMix` class
- **`mix.dart` is generated** — never edit directly; run `melos run exports`
- **Run codegen after spec changes** — `melos run gen:build`
- **Grid constraint branches are geometry-only** — columns, rows, `autoRows`, and gaps; keep clipping, modifiers, animations, and ordinary variants on the base styler
- **Prop merge semantics** — regular values: last wins (replacement); Mix values: accumulated merge
- **Variant priority** — ContextVariant/NamedVariant first → StyleVariation second → WidgetStateVariant last (highest)

## Commands

```bash
melos bootstrap           # Install dependencies
melos run gen:build       # Clean + regenerate all *.g.dart files
melos run ci              # Run all tests (flutter + dart)
melos run analyze         # Dart + DCM analysis
melos run fix             # Auto-fix lint issues
melos run exports         # Regenerate mix.dart barrel file
```

**Pre-commit verification:**
```bash
melos run gen:build && melos run ci && melos run analyze
```

## Monorepo Packages

| Package | Purpose |
|---------|---------|
| `mix` | Core framework |
| `mix_annotations` | `@MixableSpec`, `@MixWidget`, `@MixableModifier`, `@MixableStyler`, `@Mixable`, `@MixableField` |
| `mix_generator` | `build_runner` generator producing `*.g.dart` mixins |
| `mix_lint` | Analysis server plugin with Mix-specific lint rules |
| `mix_protocol` | Versioned JSON wire contract, codecs, schemas, inspection, and token walking for Mix styles |
| `mix_winds` | Tailwind-style utility layer (experimental) |
| `mix_chart` | Mix-owned line, bar, and pie chart APIs |

## References

Consult these for detailed guidance:

- **[`references/architecture.md`](references/architecture.md)** — Spec, Styler, Prop<V>, resolution pipeline, StyleWidget
- **[`references/styler-api-policy.md`](references/styler-api-policy.md)** — Top-level rule, dot-shorthand policy, factory constructor table, chain-only methods
- **[`references/layout.md`](references/layout.md)** — Box/Flex/Wrap/Grid/Stack selection, responsive Grid use cases, constraints, and layout composition
- **[`references/fluent-api.md`](references/fluent-api.md)** — Chaining, style mixins, sizing decision tree, composition
- **[`references/code-generation.md`](references/code-generation.md)** — Annotations, generated output, BoxSpec reference impl
- **[`references/examples.md`](references/examples.md)** — Worked end-to-end examples
- **[`references/variants.md`](references/variants.md)** — NamedVariant, ContextVariant, WidgetStateVariant, built-in methods
- **[`references/animations.md`](references/animations.md)** — Implicit, Phase, Keyframe animations
- **[`references/design-tokens.md`](references/design-tokens.md)** — MixScope, token types, theming
- **[`references/widget-modifiers-directives.md`](references/widget-modifiers-directives.md)** — .wrap(), modifiers, directives
- **[`references/development-workflow.md`](references/development-workflow.md)** — Creating specs, codegen workflow, monorepo
- **[`references/testing.md`](references/testing.md)** — resolvesTo matcher, MockBuildContext, merge testing
