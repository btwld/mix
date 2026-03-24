### mix_avoid_defining_tokens_within_style

Ensure that `MixToken` instances are not created directly inside Styler method calls. Define tokens outside the style (e.g. top-level or as local constants), then pass them in.

Tokens are meant to be shared across the app. Creating them inline inside a Styler makes them local to that call and harder to reuse or reference elsewhere.

#### Don't

```dart
// Inline token inside a Styler
final style = BoxStyler()
    .color.ref(ColorToken('primary'))
    .borderRadiusTopLeft(RadiusToken('rounded')());
```

#### Do

```dart
final primary = ColorToken('primary');
final rounded = RadiusToken('rounded');

final style = BoxStyler()
    .color.ref(primary)
    .borderRadiusTopLeft(rounded());
```
