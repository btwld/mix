# TextStyler API Reference

## Overview
The `TextStyler` class is an **immutable style class** for text styling in Mix. It represents a finalized text style with all properties resolved, created either through direct instantiation or as the result of utility building. TextStyler provides instance methods for convenient style manipulation and supports text directives, animations, and conditional styling through variants.

**Type Alias:** `TextMix = TextStyler`

**Relationship to Utilities:** TextStyler is the **immutable result** produced by `TextSpecUtility` (accessed via `$text`). While `$text.color.blue().fontSize(16)` uses the fluent utility API, the final result is a `TextStyler` instance.

**Note:** For utility-based styling documentation, see [TextSpecUtility API Reference](text_util_api.md).

## Constructors

### TextStyler({...}) → TextStyler
Main constructor with optional parameters for all text properties.
```dart
TextStyler({
  TextOverflow? overflow,
  StrutStyleMix? strutStyle,
  TextAlign? textAlign,
  TextScaler? textScaler,
  int? maxLines,
  TextStyleMix? style,
  TextWidthBasis? textWidthBasis,
  TextHeightBehaviorMix? textHeightBehavior,
  TextDirection? textDirection,
  bool? softWrap,
  List<Directive<String>>? textDirectives,
  Color? selectionColor,
  String? semanticsLabel,
  Locale? locale,
  AnimationConfig? animation,
  ModifierConfig? modifier,
  List<VariantStyle<TextSpec>>? variants,
})
```

### TextStyler.create({...}) → TextStyler
Internal constructor using `Prop<T>` types for advanced usage.
```dart
const TextStyler.create({
  Prop<TextOverflow>? overflow,
  Prop<StrutStyle>? strutStyle,
  Prop<TextAlign>? textAlign,
  Prop<TextScaler>? textScaler,
  Prop<int>? maxLines,
  Prop<TextStyle>? style,
  Prop<TextWidthBasis>? textWidthBasis,
  Prop<TextHeightBehavior>? textHeightBehavior,
  Prop<TextDirection>? textDirection,
  Prop<bool>? softWrap,
  List<Directive<String>>? textDirectives,
  Prop<Color>? selectionColor,
  Prop<String>? semanticsLabel,
  Prop<Locale>? locale,
  AnimationConfig? animation,
  ModifierConfig? modifier,
  List<VariantStyle<TextSpec>>? variants,
})
```

### TextStyler.builder(TextStyler Function(BuildContext)) → TextStyler
Factory constructor for context-dependent text styling.

## Utility Methods (via $text)

### Text Style Properties

#### $text.style → TextStyleUtility
Core text styling utility providing comprehensive typography controls:
- **$text.style.fontSize(double)** → Sets font size in logical pixels
- **$text.style.fontFamily(String)** → Sets font family
- **$text.style.fontWeight** → FontWeight utility (with .bold() shortcut)
- **$text.style.fontStyle** → FontStyle utility (with .italic() shortcut) 
- **$text.style.color** → ColorUtility for text color
- **$text.style.backgroundColor** → ColorUtility for background color
- **$text.style.decoration** → TextDecoration utility (underline, overline, etc.)
- **$text.style.decorationColor** → ColorUtility for decoration color
- **$text.style.decorationStyle** → TextDecorationStyle utility
- **$text.style.decorationThickness(double)** → Sets decoration thickness
- **$text.style.height(double)** → Sets line height multiplier
- **$text.style.letterSpacing(double)** → Sets letter spacing
- **$text.style.wordSpacing(double)** → Sets word spacing
- **$text.style.textBaseline** → TextBaseline utility
- **$text.style.shadows(List<Shadow>)** → Sets text shadows
- **$text.style.fontVariations(List<FontVariation>)** → Sets variable font axes
- **$text.style.fontFeatures(List<FontFeature>)** → Sets font features
- **$text.style.foreground(Paint)** → Sets foreground paint
- **$text.style.background(Paint)** → Sets background paint
- **$text.style.fontFamilyFallback(List<String>)** → Sets fallback fonts
- **$text.style.debugLabel(String)** → Sets debug label

