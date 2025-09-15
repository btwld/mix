# BoxStyler API Reference

## Overview
The `BoxStyler` class is an **immutable style class** for box layouts in Mix. It represents a finalized box style with all properties resolved, created either through direct instantiation or as the result of utility building. BoxStyler provides instance methods through mixins for convenient style manipulation and supports widget modifiers, variants, and animations.

**Type Alias:** `BoxMix = BoxStyler`

**Relationship to Utilities:** BoxStyler is the **immutable result** produced by `BoxSpecUtility` (accessed via `$box`). While `$box.color.red().padding.all(16)` uses the fluent utility API, the final result is a `BoxStyler` instance.

## Constructors

### BoxStyler({...}) → BoxStyler
Main constructor with optional parameters for all box properties.
```dart
BoxStyler({
  AlignmentGeometry? alignment,
  EdgeInsetsGeometryMix? padding,
  EdgeInsetsGeometryMix? margin,
  BoxConstraintsMix? constraints,
  DecorationMix? decoration,
  DecorationMix? foregroundDecoration,
  Matrix4? transform,
  AlignmentGeometry? transformAlignment,
  Clip? clipBehavior,
  AnimationConfig? animation,
  ModifierConfig? modifier,
  List<VariantStyle<BoxSpec>>? variants,
})
```

### BoxStyler.create({...}) → BoxStyler
Internal constructor using `Prop<T>` types for advanced usage.
```dart
const BoxStyler.create({
  Prop<AlignmentGeometry>? alignment,
  Prop<EdgeInsetsGeometry>? padding,
  Prop<EdgeInsetsGeometry>? margin,
  Prop<BoxConstraints>? constraints,
  Prop<Decoration>? decoration,
  Prop<Decoration>? foregroundDecoration,
  Prop<Matrix4>? transform,
  Prop<AlignmentGeometry>? transformAlignment,
  Prop<Clip>? clipBehavior,
  List<VariantStyle<BoxSpec>>? variants,
  ModifierConfig? modifier,
  AnimationConfig? animation,
})
```

### BoxStyler.builder(BoxStyler Function(BuildContext)) → BoxStyler
Factory constructor for context-dependent styling.

## Static Properties

### BoxStyler.chain → BoxSpecUtility
Static accessor providing utility methods for chaining box styling operations.

**Note:** For utility-based styling documentation, see [BoxSpecUtility API Reference](box_util_api.md).

## Core Methods

### call({Widget? child}) → Box
Creates a `Box` widget with this style applied. This is the primary method for converting a style into a widget.

### resolve(BuildContext context) → StyleSpec<BoxSpec>
Resolves all properties using the provided context, converting tokens and contextual values into concrete specifications.

### merge(BoxStyler? other) → BoxStyler
Merges this BoxStyler with another, with the other's properties taking precedence for non-null values.

## Instance Methods

### Core Layout Methods

#### alignment(AlignmentGeometry value) → BoxStyler
Sets the alignment of the child within the box.

#### clipBehavior(Clip value) → BoxStyler
Sets how the box clips its child.

### Spacing Methods (from SpacingStyleMixin)

#### Base Methods
- **padding(EdgeInsetsGeometryMix value)** → BoxStyler - Sets internal padding
- **margin(EdgeInsetsGeometryMix value)** → BoxStyler - Sets external margin

#### Padding Convenience Methods
- **paddingAll(double value)** → BoxStyler - Sets padding on all sides
- **paddingTop(double value)** → BoxStyler - Sets top padding
- **paddingBottom(double value)** → BoxStyler - Sets bottom padding
- **paddingLeft(double value)** → BoxStyler - Sets left padding
- **paddingRight(double value)** → BoxStyler - Sets right padding
- **paddingX(double value)** → BoxStyler - Sets horizontal padding (left & right)
- **paddingY(double value)** → BoxStyler - Sets vertical padding (top & bottom)
- **paddingStart(double value)** → BoxStyler - Sets start padding (RTL-aware)
- **paddingEnd(double value)** → BoxStyler - Sets end padding (RTL-aware)
- **paddingOnly({double? horizontal, vertical, start, end, left, right, top, bottom})** → BoxStyler - Sets specific padding sides with priority resolution

