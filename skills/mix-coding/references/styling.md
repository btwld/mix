# Styling Reference

Use Stylers to describe visual intent, then pass them to Mix widgets. Keep app
code on `BoxStyler`, `TextStyler`, `IconStyler`, `ImageStyler`,
`FlexBoxStyler`, and `StackBoxStyler`; do not construct Specs directly.

## Basic Box Styling

```dart
final cardStyle = BoxStyler()
    .color(Colors.white)
    .paddingAll(16)
    .borderRounded(12)
    .shadow(
      .color(Colors.black.withValues(alpha: 0.12))
          .offset(y: 4)
          .blurRadius(12),
    );

Box(style: cardStyle, child: child);
```

Factory constructors are available for many first properties:

```dart
final badgeStyle = BoxStyler.color(Colors.green)
    .paddingX(10)
    .paddingY(4)
    .shapeStadium();
```

## Composition

Stylers are immutable. Chain methods or merge smaller Stylers.

```dart
final baseCard = BoxStyler()
    .paddingAll(16)
    .borderRounded(12);

final elevated = BoxStyler().shadow(
  .color(Colors.black26).offset(y: 6).blurRadius(16),
);

final selectedCard = baseCard
    .merge(elevated)
    .color(Colors.blue.shade50);
```

Use variant styles to override only what changes:

```dart
final buttonStyle = BoxStyler()
    .color(Colors.blue)
    .paddingX(20)
    .paddingY(12)
    .borderRounded(8)
    .onHovered(.color(Colors.blue.shade700));
```

## BoxStyler Surface

Common methods from `packages/mix/lib/src/specs/box/box_style.dart` and mixins:

- Color and decoration: `.color(...)`, `.gradient(...)`, `.linearGradient(...)`,
  `.radialGradient(...)`, `.sweepGradient(...)`, `.image(...)`,
  `.backgroundImage(...)`, `.backgroundImageUrl(...)`,
  `.backgroundImageAsset(...)`
- Spacing: `.paddingAll(...)`, `.paddingX(...)`, `.paddingY(...)`,
  `.paddingOnly(...)`, `.marginAll(...)`, `.marginX(...)`, `.marginY(...)`,
  `.marginOnly(...)`
- Constraints: `.width(...)`, `.height(...)`, `.size(width, height)`,
  `.minWidth(...)`, `.maxWidth(...)`, `.minHeight(...)`, `.maxHeight(...)`
- Border: `.border(...)`, `.borderAll(...)`, `.borderTop(...)`,
  `.borderBottom(...)`, `.borderLeft(...)`, `.borderRight(...)`,
  `.borderHorizontal(...)`, `.borderVertical(...)`
- Radius: `.borderRadius(...)`, `.borderRounded(...)`,
  `.borderRoundedTop(...)`, `.borderRoundedBottom(...)`,
  `.borderRoundedLeft(...)`, `.borderRoundedRight(...)`
- Shadows: `.shadow(.color(...).blurRadius(...))`, `.shadow(BoxShadowMix(...))`,
  `.shadows([...])`, `.boxShadows([...])`, `.shadowOnly(...)`,
  `.elevation(...)`, `.boxElevation(...)`
- Shape: `.shape(...)`, `.shapeCircle(...)`, `.shapeStadium(...)`,
  `.shapeRoundedRectangle(...)`, `.shapeSuperellipse(...)`
- Transform: `.scale(value)`, `.rotate(radians)`, `.translate(x, y, [z])`,
  `.skew(x, y)`
- Layout/modifiers: `.alignment(...)`, `.clipBehavior(...)`, `.wrap(...)`,
  `.modifier(...)`

For generated examples, prefer typed dot shorthand for one-off shadows:
`.shadow(.color(...).offset(y: ...).blurRadius(...))`. Use `.shadowOnly(...)`
only when explicitly showing the named-argument convenience fallback. Never call
`.shadow(color: ...)`; `.shadow(...)` takes a `BoxShadowMix`.

