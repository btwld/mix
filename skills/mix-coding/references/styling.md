# Styling Reference

## Patterns

### Creating a Style

```dart
// Start from constructor
final style = BoxStyler()
    .color(Colors.blue)
    .size(100, 100)
    .borderRounded(12);

// Start from factory (equivalent)
final style = BoxStyler.color(Colors.blue)
    .size(100, 100)
    .borderRounded(12);
```

### Composing Styles

Build new styles on top of existing ones. Later values override earlier ones:

```dart
final base = BoxStyler()
    .paddingX(16)
    .paddingY(8)
    .borderRounded(8)
    .color(Colors.black);

final solid = base.color(Colors.blue);        // Override color only
final soft = base.color(Colors.blue.shade100); // Different override
```

### Merging Styles

Use `.merge()` to combine two stylers:

```dart
final layout = BoxStyler().paddingAll(16).size(200, 200);
final visual = BoxStyler().color(Colors.blue).borderRounded(12);
final combined = layout.merge(visual);
```

### Applying to Widgets

```dart
// Explicit style parameter
Box(style: style, child: child);

// Callable shorthand
final box = BoxStyler().color(Colors.blue).size(100, 100);
box(child: child);  // Creates a Box widget
```

### Widget Modifiers (wrap)

Add widget-level behavior without nesting widgets:

```dart
final style = BoxStyler()
    .color(Colors.blue)
    .wrap(
      .new().defaultTextStyle(
        style: TextStyleMix().color(Colors.white).fontWeight(.bold),
      ),
    );
```

---

## BoxStyler API

### Color & Background

| Method | Description |
|--------|-------------|
| `.color(Color)` | Background color |
| `.linearGradient({colors, begin, end, stops, tileMode})` | Linear gradient background |
| `.radialGradient({center, radius, colors, stops, tileMode})` | Radial gradient background |
| `.sweepGradient({center, startAngle, endAngle, colors, stops, tileMode})` | Sweep gradient background |
| `.backgroundImage(ImageProvider, {fit, alignment, repeat})` | Background image |
| `.backgroundImageUrl(String, {fit, alignment, repeat})` | Background image from URL |
| `.backgroundImageAsset(String, {fit, alignment, repeat})` | Background image from asset |

### Sizing & Constraints

| Method | Description |
|--------|-------------|
| `.width(double)` | Fixed width |
| `.height(double)` | Fixed height |
| `.size(double w, double h)` | Fixed width and height |
| `.minWidth(double)` | Minimum width |
| `.maxWidth(double)` | Maximum width |
| `.minHeight(double)` | Minimum height |
| `.maxHeight(double)` | Maximum height |

### Spacing

| Method | Description |
|--------|-------------|
| `.paddingAll(double)` | Padding on all sides |
| `.paddingX(double)` | Horizontal padding (left + right) |
| `.paddingY(double)` | Vertical padding (top + bottom) |
| `.paddingTop(double)` | Top padding |
| `.paddingBottom(double)` | Bottom padding |
| `.paddingLeft(double)` | Left padding |
| `.paddingRight(double)` | Right padding |
| `.paddingStart(double)` | Start padding (RTL-aware) |
| `.paddingEnd(double)` | End padding (RTL-aware) |
| `.paddingOnly({top, bottom, left, right})` | Individual padding |
| `.marginAll(double)` | Margin on all sides |
| `.marginX(double)` | Horizontal margin |
| `.marginY(double)` | Vertical margin |
| `.marginTop(double)` / `.marginBottom(double)` / `.marginLeft(double)` / `.marginRight(double)` | Directional margin |
| `.marginStart(double)` / `.marginEnd(double)` | RTL-aware margin |

### Border

| Method | Description |
|--------|-------------|
| `.borderAll({color, width, style, strokeAlign})` | Border on all sides |
| `.borderTop({color, width, style, strokeAlign})` | Top border |
| `.borderBottom({color, width, style, strokeAlign})` | Bottom border |
| `.borderLeft({color, width, style, strokeAlign})` | Left border |
| `.borderRight({color, width, style, strokeAlign})` | Right border |
| `.borderStart({color, width, style, strokeAlign})` | Start border (RTL-aware) |
| `.borderEnd({color, width, style, strokeAlign})` | End border (RTL-aware) |
| `.borderVertical({color, width, style, strokeAlign})` | Top + bottom borders |
| `.borderHorizontal({color, width, style, strokeAlign})` | Left + right borders |

### Border Radius