#### Margin Convenience Methods
- **marginAll(double value)** → BoxStyler - Sets margin on all sides
- **marginTop(double value)** → BoxStyler - Sets top margin
- **marginBottom(double value)** → BoxStyler - Sets bottom margin
- **marginLeft(double value)** → BoxStyler - Sets left margin
- **marginRight(double value)** → BoxStyler - Sets right margin
- **marginX(double value)** → BoxStyler - Sets horizontal margin (left & right)
- **marginY(double value)** → BoxStyler - Sets vertical margin (top & bottom)
- **marginStart(double value)** → BoxStyler - Sets start margin (RTL-aware)
- **marginEnd(double value)** → BoxStyler - Sets end margin (RTL-aware)
- **marginOnly({double? horizontal, vertical, start, end, left, right, top, bottom})** → BoxStyler - Sets specific margin sides with priority resolution

### Constraint Methods (from ConstraintStyleMixin)

#### Base Method
- **constraints(BoxConstraintsMix value)** → BoxStyler - Sets box constraints

#### Convenience Methods
- **width(double value)** → BoxStyler - Sets fixed width (min and max)
- **height(double value)** → BoxStyler - Sets fixed height (min and max)
- **minWidth(double value)** → BoxStyler - Sets minimum width
- **maxWidth(double value)** → BoxStyler - Sets maximum width
- **minHeight(double value)** → BoxStyler - Sets minimum height
- **maxHeight(double value)** → BoxStyler - Sets maximum height
- **size(double width, double height)** → BoxStyler - Sets both width and height
- **constraintsOnly({double? width, double? height, double? minWidth, double? maxWidth, double? minHeight, double? maxHeight})** → BoxStyler - Sets specific constraints with priority resolution

### Border Methods (from BorderStyleMixin)

#### Individual Border Sides
- **borderTop({Color? color, double? width, BorderStyle? style, double? strokeAlign})** → BoxStyler
- **borderBottom({Color? color, double? width, BorderStyle? style, double? strokeAlign})** → BoxStyler
- **borderLeft({Color? color, double? width, BorderStyle? style, double? strokeAlign})** → BoxStyler
- **borderRight({Color? color, double? width, BorderStyle? style, double? strokeAlign})** → BoxStyler

#### Directional Borders (RTL-aware)
- **borderStart({Color? color, double? width, BorderStyle? style, double? strokeAlign})** → BoxStyler
- **borderEnd({Color? color, double? width, BorderStyle? style, double? strokeAlign})** → BoxStyler

#### Border Groups
- **borderAll({Color? color, double? width, BorderStyle? style, double? strokeAlign})** → BoxStyler - Sets all borders
- **borderVertical({Color? color, double? width, BorderStyle? style, double? strokeAlign})** → BoxStyler - Sets top and bottom borders
- **borderHorizontal({Color? color, double? width, BorderStyle? style, double? strokeAlign})** → BoxStyler - Sets left and right borders

### Border Radius Methods (from BorderRadiusStyleMixin)

#### Base Method
- **borderRadius(BorderRadiusGeometryMix value)** → BoxStyler - Sets border radius

#### Individual Corner Methods (Radius values)
- **borderRadiusAll(Radius radius)** → BoxStyler
- **borderRadiusTop(Radius radius)** → BoxStyler - Top corners
- **borderRadiusBottom(Radius radius)** → BoxStyler - Bottom corners
- **borderRadiusLeft(Radius radius)** → BoxStyler - Left corners
- **borderRadiusRight(Radius radius)** → BoxStyler - Right corners
- **borderRadiusTopLeft(Radius radius)** → BoxStyler
- **borderRadiusTopRight(Radius radius)** → BoxStyler
- **borderRadiusBottomLeft(Radius radius)** → BoxStyler
- **borderRadiusBottomRight(Radius radius)** → BoxStyler

#### Directional Corner Methods (RTL-aware)
- **borderRadiusTopStart(Radius radius)** → BoxStyler
- **borderRadiusTopEnd(Radius radius)** → BoxStyler
- **borderRadiusBottomStart(Radius radius)** → BoxStyler
- **borderRadiusBottomEnd(Radius radius)** → BoxStyler

