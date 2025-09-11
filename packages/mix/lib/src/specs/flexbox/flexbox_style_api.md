# FlexBoxStyler API Reference

## Overview
The `FlexBoxStyler` class is an **immutable composite style class** that combines both Box and Flex styling capabilities in Mix. It represents a finalized flex container style with all properties resolved, created either through direct instantiation or as the result of utility building. FlexBoxStyler provides instance methods from multiple mixins for convenient style manipulation.

**Type Alias:** `FlexBoxMix = FlexBoxStyler`

**Relationship to Utilities:** FlexBoxStyler is the **immutable result** produced by `FlexBoxSpecUtility` (accessed via `$flexbox`). While `$flexbox.color.blue().direction.horizontal()` uses the fluent utility API, the final result is a `FlexBoxStyler` instance.

**Note:** For utility-based styling documentation, see [FlexBoxSpecUtility API Reference](flexbox_util_api.md).

## Utility Methods (via $flexbox)

### Box Properties

#### Layout & Spacing

##### $flexbox.padding → EdgeInsetsGeometryUtility
Provides padding configuration methods (same API as $box.padding):
- **$flexbox.padding.all(double)** → Sets padding on all sides
- **$flexbox.padding.horizontal(double)** → Sets left and right padding  
- **$flexbox.padding.vertical(double)** → Sets top and bottom padding
- **$flexbox.padding.top/bottom/left/right(double)** → Sets individual sides
- **$flexbox.padding.only({...})** → Sets specific sides
- **$flexbox.padding(double, ...)** → CSS-style shorthand

##### $flexbox.margin → EdgeInsetsGeometryUtility
Provides margin configuration methods (same API as padding):
- **$flexbox.margin.all(double)** → Sets margin on all sides
- **$flexbox.margin.horizontal/vertical(double)** → Sets directional margins
- **$flexbox.margin.top/bottom/left/right(double)** → Sets individual margins
- **$flexbox.margin.only({...})** → Sets specific sides

#### Size & Constraints

##### $flexbox.constraints → BoxConstraintsUtility
Provides constraint configuration methods:
- **$flexbox.constraints.minWidth/maxWidth(double)** → Sets width constraints
- **$flexbox.constraints.minHeight/maxHeight(double)** → Sets height constraints
- **$flexbox.constraints({...})** → Sets multiple constraints

##### Direct Size Utilities
- **$flexbox.width(double)** → Sets fixed width
- **$flexbox.height(double)** → Sets fixed height
- **$flexbox.minWidth/maxWidth/minHeight/maxHeight(double)** → Individual constraints

#### Visual Styling

##### $flexbox.decoration → DecorationUtility
Provides decoration configuration:
- **$flexbox.decoration.box** → BoxDecorationUtility
- **$flexbox.decoration.shape** → ShapeDecorationUtility

##### Direct Visual Utilities
- **$flexbox.color** → ColorUtility for background colors
- **$flexbox.gradient** → GradientUtility for gradient backgrounds
- **$flexbox.border** → BorderUtility for border styling
- **$flexbox.borderRadius** → BorderRadiusUtility for corner rounding
- **$flexbox.shape** → ShapeUtility for shape styling

#### Transform & Alignment

- **$flexbox.transform** → MixUtility for matrix transformations
- **$flexbox.transformAlignment** → MixUtility for transform origin
- **$flexbox.alignment** → MixUtility for child alignment within box
- **$flexbox.clipBehavior** → MixUtility for box clipping behavior

### Flex Properties

#### Layout Direction

- **$flexbox.direction** → MixUtility for flex direction (Axis.horizontal/vertical)

#### Main Axis Alignment

##### $flexbox.mainAxisAlignment → MixUtility
Controls how children are positioned along the main axis:
- **$flexbox.mainAxisAlignment(MainAxisAlignment)** → Sets main axis alignment
- **$flexbox.mainAxisAlignment.start()** → Aligns to start
- **$flexbox.mainAxisAlignment.end()** → Aligns to end
- **$flexbox.mainAxisAlignment.center()** → Centers children
- **$flexbox.mainAxisAlignment.spaceBetween()** → Space between children
- **$flexbox.mainAxisAlignment.spaceAround()** → Space around children
- **$flexbox.mainAxisAlignment.spaceEvenly()** → Even space distribution

