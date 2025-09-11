# FlexSpecUtility API Reference

## Overview
The `FlexSpecUtility` class provides a mutable utility for flex layout styling with cascade notation support in Mix. It maintains mutable internal state enabling fluid styling like `$flex..direction.horizontal()..mainAxisAlignment.spaceBetween()`. This is the core utility class behind the global `$flex` accessor.

**Global Access:** `$flex` → `FlexSpecUtility()`

## Core Utility Properties

### Layout Direction

#### $flex.direction → MixUtility
Controls the main axis direction of the flex layout:
- **$flex.direction(Axis value)** → FlexStyler - Sets flex direction
- **$flex.direction.horizontal()** → FlexStyler - Horizontal layout (row)
- **$flex.direction.vertical()** → FlexStyler - Vertical layout (column)

#### Direct Direction Methods
- **$flex.row()** → FlexStyler - Convenience method for horizontal direction
- **$flex.column()** → FlexStyler - Convenience method for vertical direction

### Main Axis Alignment

#### $flex.mainAxisAlignment → MixUtility
Controls how children are aligned along the main axis:
- **$flex.mainAxisAlignment(MainAxisAlignment value)** → FlexStyler - Sets main axis alignment
- **$flex.mainAxisAlignment.start()** → FlexStyler - Align children to the start of main axis
- **$flex.mainAxisAlignment.end()** → FlexStyler - Align children to the end of main axis
- **$flex.mainAxisAlignment.center()** → FlexStyler - Center children on main axis
- **$flex.mainAxisAlignment.spaceBetween()** → FlexStyler - Space children evenly with no space at ends
- **$flex.mainAxisAlignment.spaceAround()** → FlexStyler - Space children evenly with half space at ends
- **$flex.mainAxisAlignment.spaceEvenly()** → FlexStyler - Space children evenly with equal space everywhere

### Cross Axis Alignment

#### $flex.crossAxisAlignment → MixUtility
Controls how children are aligned along the cross axis:
- **$flex.crossAxisAlignment(CrossAxisAlignment value)** → FlexStyler - Sets cross axis alignment
- **$flex.crossAxisAlignment.start()** → FlexStyler - Align children to start of cross axis
- **$flex.crossAxisAlignment.end()** → FlexStyler - Align children to end of cross axis
- **$flex.crossAxisAlignment.center()** → FlexStyler - Center children on cross axis
- **$flex.crossAxisAlignment.stretch()** → FlexStyler - Stretch children to fill cross axis
- **$flex.crossAxisAlignment.baseline()** → FlexStyler - Align children by text baseline

### Main Axis Size

#### $flex.mainAxisSize → MixUtility
Controls how much space the flex layout should occupy on the main axis:
- **$flex.mainAxisSize(MainAxisSize value)** → FlexStyler - Sets main axis size
- **$flex.mainAxisSize.min()** → FlexStyler - Take up minimum space required
- **$flex.mainAxisSize.max()** → FlexStyler - Take up maximum available space

### Direction & Text Properties

#### $flex.verticalDirection → MixUtility
Controls the order in which children are placed vertically:
- **$flex.verticalDirection(VerticalDirection value)** → FlexStyler - Sets vertical direction
- **$flex.verticalDirection.down()** → FlexStyler - Top to bottom (default)
- **$flex.verticalDirection.up()** → FlexStyler - Bottom to top

#### $flex.textDirection → MixUtility
Controls the order in which children are placed horizontally:
- **$flex.textDirection(TextDirection value)** → FlexStyler - Sets text direction
- **$flex.textDirection.ltr()** → FlexStyler - Left to right
- **$flex.textDirection.rtl()** → FlexStyler - Right to left

#### $flex.textBaseline → MixUtility
Sets the text baseline for baseline alignment:
- **$flex.textBaseline(TextBaseline value)** → FlexStyler - Sets text baseline
- **$flex.textBaseline.alphabetic()** → FlexStyler - Alphabetic baseline
- **$flex.textBaseline.ideographic()** → FlexStyler - Ideographic baseline

