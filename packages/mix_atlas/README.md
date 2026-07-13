# mix_atlas

`mix_atlas` renders every component variant and scenario into deterministic
contact sheets for human review, Flutter golden tests, and AI inspection.
Atlases are executable Flutter widget code: there is no schema generator, knob
panel, or simulated pointer interaction.

## Install

Add the package next to Mix (and Remix when your design system uses it):

```yaml
dependencies:
  mix: ^2.2.0
  mix_atlas: ^0.1.0
```

Import `package:mix_atlas/mix_atlas.dart` from app, example, or fixture code.
Import `package:mix_atlas/golden.dart` only from tests and
`flutter_test_config.dart` because that entrypoint depends on `flutter_test`.

## How state forcing works

Each cell installs a styling-only widget-state override. Mix `StyleBuilder`
uses the scenario states when resolving normal component `style` parameters,
even if a `Pressable`, Naked UI component, or explicit state controller adds a
nearer interaction provider. The component still builds normally, so its
defaults and complete style-resolution path remain active.

Widget states and structural component properties are different:

- `hovered`, `pressed`, `focused`, and `disabled` activate Mix style variants.
- `loading`, `selected`, `checked`, `open`, and similar constructor properties
  must be mapped from `AtlasCellContext` by the row builder.
- `styleSpec` is not required. `cell.resolve(context, style)` remains available
  as an advanced eager-resolution escape hatch.

## Copyable setup

The normal setup is three small files. Keep a catalog in app/example code when
the live viewer also imports it; keep a test-only catalog under `test/support`.

### 1. `test/support/component_catalog.dart`

```dart
import 'package:flutter/material.dart';
import 'package:mix/mix.dart';
import 'package:mix_atlas/mix_atlas.dart';

final buttonStyle = BoxStyler()
    .size(112, 40)
    .alignment(.center)
    .borderRounded(10)
    .color(const Color(0xff3157d5))
    .onHovered(.color(const Color(0xff2447bc)))
    .onPressed(.color(const Color(0xff193695)))
    .onDisabled(.color(const Color(0xff8b909c)));

final componentCatalog = AtlasCatalog(
  id: 'app-components',
  themes: [
    AtlasTheme(
      'light',
      background: const Color(0xfff4f6fa),
      builder: (_, child) => child, // Wrap with your token scope here.
    ),
    AtlasTheme(
      'dark',
      brightness: Brightness.dark,
      background: const Color(0xff151821),
      builder: (_, child) => child,
    ),
  ],
  atlases: [
    ComponentAtlas(
      id: 'button',
      rowAxes: const [AtlasAxis('tone', 'Tone')],
      scenarios: const [
        ...AtlasScenarios.interactive,
        AtlasScenario('loading', props: {'loading': true}),
      ],
      rows: [
        AtlasRow(
          'primary',
          (context, cell) {
            final loading = cell.propOr('loading', false);
            return Pressable(
              enabled: !cell.disabled && !loading,
              onPress: cell.disabled || loading ? null : () {},
              child: Box(
                style: buttonStyle, // Normal component style API.
                child: StyledText(loading ? 'Loading…' : 'Button'),
              ),
            );
          },
          values: const {
            'tone': AtlasAxisValue('primary', 'Primary'),
          },
        ),
      ],
    ),
  ],
);
```

Rows are component variants. Scenarios are columns. Ordered `rowAxes` describe
variant, size, density, or tone: with one axis its value labels each row; with
multiple axes every axis except the last creates section headers.

### 2. `test/flutter_test_config.dart`

```dart
import 'dart:async';
import 'dart:io';

import 'package:mix_atlas/golden.dart';

Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  if (!Platform.environment.containsKey('CI')) {
    AtlasGoldens.precisionTolerance = 0.0001;
  }
  configureAtlasGoldenComparator();
  await loadAtlasFonts();
  await testMain();
}
```

The comparator writes artifacts reliably and the font loader uses Flutter's
Roboto and Material Icons files instead of the block test font. The optional
local tolerance still compares the full image while absorbing a tiny number of
host macOS text-rasterization pixels; CI stays byte-exact at the default zero.

