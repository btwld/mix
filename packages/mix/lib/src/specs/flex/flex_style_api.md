# FlexStyler API Reference

## Overview
The `FlexStyler` class is an **immutable style class** for flex layout styling in Mix. It represents a finalized flex style with all properties resolved, created either through direct instantiation or as the result of utility building. FlexStyler provides instance methods for convenient style manipulation and is used for creating row and column layouts with flexible child arrangement.

**Type Alias:** `FlexMix = FlexStyler`

**Relationship to Utilities:** FlexStyler is the **immutable result** produced by `FlexSpecUtility` (accessed via `$flex`). While `$flex.row().spacing(8)` uses the fluent utility API, the final result is a `FlexStyler` instance.

**Note:** For utility-based styling documentation, see [FlexSpecUtility API Reference](flex_util_api.md).

## Utility Methods (via $flex)

### Layout Direction

#### $flex.direction → MixUtility
Provides flex direction configuration:
- **$flex.direction(Axis)** → Sets flex direction (horizontal/vertical)
- **$flex.direction.horizontal()** → Sets horizontal direction (row layout)
- **$flex.direction.vertical()** → Sets vertical direction (column layout)

#### Convenience Direction Methods
- **$flex.row()** → Sets flex direction to horizontal (Axis.horizontal)
- **$flex.column()** → Sets flex direction to vertical (Axis.vertical)

### Main Axis Alignment

#### $flex.mainAxisAlignment → MixUtility
Controls how children are positioned along the main axis:
- **$flex.mainAxisAlignment(MainAxisAlignment)** → Sets main axis alignment
- **$flex.mainAxisAlignment.start()** → Aligns children to the start
- **$flex.mainAxisAlignment.end()** → Aligns children to the end
- **$flex.mainAxisAlignment.center()** → Centers children
- **$flex.mainAxisAlignment.spaceBetween()** → Distributes space between children
- **$flex.mainAxisAlignment.spaceAround()** → Distributes space around children
- **$flex.mainAxisAlignment.spaceEvenly()** → Distributes space evenly

### Cross Axis Alignment

#### $flex.crossAxisAlignment → MixUtility
Controls how children are positioned along the cross axis:
- **$flex.crossAxisAlignment(CrossAxisAlignment)** → Sets cross axis alignment
- **$flex.crossAxisAlignment.start()** → Aligns children to the start
- **$flex.crossAxisAlignment.end()** → Aligns children to the end
- **$flex.crossAxisAlignment.center()** → Centers children
- **$flex.crossAxisAlignment.stretch()** → Stretches children to fill cross axis
- **$flex.crossAxisAlignment.baseline()** → Aligns children to text baseline

### Size & Space Management

#### $flex.mainAxisSize → MixUtility
Controls how much space the flex layout occupies on the main axis:
- **$flex.mainAxisSize(MainAxisSize)** → Sets main axis size behavior
- **$flex.mainAxisSize.min()** → Occupies minimum space required
- **$flex.mainAxisSize.max()** → Occupies maximum available space

#### Spacing Between Children
- **$flex.spacing(double)** → Sets spacing between children in logical pixels
- **$flex.gap(double)** → ⚠️ **Deprecated** - Use spacing instead

### Direction & Baseline

#### $flex.verticalDirection → MixUtility
Controls the order children appear in the vertical direction:
- **$flex.verticalDirection(VerticalDirection)** → Sets vertical direction
- **$flex.verticalDirection.down()** → Children arranged top to bottom
- **$flex.verticalDirection.up()** → Children arranged bottom to top

#### $flex.textDirection → MixUtility
Controls the order children appear in the horizontal direction:
- **$flex.textDirection(TextDirection)** → Sets text direction
- **$flex.textDirection.ltr()** → Left-to-right layout
- **$flex.textDirection.rtl()** → Right-to-left layout

#### $flex.textBaseline → MixUtility
Sets the baseline for baseline alignment:
- **$flex.textBaseline(TextBaseline)** → Sets text baseline
- **$flex.textBaseline.alphabetic()** → Alphabetic baseline
- **$flex.textBaseline.ideographic()** → Ideographic baseline

### Clipping

#### $flex.clipBehavior → MixUtility
Controls how the flex layout clips its children:
- **$flex.clipBehavior(Clip)** → Sets clipping behavior
- **$flex.clipBehavior.none()** → No clipping
- **$flex.clipBehavior.hardEdge()** → Hard edge clipping
- **$flex.clipBehavior.antiAlias()** → Anti-aliased clipping
- **$flex.clipBehavior.antiAliasWithSaveLayer()** → Anti-aliased with save layer

