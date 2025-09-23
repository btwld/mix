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
    return const CupertinoApp(
      home: Scaffold(body: Center(child: Example())),
    );
  }
}

class Example extends StatefulWidget {
  const Example({super.key});

  @override
  State<Example> createState() => _ExampleState();
}

class _ExampleState extends State<Example> {
  final trigger = ValueNotifier(0);

  @override
  void dispose() {
    trigger.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (event) => trigger.value++,
      child: RowBox(
        style: FlexBoxStyler()
            .color(Colors.white)
            .paddingX(16)
            .paddingY(8)
            .borderRounded(10)
            .border(BoxBorderMix.all(BorderSideMix.color(Colors.grey.shade200)))
            .mainAxisSize(MainAxisSize.min)
            .spacing(8)
            .onHovered(
              FlexBoxStyler().border(
                BoxBorderMix.all(BorderSideMix.color(Colors.grey.shade300)),
              ),
            )
            .animate(AnimationConfig.easeInOut(150.ms)),

        children: [
          Text('Developer Preview'),
          ArrowIconButton(animationTrigger: trigger),
        ],
      ),
    );
  }
}

enum ArrowPhases {
  identity,
  topRight,
  bottomLeft;

  Offset get offset => switch (this) {
    identity => Offset.zero,
    topRight => const Offset(16, -16),
    bottomLeft => const Offset(-16, 16),
  };

  Duration get duration => switch (this) {
    identity => 500.ms,
    topRight => 200.ms,
    bottomLeft => 1.ms,
  };

  Curve get curve => switch (this) {
    identity => SpringCurve.withDampingRatio(ratio: 0.4),
    topRight || bottomLeft => Curves.easeOut,
  };
}

class ArrowIconButton extends StatelessWidget {
  final ValueNotifier animationTrigger;
  const ArrowIconButton({super.key, required this.animationTrigger});
  @override
  Widget build(BuildContext context) {
    final boxContainer = BoxStyler()
        .color(Colors.grey.shade200)
        .borderRadius(BorderRadiusMix.circular(10))
        .size(20, 20)
        .clipBehavior(Clip.hardEdge);

    final icon = IconStyler()
        .color(Colors.grey.shade500)
        .size(14)
        .phaseAnimation(
          trigger: animationTrigger,
          phases: ArrowPhases.values,
          styleBuilder: (phase, style) =>
              style.wrapTranslate(x: phase.offset.dx, y: phase.offset.dy),
          configBuilder: (phase) => CurveAnimationConfig(
            duration: phase.duration,
            curve: phase.curve,
          ),
        );

    return boxContainer(child: icon(icon: CupertinoIcons.arrow_up_right));
  }
}
