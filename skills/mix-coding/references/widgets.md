# Widgets Reference

Mix provides styled widget equivalents for common Flutter widgets. Each Mix widget takes a `style` parameter built with its corresponding Styler.

## Widget Selection Guide

| Need | Use | Styler |
|------|-----|--------|
| Container/card/background | `Box` | `BoxStyler` |
| Horizontal layout | `RowBox` (alias: `HBox`) | `FlexBoxStyler` |
| Vertical layout | `ColumnBox` (alias: `VBox`) | `FlexBoxStyler` |
| Stack/overlay | `ZBox` | `FlexBoxStyler` |
| Text | `StyledText` | `TextStyler` |
| Icon | `StyledIcon` | `IconStyler` |
| Image | `StyledImage` | `ImageStyler` |
| Tappable wrapper | `Pressable` | (wraps child styles) |
| Tappable box | `PressableBox` | `BoxStyler` |

---

## Box

Replacement for Flutter's `Container`. Supports color, padding, margin, borders, shadows, gradients, and constraints.

```dart
final style = BoxStyler()
    .color(Colors.white)
    .paddingAll(16)
    .borderRounded(12)
    .shadowOnly(color: Colors.black12, blurRadius: 8);

Box(style: style, child: content);
```

### Box Constructor

| Parameter | Type | Description |
|-----------|------|-------------|
| `style` | `BoxStyler` | The box style |
| `child` | `Widget?` | Child widget |
| `inherit` | `bool` | Inherit parent style (default: false) |

---

## FlexBox (RowBox, ColumnBox, ZBox)

`FlexBox` combines Flutter's `Flex` + `Container`. Use the directional aliases:

### RowBox / HBox — Horizontal Layout

```dart
final style = FlexBoxStyler()
    .crossAxisAlignment(.center)
    .spacing(8);

RowBox(
  style: style,
  children: [
    StyledIcon(icon: Icons.star, style: iconStyle),
    StyledText('Label', style: textStyle),
  ],
);
```

### ColumnBox / VBox — Vertical Layout

```dart
final style = FlexBoxStyler()
    .crossAxisAlignment(.start)
    .spacing(16)
    .marginAll(16);

ColumnBox(
  style: style,
  children: [
    StyledText('Title', style: titleStyle),
    StyledText('Subtitle', style: subtitleStyle),
    Box(style: cardStyle, child: content),
  ],
);
```

### ZBox — Stack/Overlay Layout

```dart
ZBox(
  style: FlexBoxStyler().alignment(.center),
  children: [
    Box(style: backgroundStyle),
    Box(style: foregroundStyle),
  ],
);
```

### FlexBoxStyler API

All `BoxStyler` methods are available plus:

| Method | Description |
|--------|-------------|
| `.direction(Axis)` | Main axis direction |
| `.mainAxisAlignment(MainAxisAlignment)` | Main axis alignment |
| `.crossAxisAlignment(CrossAxisAlignment)` | Cross axis alignment |
| `.mainAxisSize(MainAxisSize)` | Main axis size |
| `.spacing(double)` | Gap between children |
| `.verticalDirection(VerticalDirection)` | Vertical ordering |
| `.textDirection(TextDirection)` | Text direction |
| `.textBaseline(TextBaseline)` | Text baseline |
| `.clipBehavior(Clip)` | Clip behavior |

### FlexBox Constructor

| Parameter | Type | Description |
|-----------|------|-------------|
| `style` | `FlexBoxStyler` | The flex box style |
| `children` | `List<Widget>` | Child widgets |
| `direction` | `Axis` | Main axis (RowBox=horizontal, ColumnBox=vertical) |
| `inherit` | `bool` | Inherit parent style (default: false) |

---

## StyledText

Replacement for Flutter's `Text` widget with Mix styling.

```dart
final style = TextStyler()
    .fontSize(18)
    .fontWeight(.bold)
    .color(Colors.black)
    .letterSpacing(0.5);

StyledText('Hello World', style: style);
```

