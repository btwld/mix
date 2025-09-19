# TextSpecUtility API Reference

## Overview
The `TextSpecUtility` class provides a mutable utility for text styling with cascade notation support in Mix. It maintains mutable internal state enabling fluid styling like `$text..color.red()..fontSize(16)`. This is the core utility class behind the global `$text` accessor.

**Global Access:** `$text` → `TextSpecUtility()`

## Core Utility Properties

### Text Layout & Display

#### $text.textOverflow → MixUtility
Controls text overflow behavior:
- **$text.textOverflow(TextOverflow value)** → TextStyler - Sets overflow behavior
- **$text.textOverflow.clip()** → TextStyler - Clips overflowing text
- **$text.textOverflow.ellipsis()** → TextStyler - Shows ellipsis for overflow
- **$text.textOverflow.fade()** → TextStyler - Fades overflowing text
- **$text.textOverflow.visible()** → TextStyler - Shows all text (may overflow)

#### $text.textAlign → MixUtility
Controls text alignment:
- **$text.textAlign(TextAlign value)** → TextStyler - Sets text alignment
- **$text.textAlign.left()** → TextStyler - Left-align text
- **$text.textAlign.right()** → TextStyler - Right-align text
- **$text.textAlign.center()** → TextStyler - Center-align text
- **$text.textAlign.justify()** → TextStyler - Justify text
- **$text.textAlign.start()** → TextStyler - Start-align text (RTL-aware)
- **$text.textAlign.end()** → TextStyler - End-align text (RTL-aware)

#### $text.textScaler → MixUtility
Controls text scaling for accessibility:
- **$text.textScaler(TextScaler value)** → TextStyler - Sets text scaler
- **$text.textScaler.linear(double factor)** → TextStyler - Sets linear scaling factor

#### $text.textWidthBasis → MixUtility
Controls how text width is measured:
- **$text.textWidthBasis(TextWidthBasis value)** → TextStyler - Sets width measurement basis
- **$text.textWidthBasis.parent()** → TextStyler - Use parent width
- **$text.textWidthBasis.longestLine()** → TextStyler - Use longest line width

#### $text.textDirection → MixUtility
Controls text direction:
- **$text.textDirection(TextDirection value)** → TextStyler - Sets text direction
- **$text.textDirection.ltr()** → TextStyler - Left-to-right direction
- **$text.textDirection.rtl()** → TextStyler - Right-to-left direction

### Text Style Properties

#### $text.style → TextStyleUtility
Core text styling utility providing comprehensive typography controls:

##### Typography Methods
- **$text.style.fontSize(double value)** → TextStyler - Sets font size in logical pixels
- **$text.style.fontFamily(String value)** → TextStyler - Sets font family
- **$text.style.fontWeight(FontWeight value)** → TextStyler - Sets font weight
- **$text.style.fontStyle(FontStyle value)** → TextStyler - Sets font style (normal/italic)
- **$text.style.color(Color value)** → TextStyler - Sets text color
- **$text.style.backgroundColor(Color value)** → TextStyler - Sets background color

##### Text Decoration
- **$text.style.decoration(TextDecoration value)** → TextStyler - Sets text decoration
- **$text.style.decorationColor(Color value)** → TextStyler - Sets decoration color
- **$text.style.decorationStyle(TextDecorationStyle value)** → TextStyler - Sets decoration style
- **$text.style.decorationThickness(double value)** → TextStyler - Sets decoration thickness

##### Spacing & Layout
- **$text.style.letterSpacing(double value)** → TextStyler - Sets letter spacing
- **$text.style.wordSpacing(double value)** → TextStyler - Sets word spacing
- **$text.style.height(double value)** → TextStyler - Sets line height multiplier
- **$text.style.textBaseline(TextBaseline value)** → TextStyler - Sets text baseline

