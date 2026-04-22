# Widgets Reference

Mix widgets pair with Stylers. Choose the widget first, then build a named style for it.

## Selection Guide

| Need | Widget | Styler |
|---|---|---|
| Styled surface, card, background, constraints | `Box` | `BoxStyler` |
| Dynamic flex direction | `FlexBox` | `FlexBoxStyler` |
| Horizontal flex layout | `RowBox` | `FlexBoxStyler` |
| Vertical flex layout | `ColumnBox` | `FlexBoxStyler` |
| Stack/overlay layout | `StackBox` | `StackBoxStyler` |
| Styled text | `StyledText` | `TextStyler` |
| Styled icon | `StyledIcon` | `IconStyler` |
| Styled image | `StyledImage` | `ImageStyler` |
| Generic interaction state wrapper | `Pressable` | child keeps its own style |
| Interactive styled box | `PressableBox` | `BoxStyler` |

## Box

`Box` is the Mix surface widget. Use it instead of `Container` when the user wants Mix styling.

```dart
final cardStyle = BoxStyler()
    .color(Colors.white)
    .paddingAll(16)
    .borderRounded(12);

Box(style: cardStyle, child: content);
```

Constructor shape:

```dart
Box({
  BoxStyler style = const BoxStyler.create(),
  StyleSpec<BoxSpec>? styleSpec,
  Widget? child,
});
```

## FlexBox, RowBox, ColumnBox

`FlexBox` combines flex layout with box styling. Use `RowBox` and `ColumnBox`
when the direction is fixed.

```dart
final rowStyle = FlexBoxStyler()
    .spacing(8)
    .crossAxisAlignment(.center)
    .paddingAll(12)
    .borderRounded(8)
    .color(Colors.blue.shade50);

RowBox(
  style: rowStyle,
  children: [
    StyledIcon(icon: Icons.info, style: IconStyler.color(Colors.blue)),
    StyledText('Details', style: TextStyler.fontWeight(.bold)),
  ],
);
```

Use `FlexBox` directly when direction itself is part of the style:

```dart
FlexBox(
  style: FlexBoxStyler()
      .direction(.vertical)
      .spacing(12)
      .paddingAll(16),
  children: children,
);
```

## StackBox

Use `StackBox` for overlay layouts that also need Mix box styling.

```dart
final stackStyle = StackBoxStyler()
    .stackAlignment(.center)
    .color(Colors.black)
    .borderRounded(12);

StackBox(
  style: stackStyle,
  children: [
    StyledImage(image: imageProvider, style: imageStyle),
    StyledText('Live', style: badgeTextStyle),
  ],
);
```

## StyledText

```dart
final textStyle = TextStyler()
    .fontSize(18)
    .fontWeight(.w700)
    .color(Colors.black);

StyledText('Hello Mix', style: textStyle);
```

`TextStyler.call(String)` creates `StyledText`:

```dart
final caption = TextStyler.fontSize(12).color(Colors.grey);
caption('Caption');
```

## StyledIcon

```dart
final iconStyle = IconStyler()
    .size(24)
    .color(Colors.amber);

StyledIcon(icon: Icons.star, style: iconStyle);
```

`IconStyler.call(...)` creates `StyledIcon`:

```dart
IconStyler.size(20).color(Colors.green)(icon: Icons.check);
```

## StyledImage

```dart
final imageStyle = ImageStyler()
    .width(160)
    .height(120)
    .fit(BoxFit.cover);

StyledImage(
  image: const NetworkImage('https://example.com/photo.jpg'),
  style: imageStyle,
);
```

`StyledImage` needs an `ImageProvider` either on the widget or inside `ImageStyler.image(...)`.

## Pressable and PressableBox

Use `PressableBox` when the interactive target is a styled box. Use `Pressable`
when wrapping another widget.

```dart
final buttonStyle = BoxStyler()
    .color(Colors.blue)
    .paddingX(20)
    .paddingY(12)
    .borderRounded(8)
    .onHovered(.color(Colors.blue.shade700))
    .onPressed(.color(Colors.blue.shade900))
    .onDisabled(.color(Colors.grey));

PressableBox(
  style: buttonStyle,
  enabled: isEnabled,
  onPress: onPress,
  child: StyledText('Continue', style: TextStyler.color(Colors.white)),
);
```

`PressableBox` manages hover, press, focus, disabled, and keyboard activation
for styled boxes. Use `Pressable` when wrapping another widget or when you need
an optional external `WidgetStatesController`; `PressableBox` does not expose a
controller parameter.

## Source Files

- `packages/mix/lib/src/specs/box/box_widget.dart`
- `packages/mix/lib/src/specs/flexbox/flexbox_widget.dart`
- `packages/mix/lib/src/specs/stackbox/stackbox_widget.dart`
- `packages/mix/lib/src/specs/text/text_widget.dart`
- `packages/mix/lib/src/specs/icon/icon_widget.dart`
- `packages/mix/lib/src/specs/image/image_widget.dart`
- `packages/mix/lib/src/specs/pressable/pressable_widget.dart`