#### Rounded Shortcuts (double values)
- **borderRounded(double radius)** → BoxStyler - All corners
- **borderRoundedTop(double radius)** → BoxStyler - Top corners
- **borderRoundedBottom(double radius)** → BoxStyler - Bottom corners
- **borderRoundedLeft(double radius)** → BoxStyler - Left corners
- **borderRoundedRight(double radius)** → BoxStyler - Right corners
- **borderRoundedTopLeft(double radius)** → BoxStyler
- **borderRoundedTopRight(double radius)** → BoxStyler
- **borderRoundedBottomLeft(double radius)** → BoxStyler
- **borderRoundedBottomRight(double radius)** → BoxStyler
- **borderRoundedTopStart(double radius)** → BoxStyler - RTL-aware
- **borderRoundedTopEnd(double radius)** → BoxStyler - RTL-aware
- **borderRoundedBottomStart(double radius)** → BoxStyler - RTL-aware
- **borderRoundedBottomEnd(double radius)** → BoxStyler - RTL-aware

### Decoration Methods (from DecorationStyleMixin)

#### Base Methods
- **decoration(DecorationMix value)** → BoxStyler - Sets box decoration
- **foregroundDecoration(DecorationMix value)** → BoxStyler - Sets foreground decoration

#### Color & Gradient Methods
- **color(Color value)** → BoxStyler - Sets background color
- **gradient(GradientMix value)** → BoxStyler - Sets gradient background
- **linearGradient({required List<Color> colors, List<double>? stops, AlignmentGeometry? begin, end, TileMode? tileMode})** → BoxStyler
- **radialGradient({required List<Color> colors, List<double>? stops, AlignmentGeometry? center, double? radius, AlignmentGeometry? focal, double? focalRadius, TileMode? tileMode})** → BoxStyler
- **sweepGradient({required List<Color> colors, List<double>? stops, AlignmentGeometry? center, double? startAngle, endAngle, TileMode? tileMode})** → BoxStyler

#### Shape Methods
- **shape(ShapeBorderMix value)** → BoxStyler - Sets box shape
- **shapeCircle({BorderSideMix? side})** → BoxStyler - Circular shape
- **shapeStadium({BorderSideMix? side})** → BoxStyler - Stadium shape
- **shapeRoundedRectangle({BorderSideMix? side, BorderRadiusMix? borderRadius})** → BoxStyler
- **shapeBeveledRectangle({BorderSideMix? side, BorderRadiusMix? borderRadius})** → BoxStyler
- **shapeContinuousRectangle({BorderSideMix? side, BorderRadiusMix? borderRadius})** → BoxStyler
- **shapeStar({BorderSideMix? side, double? points, innerRadiusRatio, pointRounding, valleyRounding, rotation, squash})** → BoxStyler
- **shapeLinear({BorderSideMix? side, LinearBorderEdgeMix? start, end, top, bottom})** → BoxStyler
- **shapeSuperellipse({BorderSideMix? side, BorderRadiusMix? borderRadius})** → BoxStyler

#### Background Image Methods
- **backgroundImage(ImageProvider image, {BoxFit? fit, AlignmentGeometry? alignment, ImageRepeat repeat})** → BoxStyler
- **backgroundImageUrl(String url, {BoxFit? fit, AlignmentGeometry? alignment, ImageRepeat repeat})** → BoxStyler
- **backgroundImageAsset(String path, {BoxFit? fit, AlignmentGeometry? alignment, ImageRepeat repeat})** → BoxStyler

#### Image Decoration Methods
- **image(DecorationImageMix value)** → BoxStyler - Sets decoration image

#### Foreground Gradient Methods
- **foregroundLinearGradient({required List<Color> colors, List<double>? stops, AlignmentGeometry? begin, end, TileMode? tileMode})** → BoxStyler
- **foregroundRadialGradient({required List<Color> colors, List<double>? stops, AlignmentGeometry? center, double? radius, AlignmentGeometry? focal, double? focalRadius, TileMode? tileMode})** → BoxStyler
- **foregroundSweepGradient({required List<Color> colors, List<double>? stops, AlignmentGeometry? center, double? startAngle, endAngle, TileMode? tileMode})** → BoxStyler

