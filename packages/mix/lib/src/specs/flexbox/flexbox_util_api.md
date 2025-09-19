# FlexBoxSpecUtility API Reference

## Overview
The `FlexBoxSpecUtility` class provides a mutable utility for combined flex and box styling with cascade notation support in Mix. It maintains mutable internal state enabling fluid styling like `$flexbox..color.blue()..direction.horizontal()..spacing(16)`. This combines both flex layout capabilities and box styling (colors, borders, padding, etc.) in a single utility. This is the core utility class behind the global `$flexbox` accessor.

**Global Access:** `$flexbox` → `FlexBoxSpecUtility()`

## Architecture

FlexBoxSpecUtility combines:
- **Box Styling**: Colors, borders, padding, margin, decoration, constraints
- **Flex Layout**: Direction, alignment, spacing, sizing behavior

This allows creating styled flexible containers that have both visual appearance and layout behavior.

## Core Utility Properties

### Box Styling Properties

#### $flexbox.padding → EdgeInsetsGeometryUtility
Provides comprehensive padding configuration:
- **$flexbox.padding.all(double value)** → FlexBoxStyler - Sets padding on all sides
- **$flexbox.padding.only({double? left, double? top, double? right, double? bottom})** → FlexBoxStyler - Sets specific side padding
- **$flexbox.padding.horizontal(double value)** → FlexBoxStyler - Sets left and right padding
- **$flexbox.padding.vertical(double value)** → FlexBoxStyler - Sets top and bottom padding

#### $flexbox.margin → EdgeInsetsGeometryUtility
Provides comprehensive margin configuration (same API as padding):
- **$flexbox.margin.all(double value)** → FlexBoxStyler - Sets margin on all sides
- **$flexbox.margin.only({double? left, double? top, double? right, double? bottom})** → FlexBoxStyler - Sets specific side margin

#### $flexbox.constraints → BoxConstraintsUtility
Provides box constraint configuration:
- **$flexbox.constraints(BoxConstraints value)** → FlexBoxStyler - Sets box constraints

#### $flexbox.decoration → DecorationUtility
Provides decoration configuration:
- **$flexbox.decoration(Decoration value)** → FlexBoxStyler - Sets decoration directly
- **$flexbox.decoration.box** → BoxDecorationUtility - Access to box decoration utilities

### Convenience Decoration Accessors

#### Colors & Visual Effects
- **$flexbox.color** → ColorUtility - Direct access to background color
- **$flexbox.gradient** → GradientUtility - Direct access to gradient backgrounds
- **$flexbox.border** → BorderUtility - Direct access to border styling
- **$flexbox.borderRadius** → BorderRadiusUtility - Direct access to border radius
- **$flexbox.shadow** → BoxShadowUtility - Direct access to box shadow
- **$flexbox.shape** → ShapeUtility - Direct access to shape configuration

#### Size & Constraints Accessors
- **$flexbox.width** → ConstraintUtility - Direct access to width constraints
- **$flexbox.height** → ConstraintUtility - Direct access to height constraints
- **$flexbox.minWidth** → ConstraintUtility - Direct access to minimum width
- **$flexbox.maxWidth** → ConstraintUtility - Direct access to maximum width
- **$flexbox.minHeight** → ConstraintUtility - Direct access to minimum height
- **$flexbox.maxHeight** → ConstraintUtility - Direct access to maximum height

### Flex Layout Properties

#### $flexbox.direction → MixUtility
Controls the main axis direction of the flex layout:
- **$flexbox.direction(Axis value)** → FlexBoxStyler - Sets flex direction
- **$flexbox.direction.horizontal()** → FlexBoxStyler - Horizontal layout (row)
- **$flexbox.direction.vertical()** → FlexBoxStyler - Vertical layout (column)

#### Direct Direction Methods
- **$flexbox.row()** → FlexBoxStyler - Convenience method for horizontal direction
- **$flexbox.column()** → FlexBoxStyler - Convenience method for vertical direction

#### $flexbox.mainAxisAlignment → MixUtility
Controls how children are aligned along the main axis:
- **$flexbox.mainAxisAlignment(MainAxisAlignment value)** → FlexBoxStyler - Sets main axis alignment
- **$flexbox.mainAxisAlignment.start()** → FlexBoxStyler - Align to start
- **$flexbox.mainAxisAlignment.end()** → FlexBoxStyler - Align to end
- **$flexbox.mainAxisAlignment.center()** → FlexBoxStyler - Center alignment
- **$flexbox.mainAxisAlignment.spaceBetween()** → FlexBoxStyler - Space evenly with no end spaces
- **$flexbox.mainAxisAlignment.spaceAround()** → FlexBoxStyler - Space evenly with half end spaces
- **$flexbox.mainAxisAlignment.spaceEvenly()** → FlexBoxStyler - Space evenly everywhere