#### Direct Style Shortcuts
These properties are available directly on `$text` for convenience:
- **$text.color** → Direct access to text color utility
- **$text.fontSize(double)** → Direct font size setter
- **$text.fontFamily(String)** → Direct font family setter
- **$text.fontWeight** → Direct font weight utility
- **$text.fontStyle** → Direct font style utility
- **$text.decoration** → Direct text decoration utility
- **$text.backgroundColor** → Direct background color utility
- **$text.decorationColor** → Direct decoration color utility
- **$text.decorationStyle** → Direct decoration style utility
- **$text.textBaseline** → Direct text baseline utility
- **$text.height(double)** → Direct line height setter
- **$text.letterSpacing(double)** → Direct letter spacing setter
- **$text.wordSpacing(double)** → Direct word spacing setter
- **$text.fontVariations** → Direct font variations utility
- **$text.shadows** → Direct text shadows utility
- **$text.foreground** → Direct foreground paint utility
- **$text.background** → Direct background paint utility
- **$text.fontFeatures** → Direct font features utility
- **$text.decorationThickness** → Direct decoration thickness utility
- **$text.fontFamilyFallback** → Direct fallback fonts utility
- **$text.debugLabel** → Direct debug label utility

### Text Layout & Display

- **$text.textOverflow** → MixUtility for TextOverflow settings
- **$text.textAlign** → MixUtility for TextAlign settings
- **$text.textScaler** → MixUtility for TextScaler settings
- **$text.textWidthBasis** → MixUtility for TextWidthBasis settings
- **$text.textDirection** → MixUtility for TextDirection settings
- **$text.maxLines(int)** → Sets maximum number of lines
- **$text.softWrap(bool)** → Sets soft wrap behavior

### Text Behavior & Formatting

- **$text.strutStyle** → StrutStyleUtility for consistent line heights
- **$text.textHeightBehavior** → TextHeightBehaviorUtility for height calculations
- **$text.directives** → MixUtility for text transformation directives
- **$text.locale** → MixUtility for locale settings

### Accessibility & Selection

- **$text.selectionColor** → ColorUtility for text selection highlighting
- **$text.semanticsLabel(String)** → Sets semantic label for accessibility

### Convenience Methods

- **$text.bold()** → Makes text bold (shortcut for fontWeight.bold())
- **$text.italic()** → Makes text italic (shortcut for fontStyle.italic())

### Modifiers & Animation

- **$text.wrap** → ModifierUtility for widget modifiers
- **$text.animate(AnimationConfig)** → Applies animation configuration

## Static Properties

### TextStyler.chain → TextSpecUtility
Static accessor providing utility methods for chaining text styling operations.

## Core Methods

### call(String text) → StyledText
Creates a `StyledText` widget with the provided text and this style applied.

### resolve(BuildContext context) → StyleSpec<TextSpec>
Resolves all properties using the provided context, converting tokens and contextual values into concrete specifications.

### merge(TextStyler? other) → TextStyler
Merges this TextStyler with another, with the other's properties taking precedence for non-null values.

## Instance Methods

### Text Display Properties

- **overflow(TextOverflow value)** → TextStyler - Sets how text overflow is handled (clip, ellipsis, fade, visible)
- **maxLines(int value)** → TextStyler - Sets the maximum number of lines for the text to span
- **softWrap(bool value)** → TextStyler - Sets whether text should break at soft line breaks
- **textAlign(TextAlign value)** → TextStyler - Sets how text is aligned horizontally within its container
- **textDirection(TextDirection value)** → TextStyler - Sets the directionality of the text (left-to-right or right-to-left)
- **textWidthBasis(TextWidthBasis value)** → TextStyler - Sets how the text's width is measured (parent width or text width)

### Text Scaling & Layout

- **textScaler(TextScaler value)** → TextStyler - Sets the text scaling factor for accessibility
- **textHeightBehavior(TextHeightBehaviorMix value)** → TextStyler - Sets how text height is calculated and applied
- **strutStyle(StrutStyleMix value)** → TextStyler - Sets the strut style for consistent text line heights

### Text Style Methods (from TextStyleMixin)

#### Base Method
- **style(TextStyleMix value)** → TextStyler - Sets the text style through the mixin

