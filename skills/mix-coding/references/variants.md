# Variants Reference

Variants make styles context-aware — they adapt to hover, press, dark mode, and other states automatically. You define what changes; Mix handles when it applies.

## Patterns

### Basic Variant

Add a variant by chaining the variant method. Only specify what changes — Mix merges it with the base style:

```dart
final style = BoxStyler()
    .color(Colors.red)
    .height(100)
    .width(100)
    .borderRounded(10)
    .onHovered(.color(Colors.blue));  // Only color changes on hover
```

### Multiple Variants

Chain multiple variants on the same style:

```dart
final style = BoxStyler()
    .color(Colors.blue)
    .size(100, 100)
    .borderRounded(10)
    .onHovered(.color(Colors.blue.shade700))
    .onPressed(.color(Colors.blue.shade900))
    .onDisabled(.color(Colors.grey));
```

### Composing Styles with Variants

When you override a style that already has variants, the new variant values merge with existing ones:

```dart
final styleA = BoxStyler()
    .color(Colors.red)
    .size(100, 100)
    .onHovered(.color(Colors.blue).width(200));

// styleB inherits hover width=200 but overrides hover color
final styleB = styleA.onHovered(.color(Colors.green));
// Hover result: color=green, width=200
```

### Nesting Variants

Combine variants for compound conditions:

```dart
final hoverStyle = BoxStyler()
    .onDark(.color(Colors.blue))
    .onLight(.color(Colors.green));

final style = BoxStyler()
    .color(Colors.red)
    .size(100, 100)
    .onHovered(hoverStyle);  // Different hover colors per theme
```

### Dark/Light Mode

```dart
final buttonStyle = BoxStyler()
    .height(60)
    .width(60)
    .borderRounded(30)
    .color(Colors.grey.shade200)
    .onDark(.color(Colors.grey.shade800));

final iconStyle = IconStyler()
    .color(Colors.grey.shade800)
    .size(28)
    .icon(Icons.dark_mode)
    .onDark(.icon(Icons.light_mode).color(Colors.yellow));
```

### Responsive Breakpoints

```dart
final style = BoxStyler()
    .width(100)
    .height(100)
    .color(Colors.blue.shade400)
    .onBreakpoint(Breakpoint.maxWidth(575), .color(Colors.green))
    .onMobile(.width(80))
    .onTablet(.width(120))
    .onDesktop(.width(200));
```

### Widget State with Pressable

For hover, press, and focus to work, the widget must be wrapped in a `Pressable` or use `PressableBox`:

```dart
// Using Pressable wrapper
final style = BoxStyler()
    .color(Colors.red)
    .size(100, 100)
    .onPressed(.color(Colors.blue));

Pressable(
  onPress: () => print('tapped'),
  child: Box(style: style),
);

// Or use PressableBox (Box + Pressable combined)
PressableBox(
  style: style,
  onPress: () => print('tapped'),
  child: child,
);
```

### Selected State with Controller

```dart
class MyWidget extends StatefulWidget { ... }

class _MyWidgetState extends State<MyWidget> {
  final controller = WidgetStatesController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final style = BoxStyler()
        .color(Colors.red)
        .size(100, 100)
        .variant(ContextVariant.widgetState(.selected), .color(Colors.blue));

    return Pressable(
      onPress: () {
        final isSelected = controller.has(.selected);
        controller.update(.selected, !isSelected);
      },
      controller: controller,
      child: Box(style: style),
    );
  }
}
```

### Custom Context Variant

Create variants based on any `InheritedWidget` or `BuildContext` condition:

```dart
class MyCustomVariant extends ContextVariant {
  MyCustomVariant()
    : super('my_custom', (context) {
        // Return true when this variant should be active
        return MyInheritedWidget.of(context)?.isActive ?? false;
      });
}

// Usage
final style = BoxStyler()
    .color(Colors.grey)
    .variant(MyCustomVariant(), .color(Colors.blue));
```

### Animating Variants

Add `.animate()` to smoothly transition between variant states:

```dart
final style = BoxStyler()
    .color(Colors.grey.shade200)
    .animate(.easeInOut(600.ms))
    .onDark(.color(Colors.grey.shade800))
    .onHovered(.color(Colors.blue));
```

---

## Built-in Variant Methods

All stylers (`BoxStyler`, `TextStyler`, `IconStyler`, etc.) support these variant methods:

### Widget State Variants

| Method | Description |
|--------|-------------|
| `.onHovered(style)` | When widget is hovered |
| `.onPressed(style)` | When widget is pressed |
| `.onFocused(style)` | When widget is focused |
| `.onDisabled(style)` | When widget is disabled |
| `.onEnabled(style)` | When widget is enabled |

### Theme Variants

| Method | Description |
|--------|-------------|
| `.onDark(style)` | In dark mode |
| `.onLight(style)` | In light mode |

### Orientation Variants

| Method | Description |
|--------|-------------|
| `.onPortrait(style)` | Portrait orientation |
| `.onLandscape(style)` | Landscape orientation |

### Responsive Variants

| Method | Description |
|--------|-------------|
| `.onBreakpoint(Breakpoint, style)` | Custom breakpoint |
| `.onMobile(style)` | Mobile screen size |
| `.onTablet(style)` | Tablet screen size |
| `.onDesktop(style)` | Desktop screen size |

### Direction Variants

| Method | Description |
|--------|-------------|
| `.onLtr(style)` | Left-to-right |
| `.onRtl(style)` | Right-to-left |

### Platform Variants

| Method | Description |
|--------|-------------|
| `.onIos(style)` | iOS platform |
| `.onAndroid(style)` | Android platform |
| `.onMacos(style)` | macOS platform |
| `.onWindows(style)` | Windows platform |
| `.onLinux(style)` | Linux platform |
| `.onFuchsia(style)` | Fuchsia platform |
| `.onWeb(style)` | Web platform |

### Advanced

| Method | Description |
|--------|-------------|
| `.onNot(contextVariant, style)` | When variant is NOT active |
| `.onBuilder((context) => style)` | Custom function-based variant |
| `.variant(ContextVariant, style)` | Apply any custom variant |

---

## Source Files

- `examples/lib/api/context_variants/hovered.dart` — Hover example
- `examples/lib/api/context_variants/pressed.dart` — Press with Pressable
- `examples/lib/api/context_variants/on_dark_light.dart` — Dark/light mode toggle
- `examples/lib/api/context_variants/selected.dart` — Selected state with controller
- `examples/lib/api/context_variants/disabled.dart` — Disabled state
- `examples/lib/api/context_variants/custom_context_variant.dart` — Custom variant
- `examples/lib/api/context_variants/responsive_size.dart` — Responsive breakpoints
- `examples/lib/docs/guides/variants.dart` — Variants guide examples