#### $flexbox.crossAxisAlignment → MixUtility
Controls how children are aligned along the cross axis:
- **$flexbox.crossAxisAlignment(CrossAxisAlignment value)** → FlexBoxStyler - Sets cross axis alignment
- **$flexbox.crossAxisAlignment.start()** → FlexBoxStyler - Align to start
- **$flexbox.crossAxisAlignment.end()** → FlexBoxStyler - Align to end
- **$flexbox.crossAxisAlignment.center()** → FlexBoxStyler - Center alignment
- **$flexbox.crossAxisAlignment.stretch()** → FlexBoxStyler - Stretch to fill
- **$flexbox.crossAxisAlignment.baseline()** → FlexBoxStyler - Align by text baseline

#### $flexbox.spacing → MixUtility
Controls spacing between flex children:
- **$flexbox.spacing(double value)** → FlexBoxStyler - Sets spacing between children
- **$flexbox.spacing.small()** → FlexBoxStyler - Small spacing (8px)
- **$flexbox.spacing.medium()** → FlexBoxStyler - Medium spacing (16px)
- **$flexbox.spacing.large()** → FlexBoxStyler - Large spacing (24px)

#### $flexbox.mainAxisSize → MixUtility
Controls how much space the flex layout should occupy:
- **$flexbox.mainAxisSize(MainAxisSize value)** → FlexBoxStyler - Sets main axis size
- **$flexbox.mainAxisSize.min()** → FlexBoxStyler - Take minimum space
- **$flexbox.mainAxisSize.max()** → FlexBoxStyler - Take maximum space

### Transform & Alignment
- **$flexbox.transform** → MixUtility - Direct access to transform matrix
- **$flexbox.alignment** → MixUtility - Direct access to alignment settings
- **$flexbox.clipBehavior** → MixUtility - Direct access to clipping behavior

### Modifiers & Animation

#### $flexbox.wrap → ModifierUtility
Provides widget modifiers:
- **$flexbox.wrap(Modifier value)** → FlexBoxStyler - Applies widget modifier
- **$flexbox.wrap.opacity(double value)** → FlexBoxStyler - Wraps with opacity
- **$flexbox.wrap.transform(Matrix4 value)** → FlexBoxStyler - Wraps with transform
- **$flexbox.wrap.clipRect()** → FlexBoxStyler - Clips to rectangular bounds

## Core Methods


### merge(Style<FlexBoxSpec>? other) → FlexBoxSpecUtility
Merges this utility with another style, returning a new utility instance.

## Variant Support

The FlexBoxSpecUtility includes `UtilityVariantMixin` providing:

### withVariant(Variant variant, FlexBoxStyler style) → FlexBoxStyler
Applies a style under a specific variant condition.

### withVariants(List<VariantStyle<FlexBoxSpec>> variants) → FlexBoxStyler
Applies multiple variant styles.

## Usage Examples

### Basic Styled Flex Containers
```dart
// Simple card with flex content
final cardContainer = $flexbox
  .color.white()
  .padding.all(20)
  .borderRadius.circular(12)
  .shadow.medium()
  .direction.vertical()
  .spacing(16);

// Horizontal navigation bar
final navBar = $flexbox
  .color.blue().shade800()
  .padding.horizontal(24).padding.vertical(12)
  .direction.horizontal()
  .mainAxisAlignment.spaceBetween()
  .crossAxisAlignment.center();
```

### Complex Visual Layouts
```dart
// Gradient card with centered content
final gradientCard = $flexbox
  .gradient.linear(
    colors: [Colors.blue, Colors.purple],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  )
  .padding.all(24)
  .borderRadius.circular(16)
  .direction.column()
  .mainAxisAlignment.center()
  .crossAxisAlignment.center()
  .spacing(12);

// Bordered container with constrained size
final constrainedContainer = $flexbox
  .width.fixed(300)
  .height.fixed(200)
  .color.grey().shade50()
  .border.all(color: Colors.grey.shade300)
  .borderRadius.circular(8)
  .padding.all(16)
  .direction.column()
  .crossAxisAlignment.stretch()
  .spacing(8);
```

### Responsive Flexbox Layouts
```dart
// Container that adapts spacing and direction
final responsiveContainer = $flexbox
  .color.white()
  .padding.all(16)
  .borderRadius.circular(12)
  .shadow.small()
  .direction.vertical()
  .spacing(12)
  .onBreakpoint(Breakpoint.md, $flexbox
    .direction.horizontal()
    .spacing(20)
    .padding.all(24)
  )
  .onBreakpoint(Breakpoint.lg, $flexbox
    .spacing(32)
    .padding.all(32)
  );

// Theme-aware styled container
final themeContainer = $flexbox
  .color.white()
  .border.all(color: Colors.grey.shade300)
  .padding.all(16)
  .direction.column()
  .spacing(12)
  .onDark($flexbox
    .color.grey().shade800()
    .border.all(color: Colors.grey.shade600)
  );
```