### Layout Behavior

#### $flex.clipBehavior → MixUtility
Controls how content is clipped:
- **$flex.clipBehavior(Clip value)** → FlexStyler - Sets clip behavior
- **$flex.clipBehavior.none()** → FlexStyler - No clipping
- **$flex.clipBehavior.hardEdge()** → FlexStyler - Clip with hard edges
- **$flex.clipBehavior.antiAlias()** → FlexStyler - Clip with anti-aliasing
- **$flex.clipBehavior.antiAliasWithSaveLayer()** → FlexStyler - Clip with save layer

### Child Spacing

#### $flex.spacing → MixUtility
Controls spacing between flex children:
- **$flex.spacing(double value)** → FlexStyler - Sets spacing between children in logical pixels
- **$flex.spacing.small()** → FlexStyler - Small spacing (typically 8px)
- **$flex.spacing.medium()** → FlexStyler - Medium spacing (typically 16px)
- **$flex.spacing.large()** → FlexStyler - Large spacing (typically 24px)

### Modifiers & Animation

#### $flex.wrap → ModifierUtility
Provides widget modifiers:
- **$flex.wrap(Modifier value)** → FlexStyler - Applies widget modifier
- **$flex.wrap.opacity(double value)** → FlexStyler - Wraps with opacity modifier
- **$flex.wrap.padding(EdgeInsets value)** → FlexStyler - Wraps with padding modifier
- **$flex.wrap.transform(Matrix4 value)** → FlexStyler - Wraps with transform modifier

## Core Methods

### animate(AnimationConfig animation) → FlexStyler
Applies animation configuration to the flex styling.

### merge(Style<FlexSpec>? other) → FlexSpecUtility
Merges this utility with another style, returning a new utility instance.

## Variant Support

The FlexSpecUtility includes `UtilityVariantMixin` providing:

### withVariant(Variant variant, FlexStyler style) → FlexStyler
Applies a style under a specific variant condition.

### withVariants(List<VariantStyle<FlexSpec>> variants) → FlexStyler
Applies multiple variant styles.

## Deprecated Methods

### $flex.on → OnContextVariantUtility (Deprecated)
**⚠️ Deprecated:** Use direct methods like `$flex.onHovered()` instead.
- **$flex.on.hover(FlexStyler style)** → FlexStyler - Apply style on hover
- **$flex.on.dark(FlexStyler style)** → FlexStyler - Apply style in dark mode
- **$flex.on.light(FlexStyler style)** → FlexStyler - Apply style in light mode

**Replacement Pattern:**
```dart
// Instead of:
$flex.on.hover($flex.spacing(20))

// Use:
$flex.onHovered($flex.spacing(20))
```

## Usage Examples

### Basic Flex Layouts
```dart
// Simple horizontal row
final horizontalRow = $flex
  .direction.horizontal()
  .mainAxisAlignment.spaceBetween()
  .crossAxisAlignment.center()
  .spacing(16);

// Vertical column layout
final verticalColumn = $flex
  .direction.vertical()
  .mainAxisAlignment.start()
  .crossAxisAlignment.stretch()
  .spacing(12);
```

### Centered Layouts
```dart
// Centered content
final centeredFlex = $flex
  .direction.vertical()
  .mainAxisAlignment.center()
  .crossAxisAlignment.center()
  .mainAxisSize.max();

// Centered row with spacing
final centeredRow = $flex
  .row()
  .mainAxisAlignment.center()
  .crossAxisAlignment.center()
  .spacing(8);
```

### Responsive Flex Layouts
```dart
// Layout that changes direction on different screen sizes
final responsiveFlex = $flex
  .direction.vertical()
  .mainAxisAlignment.start()
  .spacing(16)
  .onBreakpoint(Breakpoint.md, $flex.direction.horizontal())
  .onBreakpoint(Breakpoint.lg, $flex.spacing(24));

// Theme-aware flex layout
final themeFlex = $flex
  .column()
  .spacing(12)
  .onDark($flex.spacing(16));
```