#### Cross Axis Alignment

##### $flexbox.crossAxisAlignment → MixUtility
Controls how children are positioned along the cross axis:
- **$flexbox.crossAxisAlignment(CrossAxisAlignment)** → Sets cross axis alignment
- **$flexbox.crossAxisAlignment.start()** → Aligns to start
- **$flexbox.crossAxisAlignment.end()** → Aligns to end
- **$flexbox.crossAxisAlignment.center()** → Centers children
- **$flexbox.crossAxisAlignment.stretch()** → Stretches to fill
- **$flexbox.crossAxisAlignment.baseline()** → Baseline alignment

#### Size & Direction Control

- **$flexbox.mainAxisSize** → MixUtility for MainAxisSize (min/max)
- **$flexbox.verticalDirection** → MixUtility for VerticalDirection (up/down)
- **$flexbox.flexTextDirection** → MixUtility for flex text direction
- **$flexbox.textBaseline** → MixUtility for TextBaseline
- **$flexbox.flexClipBehavior** → MixUtility for flex-specific clipping

### Spacing Between Children

- **$flexbox.spacing(double)** → Sets spacing between flex children
- **$flexbox.gap(double)** → ⚠️ **Deprecated** - Use spacing instead

### Modifiers

- **$flexbox.wrap** → ModifierUtility for widget modifiers

## Constructors

### FlexBoxStyler({...}) → FlexBoxStyler
Main constructor with optional parameters for all flexbox properties.
```dart
FlexBoxStyler({
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
  // Flex properties
  Axis? direction,
  MainAxisAlignment? mainAxisAlignment,
  CrossAxisAlignment? crossAxisAlignment,
  MainAxisSize? mainAxisSize,
  VerticalDirection? verticalDirection,
  TextDirection? textDirection,
  TextBaseline? textBaseline,
  Clip? flexClipBehavior,
  double? spacing,
  // Style properties
  ModifierConfig? modifier,
  List<VariantStyle<FlexBoxSpec>>? variants,
})
```

### FlexBoxStyler.create({...}) → FlexBoxStyler
Internal constructor using `Prop<T>` types for advanced usage.

### FlexBoxStyler.builder(FlexBoxStyler Function(BuildContext)) → FlexBoxStyler
Factory constructor for context-dependent flexbox styling.

## Static Properties

### FlexBoxStyler.chain → FlexBoxSpecUtility
Static accessor providing utility methods for chaining flexbox styling operations.

## Core Methods

### resolve(BuildContext context) → StyleSpec<FlexBoxSpec>
Resolves all properties using the provided context, converting tokens and contextual values into concrete specifications.

### merge(FlexBoxStyler? other) → FlexBoxStyler
Merges this FlexBoxStyler with another, with the other's properties taking precedence for non-null values.

## Instance Methods

### Direct Methods
- **alignment(AlignmentGeometry value)** → FlexBoxStyler - Sets box alignment
- **transformAlignment(AlignmentGeometry value)** → FlexBoxStyler - Sets transform alignment
- **clipBehavior(Clip value)** → FlexBoxStyler - Sets box clip behavior
- **gap(double value)** → FlexBoxStyler - ⚠️ **Deprecated** - Use spacing instead
- **modifier(ModifierConfig value)** → FlexBoxStyler - Adds modifiers
- **wrap(ModifierConfig value)** → FlexBoxStyler - Alias for modifier()
- **variants(List<VariantStyle<FlexBoxSpec>> variants)** → FlexBoxStyler - Sets variants

### Spacing Methods (from SpacingStyleMixin)