##### Advanced Typography
- **$text.style.shadows(List<Shadow> value)** → TextStyler - Sets text shadows
- **$text.style.fontVariations(List<FontVariation> value)** → TextStyler - Sets variable font axes
- **$text.style.fontFeatures(List<FontFeature> value)** → TextStyler - Sets font features
- **$text.style.foreground(Paint value)** → TextStyler - Sets foreground paint
- **$text.style.background(Paint value)** → TextStyler - Sets background paint
- **$text.style.fontFamilyFallback(List<String> value)** → TextStyler - Sets fallback fonts

### Convenience Accessors (Direct Style Access)

#### Typography
- **$text.color** → ColorUtility - Direct access to text color utility
- **$text.fontSize(double value)** → TextStyler - Direct font size setter
- **$text.fontFamily(String value)** → TextStyler - Direct font family setter
- **$text.fontWeight** → FontWeightUtility - Direct font weight utility
- **$text.fontStyle** → FontStyleUtility - Direct font style utility

#### Text Decoration
- **$text.decoration** → TextDecorationUtility - Direct text decoration utility
- **$text.backgroundColor** → ColorUtility - Direct background color utility
- **$text.decorationColor** → ColorUtility - Direct decoration color utility
- **$text.decorationStyle** → DecorationStyleUtility - Direct decoration style utility

#### Spacing
- **$text.height(double value)** → TextStyler - Direct line height setter
- **$text.letterSpacing(double value)** → TextStyler - Direct letter spacing setter
- **$text.wordSpacing(double value)** → TextStyler - Direct word spacing setter

#### Advanced Features
- **$text.textBaseline** → TextBaselineUtility - Direct text baseline utility
- **$text.fontVariations** → FontVariationUtility - Direct font variations utility
- **$text.shadows** → ShadowUtility - Direct text shadows utility
- **$text.foreground** → PaintUtility - Direct foreground paint utility
- **$text.background** → PaintUtility - Direct background paint utility
- **$text.fontFeatures** → FontFeatureUtility - Direct font features utility
- **$text.decorationThickness** → ThicknessUtility - Direct decoration thickness utility
- **$text.fontFamilyFallback** → FontFallbackUtility - Direct fallback fonts utility
- **$text.debugLabel** → DebugLabelUtility - Direct debug label utility

### Text Behavior & Formatting

#### $text.strutStyle → StrutStyleUtility
Controls strut style for consistent line heights:
- **$text.strutStyle(StrutStyle value)** → TextStyler - Sets strut style
- **$text.strutStyle.height(double value)** → TextStyler - Sets strut height
- **$text.strutStyle.fontSize(double value)** → TextStyler - Sets strut font size
- **$text.strutStyle.fontFamily(String value)** → TextStyler - Sets strut font family

#### $text.textHeightBehavior → TextHeightBehaviorUtility
Controls text height calculations:
- **$text.textHeightBehavior(TextHeightBehavior value)** → TextStyler - Sets height behavior
- **$text.textHeightBehavior.applyHeightToFirstAscent(bool value)** → TextStyler - Controls first line height
- **$text.textHeightBehavior.applyHeightToLastDescent(bool value)** → TextStyler - Controls last line height

#### $text.directives → MixUtility
Controls text transformation directives:
- **$text.directives(List<Directive<String>> value)** → TextStyler - Sets text directives

#### $text.locale → MixUtility  
Controls locale for text rendering:
- **$text.locale(Locale value)** → TextStyler - Sets text locale

### Accessibility & Selection

#### $text.selectionColor → ColorUtility
Controls text selection highlighting:
- **$text.selectionColor(Color value)** → TextStyler - Sets selection color
- **$text.selectionColor.red()** → TextStyler - Sets red selection color
- **$text.selectionColor.blue()** → TextStyler - Sets blue selection color

### Modifiers & Animation

#### $text.wrap → ModifierUtility
Provides widget modifiers:
- **$text.wrap(Modifier value)** → TextStyler - Applies widget modifier
- **$text.wrap.opacity(double value)** → TextStyler - Wraps with opacity modifier
- **$text.wrap.padding(EdgeInsets value)** → TextStyler - Wraps with padding modifier
- **$text.wrap.transform(Matrix4 value)** → TextStyler - Wraps with transform modifier

