# ImageStyler API Reference

## Overview
The `ImageStyler` class is an **immutable style class** for image styling in Mix. It represents a finalized image style with all properties resolved, created either through direct instantiation or as the result of utility building. ImageStyler provides instance methods for convenient style manipulation and supports animations, modifiers, and conditional styling through variants.

**Type Alias:** `ImageMix = ImageStyler`

**Relationship to Utilities:** ImageStyler is the **immutable result** produced by `ImageSpecUtility` (accessed via `$image`). While `$image.width(200).height(150)` uses the fluent utility API, the final result is an `ImageStyler` instance.

**Note:** For utility-based styling documentation, see [ImageSpecUtility API Reference](image_util_api.md).

## Constructors

### ImageStyler({...}) → ImageStyler
Main constructor with optional parameters for all image properties.
```dart
ImageStyler({
  ImageProvider<Object>? image,
  double? width,
  double? height,
  Color? color,
  ImageRepeat? repeat,
  BoxFit? fit,
  AlignmentGeometry? alignment,
  Rect? centerSlice,
  FilterQuality? filterQuality,
  BlendMode? colorBlendMode,
  String? semanticLabel,
  bool? excludeFromSemantics,
  bool? gaplessPlayback,
  bool? isAntiAlias,
  bool? matchTextDirection,
  AnimationConfig? animation,
  ModifierConfig? modifier,
  List<VariantStyle<ImageSpec>>? variants,
})
```

### ImageStyler.create({...}) → ImageStyler
Internal constructor using `Prop<T>` types for advanced usage.
```dart
const ImageStyler.create({
  Prop<ImageProvider<Object>>? image,
  Prop<double>? width,
  Prop<double>? height,
  Prop<Color>? color,
  Prop<ImageRepeat>? repeat,
  Prop<BoxFit>? fit,
  Prop<AlignmentGeometry>? alignment,
  Prop<Rect>? centerSlice,
  Prop<FilterQuality>? filterQuality,
  Prop<BlendMode>? colorBlendMode,
  Prop<String>? semanticLabel,
  Prop<bool>? excludeFromSemantics,
  Prop<bool>? gaplessPlayback,
  Prop<bool>? isAntiAlias,
  Prop<bool>? matchTextDirection,
  AnimationConfig? animation,
  ModifierConfig? modifier,
  List<VariantStyle<ImageSpec>>? variants,
})
```

### ImageStyler.builder(ImageStyler Function(BuildContext)) → ImageStyler
Factory constructor for context-dependent image styling.

## Utility Methods (via $image)

### Image Source & Dimensions

- **$image.image(ImageProvider<Object>)** → Sets the image data provider
- **$image.width(double)** → Sets image width in logical pixels
- **$image.height(double)** → Sets image height in logical pixels

### Layout & Positioning

#### $image.fit → MixUtility
Provides image fitting configuration:
- **$image.fit(BoxFit)** → Sets how image fits within container
- **$image.fit.cover()**, **$image.fit.contain()**, **$image.fit.fill()** → Common fit modes
- **$image.fit.fitWidth()**, **$image.fit.fitHeight()** → Directional fitting
- **$image.fit.scaleDown()**, **$image.fit.none()** → Special fit modes

#### $image.alignment → MixUtility
Provides image alignment configuration:
- **$image.alignment(AlignmentGeometry)** → Sets image alignment within container
- **$image.alignment.center()**, **$image.alignment.topLeft()** → Alignment shortcuts

#### $image.repeat → MixUtility
Provides image repeat configuration:
- **$image.repeat(ImageRepeat)** → Sets image repeat behavior
- **$image.repeat.noRepeat()**, **$image.repeat.repeat()** → Repeat modes
- **$image.repeat.repeatX()**, **$image.repeat.repeatY()** → Directional repeat

### Visual Effects

#### $image.color → ColorUtility
Provides color overlay configuration:
- **$image.color(Color)** → Sets color overlay directly
- **$image.color.red()**, **$image.color.blue()**, etc. → Named color shortcuts
- **$image.color.withOpacity(0.5)** → Color with opacity
- **$image.color.black26()**, **$image.color.white70()** → Opacity variants

#### $image.colorBlendMode → MixUtility
Provides blend mode configuration:
- **$image.colorBlendMode(BlendMode)** → Sets how color blends with image
- **$image.colorBlendMode.multiply()**, **$image.colorBlendMode.overlay()** → Blend mode shortcuts

### Advanced Features

