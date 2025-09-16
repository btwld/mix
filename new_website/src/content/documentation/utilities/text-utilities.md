# Text Utilities

## $text.overflow
Utility for setting `TextOverflow` values.

```dart
$text.overflow.clip();
$text.overflow.ellipsis();
$text.overflow.fade();
```

## $text.strutStyle
Utility for setting `StrutStyle` values.

### $text.strutStyle.fontFamily
The name of the font to use when calculating the strut.

```dart
$text.strutStyle.fontFamily('Roboto')
```

### $text.strutStyle.fontSize
The size of text (in logical pixels) to use when obtaining metrics from the font.

```dart 
$text.strutStyle.fontSize(10)
```

### $text.strutStyle.fontWeight

Useful for defining `FontWeight` values for widgets

```dart
$text.strutStyle.fontWeight(FontWeight.w500)
```

### $text.strutStyle.fontStyle
The typeface variant to use when calculating the strut

```dart
$text.strutStyle.fontStyle.italic()
```

### $text.strutStyle.forceStrutHeight

Whether the strut height should be forced

```dart
$text.strutStyle.forceStrutHeight.on()
```

### $text.strutStyle.height
The minimum height of the strut, as a multiple of `fontSize`.

```dart
$text.strutStyle.height(1.5)
```

### $text.strutStyle.leading
The additional leading to apply to the strut as a multiple of `fontSize`, independent of `height` and `leadingDistribution`.

```dart
$text.strutStyle.leading(10)
```

### $text.strutStyle.fontFamilyFallback
The ordered list of font families to fall back on when a higher priority font family cannot be found.

```dart
$text.strutStyle.fontFamilyFallback(['Roboto']),
```

## $text.textAlign
How the text should be aligned horizontally.

```dart
$text.textAlign.left()
$text.textAlign.right()
$text.textAlign.center()
$text.textAlign.justify()
$text.textAlign.start()
$text.textAlign.end()
```

## $text.maxLines
An optional maximum number of lines for the text to span, wrapping if necessary.

```dart
$text.maxLines(1)
```


## $text.style
The style to use for text.

### $text.style.fontFamily
The name of the font to use when painting the text.

```dart
$text.style.fontFamily()
```

### $text.style.fontWeight
The typeface thickness to use when painting the text.

```dart
$text.style.fontWeight()
```

### $text.style.fontStyle
The typeface variant to use when drawing the letters.

```dart
$text.style.fontStyle()
```

### $text.style.fontSize
The size of fonts (in logical pixels) to use when painting the text.

```dart
$text.style.fontSize(20)
```

### $text.style.letterSpacing
The amount of space (in logical pixels) to add between each letter. A negative value can be used to bring the letters closer.

```dart
$text.style.letterSpacing(10)
```

### $text.style.wordSpacing
The amount of space (in logical pixels) to add at each sequence of white-space (i.e. between each word). A negative value can be used to bring the words closer.

```dart
$text.style.wordSpacing(30)
```

### $text.style.textBaseline
The common baseline that should be aligned between this text span and its parent text span, or, for the root text spans, with the line box.

```dart
$text.style.textBaseline.ideographic()
$text.style.textBaseline.alphabetic()
```

### $text.style.shadows
A list of Shadows that will be painted underneath the text.

```dart
$text.style.shadows(const [
  Shadow(
    color: Colors.black,
    offset: Offset(10, 10),
    blurRadius: 10,
  ),
  Shadow(
    color: Colors.red,
    offset: Offset(0, -10),
    blurRadius: 100,
  ),
]),
```

### $text.style.shadow
Instead of a list of Shadows this utility receive only one shadow model that will be painted underneath the text.

```dart
$text.style.shadow(
  color: Colors.black,
  offset: Offset(10, 10),
  blurRadius: 10,
),
```

### $text.style.color
The color to use when painting the text.

```dart
$text.style.color(Colors.blueAccent)
$text.style.color.blueAccent()
```

### $text.style.backgroundColor
The color to use as the background for the text.

```dart
$text.style.backgroundColor(Colors.blueAccent)
$text.style.backgroundColor.blueAccent()
```

### $text.style.fontFeatures
A list of `FontFeatures` that affect how the font selects glyphs.

```dart
$text.style.fontFeatures([const FontFeature.tabularFigures()])
```

### $text.style.decoration
The decorations to paint near the text.

```dart
$text.style.decoration.underline()
$text.style.decoration.overline()
$text.style.decoration.lineThrough()
$text.style.decoration.none()
```

### $text.style.decorationStyle
The style in which to paint the text decorations.

```dart
$text.style.decorationStyle.solid()
$text.style.decorationStyle.double()
$text.style.decorationStyle.dotted()
$text.style.decorationStyle.dashed()
$text.style.decorationStyle.wavy()
```

### $text.style.locale
The locale used to select region-specific glyphs.

```dart
$text.style.locale(const Locale('fr', 'FR'))
```

### $text.style.debugLabel
A human-readable description of this text style.

```dart
$text.style.debugLabel('flutter documentation')
```

### $text.style.fontFamilyFallback
The ordered list of font families to fall back on when a glyph cannot be found in a higher priority font family.

```dart
$text.style.fontFamilyFallback(['Roboto', 'Montserrat'])
```

### $text.style.foreground
The paint drawn as a foreground for the text.

```dart
$text.style.foreground(
  Paint()
    ..style = PaintingStyle.stroke
    ..color = Colors.black
    ..strokeWidth = 2,
)
```

### $text.style.background
The paint drawn as a background for the text.

```dart
$text.style.background(
  Paint()
    ..style = PaintingStyle.stroke
    ..color = Colors.black
    ..strokeWidth = 2,
)
```

### $text.style.decorationThickness
The thickness of the decoration stroke as a multiplier of the thickness defined by the font.

```dart
$text.style.decorationThickness(2)
```

### $text.style.decorationColor
The color in which to paint the text decorations.

```dart
$text.style.decorationColor.red()
$text.style.decorationColor(Colors.red)
```

### $text.style.height
The height of this text span, as a multiple of the font size.

```dart
$text.style.height(1.5)
```

## $text.textWidthBasis
Defines how to measure the width of the rendered text.

```dart
$text.textWidthBasis.parent()
$text.textWidthBasis.longestLine()
```

## $text.textHeightBehavior
Defines how to apply `TextStyle.height` over and under text.

```dart
$text.textHeightBehavior(
  const TextHeightBehavior(
    applyHeightToFirstAscent: true,
    applyHeightToLastDescent: true,
    leadingDistribution: TextLeadingDistribution.even,
  ),
)
```


## $text.textDirection
A direction in which text flows

```dart
$text.textDirection.ltr()
$text.textDirection.rtl()
```

## $text.softWrap
Whether the text should break at soft line breaks.

```dart
$text.softWrap.on()
$text.softWrap.off()
```

## $text.directive
We define everything about directives in another [page](https://www.fluttermix.com/docs/guides/directives)
