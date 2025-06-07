import 'package:flutter/cupertino.dart';
import 'package:mix/experimental.dart';
import 'package:mix/mix.dart';

void main() {
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const Directionality(
      textDirection: TextDirection.ltr,
      child: Center(
        child: BellAnimation(),
      ),
    );
  }
}

enum HeartAnimationPhases implements PhaseVariant {
  initial,
  pulse;

  @override
  Variant get variant => Variant(name);
}

class HeartAnimation extends StatefulWidget {
  const HeartAnimation({
    super.key,
  });

  @override
  State<HeartAnimation> createState() => _HeartAnimationState();
}

class _HeartAnimationState extends State<HeartAnimation> {
  int count = 0;
  @override
  Widget build(BuildContext context) {
    final matrix = Matrix4.identity()..scale(2.0);

    final baseStyle = Style(
      $with.transform(Matrix4.identity()..scale(1.5)),
      $text.fontSize(50),
      $text.color.red(),
    );

    return StylePhaseAnimator(
      phases: {
        HeartAnimationPhases.initial: baseStyle,
        HeartAnimationPhases.pulse: Style(
          baseStyle(),
          $with.transform(matrix),
        ),
      },
      animation: (_) => const PhaseAnimationData(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      ),
      trigger: count,
      builder: (_, __, ___) => GestureDetector(
        onTap: () {
          setState(() {
            count++;
          });
        },
        child: const Box(
          inherit: true,
          child: StyledText('♥️'),
        ),
      ),
    );
  }
}

enum BellHighlightPhases implements PhaseVariant {
  initial,
  highlight;

  @override
  Variant get variant => Variant(name);
}

// 0, 8, -8, 4, -4, 3, -3, 2, -2, 1, -1, 0
enum BellAnimationPhases implements PhaseVariant {
  zero,
  eightP,
  eightN,
  fourP,
  fourN,
  threeP,
  threeN,
  twoP,
  twoN,
  oneP,
  oneN;

  @override
  Variant get variant => Variant(name);
}

class BellAnimation extends StatefulWidget {
  const BellAnimation({
    super.key,
  });

  @override
  State<BellAnimation> createState() => _BellAnimationState();
}

class _BellAnimationState extends State<BellAnimation> {
  Matrix4 calculateMatrixForShake(double x) =>
      Matrix4.identity()..translate(x, 0, 0);
  Matrix4 calculateMatrixScaleAndRotate(double scale, double rotation) =>
      Matrix4.identity()
        ..scale(scale, scale, 1)
        ..rotateZ(rotation);
  int count = 0;

  @override
  Widget build(BuildContext context) {
    // return StylePhaseAnimator(
    //     phases: {
    //       BellHighlightPhases.initial: baseA,
    //       BellHighlightPhases.highlight: Style(
    //         baseA(),
    //         $box.transform(calculateMatrixScaleAndRotate(2, pi / 12)),
    //         $box.transformAlignment.center(),
    //       ),
    //     },
    //     animation: (v) => switch (v) {
    //           BellHighlightPhases.initial => const PhaseAnimationData(
    //               duration: Duration(milliseconds: 3000),
    //               curve: Curves.linear,
    //             ),
    //           BellHighlightPhases.highlight => const PhaseAnimationData(
    //               duration: Duration(milliseconds: 300),
    //               curve: Curves.linear,
    //             ),
    //         },
    //     trigger: count,
    //     builder: (context, style, variant) {
    //       return GestureDetector(
    //         onTap: () {
    //           setState(() {
    //             count++;
    //           });
    //         },
    //         child: Box(
    //           style: style,
    //           child: const StyledIcon(CupertinoIcons.bell_fill),
    //         ),
    //       );
    final baseStyle = Style(
      $icon.wrap.transform(Matrix4.identity()),
      $icon.size(50),
      $icon.color.yellowAccent.shade700(),
    );
    return StylePhaseAnimator(
      trigger: count,
      phases: {
        BellAnimationPhases.zero: baseStyle,
        BellAnimationPhases.eightP: Style(
          baseStyle(),
          $icon.wrap.transform(calculateMatrixForShake(8)),
        ),
        BellAnimationPhases.eightN: Style(
          baseStyle(),
          $icon.wrap.transform(calculateMatrixForShake(-8)),
        ),
        BellAnimationPhases.fourP: Style(
          baseStyle(),
          $icon.wrap.transform(calculateMatrixForShake(4)),
        ),
        BellAnimationPhases.fourN: Style(
          baseStyle(),
          $icon.wrap.transform(calculateMatrixForShake(-4)),
        ),
        BellAnimationPhases.threeP: Style(
          baseStyle(),
          $icon.wrap.transform(calculateMatrixForShake(3)),
        ),
        BellAnimationPhases.threeN: Style(
          baseStyle(),
          $icon.wrap.transform(calculateMatrixForShake(-3)),
        ),
        BellAnimationPhases.twoP: Style(
          baseStyle(),
          $icon.wrap.transform(calculateMatrixForShake(2)),
        ),
        BellAnimationPhases.twoN: Style(
          baseStyle(),
          $icon.wrap.transform(calculateMatrixForShake(-2)),
        ),
        BellAnimationPhases.oneP: Style(
          baseStyle(),
          $icon.wrap.transform(calculateMatrixForShake(1)),
        ),
        BellAnimationPhases.oneN: Style(
          baseStyle(),
          $icon.wrap.transform(calculateMatrixForShake(-1)),
        ),
      },
      animation: (_) => PhaseAnimationData(
        duration: const Duration(milliseconds: 70),
        curve: SpringCurve(
          mass: 1,
          stiffness: 100,
          dampingRatio: 15,
        ),
      ),
      builder: (context, style, variant) => GestureDetector(
        onTap: () {
          setState(() {
            count++;
          });
        },
        child: const Box(
          inherit: true,
          child: StyledIcon(CupertinoIcons.bell_fill),
        ),
      ),
    );
  }
}
