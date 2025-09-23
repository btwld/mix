# IconStyler API Reference

## Overview
The `IconStyler` class is an **immutable style class** for icon styling in Mix. It represents a finalized icon style with all properties resolved, created either through direct instantiation or as the result of utility building. IconStyler provides instance methods for convenient style manipulation and supports animations, modifiers, and conditional styling through variants.

**Type Alias:** `IconMix = IconStyler`

**Relationship to Utilities:** IconStyler is the **immutable result** produced by `IconSpecUtility` (accessed via `$icon`). While `$icon.color.blue().size(24)` uses the fluent utility API, the final result is an `IconStyler` instance.

**Note:** For utility-based styling documentation, see [IconSpecUtility API Reference](icon_util_api.md).

## Constructors

### IconStyler({...}) → IconStyler
Main constructor with optional parameters for all icon properties.
```dart
IconStyler({
  Color? color,
  double? size,
  double? weight,
  double? grade,
  double? opticalSize,
  List<ShadowMix>? shadows,
  TextDirection? textDirection,
  bool? applyTextScaling,
  double? fill,
  String? semanticsLabel,
  double? opacity,
  BlendMode? blendMode,
  IconData? icon,
  AnimationConfig? animation,
  ModifierConfig? modifier,
  List<VariantStyle<IconSpec>>? variants,
})
```

### IconStyler.create({...}) → IconStyler
Internal constructor using `Prop<T>` types for advanced usage.
```dart
const IconStyler.create({
  Prop<Color>? color,
  Prop<double>? size,
  Prop<double>? weight,
  Prop<double>? grade,
  Prop<double>? opticalSize,
  Prop<List<Shadow>>? shadows,
  Prop<TextDirection>? textDirection,
  Prop<bool>? applyTextScaling,
  Prop<double>? fill,
  Prop<String>? semanticsLabel,
  Prop<double>? opacity,
  Prop<BlendMode>? blendMode,
  Prop<IconData>? icon,
  AnimationConfig? animation,
  ModifierConfig? modifier,
  List<VariantStyle<IconSpec>>? variants,
})
```

### IconStyler.builder(IconStyler Function(BuildContext)) → IconStyler
Factory constructor for context-dependent icon styling.

## Utility Methods (via $icon)

### Visual Properties

#### $icon.color → ColorUtility
Provides comprehensive color configuration:
- **$icon.color(Color)** → Sets icon color directly
- **$icon.color.red()**, **$icon.color.blue()**, etc. → Named color shortcuts
- **$icon.color.red.shade500()** → Material color shades
- **$icon.color.withOpacity(0.5)** → Color with opacity
- **$icon.color.black87()**, **$icon.color.white70()** → Opacity variants

### Shadow Effects

#### $icon.shadow → ShadowUtility  
Provides shadow configuration:
- **$icon.shadow(ShadowMix)** → Adds a single shadow effect
- **$icon.shadow.small()**, **$icon.shadow.medium()**, **$icon.shadow.large()** → Preset shadows
- **$icon.shadows(List<ShadowMix>)** → Adds multiple shadow effects

### Size & Typography

- **$icon.size(double)** → Sets icon size in logical pixels
- **$icon.weight(double)** → Sets icon weight/thickness for variable fonts
- **$icon.grade(double)** → Sets icon grade for variable fonts
- **$icon.opticalSize(double)** → Sets optical size adjustment for variable fonts
- **$icon.fill(double)** → Sets fill amount for filled/outlined icons (0.0 to 1.0)

### Layout & Direction

- **$icon.textDirection** → MixUtility for TextDirection settings
- **$icon.applyTextScaling(bool)** → Sets whether icon scales with text scale factor

### Modifiers & Animation

- **$icon.wrap** → ModifierUtility for widget modifiers
- **$icon.animate(AnimationConfig)** → Applies animation configuration

## Static Properties

### IconStyler.chain → IconSpecUtility
Static accessor providing utility methods for chaining icon styling operations.

## Core Methods

### call({IconData? icon, String? semanticLabel}) → StyledIcon
Creates a `StyledIcon` widget with optional icon data and semantic label, using this style.

### resolve(BuildContext context) → StyleSpec<IconSpec>
Resolves all properties using the provided context, converting tokens and contextual values into concrete specifications.

### merge(IconStyler? other) → IconStyler
Merges this IconStyler with another, with the other's properties taking precedence for non-null values.

## Visual Properties

### color(Color value) → IconStyler
Sets the icon color.

### size(double value) → IconStyler
Sets the icon size in logical pixels.

### opacity(double value) → IconStyler
Sets the icon opacity (0.0 to 1.0).

### blendMode(BlendMode value) → IconStyler
Sets the blend mode for compositing the icon with its background.

## Advanced Icon Properties

### weight(double value) → IconStyler
Sets the icon weight/thickness for variable fonts that support it.

### grade(double value) → IconStyler
Sets the icon grade for variable fonts that support grade variations.

### opticalSize(double value) → IconStyler
Sets the optical size adjustment for variable fonts.