#### Padding Convenience Methods
- **padding(EdgeInsetsGeometryMix value)** → FlexBoxStyler - Sets padding using EdgeInsetsGeometryMix
- **paddingAll(double value)** → FlexBoxStyler - Sets padding on all sides
- **paddingX(double value)** → FlexBoxStyler - Sets left and right padding
- **paddingY(double value)** → FlexBoxStyler - Sets top and bottom padding
- **paddingTop(double value)** → FlexBoxStyler - Sets top padding
- **paddingBottom(double value)** → FlexBoxStyler - Sets bottom padding
- **paddingLeft(double value)** → FlexBoxStyler - Sets left padding
- **paddingRight(double value)** → FlexBoxStyler - Sets right padding
- **paddingStart(double value)** → FlexBoxStyler - Sets start padding (direction-aware)
- **paddingEnd(double value)** → FlexBoxStyler - Sets end padding (direction-aware)
- **paddingOnly({double? horizontal, double? vertical, double? start, double? end, double? left, double? right, double? top, double? bottom})** → FlexBoxStyler - Sets padding on specific sides with priority resolution

#### Margin Convenience Methods
- **margin(EdgeInsetsGeometryMix value)** → FlexBoxStyler - Sets margin using EdgeInsetsGeometryMix
- **marginAll(double value)** → FlexBoxStyler - Sets margin on all sides
- **marginX(double value)** → FlexBoxStyler - Sets left and right margin
- **marginY(double value)** → FlexBoxStyler - Sets top and bottom margin
- **marginTop(double value)** → FlexBoxStyler - Sets top margin
- **marginBottom(double value)** → FlexBoxStyler - Sets bottom margin
- **marginLeft(double value)** → FlexBoxStyler - Sets left margin
- **marginRight(double value)** → FlexBoxStyler - Sets right margin
- **marginStart(double value)** → FlexBoxStyler - Sets start margin (direction-aware)
- **marginEnd(double value)** → FlexBoxStyler - Sets end margin (direction-aware)
- **marginOnly({double? horizontal, double? vertical, double? start, double? end, double? left, double? right, double? top, double? bottom})** → FlexBoxStyler - Sets margin on specific sides with priority resolution

### Constraint Methods (from ConstraintStyleMixin)
- **constraints(BoxConstraintsMix value)** → FlexBoxStyler - Sets box constraints using BoxConstraintsMix
- **width(double value)** → FlexBoxStyler - Sets fixed width
- **height(double value)** → FlexBoxStyler - Sets fixed height
- **minWidth(double value)** → FlexBoxStyler - Sets minimum width
- **maxWidth(double value)** → FlexBoxStyler - Sets maximum width
- **minHeight(double value)** → FlexBoxStyler - Sets minimum height
- **maxHeight(double value)** → FlexBoxStyler - Sets maximum height
- **size(double width, double height)** → FlexBoxStyler - Sets both width and height

### Border Methods (from BorderStyleMixin)
- **border(BoxBorderMix value)** → FlexBoxStyler - Sets border using BoxBorderMix
- **borderAll({Color? color, double? width, BorderStyle? style})** → FlexBoxStyler - Sets border on all sides
- **borderTop({Color? color, double? width, BorderStyle? style})** → FlexBoxStyler - Sets top border
- **borderBottom({Color? color, double? width, BorderStyle? style})** → FlexBoxStyler - Sets bottom border
- **borderLeft({Color? color, double? width, BorderStyle? style})** → FlexBoxStyler - Sets left border
- **borderRight({Color? color, double? width, BorderStyle? style})** → FlexBoxStyler - Sets right border
- **borderHorizontal({Color? color, double? width, BorderStyle? style})** → FlexBoxStyler - Sets horizontal borders
- **borderVertical({Color? color, double? width, BorderStyle? style})** → FlexBoxStyler - Sets vertical borders

### Border Radius Methods (from BorderRadiusStyleMixin)
- **borderRadius(BorderRadiusGeometryMix value)** → FlexBoxStyler - Sets border radius using BorderRadiusGeometryMix
- **borderRadiusAll(double value)** → FlexBoxStyler - Sets border radius on all corners
- **borderRounded(double radius)** → FlexBoxStyler - Sets circular border radius on all corners
- **borderRadiusTopLeft(double value)** → FlexBoxStyler - Sets top-left border radius
- **borderRadiusTopRight(double value)** → FlexBoxStyler - Sets top-right border radius
- **borderRadiusBottomLeft(double value)** → FlexBoxStyler - Sets bottom-left border radius
- **borderRadiusBottomRight(double value)** → FlexBoxStyler - Sets bottom-right border radius
- **borderRadiusTop(double value)** → FlexBoxStyler - Sets top border radius (left and right)
- **borderRadiusBottom(double value)** → FlexBoxStyler - Sets bottom border radius (left and right)
- **borderRadiusLeft(double value)** → FlexBoxStyler - Sets left border radius (top and bottom)
- **borderRadiusRight(double value)** → FlexBoxStyler - Sets right border radius (top and bottom)