### Shadow Methods (from ShadowStyleMixin)

#### Shadow Methods
- **shadowOnly({Color? color, Offset? offset, double? blurRadius, spreadRadius})** → BoxStyler - Creates single shadow
- **boxShadows(List<BoxShadowMix> value)** → BoxStyler - Sets multiple shadows
- **boxElevation(ElevationShadow value)** → BoxStyler - Sets Material elevation shadow

#### From DecorationStyleMixin
- **shadow(BoxShadowMix value)** → BoxStyler - Sets single shadow
- **shadows(List<BoxShadowMix> value)** → BoxStyler - Sets multiple shadows
- **elevation(ElevationShadow value)** → BoxStyler - Sets elevation shadow

### Transform Methods (from TransformStyleMixin)

- **transform(Matrix4 value, {AlignmentGeometry alignment = Alignment.center})** → BoxStyler - Sets transformation matrix and origin

## Animation & Modifiers

### animate(AnimationConfig animation) → BoxStyler
Applies animation configuration to the box style.

### modifier(ModifierConfig value) → BoxStyler
Adds widget modifiers that wrap the box widget.

### wrap(ModifierConfig value) → BoxStyler
Alias for `modifier()` - adds widget modifiers.

## Variants

### variants(List<VariantStyle<BoxSpec>> value) → BoxStyler
Sets conditional styling variants based on context or state.

## Properties (Read-only)

The following properties are available as readonly `Prop<T>` values:

- **$alignment** → `Prop<AlignmentGeometry>?` - Child alignment
- **$padding** → `Prop<EdgeInsetsGeometry>?` - Internal padding
- **$margin** → `Prop<EdgeInsetsGeometry>?` - External margin  
- **$constraints** → `Prop<BoxConstraints>?` - Size constraints
- **$decoration** → `Prop<Decoration>?` - Box decoration
- **$foregroundDecoration** → `Prop<Decoration>?` - Foreground decoration
- **$transform** → `Prop<Matrix4>?` - Transformation matrix
- **$transformAlignment** → `Prop<AlignmentGeometry>?` - Transform origin
- **$clipBehavior** → `Prop<Clip>?` - Clipping behavior

## Modifier Methods (from ModifierStyleMixin)

### wrap(ModifierConfig value) → BoxStyler
Applies the given modifier configuration to wrap the box widget.

#### Layout Modifiers
- **wrapOpacity(double opacity)** → BoxStyler - Wraps with opacity modifier
- **wrapPadding(EdgeInsetsGeometryMix padding)** → BoxStyler - Wraps with padding modifier
- **wrapSizedBox({double? width, double? height})** → BoxStyler - Wraps with sized box
- **wrapConstrainedBox(BoxConstraints constraints)** → BoxStyler - Wraps with constrained box
- **wrapAspectRatio(double aspectRatio)** → BoxStyler - Wraps with aspect ratio modifier

#### Positioning Modifiers
- **wrapAlign(AlignmentGeometry alignment)** → BoxStyler - Wraps with align modifier
- **wrapCenter()** → BoxStyler - Wraps with center alignment modifier
- **wrapFractionallySizedBox({double? widthFactor, double? heightFactor, AlignmentGeometry alignment = Alignment.center})** → BoxStyler - Wraps with fractionally sized box

#### Transform Modifiers
- **wrapScale(double scale, {Alignment alignment = Alignment.center})** → BoxStyler - Wraps with scale transform
- **wrapRotate(double angle, {Alignment alignment = Alignment.center})** → BoxStyler - Wraps with rotation transform
- **wrapTranslate(double x, double y, [double z = 0.0])** → BoxStyler - Wraps with translation transform
- **wrapTransform(Matrix4 transform, {Alignment alignment = Alignment.center})** → BoxStyler - Wraps with custom transform
- **wrapRotatedBox(int quarterTurns)** → BoxStyler - Wraps with rotated box modifier