#### Typography Methods
- **color(Color value)** → TextStyler - Sets text color
- **backgroundColor(Color value)** → TextStyler - Sets background color
- **fontSize(double value)** → TextStyler - Sets font size
- **fontWeight(FontWeight value)** → TextStyler - Sets font weight
- **fontStyle(FontStyle value)** → TextStyler - Sets font style (normal/italic)
- **fontFamily(String value)** → TextStyler - Sets font family
- **fontFamilyFallback(List<String> value)** → TextStyler - Sets font family fallback list

#### Text Spacing & Layout
- **letterSpacing(double value)** → TextStyler - Sets letter spacing
- **wordSpacing(double value)** → TextStyler - Sets word spacing
- **height(double value)** → TextStyler - Sets line height
- **textBaseline(TextBaseline value)** → TextStyler - Sets text baseline

#### Text Decoration
- **decoration(TextDecoration value)** → TextStyler - Sets text decoration (underline, overline, line-through)
- **decorationColor(Color value)** → TextStyler - Sets decoration color
- **decorationStyle(TextDecorationStyle value)** → TextStyler - Sets decoration style (solid, dashed, dotted, etc.)
- **decorationThickness(double value)** → TextStyler - Sets decoration thickness

#### Advanced Text Features
- **shadows(List<ShadowMix> value)** → TextStyler - Sets text shadows
- **fontFeatures(List<FontFeature> value)** → TextStyler - Sets font features
- **fontVariations(List<FontVariation> value)** → TextStyler - Sets font variations for variable fonts
- **foreground(Paint value)** → TextStyler - Sets foreground paint
- **background(Paint value)** → TextStyler - Sets background paint
- **debugLabel(String value)** → TextStyler - Sets debug label
- **inherit(bool value)** → TextStyler - Sets inherit property

## Text Transformations

### Text Transformation Methods

- **uppercase()** → TextStyler - Applies uppercase transformation to the text content
- **lowercase()** → TextStyler - Applies lowercase transformation to the text content
- **capitalize()** → TextStyler - Capitalizes the first letter of the text content
- **titleCase()** → TextStyler - Applies title case transformation (capitalizes first letter of each word)
- **sentenceCase()** → TextStyler - Applies sentence case transformation (capitalizes first letter of each sentence)
- **directive(Directive<String> value)** → TextStyler - Applies a custom text directive for string transformation
- **textDirective(Directive<String> value)** → TextStyler - Alias for directive() - applies a text directive

## Modifier Methods (from ModifierStyleMixin)

### wrap(ModifierConfig value) → TextStyler
Applies the given modifier configuration to wrap the text widget.

#### Layout Modifiers
- **wrapOpacity(double opacity)** → TextStyler - Wraps with opacity modifier
- **wrapPadding(EdgeInsetsGeometryMix padding)** → TextStyler - Wraps with padding modifier
- **wrapSizedBox({double? width, double? height})** → TextStyler - Wraps with sized box
- **wrapConstrainedBox(BoxConstraints constraints)** → TextStyler - Wraps with constrained box
- **wrapAspectRatio(double aspectRatio)** → TextStyler - Wraps with aspect ratio modifier

#### Positioning Modifiers
- **wrapAlign(AlignmentGeometry alignment)** → TextStyler - Wraps with align modifier
- **wrapCenter()** → TextStyler - Wraps with center alignment modifier
- **wrapFractionallySizedBox({double? widthFactor, double? heightFactor, AlignmentGeometry alignment = Alignment.center})** → TextStyler - Wraps with fractionally sized box

#### Transform Modifiers
- **wrapScale(double scale, {Alignment alignment = Alignment.center})** → TextStyler - Wraps with scale transform
- **wrapRotate(double angle, {Alignment alignment = Alignment.center})** → TextStyler - Wraps with rotation transform
- **wrapTranslate(double x, double y, [double z = 0.0])** → TextStyler - Wraps with translation transform
- **wrapTransform(Matrix4 transform, {Alignment alignment = Alignment.center})** → TextStyler - Wraps with custom transform
- **wrapRotatedBox(int quarterTurns)** → TextStyler - Wraps with rotated box modifier

#### Clipping Modifiers
- **wrapClipOval({CustomClipper<Rect>? clipper, Clip? clipBehavior})** → TextStyler - Wraps with oval clipping
- **wrapClipRect({CustomClipper<Rect>? clipper, Clip? clipBehavior})** → TextStyler - Wraps with rectangular clipping
- **wrapClipPath({CustomClipper<Path>? clipper, Clip? clipBehavior})** → TextStyler - Wraps with path clipping
- **wrapClipTriangle({Clip? clipBehavior})** → TextStyler - Wraps with triangle clipping
- **wrapClipRRect({required BorderRadius borderRadius, CustomClipper<RRect>? clipper, Clip? clipBehavior})** → TextStyler - Wraps with rounded rectangle clipping