### Decoration Methods (from DecorationStyleMixin)
- **decoration(DecorationMix value)** → FlexBoxStyler - Sets decoration using DecorationMix
- **foregroundDecoration(DecorationMix value)** → FlexBoxStyler - Sets foreground decoration
- **color(Color value)** → FlexBoxStyler - Sets background color
- **gradient(GradientMix value)** → FlexBoxStyler - Sets gradient with any GradientMix type
- **shadow(BoxShadowMix value)** → FlexBoxStyler - Sets single shadow
- **shadows(List<BoxShadowMix> value)** → FlexBoxStyler - Sets multiple shadows
- **elevation(ElevationShadow value)** → FlexBoxStyler - Sets elevation shadow
- **image(DecorationImageMix value)** → FlexBoxStyler - Sets image decoration
- **shape(ShapeBorderMix value)** → FlexBoxStyler - Sets box shape
- **shapeCircle({BorderSideMix? side})** → FlexBoxStyler - Sets circular shape
- **shapeStadium({BorderSideMix? side})** → FlexBoxStyler - Sets stadium shape
- **shapeRoundedRectangle({BorderSideMix? side, BorderRadiusMix? borderRadius})** → FlexBoxStyler - Sets rounded rectangle shape
- **backgroundImage(ImageProvider image, {BoxFit? fit, AlignmentGeometry? alignment, ImageRepeat repeat})** → FlexBoxStyler - Sets background image
- **backgroundImageUrl(String url, {BoxFit? fit, AlignmentGeometry? alignment, ImageRepeat repeat})** → FlexBoxStyler - Sets background image from URL
- **backgroundImageAsset(String path, {BoxFit? fit, AlignmentGeometry? alignment, ImageRepeat repeat})** → FlexBoxStyler - Sets background image from asset
- **linearGradient({required List<Color> colors, List<double>? stops, AlignmentGeometry? begin, AlignmentGeometry? end, TileMode? tileMode})** → FlexBoxStyler - Sets linear gradient
- **radialGradient({required List<Color> colors, List<double>? stops, AlignmentGeometry? center, double? radius, AlignmentGeometry? focal, double? focalRadius, TileMode? tileMode})** → FlexBoxStyler - Sets radial gradient
- **sweepGradient({required List<Color> colors, List<double>? stops, AlignmentGeometry? center, double? startAngle, double? endAngle, TileMode? tileMode})** → FlexBoxStyler - Sets sweep gradient

### Shadow Methods (from ShadowStyleMixin)
- **shadowOnly({Color? color, Offset? offset, double? blurRadius, double? spreadRadius})** → FlexBoxStyler - Creates single shadow with parameters
- **boxShadows(List<BoxShadowMix> value)** → FlexBoxStyler - Creates multiple box shadows
- **boxElevation(ElevationShadow value)** → FlexBoxStyler - Creates elevation-based shadows

### Transform Methods (from TransformStyleMixin)
- **transform(Matrix4 value, {AlignmentGeometry alignment})** → FlexBoxStyler - Sets matrix transformation
- **scale(double value, {AlignmentGeometry? alignment})** → FlexBoxStyler - Sets uniform scale transformation
- **scaleX(double value, {AlignmentGeometry? alignment})** → FlexBoxStyler - Sets X-axis scale
- **scaleY(double value, {AlignmentGeometry? alignment})** → FlexBoxStyler - Sets Y-axis scale
- **translate({double? x, double? y, AlignmentGeometry? alignment})** → FlexBoxStyler - Sets translation transformation
- **rotate(double angle, {AlignmentGeometry? alignment})** → FlexBoxStyler - Sets rotation transformation
- **skew({double? x, double? y, AlignmentGeometry? alignment})** → FlexBoxStyler - Sets skew transformation

