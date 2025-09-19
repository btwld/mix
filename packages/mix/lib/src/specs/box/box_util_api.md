# BoxSpecUtility API Reference

## Overview
The `BoxSpecUtility` class provides a mutable utility for box styling with cascade notation support in Mix. It maintains mutable internal state enabling fluid styling like `$box..color.red()..width(100)`. This is the core utility class behind the global `$box` accessor.

**Global Access:** `$box` → `BoxSpecUtility()`

## Core Utility Properties

### Sub-Utilities

#### $box.padding → EdgeInsetsGeometryUtility
Provides comprehensive padding configuration:
- **$box.padding.all(double value)** → BoxStyler - Sets padding on all sides
- **$box.padding.only({double? left, double? top, double? right, double? bottom})** → BoxStyler - Sets specific side padding
- **$box.padding.horizontal(double value)** → BoxStyler - Sets left and right padding
- **$box.padding.vertical(double value)** → BoxStyler - Sets top and bottom padding
- **$box.padding.left(double value)** → BoxStyler - Sets left padding
- **$box.padding.right(double value)** → BoxStyler - Sets right padding  
- **$box.padding.top(double value)** → BoxStyler - Sets top padding
- **$box.padding.bottom(double value)** → BoxStyler - Sets bottom padding

#### $box.margin → EdgeInsetsGeometryUtility
Provides comprehensive margin configuration (same API as padding):
- **$box.margin.all(double value)** → BoxStyler - Sets margin on all sides
- **$box.margin.only({double? left, double? top, double? right, double? bottom})** → BoxStyler - Sets specific side margin
- **$box.margin.horizontal(double value)** → BoxStyler - Sets left and right margin
- **$box.margin.vertical(double value)** → BoxStyler - Sets top and bottom margin
- **$box.margin.left(double value)** → BoxStyler - Sets left margin
- **$box.margin.right(double value)** → BoxStyler - Sets right margin
- **$box.margin.top(double value)** → BoxStyler - Sets top margin
- **$box.margin.bottom(double value)** → BoxStyler - Sets bottom margin

#### $box.constraints → BoxConstraintsUtility
Provides box constraint configuration:
- **$box.constraints(BoxConstraints value)** → BoxStyler - Sets box constraints

#### $box.decoration → DecorationUtility
Provides decoration configuration with extensive sub-utilities:
- **$box.decoration(Decoration value)** → BoxStyler - Sets decoration directly
- **$box.decoration.box** → BoxDecorationUtility - Access to box decoration utilities

#### $box.wrap → ModifierUtility
Provides widget modifier configuration:
- **$box.wrap(Modifier value)** → BoxStyler - Applies widget modifier
- **$box.wrap.opacity(double value)** → BoxStyler - Wraps with opacity modifier
- **$box.wrap.padding(EdgeInsets value)** → BoxStyler - Wraps with padding modifier
- **$box.wrap.transform(Matrix4 value)** → BoxStyler - Wraps with transform modifier

### Convenience Accessors

#### Color & Decoration
- **$box.border** → BorderUtility - Direct access to border styling
- **$box.borderRadius** → BorderRadiusUtility - Direct access to border radius
- **$box.color** → ColorUtility - Direct access to background color
- **$box.gradient** → GradientUtility - Direct access to gradient backgrounds
- **$box.shape** → ShapeUtility - Direct access to shape configuration
- **$box.shadow** → BoxShadowUtility - Direct access to box shadow

#### Size & Constraints
- **$box.width** → ConstraintUtility - Direct access to width constraints
- **$box.height** → ConstraintUtility - Direct access to height constraints
- **$box.minWidth** → ConstraintUtility - Direct access to minimum width
- **$box.maxWidth** → ConstraintUtility - Direct access to maximum width
- **$box.minHeight** → ConstraintUtility - Direct access to minimum height
- **$box.maxHeight** → ConstraintUtility - Direct access to maximum height

