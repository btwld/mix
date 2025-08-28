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
      child: HBox(
        style:
            Style.flexbox(
              FlexBoxStyle(
                decoration: BoxDecorationMix.color(Colors.white)
                    .borderRadius(BorderRadiusMix.circular(10))
                    .border(
                      BoxBorderMix.all(
                        BorderSideMix.color(Colors.grey.shade200),
                      ),
                    ),
                padding: EdgeInsetsMix.symmetric(horizontal: 16, vertical: 8),
                mainAxisSize: MainAxisSize.min,
                spacing: 8,
              ),
            ).onHovered(
              FlexBoxStyle(
                decoration: BoxDecorationMix().border(
                  BoxBorderMix.all(BorderSideMix.color(Colors.red)),
                ),
              ),
            ),

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
    identity => 200.ms,
    topRight => 1.ms,
    bottomLeft => 700.ms,
  };

  Curve get curve => switch (this) {
    identity => Curves.easeOut,
    topRight || bottomLeft => Curves.elasticOut,
  };
}

class ArrowIconButton extends StatelessWidget {
  const ArrowIconButton({super.key, required this.animationTrigger});
  final ValueNotifier animationTrigger;

  @override
  Widget build(BuildContext context) {
    return Box(
      style: BoxStyle()
          .color(Colors.grey.shade200)
          .borderRadius(BorderRadiusMix.circular(10))
          .size(20, 20)
          .clipBehavior(Clip.hardEdge),

      child: Box(
        style: BoxStyle().phaseAnimation(
          trigger: animationTrigger,
          phases: ArrowPhases.values,
          styleBuilder: (phase, style) =>
              style.translate(phase.offset.dx, phase.offset.dy),
          configBuilder: (phase) => CurveAnimationConfig(
            duration: phase.duration,
            curve: phase.curve,
          ),
        ),
        child: StyledIcon(
          icon: CupertinoIcons.arrow_up_right,
          style: IconStyle().color(Colors.grey.shade500).size(14),
        ),
      ),
    );
  }
}
