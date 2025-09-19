# AI Usage Guide

## Overview
Mix is a Flutter styling system that separates style semantics from widgets while maintaining an easy-to-understand relationship. It provides a comprehensive set of utilities and components for consistent and expressive styling.

## Constraints
mix: 1.7.0

## Widgets Categories and Examples

### 1. Box Widget
- **Box**: Equivalent to a container.
  - **Example**: `lib/src/specs/box/box_widget.dart`
  

### 2. Text Widget
- **StyledText**: Equivalent to a Text.
  - **Example**: `lib/src/specs/text/text_widget.dart`

### 3. Icon Widget
- **StyledIcon**: Equivalent to a Icon.
  - **Example**: `lib/src/specs/icon/icon_widget.dart`

### 4. Flex Widget
- **HBox/VBox/FlexBox**: Horizontal and vertical layout with containers.
  - **Example**: `lib/src/specs/flexbox/flexbox_widget.dart`

### 5. Stack Widget
- **ZBox**: Equivalent to a Stack, used for layering widgets on top of each other.
  - **Example**: `lib/src/specs/stack/zbox_widget.dart`

### 6. Image Widget
- **StyledImage**: Equivalent to an Image.
  - **Example**: `lib/src/specs/image/image_widget.dart`

## Utilities for Styling in Mix

Mix provides a set of utility functions to style widgets effectively. These utilities are prefixed with `$` to denote their association with Mix's styling system.

### Box Utilities
- **$box**: Used for styling container-like widgets.

### Text Utilities
- **$text**: Used for styling text elements.

### Icon Utilities
- **$icon**: Used for styling icon elements.

### Flex Utilities
- **$flex**: Used for layout styling in flex containers.

### Image Utilities
- **$image**: Utilized for styling image elements, allowing for consistent and expressive image customization.

### Stack Utilities
- **$stack**: Used for styling stack-like widgets.

### Context-Based Variants
- **$on**: Used for conditional styling based on context or state.
  - **Hover**: `$on.hover($box.color.blue(700))` changes color on hover.
  - **Press**: `$on.press($box.color.blue(900))` changes color on press.
  - **Dark Mode**: `$on.dark($box.color.black())` applies styles in dark mode.

### Widget Modifiers
- **$box.modifier**: Used for applying modifiers to widgets.
  - **Scale**: `$box.modifier.scale(1.2)` scales the widget.
  - **Opacity**: `$box.modifier.opacity(0.7)` sets the widget's opacity.

These utilities allow for a highly customizable and consistent styling approach across your Flutter application using Mix. By leveraging these utilities, you can create complex styles that are easy to maintain and extend.

## Styling and Customization

All Mix components support extensive customization through their respective style classes. For example, you can customize the `Box` using `Style` and $box utility to change colors, padding, and border radius.

### Basic Styling Pattern

```dart
final style = Style(
    $box
        ..padding(16)
        ..color.blue()
        ..borderRadius(8),
  );

// Mix approach
Box( // Use Box instead of Container
  style: style,
  child: StyledText('Hello World'), // Use StyledText for consistent Mix styling
)
```

> **Note**: When using Mix, prefer Mix widgets (StyledText, StyledIcon, HBox, VBox, FlexBox) over native Flutter widgets (Text, Icon, Row, Column, Flex) for consistent styling and inheritance behavior.

### Extract Repeated Styles:
Extract repeated styles as constants or static fields within your widgets to promote reusability and maintainability.

```dart 
static final aStyle = Style(
    $box
        ..padding(16),
        ..borderRadius(12),
        ..color.white(),
        ..elevation(2),
    $on.hover($box.elevation(4)),
);

static final bStyle = Style(
    $box.color.blue(),
)
```

### Leverage Design Tokens:
Define reusable design tokens for colors, typography, spacing, and radii to ensure consistency across your application.

```dart
// Button styles
final primaryButton = Style(
  $box.padding(12, 24),
  $box.color.blue(),
  $box.borderRadius(8),
  $text.style.color.white(),
  $text.style.fontWeight.w600(),
  $on.hover($box.color.blue(700)),
  $on.press($box.color.blue(900)),
);

final secondaryButton = Style(
  $box.padding(12, 24),
  $box.borderRadius(8),
  $box.border.all.color.blue(),
  $box.border.all.width(2),
  $text.style.color.blue(),
  $text.style.fontWeight.w600(),
  $on.hover($box.color.blue(50)),
);

// Typography
final h1 = Style(
  $text.style.fontSize(32),
  $text.style.fontWeight.bold(),
);

final h2 = Style(
  $text.style.fontSize(24),
  $text.style.fontWeight.w600(),
);

final body = Style(
  $text.style.fontSize(16),
  $text.style.height(1.5),
);

final caption = Style(
  $text.style.fontSize(14),
  $text.style.color.gray(600),
);
```

## Constraints
### Avoid Inline Styles:
Avoid using inline styles directly within widgets. Instead, define styles separately and reference them.

```dart
// Don't
Box(
    style: Style(
        $box.height(100)
        $box.width(100)
        $box.color.red()
    )
)

// Do
final style = Style(
    $box.height(100)
    $box.width(100)
    $box.color.red()
);

Box(
    style: style,
)
```

### Limit Complexity in a Single Style:
Keep individual styles simple and focused. If a style becomes too complex, consider breaking it down into smaller, reusable parts.

```dart
// Don't
final complexStyle = Style(
  $box.padding(16),
  $box.borderRadius(12),
  $box.color.white(),
  $box.elevation(2),
  $on.hover($box.elevation(4)),
  $text.style.fontSize(20),
  $text.style.fontWeight.bold(),
  $text.style.color.green(600),
  $text.style.fontSize(16),
  $text.style.fontWeight.w500(),
);

// Do
final itemCardStyle = Style(
  $box.padding(16),
  $box.borderRadius(12),
  $box.color.white(),
  $box.elevation(2),
  $on.hover($box.elevation(4)),
);

final priceTextStyle = Style(
  $text.style.fontSize(20),
  $text.style.fontWeight.bold(),
  $text.style.color.green(600),
);

final titleTextStyle = Style(
  $text.style.fontSize(16),
  $text.style.fontWeight.w500(),
);

final combinedStyle = Style(
    itemCardStyle,
    priceTextStyle,
    titleTextStyle,
)
```

### Avoid Overlapping Styles:
Ensure that styles do not conflict or overlap in ways that could lead to unexpected behavior.

```
// Define simple, focused styles
final buttonBaseStyle = Style(
  $box.padding(12, 24),
  $box.borderRadius(8),
  $text.style.fontWeight.w600(),
);

final primaryButtonStyle = Style.combine([
  buttonBaseStyle,
  Style(
    $box.color.blue(),
    $text.style.color.white(),
    $on.hover($box.color.blue(700)),
    $on.press($box.color.blue(900)),
  ),
]);

final secondaryButtonStyle = Style.combine([
  buttonBaseStyle,
  Style(
    $box.border.all.color.blue(),
    $box.border.all.width(2),
    $text.style.color.blue(),
    $on.hover($box.color.blue(50)),
  ),
]);
```