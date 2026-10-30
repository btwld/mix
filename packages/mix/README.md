<picture>
  <source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/btwld/mix/main/assets/dark.svg">
  <img alt="Mix logo" src="https://raw.githubusercontent.com/btwld/mix/main/assets/light.svg">
</picture>

# Mix

Type-safe styling for Flutter, with styles defined separately from widget structure.

[Documentation](https://www.fluttermix.com) ·
[Source](https://github.com/btwld/mix) · [BSD 3-Clause license](LICENSE)

## Core concepts

- **Styler → Spec → Widget:** a typed style resolves to data that a widget renders.
- **Styles are values:** fluent methods return new merged styles, so bases can be reused.
- **Props defer values:** concrete values, tokens, and Mix values resolve with context;
  plain values replace, while Mix values accumulate fieldwise.
- **Tokens name values:** `MixScope` supplies them; `ContextToken` can compute a default.
- **Variants are conditional patches:** state-dependent patches have higher priority,
  with declaration order preserved within each priority group.
- **Modifiers wrap widgets; directives transform values** during resolution or rendering.
- **Animation interpolates resolved specs:** implicit, phase, and keyframe modes.
- **Annotations generate typed plumbing** and widgets from style recipes.

The [architecture map and decision log](https://github.com/btwld/mix/blob/main/ARCHITECTURE.md)
record the rationale behind the model.

## Install

```bash
flutter pub add mix
```

Current sources require Dart 3.12+ and Flutter 3.44+; check
[pubspec.yaml](pubspec.yaml) for this package's constraints.

```dart
import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

final cardStyle = BoxStyler()
    .size(240, 100)
    .color(Colors.blue)
    .alignment(.center)
    .borderRadius(.circular(12));

final card = Box(
  style: cardStyle,
  child: StyledText(
    'Hello Mix',
    style: TextStyler().color(Colors.white).fontSize(18),
  ),
);
```

## Compose styles

```dart
final base = BoxStyler().padding(.all(16)).borderRadius(.circular(8));
final highlighted = base.color(Colors.blue);
final interactive = highlighted
    .onDark(.color(Colors.blue.shade200))
    .onHovered(.color(Colors.blue.shade700));
```

`base` retains its original style. Later plain values replace earlier values;
partial Mix values merge their fields. Use `.create()` when supplying explicit
`Prop` values rather than the normal fluent surface.

For interactive surfaces, use `PressableBox` or `BoxStyler.pressable(...)` so
state variants have a shared interaction owner.

## Choose a layout

| Need | Widget |
|---|---|
| One styled child | `Box` |
| Non-wrapping row or column | `RowBox`, `ColumnBox`, `FlexBox` |
| Items flowing across runs | `WrapBox` |
| Explicit two-dimensional tracks | `GridBox` |
| Overlays | `StackBox` |

`GridBox` has no outer Box chrome. Wrap it in `Box` for padding or decoration.
Its local `onConstraints` patches change geometry; `onBreakpoint` uses viewport
width. Fixed/fractional columns and content-sized rows have different measurement
costs; see the [Grid guide](doc/grid-layout.md).

```dart
final GridBoxStyler grid = .equalColumns(3).gap(16).onConstraints(
  .maxWidth(720),
  .equalColumns(1).gap(12),
);
```

`WrapBox` combines outer Box styling with inner Wrap layout. Use
`wrapAlignment` and `wrapClipBehavior` for the inner layout; `alignment` and
`clipBehavior` apply to the outer Box. `.flow(WrapStyler(...))` supplies a
nested Wrap style.

## Tokens and theming

```dart
const primary = ColorToken('brand.primary');
const spacing = SpaceToken('space.md');

final themedCard = MixScope(
  colors: {primary: Colors.blue},
  spaces: {spacing: 16.0},
  child: Box(style: BoxStyler().color(primary()).padding(.all(spacing()))),
);
```

Calling a token creates a deferred reference; `token.resolve(context)` retrieves
a value. A plain nested `MixScope` shadows its ancestor; use `MixScope.inherit`
for partial overrides. `ContextToken` computes a fallback even without a scope.
See [scope and theming](doc/mix-scope-and-theming.md).

## Animation, modifiers and directives

- `.animate(...)` interpolates compatible resolved specs.
- `.phaseAnimation(...)` and `.keyframeAnimation(...)` express sequenced changes.
- `.wrap(...)` composes widget modifiers such as opacity and clipping.
- Directives transform resolved values, for example text casing.

These compose with variants; consult the versioned API for exact signatures.

## Learn and extend

- [Styling](https://www.fluttermix.com/documentation/mix/guides/styling),
  [variants](https://www.fluttermix.com/documentation/mix/guides/dynamic-styling),
  [tokens](https://www.fluttermix.com/documentation/mix/guides/design-token),
  [animations](https://www.fluttermix.com/documentation/mix/guides/animations).
- [Runnable showcase](https://github.com/btwld/mix/tree/main/examples/showcase)
  and [layout examples](https://github.com/btwld/mix/blob/main/examples/showcase/docs/layouts.md).
- [Token migration](doc/token-migration-guide.md).
- [mix_annotations](https://pub.dev/packages/mix_annotations) and
  [mix_generator](https://pub.dev/packages/mix_generator): specs and recipe widgets.
- [mix_protocol](https://pub.dev/packages/mix_protocol): optional JSON boundary.
- [mix_winds](https://pub.dev/packages/mix_winds): Tailwind-style classes.
- [mix_chart](https://pub.dev/packages/mix_chart): Mix-styled charts;
  [mix_chart_protocol](https://github.com/btwld/mix/tree/main/packages/mix_chart_protocol)
  adds serialization.
- [mix_lint](https://pub.dev/packages/mix_lint): analyzer rules.
- [Mix skill](https://github.com/btwld/mix/tree/main/skills/mix): agent API references.
