import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const CupertinoApp(home: DemoApp());
  }
}

class DemoApp extends StatelessWidget {
  const DemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const CupertinoPageScaffold(
      backgroundColor: CupertinoColors.extraLightBackgroundGray,
      child: Center(child: EmojiSelector()),
    );
  }
}

class EmojiSelector extends StatelessWidget {
  const EmojiSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return FlexBox(
      direction: Axis.horizontal,
      style: FlexBoxStyle()
          .container(
            BoxMix()
                .padding(EdgeInsetsMix.symmetric(horizontal: 16, vertical: 10))
                .color(Colors.white)
                .borderRadius(BorderRadiusMix.circular(50))
                .shadow(
                  BoxShadowMix()
                      .color(Colors.black12)
                      .blurRadius(50)
                      .offset(Offset(0, 0)),
                ),
          )
          .flex(
            FlexMix()
                .spacing(16)
                .mainAxisAlignment(MainAxisAlignment.center)
                .mainAxisSize(MainAxisSize.min),
          ),
      children: [
        AnimatedEmoji(emoji: '❤️', delay: 0.ms),
        AnimatedEmoji(emoji: '🤑', delay: 100.ms),
        AnimatedEmoji(emoji: '👍', delay: 200.ms),
        AnimatedEmoji(emoji: '👎', delay: 300.ms),
        AnimatedEmoji(emoji: '🤣', delay: 400.ms),
      ],
    );
  }
}

enum AnimationEmojiPhase {
  vanish,
  bounceOut,
  identity;

  Matrix4 get matrix => switch (this) {
    AnimationEmojiPhase.identity => Matrix4.identity(),
    AnimationEmojiPhase.vanish =>
      Matrix4.identity()
        ..rotateZ(-pi / 14)
        ..translateByDouble(-5.0, -20.0, 0.0, 0.0)
        ..scaleByDouble(0.01, 0.01, 1, 1),
    AnimationEmojiPhase.bounceOut =>
      Matrix4.identity()
        ..rotateZ(-pi / 20)
        ..translateByDouble(-0.0, -25.0, 0.0, 0.0)
        ..scaleByDouble(0.9, 0.9, 1, 1),
  };

  CurveAnimationConfig get config => switch (this) {
    AnimationEmojiPhase.bounceOut => CurveAnimationConfig.bounceOut(300.ms),
    _ => CurveAnimationConfig.easeOut(150.ms),
  };
}

class AnimatedEmoji extends StatefulWidget {
  const AnimatedEmoji({
    super.key,
    required this.emoji,
    this.delay = Duration.zero,
  });

  final String emoji;
  final Duration delay;

  @override
  State<AnimatedEmoji> createState() => _AnimatedEmojiState();
}

class _AnimatedEmojiState extends State<AnimatedEmoji> {
  final trigger = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      trigger.value = true;
    });
  }

  @override
  void dispose() {
    trigger.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Box(
      style: Style.box(
        BoxStyle().phaseAnimation(
          trigger: trigger,
          phases: AnimationEmojiPhase.values,
          mode: PhaseAnimationMode.oneShot,
          styleBuilder: (phase, style) => style.transform(phase.matrix),
          configBuilder: (phase) {
            if (phase == AnimationEmojiPhase.vanish) {
              return phase.config.copyWith(delay: widget.delay);
            }
            return phase.config;
          },
        ),
      ),
      child: StyledText(
        widget.emoji,
        style: Style.text(TextStyling.fontSize(25)),
      ),
    );
  }
}
