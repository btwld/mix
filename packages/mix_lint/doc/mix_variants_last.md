### mix_variants_last

Ensures that variant methods (`onHovered`, `onPressed`, `onFocused`, `onDisabled`, `onDark`, etc.) are placed at the bottom of the Styler chain, after all base styling methods. Mixing variant calls between base properties makes the style harder to read and reason about.

#### Don't

```dart
final style = BoxStyler()
    .color(Colors.red)
    .onHovered(.color(Colors.blue))
    .paddingAll(16)
    .borderRounded(8)
    .onPressed(.color(Colors.green));
```

#### Do

```dart
final style = BoxStyler()
    .color(Colors.red)
    .paddingAll(16)
    .borderRounded(8)
    .onHovered(.color(Colors.blue))
    .onPressed(.color(Colors.green));
```