#### Clipping Modifiers
- **wrapClipOval({CustomClipper<Rect>? clipper, Clip? clipBehavior})** → BoxStyler - Wraps with oval clipping
- **wrapClipRect({CustomClipper<Rect>? clipper, Clip? clipBehavior})** → BoxStyler - Wraps with rectangular clipping
- **wrapClipPath({CustomClipper<Path>? clipper, Clip? clipBehavior})** → BoxStyler - Wraps with path clipping
- **wrapClipTriangle({Clip? clipBehavior})** → BoxStyler - Wraps with triangle clipping
- **wrapClipRRect({required BorderRadius borderRadius, CustomClipper<RRect>? clipper, Clip? clipBehavior})** → BoxStyler - Wraps with rounded rectangle clipping

#### Flex Modifiers
- **wrapFlexible({int flex = 1, FlexFit fit = FlexFit.loose})** → BoxStyler - Wraps with flexible modifier
- **wrapExpanded({int flex = 1})** → BoxStyler - Wraps with expanded modifier

#### Visibility & Behavior
- **wrapVisibility(bool visible)** → BoxStyler - Wraps with visibility modifier
- **wrapIntrinsicWidth()** → BoxStyler - Wraps with intrinsic width modifier
- **wrapIntrinsicHeight()** → BoxStyler - Wraps with intrinsic height modifier
- **wrapMouseCursor(MouseCursor cursor)** → BoxStyler - Wraps with mouse cursor modifier

#### Theme Modifiers
- **wrapDefaultTextStyle(TextStyleMix style)** → BoxStyler - Wraps with default text style modifier
- **wrapIconTheme(IconThemeData data)** → BoxStyler - Wraps with icon theme modifier
- **wrapBox(BoxStyler spec)** → BoxStyler - Wraps with box modifier

## Animation Methods (from AnimationStyleMixin)

### animate(AnimationConfig config) → BoxStyler
Applies animation configuration to the box style.

### keyframeAnimation({required Listenable trigger, required List<KeyframeTrack> timeline, required KeyframeStyleBuilder<BoxSpec, BoxStyler> styleBuilder}) → BoxStyler
Creates keyframe-based animation with timeline control.

### phaseAnimation<P>({required Listenable trigger, required List<P> phases, required BoxStyler Function(P phase, BoxStyler style) styleBuilder, required CurveAnimationConfig Function(P phase) configBuilder}) → BoxStyler
Creates phase-based animation with custom curve configurations for each phase.

## Variant Methods

### variants(List<VariantStyle<BoxSpec>> value) → BoxStyler
Sets conditional styling variants based on context or state.

### variant(Variant variant, BoxStyler style) → BoxStyler
Adds a single variant with the given variant condition and style.

#### Context Variants
- **onDark(BoxStyler style)** → BoxStyler - Applies style in dark mode
- **onLight(BoxStyler style)** → BoxStyler - Applies style in light mode
- **onNot(ContextVariant contextVariant, BoxStyler style)** → BoxStyler - Applies style when context variant is NOT active

#### State Variants
- **onHovered(BoxStyler style)** → BoxStyler - Applies style on hover
- **onPressed(BoxStyler style)** → BoxStyler - Applies style when pressed
- **onFocused(BoxStyler style)** → BoxStyler - Applies style when focused
- **onDisabled(BoxStyler style)** → BoxStyler - Applies style when disabled
- **onSelected(BoxStyler style)** → BoxStyler - Applies style when selected

#### Responsive Variants
- **onBreakpoint(Breakpoint breakpoint, BoxStyler style)** → BoxStyler - Applies style at specific breakpoint

#### Builder Variant
- **builder(BoxStyler Function(BuildContext context) fn)** → BoxStyler - Creates context-dependent styling

## Border Methods (from BorderStyleMixin)

### border(BoxBorderMix value) → BoxStyler
Sets border styling for the box container.

## Border Radius Methods (from BorderRadiusStyleMixin)

### borderRadius(BorderRadiusGeometryMix value) → BoxStyler
Sets border radius for the box container.

