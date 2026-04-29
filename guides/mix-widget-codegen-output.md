# @MixWidget Codegen Output Guide

This guide shows what `@MixWidget` generates and where each generated
constructor parameter comes from.

## Core Rules

- `key` is always owned by the generated `StatelessWidget`.
- The renderer widget is declared once on the `Spec` class via
  `@MixWidgetRenderer(YourWidget)`. The generator looks it up there and
  mirrors that widget's unnamed constructor onto the wrapper.
- Mix's own specs (`BoxSpec`, `TextSpec`, `FlexBoxSpec`, `IconSpec`,
  `ImageSpec`, `StackBoxSpec`) ship with `@MixWidgetRenderer` annotations,
  so applying `@MixWidget()` to a Mix-built-in styler "just works".
- Wrapper parameters come from the renderer widget's constructor (excluding
  `key`, `style`, `styleSpec`).
- Function factory parameters become generated wrapper constructor
  parameters and are passed back to the factory.
- Factory parameters shape the style only. They do not automatically become
  renderer arguments.

## Variable-Backed Built-In Style

Input:

```dart
import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';
import 'package:mix_annotations/mix_annotations.dart';

part 'card_style.g.dart';

@MixWidget()
final cardStyle = BoxStyler()
    .paddingAll(16)
    .borderRounded(12);
```

Generated output:

```dart
class Card extends StatelessWidget {
  const Card({super.key, this.child});

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Box(key: key, style: cardStyle, child: child);
  }
}
```

What happened:

- `Card` comes from `cardStyle` with the trailing `Style` removed.
- The generator resolved `BoxStyler` → `BoxSpec`, found
  `@MixWidgetRenderer(Box)` on `BoxSpec`, and mirrored `Box`'s constructor.
- `child` comes from `Box({Widget? child})`.
- `style: cardStyle` passes the original top-level styler to `Box`.

## Function-Backed Style With Parameters

Use a function when the generated widget needs inputs that change the style.

Input:

```dart
@MixWidget()
BoxStyler badgeStyle({
  Color? color,
  BoxStyler? style,
}) {
  return BoxStyler()
      .paddingAll(8)
      .borderRounded(999)
      .color(color ?? const Color(0xFF006ADC))
      .merge(style);
}
```

Generated output:

```dart
class Badge extends StatelessWidget {
  const Badge({
    super.key,
    this.color,
    this.style,
    this.child,
  });

  final Color? color;

  final BoxStyler? style;

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Box(
      key: key,
      style: badgeStyle(color: color, style: style),
      child: child,
    );
  }
}
```

What happened:

- `color` and `style` come from the `badgeStyle(...)` factory signature.
- `child` still comes from the `Box` renderer constructor.
- `style` is treated like a normal factory parameter. It is not magic.
- `badgeStyle(color: color, style: style)` creates the final style passed to
  `Box`.

Factory parameters can be positional, named, required, optional, and
defaulted. The generated wrapper mirrors that shape before adding renderer
parameters.

Example with positional text for the built-in text renderer:

```dart
@MixWidget()
TextStyler labelStyle({Color? color}) {
  return TextStyler().color(color ?? const Color(0xFF111111));
}
```

Generated output:

```dart
class Label extends StatelessWidget {
  const Label(this.text, {super.key, this.color});

  final String text;

  final Color? color;

  @override
  Widget build(BuildContext context) {
    return StyledText(text, key: key, style: labelStyle(color: color));
  }
}
```

Here `text` comes from `StyledText(String text)`, while `color` comes from
the style factory.

## Custom Renderer (Spec-Side Annotation)

For widgets outside Mix's built-ins, declare the renderer on the spec class.
That single annotation is enough — no adapter or builder class is required.

Input:

```dart
import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';
import 'package:mix_annotations/mix_annotations.dart';

part 'button.g.dart';

@MixWidgetRenderer(Button)
class ButtonSpec extends Spec<ButtonSpec> {
  const ButtonSpec();
}

class ButtonStyler extends Style<ButtonSpec> {
  const ButtonStyler();

  ButtonStyler color(Color value) => this;
  ButtonStyler merge(ButtonStyler? other) => this;
}

class Button extends StatelessWidget {
  const Button({
    super.key,
    required this.style,
    required this.onPressed,
    required this.child,
  });

  final ButtonStyler style;
  final VoidCallback onPressed;
  final Widget child;

  // ...build()...
}

@MixWidget()
ButtonStyler primaryButtonStyle({Color color = Colors.blue}) {
  return ButtonStyler().color(color);
}
```

Generated output:

```dart
class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    this.color = Colors.blue,
    required this.onPressed,
    required this.child,
  });

  final Color color;
  final VoidCallback onPressed;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Button(
      key: key,
      style: primaryButtonStyle(color: color),
      onPressed: onPressed,
      child: child,
    );
  }
}
```

What happened:

- `color` came from the `primaryButtonStyle` factory, so it's a wrapper
  param routed back into the factory.
- `onPressed` and `child` came from `Button`'s constructor.
- `key` is forwarded automatically.
- `style:` was constructed by calling the factory — no merge or override
  parameter is generated.
- Visual variants like primary/secondary or hover/pressed states belong in
  the styler or factory, not in the renderer's constructor.

## Renderer Widget Contract

A renderer widget must:

- Have an unnamed constructor.
- Declare a `style:` named parameter assignable from `Style<TSpec>` (the
  styler type compatible with the spec).
- Be a Flutter `Widget` subtype.

It does **not** need to:

- Extend `StyleWidget<TSpec>`. Any `StatelessWidget` or `StatefulWidget` that
  takes `style:` works.
- Declare a `styleSpec` parameter. If present, it's reserved and ignored.
- Have a special base class or annotation on the widget itself.

## Parameter Collision Rules

- `key` is reserved by the generated widget.
- `style` and `styleSpec` are reserved on the renderer constructor (the
  generator never mirrors them onto the wrapper).
- Factory parameter `style` is allowed and treated as a normal input.
- Duplicate generated names are rejected. For example, a `Box` wrapper
  cannot have both a factory parameter named `child` and a renderer
  parameter named `child`.

## Mental Model

```dart
return Renderer(
  key: key,
  style: styleFactory(...factoryParams),
  ...rendererParams,
);
```

Factory parameters create the style. Renderer constructor parameters create
the widget structure and behavior. The renderer widget is the single source
of truth for the wrapper's API.