For simple named borders, use helpers such as
`.borderAll(color: ..., width: ...)`, `.borderTop(...)`, or `.borderBottom(...)`.
Never call `.border(color: ...)`; `.border(...)` takes a `BoxBorderMix`.

Transform helpers use positional arguments from `transform_style_mixin.dart`;
for a hover lift use `.translate(0, -1)`, not `.translate(y: -1)` or
`.translateY(...)`.

```dart
final style = BoxStyler()
    .shadow(.color(Colors.black26).offset(y: 4).blurRadius(8))
    .boxShadows([
      BoxShadowMix.color(Colors.black12).offset(y: 6).blurRadius(12),
    ]);
```

## TextStyler

`TextStyler` styles `StyledText`.

```dart
final titleStyle = TextStyler()
    .fontSize(22)
    .fontWeight(.bold)
    .color(Colors.black)
    .letterSpacing(0.2);

StyledText('Revenue', style: titleStyle);
```

Common methods:

- Typography: `.fontSize(...)`, `.fontWeight(...)`, `.fontStyle(...)`,
  `.fontFamily(...)`, `.fontFamilyFallback(...)`, `.letterSpacing(...)`,
  `.wordSpacing(...)`, `.height(...)`
- Color: `.color(...)`, `.backgroundColor(...)`, `.selectionColor(...)`
- Layout: `.textAlign(...)`, `.maxLines(...)`, `.overflow(...)`,
  `.softWrap(...)`, `.textDirection(...)`
- Decoration: `.decoration(...)`, `.decorationColor(...)`,
  `.decorationStyle(...)`, `.decorationThickness(...)`
- Text transforms: `.uppercase()`, `.lowercase()`, `.capitalize()`,
  `.titlecase()`, `.sentencecase()`
- Shadows: `.shadow(...)`, `.shadows(...)`

Callable shorthand:

```dart
final label = TextStyler.fontSize(14).color(Colors.grey.shade700);

label('Updated today');
```

## IconStyler

```dart
final iconStyle = IconStyler()
    .icon(Icons.check_circle)
    .size(20)
    .color(Colors.green);

StyledIcon(style: iconStyle);
```

Common methods:
`.icon(...)`, `.size(...)`, `.color(...)`, `.weight(...)`, `.grade(...)`,
`.opticalSize(...)`, `.fill(...)`, `.opacity(...)`, `.shadow(...)`,
`.shadows(...)`.

## ImageStyler

```dart
final imageStyle = ImageStyler()
    .width(96)
    .height(96)
    .fit(BoxFit.cover)
    .alignment(.center);

StyledImage(
  image: const NetworkImage('https://example.com/avatar.png'),
  style: imageStyle,
);
```

Common methods:
`.image(...)`, `.width(...)`, `.height(...)`, `.color(...)`, `.fit(...)`,
`.alignment(...)`, `.repeat(...)`, `.filterQuality(...)`,
`.colorBlendMode(...)`.

## Widget Modifiers

Prefer Mix style methods to extra Flutter wrapper widgets when Mix provides the
behavior. Use `.wrap(...)` or `.modifier(...)` for widget-level behavior.

```dart
final style = BoxStyler()
    .color(Colors.blue)
    .wrap(.new().opacity(0.92));
```

## Source Files

- `packages/mix/lib/src/specs/box/box_style.dart`
- `packages/mix/lib/src/specs/text/text_style.dart`
- `packages/mix/lib/src/specs/icon/icon_style.dart`
- `packages/mix/lib/src/specs/image/image_style.dart`
- `packages/mix/lib/src/style/mixins/spacing_style_mixin.dart`
- `packages/mix/lib/src/style/mixins/decoration_style_mixin.dart`
- `packages/mix/lib/src/style/mixins/shadow_style_mixin.dart`
- `packages/mix/lib/src/style/mixins/text_style_mixin.dart`
