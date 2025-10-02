# StackStyler API Reference

## Overview
The `StackStyler` class is an **immutable style class** for stack layout styling in Mix. It represents a finalized stack style with all properties resolved, created either through direct instantiation or as the result of utility building. StackStyler provides instance methods for convenient style manipulation and is used for creating overlapping widget arrangements similar to Flutter's Stack widget.

**Type Alias:** `StackMix = StackStyler`

**Relationship to Utilities:** StackStyler is the **immutable result** produced by `StackSpecUtility` (accessed via `$stack`). While `$stack.alignment.center()` uses the fluent utility API, the final result is a `StackStyler` instance.

**Note:** For utility-based styling documentation, see [StackSpecUtility API Reference](stack_util_api.md).

## Utility Methods (via $stack)

### Child Positioning

#### $stack.alignment → MixUtility
Controls how children are positioned within the stack:
- **$stack.alignment(AlignmentGeometry)** → Sets default child alignment
- **$stack.alignment.topLeft()** → Aligns children to top-left corner
- **$stack.alignment.topCenter()** → Aligns children to top-center
- **$stack.alignment.topRight()** → Aligns children to top-right corner
- **$stack.alignment.centerLeft()** → Aligns children to center-left
- **$stack.alignment.center()** → Centers children within stack
- **$stack.alignment.centerRight()** → Aligns children to center-right
- **$stack.alignment.bottomLeft()** → Aligns children to bottom-left
- **$stack.alignment.bottomCenter()** → Aligns children to bottom-center
- **$stack.alignment.bottomRight()** → Aligns children to bottom-right

### Child Sizing

#### $stack.fit → MixUtility
Controls how children are sized within the stack:
- **$stack.fit(StackFit)** → Sets stack fit behavior
- **$stack.fit.loose()** → Children maintain their natural size
- **$stack.fit.expand()** → Non-positioned children expand to fill the stack
- **$stack.fit.passthrough()** → Stack passes constraints through to children

### Text Direction

#### $stack.textDirection → MixUtility
Controls text direction for directional alignment:
- **$stack.textDirection(TextDirection)** → Sets text direction
- **$stack.textDirection.ltr()** → Left-to-right text direction
- **$stack.textDirection.rtl()** → Right-to-left text direction

### Clipping

#### $stack.clipBehavior → MixUtility
Controls how the stack clips its children:
- **$stack.clipBehavior(Clip)** → Sets clipping behavior
- **$stack.clipBehavior.none()** → No clipping (default)
- **$stack.clipBehavior.hardEdge()** → Hard edge clipping
- **$stack.clipBehavior.antiAlias()** → Anti-aliased clipping
- **$stack.clipBehavior.antiAliasWithSaveLayer()** → Anti-aliased with save layer

### Modifiers & Animation

- **$stack.wrap** → ModifierUtility for widget modifiers
- **$stack.animate(AnimationConfig)** → Applies animation configuration

## Constructors

### StackStyler({...}) → StackStyler
Main constructor with optional parameters for all stack properties.
```dart
StackStyler({
  AlignmentGeometry? alignment,
  StackFit? fit,
  TextDirection? textDirection,
  Clip? clipBehavior,
  AnimationConfig? animation,
  ModifierConfig? modifier,
  List<VariantStyle<StackSpec>>? variants,
})
```

### StackStyler.create({...}) → StackStyler
Internal constructor using `Prop<T>` types for advanced usage.
```dart
const StackStyler.create({
  Prop<AlignmentGeometry>? alignment,
  Prop<StackFit>? fit,
  Prop<TextDirection>? textDirection,
  Prop<Clip>? clipBehavior,
  AnimationConfig? animation,
  ModifierConfig? modifier,
  List<VariantStyle<StackSpec>>? variants,
})
```

### StackStyler.builder(StackStyler Function(BuildContext)) → StackStyler
Factory constructor for context-dependent stack styling.

## Static Properties

### StackStyler.chain → StackSpecUtility
Static accessor providing utility methods for chaining stack styling operations.

## Core Methods

### resolve(BuildContext context) → StyleSpec<StackSpec>
Resolves all properties using the provided context, converting tokens and contextual values into concrete specifications.

### merge(StackStyler? other) → StackStyler
Merges this StackStyler with another, with the other's properties taking precedence for non-null values.

## Instance Methods

### Layout Methods
- **alignment(AlignmentGeometry value)** → Sets stack alignment
- **fit(StackFit value)** → Sets stack fit behavior
- **textDirection(TextDirection value)** → Sets text direction
- **clipBehavior(Clip value)** → Sets clip behavior
- **modifier(ModifierConfig value)** → Adds widget modifiers
- **animate(AnimationConfig animation)** → Applies animation configuration
- **variants(List<VariantStyle<StackSpec>> variants)** → Sets conditional styling
- **wrap(ModifierConfig value)** → Alias for modifier()

