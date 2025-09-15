# StackBoxStyler API Reference

## Overview
The `StackBoxStyler` class is an **immutable composite style class** that combines both Box and Stack styling capabilities in Mix. It represents a finalized stack container style with all properties resolved, created through direct instantiation. StackBoxStyler provides instance methods from mixins for convenient style manipulation and is ideal for creating styled stack containers with overlapping children and box decorations.

**Type Alias:** `StackBoxMix = StackBoxStyler`

**Important:** StackBoxStyler does not have a global utility accessor (no `$stackbox` equivalent). It must be used through direct instantiation and instance methods.

## Utility Access

### StackBoxSpecUtility
Access to stack-box utilities is provided through the `StackBoxSpecUtility` class:

```dart
// Static access
final utility = StackBoxSpecUtility.self;

// Utility properties
final boxUtility = utility.box;      // Access to BoxStyler utilities
final stackUtility = utility.stack;  // Access to StackStyler utilities
```

### Individual Component Access
Since StackBoxStyler combines box and stack functionality, you can access individual utilities:

```dart
// Use existing global utilities for individual components
final boxStyle = $box.color.blue().padding.all(16);
final stackStyle = $stack.alignment.center().fit.expand();

// Combine in StackBoxStyler constructor
final stackBoxStyle = StackBoxStyler(
  // Box properties
  decoration: boxStyle.decoration,
  padding: boxStyle.padding,
  // Stack properties  
  stackAlignment: stackStyle.alignment,
  fit: stackStyle.fit,
);
```

## Constructors

### StackBoxStyler({...}) → StackBoxStyler
Main constructor with optional parameters for all stack-box properties.
```dart
StackBoxStyler({
  // Box properties
  DecorationMix? decoration,
  DecorationMix? foregroundDecoration,
  EdgeInsetsGeometryMix? padding,
  EdgeInsetsGeometryMix? margin,
  AlignmentGeometry? alignment,
  BoxConstraintsMix? constraints,
  Matrix4? transform,
  AlignmentGeometry? transformAlignment,
  Clip? clipBehavior,
  // Stack properties
  AlignmentGeometry? stackAlignment,
  StackFit? fit,
  TextDirection? textDirection,
  Clip? stackClipBehavior,
  // Style properties
  List<VariantStyle<ZBoxSpec>>? variants,
})
```

### StackBoxStyler.create({...}) → StackBoxStyler
Internal constructor using `Prop<T>` types for advanced usage.
```dart
const StackBoxStyler.create({
  Prop<StyleSpec<BoxSpec>>? box,
  Prop<StyleSpec<StackSpec>>? stack,
  List<VariantStyle<ZBoxSpec>>? variants,
})
```

### StackBoxStyler.builder(StackBoxStyler Function(BuildContext)) → StackBoxStyler
Factory constructor for context-dependent stack-box styling.

## Static Properties

### StackBoxStyler.chain → StackBoxSpecUtility
Static accessor providing utility methods for stack-box operations.

## Utility Methods

### StackBoxSpecUtility.only({...}) → StackBoxStyler
Factory method for creating StackBoxStyler with specific properties:

```dart
StackBoxSpecUtility.only({
  // Box properties
  DecorationMix? decoration,
  EdgeInsetsGeometryMix? padding,
  EdgeInsetsGeometryMix? margin,
  BoxConstraintsMix? constraints,
  AlignmentGeometry? alignment,
  Matrix4? transform,
  AlignmentGeometry? transformAlignment,
  Clip? clipBehavior,
  // Stack properties
  AlignmentGeometry? stackAlignment,
  StackFit? fit,
  TextDirection? textDirection,
  Clip? stackClipBehavior,
  // Style properties
  List<VariantStyle<ZBoxSpec>>? variants,
})
```

### Component Utilities

#### StackBoxSpecUtility.box → BoxStyler
Provides access to box styling utilities.

#### StackBoxSpecUtility.stack → StackStyler  
Provides access to stack styling utilities.

## Core Methods

### resolve(BuildContext context) → StyleSpec<ZBoxSpec>
Resolves all properties using the provided context, converting tokens and contextual values into concrete specifications.

