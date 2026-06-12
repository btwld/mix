# Animations

Three animation systems in Mix, from simple to full control.

## Implicit Animations

Simplest approach. Call `.animate()` on any Styler — Mix interpolates between old and new values automatically when state or variants change.

**When to use:** Simple hover/press effects, state transitions, variant-driven changes.

### State-Triggered

```dart
class ScaleAnimation extends StatefulWidget {
  @override
  State<ScaleAnimation> createState() => _ScaleAnimationState();
}

class _ScaleAnimationState extends State<ScaleAnimation> {
  bool appear = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() => appear = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    final style = BoxStyler()
        .color(Colors.black)
        .height(100)
        .width(100)
        .borderRounded(10)
        .scale(appear ? 1 : 0.1)
        .animate(.easeInOut(1.s));

    return Box(style: style);
  }
}
```

### Variant-Triggered

```dart
final style = BoxStyler()
    .color(Colors.black)
    .height(100)
    .width(100)
    .borderRounded(10)
    .scale(1)
    .onHovered(
      BoxStyler()
        .color(Colors.blue)
        .scale(1.5),
    )
    .animate(.spring(800.ms));
```

### AnimationConfig Options

`AnimationConfig` is a sealed class with curve-based factories and spring helpers:

| Factory | Signature Notes |
|---------|-----------------|
| `.curve(duration:, curve:, delay:, onEnd:)` | Custom `CurveAnimationConfig` |
| `.linear(duration)` | Linear curve |
| `.ease(duration)` / `.easeIn(duration)` / `.easeOut(duration)` / `.easeInOut(duration)` | Common Flutter curves |
| `.decelerate(duration)` | Decelerate curve |
| `.spring(duration, bounce:, onEnd:)` | Duration-based spring physics |
| `.springWithDampingRatio(mass:, stiffness:, dampingRatio:, onEnd:)` | Physics spring without an explicit duration |

For phase animations, `configBuilder` must return `CurveAnimationConfig`; use `CurveAnimationConfig.springWithDampingRatio(duration, ratio: ...)` when a duration is required.

Duration extensions: `.ms` (milliseconds), `.s` (seconds). Example: `300.ms`, `1.s`.

## Phase Animations

Multi-step sequences that progress through defined phases, then return to initial.

**When to use:** State machines, progress indicators, sequential micro-interactions.

```dart
enum AnimationPhases { initial, compress, expanded }

final style = BoxStyler()
    .color(Colors.deepPurple)
    .height(100)
    .width(100)
    .borderRounded(40)
    .phaseAnimation(
      trigger: _isExpanded,  // Listenable; each notification starts one run
      phases: AnimationPhases.values,
      styleBuilder: (phase, style) => switch (phase) {
        .initial => style.scale(1),
        .compress => style.scale(0.75).color(Colors.red.shade800),
        .expanded => style.scale(1.25).borderRounded(20).color(Colors.yellow.shade300),
      },
      configBuilder: (phase) => switch (phase) {
        .initial => CurveAnimationConfig.springWithDampingRatio(800.ms, ratio: 0.3),
        .compress => .decelerate(200.ms),
        .expanded => .decelerate(100.ms),
      },
    );
```

Parameters:
- `trigger` — optional `Listenable`; each notification starts one run. Omit it for looping.
- `phases` — list of phase values (usually an enum)
- `styleBuilder` — returns style for each phase (receives base style)
- `configBuilder` — returns `CurveAnimationConfig` for each phase transition

## Keyframe Animations

Timeline-based with precise control over multiple properties and easing (like CSS keyframes).

**When to use:** Choreographed sequences, multi-property transitions.

```dart
final style = BoxStyler()
    .color(Colors.red)
    .size(80, 80)
    .keyframeAnimation(
      trigger: _trigger,  // Listenable; omit for looping
      timeline: [
        KeyframeTrack<Color>(
          'color',
          [
            .linear(Colors.blue.shade100, 100.ms),
            .elasticOut(Colors.blue.shade400, 800.ms),
            .elasticOut(Colors.green.shade100, 800.ms),
          ],
          initial: Colors.red.shade100,
          tweenBuilder: ColorTween.new,
        ),
        KeyframeTrack<double>('scale', [
          .linear(1.0, 360.ms),
          .elasticOut(1.5, 800.ms),
          .elasticOut(1.0, 800.ms),
        ], initial: 1.0),
      ],
      styleBuilder: (values, style) {
        final color = values.get<Color>('color');
        final scale = values.get<double>('scale');
        return style
            .color(color)
            .transform(Matrix4.identity()..scale(scale, scale, scale));
      },
    );
```

Parameters:
- `trigger` — optional `Listenable`; each notification starts one run. Omit it for looping.
- `timeline` — `List<KeyframeTrack>`, each runs in parallel
- `styleBuilder` — receives `KeyframeAnimationResult` and base style, returns modified style

### KeyframeTrack

Each track represents one animatable property:
- `name` — identifier for `values.get<T>(name)`
- `keyframes` — list of keyframe values with duration and easing
- `initial` — starting value
- `tweenBuilder` — optional custom tween (e.g., `ColorTween.new`)

Keyframes within a track run in sequence; tracks run in parallel.

## Comparison

| Type | Use Case | Complexity | Control |
|------|----------|------------|---------|
| **Implicit** | Simple state/variant transitions | Low | Basic |
| **Phase** | Multi-step / state machine | Medium | Moderate |
| **Keyframe** | Choreographed, multi-track | High | Full |
