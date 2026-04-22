# Animations Reference

Mix animation is configured on Stylers. Prefer style-level APIs for new app code:
`.animate(...)`, `.keyframeAnimation(...)`, and `.phaseAnimation(...)`.

## Implicit Animations

Use `.animate(...)` when a style changes because of state, variants, or rebuilds.

```dart
final style = BoxStyler()
    .color(Colors.blue)
    .size(100, 100)
    .borderRounded(12)
    .animate(.easeInOut(220.ms))
    .onHovered(
      .color(Colors.blue.shade700)
          .size(112, 112),
    )
    .onPressed(.scale(0.96));
```

Common configs from `animation_config.dart`:

| Config | Use |
|---|---|
| `AnimationConfig.linear(duration)` or `.linear(duration)` | constant speed |
| `AnimationConfig.ease(duration)` or `.ease(duration)` | default ease |
| `AnimationConfig.easeInOut(duration)` or `.easeInOut(duration)` | balanced transition |
| `AnimationConfig.decelerate(duration)` or `.decelerate(duration)` | slow finish |
| `AnimationConfig.bounceOut(duration)` or `.bounceOut(duration)` | playful exit |
| `AnimationConfig.elasticOut(duration)` or `.elasticOut(duration)` | elastic movement |
| `AnimationConfig.spring(...)` | spring physics |

Durations can use extension getters such as `180.ms`.

## Keyframe Animation

Use `.keyframeAnimation(...)` for timeline values. The `styleBuilder` receives
computed keyframe values and returns a new Styler.

```dart
final pulseTrigger = ValueNotifier(0);

final style = BoxStyler()
    .color(Colors.pink)
    .size(80, 80)
    .shapeCircle()
    .keyframeAnimation(
      trigger: pulseTrigger,
      timeline: [
        KeyframeTrack<double>(
          'scale',
          [
            Keyframe.easeOut(1.12, 120.ms),
            Keyframe.easeIn(1.0, 160.ms),
          ],
          initial: 1.0,
        ),
      ],
      styleBuilder: (values, style) {
        return style.scale(values.get<double>('scale'));
      },
    );
```

If `trigger` is omitted in the underlying config, keyframe animation is treated
as looping. Prefer explicit triggers for event-based examples.

## Phase Animation

Use `.phaseAnimation(...)` for named or indexed steps where each phase maps to a target style.

```dart
enum ButtonPhase { compress, expand, settle }

final trigger = ValueNotifier(0);

final style = BoxStyler()
    .color(Colors.blue)
    .size(96, 48)
    .borderRounded(12)
    .phaseAnimation<ButtonPhase>(
      trigger: trigger,
      phases: ButtonPhase.values,
      styleBuilder: (phase, style) {
        return switch (phase) {
          ButtonPhase.compress => style.scale(0.94),
          ButtonPhase.expand => style.scale(1.04),
          ButtonPhase.settle => style.scale(1.0),
        };
      },
      configBuilder: (phase) {
        return CurveAnimationConfig(
          duration: 120.ms,
          curve: Curves.easeInOut,
        );
      },
    );
```

## Practical Guidance

- Use `.animate(...)` for hover/press/theme transitions.
- Use `.keyframeAnimation(...)` when one or more numeric values need a timeline.
- Use `.phaseAnimation(...)` when the animation is a sequence of named states.
- Dispose or own any external `Listenable` such as `ValueNotifier` in the
  surrounding stateful widget.
- Do not use builder-class examples for new app code unless source/docs specifically require them.

## Source Files

- `packages/mix/lib/src/style/mixins/animation_style_mixin.dart`
- `packages/mix/lib/src/animation/animation_config.dart`
- `packages/mix/lib/src/core/extensions/extensions.dart`
- `packages/mix/test/src/style/styler_mixin_conformance_test.dart`
- `packages/mix/test/src/animation/animation_config_test.dart`
- `packages/mix/test/src/animation/style_animation_driver_test.dart`
