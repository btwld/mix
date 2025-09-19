# Mix Global Utility Accessors API Reference

## Overview
The `spec_util.dart` file provides convenient global accessors for all Mix specification utilities. These global getters create new instances of each utility class, enabling the fluent, chainable API that makes Mix styling intuitive and powerful.

**Import:** `import 'package:mix/mix.dart';`

All global utilities are available after importing the main Mix package.

## Global Utility Accessors

### $box → BoxSpecUtility
Global accessor for box specification utilities providing comprehensive container styling.

```dart
BoxSpecUtility get $box => BoxSpecUtility();
```

**Capabilities:**
- Colors, gradients, and backgrounds
- Borders and border radius
- Padding and margin
- Width, height, and constraints
- Box shadows and decorations
- Transform and alignment
- Widget modifiers and animations

**Common Usage:**
```dart
final styledBox = $box
  .color.blue()
  .padding.all(16)
  .borderRadius.circular(8)
  .shadow.medium();
```

**See:** [BoxSpecUtility API Reference](box/box_util_api.md)

### $text → TextSpecUtility
Global accessor for text specification utilities providing comprehensive typography and text styling.

```dart
TextSpecUtility get $text => TextSpecUtility();
```

**Capabilities:**
- Font family, size, weight, and style
- Text color and background color
- Text decoration (underline, overline, strikethrough)
- Letter spacing, word spacing, and line height
- Text alignment and overflow behavior
- Text transformations and directives
- Accessibility and semantic labels

**Common Usage:**
```dart
final styledText = $text
  .fontSize(18)
  .fontWeight.bold()
  .color.blue()
  .letterSpacing(0.5);
```

**See:** [TextSpecUtility API Reference](text/text_util_api.md)

### $icon → IconSpecUtility
Global accessor for icon specification utilities providing comprehensive icon styling.

```dart
IconSpecUtility get $icon => IconSpecUtility();
```

**Capabilities:**
- Icon color and size
- Icon weight, grade, and optical size (for variable fonts)
- Icon shadows and effects
- Opacity and blend modes
- Accessibility labels
- Animation support

**Common Usage:**
```dart
final styledIcon = $icon
  .color.red()
  .size(24)
  .weight.bold();
```

**See:** [IconSpecUtility API Reference](icon/icon_util_api.md)

### $image → ImageSpecUtility
Global accessor for image specification utilities providing comprehensive image display and styling.

```dart
ImageSpecUtility get $image => ImageSpecUtility();
```

**Capabilities:**
- Image sources (asset, network, file, memory)
- Width, height, and sizing behavior
- Image fitting and alignment
- Color tinting and blend modes
- Image repetition patterns
- Quality and rendering settings
- Accessibility and semantic labels

**Common Usage:**
```dart
final styledImage = $image
  .image.asset('assets/photo.jpg')
  .width(200)
  .height(150)
  .fit.cover()
  .borderRadius.circular(8);
```

**See:** [ImageSpecUtility API Reference](image/image_util_api.md)

### $flex → FlexSpecUtility
Global accessor for flex specification utilities providing flex layout configuration.

```dart
FlexSpecUtility get $flex => FlexSpecUtility();
```

**Capabilities:**
- Flex direction (row/column)
- Main axis and cross axis alignment
- Spacing between children
- Main axis sizing behavior
- Text direction and baseline alignment
- Clipping behavior

**Common Usage:**
```dart
final flexLayout = $flex
  .direction.horizontal()
  .mainAxisAlignment.spaceBetween()
  .crossAxisAlignment.center()
  .spacing(16);
```

**See:** [FlexSpecUtility API Reference](flex/flex_util_api.md)

### $stack → StackSpecUtility
Global accessor for stack specification utilities providing stack layout configuration.

```dart
StackSpecUtility get $stack => StackSpecUtility();
```

**Capabilities:**
- Child alignment within stack
- Stack fit behavior (loose/expand/passthrough)
- Text direction for positioned children
- Clipping behavior
- Overlay and positioning support

**Common Usage:**
```dart
final stackLayout = $stack
  .alignment.center()
  .fit.expand()
  .clipBehavior.hardEdge();
```

**See:** [StackSpecUtility API Reference](stack/stack_util_api.md)

### $flexbox → FlexBoxSpecUtility
Global accessor for flexbox specification utilities combining box styling with flex layout.

```dart
FlexBoxSpecUtility get $flexbox => FlexBoxSpecUtility();
```

**Capabilities:**
- All box styling features (colors, borders, padding, etc.)
- All flex layout features (direction, alignment, spacing)
- Combined visual and layout styling
- Ideal for styled flexible containers

**Common Usage:**
```dart
final styledFlexContainer = $flexbox
  .color.blue().shade100()
  .padding.all(16)
  .borderRadius.circular(8)
  .direction.horizontal()
  .mainAxisAlignment.spaceBetween()
  .spacing(12);
```

**See:** [FlexBoxSpecUtility API Reference](flexbox/flexbox_util_api.md)

## Deprecated Global Utilities

The following global utilities have been deprecated and replaced by spec-specific utilities:

### ~~$on~~ and ~~$wrap~~ (Deprecated)
**⚠️ Deprecated:** Global `$on` and `$wrap` utilities have been replaced by spec-specific utilities.

**Old Pattern (Deprecated):**
```dart
// Don't use these patterns
$on.hover($box.color.red(), $text.color.white())
$wrap.opacity(0.5, $box.padding.all(16))
```