## Core Methods

### animate(AnimationConfig animation) → TextStyler
Applies animation configuration to the text styling.

### merge(Style<TextSpec>? other) → TextSpecUtility
Merges this utility with another style, returning a new utility instance.

## Variant Support

The TextSpecUtility includes `UtilityVariantMixin` providing:

### withVariant(Variant variant, TextStyler style) → TextStyler
Applies a style under a specific variant condition.

### withVariants(List<VariantStyle<TextSpec>> variants) → TextStyler
Applies multiple variant styles.

## Deprecated Methods

### $text.on → OnContextVariantUtility (Deprecated)
**⚠️ Deprecated:** Use direct methods like `$text.onHovered()` instead.
- **$text.on.hover(TextStyler style)** → TextStyler - Apply style on hover
- **$text.on.dark(TextStyler style)** → TextStyler - Apply style in dark mode
- **$text.on.light(TextStyler style)** → TextStyler - Apply style in light mode

**Replacement Pattern:**
```dart
// Instead of:
$text.on.hover($text.color.blue())

// Use:
$text.onHovered($text.color.blue())
```

## Usage Examples

### Basic Text Styling
```dart
// Simple colored text
final basicText = $text
  .color.blue()
  .fontSize(16);

// Bold text with custom font
final boldText = $text
  .fontWeight.bold()
  .fontFamily('Roboto')
  .fontSize(18);
```

### Advanced Typography
```dart
// Styled text with decoration
final decoratedText = $text
  .fontSize(20)
  .fontWeight.w600()
  .color.red()
  .decoration.underline()
  .decorationColor.blue()
  .letterSpacing(1.2)
  .height(1.4);

// Text with shadows and effects
final shadowText = $text
  .fontSize(24)
  .fontWeight.bold()
  .color.white()
  .shadows([
    Shadow(
      color: Colors.black26,
      offset: Offset(1, 1),
      blurRadius: 2,
    ),
  ]);
```

### Text Layout Control
```dart
// Controlled text layout
final layoutText = $text
  .fontSize(14)
  .color.black87()
  .textAlign.center()
  .textOverflow.ellipsis()
  .height(1.5);

// Responsive text scaling
final accessibleText = $text
  .fontSize(16)
  .textScaler.linear(1.2)
  .color.grey().shade800();
```

### Text Transformations
```dart
// Uppercase text with spacing
final upperText = $text
  .fontSize(12)
  .fontWeight.w600()
  .color.grey().shade600()
  .letterSpacing(0.8)
  .textTransform.uppercase();

// Title case with custom styling
final titleText = $text
  .fontSize(24)
  .fontWeight.bold()
  .color.black()
  .textTransform.titleCase()
  .height(1.2);
```

### Variant-Based Styling
```dart
// Theme-aware text
final themeText = $text
  .fontSize(16)
  .color.black()
  .onDark($text.color.white())
  .onBreakpoint(Breakpoint.md, $text.fontSize(18));

// Interactive text
final interactiveText = $text
  .color.blue()
  .decoration.underline()
  .onHovered($text.color.blue().shade700());
```

## Performance Notes

- **Mutable State**: TextSpecUtility maintains mutable state for efficient chaining
- **Lazy Properties**: Sub-utilities are initialized lazily using `late final`
- **Immutable Results**: Despite mutable building, the final styles are immutable
- **Text Rendering**: Optimized for Flutter's text rendering pipeline

## Related Classes

- **TextStyler** - The immutable style class that TextSpecUtility builds
- **TextSpec** - The resolved specification used at runtime
- **TextStyleUtility** - Utility for comprehensive text style configuration
- **StrutStyleUtility** - Utility for strut style configuration
- **TextHeightBehaviorUtility** - Utility for text height behavior