### fill(double value) → IconStyler
Sets the fill amount for icons that support filled/outlined variations (0.0 to 1.0).

## Icon Data

### icon(IconData value) → IconStyler
Sets the icon data that defines which icon to display.

## Shadow Effects

### shadow(ShadowMix value) → IconStyler
Adds a single shadow effect to the icon.

### shadows(List<ShadowMix> value) → IconStyler
Adds multiple shadow effects to the icon.

## Layout & Direction

### textDirection(TextDirection value) → IconStyler
Sets the text direction for icons that are direction-sensitive.

### applyTextScaling(bool value) → IconStyler
Sets whether the icon should scale with the text scale factor for accessibility.

## Accessibility

### semanticsLabel(String value) → IconStyler
Sets the semantic label for screen readers and accessibility tools.

## Animation & Modifiers

### animate(AnimationConfig animation) → IconStyler
Applies animation configuration to the icon style.

### modifier(ModifierConfig value) → IconStyler
Adds widget modifiers that wrap the icon widget.

### wrap(ModifierConfig value) → IconStyler
Alias for `modifier()` - adds widget modifiers.

## Variants

### variants(List<VariantStyle<IconSpec>> value) → IconStyler
Sets conditional styling variants based on context or state.

## Properties (Read-only)

The following properties are available as readonly `Prop<T>` values:

- **$color** → `Prop<Color>?` - Icon color
- **$size** → `Prop<double>?` - Icon size in logical pixels
- **$weight** → `Prop<double>?` - Icon weight for variable fonts
- **$grade** → `Prop<double>?` - Icon grade for variable fonts
- **$opticalSize** → `Prop<double>?` - Optical size adjustment
- **$shadows** → `Prop<List<Shadow>>?` - Shadow effects
- **$textDirection** → `Prop<TextDirection>?` - Text direction
- **$applyTextScaling** → `Prop<bool>?` - Text scaling behavior
- **$fill** → `Prop<double>?` - Fill amount (0.0 to 1.0)
- **$semanticsLabel** → `Prop<String>?` - Accessibility label
- **$opacity** → `Prop<double>?` - Icon opacity
- **$blendMode** → `Prop<BlendMode>?` - Compositing blend mode
- **$icon** → `Prop<IconData>?` - Icon data

## Modifier Methods (from ModifierStyleMixin)

### wrap(ModifierConfig value) → IconStyler
Applies the given modifier configuration to wrap the icon widget.

#### Layout Modifiers
- **wrapOpacity(double opacity)** → IconStyler - Wraps with opacity modifier
- **wrapPadding(EdgeInsetsGeometryMix padding)** → IconStyler - Wraps with padding modifier
- **wrapSizedBox({double? width, double? height})** → IconStyler - Wraps with sized box
- **wrapConstrainedBox(BoxConstraints constraints)** → IconStyler - Wraps with constrained box
- **wrapAspectRatio(double aspectRatio)** → IconStyler - Wraps with aspect ratio modifier

#### Positioning Modifiers
- **wrapAlign(AlignmentGeometry alignment)** → IconStyler - Wraps with align modifier
- **wrapCenter()** → IconStyler - Wraps with center alignment modifier
- **wrapFractionallySizedBox({double? widthFactor, double? heightFactor, AlignmentGeometry alignment = Alignment.center})** → IconStyler - Wraps with fractionally sized box

#### Transform Modifiers
- **wrapScale(double scale, {Alignment alignment = Alignment.center})** → IconStyler - Wraps with scale transform
- **wrapRotate(double angle, {Alignment alignment = Alignment.center})** → IconStyler - Wraps with rotation transform
- **wrapTranslate(double x, double y, [double z = 0.0])** → IconStyler - Wraps with translation transform
- **wrapTransform(Matrix4 transform, {Alignment alignment = Alignment.center})** → IconStyler - Wraps with custom transform
- **wrapRotatedBox(int quarterTurns)** → IconStyler - Wraps with rotated box modifier

#### Clipping Modifiers
- **wrapClipOval({CustomClipper<Rect>? clipper, Clip? clipBehavior})** → IconStyler - Wraps with oval clipping
- **wrapClipRect({CustomClipper<Rect>? clipper, Clip? clipBehavior})** → IconStyler - Wraps with rectangular clipping
- **wrapClipPath({CustomClipper<Path>? clipper, Clip? clipBehavior})** → IconStyler - Wraps with path clipping
- **wrapClipTriangle({Clip? clipBehavior})** → IconStyler - Wraps with triangle clipping
- **wrapClipRRect({required BorderRadius borderRadius, CustomClipper<RRect>? clipper, Clip? clipBehavior})** → IconStyler - Wraps with rounded rectangle clipping

#### Flex Modifiers
- **wrapFlexible({int flex = 1, FlexFit fit = FlexFit.loose})** → IconStyler - Wraps with flexible modifier
- **wrapExpanded({int flex = 1})** → IconStyler - Wraps with expanded modifier