#### Individual Corner Methods (Radius values)
- **borderRadiusAll(Radius radius)** → BoxStyler - Sets radius on all corners
- **borderRadiusTop(Radius radius)** → BoxStyler - Sets radius on top corners
- **borderRadiusBottom(Radius radius)** → BoxStyler - Sets radius on bottom corners
- **borderRadiusLeft(Radius radius)** → BoxStyler - Sets radius on left corners
- **borderRadiusRight(Radius radius)** → BoxStyler - Sets radius on right corners
- **borderRadiusTopLeft(Radius radius)** → BoxStyler - Sets top-left corner radius
- **borderRadiusTopRight(Radius radius)** → BoxStyler - Sets top-right corner radius
- **borderRadiusBottomLeft(Radius radius)** → BoxStyler - Sets bottom-left corner radius
- **borderRadiusBottomRight(Radius radius)** → BoxStyler - Sets bottom-right corner radius

#### Directional Corner Methods (RTL-aware)
- **borderRadiusTopStart(Radius radius)** → BoxStyler - Sets top-start corner radius
- **borderRadiusTopEnd(Radius radius)** → BoxStyler - Sets top-end corner radius
- **borderRadiusBottomStart(Radius radius)** → BoxStyler - Sets bottom-start corner radius
- **borderRadiusBottomEnd(Radius radius)** → BoxStyler - Sets bottom-end corner radius

#### Rounded Shortcuts (using double values)
- **borderRounded(double radius)** → BoxStyler - Sets circular radius on all corners
- **borderRoundedTop(double radius)** → BoxStyler - Sets circular radius on top corners
- **borderRoundedBottom(double radius)** → BoxStyler - Sets circular radius on bottom corners
- **borderRoundedLeft(double radius)** → BoxStyler - Sets circular radius on left corners
- **borderRoundedRight(double radius)** → BoxStyler - Sets circular radius on right corners
- **borderRoundedTopLeft(double radius)** → BoxStyler - Sets circular top-left corner radius
- **borderRoundedTopRight(double radius)** → BoxStyler - Sets circular top-right corner radius
- **borderRoundedBottomLeft(double radius)** → BoxStyler - Sets circular bottom-left corner radius
- **borderRoundedBottomRight(double radius)** → BoxStyler - Sets circular bottom-right corner radius
- **borderRoundedTopStart(double radius)** → BoxStyler - Sets circular top-start corner radius
- **borderRoundedTopEnd(double radius)** → BoxStyler - Sets circular top-end corner radius
- **borderRoundedBottomStart(double radius)** → BoxStyler - Sets circular bottom-start corner radius
- **borderRoundedBottomEnd(double radius)** → BoxStyler - Sets circular bottom-end corner radius

## Shadow Methods (from ShadowStyleMixin)

### shadow(List<BoxShadowMix> value) → BoxStyler
Sets box shadows for the box container.

## Decoration Methods (from DecorationStyleMixin)

### decoration(DecorationMix value) → BoxStyler
Sets decoration for the box container.

### foregroundDecoration(DecorationMix value) → BoxStyler
Sets foreground decoration for the box container.

## Transform Methods (from TransformStyleMixin)

### transform(Matrix4 value, {AlignmentGeometry alignment = Alignment.center}) → BoxStyler
Sets transform matrix for the box container.

## Spacing Methods (from SpacingStyleMixin)

### padding(EdgeInsetsGeometryMix value) → BoxStyler
Sets padding using EdgeInsetsGeometryMix for the box container.

### margin(EdgeInsetsGeometryMix value) → BoxStyler
Sets margin using EdgeInsetsGeometryMix for the box container.

#### Padding Methods
- **paddingX(double value)** → BoxStyler - Sets left and right padding
- **paddingY(double value)** → BoxStyler - Sets top and bottom padding

#### Margin Methods
- **marginX(double value)** → BoxStyler - Sets left and right margin
- **marginY(double value)** → BoxStyler - Sets top and bottom margin

## Constraint Methods (from ConstraintStyleMixin)

### constraints(BoxConstraintsMix value) → BoxStyler
Sets box constraints for the box container.