## Properties (Read-only)

The following properties are available as readonly `Prop<T>` values:

- **$alignment** → `Prop<AlignmentGeometry>?` - Default child alignment
- **$fit** → `Prop<StackFit>?` - Child sizing behavior
- **$textDirection** → `Prop<TextDirection>?` - Text direction
- **$clipBehavior** → `Prop<Clip>?` - Clipping behavior

## Modifier Methods (from ModifierStyleMixin)

### wrap(ModifierConfig value) → StackStyler
Applies the given modifier configuration to wrap the stack widget.

#### Layout Modifiers
- **wrapOpacity(double opacity)** → StackStyler - Wraps with opacity modifier
- **wrapPadding(EdgeInsetsGeometryMix padding)** → StackStyler - Wraps with padding modifier
- **wrapSizedBox({double? width, double? height})** → StackStyler - Wraps with sized box
- **wrapConstrainedBox(BoxConstraints constraints)** → StackStyler - Wraps with constrained box
- **wrapAspectRatio(double aspectRatio)** → StackStyler - Wraps with aspect ratio modifier

#### Positioning Modifiers
- **wrapAlign(AlignmentGeometry alignment)** → StackStyler - Wraps with align modifier
- **wrapCenter()** → StackStyler - Wraps with center alignment modifier
- **wrapFractionallySizedBox({double? widthFactor, double? heightFactor, AlignmentGeometry alignment = Alignment.center})** → StackStyler - Wraps with fractionally sized box

#### Transform Modifiers
- **wrapScale(double scale, {Alignment alignment = Alignment.center})** → StackStyler - Wraps with scale transform
- **wrapRotate(double angle, {Alignment alignment = Alignment.center})** → StackStyler - Wraps with rotation transform
- **wrapTranslate(double x, double y, [double z = 0.0])** → StackStyler - Wraps with translation transform
- **wrapTransform(Matrix4 transform, {Alignment alignment = Alignment.center})** → StackStyler - Wraps with custom transform
- **wrapRotatedBox(int quarterTurns)** → StackStyler - Wraps with rotated box modifier

#### Clipping Modifiers
- **wrapClipOval({CustomClipper<Rect>? clipper, Clip? clipBehavior})** → StackStyler - Wraps with oval clipping
- **wrapClipRect({CustomClipper<Rect>? clipper, Clip? clipBehavior})** → StackStyler - Wraps with rectangular clipping
- **wrapClipPath({CustomClipper<Path>? clipper, Clip? clipBehavior})** → StackStyler - Wraps with path clipping
- **wrapClipTriangle({Clip? clipBehavior})** → StackStyler - Wraps with triangle clipping
- **wrapClipRRect({required BorderRadius borderRadius, CustomClipper<RRect>? clipper, Clip? clipBehavior})** → StackStyler - Wraps with rounded rectangle clipping

#### Flex Modifiers
- **wrapFlexible({int flex = 1, FlexFit fit = FlexFit.loose})** → StackStyler - Wraps with flexible modifier
- **wrapExpanded({int flex = 1})** → StackStyler - Wraps with expanded modifier

#### Visibility & Behavior
- **wrapVisibility(bool visible)** → StackStyler - Wraps with visibility modifier
- **wrapIntrinsicWidth()** → StackStyler - Wraps with intrinsic width modifier
- **wrapIntrinsicHeight()** → StackStyler - Wraps with intrinsic height modifier
- **wrapMouseCursor(MouseCursor cursor)** → StackStyler - Wraps with mouse cursor modifier

#### Theme Modifiers
- **wrapDefaultTextStyle(TextStyleMix style)** → StackStyler - Wraps with default text style modifier
- **wrapIconTheme(IconThemeData data)** → StackStyler - Wraps with icon theme modifier
- **wrapBox(BoxStyler spec)** → StackStyler - Wraps with box modifier

## Animation Methods (from AnimationStyleMixin)

### animate(AnimationConfig config) → StackStyler
Applies animation configuration to the stack style.

### keyframeAnimation({required Listenable trigger, required List<KeyframeTrack> timeline, required KeyframeStyleBuilder<StackSpec, StackStyler> styleBuilder}) → StackStyler
Creates keyframe-based animation with timeline control.