#### Transform & Alignment
- **$box.transform** → MixUtility - Direct access to transform matrix
- **$box.clipBehavior** → MixUtility - Direct access to clipping behavior
- **$box.alignment** → MixUtility - Direct access to alignment settings

## Core Methods

### animate(AnimationConfig animation) → BoxStyler
Applies animation configuration to the box styling.

### merge(Style<BoxSpec>? other) → BoxSpecUtility
Merges this utility with another style, returning a new utility instance.

## Variant Support

The BoxSpecUtility includes `UtilityVariantMixin` providing:

### withVariant(Variant variant, BoxStyler style) → BoxStyler
Applies a style under a specific variant condition.

### withVariants(List<VariantStyle<BoxSpec>> variants) → BoxStyler
Applies multiple variant styles.

## Deprecated Methods

### $box.on → OnContextVariantUtility (Deprecated)
**⚠️ Deprecated:** Use direct methods like `$box.onHovered()` instead.
- **$box.on.hover(BoxStyler style)** → BoxStyler - Apply style on hover
- **$box.on.dark(BoxStyler style)** → BoxStyler - Apply style in dark mode
- **$box.on.light(BoxStyler style)** → BoxStyler - Apply style in light mode

**Replacement Pattern:**
```dart
// Instead of:
$box.on.hover($box.color.blue())

// Use:
$box.onHovered($box.color.blue())
```

## Usage Examples

### Basic Box Styling
```dart
// Simple colored box with padding
final basicBox = $box
  .color.blue()
  .padding.all(16);

// Box with gradient background
final gradientBox = $box
  .gradient.linear(
    colors: [Colors.blue, Colors.purple],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  )
  .borderRadius.circular(12);
```

### Complex Styling with Chaining
```dart
// Card-like container
final cardBox = $box
  .color.white()
  .padding.all(20)
  .margin.horizontal(16).margin.vertical(8)
  .borderRadius.circular(12)
  .shadow.medium()
  .border.all(color: Colors.grey.shade200);

// Constrained container with transform
final constrainedBox = $box
  .width.fixed(200)
  .height.fixed(150)
  .color.red().withOpacity(0.8)
  .transform.scale(1.1)
  .borderRadius.circular(8);
```

### Using Sub-Utilities
```dart
// Detailed padding configuration
final paddedBox = $box
  .padding.only(
    left: 16,
    right: 16, 
    top: 24,
    bottom: 12,
  )
  .margin.horizontal(8);

// Complex constraint setup
final responsiveBox = $box
  .constraints.width(300)
  .minHeight.fixed(100)
  .maxHeight.fixed(400);
```

### Animation & Modifiers
```dart
// Animated box with modifiers
final animatedBox = $box
  .color.blue()
  .padding.all(16)
  .animate(AnimationConfig(
    duration: Duration(milliseconds: 200),
    curve: Curves.easeInOut,
  ))
  .wrap.opacity(0.9)
  .wrap.transform(Matrix4.rotationZ(0.1));
```

### Variant-Based Styling
```dart
// Responsive design with variants
final responsiveBox = $box
  .color.blue()
  .padding.all(16)
  .onBreakpoint(Breakpoint.md, $box.padding.all(24))
  .onDark($box.color.grey().shade800());
```

## Performance Notes

- **Mutable State**: BoxSpecUtility maintains mutable state for efficient chaining
- **Lazy Properties**: Sub-utilities are initialized lazily using `late final`
- **Immutable Results**: Despite mutable building, the final styles are immutable
- **Memory Efficiency**: Utilities are created on-demand and can be garbage collected

## Related Classes

- **BoxStyler** - The immutable style class that BoxSpecUtility builds
- **BoxSpec** - The resolved specification used at runtime
- **EdgeInsetsGeometryUtility** - Utility for padding/margin configuration
- **BoxConstraintsUtility** - Utility for constraint configuration
- **DecorationUtility** - Utility for decoration configuration