### Modifiers & Animation

- **$flex.wrap** → ModifierUtility for widget modifiers
- **$flex.animate(AnimationConfig)** → Applies animation configuration

## Constructors

### FlexStyler({...}) → FlexStyler
Main constructor with optional parameters for all flex properties.
```dart
FlexStyler({
  Axis? direction,
  MainAxisAlignment? mainAxisAlignment,
  CrossAxisAlignment? crossAxisAlignment,
  MainAxisSize? mainAxisSize,
  VerticalDirection? verticalDirection,
  TextDirection? textDirection,
  TextBaseline? textBaseline,
  Clip? clipBehavior,
  double? spacing,
  AnimationConfig? animation,
  ModifierConfig? modifier,
  List<VariantStyle<FlexSpec>>? variants,
})
```

### FlexStyler.create({...}) → FlexStyler
Internal constructor using `Prop<T>` types for advanced usage.

### FlexStyler.builder(FlexStyler Function(BuildContext)) → FlexStyler
Factory constructor for context-dependent flex styling.

## Static Properties

### FlexStyler.chain → FlexSpecUtility
Static accessor providing utility methods for chaining flex styling operations.

## Core Methods

### resolve(BuildContext context) → StyleSpec<FlexSpec>
Resolves all properties using the provided context, converting tokens and contextual values into concrete specifications.

### merge(FlexStyler? other) → FlexStyler
Merges this FlexStyler with another, with the other's properties taking precedence for non-null values.

## Instance Methods

### Layout Methods (Direct Methods)
- **clipBehavior(Clip value)** → FlexStyler - Sets clipping behavior
- **gap(double value)** → FlexStyler - ⚠️ **Deprecated** - Use spacing instead
- **modifier(ModifierConfig value)** → FlexStyler - Adds widget modifiers
- **flex(FlexStyler value)** → FlexStyler - Merges with another flex styler
- **animate(AnimationConfig animation)** → FlexStyler - Applies animation configuration
- **variants(List<VariantStyle<FlexSpec>> variants)** → FlexStyler - Sets conditional styling
- **wrap(ModifierConfig value)** → FlexStyler - Alias for modifier()

### Flex Layout Methods (from FlexStyleMixin)

#### Direction & Layout
- **direction(Axis value)** → FlexStyler - Sets flex direction (horizontal/vertical)
- **row()** → FlexStyler - Convenience method for setting direction to horizontal
- **column()** → FlexStyler - Convenience method for setting direction to vertical

#### Alignment Methods
- **mainAxisAlignment(MainAxisAlignment value)** → FlexStyler - Sets main axis alignment
- **crossAxisAlignment(CrossAxisAlignment value)** → FlexStyler - Sets cross axis alignment
- **mainAxisSize(MainAxisSize value)** → FlexStyler - Sets main axis size behavior

#### Direction & Text Properties
- **verticalDirection(VerticalDirection value)** → FlexStyler - Sets vertical direction
- **textDirection(TextDirection value)** → FlexStyler - Sets text direction
- **textBaseline(TextBaseline value)** → FlexStyler - Sets text baseline

#### Spacing
- **spacing(double value)** → FlexStyler - Sets spacing between children

## Properties (Read-only)

The following properties are available as readonly `Prop<T>` values:

- **$direction** → `Prop<Axis>?` - Flex direction (horizontal/vertical)
- **$mainAxisAlignment** → `Prop<MainAxisAlignment>?` - Main axis alignment
- **$crossAxisAlignment** → `Prop<CrossAxisAlignment>?` - Cross axis alignment
- **$mainAxisSize** → `Prop<MainAxisSize>?` - Main axis size behavior
- **$verticalDirection** → `Prop<VerticalDirection>?` - Vertical direction
- **$textDirection** → `Prop<TextDirection>?` - Text/horizontal direction
- **$textBaseline** → `Prop<TextBaseline>?` - Text baseline
- **$clipBehavior** → `Prop<Clip>?` - Clipping behavior
- **$spacing** → `Prop<double>?` - Spacing between children

## Flex Methods (from FlexStyleMixin)

### flex(FlexStyler value) → FlexStyler
Applies the given flex styling configuration.

#### Layout Direction
- **direction(Axis value)** → FlexStyler - Sets flex direction (horizontal/vertical)
- **row()** → FlexStyler - Convenience method for horizontal direction
- **column()** → FlexStyler - Convenience method for vertical direction

