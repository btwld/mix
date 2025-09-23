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
    Widget emoji(String emoji) {
      return StyledText(emoji, style: TextStyler().fontSize(25));
    }

    return FlexBox(
      style: FlexBoxStyler()
          .padding(EdgeInsetsMix.symmetric(vertical: 10, horizontal: 16))
          .color(Colors.white)
          .borderRounded(50)
          .shadowOnly(color: Colors.black12, blurRadius: 50)
          .spacing(16)
          .mainAxisAlignment(MainAxisAlignment.center)
          .mainAxisSize(MainAxisSize.min),

      children: [
        PopUpAnimation(child: emoji('❤️')),
        PopUpAnimation(delay: 100.ms, child: emoji('🤑')),
        PopUpAnimation(delay: 200.ms, child: emoji('👍')),
        PopUpAnimation(delay: 300.ms, child: emoji('👎')),
        PopUpAnimation(delay: 400.ms, child: emoji('🤣')),
      ],
    );
  }
}

class PopUpAnimation extends StatefulWidget {
  final Widget child;

  final Duration delay;
  const PopUpAnimation({
    super.key,
    required this.child,
    this.delay = Duration.zero,
  });

  @override
  State<PopUpAnimation> createState() => _PopUpAnimationState();
}

class _PopUpAnimationState extends State<PopUpAnimation> {
  final trigger = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    Future.delayed(widget.delay, () => trigger.value = true);
  }

  @override
  void dispose() {
    trigger.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Box(
      style: BoxStyler().keyframeAnimation(
        trigger: trigger,
        timeline: [
          KeyframeTrack<double>('scale', [
            Keyframe.ease(0.2, 200.ms),
            Keyframe.elasticOut(1.0, 1000.ms),
          ], initial: 0),
          KeyframeTrack<double>('y', [
            Keyframe.elasticOut(0, 800.ms),
          ], initial: -100),
          KeyframeTrack<double>('opacity', [
            Keyframe.easeIn(1.0, 500.ms),
          ], initial: 0),
        ],
        styleBuilder: (values, style) {
          final scale = values.get('scale');
          final y = values.get('y');
          final opacity = values.get('opacity');

          return style
              .transform(
                Matrix4.identity()
                  ..scaleByDouble(scale, scale, 1, 1)
                  ..translateByDouble(0.0, y, 0, 1),
              )
              .wrapOpacity(opacity);
        },
      ),
      child: widget.child,
    );
  }
}