### Flex Layout Methods (from FlexStyleMixin)
- **flex(FlexStyler value)** → FlexBoxStyler - Merges with another FlexStyler
- **direction(Axis value)** → FlexBoxStyler - Sets flex direction (horizontal/vertical)
- **row()** → FlexBoxStyler - Convenience method for horizontal direction
- **column()** → FlexBoxStyler - Convenience method for vertical direction
- **mainAxisAlignment(MainAxisAlignment value)** → FlexBoxStyler - Sets main axis alignment
- **crossAxisAlignment(CrossAxisAlignment value)** → FlexBoxStyler - Sets cross axis alignment
- **mainAxisSize(MainAxisSize value)** → FlexBoxStyler - Sets main axis size behavior
- **verticalDirection(VerticalDirection value)** → FlexBoxStyler - Sets vertical direction
- **textDirection(TextDirection value)** → FlexBoxStyler - Sets text direction
- **textBaseline(TextBaseline value)** → FlexBoxStyler - Sets text baseline
- **spacing(double value)** → FlexBoxStyler - Sets spacing between children

## Properties (Read-only)

The following properties are available as readonly `Prop<T>` values:

- **$box** → `Prop<StyleSpec<BoxSpec>>?` - Box specification
- **$flex** → `Prop<StyleSpec<FlexSpec>>?` - Flex specification

## Modifier Methods (from ModifierStyleMixin)

### wrap(ModifierConfig value) → FlexBoxStyler
Applies the given modifier configuration to wrap the flexbox widget.

#### Layout Modifiers
- **wrapOpacity(double opacity)** → FlexBoxStyler - Wraps with opacity modifier
- **wrapPadding(EdgeInsetsGeometryMix padding)** → FlexBoxStyler - Wraps with padding modifier
- **wrapSizedBox({double? width, double? height})** → FlexBoxStyler - Wraps with sized box
- **wrapConstrainedBox(BoxConstraints constraints)** → FlexBoxStyler - Wraps with constrained box
- **wrapAspectRatio(double aspectRatio)** → FlexBoxStyler - Wraps with aspect ratio modifier

#### Positioning Modifiers
- **wrapAlign(AlignmentGeometry alignment)** → FlexBoxStyler - Wraps with align modifier
- **wrapCenter()** → FlexBoxStyler - Wraps with center alignment modifier
- **wrapFractionallySizedBox({double? widthFactor, double? heightFactor, AlignmentGeometry alignment = Alignment.center})** → FlexBoxStyler - Wraps with fractionally sized box

#### Transform Modifiers
- **wrapScale(double scale, {Alignment alignment = Alignment.center})** → FlexBoxStyler - Wraps with scale transform
- **wrapRotate(double angle, {Alignment alignment = Alignment.center})** → FlexBoxStyler - Wraps with rotation transform
- **wrapTranslate(double x, double y, [double z = 0.0])** → FlexBoxStyler - Wraps with translation transform
- **wrapTransform(Matrix4 transform, {Alignment alignment = Alignment.center})** → FlexBoxStyler - Wraps with custom transform
- **wrapRotatedBox(int quarterTurns)** → FlexBoxStyler - Wraps with rotated box modifier

#### Clipping Modifiers
- **wrapClipOval({CustomClipper<Rect>? clipper, Clip? clipBehavior})** → FlexBoxStyler - Wraps with oval clipping
- **wrapClipRect({CustomClipper<Rect>? clipper, Clip? clipBehavior})** → FlexBoxStyler - Wraps with rectangular clipping
- **wrapClipPath({CustomClipper<Path>? clipper, Clip? clipBehavior})** → FlexBoxStyler - Wraps with path clipping
- **wrapClipTriangle({Clip? clipBehavior})** → FlexBoxStyler - Wraps with triangle clipping
- **wrapClipRRect({required BorderRadius borderRadius, CustomClipper<RRect>? clipper, Clip? clipBehavior})** → FlexBoxStyler - Wraps with rounded rectangle clipping

#### Flex Modifiers
- **wrapFlexible({int flex = 1, FlexFit fit = FlexFit.loose})** → FlexBoxStyler - Wraps with flexible modifier
- **wrapExpanded({int flex = 1})** → FlexBoxStyler - Wraps with expanded modifier