#### Flex Modifiers
- **wrapFlexible({int flex = 1, FlexFit fit = FlexFit.loose})** → TextStyler - Wraps with flexible modifier
- **wrapExpanded({int flex = 1})** → TextStyler - Wraps with expanded modifier

#### Visibility & Behavior
- **wrapVisibility(bool visible)** → TextStyler - Wraps with visibility modifier
- **wrapIntrinsicWidth()** → TextStyler - Wraps with intrinsic width modifier
- **wrapIntrinsicHeight()** → TextStyler - Wraps with intrinsic height modifier
- **wrapMouseCursor(MouseCursor cursor)** → TextStyler - Wraps with mouse cursor modifier

#### Theme Modifiers
- **wrapDefaultTextStyle(TextStyleMix style)** → TextStyler - Wraps with default text style modifier
- **wrapIconTheme(IconThemeData data)** → TextStyler - Wraps with icon theme modifier
- **wrapBox(BoxStyler spec)** → TextStyler - Wraps with box modifier

## Animation Methods (from AnimationStyleMixin)

### animate(AnimationConfig config) → TextStyler
Applies animation configuration to the text style.

### keyframeAnimation({required Listenable trigger, required List<KeyframeTrack> timeline, required KeyframeStyleBuilder<TextSpec, TextStyler> styleBuilder}) → TextStyler
Creates keyframe-based animation with timeline control.

### phaseAnimation<P>({required Listenable trigger, required List<P> phases, required TextStyler Function(P phase, TextStyler style) styleBuilder, required CurveAnimationConfig Function(P phase) configBuilder}) → TextStyler
Creates phase-based animation with custom curve configurations for each phase.

## Variant Methods

### variants(List<VariantStyle<TextSpec>> value) → TextStyler
Sets conditional styling variants based on context or state.

### variant(Variant variant, TextStyler style) → TextStyler
Adds a single variant with the given variant condition and style.

#### Context Variants
- **onDark(TextStyler style)** → TextStyler - Applies style in dark mode
- **onLight(TextStyler style)** → TextStyler - Applies style in light mode
- **onNot(ContextVariant contextVariant, TextStyler style)** → TextStyler - Applies style when context variant is NOT active

#### State Variants
- **onHovered(TextStyler style)** → TextStyler - Applies style on hover
- **onPressed(TextStyler style)** → TextStyler - Applies style when pressed
- **onFocused(TextStyler style)** → TextStyler - Applies style when focused
- **onDisabled(TextStyler style)** → TextStyler - Applies style when disabled
- **onSelected(TextStyler style)** → TextStyler - Applies style when selected

#### Responsive Variants
- **onBreakpoint(Breakpoint breakpoint, TextStyler style)** → TextStyler - Applies style at specific breakpoint

#### Builder Variant
- **builder(TextStyler Function(BuildContext context) fn)** → TextStyler - Creates context-dependent styling

## Accessibility & Semantics

### selectionColor(Color value) → TextStyler
Sets the color used for text selection highlighting.

### semanticsLabel(String value) → TextStyler
Sets the semantic label for accessibility purposes.

### locale(Locale value) → TextStyler
Sets the locale for text rendering and behavior.

## Properties (Read-only)

The following properties are available as readonly `Prop<T>` values:

- **$overflow** → `Prop<TextOverflow>?` - Text overflow behavior
- **$strutStyle** → `Prop<StrutStyle>?` - Strut style configuration
- **$textAlign** → `Prop<TextAlign>?` - Text alignment
- **$textScaler** → `Prop<TextScaler>?` - Text scaling factor
- **$maxLines** → `Prop<int>?` - Maximum lines
- **$style** → `Prop<TextStyle>?` - Text style properties
- **$textWidthBasis** → `Prop<TextWidthBasis>?` - Width measurement basis
- **$textHeightBehavior** → `Prop<TextHeightBehavior>?` - Height behavior
- **$textDirection** → `Prop<TextDirection>?` - Text direction
- **$softWrap** → `Prop<bool>?` - Soft wrap behavior
- **$textDirectives** → `List<Directive<String>>?` - Text transformations
- **$selectionColor** → `Prop<Color>?` - Selection highlighting color
- **$semanticsLabel** → `Prop<String>?` - Accessibility label
- **$locale** → `Prop<Locale>?` - Text locale