### merge(StackBoxStyler? other) → StackBoxStyler
Merges this StackBoxStyler with another, with the other's properties taking precedence for non-null values.

## Instance Methods

### Direct Methods
- **variants(List<VariantStyle<ZBoxSpec>> variants)** → StackBoxStyler - Sets conditional styling variants

### Stack-Specific Methods
- **stackAlignment(AlignmentGeometry value)** → StackBoxStyler - Sets stack alignment
- **fit(StackFit value)** → StackBoxStyler - Sets stack fit behavior
- **textDirection(TextDirection value)** → StackBoxStyler - Sets text direction
- **stackClipBehavior(Clip value)** → StackBoxStyler - Sets stack clip behavior

### Box-Specific Methods
- **alignment(AlignmentGeometry value)** → StackBoxStyler - Sets box alignment
- **transformAlignment(AlignmentGeometry value)** → StackBoxStyler - Sets transform alignment
- **clipBehavior(Clip value)** → StackBoxStyler - Sets box clip behavior
- **foregroundDecoration(DecorationMix value)** → StackBoxStyler - Sets foreground decoration

### Spacing Methods (from SpacingStyleMixin)

#### Padding Convenience Methods
- **padding(EdgeInsetsGeometryMix value)** → StackBoxStyler - Sets padding using EdgeInsetsGeometryMix
- **paddingAll(double value)** → StackBoxStyler - Sets padding on all sides
- **paddingX(double value)** → StackBoxStyler - Sets left and right padding
- **paddingY(double value)** → StackBoxStyler - Sets top and bottom padding
- **paddingTop(double value)** → StackBoxStyler - Sets top padding
- **paddingBottom(double value)** → StackBoxStyler - Sets bottom padding
- **paddingLeft(double value)** → StackBoxStyler - Sets left padding
- **paddingRight(double value)** → StackBoxStyler - Sets right padding
- **paddingStart(double value)** → StackBoxStyler - Sets start padding (direction-aware)
- **paddingEnd(double value)** → StackBoxStyler - Sets end padding (direction-aware)
- **paddingOnly({double? horizontal, double? vertical, double? start, double? end, double? left, double? right, double? top, double? bottom})** → StackBoxStyler - Sets padding on specific sides with priority resolution

#### Margin Convenience Methods
- **margin(EdgeInsetsGeometryMix value)** → StackBoxStyler - Sets margin using EdgeInsetsGeometryMix
- **marginAll(double value)** → StackBoxStyler - Sets margin on all sides
- **marginX(double value)** → StackBoxStyler - Sets left and right margin
- **marginY(double value)** → StackBoxStyler - Sets top and bottom margin
- **marginTop(double value)** → StackBoxStyler - Sets top margin
- **marginBottom(double value)** → StackBoxStyler - Sets bottom margin
- **marginLeft(double value)** → StackBoxStyler - Sets left margin
- **marginRight(double value)** → StackBoxStyler - Sets right margin
- **marginStart(double value)** → StackBoxStyler - Sets start margin (direction-aware)
- **marginEnd(double value)** → StackBoxStyler - Sets end margin (direction-aware)
- **marginOnly({double? horizontal, double? vertical, double? start, double? end, double? left, double? right, double? top, double? bottom})** → StackBoxStyler - Sets margin on specific sides with priority resolution

### Constraint Methods (from ConstraintStyleMixin)
- **constraints(BoxConstraintsMix value)** → StackBoxStyler - Sets box constraints using BoxConstraintsMix
- **width(double value)** → StackBoxStyler - Sets fixed width
- **height(double value)** → StackBoxStyler - Sets fixed height
- **minWidth(double value)** → StackBoxStyler - Sets minimum width
- **maxWidth(double value)** → StackBoxStyler - Sets maximum width
- **minHeight(double value)** → StackBoxStyler - Sets minimum height
- **maxHeight(double value)** → StackBoxStyler - Sets maximum height
- **size(double width, double height)** → StackBoxStyler - Sets both width and height

