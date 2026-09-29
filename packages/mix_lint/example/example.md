# mix_lint example

Enable the plugin and the lints in `analysis_options.yaml`:

```yaml
plugins:
  mix_lint:
    version: ^2.0.0
    diagnostics:
      base_style_after_variant: true
      inline_token_definition: true
      long_styler_chain: true
      unnecessary_styler_constructor: true
      unnecessary_type_name: true
      variants_without_base_style: true
```

With that config, the analyzer reports each commented line below:

```dart
import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';

final $primary = ColorToken('primary');

// variants_without_base_style
final hoverOnly = BoxStyler().onHovered(.color(Colors.blue));

// base_style_after_variant
final card = BoxStyler()
    .color(Colors.white)
    .onHovered(.color(Colors.blue))
    .padding(.all(16));

// unnecessary_styler_constructor (quick fix: `.onHovered(.color(...))`)
final button = BoxStyler()
    .color(Colors.white)
    .onHovered(BoxStyler().color(Colors.blue));

// unnecessary_type_name (quick fix: `.all(16)`)
final padded = BoxStyler().padding(EdgeInsetsGeometryMix.all(16));

// inline_token_definition
final accent = BoxStyler().color(ColorToken('accent')());

// token_reference_outside_mix (a warning, on by default)
final swatch = Container(color: $primary());
```