### 3. `test/component_atlas_golden_test.dart`

```dart
import 'package:mix_atlas/golden.dart';

import 'support/component_catalog.dart';

void main() {
  registerAtlasCatalogGoldens(componentCatalog);
}
```

Generate and compare with Flutter's ordinary golden workflow:

```sh
flutter test test/component_atlas_golden_test.dart --update-goldens
flutter test test/component_atlas_golden_test.dart
```

Generation is `flutter test --update-goldens`. It is not `build_runner`, and
`mix_atlas` does not provide a package binary or custom CLI.

Commit every generated file:

```text
test/goldens/catalog.json
test/goldens/light/button.json
test/goldens/light/button.png
test/goldens/dark/button.json
test/goldens/dark/button.png
```

Normal tests compare canonical JSON exactly on every OS. PNGs are generated
and compared only on `AtlasGoldens.platforms` (macOS by default), because OS,
Flutter version, and font rasterization affect image bytes. Pin Flutter in
local development and CI, load the same fonts, and run the PNG job on one
canonical OS. An update should be followed by a normal run and a second update
that leaves `test/goldens` unchanged.

## Mix and Remix components

Return any widget from an `AtlasRow`. A Mix component uses its normal styler:

```dart
AtlasRow('primary', (context, cell) => PressableBox(
  enabled: !cell.disabled,
  onPress: cell.disabled ? null : () {},
  style: buttonStyle,
  child: const StyledText('Button'),
));
```

Remix works through the same Mix `StyleBuilder` contract; `mix_atlas` does not
depend on Remix:

```dart
AtlasRow('primary', (context, cell) => RemixButton(
  label: 'Button',
  enabled: !cell.disabled,
  loading: cell.propOr('loading', false),
  onPressed: cell.disabled ? null : () {},
  style: remixButtonStyle,
));
```

For an unusual component that intentionally accepts a pre-resolved spec, the
optional escape hatch is:

```dart
styleSpec: cell.resolve(context, buttonStyle)
```

Prefer `style`; eager specs bypass normal component style resolution.

## Live viewer and overlays

The same catalog can power a local viewer:

```dart
MaterialApp(home: AtlasCatalogViewer(catalog: componentCatalog))
```

The responsive viewer preserves declared catalog order and includes keyboard
search (`/` to focus and Escape to clear), compact navigation, theme controls,
and an atlas-details popover. Its non-interactive `AtlasStoryCanvas` presents
each scenario as a story and places values from the final row axis side by side
for quick comparison. The canonical `AtlasView` row-by-scenario grid remains
the source for generated golden artifacts.

`AtlasStoryCanvas` can also be embedded directly when an application supplies
its own catalog shell:

```dart
AtlasStoryCanvas(atlas: buttonAtlas, theme: lightTheme)
```

Wrap bounded menu, dialog, tooltip, or popover fixtures in `AtlasOverlayHost`
so their local `Navigator` and `Overlay` stay inside both the viewer canvas and
the golden repaint boundary. Overlay fixtures need a deterministic initial-open
or controller API; pointer gestures are not captured by the atlas.

## AI inspection workflow

1. Read `goldens/catalog.json` and select a component/theme pair.
2. Read its JSON sidecar for stable row axes, scenarios, states, and props.
3. Open the referenced PNG at original resolution.
4. Check labels, state colors, theme behavior, clipping, overflow, spacing, and
   unexpected diffs.
5. Use the live viewer only as supplemental evidence.

JSON props must contain only finite numbers, strings, booleans, null, lists,
and string-keyed maps. Metadata generation reports the scenario and nested prop
key when it encounters an unsupported value.

## Limitations

- Atlas states affect style resolution only; they do not synthesize real
  pointer, keyboard, focus, gesture, animation, or semantic events.
- Builders must map structural properties such as `enabled`, `loading`,
  `selected`, and `open` themselves.
- Animated and overlay examples need an explicit deterministic frame/open
  contract before they are suitable for committed goldens.
- PNG baselines are platform-specific; JSON metadata is platform-independent.
