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

class DemoApp extends StatefulWidget {
  const DemoApp({super.key});

  @override
  State<DemoApp> createState() => _DemoAppState();
}

class _DemoAppState extends State<DemoApp> {
  bool animate = false;

  @override
  Widget build(BuildContext context) {
    final vboxStyle = FlexBoxStyle()
        .flex(FlexMix().mainAxisSize(MainAxisSize.min).spacing(60))
        .box(BoxMix().margin(EdgeInsetsMix.all(10)));

    final FlexBoxStyle hboxStyle = FlexBoxStyle()
        .flex(
          FlexMix()
              .mainAxisAlignment(MainAxisAlignment.spaceBetween)
              .crossAxisAlignment(CrossAxisAlignment.center),
        )
        .box(
          BoxMix()
              .padding(EdgeInsetsMix.horizontal(16).vertical(8))
              .color(Colors.grey.shade200)
              .borderRadius(BorderRadiusMix.circular(10)),
        );

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: VBox(
          style: vboxStyle,
          children: [
            HeartAnimation(animate: animate),
            HBox(
              style: hboxStyle,
              children: [
                StyledText('Animate', style: TextStyling.fontSize(16)),
                Switch.adaptive(
                  value: animate,
                  onChanged: (value) {
                    setState(() {
                      animate = value;
                    });
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class HeartAnimation extends StatelessWidget {
  const HeartAnimation({super.key, required this.animate});
  final bool animate;

  @override
  Widget build(BuildContext context) {
    return Box(
      style: Style.box(
        BoxStyle()
            .modifier(animate ? ModifierConfig.scale(2.0) : ModifierConfig())
            .modifier(ModifierConfig.opacity(animate ? 1.0 : 0.5))
            .animate(AnimationConfig.bounceIn(1000.ms)),
      ),
      child: ShaderMask(
        shaderCallback: (Rect bounds) {
          return LinearGradient(
            colors: [Colors.redAccent.shade100, Colors.redAccent.shade400],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ).createShader(bounds);
        },
        child: StyledIcon(
          icon: CupertinoIcons.heart_fill,
          style: IconStyle().size(100).color(Colors.white),
        ),
      ),
    );
  }
}
