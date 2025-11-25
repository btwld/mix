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

## License

See the [Mix repository](https://github.com/btwld/mix) for license information.
