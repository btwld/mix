# mix_winds

> **Warning**
> This package is **highly experimental** and should be considered a **proof of concept**. The API is unstable and subject to breaking changes without notice. Use at your own risk in production environments.

Current release channel: **`0.1.0-alpha.1`** (experimental alpha).

Tailwind-like class utilities mapped to [Mix](https://pub.dev/packages/mix) 2.0 stylers.

> **Renamed from `mix_tailwinds`**
> This package was published as [`mix_tailwinds`](https://pub.dev/packages/mix_tailwinds)
> through `0.0.1-alpha.1` and is now `mix_winds`. To migrate, rename the
> dependency and replace `package:mix_tailwinds/mix_tailwinds.dart` imports with
> `package:mix_winds/mix_winds.dart`. No public API symbol changed — the `Tw*`
> types and the functional `div`/`span`/`button` API keep their names.

## Overview

`mix_winds` provides a familiar Tailwind CSS-like syntax for styling Flutter widgets using the Mix styling system. It allows you to use class name strings like `flex flex-col gap-4 p-6 bg-white rounded-lg` to style your widgets.

## Installation

```yaml
dependencies:
  mix_winds: 0.1.0-alpha.1
```

For unreleased changes, use the git reference:

```yaml
dependencies:
  mix_winds:
    git:
      url: https://github.com/btwld/mix.git
      path: packages/mix_winds
```

## Usage

The class-first functional API keeps each Tailwind utility string beside its
content and returns the corresponding concrete widget:

```dart
import 'package:mix_winds/mix_winds.dart';

final card = div(
  'flex flex-col gap-4 rounded-lg bg-white p-6 shadow-lg',
  [
    h2('text-2xl font-bold text-gray-900', 'Hello World'),
    button(
      'rounded-lg bg-blue-600 px-4 py-2 hover:bg-blue-700',
      [span('font-medium text-white', 'Save')],
      onPressed: () {},
    ),
  ],
);
```

All functions require a non-null class string; pass `''` when an element has no
utilities. Their signatures and concrete return types are:

| Element | Functional API | Returns |
|---|---|---|
| Container/structural element | `div(String classNames, [List<Widget> children = const []])` | `Div` |
| Paragraph | `p(String classNames, String text)` | `P` |
| Inline text | `span(String classNames, String text)` | `Span` |
| Headings | `h1` through `h6` with `(String classNames, String text)` | `H1` through `H6` |
| Button | `button(String classNames, List<Widget> children, {required VoidCallback? onPressed, String? semanticsLabel})` | `Button` |
| Icon | `twIcon(String classNames, IconData icon, {String? semanticLabel})` | `TwIcon` |
| Truncated paragraph | `truncatedP(String classNames, String text)` | `TruncatedP` |

These convenience functions are intentionally non-const and forward only the
arguments shown above. Use the uppercase constructors as the advanced and
const-capable escape hatch for keys, configuration, diagnostics, single-child
composition, focus/controller options, long press, and other widget-specific
settings:

```dart
Button(
  key: const ValueKey('save-button'),
  classNames: 'px-4 py-2 rounded-lg bg-blue-600 hover:bg-blue-700 '
      'focus-visible:bg-blue-700 active:bg-blue-800',
  onPressed: () {},
  child: const Span(text: 'Save', classNames: 'text-white font-medium'),
)
```

Use `button` or `Button` for HTML button counterparts so hover, press, keyboard,
focus, semantics, and disabled state share one interaction owner. `Button`
accepts the same child/flex/config/diagnostic options as `Div` and forwards Mix
`Pressable` interaction options. It always exposes button semantics;
`onPressed: null` disables it unless `onLongPress` supplies an action. CSS
margin remains outside its visual, semantic, and tappable border box. Use
`div` or `Div` for structural elements and non-button tags such as links.

Visible `span`/`Span` text automatically becomes the accessible button name.
Omit `semanticsLabel` when child text already names the control because Mix
combines explicit and descendant labels; reserve it for icon-only or otherwise
nonverbal children.

## Portable Style Output

`mix_winds` compiles Tailwind classes to typed Mix stylers but does not own or
depend on the Mix wire format. Applications that need portable JSON opt into
`mix_protocol` themselves. Add `mix_protocol: ^1.0.0-alpha.0` as a direct
dependency, then encode the compiled styler at the application boundary:

```dart
import 'package:mix_protocol/mix_protocol.dart';
import 'package:mix_winds/mix_winds.dart';

final result = TwParser().compileBox(
  'w-40 rounded-lg bg-blue-500 p-4 hover:bg-blue-600',
);
final encoded = mixProtocol.encodeStyle(result.styler);
```

The same pattern applies to `compileFlex`, `compileText`, and `compileIcon`.
Inspect `result.diagnostics` before accepting user-authored classes and always
handle `MixProtocolFailure` from the codec. Protocol vocabulary support is
separate from `requiresWidgetRuntime`. Protocol v1 encodes `FocusVisibleVariant`
as `context_focus_visible`. When
`requiresWidgetRuntime` is true, even a successfully encoded styler is not the
complete behavior; render the same classes with a `mix_winds` widget so its
Flutter layout plan is evaluated. JSON is a consumer boundary representation,
not an intermediate representation inside `mix_winds`.

## Supported Tokens

This proof of concept supports a subset of Tailwind CSS utilities including:

- **Layout**: `flex`, `flex-row`, `flex-col`, `items-*`, `justify-*`, `gap-*`
- **Spacing**: `p-*`, `px-*`, `py-*`, `m-*`, `mx-*`, `my-*`
- **Sizing**: `w-*`, `h-*`, `min-w-*`, `min-h-*`
- **Typography**: `text-*`, `font-*`, `leading-*`, `tracking-*`
- **Colors**: `bg-*`, `text-*`, `border-*`
- **Borders**: `border`, `border-*`, `rounded-*`
- **Effects**: `shadow-*`
- **Responsive**: `sm:`, `md:`, `lg:`, `xl:`, `2xl:` prefixes

## Limitations

As an experimental proof of concept:

- Not all Tailwind utilities are implemented
- Some utilities may behave differently than their CSS counterparts
- Performance has not been optimized for production use
- The API may change significantly in future versions

## Semantic Differences from Tailwind CSS

For the authoritative list of Tailwind ↔ Flutter behavioral differences and recommended workarounds, see `FLUTTER_ADAPTATIONS.md`. This README focuses on the surface API and supported tokens to avoid duplication.

For default typography parity guidance (Tailwind base defaults vs Flutter `TwScope`/`MixScope`), see the "Default Typography Parity" section in `FLUTTER_ADAPTATIONS.md`.

### Flex Item Tokens

Flex item tokens (`flex-1`, `flex-auto`, `flex-none`, `basis-*`, `self-*`, `shrink-*`) are handled at the widget layer, not the parser layer.

| Token | Supported Values | Notes |
|-------|------------------|-------|
| `flex-1`, `flex-auto`, `flex-initial`, `flex-none` | ✅ Supported | Maps to Flutter flex behavior; owned Tailwind flex containers reserve unequal non-content size for zero-basis growers when positive content space remains |
| `basis-*` | Spacing scale only (e.g., `basis-32`) | Unsupported fractional, full, arbitrary, and unknown values are no-ops reported through `onDiagnostic` |
| `self-start`, `self-center`, `self-end` | ✅ Supported | Cross-axis alignment |
| `shrink`, `shrink-0` | ✅ Supported | Controls shrink behavior |

**Important**: Flex item tokens are handled at the widget layer rather than as
Mix styler properties. Supported values stay quiet; unsupported `basis-*`
values such as `basis-1/2` are reported through `onDiagnostic`.

## Custom Configuration

`TwConfig.standard()` is generated from the checked-in Tailwind CSS 4.3.1
theme snapshot and contains stock Tailwind defaults only. Add product aliases
explicitly rather than relying on fixture-specific values:

You can customize defaults and provide config with `TwScope`:

```dart
TwScope(
  config: TwConfig.standard().copyWith(
    colors: {
      ...TwConfig.standard().colors,
      'brand-500': Color(0xFF8B5CF6),
      'brand-600': Color(0xFF7C3AED),
    },
    textDefaults: TwConfig.standard().textDefaults.copyWith(
      fontFamily: 'Inter',
      fontSize: 16,
    ),
  ),
  child: MyApp(),
)
```

Descendant `Div` and `Span` widgets automatically use this config, and typography defaults are applied via Mix `TextScope` (without `ThemeData.textTheme` overrides).

When intentionally updating the pinned upstream theme, regenerate and verify
the snapshot from the visual-comparison tool directory:

```bash
npm run update:theme-snapshot
cd ../..
dart run tool/gen_registry.dart --check
```

To use native platform defaults (no explicit `sans-serif` override):

```dart
TwScope(
  config: TwConfig.standard().copyWith(
    textDefaults: const TwTextDefaults.platformDefault(),
  ),
  child: MyApp(),
)
```

## Handling Unsupported Tokens

The `Div` widget accepts an `onDiagnostic` callback to explain unrecognized,
unsupported, and intentionally ignored Tailwind classes:

```dart
Div(
  classNames: 'flex gap-4 unknown-class',
  onDiagnostic: (diagnostic) {
    debugPrint(
      '${diagnostic.code}: ${diagnostic.token} — ${diagnostic.reason}',
    );
  },
  children: [...],
)
```

This callback receives:
- The original class token, including variant prefixes when present
- A stable `TwDiagnosticCode` plus a human-readable reason
- An optional supported workaround
- Tokens that cannot be mapped to Mix stylers, unsupported widget-layer values,
  and adaptations intentionally ignored by Flutter
- It's safe to throw from this callback (will surface during development)

Supported flex item tokens (`flex-*`, `basis-*`, `self-*`, `shrink-*`, and
`grow-*`) do not trigger `onDiagnostic`.

The token-only `onUnsupported` callback and `TokenWarningCallback` typedef remain
as deprecated compatibility shims. New code should use `onDiagnostic`.

## License

See the [Mix repository](https://github.com/btwld/mix) for license information.
