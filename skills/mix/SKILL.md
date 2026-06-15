---
name: mix
description: >
  This skill should be used when working on the Mix Flutter styling
  framework or any project using the mix package. Applies when the user
  mentions Mix specs, Mix styles, BoxStyler, TextStyler, Pressable,
  PressableBox, StyleWidget, MixStyler, fluent chaining, Prop values, Mix types,
  Mix annotations (@MixableSpec, @MixWidget, legacy @MixableStyler, @Mixable),
  code generation with mix_generator, dot-shorthand policy, style variants (NamedVariant,
  ContextVariant, WidgetStateVariant, onHovered, onPressed, onDark), implicit
  animations with .animate(), Phase animations, Keyframe animations, design
  tokens (MixScope, tokens), widget modifiers (.wrap()), directives, style
  mixins, melos commands for Mix (gen:build, ci, analyze, exports), or the
  Mix monorepo packages (mix, mix_annotations, mix_generator, mix_lint,
  mix_tailwinds).
---

# Mix Framework

Type-safe styling system for Flutter that separates style semantics from widgets.

**Target version:** `mix: 2.0.3` (Dart >=3.11.0, Flutter >=3.41.0)
Confirm the project's actual version before applying patterns — check `pubspec.yaml`.

## Source of Truth

When working on Mix code, resolve ambiguity in this order:

1. **Local source code** — always highest priority when the repo is present
2. **Dart MCP tools** (`hover`, `signature_help`, `resolve_workspace_symbol`) — if connected and dependencies resolved
3. **Version-pinned docs** — [Mix website](https://fluttermix.com), [pub.dev/packages/mix](https://pub.dev/packages/mix)
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
| `StackStyler` | `StackSpec` | — (layout) | `Stack` |
| `StackBoxStyler` | `StackBoxSpec` | `StackBox` | `Stack` + `Container` |
| `IconStyler` | `IconSpec` | `StyledIcon` | `Icon` |
| `ImageStyler` | `ImageSpec` | `StyledImage` | `Image` |

Interactive: `Pressable` (gesture + focus + mouse), `PressableBox` (Pressable + Box).

## Key Patterns

### Top-Level Rule

Start top-level declarations with the relevant concrete Styler constructor (`BoxStyler()`, `TextStyler()`, `IconStyler()`, etc.), then chain. Static factories are valid API but discouraged for top-level declarations; bare dot-shorthand is only for typed nested contexts. In nested typed contexts (variants, state callbacks), use bare shorthand `.method()` instead. See `references/styler-api-policy.md` for the complete policy.

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
- **`mix.dart` is generated** — never edit directly; run `melos run exports`
- **Run codegen after spec changes** — `melos run gen:build`
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
| `mix_annotations` | `@MixableSpec`, `@MixWidget`, `@MixableStyler`, `@Mixable`, `@MixableField` |
| `mix_generator` | `build_runner` generator producing `*.g.dart` mixins |
| `mix_lint` | Analysis server plugin with Mix-specific lint rules |
| `mix_tailwinds` | Tailwind-style utility layer (experimental) |

## References

Consult these for detailed guidance:

- **[`references/architecture.md`](references/architecture.md)** — Spec, Styler, Prop<V>, resolution pipeline, StyleWidget
- **[`references/styler-api-policy.md`](references/styler-api-policy.md)** — Top-level rule, dot-shorthand policy, factory constructor table, chain-only methods
- **[`references/fluent-api.md`](references/fluent-api.md)** — Chaining, style mixins, sizing decision tree, composition
- **[`references/code-generation.md`](references/code-generation.md)** — Annotations, generated output, BoxSpec reference impl
- **[`references/variants.md`](references/variants.md)** — NamedVariant, ContextVariant, WidgetStateVariant, built-in methods
- **[`references/animations.md`](references/animations.md)** — Implicit, Phase, Keyframe animations
- **[`references/design-tokens.md`](references/design-tokens.md)** — MixScope, token types, theming
- **[`references/widget-modifiers-directives.md`](references/widget-modifiers-directives.md)** — .wrap(), modifiers, directives
- **[`references/development-workflow.md`](references/development-workflow.md)** — Creating specs, codegen workflow, monorepo
- **[`references/testing.md`](references/testing.md)** — resolvesTo matcher, MockBuildContext, merge testing