### Advanced Alignment
```dart
// Baseline-aligned text elements
final baselineFlex = $flex
  .row()
  .crossAxisAlignment.baseline()
  .textBaseline.alphabetic()
  .spacing(8);

// End-aligned column
final endAlignedColumn = $flex
  .column()
  .mainAxisAlignment.end()
  .crossAxisAlignment.end()
  .mainAxisSize.max();
```

### Flex with Spacing Variants
```dart
// Different spacing for different contexts
final spacedFlex = $flex
  .row()
  .mainAxisAlignment.start()
  .spacing.small()
  .onBreakpoint(Breakpoint.md, $flex.spacing.medium())
  .onBreakpoint(Breakpoint.lg, $flex.spacing.large());
```

### Direction Control
```dart
// RTL-aware horizontal layout
final rtlFlex = $flex
  .direction.horizontal()
  .textDirection.ltr()
  .mainAxisAlignment.start()
  .spacing(12)
  .onLocale(Locale('ar'), $flex.textDirection.rtl());

// Reverse vertical layout
final reverseFlex = $flex
  .column()
  .verticalDirection.up()
  .mainAxisAlignment.start()
  .spacing(10);
```

### Interactive Flex Layouts
```dart
// Flex layout with hover effects
final interactiveFlex = $flex
  .row()
  .mainAxisAlignment.spaceBetween()
  .spacing(16)
  .onHovered($flex.spacing(20).animate(
    AnimationConfig(duration: Duration(milliseconds: 200)),
  ));

// Animated spacing changes
final animatedFlex = $flex
  .column()
  .spacing(12)
  .animate(AnimationConfig(
    duration: Duration(milliseconds: 300),
    curve: Curves.easeInOut,
  ));
```

### Complex Layouts
```dart
// Navigation bar layout
final navBarFlex = $flex
  .row()
  .mainAxisAlignment.spaceBetween()
  .crossAxisAlignment.center()
  .mainAxisSize.max()
  .spacing(16)
  .wrap.padding(EdgeInsets.only(left: 20, right: 20, top: 12, bottom: 12));

// Card content layout
final cardContentFlex = $flex
  .column()
  .crossAxisAlignment.stretch()
  .spacing(16)
  .wrap.padding(EdgeInsets.all(20));

// Button group layout
final buttonGroupFlex = $flex
  .row()
  .mainAxisAlignment.end()
  .crossAxisAlignment.center()
  .spacing(12);
```

### Form Layouts
```dart
// Form field layout
final formFieldFlex = $flex
  .column()
  .crossAxisAlignment.stretch()
  .spacing(8)
  .mainAxisSize.min();

// Inline form layout
final inlineFormFlex = $flex
  .row()
  .mainAxisAlignment.start()
  .crossAxisAlignment.baseline()
  .textBaseline.alphabetic()
  .spacing(12);
```

## Performance Notes

- **Mutable State**: FlexSpecUtility maintains mutable state for efficient chaining
- **Lazy Properties**: Sub-utilities are initialized lazily using `late final`
- **Immutable Results**: Despite mutable building, the final styles are immutable
- **Layout Performance**: Flex layouts are highly optimized in Flutter
- **Intrinsic Dimensions**: Be mindful of intrinsic dimension calculations with flex layouts

## Related Classes

- **FlexStyler** - The immutable style class that FlexSpecUtility builds
- **FlexSpec** - The resolved specification used at runtime
- **Flex** (Flutter) - The underlying Flutter widget for flex layouts
- **Row** (Flutter) - Horizontal flex layout widget
- **Column** (Flutter) - Vertical flex layout widget
- **ModifierUtility** - Utility for widget modifiers