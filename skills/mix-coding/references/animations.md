# Animations Reference

Mix provides three animation approaches, from simple to full control:

1. **Implicit** — easiest, auto-animate when state or variant changes
2. **Phase** — multi-step flows triggered by events
3. **Keyframe** — full timeline control with tracks

## Implicit Animations

Add `.animate()` to any style — Mix auto-animates between states when variant conditions change.

### Basic Implicit Animation

```dart
final style = BoxStyler()
    .color(Colors.blue)
    .size(100, 100)
    .animate(.easeInOut(300.ms))
    .onHovered(.color(Colors.red).size(120, 120));
```

### Animation Configs

The `.animate()` method takes an `AnimationConfig`:

| Config | Description |
|--------|-------------|
| `.easeInOut(Duration)` | Ease in and out curve |
| `.ease(Duration)` | Standard ease curve |
| `.linear(Duration)` | Linear interpolation |
| `.spring(Duration)` | Spring physics |
| `.decelerate(Duration)` | Decelerate curve |
| `.bounceIn(Duration)` | Bounce in curve |
| `.bounceOut(Duration)` | Bounce out curve |
| `.elasticIn(Duration)` | Elastic in curve |
| `.elasticOut(Duration)` | Elastic out curve |

Duration uses the `.ms` extension (e.g., `300.ms`, `600.ms`).

### State-Triggered Implicit Animation

When state changes cause style differences, Mix interpolates automatically:

```dart
class Counter extends StatefulWidget { ... }

class _CounterState extends State<Counter> {
  int count = 0;

  @override
  Widget build(BuildContext context) {
    final style = BoxStyler()
        .color(Colors.blue)
        .size(100 + count * 20, 100 + count * 20)
        .borderRounded(10 + count * 5)
        .animate(.spring(600.ms));

    return GestureDetector(
      onTap: () => setState(() => count++),
      child: Box(style: style),
    );
  }
}
```

### Variant-Triggered Implicit Animation

```dart
final style = BoxStyler()
    .color(Colors.blue)
    .size(100, 100)
    .borderRounded(10)
    .animate(.easeInOut(200.ms))
    .onHovered(
      .color(Colors.deepPurple)
          .size(120, 120)
          .borderRounded(20),
    );
```

---

## Phase Animations

Multi-step animations triggered by events. Each phase runs in sequence.

### Basic Phase Animation

```dart
class CompressExample extends StatefulWidget { ... }

class _CompressExampleState extends State<CompressExample> {
  final controller = PhaseAnimationController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final style = BoxStyler()
        .color(Colors.blue)
        .size(100, 100)
        .borderRounded(12);

    return GestureDetector(
      onTap: () => controller.forward(),
      child: PhaseAnimationBuilder(
        controller: controller,
        phases: [
          // Phase 1: Compress
          PhaseConfig(
            style.size(80, 80).borderRounded(20),
            duration: 150.ms,
            curve: .easeIn,
          ),
          // Phase 2: Expand
          PhaseConfig(
            style.size(120, 120),
            duration: 300.ms,
            curve: .bounceOut,
          ),
          // Phase 3: Return to original
          PhaseConfig(
            style,
            duration: 200.ms,
            curve: .easeOut,
          ),
        ],
        builder: (context, phaseStyle) {
          return Box(style: phaseStyle);
        },
      ),
    );
  }
}
```

### PhaseConfig

| Parameter | Type | Description |
|-----------|------|-------------|
| `style` | Styler | The target style for this phase |
| `duration` | `Duration` | How long this phase takes |
| `curve` | `Curve` | Animation curve for this phase |

### PhaseAnimationController

| Method | Description |
|--------|-------------|
| `.forward()` | Start/restart the animation sequence |
| `.dispose()` | Clean up resources |

---

## Keyframe Animations

Full timeline control with multiple tracks animating different properties.

### Basic Keyframe Animation