#### Visibility & Behavior
- **wrapVisibility(bool visible)** → FlexBoxStyler - Wraps with visibility modifier
- **wrapIntrinsicWidth()** → FlexBoxStyler - Wraps with intrinsic width modifier
- **wrapIntrinsicHeight()** → FlexBoxStyler - Wraps with intrinsic height modifier
- **wrapMouseCursor(MouseCursor cursor)** → FlexBoxStyler - Wraps with mouse cursor modifier

#### Theme Modifiers
- **wrapDefaultTextStyle(TextStyleMix style)** → FlexBoxStyler - Wraps with default text style modifier
- **wrapIconTheme(IconThemeData data)** → FlexBoxStyler - Wraps with icon theme modifier
- **wrapBox(BoxStyler spec)** → FlexBoxStyler - Wraps with box modifier

## Variant Methods (from VariantStyleMixin)

### variants(List<VariantStyle<FlexBoxSpec>> value) → FlexBoxStyler
Sets conditional styling variants based on context or state.

### variant(Variant variant, FlexBoxStyler style) → FlexBoxStyler
Adds a single variant with the given variant condition and style.

#### Context Variants
- **onDark(FlexBoxStyler style)** → FlexBoxStyler - Applies style in dark mode
- **onLight(FlexBoxStyler style)** → FlexBoxStyler - Applies style in light mode
- **onNot(ContextVariant contextVariant, FlexBoxStyler style)** → FlexBoxStyler - Applies style when context variant is NOT active

#### State Variants
- **onHovered(FlexBoxStyler style)** → FlexBoxStyler - Applies style on hover
- **onPressed(FlexBoxStyler style)** → FlexBoxStyler - Applies style when pressed
- **onFocused(FlexBoxStyler style)** → FlexBoxStyler - Applies style when focused
- **onDisabled(FlexBoxStyler style)** → FlexBoxStyler - Applies style when disabled
- **onSelected(FlexBoxStyler style)** → FlexBoxStyler - Applies style when selected

#### Responsive Variants
- **onBreakpoint(Breakpoint breakpoint, FlexBoxStyler style)** → FlexBoxStyler - Applies style at specific breakpoint

#### Builder Variant
- **builder(FlexBoxStyler Function(BuildContext context) fn)** → FlexBoxStyler - Creates context-dependent styling

## Spacing Methods (from SpacingStyleMixin)

### padding(EdgeInsetsGeometryMix value) → FlexBoxStyler
Sets padding using EdgeInsetsGeometryMix for the flex container.

### margin(EdgeInsetsGeometryMix value) → FlexBoxStyler
Sets margin using EdgeInsetsGeometryMix for the flex container.

#### Padding Methods
- **paddingX(double value)** → FlexBoxStyler - Sets left and right padding
- **paddingY(double value)** → FlexBoxStyler - Sets top and bottom padding

#### Margin Methods
- **marginX(double value)** → FlexBoxStyler - Sets left and right margin
- **marginY(double value)** → FlexBoxStyler - Sets top and bottom margin

## Constraint Methods (from ConstraintStyleMixin)

### constraints(BoxConstraintsMix value) → FlexBoxStyler
Sets box constraints for the flex container.

#### Size Methods
- **width(double value)** → FlexBoxStyler - Sets both min and max width
- **height(double value)** → FlexBoxStyler - Sets both min and max height
- **size(double width, double height)** → FlexBoxStyler - Sets both width and height
- **minWidth(double value)** → FlexBoxStyler - Sets minimum width constraint
- **maxWidth(double value)** → FlexBoxStyler - Sets maximum width constraint
- **minHeight(double value)** → FlexBoxStyler - Sets minimum height constraint
- **maxHeight(double value)** → FlexBoxStyler - Sets maximum height constraint

#### Advanced Constraints
- **constraintsOnly({double? width, double? height, double? minWidth, double? maxWidth, double? minHeight, double? maxHeight})** → FlexBoxStyler - Creates constraints with only specified values

## Border Methods (from BorderStyleMixin)

### border(BoxBorderMix value) → FlexBoxStyler
Sets border styling for the flex container.