#### Visibility & Behavior
- **wrapVisibility(bool visible)** → IconStyler - Wraps with visibility modifier
- **wrapIntrinsicWidth()** → IconStyler - Wraps with intrinsic width modifier
- **wrapIntrinsicHeight()** → IconStyler - Wraps with intrinsic height modifier
- **wrapMouseCursor(MouseCursor cursor)** → IconStyler - Wraps with mouse cursor modifier

#### Theme Modifiers
- **wrapDefaultTextStyle(TextStyleMix style)** → IconStyler - Wraps with default text style modifier
- **wrapIconTheme(IconThemeData data)** → IconStyler - Wraps with icon theme modifier
- **wrapBox(BoxStyler spec)** → IconStyler - Wraps with box modifier

## Animation Methods (from AnimationStyleMixin)

### animate(AnimationConfig config) → IconStyler
Applies animation configuration to the icon style.

### keyframeAnimation({required Listenable trigger, required List<KeyframeTrack> timeline, required KeyframeStyleBuilder<IconSpec, IconStyler> styleBuilder}) → IconStyler
Creates keyframe-based animation with timeline control.

### phaseAnimation<P>({required Listenable trigger, required List<P> phases, required IconStyler Function(P phase, IconStyler style) styleBuilder, required CurveAnimationConfig Function(P phase) configBuilder}) → IconStyler
Creates phase-based animation with custom curve configurations for each phase.

## Variant Methods

### variants(List<VariantStyle<IconSpec>> value) → IconStyler
Sets conditional styling variants based on context or state.

### variant(Variant variant, IconStyler style) → IconStyler
Adds a single variant with the given variant condition and style.

#### Context Variants
- **onDark(IconStyler style)** → IconStyler - Applies style in dark mode
- **onLight(IconStyler style)** → IconStyler - Applies style in light mode
- **onNot(ContextVariant contextVariant, IconStyler style)** → IconStyler - Applies style when context variant is NOT active

#### State Variants
- **onHovered(IconStyler style)** → IconStyler - Applies style on hover
- **onPressed(IconStyler style)** → IconStyler - Applies style when pressed
- **onFocused(IconStyler style)** → IconStyler - Applies style when focused
- **onDisabled(IconStyler style)** → IconStyler - Applies style when disabled
- **onSelected(IconStyler style)** → IconStyler - Applies style when selected

#### Responsive Variants
- **onBreakpoint(Breakpoint breakpoint, IconStyler style)** → IconStyler - Applies style at specific breakpoint

#### Builder Variant
- **builder(IconStyler Function(BuildContext context) fn)** → IconStyler - Creates context-dependent styling

## Usage Examples

### Using Global Utility (Recommended)
```dart
// Simple icon styling
final basicIcon = $icon
  .color.blue()
  .size(24);

// Advanced icon styling
final fancyIcon = $icon
  .color.red.shade600()
  .size(32)
  .weight(500)
  .fill(0.8)
  .shadow.medium()
  .animate(AnimationConfig(duration: Duration(milliseconds: 200)));

// Variable font features
final variableIcon = $icon
  .size(28)
  .color.green()
  .weight(600)
  .grade(200)
  .opticalSize(24)
  .fill(1.0);

// Icon with multiple shadows
final shadowedIcon = $icon
  .color.purple()
  .size(20)
  .shadows([
    ShadowMix(
      color: Colors.black26,
      offset: Offset(1, 1),
      blurRadius: 2,
    ),
    ShadowMix(
      color: Colors.purple.withOpacity(0.3),
      offset: Offset(2, 2),
      blurRadius: 4,
    ),
  ]);
```

### Using IconStyler Constructor
```dart
final iconStyle = IconStyler()
  .color(Colors.blue)
  .size(24)
  .weight(400)
  .fill(0.5)
  .shadow(ShadowMix(
    color: Colors.black26,
    offset: Offset(2, 2),
    blurRadius: 4,
  ))
  .animate(AnimationConfig(duration: Duration(milliseconds: 300)));
```

### Creating Widgets
```dart
// Using Style.icon() factory (common pattern)
final widget = Style.icon(
  color: Colors.blue,
  size: 24,
)(icon: Icons.star, semanticLabel: 'Favorite');

// Using StyledIcon widget directly
final widget = StyledIcon(
  icon: Icons.star,
  style: iconStyle,
  semanticLabel: 'Favorite',
);

// Using call operator on style
final widget = iconStyle(icon: Icons.star, semanticLabel: 'Favorite');
```

### Common Icon Patterns
```dart
// Navigation icons
final navIcon = $icon
  .color.grey.shade600()
  .size(24);

// Action button icons
final actionIcon = $icon
  .color.white()
  .size(20)
  .weight(500);

// Status icons with colors
final successIcon = $icon.color.green().size(16);
final warningIcon = $icon.color.orange().size(16);
final errorIcon = $icon.color.red().size(16);

// Large feature icons
final featureIcon = $icon
  .color.blue.shade700()
  .size(48)
  .weight(400)
  .shadow.large();

// Interactive icons with hover effects
final interactiveIcon = $icon
  .color.grey.shade700()
  .size(20)
  .animate(AnimationConfig(
    duration: Duration(milliseconds: 150),
    curve: Curves.easeInOut,
  ));
```
