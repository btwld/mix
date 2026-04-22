# Variants Reference

Variants make a Styler context-aware. Define the base style first, then add only
the values that change.

## Widget State Variants

```dart
final buttonStyle = BoxStyler()
    .color(Colors.blue)
    .paddingX(20)
    .paddingY(12)
    .borderRounded(8)
    .onHovered(.color(Colors.blue.shade700))
    .onPressed(.color(Colors.blue.shade900))
    .onFocused(.borderAll(color: Colors.white, width: 2))
    .onDisabled(.color(Colors.grey));

PressableBox(
  style: buttonStyle,
  enabled: isEnabled,
  onPress: onPress,
  child: label,
);
```

Widget state methods from `widget_state_variant_mixin.dart`:

| Method | Applies when |
|---|---|
| `.onHovered(style)` | hovered |
| `.onPressed(style)` | pressed |
| `.onFocused(style)` | focused |
| `.onDisabled(style)` | disabled |
| `.onEnabled(style)` | not disabled |

Styled widgets automatically track hover and press when their style contains
widget-state variants and no external controller is supplied. Use `Pressable` or
`PressableBox` when the surface needs tap handling, focus/keyboard activation,
disabled behavior, or explicit controller-driven state.

## Theme and Context Variants

```dart
final surfaceStyle = BoxStyler()
    .color(Colors.white)
    .onDark(.color(const Color(0xFF1E1E24)))
    .onLight(.color(Colors.white));
```

Context methods from `variant_style_mixin.dart`:

- Brightness: `.onDark(style)`, `.onLight(style)`
- Breakpoints: `.onBreakpoint(breakpoint, style)`, `.onMobile(style)`,
  `.onTablet(style)`, `.onDesktop(style)`
- Orientation: `.onPortrait(style)`, `.onLandscape(style)`
- Directionality: `.onLtr(style)`, `.onRtl(style)`
- Platform: `.onIos(style)`, `.onAndroid(style)`, `.onMacos(style)`,
  `.onWindows(style)`, `.onLinux(style)`, `.onFuchsia(style)`, `.onWeb(style)`
- Advanced: `.onNot(contextVariant, style)`, `.onBuilder((context) => style)`,
  `.variant(variant, style)`

Responsive example:

```dart
final panelStyle = BoxStyler()
    .width(320)
    .paddingAll(16)
    .onMobile(.width(280).paddingAll(12))
    .onDesktop(.width(520).paddingAll(24));
```

## Custom Context Variants

Use `ContextVariant` when the condition comes from `BuildContext`.

```dart
class CompactModeVariant extends ContextVariant {
  CompactModeVariant()
      : super('compact_mode', (context) {
          return MediaQuery.sizeOf(context).width < 480;
        });
}

final style = BoxStyler()
    .paddingAll(16)
    .variant(CompactModeVariant(), .paddingAll(8));
```

## Named Variants

Use `NamedVariant` for explicitly selected style modes.

```dart
const primary = NamedVariant('primary');

final style = BoxStyler()
    .color(Colors.grey)
    .variant(primary, .color(Colors.blue));

final primaryStyle = style.applyVariants([primary]);
```

## Selected or Custom Widget States

There is no fluent `.onSelected()` helper in the current source. Use
`ContextVariant.widgetState(...)` with a `WidgetStatesController` when you need
selected state.

```dart
final controller = WidgetStatesController();

final style = BoxStyler()
    .color(Colors.grey)
    .variant(
      ContextVariant.widgetState(.selected),
      .color(Colors.blue),
    );

Pressable(
  controller: controller,
  onPress: () {
    controller.update(.selected, !controller.has(.selected));
  },
  child: Box(style: style, child: child),
);
```

Dispose externally owned controllers in stateful widgets.

## Variant Ordering

Keep variants at the end of a chain for readability. Build the base style first,
then attach variants.

```dart
final style = BoxStyler()
    .color(Colors.blue)
    .paddingAll(16)
    .animate(.easeInOut(180.ms))
    .onHovered(.color(Colors.blue.shade700))
    .onPressed(.color(Colors.blue.shade900));
```

## Source Files

- `packages/mix/lib/src/style/mixins/variant_style_mixin.dart`
- `packages/mix/lib/src/style/mixins/widget_state_variant_mixin.dart`
- `packages/mix/lib/src/variants/variant.dart`
- `packages/mix/test/src/variants/variant_mixin_test.dart`
- `packages/mix/test/src/specs/pressable/pressable_widget_test.dart`