#### Alignment Methods
- **mainAxisAlignment(MainAxisAlignment value)** → FlexStyler - Sets main axis alignment
- **crossAxisAlignment(CrossAxisAlignment value)** → FlexStyler - Sets cross axis alignment
- **mainAxisSize(MainAxisSize value)** → FlexStyler - Sets main axis size

#### Direction & Text Properties
- **verticalDirection(VerticalDirection value)** → FlexStyler - Sets vertical direction
- **textDirection(TextDirection value)** → FlexStyler - Sets text direction
- **textBaseline(TextBaseline value)** → FlexStyler - Sets text baseline

#### Spacing
- **spacing(double value)** → FlexStyler - Sets spacing between children

## Modifier Methods (from ModifierStyleMixin)

### wrap(ModifierConfig value) → FlexStyler
Applies the given modifier configuration to wrap the flex widget.

#### Layout Modifiers
- **wrapOpacity(double opacity)** → FlexStyler - Wraps with opacity modifier
- **wrapPadding(EdgeInsetsGeometryMix padding)** → FlexStyler - Wraps with padding modifier
- **wrapSizedBox({double? width, double? height})** → FlexStyler - Wraps with sized box
- **wrapConstrainedBox(BoxConstraints constraints)** → FlexStyler - Wraps with constrained box
- **wrapAspectRatio(double aspectRatio)** → FlexStyler - Wraps with aspect ratio modifier

#### Positioning Modifiers
- **wrapAlign(AlignmentGeometry alignment)** → FlexStyler - Wraps with align modifier
- **wrapCenter()** → FlexStyler - Wraps with center alignment modifier
- **wrapFractionallySizedBox({double? widthFactor, double? heightFactor, AlignmentGeometry alignment = Alignment.center})** → FlexStyler - Wraps with fractionally sized box

#### Transform Modifiers
- **wrapScale(double scale, {Alignment alignment = Alignment.center})** → FlexStyler - Wraps with scale transform
- **wrapRotate(double angle, {Alignment alignment = Alignment.center})** → FlexStyler - Wraps with rotation transform
- **wrapTranslate(double x, double y, [double z = 0.0])** → FlexStyler - Wraps with translation transform
- **wrapTransform(Matrix4 transform, {Alignment alignment = Alignment.center})** → FlexStyler - Wraps with custom transform
- **wrapRotatedBox(int quarterTurns)** → FlexStyler - Wraps with rotated box modifier

#### Clipping Modifiers
- **wrapClipOval({CustomClipper<Rect>? clipper, Clip? clipBehavior})** → FlexStyler - Wraps with oval clipping
- **wrapClipRect({CustomClipper<Rect>? clipper, Clip? clipBehavior})** → FlexStyler - Wraps with rectangular clipping
- **wrapClipPath({CustomClipper<Path>? clipper, Clip? clipBehavior})** → FlexStyler - Wraps with path clipping
- **wrapClipTriangle({Clip? clipBehavior})** → FlexStyler - Wraps with triangle clipping
- **wrapClipRRect({required BorderRadius borderRadius, CustomClipper<RRect>? clipper, Clip? clipBehavior})** → FlexStyler - Wraps with rounded rectangle clipping

#### Flex Modifiers
- **wrapFlexible({int flex = 1, FlexFit fit = FlexFit.loose})** → FlexStyler - Wraps with flexible modifier
- **wrapExpanded({int flex = 1})** → FlexStyler - Wraps with expanded modifier

#### Visibility & Behavior
- **wrapVisibility(bool visible)** → FlexStyler - Wraps with visibility modifier
- **wrapIntrinsicWidth()** → FlexStyler - Wraps with intrinsic width modifier
- **wrapIntrinsicHeight()** → FlexStyler - Wraps with intrinsic height modifier
- **wrapMouseCursor(MouseCursor cursor)** → FlexStyler - Wraps with mouse cursor modifier

#### Theme Modifiers
- **wrapDefaultTextStyle(TextStyleMix style)** → FlexStyler - Wraps with default text style modifier
- **wrapIconTheme(IconThemeData data)** → FlexStyler - Wraps with icon theme modifier
- **wrapBox(BoxStyler spec)** → FlexStyler - Wraps with box modifier

## Animation Methods (from AnimationStyleMixin)

### animate(AnimationConfig config) → FlexStyler
Applies animation configuration to the flex style.

### keyframeAnimation({required Listenable trigger, required List<KeyframeTrack> timeline, required KeyframeStyleBuilder<FlexSpec, FlexStyler> styleBuilder}) → FlexStyler
Creates keyframe-based animation with timeline control.