## Border Radius Methods (from BorderRadiusStyleMixin)

### borderRadius(BorderRadiusGeometryMix value) → FlexBoxStyler
Sets border radius for the flex container.

#### Individual Corner Methods (Radius values)
- **borderRadiusAll(Radius radius)** → FlexBoxStyler - Sets radius on all corners
- **borderRadiusTop(Radius radius)** → FlexBoxStyler - Sets radius on top corners
- **borderRadiusBottom(Radius radius)** → FlexBoxStyler - Sets radius on bottom corners
- **borderRadiusLeft(Radius radius)** → FlexBoxStyler - Sets radius on left corners
- **borderRadiusRight(Radius radius)** → FlexBoxStyler - Sets radius on right corners
- **borderRadiusTopLeft(Radius radius)** → FlexBoxStyler - Sets top-left corner radius
- **borderRadiusTopRight(Radius radius)** → FlexBoxStyler - Sets top-right corner radius
- **borderRadiusBottomLeft(Radius radius)** → FlexBoxStyler - Sets bottom-left corner radius
- **borderRadiusBottomRight(Radius radius)** → FlexBoxStyler - Sets bottom-right corner radius

#### Directional Corner Methods (RTL-aware)
- **borderRadiusTopStart(Radius radius)** → FlexBoxStyler - Sets top-start corner radius
- **borderRadiusTopEnd(Radius radius)** → FlexBoxStyler - Sets top-end corner radius
- **borderRadiusBottomStart(Radius radius)** → FlexBoxStyler - Sets bottom-start corner radius
- **borderRadiusBottomEnd(Radius radius)** → FlexBoxStyler - Sets bottom-end corner radius

#### Rounded Shortcuts (using double values)
- **borderRounded(double radius)** → FlexBoxStyler - Sets circular radius on all corners
- **borderRoundedTop(double radius)** → FlexBoxStyler - Sets circular radius on top corners
- **borderRoundedBottom(double radius)** → FlexBoxStyler - Sets circular radius on bottom corners
- **borderRoundedLeft(double radius)** → FlexBoxStyler - Sets circular radius on left corners
- **borderRoundedRight(double radius)** → FlexBoxStyler - Sets circular radius on right corners
- **borderRoundedTopLeft(double radius)** → FlexBoxStyler - Sets circular top-left corner radius
- **borderRoundedTopRight(double radius)** → FlexBoxStyler - Sets circular top-right corner radius
- **borderRoundedBottomLeft(double radius)** → FlexBoxStyler - Sets circular bottom-left corner radius
- **borderRoundedBottomRight(double radius)** → FlexBoxStyler - Sets circular bottom-right corner radius
- **borderRoundedTopStart(double radius)** → FlexBoxStyler - Sets circular top-start corner radius
- **borderRoundedTopEnd(double radius)** → FlexBoxStyler - Sets circular top-end corner radius
- **borderRoundedBottomStart(double radius)** → FlexBoxStyler - Sets circular bottom-start corner radius
- **borderRoundedBottomEnd(double radius)** → FlexBoxStyler - Sets circular bottom-end corner radius

## Shadow Methods (from ShadowStyleMixin)

### shadow(List<BoxShadowMix> value) → FlexBoxStyler
Sets box shadows for the flex container.

## Decoration Methods (from DecorationStyleMixin)

### decoration(DecorationMix value) → FlexBoxStyler
Sets decoration for the flex container.

### foregroundDecoration(DecorationMix value) → FlexBoxStyler
Sets foreground decoration for the flex container.

## Transform Methods (from TransformStyleMixin)

### transform(Matrix4 value, {AlignmentGeometry alignment = Alignment.center}) → FlexBoxStyler
Sets transform matrix for the flex container.

## Flex Methods (from FlexStyleMixin)

### flex(FlexStyler value) → FlexBoxStyler
Applies the given flex styling configuration.

#### Layout Direction
- **direction(Axis value)** → FlexBoxStyler - Sets flex direction (horizontal/vertical)
- **row()** → FlexBoxStyler - Convenience method for horizontal direction
- **column()** → FlexBoxStyler - Convenience method for vertical direction