#### $image.centerSlice → MixUtility
Provides 9-patch image configuration:
- **$image.centerSlice(Rect)** → Sets center slice rectangle for 9-patch scaling

### Image Quality & Rendering

#### $image.filterQuality → MixUtility
Provides filter quality configuration:
- **$image.filterQuality(FilterQuality)** → Sets scaling filter quality
- **$image.filterQuality.low()**, **$image.filterQuality.medium()**, **$image.filterQuality.high()** → Quality levels

- **$image.isAntiAlias(bool)** → Sets anti-aliasing behavior
- **$image.gaplessPlayback(bool)** → Sets gapless loading behavior
- **$image.matchTextDirection(bool)** → Sets text direction matching

### Accessibility

- **$image.semanticLabel(String)** → Sets semantic label for screen readers
- **$image.excludeFromSemantics(bool)** → Sets semantic tree exclusion

### Modifiers & Animation

- **$image.wrap** → ModifierUtility for widget modifiers
- **$image.animate(AnimationConfig)** → Applies animation configuration
- **$image.variants(List<VariantStyle<ImageSpec>>)** → Sets conditional styling variants

## Static Properties

### ImageStyler.chain → ImageSpecUtility
Static accessor providing utility methods for chaining image styling operations.

## Core Methods

### call({...}) → StyledImage
Creates a `StyledImage` widget with optional parameters for advanced image handling.
```dart
StyledImage call({
  ImageProvider? image,
  ImageFrameBuilder? frameBuilder,
  ImageLoadingBuilder? loadingBuilder,
  ImageErrorWidgetBuilder? errorBuilder,
  Animation<double>? opacity,
})
```

### resolve(BuildContext context) → StyleSpec<ImageSpec>
Resolves all properties using the provided context, converting tokens and contextual values into concrete specifications.

### merge(ImageStyler? other) → ImageStyler
Merges this ImageStyler with another, with the other's properties taking precedence for non-null values.

## Image Source

### image(ImageProvider<Object> value) → ImageStyler
Sets the image provider that supplies the image data.

## Dimensions

### width(double value) → ImageStyler
Sets the image width in logical pixels.

### height(double value) → ImageStyler
Sets the image height in logical pixels.

## Layout & Positioning

### fit(BoxFit value) → ImageStyler
Sets how the image should be fitted within its container (cover, contain, fill, etc.).

### alignment(AlignmentGeometry value) → ImageStyler
Sets how the image is aligned within its container.

### repeat(ImageRepeat value) → ImageStyler
Sets how the image should be repeated (repeat, repeatX, repeatY, noRepeat).

## Visual Effects

### color(Color value) → ImageStyler
Sets a color to blend with the image using the specified blend mode.

### colorBlendMode(BlendMode value) → ImageStyler
Sets the blend mode for combining the image with the color overlay.

## Image Quality & Rendering

### filterQuality(FilterQuality value) → ImageStyler
Sets the filter quality for image scaling (low, medium, high).

### isAntiAlias(bool value) → ImageStyler
Sets whether anti-aliasing should be applied to the image.

### gaplessPlayback(bool value) → ImageStyler
Sets whether to maintain the previous image while loading a new one to prevent visual gaps.

## Advanced Features

### centerSlice(Rect value) → ImageStyler
Sets the center slice rectangle for 9-patch image scaling.

### matchTextDirection(bool value) → ImageStyler
Sets whether the image should be flipped to match the current text direction.

## Accessibility

### semanticLabel(String value) → ImageStyler
Sets the semantic label for screen readers and accessibility tools.

### excludeFromSemantics(bool value) → ImageStyler
Sets whether this image should be excluded from the semantic tree.

## Animation & Modifiers

### animate(AnimationConfig animation) → ImageStyler
Applies animation configuration to the image style.

### modifier(ModifierConfig value) → ImageStyler
Adds widget modifiers that wrap the image widget.

### wrap(ModifierConfig value) → ImageStyler
Alias for `modifier()` - adds widget modifiers.

## Variants

### variants(List<VariantStyle<ImageSpec>> variants) → ImageStyler
Sets conditional styling variants based on context or state.

## Properties (Read-only)

The following properties are available as readonly `Prop<T>` values:

- **$image** → `Prop<ImageProvider<Object>>?` - Image data provider
- **$width** → `Prop<double>?` - Image width
- **$height** → `Prop<double>?` - Image height
- **$color** → `Prop<Color>?` - Color overlay
- **$repeat** → `Prop<ImageRepeat>?` - Repeat behavior
- **$fit** → `Prop<BoxFit>?` - Fitting behavior
- **$alignment** → `Prop<AlignmentGeometry>?` - Image alignment
- **$centerSlice** → `Prop<Rect>?` - 9-patch center slice
- **$filterQuality** → `Prop<FilterQuality>?` - Scaling filter quality
- **$colorBlendMode** → `Prop<BlendMode>?` - Color blend mode
- **$semanticLabel** → `Prop<String>?` - Accessibility label
- **$excludeFromSemantics** → `Prop<bool>?` - Semantic exclusion
- **$gaplessPlayback** → `Prop<bool>?` - Gapless loading behavior
- **$isAntiAlias** → `Prop<bool>?` - Anti-aliasing setting
- **$matchTextDirection** → `Prop<bool>?` - Text direction matching

## Modifier Methods (from StyleModifierMixin)

### wrap(ModifierConfig value) → ImageStyler
Applies the given modifier configuration to wrap the image widget.

#### Layout Modifiers
- **wrapOpacity(double opacity)** → ImageStyler - Wraps with opacity modifier
- **wrapPadding(EdgeInsetsGeometryMix padding)** → ImageStyler - Wraps with padding modifier
- **wrapSizedBox({double? width, double? height})** → ImageStyler - Wraps with sized box
- **wrapConstrainedBox(BoxConstraints constraints)** → ImageStyler - Wraps with constrained box
- **wrapAspectRatio(double aspectRatio)** → ImageStyler - Wraps with aspect ratio modifier

#### Positioning Modifiers
- **wrapAlign(AlignmentGeometry alignment)** → ImageStyler - Wraps with align modifier
- **wrapCenter()** → ImageStyler - Wraps with center alignment modifier
- **wrapFractionallySizedBox({double? widthFactor, double? heightFactor, AlignmentGeometry alignment = Alignment.center})** → ImageStyler - Wraps with fractionally sized box

#### Transform Modifiers
- **wrapScale(double scale, {Alignment alignment = Alignment.center})** → ImageStyler - Wraps with scale transform
- **wrapRotate(double angle, {Alignment alignment = Alignment.center})** → ImageStyler - Wraps with rotation transform
- **wrapTranslate(double x, double y, [double z = 0.0])** → ImageStyler - Wraps with translation transform
- **wrapTransform(Matrix4 transform, {Alignment alignment = Alignment.center})** → ImageStyler - Wraps with custom transform
- **wrapRotatedBox(int quarterTurns)** → ImageStyler - Wraps with rotated box modifier

#### Clipping Modifiers
- **wrapClipOval({CustomClipper<Rect>? clipper, Clip? clipBehavior})** → ImageStyler - Wraps with oval clipping
- **wrapClipRect({CustomClipper<Rect>? clipper, Clip? clipBehavior})** → ImageStyler - Wraps with rectangular clipping
- **wrapClipPath({CustomClipper<Path>? clipper, Clip? clipBehavior})** → ImageStyler - Wraps with path clipping
- **wrapClipTriangle({Clip? clipBehavior})** → ImageStyler - Wraps with triangle clipping
- **wrapClipRRect({required BorderRadius borderRadius, CustomClipper<RRect>? clipper, Clip? clipBehavior})** → ImageStyler - Wraps with rounded rectangle clipping

#### Flex Modifiers
- **wrapFlexible({int flex = 1, FlexFit fit = FlexFit.loose})** → ImageStyler - Wraps with flexible modifier
- **wrapExpanded({int flex = 1})** → ImageStyler - Wraps with expanded modifier

#### Visibility & Behavior
- **wrapVisibility(bool visible)** → ImageStyler - Wraps with visibility modifier
- **wrapIntrinsicWidth()** → ImageStyler - Wraps with intrinsic width modifier
- **wrapIntrinsicHeight()** → ImageStyler - Wraps with intrinsic height modifier
- **wrapMouseCursor(MouseCursor cursor)** → ImageStyler - Wraps with mouse cursor modifier

#### Theme Modifiers
- **wrapDefaultTextStyle(TextStyleMix style)** → ImageStyler - Wraps with default text style modifier
- **wrapIconTheme(IconThemeData data)** → ImageStyler - Wraps with icon theme modifier
- **wrapBox(BoxStyler spec)** → ImageStyler - Wraps with box modifier

## Variant Methods (from StyleVariantMixin)

