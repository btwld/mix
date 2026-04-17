---
name: mix-coding
description: "Use when the user asks to write Flutter code using Mix, or mentions Mix styling, BoxStyler, TextStyler, IconStyler, variants, animations, design tokens, or Mix widgets like Box, HBox, VBox, StyledText, StyledIcon, Pressable. Also trigger when user references 'package:mix' or fluent styling in Flutter. This skill ensures Claude writes correct, idiomatic Mix 2.0 code instead of guessing at the API."
---

# Mix 2.0 — Correct Code Patterns

This skill ensures you write correct Mix 2.0 code. Mix separates style semantics from widgets using a **Spec/Style/Widget** pattern with a fluent chaining API.

**This is a rigid skill.** Follow the documented patterns exactly. Do not guess at method names or API shapes — read the relevant reference file first.

## Core Principles

These rules apply to ALL Mix code you write:

1. **Always import Mix:**
   ```dart
   import 'package:mix/mix.dart';
   ```

2. **Use fluent chaining** — styles are built by chaining methods on Stylers:
   ```dart
   final style = BoxStyler()
       .color(Colors.blue)
       .size(100, 100)
       .paddingAll(16)
       .borderRounded(8);
   ```

3. **Specs are immutable, Stylers are builders.** Never construct a Spec directly — always use the corresponding Styler (`BoxStyler`, `TextStyler`, `IconStyler`).

4. **Define styles as variables**, not inline:
   ```dart
   // Correct
   final cardStyle = BoxStyler().color(Colors.white).paddingAll(16);
   Box(style: cardStyle, child: content);

   // Wrong — don't inline complex styles
   Box(style: BoxStyler().color(Colors.white).paddingAll(16), child: content);
   ```

5. **Dart SDK >=3.11.0** — dot-shorthands are enabled (e.g., `.center`, `.bold`, `.topLeft`).

6. **Stylers can be called directly** to create their widget:
   ```dart
   final box = BoxStyler().color(Colors.blue).size(100, 100);
   // These are equivalent:
   Box(style: box);
   box();  // Shorthand — calls the styler to produce a Box
   ```

7. **Factory constructors** allow starting with a property:
   ```dart
   // These are equivalent:
   BoxStyler().color(Colors.blue)
   BoxStyler.color(Colors.blue)
   ```

## Common Mistakes

Avoid these patterns — they are the most frequent errors:

| Wrong | Correct | Why |
|-------|---------|-----|
| `Container(color: ...)` | `Box(style: BoxStyler().color(...))` | Use Mix widgets, not Flutter primitives |
| `Text(style: TextStyle(...))` | `StyledText('...', style: TextStyler().fontSize(...))` | Use StyledText with TextStyler |
| `Icon(Icons.star, size: 30)` | `StyledIcon(icon: Icons.star, style: IconStyler.size(30))` | Use StyledIcon with IconStyler |
| Mutating a styler in place | Chain returns a new styler | Stylers are immutable builders |
| `Theme.of(context).colorScheme` | Use `ColorToken` with `MixScope` | Don't mix Flutter theming with Mix tokens |
| Nesting `Padding`/`Align` widgets | Use `.paddingAll()`, `.alignment()` on styler | Mix handles spacing/alignment via style |

## Reference Routing

Before writing Mix code, **read the relevant reference file(s)** based on what the user needs. Load 1-2 references per request — don't load them all.

| User is asking about... | Read this reference |
|---|---|
| Styling a widget: colors, padding, borders, sizing, gradients, shadows | `references/styling.md` |
| Hover, press, focus, dark/light mode, responsive, disabled, selected | `references/variants.md` |
| Animations, transitions, keyframes, spring physics, phases | `references/animations.md` |
| Design tokens, theming, MixScope, token types | `references/tokens.md` |
| Which widget to use, Box vs FlexBox, layout, Pressable | `references/widgets.md` |
| Need a full working example or pattern reference | `references/examples.md` |

**How to use references:** Read the file with the Read tool, then follow the patterns and API tables in it. The references contain real, verified method signatures and code examples extracted from the Mix codebase.

## Style Composition

Styles compose by merging — later values override earlier ones:

```dart
final base = BoxStyler()
    .paddingX(16)
    .paddingY(8)
    .borderRounded(8)
    .color(Colors.black);

// Override just the color — everything else carries over
final solid = base.color(Colors.blue);
final soft = base.color(Colors.blue.shade100);
```

## Quick Reference: Widget ↔ Styler Mapping

| Widget | Styler | Use for |
|--------|--------|---------|
| `Box` | `BoxStyler` | Container, card, background |
| `RowBox` / `HBox` | `FlexBoxStyler` | Horizontal layout |
| `ColumnBox` / `VBox` | `FlexBoxStyler` | Vertical layout |
| `ZBox` | `FlexBoxStyler` | Stack/overlay layout |
| `StyledText` | `TextStyler` | Styled text |
| `StyledIcon` | `IconStyler` | Styled icon |
| `StyledImage` | `ImageStyler` | Styled image |
| `Pressable` / `PressableBox` | (wraps other styles) | Interactive/tappable |
