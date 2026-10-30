<picture>
  <source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/btwld/mix/main/assets/dark.svg">
  <img alt="Mix logo" src="https://raw.githubusercontent.com/btwld/mix/main/assets/light.svg">
</picture>

# Mix

Type-safe styling for Flutter, with style definitions separate from widget structure.

[Package](https://pub.dev/packages/mix) ·
[Documentation](https://www.fluttermix.com) ·
[BSD 3-Clause license](LICENSE)

## Core concepts

- Styler → Spec → Widget: a typed style resolves to data that a widget renders.
- Styles are values: fluent methods return new merged styles, so bases can be reused.
- Props defer values: concrete values, tokens, and Mix values resolve with context;
  plain values replace, while Mix values accumulate fieldwise.
- Tokens name values: `MixScope` supplies them; `ContextToken` can compute a default.
- Variants are conditional patches: state-dependent patches have higher priority,
  with declaration order preserved within each priority group.
- Modifiers wrap widgets; directives transform values during resolution or rendering.
- Animation interpolates resolved specs: implicit, phase, and keyframe modes.
- Annotations generate typed plumbing and widgets from style recipes.

The [decision log](ARCHITECTURE.md) explain the boundaries
and tradeoffs behind these concepts. The bullets describe the model; the log
preserves reasons to revisit a choice.

## Start

```bash
flutter pub add mix
```

Current sources require Dart 3.12+ and Flutter 3.44+; check the
[package manifest](packages/mix/pubspec.yaml) for the version you use.

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

## Packages

| Package | Purpose |
|---|---|
| [mix](packages/mix) | Styling, tokens, variants, animation and layout |
| [mix_annotations](packages/mix_annotations) | Code-generation annotations |
| [mix_generator](packages/mix_generator) | build_runner generators |
| [mix_lint](packages/mix_lint) | Mix analyzer rules |
| [mix_protocol](packages/mix_protocol) | JSON contract, codecs and schemas |
| [mix_winds](packages/mix_winds) | Tailwind utility compiler and Flutter widgets |
| [mix_chart](packages/mix_chart) | Line, bar and pie charts |
| [mix_chart_protocol](packages/mix_chart_protocol) | Optional chart JSON vocabulary |

## Examples and guides

- [Showcase](examples/showcase): widgets, responsive layouts, interactions and charts.
- [Example workspace setup](examples): dependencies and web builds.
- [Styling](https://www.fluttermix.com/documentation/mix/guides/styling),
  [variants](https://www.fluttermix.com/documentation/mix/guides/dynamic-styling),
  [tokens](https://www.fluttermix.com/documentation/mix/guides/design-token),
  [animation](https://www.fluttermix.com/documentation/mix/guides/animations).
- [Grid layout](packages/mix/doc/grid-layout.md),
  [scope and theming](packages/mix/doc/mix-scope-and-theming.md),
  [token migration](packages/mix/doc/token-migration-guide.md).
- [MixWidget constructors](guides/mix-widget-variant-constructors.md),
  [protocol integration](packages/mix_protocol/GUIDE.md),
  [protocol publishing](guides/publishing_mix_protocol.md).

## Contribute

Read [AGENTS.md](AGENTS.md) for setup, commands, generated-file rules and
verification. Dependencies are bootstrapped with Melos.
The [website source](https://github.com/btwld/mix-docs) lives separately.

The [Mix agent skill](skills/mix/SKILL.md) includes portable API references.
Install it in a consuming project with:

```bash
npx skills add btwld/mix --skill mix -y
```

[Contributors](https://github.com/btwld/mix/graphs/contributors)
