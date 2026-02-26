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
      return StyledText(emoji, style: .fontSize(25));
    }

    return FlexBox(
      style: .padding(.symmetric(vertical: 10, horizontal: 16))
          .color(Colors.white)
          .borderRadius(.circular(50))
          .shadow(.color(Colors.black12).blurRadius(50))
          .spacing(16)
          .mainAxisAlignment(.center)
          .mainAxisSize(.min),

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
  const PopUpAnimation({super.key, required this.child, this.delay = .zero});

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
      style: .keyframeAnimation(
        trigger: trigger,
        timeline: [
          KeyframeTrack('scale', [
            .ease(0.2, 200.ms),
            .elasticOut(1.0, 1000.ms),
          ], initial: 0.0),
          KeyframeTrack('y', [.elasticOut(0.0, 800.ms)], initial: -100.0),
          KeyframeTrack('opacity', [.easeIn(1.0, 500.ms)], initial: 0.0),
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
              .wrap(.new().opacity(opacity));
        },
      ),
      child: widget.child,
    );
  }
}
