import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mix/experimental.dart';
import 'package:mix/mix.dart';

const primary = ColorToken('primary');

void main() {
  runApp(
    MixTheme(
      data: MixThemeData(
        colors: {
          primary: Colors.blue,
        },
      ),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const Directionality(
      textDirection: TextDirection.ltr,
      child: Center(
        child: Column(
          spacing: 16,
          mainAxisSize: MainAxisSize.min,
          children: [
            HeartAnimation(),
            ButtonAnimation(),
            CompassAnimation(),
          ],
        ),
      ),
    );
  }
}

class ButtonAnimation extends StatefulWidget {
  const ButtonAnimation({
    super.key,
  });

  @override
  State<ButtonAnimation> createState() => _ButtonAnimationState();
}

enum ButtonAnimationPhases implements PhaseVariant {
  initial,
  shakeLeft,
  shakeRight;

  @override
  Variant get variant => Variant(name);
}

class _ButtonAnimationState extends State<ButtonAnimation> {
  int _clickCount = 0;

  Matrix4 matrix(double angle) => Matrix4.identity()..rotateZ(angle);

  @override
  Widget build(BuildContext context) {
    final baseStyle = Style(
      $icon.chain
        ..size(18)
        ..color.white()
        ..wrap.transform(Matrix4.identity()),
      $flexbox.chain
        ..flex.gap(8)
        ..color.redAccent()
        ..flex.mainAxisSize.min()
        ..padding(12, 8)
        ..borderRadius(12),
    );

    return StylePhaseAnimator(
      trigger: _clickCount,
      phases: {
        ButtonAnimationPhases.initial: baseStyle,
        ButtonAnimationPhases.shakeLeft: Style(
          baseStyle(),
          $icon.wrap.transform(matrix(pi / 8)),
        ),
        ButtonAnimationPhases.shakeRight: Style(
          baseStyle(),
          $icon.wrap.transform(matrix(-pi / 8)),
        ),
      },
      animation: (variants) {
        return switch (variants) {
          ButtonAnimationPhases.initial => const PhaseAnimationData(
              duration: Duration(milliseconds: 100),
              curve: Curves.linear,
            ),
          ButtonAnimationPhases.shakeLeft => const PhaseAnimationData(
              duration: Duration(milliseconds: 150),
              curve: Curves.easeIn,
            ),
          ButtonAnimationPhases.shakeRight => const PhaseAnimationData(
              duration: Duration(milliseconds: 150),
              curve: Curves.easeOut,
            ),
        };
      },
      builder: (context, style, variant) => GestureDetector(
        onTap: () {
          setState(() {
            _clickCount++;
          });
        },
        child: const FlexBox(
          inherit: true,
          direction: Axis.horizontal,
          children: [
            StyledIcon(CupertinoIcons.bell),
            StyledText('Press me'),
          ],
        ),
      ),
    );
  }
}

class CompassAnimation extends StatefulWidget {
  const CompassAnimation({
    super.key,
  });

  @override
  State<CompassAnimation> createState() => _CompassAnimationState();
}

enum CompassAnimationPhases implements PhaseVariant {
  north,
  east,
  south,
  west;

  @override
  Variant get variant => Variant(name);
}

class _CompassAnimationState extends State<CompassAnimation> {
  int _clickCount = 0;

  Matrix4 matrix(double angle) => Matrix4.identity()..rotateZ(angle);

  @override
  Widget build(BuildContext context) {
    final baseStyle = Style(
      $icon.size(30),
      $icon.color.white(),
      $box.padding(20),
      $icon.wrap.transform(Matrix4.identity()),
      $box.color.blueAccent(),
      $box.shape.circle(),
      $box.border.all(color: Colors.white, width: 5),
    );

    return StylePhaseAnimator(
      trigger: _clickCount,
      phases: {
        CompassAnimationPhases.north: baseStyle,
        CompassAnimationPhases.east: Style(
          baseStyle(),
          $icon.wrap.transform(matrix(pi / 2)),
        ),
        CompassAnimationPhases.south: Style(
          baseStyle(),
          $icon.wrap.transform(matrix(pi)),
        ),
        CompassAnimationPhases.west: Style(
          baseStyle(),
          $icon.wrap.transform(matrix(3 * pi / 2)),
        ),
      },
      animation: (_) => PhaseAnimationData(
        duration: const Duration(milliseconds: 1000),
        curve: SpringCurve(
          dampingRatio: 0.3,
          stiffness: 50,
          mass: 1,
        ),
      ),
      builder: (context, style, variant) => GestureDetector(
        onTap: () {
          setState(() {
            _clickCount++;
          });
        },
        child: const Box(
          inherit: true,
          child: StyledIcon(CupertinoIcons.location_north_fill),
        ),
      ),
    );
  }
}

class HeartAnimation extends StatefulWidget {
  const HeartAnimation({
    super.key,
  });

  @override
  State<HeartAnimation> createState() => _HeartAnimationState();
}

enum HeartAnimationPhases implements PhaseVariant {
  initial,
  moveAndScale;

  @override
  Variant get variant => Variant(name);
}

class _HeartAnimationState extends State<HeartAnimation> {
  int _clickCount = 0;

  final matrix = Matrix4.identity()
    ..translate(0.0, -64.0)
    ..scale(2.0);

  @override
  Widget build(BuildContext context) {
    final baseStyle = Style(
      $with.transform(Matrix4.identity()),
      $text.fontSize(50),
    );

    return StylePhaseAnimator(
      trigger: _clickCount,
      phases: {
        HeartAnimationPhases.initial: baseStyle,
        HeartAnimationPhases.moveAndScale: Style(
          baseStyle(),
          $with.transform(matrix),
        ),
      },
      animation: (variant) {
        switch (variant) {
          case HeartAnimationPhases.moveAndScale:
            return const PhaseAnimationData(
              duration: Duration(milliseconds: 300),
              curve: Curves.decelerate,
            );
          case HeartAnimationPhases.initial:
            return const PhaseAnimationData(
              duration: Duration(milliseconds: 500),
            );
        }
      },
      builder: (context, style, variant) => GestureDetector(
        onTap: () {
          setState(() {
            _clickCount++;
          });
        },
        child: Box(
          inherit: true,
          style: Style(
            HeartAnimationPhases.initial.variant($text.color.red()),
            HeartAnimationPhases.moveAndScale.variant($text.color.blue()),
          ).applyVariant(variant).animate(duration: Duration.zero),
          child: const StyledText('♥️'),
        ),
      ),
    );
  }
}

Style style() => Style(
      $icon.color.red(),
      $flexbox.chain
        ..flex.direction(Axis.horizontal)
        ..flex.mainAxisSize.min(),
      $on.breakpoint(const Breakpoint(minWidth: 0, maxWidth: 365))(
        $flexbox.chain.flex.direction(Axis.vertical),
      ),
    ).animate(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
    );
