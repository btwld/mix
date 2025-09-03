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
      return StyledText(emoji, style: Style.text().fontSize(25));
    }

    return FlexBox(
      direction: Axis.horizontal,
      style: Style.flexbox()
          .padding(EdgeInsetsMix.symmetric(horizontal: 16, vertical: 10))
          .color(Colors.white)
          .rounded(50)
          .boxShadow(
            color: Colors.black12,
            blurRadius: 50,
            offset: Offset(0, 0),
          )
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
  const PopUpAnimation({
    super.key,
    required this.child,
    this.delay = Duration.zero,
  });

  final Widget child;
  final Duration delay;

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
      style: Style.box().keyframeAnimation(
        trigger: trigger,
        timeline: [
          KeyframeTrack<double>('scale', initial: 0, [
            Keyframe.ease(0.2, 200.ms),
            Keyframe.elasticOut(1.0, 1000.ms),
          ]),
          KeyframeTrack<double>('y', initial: -100, [
            Keyframe.elasticOut(0, 800.ms),
          ]),
          KeyframeTrack<double>('opacity', initial: 0, [
            Keyframe.easeIn(1.0, 500.ms),
          ]),
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
