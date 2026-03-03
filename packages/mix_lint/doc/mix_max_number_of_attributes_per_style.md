### mix_max_number_of_attributes_per_style

Limit the number of attributes per style. The default value is 15. This rule encourages keeping styles concise and focused; split large styles into smaller, reusable Stylers and compose with `merge()`.

The rule reports when a `Styler` constructor or a variant-style invocation has more than `max_number` arguments.

#### Don't

```dart
// One large style with too many arguments (exceeds max_number)
final style = BoxStyler()
    .color(Colors.blue)
    .paddingAll(8)
    .margin(.all(4))
    .alignment(.center)
    .borderRounded(8)
    .width(200)
    .height(100)
    .opacity(0.9)
    .onHovered(BoxStyler()
        .color(Colors.red)
        .paddingAll(12)
        .margin(.all(6))
        .borderRounded(10)
        .width(220)
        .height(120)
        .opacity(1.0));
```

#### Do

```dart
final layout = BoxStyler()
    .paddingAll(8)
    .margin(.all(4))
    .alignment(.center);

final appearance = BoxStyler()
    .color(Colors.blue)
    .borderRounded(8)
    .width(200)
    .height(100)
    .opacity(0.9);

final hovered = BoxStyler()
    .color(Colors.red)
    .paddingAll(12)
    .margin(.all(6))
    .borderRounded(10)
    .width(220)
    .height(120)
    .opacity(1.0);

final style = layout
    .merge(appearance)
    .onHovered(hovered);
```

#### Parameters

##### max_number (int)

The maximum number of attributes allowed per style (or per variant invocation). The default value is 15.