#### Size Methods
- **width(double value)** → BoxStyler - Sets both min and max width
- **height(double value)** → BoxStyler - Sets both min and max height
- **size(double width, double height)** → BoxStyler - Sets both width and height
- **minWidth(double value)** → BoxStyler - Sets minimum width constraint
- **maxWidth(double value)** → BoxStyler - Sets maximum width constraint
- **minHeight(double value)** → BoxStyler - Sets minimum height constraint
- **maxHeight(double value)** → BoxStyler - Sets maximum height constraint

#### Advanced Constraints
- **constraintsOnly({double? width, double? height, double? minWidth, double? maxWidth, double? minHeight, double? maxHeight})** → BoxStyler - Creates constraints with only specified values

## Usage Examples

### Using BoxStyler Directly (Advanced)
```dart
// Direct instantiation with constructor
final style = BoxStyler(
  padding: EdgeInsetsGeometryMix.all(16),
  decoration: DecorationMix(
    color: Colors.blue,
    borderRadius: BorderRadiusGeometryMix.circular(8),
  ),
  animation: AnimationConfig(duration: Duration(milliseconds: 300)),
);

// Using BoxStyler.create for advanced usage
final advancedStyle = BoxStyler.create(
  padding: Prop.value(EdgeInsets.all(16)),
  decoration: Prop.value(BoxDecoration(
    color: Colors.red,
    border: Border.all(width: 2, color: Colors.black),
    borderRadius: BorderRadius.circular(12),
  )),
  clipBehavior: Prop.value(Clip.antiAlias),
);
```

### Using Instance Methods (Recommended)
```dart
// Start with empty BoxStyler and build with instance methods
final boxStyle = BoxStyler()
  .paddingAll(16)
  .color(Colors.blue)
  .borderRounded(8)
  .animate(AnimationConfig(duration: Duration(milliseconds: 300)));
```

### Using Instance Methods
```dart
// Using instance methods for convenience
final cardStyle = BoxStyler()
  .color(Colors.white)
  .borderRounded(12)
  .shadowOnly(
    color: Colors.black26,
    offset: Offset(0, 2),
    blurRadius: 8,
  )
  .paddingAll(16);

// Complex border styling
final complexBorder = BoxStyler()
  .borderTop(color: Colors.blue, width: 2)
  .borderHorizontal(color: Colors.grey, width: 1)
  .borderRoundedTop(8);

// Gradient with shapes
final gradientCard = BoxStyler()
  .linearGradient(
    colors: [Colors.blue.shade400, Colors.purple.shade400],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  )
  .shapeRoundedRectangle(
    borderRadius: BorderRadiusMix.circular(16),
  )
  .paddingOnly(horizontal: 20, vertical: 16);
```

### Creating Widgets
```dart
// Using Style.box() factory (common pattern)
final widget = Style.box(
  padding: EdgeInsets.all(16),
  decoration: BoxDecoration(
    color: Colors.blue,
    borderRadius: BorderRadius.circular(8),
  ),
)(child: Text('Hello'));

// Using Box widget directly
final widget = Box(style: boxStyle, child: Text('Hello'));

// Using call operator on style
final widget = boxStyle(child: Text('Hello'));
```

### Common Patterns
```dart
// Card-like styling using instance methods
final cardStyle = BoxStyler()
  .color(Colors.white)
  .borderRounded(12)
  .shadowOnly(color: Colors.black12, offset: Offset(0, 2), blurRadius: 8)
  .paddingAll(16);

// Button-like styling using instance methods
final buttonStyle = BoxStyler()
  .color(Colors.blue)
  .borderRounded(8)
  .paddingOnly(
    horizontal: 24,
    vertical: 12,
  )
  .borderAll(
    color: Colors.blue.shade700,
    width: 1
  );

// Container with specific dimensions using instance methods
final containerStyle = BoxStyler()
  .size(300, 200)
  .color(Colors.grey.shade100)
  .borderAll(color: Colors.grey)
  .paddingAll(20);

// Advanced styling with multiple mixins
final advancedStyle = BoxStyler()
  .linearGradient(
    colors: [Colors.blue, Colors.purple],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  )
  .shapeRoundedRectangle(
    borderRadius: BorderRadiusMix.circular(16),
  )
  .wrapOpacity(0.9)
  .onHovered(BoxStyler().transform(
    Matrix4.identity()..scale(1.05),
  ));
```
