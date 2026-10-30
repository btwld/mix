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

Build and maintain Flutter UI with Mix. Preserve the user's chosen scope;
using this skill does not authorize dependency changes, publication, or other
external actions. In a consumer app, inspect its manifest and resolved Mix
version before adding or using APIs. Install with `flutter pub add mix` only
when adding Mix is part of the task.

## Resolve API questions

Use local source first, then connected Dart MCP signature/hover tools, then
version-pinned [pub.dev docs](https://pub.dev/packages/mix) and the
[Mix website](https://www.fluttermix.com). This skill supplies patterns, not a
promise that every installed release has the same surface. Confirm uncertain
signatures in the installed package before writing code.

In the Mix monorepo, read `AGENTS.md`, `melos.yaml`, and package manifests for
setup and commands. Outside it, follow the consuming project's toolchain.
References below remain usable without a checkout of the Mix repository.

## Essential model

Styler → resolved Spec → Widget. Fluent calls return **new merged values**;
plain values replace while Mix values accumulate fieldwise. `Prop` carries
concrete values, tokens or Mix values until resolution. Specs are immutable;
caller-provided collections are not necessarily deeply immutable.

Keep visual styling in stylers on Mix surfaces. Tokens and variants can be
resolved with `BuildContext`; they do not require a global mutable theme.
A style builds a `StyleSpec`, animation interpolates it, the widget renders its
spec, and ordered modifiers wrap the result.

## Author a style

Start ordinary declarations with the concrete styler, then chain. Use typed
nested shorthand for variants and nested values. Generated factories are valid;
this is a preferred spelling, not an API restriction.

```dart
final style = BoxStyler()
    .color(Colors.blue)
    .size(100, 100)
    .padding(.all(16))
    .borderRadius(.circular(8))
    .onHovered(.color(Colors.blue.shade700))
    .animate(.easeInOut(300.ms));

Box(style: style, child: child);
```

Grid is an intentional entry-point exception: make topology explicit with
`final GridBoxStyler grid = .equalColumns(3).gap(16);`.

## Choose only the references needed

| Task | Reference |
|---|---|
| Understand resolution or extend core abstractions | [Architecture](references/architecture.md) |
| Choose spelling; migrate deprecated conveniences or nullable values | [Styler policy](references/styler-api-policy.md) |
| Compose reusable fragments, interactions or callable stylers | [Fluent API](references/fluent-api.md) |
| Choose Box, Flex, Wrap, Grid or Stack; responsive constraints | [Layout](references/layout.md) |
| Add specs, recipe widgets, modifiers or generator fields | [Code generation](references/code-generation.md) |
| Conditional context, named or interaction patches | [Variants](references/variants.md) |
| Implicit, phase or keyframe transitions | [Animations](references/animations.md) |
| Scope values, custom tokens or Material defaults | [Design tokens](references/design-tokens.md) |
| Wrapper order or value transformations | [Modifiers and directives](references/widget-modifiers-directives.md) |
| Locate runnable UI patterns | [Examples](references/examples.md) |
| Work inside the monorepo | [Development workflow](references/development-workflow.md) |
| Test resolution, merges or widget integration | [Testing](references/testing.md) |

## Invariants for implementation changes

- Prefer `@MixableSpec(target: Widget.new)` over legacy `@MixableStyler` for new
  widget-backed APIs. `@MixWidget` wraps existing recipes; targets can be plain
  Widgets with a compatible named `style` parameter.
- Use `@MixableModifier` for generated modifier contracts and Mix classes.
- Edit generator inputs rather than `*.g.dart` or `mix.dart`. `gen:build` and
  `exports` are separate commands.
- Grid constraint patches are geometry-only; Grid itself has no outer Box.
- Variant priority follows declared widget-state dependencies and declaration
  order within groups, not variant class names.
- Modifier order is style-local → nearest scope → package default, with remaining
  configured types appended stably.
- Unsupported custom token `call()` shapes throw; explicit resolution or
  `Prop.token` may still support the custom value.

For repository rationale, consult
[ARCHITECTURE.md](https://github.com/btwld/mix/blob/main/ARCHITECTURE.md).
Package-specific contracts remain in the Protocol, Winds and chart docs;
do not assume that encoding a style preserves widget-runtime layout behavior.