### Button Groups & Toolbars
```dart
// Button toolbar
final buttonToolbar = $flexbox
  .color.grey().shade100()
  .padding.all(8)
  .borderRadius.circular(8)
  .border.all(color: Colors.grey.shade300)
  .direction.horizontal()
  .spacing(4);

// Action button group
final actionButtons = $flexbox
  .direction.horizontal()
  .mainAxisAlignment.end()
  .spacing(12)
  .padding.all(16);
```

### Form Layouts
```dart
// Form section
final formSection = $flexbox
  .color.white()
  .padding.all(24)
  .borderRadius.circular(12)
  .border.all(color: Colors.grey.shade200)
  .direction.column()
  .crossAxisAlignment.stretch()
  .spacing(16);

// Inline form controls
final inlineControls = $flexbox
  .direction.horizontal()
  .mainAxisAlignment.spaceBetween()
  .crossAxisAlignment.center()
  .spacing(12)
  .padding.vertical(8);
```

### Dashboard Widgets
```dart
// Metric card
final metricCard = $flexbox
  .color.blue().shade50()
  .padding.all(20)
  .borderRadius.circular(12)
  .border.all(color: Colors.blue.shade200)
  .direction.column()
  .mainAxisAlignment.center()
  .spacing(8);

// Status indicator
final statusIndicator = $flexbox
  .padding.horizontal(12).padding.vertical(6)
  .borderRadius.circular(20)
  .color.green().shade100()
  .direction.horizontal()
  .mainAxisAlignment.center()
  .crossAxisAlignment.center()
  .spacing(6);
```

### Interactive Containers
```dart
// Hoverable card
final interactiveCard = $flexbox
  .color.white()
  .padding.all(20)
  .borderRadius.circular(12)
  .shadow.small()
  .direction.column()
  .spacing(12)
  .onHovered($flexbox
    .shadow.medium()
    .transform.scale(1.02)
  );

// Clickable container with state changes
final clickableContainer = $flexbox
  .color.blue().shade500()
  .padding.all(16)
  .borderRadius.circular(8)
  .direction.horizontal()
  .mainAxisAlignment.center()
  .onPressed($flexbox
    .color.blue().shade700()
    .transform.scale(0.98)
  );
```

### Media Layouts
```dart
// Video thumbnail with overlay
final videoThumbnail = $flexbox
  .width.fixed(200)
  .height.fixed(112)
  .borderRadius.circular(8)
  .clipBehavior.hardEdge()
  .direction.column()
  .mainAxisAlignment.end()
  .padding.all(12);

// Album artwork container
final albumArtwork = $flexbox
  .width.fixed(150)
  .height.fixed(150)
  .borderRadius.circular(8)
  .shadow.medium()
  .clipBehavior.hardEdge()
  .direction.column()
  .mainAxisAlignment.end()
  .padding.all(8);
```

### Loading & Empty States
```dart
// Loading container
final loadingContainer = $flexbox
  .color.grey().shade50()
  .padding.all(40)
  .borderRadius.circular(12)
  .direction.column()
  .mainAxisAlignment.center()
  .crossAxisAlignment.center()
  .spacing(16);

// Empty state container
final emptyState = $flexbox
  .padding.all(32)
  .direction.column()
  .mainAxisAlignment.center()
  .crossAxisAlignment.center()
  .spacing(20);
```

## Performance Notes

- **Mutable State**: FlexBoxSpecUtility maintains mutable state for efficient chaining
- **Lazy Properties**: Sub-utilities are initialized lazily using `late final`
- **Immutable Results**: Despite mutable building, the final styles are immutable
- **Combined Rendering**: Efficiently combines box decoration and flex layout
- **Memory Usage**: Single utility for both concerns reduces object allocation

## Best Practices

1. **Use FlexBox for styled containers**: When you need both visual styling and flex layout
2. **Prefer semantic naming**: Use descriptive variable names for different container types
3. **Responsive design**: Leverage breakpoint variants for adaptive layouts
4. **Performance**: Avoid excessive nesting of styled containers
5. **Accessibility**: Consider color contrast and semantic structure

## Related Classes

- **FlexBoxStyler** - The immutable style class that FlexBoxSpecUtility builds
- **FlexBoxSpec** - The resolved specification used at runtime
- **BoxStyler** - Pure box styling without flex layout
- **FlexStyler** - Pure flex layout without box styling
- **BoxSpecUtility** - Utility for pure box styling
- **FlexSpecUtility** - Utility for pure flex styling