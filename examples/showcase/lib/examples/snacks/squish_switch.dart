import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';

// A local palette keeps the example independent of theme tokens.
const whiteColor = Color(0xFFFFFFFF);
const trackOffColor = Color(0xFFD1D5DB);
const trackOnColor = Color(0xFF7C3AED);
const thumbBorderColor = Color(0xFFE5E7EB);

/// Runs a standalone showcase of state-driven and keyframe animation in Mix.
///
/// Paste this entire file into https://dartpad.dev/ and select Run. Hold the
/// switch to see it shrink, then release to toggle its color and squish the
/// thumb as it moves. A quick click also plays the thumb animation.
///
/// This motion-focused demo always animates. In a production control, also
/// respect the user's reduced-motion preference.
void main() => runApp(
  WidgetsApp(
    color: whiteColor,
    debugShowCheckedModeBanner: false,
    builder: (_, _) => const ColoredBox(
      color: whiteColor,
      child: Center(child: SquishSwitch()),
    ),
  ),
);

/// Styles the track's selected color and pressed-state feedback.
///
/// [Pressable] supplies the pressed state to `.onPressed()`. The spring
/// interpolates both the color change and the return from the smaller scale.
StackBoxStyler squishTrackStyle({required bool isOn}) => StackBoxStyler()
    .size(76, 38)
    .color(isOn ? trackOnColor : trackOffColor)
    .borderRadius(.circular(19))
    .stackAlignment(.topLeft)
    .onPressed(.scale(0.92))
    .animate(.spring(300.ms, bounce: 0.12));

/// Moves the thumb between the track's two endpoints with a spring.
///
/// A 30-pixel thumb fits inside the 76-pixel track with a 4-pixel inset:
/// the right endpoint is `76 - 30 - 4 = 42`.
/// Travel lives on a separate box so its spring and the thumb's keyframes
/// can run independently; one styler holds one animation configuration.
BoxStyler squishTravelStyle({required bool isOn}) => BoxStyler()
    .translate(isOn ? 42 : 4, 4)
    .animate(.spring(360.ms, bounce: 0.24));

/// Styles the thumb and plays one squash-and-stretch sequence per notification.
///
/// [trigger] starts the sequence: stretch during travel, compress on landing,
/// then return to a circle. Segment durations are sequential, totaling 360 ms.
BoxStyler squishThumbStyle({required Listenable trigger}) => BoxStyler()
    .size(30, 30)
    .color(whiteColor)
    .border(.color(thumbBorderColor).width(1))
    .borderRadius(.circular(15))
    .keyframeAnimation(
      trigger: trigger,
      timeline: [
        KeyframeTrack<double>('squish', [
          .easeOut(1.16, 90.ms),
          .easeInOut(0.95, 150.ms),
          .easeOut(1, 120.ms),
        ], initial: 1),
      ],
      styleBuilder: (values, style) {
        // Read this frame's value using the track ID and preserve the area
        // by shrinking the vertical axis as the horizontal axis stretches.
        final scale = values.get<double>('squish');
        return style.wrap(.scale(x: scale, y: 1 / scale));
      },
    );

/// A tap-to-toggle switch combining press feedback, spring travel, and squish.
///
/// The example owns its on/off state. [Pressable] handles pointer and keyboard
/// activation; the surrounding [Semantics] exposes the switch's current state.
class SquishSwitch extends StatefulWidget {
  /// Creates the switch in its off state.
  const SquishSwitch({super.key});

  @override
  State<SquishSwitch> createState() => _SquishSwitchState();
}

class _SquishSwitchState extends State<SquishSwitch> {
  bool _on = false;
  // Only notifications matter; the counter is not an animation progress value.
  final _squish = ValueNotifier(0);

  @override
  void dispose() {
    _squish.dispose();
    super.dispose();
  }

  void _toggle() {
    // The state change retargets the implicit springs. The notification
    // separately restarts the thumb's keyframes, including on a quick tap.
    setState(() => _on = !_on);
    _squish.value++;
  }

  @override
  Widget build(BuildContext context) {
    final track = squishTrackStyle(isOn: _on);
    final travel = squishTravelStyle(isOn: _on);
    final thumb = squishThumbStyle(trigger: _squish);

    return Semantics(
      label: 'Squish switch',
      toggled: _on,
      onTap: _toggle,
      child: Pressable(
        key: const Key('squish-switch'),
        // The outer Semantics owns the switch role and action, not a button.
        excludeFromSemantics: true,
        onPress: _toggle,
        // Calling a styler creates its widget with that style already applied.
        child: track(children: [travel(child: thumb())]),
      ),
    );
  }
}