### phaseAnimation<P>({required Listenable trigger, required List<P> phases, required FlexStyler Function(P phase, FlexStyler style) styleBuilder, required CurveAnimationConfig Function(P phase) configBuilder}) → FlexStyler
Creates phase-based animation with custom curve configurations for each phase.

## Variant Methods (from VariantStyleMixin)

### variants(List<VariantStyle<FlexSpec>> value) → FlexStyler
Sets conditional styling variants based on context or state.

### variant(Variant variant, FlexStyler style) → FlexStyler
Adds a single variant with the given variant condition and style.

#### Context Variants
- **onDark(FlexStyler style)** → FlexStyler - Applies style in dark mode
- **onLight(FlexStyler style)** → FlexStyler - Applies style in light mode
- **onNot(ContextVariant contextVariant, FlexStyler style)** → FlexStyler - Applies style when context variant is NOT active

#### State Variants
- **onHovered(FlexStyler style)** → FlexStyler - Applies style on hover
- **onPressed(FlexStyler style)** → FlexStyler - Applies style when pressed
- **onFocused(FlexStyler style)** → FlexStyler - Applies style when focused
- **onDisabled(FlexStyler style)** → FlexStyler - Applies style when disabled
- **onSelected(FlexStyler style)** → FlexStyler - Applies style when selected

#### Responsive Variants
- **onBreakpoint(Breakpoint breakpoint, FlexStyler style)** → FlexStyler - Applies style at specific breakpoint

#### Builder Variant
- **builder(FlexStyler Function(BuildContext context) fn)** → FlexStyler - Creates context-dependent styling

## Usage Examples

### Using Global Utility (Recommended)
```dart
// Horizontal row layout
final rowLayout = $flex
  .row()
  .mainAxisAlignment.spaceBetween()
  .crossAxisAlignment.center()
  .spacing(16);

// Vertical column layout
final columnLayout = $flex
  .column()
  .mainAxisAlignment.start()
  .crossAxisAlignment.stretch()
  .spacing(8);

// Centered content
final centeredLayout = $flex
  .column()
  .mainAxisAlignment.center()
  .crossAxisAlignment.center()
  .mainAxisSize.max()
  .spacing(12);

// Responsive flex layout
final responsiveLayout = $flex
  .row()
  .mainAxisAlignment.spaceEvenly()
  .crossAxisAlignment.baseline()
  .textBaseline.alphabetic()
  .spacing(20)
  .animate(AnimationConfig(duration: Duration(milliseconds: 300)));
```

### Using FlexStyler Constructor
```dart
final flexStyle = FlexStyler()
  .direction(Axis.horizontal)
  .mainAxisAlignment(MainAxisAlignment.spaceBetween)
  .crossAxisAlignment(CrossAxisAlignment.center)
  .spacing(16)
  .animate(AnimationConfig(duration: Duration(milliseconds: 200)));
```

### Common Flex Patterns
```dart
// Navigation bar layout
final navbar = $flex
  .row()
  .mainAxisAlignment.spaceBetween()
  .crossAxisAlignment.center()
  .spacing(16);

// Card content layout
final cardContent = $flex
  .column()
  .crossAxisAlignment.start()
  .spacing(12);

// Button group layout
final buttonGroup = $flex
  .row()
  .mainAxisAlignment.end()
  .spacing(8);

// Form field layout
final formLayout = $flex
  .column()
  .crossAxisAlignment.stretch()
  .spacing(16);

// Grid-like layout with wrapping
final gridLayout = $flex
  .row()
  .mainAxisAlignment.spaceEvenly()
  .crossAxisAlignment.start()
  .spacing(12);

// Toolbar layout
final toolbar = $flex
  .row()
  .mainAxisAlignment.spaceBetween()
  .crossAxisAlignment.center()
  .mainAxisSize.max()
  .spacing(8);
```

### Advanced Usage
```dart
// Flexible layout with baseline alignment
final baselineLayout = $flex
  .row()
  .crossAxisAlignment.baseline()
  .textBaseline.alphabetic()
  .mainAxisAlignment.start()
  .spacing(4);

// RTL-aware layout
final rtlLayout = $flex
  .row()
  .textDirection.rtl()
  .mainAxisAlignment.start()
  .crossAxisAlignment.center()
  .spacing(12);

// Vertical layout with reverse order
final reverseLayout = $flex
  .column()
  .verticalDirection.up()
  .mainAxisAlignment.end()
  .crossAxisAlignment.center()
  .spacing(8);
```