### phaseAnimation<P>({required Listenable trigger, required List<P> phases, required StackStyler Function(P phase, StackStyler style) styleBuilder, required CurveAnimationConfig Function(P phase) configBuilder}) → StackStyler
Creates phase-based animation with custom curve configurations for each phase.

## Variant Methods (from VariantStyleMixin)

### variants(List<VariantStyle<StackSpec>> value) → StackStyler
Sets conditional styling variants based on context or state.

### variant(Variant variant, StackStyler style) → StackStyler
Adds a single variant with the given variant condition and style.

#### Context Variants
- **onDark(StackStyler style)** → StackStyler - Applies style in dark mode
- **onLight(StackStyler style)** → StackStyler - Applies style in light mode
- **onNot(ContextVariant contextVariant, StackStyler style)** → StackStyler - Applies style when context variant is NOT active

#### State Variants
- **onHovered(StackStyler style)** → StackStyler - Applies style on hover
- **onPressed(StackStyler style)** → StackStyler - Applies style when pressed
- **onFocused(StackStyler style)** → StackStyler - Applies style when focused
- **onDisabled(StackStyler style)** → StackStyler - Applies style when disabled
- **onEnabled(StackStyler style)** → StackStyler - Applies style when enabled

#### Responsive Variants
- **onBreakpoint(Breakpoint breakpoint, StackStyler style)** → StackStyler - Applies style at specific breakpoint

#### Builder Variant
- **builder(StackStyler Function(BuildContext context) fn)** → StackStyler - Creates context-dependent styling

## Usage Examples

### Using Global Utility (Recommended)
```dart
// Basic centered stack
final centeredStack = $stack
  .alignment.center()
  .fit.loose();

// Expanded stack with top-left alignment
final expandedStack = $stack
  .alignment.topLeft()
  .fit.expand();

// Stack with clipping
final clippedStack = $stack
  .alignment.center()
  .fit.expand()
  .clipBehavior.hardEdge();

// Animated stack layout
final animatedStack = $stack
  .alignment.bottomRight()
  .fit.loose()
  .animate(AnimationConfig(
    duration: Duration(milliseconds: 300),
    curve: Curves.easeInOut,
  ));

// RTL-aware stack
final rtlStack = $stack
  .alignment.centerLeft()
  .textDirection.rtl()
  .fit.expand();
```

### Using StackStyler Constructor
```dart
final stackStyle = StackStyler()
  .alignment(Alignment.center)
  .fit(StackFit.expand)
  .clipBehavior(Clip.hardEdge)
  .animate(AnimationConfig(duration: Duration(milliseconds: 200)));
```

### Common Stack Patterns
```dart
// Overlay pattern
final overlayStack = $stack
  .alignment.center()
  .fit.expand();

// Background with content
final backgroundStack = $stack
  .alignment.topLeft()
  .fit.expand();

// Floating action button pattern
final fabStack = $stack
  .alignment.bottomRight()
  .fit.loose();

// Loading overlay
final loadingStack = $stack
  .alignment.center()
  .fit.expand()
  .clipBehavior.hardEdge();

// Badge/notification pattern
final badgeStack = $stack
  .alignment.topRight()
  .fit.loose();

// Card with header image
final cardStack = $stack
  .alignment.topLeft()
  .fit.expand()
  .clipBehavior.antiAlias();
```

### Advanced Usage
```dart
// Multi-layered UI with different alignments
final complexStack = $stack
  .fit.expand()
  .clipBehavior.antiAliasWithSaveLayer()
  .animate(AnimationConfig(
    duration: Duration(milliseconds: 500),
    curve: Curves.elasticOut,
  ));

// Responsive stack that adapts to text direction
final responsiveStack = $stack
  .alignment.centerLeft()
  .textDirection.ltr()  // Can be dynamically changed
  .fit.loose();

// Stack with strict clipping for performance
final performanceStack = $stack
  .alignment.center()
  .fit.expand()
  .clipBehavior.hardEdge();  // Most performant clipping
```

### Stack Layout Scenarios
```dart
// Image with overlay text
final imageOverlay = $stack
  .alignment.bottomLeft()
  .fit.expand();

// Profile picture with status indicator  
final profileWithStatus = $stack
  .alignment.topRight()
  .fit.loose();

// Card with floating element
final cardWithFloat = $stack
  .alignment.topRight()
  .fit.loose();

// Modal backdrop
final modalBackdrop = $stack
  .alignment.center()
  .fit.expand();

// Toast/snackbar positioning
final toastPosition = $stack
  .alignment.bottomCenter()
  .fit.loose();

// Hero section with multiple layers
final heroSection = $stack
  .alignment.center()
  .fit.expand()
  .clipBehavior.antiAlias();
```