### Border Radius Methods (from BorderRadiusStyleMixin)
- **borderRadius(BorderRadiusGeometryMix value)** → StackBoxStyler - Sets border radius using BorderRadiusGeometryMix
- **borderRadiusAll(double value)** → StackBoxStyler - Sets border radius on all corners
- **borderRounded(double radius)** → StackBoxStyler - Sets circular border radius on all corners
- **borderRadiusTopLeft(double value)** → StackBoxStyler - Sets top-left border radius
- **borderRadiusTopRight(double value)** → StackBoxStyler - Sets top-right border radius
- **borderRadiusBottomLeft(double value)** → StackBoxStyler - Sets bottom-left border radius
- **borderRadiusBottomRight(double value)** → StackBoxStyler - Sets bottom-right border radius
- **borderRadiusTop(double value)** → StackBoxStyler - Sets top border radius (left and right)
- **borderRadiusBottom(double value)** → StackBoxStyler - Sets bottom border radius (left and right)
- **borderRadiusLeft(double value)** → StackBoxStyler - Sets left border radius (top and bottom)
- **borderRadiusRight(double value)** → StackBoxStyler - Sets right border radius (top and bottom)

### Decoration Methods (from DecorationStyleMixin)
- **decoration(DecorationMix value)** → StackBoxStyler - Sets decoration using DecorationMix
- **color(Color value)** → StackBoxStyler - Sets background color
- **gradient(GradientMix value)** → StackBoxStyler - Sets gradient with any GradientMix type
- **border(BoxBorderMix value)** → StackBoxStyler - Sets border
- **shadow(BoxShadowMix value)** → StackBoxStyler - Sets single shadow
- **shadows(List<BoxShadowMix> value)** → StackBoxStyler - Sets multiple shadows
- **elevation(ElevationShadow value)** → StackBoxStyler - Sets elevation shadow
- **image(DecorationImageMix value)** → StackBoxStyler - Sets image decoration
- **shape(ShapeBorderMix value)** → StackBoxStyler - Sets box shape
- **shapeCircle({BorderSideMix? side})** → StackBoxStyler - Sets circular shape
- **shapeStadium({BorderSideMix? side})** → StackBoxStyler - Sets stadium shape
- **shapeRoundedRectangle({BorderSideMix? side, BorderRadiusMix? borderRadius})** → StackBoxStyler - Sets rounded rectangle shape
- **backgroundImage(ImageProvider image, {BoxFit? fit, AlignmentGeometry? alignment, ImageRepeat repeat})** → StackBoxStyler - Sets background image
- **backgroundImageUrl(String url, {BoxFit? fit, AlignmentGeometry? alignment, ImageRepeat repeat})** → StackBoxStyler - Sets background image from URL
- **backgroundImageAsset(String path, {BoxFit? fit, AlignmentGeometry? alignment, ImageRepeat repeat})** → StackBoxStyler - Sets background image from asset
- **linearGradient({required List<Color> colors, List<double>? stops, AlignmentGeometry? begin, AlignmentGeometry? end, TileMode? tileMode})** → StackBoxStyler - Sets linear gradient
- **radialGradient({required List<Color> colors, List<double>? stops, AlignmentGeometry? center, double? radius, AlignmentGeometry? focal, double? focalRadius, TileMode? tileMode})** → StackBoxStyler - Sets radial gradient
- **sweepGradient({required List<Color> colors, List<double>? stops, AlignmentGeometry? center, double? startAngle, double? endAngle, TileMode? tileMode})** → StackBoxStyler - Sets sweep gradient

### Transform Methods (from TransformStyleMixin)
- **transform(Matrix4 value, {AlignmentGeometry alignment})** → StackBoxStyler - Sets matrix transformation
- **scale(double value, {AlignmentGeometry? alignment})** → StackBoxStyler - Sets uniform scale transformation
- **scaleX(double value, {AlignmentGeometry? alignment})** → StackBoxStyler - Sets X-axis scale
- **scaleY(double value, {AlignmentGeometry? alignment})** → StackBoxStyler - Sets Y-axis scale
- **translate({double? x, double? y, AlignmentGeometry? alignment})** → StackBoxStyler - Sets translation transformation
- **rotate(double angle, {AlignmentGeometry? alignment})** → StackBoxStyler - Sets rotation transformation
- **skew({double? x, double? y, AlignmentGeometry? alignment})** → StackBoxStyler - Sets skew transformation