### variants(List<VariantStyle<ImageSpec>> value) → ImageStyler
Sets conditional styling variants based on context or state.

### variant(Variant variant, ImageStyler style) → ImageStyler
Adds a single variant with the given variant condition and style.

#### Context Variants
- **onDark(ImageStyler style)** → ImageStyler - Applies style in dark mode
- **onLight(ImageStyler style)** → ImageStyler - Applies style in light mode
- **onNot(ContextVariant contextVariant, ImageStyler style)** → ImageStyler - Applies style when context variant is NOT active

#### State Variants
- **onHovered(ImageStyler style)** → ImageStyler - Applies style on hover
- **onPressed(ImageStyler style)** → ImageStyler - Applies style when pressed
- **onFocused(ImageStyler style)** → ImageStyler - Applies style when focused
- **onDisabled(ImageStyler style)** → ImageStyler - Applies style when disabled
- **onSelected(ImageStyler style)** → ImageStyler - Applies style when selected

#### Responsive Variants
- **onBreakpoint(Breakpoint breakpoint, ImageStyler style)** → ImageStyler - Applies style at specific breakpoint

#### Builder Variant
- **builder(ImageStyler Function(BuildContext context) fn)** → ImageStyler - Creates context-dependent styling

## Usage Examples

### Using Global Utility (Recommended)
```dart
// Basic image styling
final basicImage = $image
  .width(200)
  .height(150)
  .fit.cover();

// Advanced image styling with effects
final styledImage = $image
  .width(300)
  .height(200)
  .fit.cover()
  .alignment.center()
  .color.blue().withOpacity(0.3)
  .colorBlendMode(BlendMode.overlay)
  .filterQuality.high()
  .isAntiAlias(true)
  .animate(AnimationConfig(duration: Duration(milliseconds: 500)));

// Profile avatar styling
final avatarImage = $image
  .width(50)
  .height(50)
  .fit.cover()
  .filterQuality.high()
  .isAntiAlias(true);

// Hero image with tint
final heroImage = $image
  .width(double.infinity)
  .height(250)
  .fit.cover()
  .alignment.center()
  .color.black().withOpacity(0.2)
  .colorBlendMode.darken();

// Repeating pattern image
final patternImage = $image
  .repeat.repeat()
  .fit.none()
  .alignment.topLeft();
```

### Using ImageStyler Constructor
```dart
final imageStyle = ImageStyler()
  .width(200)
  .height(150)
  .fit(BoxFit.cover)
  .alignment(Alignment.center)
  .color(Colors.blue.withOpacity(0.3))
  .colorBlendMode(BlendMode.overlay)
  .filterQuality(FilterQuality.high)
  .isAntiAlias(true)
  .animate(AnimationConfig(duration: Duration(milliseconds: 500)));
```

### Creating Widgets
```dart
// Using Style.image() factory (common pattern)
final widget = Style.image(
  width: 200,
  height: 150,
  fit: BoxFit.cover,
)(
  image: NetworkImage('https://example.com/image.jpg'),
  loadingBuilder: (context, child, loadingProgress) => 
    loadingProgress == null ? child : CircularProgressIndicator(),
);

// Using StyledImage widget directly
final widget = StyledImage(
  style: imageStyle,
  image: NetworkImage('https://example.com/image.jpg'),
);

// Using call operator on style
final widget = imageStyle(
  image: NetworkImage('https://example.com/image.jpg'),
);
```

### Common Image Patterns
```dart
// Thumbnail image
final thumbnail = $image
  .width(80)
  .height(80)
  .fit.cover()
  .filterQuality.medium();

// Card background image
final cardBackground = $image
  .width(double.infinity)
  .height(180)
  .fit.cover()
  .color.black().withOpacity(0.1)
  .colorBlendMode.multiply();

// Profile picture
final profilePic = $image
  .width(120)
  .height(120)
  .fit.cover()
  .alignment.center()
  .isAntiAlias(true)
  .filterQuality.high();

// Full-screen image
final fullscreenImage = $image
  .width(double.infinity)
  .height(double.infinity)
  .fit.cover()
  .alignment.center()
  .gaplessPlayback(true);

// Icon replacement image
final iconImage = $image
  .width(24)
  .height(24)
  .fit.contain()
  .color.grey().shade700()
  .colorBlendMode.srcIn();

// Responsive image with quality settings
final responsiveImage = $image
  .fit.cover()
  .alignment.center()
  .filterQuality.high()
  .isAntiAlias(true)
  .matchTextDirection(true);
```