# mix_tailwinds

> **Warning**
> This package is **highly experimental** and should be considered a **proof of concept**. The API is unstable and subject to breaking changes without notice. Use at your own risk in production environments.

Tailwind-like class utilities mapped to [Mix](https://pub.dev/packages/mix) 2.0 stylers.

## Overview

`mix_tailwinds` provides a familiar Tailwind CSS-like syntax for styling Flutter widgets using the Mix styling system. It allows you to use class name strings like `flex flex-col gap-4 p-6 bg-white rounded-lg` to style your widgets.

## Installation

```yaml
dependencies:
  mix_tailwinds:
    git:
      url: https://github.com/btwld/mix.git
      path: packages/mix_tailwinds
```

## Usage

```dart
import 'package:mix_tailwinds/mix_tailwinds.dart';

// Use Div for container/box elements
Div(
  classNames: 'flex flex-col gap-4 p-6 bg-white rounded-lg shadow-lg',
  children: [
    Span(
      text: 'Hello World',
      classNames: 'text-2xl font-bold text-gray-900',
    ),
  ],
)
```

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

For default typography parity guidance (Tailwind base defaults vs Flutter `ThemeData`/`MixScope`), see the "Default Typography Parity" section in `FLUTTER_ADAPTATIONS.md`.

### Flex Item Tokens

Flex item tokens (`flex-1`, `flex-auto`, `flex-none`, `basis-*`, `self-*`, `shrink-*`) are handled at the widget layer, not the parser layer.

| Token | Supported Values | Notes |
|-------|------------------|-------|
| `flex-1`, `flex-auto`, `flex-initial`, `flex-none` | ✅ Supported | Maps to Flutter's flex factor and fit |
| `basis-*` | Spacing scale only (e.g., `basis-32`) | Fractional values like `basis-1/2` are **no-ops** |
| `self-start`, `self-center`, `self-end` | ✅ Supported | Cross-axis alignment |
| `shrink`, `shrink-0` | ✅ Supported | Controls shrink behavior |

**Important**: Because flex item tokens are handled at the widget layer (not the parser), they do **not** trigger `onUnsupported` callbacks even when unsupported (like `basis-1/2`).

## Custom Configuration

You can customize the default configuration using `TwConfigProvider`:

```dart
TwConfigProvider(
  config: TwConfig.standard().copyWith(
    colors: {
      ...TwConfig.standard().colors,
      'brand-500': Color(0xFF8B5CF6),
      'brand-600': Color(0xFF7C3AED),
    },
  ),
  child: MyApp(),
)
```

Descendant `Div` and `Span` widgets will automatically use this configuration without needing to pass `config` explicitly.

## Handling Unsupported Tokens

The `Div` widget accepts an `onUnsupported` callback to help identify unrecognized Tailwind classes:

```dart
Div(
  classNames: 'flex gap-4 unknown-class',
  onUnsupported: (token) {
    debugPrint('Unsupported Tailwind token: $token');
  },
  children: [...],
)
```

This callback receives:
- The final token value (base class, not including variant prefixes)
- Only tokens that couldn't be mapped to Mix stylers at the **parser layer**
- It's safe to throw from this callback (will surface during development)

**Note**: Flex item tokens (`flex-*`, `basis-*`, `self-*`, `shrink*`) are handled at the widget layer and **never** trigger `onUnsupported`, even for unsupported values like `basis-1/2`. This is by design.

## License

See the [Mix repository](https://github.com/btwld/mix) for license information.
