import 'dart:math';

import 'package:flutter/cupertino.dart';
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
    return Row(
      mainAxisSize: MainAxisSize.min,
      spacing: 16,
      children: [
        ScaleAnimation(),
        HoverAnimation(),
        CompressExpandAnimation(),
        HeartKeyframeAnimation(),
      ],
    );
  }
}

// 1

class ScaleAnimation extends StatefulWidget {
  const ScaleAnimation({super.key});

  @override
  State<ScaleAnimation> createState() => _ScaleAnimationState();
}

class _ScaleAnimationState extends State<ScaleAnimation> {
  bool appear = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        appear = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final style = BoxStyler()
        .color(Colors.black)
        .height(100)
        .width(100)
        .borderRounded(10)
        .scale(appear ? 1 : 0.1) // state-based
        .animate(AnimationConfig.easeInOut(1.s));

    return Box(style: style);
  }
}

// 2

class HoverAnimation extends StatelessWidget {
  const HoverAnimation({super.key});

  @override
  Widget build(BuildContext context) {
    final style = BoxStyler()
        .color(Colors.black)
        .height(100)
        .width(100)
        .borderRounded(10)
        .scale(1)
        .onHovered(BoxStyler().color(Colors.blue).scale(1.5))
        .animate(AnimationConfig.spring(800.ms));

    return Box(style: style);
  }
}

// 3

enum AnimationPhases { initial, compress, expanded }

class CompressExpandAnimation extends StatefulWidget {
  const CompressExpandAnimation({super.key});

  @override
  State<CompressExpandAnimation> createState() =>
      _CompressExpandAnimationState();
}

class _CompressExpandAnimationState extends State<CompressExpandAnimation> {
  final _isExpanded = ValueNotifier(false);

  @override
  void dispose() {
    _isExpanded.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final style = BoxStyler()
        .color(Colors.deepPurple)
        .height(100)
        .width(100)
        .borderRounded(40)
        .phaseAnimation(
          trigger: _isExpanded,
          phases: AnimationPhases.values,
          styleBuilder: (phase, style) => switch (phase) {
            AnimationPhases.initial => style.scale(1),
            AnimationPhases.compress =>
              style.scale(0.75).color(Colors.red.shade800),
            AnimationPhases.expanded =>
              style.scale(1.25).borderRounded(20).color(Colors.yellow.shade300),
          },
          configBuilder: (phase) => switch (phase) {
            AnimationPhases.initial =>
              CurveAnimationConfig.springWithDampingRatio(800.ms, ratio: 0.3),
            AnimationPhases.compress => CurveAnimationConfig.decelerate(200.ms),
            AnimationPhases.expanded => CurveAnimationConfig.decelerate(100.ms),
          },
        );
    return Pressable(
      onPress: () {
        _isExpanded.value = !_isExpanded.value;
      },
      child: Box(style: style),
    );
  }
}

// 4

class HeartKeyframeAnimation extends StatefulWidget {
  const HeartKeyframeAnimation({super.key});

  @override
  State<HeartKeyframeAnimation> createState() => _HeartKeyframeAnimationState();
}

class _HeartKeyframeAnimationState extends State<HeartKeyframeAnimation> {
  final _trigger = ValueNotifier(0);

  @override
  Widget build(BuildContext context) {
    final style = IconStyler()
        .color(Colors.red)
        .size(80)
        .keyframeAnimation(
          trigger: _trigger,
          timeline: [
            KeyframeTrack<Color>(
              'color',
              [
                Keyframe.linear(Colors.blue.shade100, 100.ms),
                Keyframe.elasticOut(Colors.blue.shade400, 800.ms),
                Keyframe.elasticOut(Colors.green.shade100, 800.ms),
              ],
              initial: Colors.red.shade100,
              tweenBuilder: ColorTween.new,
            ),
            KeyframeTrack<double>('scale', [
              Keyframe.linear(1.0, 360.ms),
              Keyframe.elasticOut(1.5, 800.ms),
              Keyframe.elasticOut(1.0, 800.ms),
            ], initial: 1.0),
            KeyframeTrack<double>('verticalOffset', [
              Keyframe.linear(0.0, 100.ms),
              Keyframe.easeIn(20.0, 150.ms),
              Keyframe.elasticOut(-60.0, 1000.ms),
              Keyframe.elasticOut(0.0, 800.ms),
            ], initial: 0.0),
            KeyframeTrack<double>('verticalStretch', [
              Keyframe.ease(1.0, 100.ms),
              Keyframe.ease(0.6, 150.ms),
              Keyframe.ease(1.5, 100.ms),
              Keyframe.ease(1.05, 150.ms),
              Keyframe.ease(1.0, 880.ms),
              Keyframe.ease(0.8, 100.ms),
              Keyframe.ease(1.04, 400.ms),
              Keyframe.ease(1.0, 220.ms),
            ], initial: 1.0),
            KeyframeTrack<double>('angle', [
              Keyframe.easeIn(0.0, 580.ms),
              Keyframe.easeIn(16.0 * (pi / 180), 125.ms),
              Keyframe.easeIn(-16.0 * (pi / 180), 125.ms),
              Keyframe.easeIn(16.0 * (pi / 180), 125.ms),
              Keyframe.easeIn(0.0, 125.ms),
            ], initial: 0.0),
          ],
          styleBuilder: (values, style) {
            final scale = values.get('scale');
            final verticalOffset = values.get('verticalOffset');
            final verticalStretch = values.get('verticalStretch');
            final angle = values.get('angle');

            return style.wrapTransform(
              Matrix4.identity()
                ..scaleByDouble(scale, scale, scale, 1.0)
                ..translateByDouble(0, verticalOffset, 0, 1)
                ..scaleByDouble(1, verticalStretch, 1, 1)
                ..rotateZ(angle),
            );
          },
        );
    return Pressable(
      onPress: () {
        _trigger.value++;
      },
      child: StyledIcon(CupertinoIcons.heart_fill, style: style),
    );
  }
}