## Properties (Read-only)

The following properties are available as readonly `Prop<T>` values:

- **$box** → `Prop<StyleSpec<BoxSpec>>?` - Box specification
- **$stack** → `Prop<StyleSpec<StackSpec>>?` - Stack specification

## Variant Methods

### variants(List<VariantStyle<ZBoxSpec>> value) → StackBoxStyler
Sets conditional styling variants based on context or state.

### variant(Variant variant, StackBoxStyler style) → StackBoxStyler
Adds a single variant with the given variant condition and style.

#### Context Variants
- **onDark(StackBoxStyler style)** → StackBoxStyler - Applies style in dark mode
- **onLight(StackBoxStyler style)** → StackBoxStyler - Applies style in light mode
- **onNot(ContextVariant contextVariant, StackBoxStyler style)** → StackBoxStyler - Applies style when context variant is NOT active

#### State Variants
- **onHovered(StackBoxStyler style)** → StackBoxStyler - Applies style on hover
- **onPressed(StackBoxStyler style)** → StackBoxStyler - Applies style when pressed
- **onFocused(StackBoxStyler style)** → StackBoxStyler - Applies style when focused
- **onDisabled(StackBoxStyler style)** → StackBoxStyler - Applies style when disabled
- **onSelected(StackBoxStyler style)** → StackBoxStyler - Applies style when selected

#### Responsive Variants
- **onBreakpoint(Breakpoint breakpoint, StackBoxStyler style)** → StackBoxStyler - Applies style at specific breakpoint

#### Builder Variant
- **builder(StackBoxStyler Function(BuildContext context) fn)** → StackBoxStyler - Creates context-dependent styling

## Spacing Methods (from SpacingStyleMixin)

### padding(EdgeInsetsGeometryMix value) → StackBoxStyler
Sets padding using EdgeInsetsGeometryMix for the stack container.

### margin(EdgeInsetsGeometryMix value) → StackBoxStyler
Sets margin using EdgeInsetsGeometryMix for the stack container.

#### Padding Methods
- **paddingX(double value)** → StackBoxStyler - Sets left and right padding
- **paddingY(double value)** → StackBoxStyler - Sets top and bottom padding

#### Margin Methods
- **marginX(double value)** → StackBoxStyler - Sets left and right margin
- **marginY(double value)** → StackBoxStyler - Sets top and bottom margin

## Constraint Methods (from ConstraintStyleMixin)

### constraints(BoxConstraintsMix value) → StackBoxStyler
Sets box constraints for the stack container.

#### Size Methods
- **width(double value)** → StackBoxStyler - Sets both min and max width
- **height(double value)** → StackBoxStyler - Sets both min and max height
- **size(double width, double height)** → StackBoxStyler - Sets both width and height
- **minWidth(double value)** → StackBoxStyler - Sets minimum width constraint
- **maxWidth(double value)** → StackBoxStyler - Sets maximum width constraint
- **minHeight(double value)** → StackBoxStyler - Sets minimum height constraint
- **maxHeight(double value)** → StackBoxStyler - Sets maximum height constraint

#### Advanced Constraints
- **constraintsOnly({double? width, double? height, double? minWidth, double? maxWidth, double? minHeight, double? maxHeight})** → StackBoxStyler - Creates constraints with only specified values

## Border Radius Methods (from BorderRadiusStyleMixin)

### borderRadius(BorderRadiusGeometryMix value) → StackBoxStyler
Sets border radius for the stack container.