### StyledText Constructor

| Parameter | Type | Description |
|-----------|------|-------------|
| `text` | `String` | The text content (positional) |
| `style` | `TextStyler` | The text style |
| `inherit` | `bool` | Inherit parent style (default: false) |

---

## StyledIcon

Replacement for Flutter's `Icon` widget with Mix styling.

```dart
final style = IconStyler()
    .size(30)
    .color(Colors.blueAccent);

StyledIcon(icon: Icons.star, style: style);
```

### StyledIcon Constructor

| Parameter | Type | Description |
|-----------|------|-------------|
| `icon` | `IconData?` | The icon data |
| `style` | `IconStyler` | The icon style |
| `inherit` | `bool` | Inherit parent style (default: false) |

---

## StyledImage

Styled image widget.

```dart
final style = ImageStyler()
    .width(200)
    .height(150)
    .fit(BoxFit.cover)
    .borderRounded(8);

StyledImage(
  image: NetworkImage('https://example.com/photo.jpg'),
  style: style,
);
```

### StyledImage Constructor

| Parameter | Type | Description |
|-----------|------|-------------|
| `image` | `ImageProvider` | The image source |
| `style` | `ImageStyler` | The image style |
| `inherit` | `bool` | Inherit parent style (default: false) |

---

## Pressable & PressableBox

Makes widgets interactive (tappable) and enables hover/press/focus/disabled variants.

### Pressable — Generic Wrapper

Wraps any widget to enable interaction state variants:

```dart
final style = BoxStyler()
    .color(Colors.blue)
    .size(100, 100)
    .onHovered(.color(Colors.blue.shade700))
    .onPressed(.color(Colors.blue.shade900));

Pressable(
  onPress: () => print('tapped'),
  child: Box(style: style),
);
```

### PressableBox — Box + Pressable Combined

Shorthand for a pressable Box:

```dart
PressableBox(
  style: BoxStyler()
      .color(Colors.blue)
      .paddingAll(16)
      .borderRounded(8)
      .onHovered(.color(Colors.blue.shade700))
      .onPressed(.color(Colors.blue.shade900)),
  onPress: () => print('tapped'),
  child: StyledText('Click me', style: textStyle),
);
```

### Pressable Constructor

| Parameter | Type | Description |
|-----------|------|-------------|
| `onPress` | `VoidCallback?` | Tap callback |
| `onLongPress` | `VoidCallback?` | Long press callback |
| `enabled` | `bool` | Enable/disable (default: true) |
| `controller` | `WidgetStatesController?` | External state controller |
| `child` | `Widget` | Child widget |

### PressableBox Constructor

Same as Pressable, plus:

| Parameter | Type | Description |
|-----------|------|-------------|
| `style` | `BoxStyler` | The box style |

---

## Callable Stylers (Shorthand)

Any styler can be called directly to create its widget:

```dart
final box = BoxStyler().color(Colors.blue).size(100, 100);
box();                    // Creates Box()
box(child: text);         // Creates Box(child: text)

final text = TextStyler().fontSize(18).color(Colors.black);
text('Hello');            // Creates StyledText('Hello')

final icon = IconStyler().size(24).color(Colors.red);
icon(icon: Icons.star);   // Creates StyledIcon()
```

---

## Source Files

- `examples/lib/docs/widgets/box.dart` — Box examples
- `examples/lib/docs/widgets/flexbox.dart` — FlexBox layout examples
- `examples/lib/docs/widgets/pressable.dart` — Pressable interaction examples
- `examples/lib/docs/widgets/icon.dart` — Icon examples
- `examples/lib/docs/widgets/image.dart` — Image examples
- `examples/lib/api/widgets/box/simple_box.dart` — Basic Box
- `examples/lib/api/widgets/box/gradient_box.dart` — Gradient Box
