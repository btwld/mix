# Examples

Start with a small current-version pattern, then inspect runnable sources for
complete app setup:

```dart
import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

final action = BoxStyler()
    .color(Colors.blue)
    .padding(.horizontal(24).vertical(12))
    .borderRadius(.circular(8))
    .onHovered(.color(Colors.blue.shade700))
    .onPressed(.scale(0.98))
    .animate(.easeInOut(150.ms));

final button = action.pressable(
  onPress: () {},
  child: TextStyler().color(Colors.white).fontWeight(.bold)('Save'),
);
```

- [Showcase](https://github.com/btwld/mix/tree/main/examples/showcase): widgets,
  interaction snacks, responsive layouts and charts.
- [Layouts](https://github.com/btwld/mix/blob/main/examples/showcase/docs/layouts.md):
  Grid and Wrap use cases with source links.
- [Charts](https://github.com/btwld/mix/tree/main/packages/mix_chart/example):
  stable IDs, labels, tooltips and animation ownership.
- [Winds](https://github.com/btwld/mix/tree/main/packages/mix_winds/example):
  utility strings, typed runtime layout and CSS parity fixtures.

Use [tokens](design-tokens.md) for themed values and [layout](layout.md) for
primitive selection. Confirm the resolved Mix version before copying main's
examples into an app.