#### Individual Corner Methods (Radius values)
- **borderRadiusAll(Radius radius)** → StackBoxStyler - Sets radius on all corners
- **borderRadiusTop(Radius radius)** → StackBoxStyler - Sets radius on top corners
- **borderRadiusBottom(Radius radius)** → StackBoxStyler - Sets radius on bottom corners
- **borderRadiusLeft(Radius radius)** → StackBoxStyler - Sets radius on left corners
- **borderRadiusRight(Radius radius)** → StackBoxStyler - Sets radius on right corners
- **borderRadiusTopLeft(Radius radius)** → StackBoxStyler - Sets top-left corner radius
- **borderRadiusTopRight(Radius radius)** → StackBoxStyler - Sets top-right corner radius
- **borderRadiusBottomLeft(Radius radius)** → StackBoxStyler - Sets bottom-left corner radius
- **borderRadiusBottomRight(Radius radius)** → StackBoxStyler - Sets bottom-right corner radius

#### Directional Corner Methods (RTL-aware)
- **borderRadiusTopStart(Radius radius)** → StackBoxStyler - Sets top-start corner radius
- **borderRadiusTopEnd(Radius radius)** → StackBoxStyler - Sets top-end corner radius
- **borderRadiusBottomStart(Radius radius)** → StackBoxStyler - Sets bottom-start corner radius
- **borderRadiusBottomEnd(Radius radius)** → StackBoxStyler - Sets bottom-end corner radius

#### Rounded Shortcuts (using double values)
- **borderRounded(double radius)** → StackBoxStyler - Sets circular radius on all corners
- **borderRoundedTop(double radius)** → StackBoxStyler - Sets circular radius on top corners
- **borderRoundedBottom(double radius)** → StackBoxStyler - Sets circular radius on bottom corners
- **borderRoundedLeft(double radius)** → StackBoxStyler - Sets circular radius on left corners
- **borderRoundedRight(double radius)** → StackBoxStyler - Sets circular radius on right corners
- **borderRoundedTopLeft(double radius)** → StackBoxStyler - Sets circular top-left corner radius
- **borderRoundedTopRight(double radius)** → StackBoxStyler - Sets circular top-right corner radius
- **borderRoundedBottomLeft(double radius)** → StackBoxStyler - Sets circular bottom-left corner radius
- **borderRoundedBottomRight(double radius)** → StackBoxStyler - Sets circular bottom-right corner radius
- **borderRoundedTopStart(double radius)** → StackBoxStyler - Sets circular top-start corner radius
- **borderRoundedTopEnd(double radius)** → StackBoxStyler - Sets circular top-end corner radius
- **borderRoundedBottomStart(double radius)** → StackBoxStyler - Sets circular bottom-start corner radius
- **borderRoundedBottomEnd(double radius)** → StackBoxStyler - Sets circular bottom-end corner radius

## Decoration Methods (from DecorationStyleMixin)

### decoration(DecorationMix value) → StackBoxStyler
Sets decoration for the stack container.

### foregroundDecoration(DecorationMix value) → StackBoxStyler
Sets foreground decoration for the stack container.

## Transform Methods (from TransformStyleMixin)

### transform(Matrix4 value, {AlignmentGeometry alignment = Alignment.center}) → StackBoxStyler
Sets transform matrix for the stack container.

## Usage Examples

### Using StackBoxStyler Constructor
```dart
// Basic styled stack container
final styledStack = StackBoxStyler(
  // Box styling
  decoration: DecorationMix(
    color: Colors.blue.shade100,
    borderRadius: BorderRadiusGeometryMix.circular(12),
    border: BoxBorderMix.all(color: Colors.blue.shade300),
  ),
  padding: EdgeInsetsGeometryMix.all(16),
  margin: EdgeInsetsGeometryMix.only(bottom: 8),
  // Stack behavior
  stackAlignment: Alignment.center,
  fit: StackFit.expand,
);

// Card with overlay
final cardWithOverlay = StackBoxStyler(
  decoration: DecorationMix(
    color: Colors.white,
    borderRadius: BorderRadiusGeometryMix.circular(8),
    boxShadow: [
      BoxShadowMix(
        color: Colors.black26,
        offset: Offset(0, 2),
        blurRadius: 4,
      ),
    ],
  ),
  padding: EdgeInsetsGeometryMix.zero,
  stackAlignment: Alignment.topRight,
  fit: StackFit.loose,
  clipBehavior: Clip.antiAlias,
);
```

