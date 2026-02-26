/// Keyframe loop animation: scale + color + opacity.
///
/// Several tracks run in parallel to create one looping animation. The style
/// builder applies scale, color, and opacity from the tracks. Uses
/// [ColorTween] to interpolate between initial and end colors.
///
/// Key concepts:
/// - Keyframe animation without trigger (loops on its own)
/// - Multiple tracks: scale, color, opacity
/// - Custom tween (ColorTween) for color interpolation
/// - styleBuilder maps track values to style
library;

import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

import '../../helpers.dart';

void main() {
  runMixApp(const Example());
}

class Example extends StatelessWidget {
  const Example({super.key});

  @override
  Widget build(BuildContext context) {
    final style = BoxStyler()
        .size(60, 60)
        .alignment(.centerLeft)
        .keyframeAnimation(
          timeline: [
            KeyframeTrack('scale', [
              .springWithBounce(1.0, 2000.ms, bounce: 0.5),
            ], initial: 0.0),
            KeyframeTrack<Color>(
              'color',
              [.easeInOut(Colors.deepPurpleAccent, 2000.ms)],
              initial: Colors.grey.shade300,
              tweenBuilder: ColorTween.new,
            ),
            KeyframeTrack('opacity', [.easeIn(1.0, 500.ms)], initial: 0.0),
          ],
          styleBuilder: (values, style) {
            final scale = values.get('scale');
            final opacity = values.get('opacity');

            return style
                .transform(Matrix4.diagonal3Values(scale, scale, 1.0))
                .color(values.get('color'))
                .wrap(WidgetModifierConfig.opacity(opacity));
          },
        );

    return style();
  }
}