#### Alignment Methods
- **mainAxisAlignment(MainAxisAlignment value)** → FlexBoxStyler - Sets main axis alignment
- **crossAxisAlignment(CrossAxisAlignment value)** → FlexBoxStyler - Sets cross axis alignment
- **mainAxisSize(MainAxisSize value)** → FlexBoxStyler - Sets main axis size

#### Direction & Text Properties
- **verticalDirection(VerticalDirection value)** → FlexBoxStyler - Sets vertical direction
- **textDirection(TextDirection value)** → FlexBoxStyler - Sets text direction
- **textBaseline(TextBaseline value)** → FlexBoxStyler - Sets text baseline

#### Spacing
- **spacing(double value)** → FlexBoxStyler - Sets spacing between children

## Usage Examples

### Using Global Utility (Recommended)
```dart
// Basic styled flex container
final styledContainer = $flexbox
  .color.blue().shade100()
  .padding.all(16)
  .borderRadius(8)
  .direction(Axis.horizontal)
  .mainAxisAlignment.spaceBetween()
  .crossAxisAlignment.center()
  .spacing(12);

// Card-style flex layout
final cardLayout = $flexbox
  .color.white()
  .border.all(color: Colors.grey.shade300)
  .borderRadius(12)
  .padding.all(20)
  .direction(Axis.vertical)
  .crossAxisAlignment.stretch()
  .spacing(16);

// Button container
final buttonContainer = $flexbox
  .color.blue()
  .borderRadius(8)
  .padding.symmetric(horizontal: 24, vertical: 12)
  .direction(Axis.horizontal)
  .mainAxisAlignment.center()
  .crossAxisAlignment.center()
  .spacing(8);
```

### Using FlexBoxStyler Constructor
```dart
final flexboxStyle = FlexBoxStyler()
  .color(Colors.blue.shade100)
  .padding(EdgeInsetsGeometryMix.all(16))
  .borderRadius(BorderRadiusGeometryMix.circular(8))
  .direction(Axis.horizontal)
  .mainAxisAlignment(MainAxisAlignment.spaceBetween)
  .spacing(12)
;
```

### Common FlexBox Patterns
```dart
// Navigation bar
final navbar = $flexbox
  .color.white()
  .padding.symmetric(horizontal: 16, vertical: 12)
  .border.bottom(color: Colors.grey.shade200)
  .direction(Axis.horizontal)
  .mainAxisAlignment.spaceBetween()
  .crossAxisAlignment.center();

// Card content with header
final cardContent = $flexbox
  .color.white()
  .borderRadius(12)
  .padding.all(16)
  .border.all(color: Colors.grey.shade200)
  .direction(Axis.vertical)
  .crossAxisAlignment.stretch()
  .spacing(12);

// Toolbar
final toolbar = $flexbox
  .color.grey().shade50()
  .padding.all(8)
  .border.bottom()
  .direction(Axis.horizontal)
  .mainAxisAlignment.end()
  .spacing(8);

// Status indicator
final statusCard = $flexbox
  .color.green().shade50()
  .border.all(color: Colors.green.shade200)
  .borderRadius(8)
  .padding.all(12)
  .direction(Axis.horizontal)
  .crossAxisAlignment.center()
  .spacing(8);

// Form section
final formSection = $flexbox
  .color.grey().shade50()
  .borderRadius(8)
  .padding.all(16)
  .direction(Axis.vertical)
  .crossAxisAlignment.stretch()
  .spacing(16);
```

### Advanced Styling
```dart
// Gradient background with shadow
final fancyContainer = $flexbox
  .gradient.linear(
    colors: [Colors.blue.shade400, Colors.purple.shade400],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  )
  .borderRadius(16)
  .padding.all(24)
  .direction(Axis.vertical)
  .mainAxisAlignment.center()
  .crossAxisAlignment.center()
  .spacing(16)
;

// Responsive layout
final responsiveLayout = $flexbox
  .color.white()
  .borderRadius(12)
  .padding.all(16)
  .constraints.maxWidth(600)
  .direction(Axis.horizontal)
  .mainAxisAlignment.spaceBetween()
  .crossAxisAlignment.stretch()
  .spacing(16);
```