### Using StackBoxSpecUtility
```dart
// Using the utility factory
final utility = StackBoxSpecUtility.self;

final styledContainer = utility.only(
  decoration: DecorationMix.color(Colors.grey.shade100),
  padding: EdgeInsetsGeometryMix.all(20),
  borderRadius: BorderRadiusGeometryMix.circular(16),
  stackAlignment: Alignment.bottomCenter,
  fit: StackFit.expand,
);
```

### Combining Individual Utilities
```dart
// Leverage existing global utilities
final backgroundStyle = $box
  .color.gradient.linear(
    colors: [Colors.purple.shade400, Colors.blue.shade400],
  )
  .borderRadius(16)
  .padding.all(24);

final stackBehavior = $stack
  .alignment.center()
  .fit.expand();

// Combine in StackBoxStyler
final combinedStyle = StackBoxStyler(
  decoration: backgroundStyle.$decoration?.resolve(context),
  padding: backgroundStyle.$padding?.resolve(context),
  stackAlignment: Alignment.center,
  fit: StackFit.expand,
);
```

### Common StackBox Patterns
```dart
// Hero section with overlay
final heroSection = StackBoxStyler(
  decoration: DecorationMix.color(Colors.black),
  stackAlignment: Alignment.center,
  fit: StackFit.expand,
  clipBehavior: Clip.hardEdge,
);

// Profile card with badge
final profileCard = StackBoxStyler(
  decoration: DecorationMix(
    color: Colors.white,
    borderRadius: BorderRadiusGeometryMix.circular(12),
    border: BoxBorderMix.all(color: Colors.grey.shade200),
  ),
  padding: EdgeInsetsGeometryMix.all(16),
  stackAlignment: Alignment.topRight,
  fit: StackFit.loose,
);

// Modal backdrop
final modalBackdrop = StackBoxStyler(
  decoration: DecorationMix.color(Colors.black54),
  stackAlignment: Alignment.center,
  fit: StackFit.expand,
);

// Notification badge container
final badgeContainer = StackBoxStyler(
  stackAlignment: Alignment.topRight,
  fit: StackFit.loose,
  clipBehavior: Clip.none,
);

// Image with gradient overlay
final imageOverlay = StackBoxStyler(
  decoration: DecorationMix.gradient(
    GradientMix.linear(
      colors: [Colors.transparent, Colors.black54],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    ),
  ),
  stackAlignment: Alignment.bottomLeft,
  fit: StackFit.expand,
  clipBehavior: Clip.antiAlias,
);
```

### Advanced Styling
```dart
// Complex layered design
final complexStack = StackBoxStyler(
  decoration: DecorationMix(
    color: Colors.white,
    borderRadius: BorderRadiusGeometryMix.circular(20),
    boxShadow: [
      BoxShadowMix(
        color: Colors.black12,
        offset: Offset(0, 8),
        blurRadius: 16,
        spreadRadius: 0,
      ),
    ],
  ),
  padding: EdgeInsetsGeometryMix.all(0),
  margin: EdgeInsetsGeometryMix.all(16),
  constraints: BoxConstraintsMix(maxWidth: 400),
  stackAlignment: Alignment.topCenter,
  fit: StackFit.loose,
  clipBehavior: Clip.antiAlias,
);
```

## Best Practices

1. **Use individual utilities when possible**: Leverage `$box` and `$stack` utilities for simpler styling needs.

2. **Combine utilities for complex layouts**: Use StackBoxStyler when you need both container styling and stack behavior.

3. **Consider performance**: Use `Clip.hardEdge` for better performance when anti-aliasing isn't needed.

4. **Layer management**: Use appropriate `StackFit` values based on your layout needs:
   - `StackFit.loose` for independent child sizing
   - `StackFit.expand` for children that should fill the container
   - `StackFit.passthrough` for constraint passing

5. **Alignment consistency**: Consider using consistent alignment values across your stack containers for visual cohesion.
