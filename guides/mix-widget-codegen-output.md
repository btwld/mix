# @MixWidget Codegen Output Guide

This guide shows what `@MixWidget` generates and where each generated
constructor parameter comes from.

## Core Rules

- `key` is always owned by the generated `StatelessWidget`.
- Wrapper parameters come from the styler's concrete `call()` method,
  excluding a named `Key? key` parameter.
- If the styler `call()` method accepts `Key? key`, the generated wrapper
  forwards its own key to it.
- Function factory parameters become generated wrapper constructor
  parameters and are passed back to the factory before `call()` is invoked.
- Factory parameters shape the style only. They do not automatically become
  widget arguments unless the `call()` method also declares matching
  parameters.
- A styler used by `@MixWidget` must expose a non-generic `call()` method that
  returns a Flutter `Widget`.

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
    return cardStyle.call(key: key, child: child);
  }
}
```

What happened:

- `Card` comes from `cardStyle` with the trailing `Style` removed.
- `child` comes from `BoxStyler.call({Widget? child})`.
- The generated build method delegates widget creation to `cardStyle.call`.

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
    return badgeStyle(color: color, style: style).call(
      key: key,
      child: child,
    );
  }
}
```

What happened:

- `color` and `style` come from the `badgeStyle(...)` factory signature.
- `child` comes from `BoxStyler.call`.
- `badgeStyle(color: color, style: style)` creates the final style, then the
  wrapper calls `.call(...)` on that style.

Factory parameters can be positional, named, required, optional, and
defaulted. The generated wrapper mirrors that shape before adding call
parameters.

Example with positional text:

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
    return labelStyle(color: color).call(text, key: key);
  }
}
```

Here `text` comes from `TextStyler.call(String text, {Key? key})`, while
`color` comes from the style factory.

## Custom Styler Call

For widgets outside Mix's built-ins, put the rendering contract on the
styler's `call()` method.

Input:

```dart
import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';
import 'package:mix_annotations/mix_annotations.dart';

part 'button.g.dart';

class ButtonSpec extends Spec<ButtonSpec> {
  const ButtonSpec();
}

class ButtonStyler extends Style<ButtonSpec> {
  const ButtonStyler();

  ButtonStyler color(Color value) => this;
  ButtonStyler merge(ButtonStyler? other) => this;

  Button call({
    Key? key,
    required VoidCallback onPressed,
    required Widget child,
  }) {
    return Button(
      key: key,
      style: this,
      onPressed: onPressed,
      child: child,
    );
  }
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
    return primaryButtonStyle(color: color).call(
      key: key,
      onPressed: onPressed,
      child: child,
    );
  }
}
```

What happened:

- `color` came from the `primaryButtonStyle` factory, so it is routed back
  into the factory.
- `onPressed` and `child` came from `ButtonStyler.call`.
- `key` is forwarded automatically because `ButtonStyler.call` accepts
  named `Key? key`.
- Visual variants like primary/secondary or hover/pressed states belong in
  the styler or factory.

## Styler Call Contract

A styler `call()` method used by `@MixWidget` must:

- Return a Flutter `Widget` subtype.
- Be non-generic.
- Use required positional parameters and named parameters. Optional
  positional parameters are rejected.
- Use named `Key? key` if it wants generated wrapper keys forwarded.

It does **not** need to:

- Match a widget constructor exactly.
- Treat `style` or `styleSpec` specially. They are normal `call()`
  parameters if you declare them.
- Declare anything on the `Spec` class.

## Parameter Collision Rules

- `key` is reserved by the generated widget.
- Factory parameter `style` is allowed and treated as a normal input.
- Duplicate generated names are rejected. For example, a wrapper cannot have
  both a factory parameter named `child` and a `call()` parameter named
  `child`.

## Mental Model

```dart
return styleFactory(...factoryParams).call(
  key: key,
  ...callParams,
);
```

Factory parameters create the style. Styler `call()` parameters create the
widget structure and behavior. The styler `call()` method is the single
source of truth for the wrapper's widget API.