```dart
class HeartAnimation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final baseStyle = IconStyler()
        .icon(Icons.favorite)
        .size(40)
        .color(Colors.red);

    return KeyframeAnimationBuilder(
      duration: 1200.ms,
      repeat: true,
      keyframes: {
        // Scale track
        KeyframeTrack<double>(
          property: KeyframeProperty.iconSize,
          keyframes: [
            Keyframe(0.0, 40),     // Start at size 40
            Keyframe(0.3, 56),     // Grow to 56 at 30%
            Keyframe(0.5, 40),     // Return to 40 at 50%
            Keyframe(0.7, 52),     // Second beat at 70%
            Keyframe(1.0, 40),     // Return to 40
          ],
        ),
        // Color track
        KeyframeTrack<Color>(
          property: KeyframeProperty.iconColor,
          keyframes: [
            Keyframe(0.0, Colors.red),
            Keyframe(0.3, Colors.red.shade900),
            Keyframe(0.5, Colors.red),
            Keyframe(0.7, Colors.red.shade800),
            Keyframe(1.0, Colors.red),
          ],
        ),
      },
      builder: (context, keyframeStyle) {
        return StyledIcon(style: baseStyle.merge(keyframeStyle));
      },
    );
  }
}
```

### Keyframe Toggle (e.g., Switch)

```dart
KeyframeAnimationBuilder(
  duration: 400.ms,
  playing: isOn,          // Animate forward when true, reverse when false
  keyframes: {
    KeyframeTrack<double>(
      property: KeyframeProperty.width,
      keyframes: [
        Keyframe(0.0, 24),
        Keyframe(0.5, 40),   // Stretch in the middle
        Keyframe(1.0, 24),
      ],
    ),
    KeyframeTrack<double>(
      property: KeyframeProperty.translateX,
      keyframes: [
        Keyframe(0.0, 0),
        Keyframe(1.0, 20),   // Slide to the right
      ],
    ),
  },
  builder: (context, style) => Box(style: baseStyle.merge(style)),
);
```

### Looping Animation

```dart
KeyframeAnimationBuilder(
  duration: 2000.ms,
  repeat: true,           // Loop forever
  keyframes: { ... },
  builder: (context, style) => widget,
);
```

### KeyframeAnimationBuilder

| Parameter | Type | Description |
|-----------|------|-------------|
| `duration` | `Duration` | Total animation duration |
| `keyframes` | `Set<KeyframeTrack>` | Set of animation tracks |
| `builder` | `(context, style) => Widget` | Build widget with animated style |
| `repeat` | `bool` | Loop animation (default: false) |
| `playing` | `bool?` | Control play/reverse (null = auto-play) |
| `curve` | `Curve?` | Overall animation curve |

### Widget State Animation (Simplest)

For simple hover/press animations without explicit animation builders:

```dart
final style = BoxStyler()
    .size(100, 100)
    .color(Colors.blue)
    .borderRounded(8)
    .animate(.spring(300.ms))
    .onHovered(.size(110, 110).color(Colors.blue.shade700));
```

---

## Source Files

- `examples/lib/api/animation/implicit.anim.counter.dart` — State-triggered growth
- `examples/lib/api/animation/implicit.curved.hover.dart` — Hover scale animation
- `examples/lib/api/animation/keyframe.heart.dart` — Multi-track heart animation
- `examples/lib/api/animation/keyframe.switch.dart` — Toggle switch keyframes
- `examples/lib/api/animation/phase.compress.dart` — Tap compress/expand
- `examples/lib/api/animation/phase.arrow.dart` — Multi-phase arrow animation
- `examples/lib/api/animation/widget_state_animation.dart` — Simple widget state animation
- `examples/lib/docs/guides/animations/implicit_state_counter.dart` — State counter
- `examples/lib/docs/guides/animations/keyframe_loop.dart` — Looping keyframe
- `examples/lib/docs/guides/animations/phase_tap_compress.dart` — Phase tap animation