**New Pattern (Recommended):**
```dart
// Use spec-specific utilities instead
$box.color.blue().onHovered($box.color.red())
$text.color.black().onHovered($text.color.white())
$box.padding.all(16).wrap.opacity(0.5)
```

**Benefits of New Pattern:**
- Better type safety
- Eliminates need for MultiSpec
- More intuitive API
- Clearer code organization

## Utility Lifecycle

### Instance Creation
Each global utility accessor creates a **new instance** every time it's called:

```dart
final utility1 = $box;  // New BoxSpecUtility instance
final utility2 = $box;  // Different BoxSpecUtility instance
```

### Mutable Building
Utilities maintain mutable state during the building process:

```dart
final builder = $box;         // Mutable state starts empty
builder.color.red();          // Mutable state updated
builder.padding.all(16);      // Mutable state updated again
final style = builder.build(); // Immutable style created
```

### Immutable Results
The final styles produced are immutable:

```dart
final style = $box.color.blue().padding.all(16);
// `style` is an immutable BoxStyler instance
```

## Architecture Notes

### Utility Pattern
Mix utilities follow the Builder pattern with these characteristics:

1. **Mutable Building Phase**: Utilities accumulate styling properties
2. **Lazy Evaluation**: Sub-utilities are created on-demand
3. **Immutable Results**: Final styles are immutable value objects
4. **Chainable API**: Methods return the utility instance for chaining

### Memory Management
- **Garbage Collection**: Utility instances are garbage collected after use
- **Lazy Properties**: Sub-utilities use `late final` for efficiency
- **Object Pooling**: Not implemented - new instances per accessor call

### Missing Global Accessors
**Note:** Some styler classes exist without corresponding global accessors:

- **StackBoxStyler** - Combines Stack and Box styling but has no `$stackbox` global accessor
- Must be instantiated directly: `StackBoxStyler()` or used via `Style.stackBox()`

### Type Safety
Each utility is strongly typed to prevent mixing incompatible styles:

```dart
// Type safe - BoxStyler methods on BoxSpecUtility
$box.color.red().padding.all(16)  ✓

// Type error - can't mix utilities
$box.color.red() + $text.fontSize(16)  ✗
```

## Usage Patterns

### Basic Styling
```dart
// Simple, single-purpose styling
final redBox = $box.color.red();
final boldText = $text.fontWeight.bold();
final largeIcon = $icon.size(32);
```

### Composed Styling
```dart
// Complex, multi-property styling
final fancyCard = $box
  .color.white()
  .padding.all(20)
  .margin.horizontal(16).margin.vertical(8)
  .borderRadius.circular(12)
  .shadow.large()
  .border.all(color: Colors.grey.shade200);
```

### Conditional Styling
```dart
// Responsive and state-based styling
final responsiveText = $text
  .fontSize(16)
  .color.black()
  .onBreakpoint(Breakpoint.md, $text.fontSize(18))
  .onDark($text.color.white())
  .onHovered($text.color.blue());
```

### Layout Combinations
```dart
// Combining layout and visual styling
final navBar = $flexbox
  .color.blue().shade800()
  .padding.horizontal(24).padding.vertical(12)
  .direction.horizontal()
  .mainAxisAlignment.spaceBetween()
  .crossAxisAlignment.center();
```

## Performance Considerations

### Best Practices
1. **Reuse Complex Styles**: Store complex styles in variables
2. **Avoid Deep Nesting**: Prefer flat utility chains over nested builders
3. **Use Appropriate Utilities**: Choose the most specific utility for your needs
4. **Cache When Possible**: Reuse identical styles across widgets

### Performance Tips
```dart
// Good: Reuse complex styles
final cardStyle = $box.color.white().padding.all(16).shadow.medium();
Widget buildCard1() => cardStyle(child: Text('Card 1'));
Widget buildCard2() => cardStyle(child: Text('Card 2'));

// Less optimal: Recreate styles each time
Widget buildCard1() => $box.color.white().padding.all(16).shadow.medium()(child: Text('Card 1'));
Widget buildCard2() => $box.color.white().padding.all(16).shadow.medium()(child: Text('Card 2'));
```

## Migration Guide

### From Old Global Utilities
If migrating from deprecated global utilities:

```dart
// Old (deprecated)
$on.hover($box.color.red(), $text.color.white())

// New (recommended)
$box.color.blue().onHovered($box.color.red())
$text.color.black().onHovered($text.color.white())
```

### From Direct StyleSpec Usage
If migrating from direct StyleSpec usage:

```dart
// Old (verbose)
BoxStyler(
  decoration: DecorationMix(color: Colors.blue),
  padding: EdgeInsetsGeometryMix.all(16),
  margin: EdgeInsetsGeometryMix.vertical(8),
)

// New (fluent)
$box
  .color.blue()
  .padding.all(16)
  .margin.vertical(8)
```

## Related Documentation

- [BoxSpecUtility API Reference](box/box_util_api.md)
- [TextSpecUtility API Reference](text/text_util_api.md)  
- [IconSpecUtility API Reference](icon/icon_util_api.md)
- [ImageSpecUtility API Reference](image/image_util_api.md)
- [FlexSpecUtility API Reference](flex/flex_util_api.md)
- [StackSpecUtility API Reference](stack/stack_util_api.md)
- [FlexBoxSpecUtility API Reference](flexbox/flexbox_util_api.md)