| Method | Description |
|--------|-------------|
| `.borderRounded(double)` | Uniform circular radius |
| `.borderRadiusAll(Radius)` | Uniform custom radius |
| `.borderRoundedTop(double)` | Top corners |
| `.borderRoundedBottom(double)` | Bottom corners |
| `.borderRoundedLeft(double)` | Left corners |
| `.borderRoundedRight(double)` | Right corners |
| `.borderRoundedTopLeft(double)` / `.borderRoundedTopRight(double)` | Individual corners |
| `.borderRoundedBottomLeft(double)` / `.borderRoundedBottomRight(double)` | Individual corners |

### Shadows

| Method | Description |
|--------|-------------|
| `.shadowOnly({color, offset, blurRadius, spreadRadius})` | Single box shadow |
| `.elevation(ElevationShadow)` | Material elevation shadow |

### Shape

| Method | Description |
|--------|-------------|
| `.shapeCircle({side})` | Circular shape |
| `.shapeStadium({side})` | Stadium/pill shape |
| `.shapeRoundedRectangle({side, borderRadius})` | Rounded rectangle |
| `.shapeBeveledRectangle({side, borderRadius})` | Beveled rectangle |
| `.shapeSuperellipse({side, borderRadius})` | Superellipse shape |

### Layout

| Method | Description |
|--------|-------------|
| `.alignment(AlignmentGeometry)` | Child alignment |
| `.clipBehavior(Clip)` | Clip behavior |

### Transform

| Method | Description |
|--------|-------------|
| `.rotate(double angle, {alignment})` | Rotation |
| `.scale(double, {alignment})` | Scale |
| `.translate(double x, double y)` | Translation |
| `.skew(double skewX, double skewY)` | Skew |

---

## TextStyler API

### Typography

| Method | Description |
|--------|-------------|
| `.fontSize(double)` | Font size |
| `.fontWeight(FontWeight)` | Font weight (e.g., `.bold`, `.w700`) |
| `.fontStyle(FontStyle)` | Italic/normal |
| `.fontFamily(String)` | Font family |
| `.letterSpacing(double)` | Letter spacing |
| `.wordSpacing(double)` | Word spacing |
| `.height(double)` | Line height multiplier |
| `.color(Color)` | Text color |
| `.backgroundColor(Color)` | Text background color |

### Text Layout

| Method | Description |
|--------|-------------|
| `.textAlign(TextAlign)` | Alignment (`.center`, `.left`, `.right`) |
| `.maxLines(int)` | Maximum line count |
| `.overflow(TextOverflow)` | Overflow behavior |
| `.softWrap(bool)` | Enable/disable soft wrapping |

### Text Decoration

| Method | Description |
|--------|-------------|
| `.decoration(TextDecoration)` | Underline, strikethrough, etc. |
| `.decorationColor(Color)` | Decoration color |
| `.decorationStyle(TextDecorationStyle)` | Decoration style |

### Text Directives (transforms)

| Method | Description |
|--------|-------------|
| `.uppercase()` | ALL CAPS |
| `.lowercase()` | all lowercase |
| `.capitalize()` | First letter uppercase |
| `.titlecase()` | Title Case |
| `.sentencecase()` | Sentence case |

### Using TextStyler

```dart
final style = TextStyler()
    .fontSize(20)
    .fontWeight(.w700)
    .color(Colors.red)
    .titlecase();

StyledText('hello world', style: style);
// Or shorthand:
style('hello world');
```

---

## IconStyler API

| Method | Description |
|--------|-------------|
| `.icon(IconData)` | Icon data |
| `.size(double)` | Icon size |
| `.color(Color)` | Icon color |
| `.weight(double)` | Icon weight |
| `.fill(double)` | Icon fill |
| `.opacity(double)` | Icon opacity |
| `.shadows(List<ShadowMix>)` | Icon shadows |

### Using IconStyler

```dart
final style = IconStyler.size(30).color(Colors.blueAccent);
StyledIcon(icon: Icons.star, style: style);
// Or shorthand:
style(icon: Icons.star);
```

---

## Source Files

For real implementations, read these example files:
- `examples/lib/api/widgets/box/simple_box.dart` — Basic styled box
- `examples/lib/api/widgets/box/gradient_box.dart` — Gradient + shadow
- `examples/lib/api/widgets/text/styled_text.dart` — Styled text with directives
- `examples/lib/api/widgets/icon/styled_icon.dart` — Styled icon
- `examples/lib/docs/guides/styling.dart` — Styling guide examples
