---
name: mix-coding
description: >
  Use this skill whenever the user asks to write, review, debug, fix, migrate,
  or modernize Flutter code using Mix; mentions package:mix, Mix 2.0,
  BoxStyler, TextStyler, IconStyler, ImageStyler, MixScope, design tokens,
  variants, animations, Box, FlexBox, RowBox, ColumnBox, StackBox, StyledText,
  StyledIcon, StyledImage, Pressable, PressableBox, or stale examples with HBox,
  VBox, ZBox, docs preview APIs, MixScopeConfig, KeyframeAnimationBuilder, or
  PhaseAnimationBuilder. This skill helps produce source-aligned Mix code
  instead of guessing at API names.
---

# Mix Coding

Use this skill to write or review app-level Flutter code that consumes Mix 2.0.
Mix separates widget semantics from style semantics through Specs, Stylers, and
styled widgets.

This is a source-aligned skill. Before giving non-trivial Mix code, load the
smallest relevant reference file and follow its examples.

## Core Rules

1. Import Mix and Flutter material/widgets as needed:
   ```dart
   import 'package:flutter/material.dart';
   import 'package:mix/mix.dart';
   ```

2. Use Stylers, not Specs, in application code.
   ```dart
   final cardStyle = BoxStyler()
       .color(Colors.white)
       .paddingAll(16)
       .borderRounded(12);
   ```

3. Prefer fluent chaining and named style variables. Inline one short style is
   fine, but move multi-property styles into variables so variants and
   composition stay readable.

4. Use dot shorthands where they make code clearer. The repo targets Dart
   `>=3.11.0`, so values like `.center`, `.bold`, `.horizontal`, `.dark`, and
   `.easeInOut(220.ms)` are valid when the target type is known.

5. Use current widget names:
   - Box/container: `Box`
   - Flex layout: `FlexBox`, `RowBox`, `ColumnBox`
   - Stack layout: `StackBox`
   - Text/icon/image: `StyledText`, `StyledIcon`, `StyledImage`
   - Interaction: `Pressable`, `PressableBox`

6. Do not invent aliases or old docs-preview APIs. If a prompt contains stale
   names, modernize them before answering.

## Reference Routing

Load only the reference files needed for the user's task.

| User needs | Read |
|---|---|
| Box/Text/Icon/Image styling, spacing, borders, shadows, gradients | `references/styling.md` |
| Hover, press, focus, disabled, dark/light, responsive, platform variants | `references/variants.md` |
| `MixScope`, tokens, semantic colors/spacing/typography | `references/tokens.md` |
| Choosing widgets or constructor shapes | `references/widgets.md` |
| `.animate`, `.keyframeAnimation`, `.phaseAnimation` | `references/animations.md` |
| Full patterns to copy or adapt | `references/examples.md` |

When a request spans more than one area, read 1-2 references. Example: a themed
hover button usually needs `styling.md`, `variants.md`, and maybe `tokens.md`;
prefer the two most relevant and inspect source if details remain unclear.

## Output Habits

- Provide complete snippets when the user asks to build something.
- Keep examples app-level unless the user explicitly asks to extend Mix internals.
- Explain only the Mix-specific choices that matter: which widget, which
  Styler, which variant or token mechanism.
- If the user asks to edit this repo, inspect current source before changing docs or code.

## Common Corrections

| Stale or risky pattern | Current pattern |
|---|---|
| `Container(...)` for Mix-styled surfaces | `Box(style: BoxStyler(...))` |
| `Text(...)` with manual `TextStyle` when Mix styling is requested | `StyledText(..., style: TextStyler(...))` |
| `Icon(...)` with manual size/color when Mix styling is requested | `StyledIcon(icon: ..., style: IconStyler(...))` |
| Old flex aliases | `RowBox`, `ColumnBox`, `FlexBox`, or `StackBox` |
| Old scope configuration helper examples | `MixScope(...)` |
| Animation builder classes for new app examples | Style-level animation APIs |
| Single shadow token references | list-based `ShadowToken` / `BoxShadowToken` refs |

## Quick Pattern

```dart
final buttonStyle = BoxStyler()
    .color(Colors.blue)
    .paddingX(20)
    .paddingY(12)
    .borderRounded(8)
    .animate(.easeInOut(180.ms))
    .onHovered(.color(Colors.blue.shade700))
    .onPressed(.color(Colors.blue.shade900));

final labelStyle = TextStyler()
    .color(Colors.white)
    .fontWeight(.bold);

PressableBox(
  style: buttonStyle,
  onPress: onPress,
  child: StyledText('Save', style: labelStyle),
);
```

## Source Anchors

Use these source paths when the references are not enough:

- `packages/mix/lib/src/specs/box/`
- `packages/mix/lib/src/specs/flexbox/`
- `packages/mix/lib/src/specs/stackbox/`
- `packages/mix/lib/src/specs/text/`
- `packages/mix/lib/src/specs/icon/`
- `packages/mix/lib/src/specs/image/`
- `packages/mix/lib/src/specs/pressable/`
- `packages/mix/lib/src/style/mixins/`
- `packages/mix/lib/src/theme/`
- `packages/mix/test/src/`
