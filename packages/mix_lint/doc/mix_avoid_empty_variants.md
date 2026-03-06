### mix_avoid_empty_variants

Don't create a Styler that only has `.on` variant methods (e.g. `.onHovered`, `.onDark`, `.onPressed`). Always include base styling so the style has a default appearance; then add variants for overrides.

#### Don't

```dart
// Styler with only variant methods, no base style
final style = BoxStyler()
    .onHovered(BoxStyler().color(Colors.blue))
    .onPressed(BoxStyler().color(Colors.green));
```

#### Do

```dart
final style = BoxStyler()
    .color(Colors.grey)
    .onHovered(BoxStyler().color(Colors.blue))
    .onPressed(BoxStyler().color(Colors.green));
```