## Mixins

TextStyler includes the following mixins for additional functionality:

- **ModifierStyleMixin** - Widget modifier support
- **VariantStyleMixin** - Conditional styling support
- **TextStyleMixin** - Text styling utilities
- **AnimationStyleMixin** - Animation support

## Usage Examples

### Using Global Utility (Recommended)
```dart
// Fluent API with global utility
final style = $text
  .color.blue()
  .fontSize(16)
  .bold()
  .textAlign(TextAlign.center)
  .maxLines(2)
  .textOverflow(TextOverflow.ellipsis);

// More complex styling
final fancyStyle = $text
  .fontFamily('Roboto')
  .fontSize(20)
  .fontWeight.w600()
  .color.red()
  .decoration(TextDecoration.underline)
  .decorationColor.blue()
  .letterSpacing(1.2)
  .height(1.4)
  .shadows([Shadow(
    color: Colors.black26,
    offset: Offset(1, 1),
    blurRadius: 2,
  )]);

// Typography presets
final headingStyle = $text.fontSize(24).fontWeight.bold().color.black();
final bodyStyle = $text.fontSize(14).color.grey.shade700();
final captionStyle = $text.fontSize(12).color.grey().italic();
```

### Using TextStyler Constructor
```dart
final textStyle = TextStyler()
  .style(TextStyleMix(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: Colors.blue,
  ))
  .textAlign(TextAlign.center)
  .maxLines(2)
  .overflow(TextOverflow.ellipsis)
  .uppercase()
  .animate(AnimationConfig(duration: Duration(milliseconds: 200)));
```

### Using Instance Methods
```dart
// Using mixin methods for convenience
final styledText = TextStyler()
  .color(Colors.blue)
  .fontSize(16)
  .fontWeight(FontWeight.bold)
  .letterSpacing(0.5)
  .height(1.4)
  .decoration(TextDecoration.underline)
  .decorationColor(Colors.blue)
  .textAlign(TextAlign.center)
  .maxLines(2)
  .overflow(TextOverflow.ellipsis);

// Text with advanced styling
final fancyText = TextStyler()
  .fontFamily('Roboto')
  .fontSize(20)
  .fontWeight(FontWeight.w600)
  .color(Colors.red)
  .backgroundColor(Colors.yellow.shade100)
  .shadows([
    ShadowMix(
      color: Colors.black26,
      offset: Offset(1, 1),
      blurRadius: 2,
    ),
  ])
  .letterSpacing(1.2)
  .wordSpacing(2.0)
  .decoration(TextDecoration.underline)
  .decorationStyle(TextDecorationStyle.wavy)
  .titleCase();

// Minimalist text styling
final simpleText = TextStyler()
  .fontSize(14)
  .color(Colors.black87)
  .height(1.5);
```

### Creating Widgets
```dart
// Using Style.text() factory (common pattern)
final widget = Style.text(
  fontSize: 16,
  color: Colors.blue,
  fontWeight: FontWeight.bold,
)('Hello World');

// Using StyledText widget directly
final widget = StyledText('Hello World', style: textStyle);

// Using call operator on style
final widget = textStyle('Hello World');
```

### Common Text Patterns
```dart
// Button text
final buttonText = $text
  .fontSize(16)
  .fontWeight.w600()
  .color.white()
  .letterSpacing(0.5);

// Title text
final titleText = $text
  .fontSize(24)
  .fontWeight.bold()
  .color.black87()
  .height(1.2);

// Body text with custom styling
final bodyText = $text
  .fontSize(14)
  .color.grey.shade800()
  .height(1.5)
  .fontFamily('Inter')
  .letterSpacing(0.1);

// Error text
final errorText = $text
  .fontSize(12)
  .color.red()
  .fontWeight.w500();

// Link text
final linkText = $text
  .color.blue()
  .decoration(TextDecoration.underline)
  .decorationColor.blue();
```
