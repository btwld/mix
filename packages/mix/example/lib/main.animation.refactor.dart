import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mix/experimental.dart';
import 'package:mix/mix.dart';

void main() {
  runApp(
    const BlockGroup(),
  );
}

class BellAnimation extends StatefulWidget {
  const BellAnimation({super.key});

  @override
  State<BellAnimation> createState() => _BellAnimationState();
}

class _BellAnimationState extends State<BellAnimation> {
  int count = 0;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      home: Center(
        child: SpecBuilder(builder: (context) {
          return SpecPhaseAnimator<bool, BoxSpecAttribute, BoxSpec>(
            trigger: count,
            phases: const [false, true],
            phaseBuilder: (phase) => Style(
              $box.transform(Matrix4.identity()..scale(phase ? 2.0 : 1.0)),
              $box.transformAlignment.center(),
            ),
            animation: (phase) => SpecPhaseAnimationData(
              duration: Duration(milliseconds: phase ? 700 : 300),
              curve: Curves.easeInOut,
            ),
            builder: (context, scaleStyle) {
              return SpecPhaseAnimator<double, BoxSpecAttribute, BoxSpec>(
                trigger: count,
                phases: const [0, -8, 8, 4, -4, 3, -3, 2, -2, 1, -1, 0],
                phaseBuilder: (phase) => Style(
                  $box.transform(Matrix4.identity()..translate(phase, 0, 0)),
                ),
                animation: (_) => const SpecPhaseAnimationData(
                  duration: Duration(milliseconds: 100),
                  curve: Curves.easeInOut,
                ),
                builder: (context, translateStyle) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        count++;
                      });
                    },
                    child: Box(
                      style: scaleStyle,
                      child: Box(
                        style: Style(
                          scaleStyle(),
                          translateStyle(),
                          $icon.color(Colors.yellowAccent.shade700),
                        ),
                        child: const StyledIcon(
                          CupertinoIcons.bell_fill,
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          );
        }),
      ),
    );
  }
}

enum BlockPhases {
  identity,
  compress,
  expand;

  double get value => switch (this) {
        identity => 0,
        compress => -0.5,
        expand => 0.5,
      };
}

class BlockGroup extends StatelessWidget {
  const BlockGroup({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      showPerformanceOverlay: true,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
      ),
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: SpecBuilder(builder: (context) {
            return const AnimatedBlock();
          }),
        ),
      ),
    );
  }
}

class AnimatedBlock extends StatefulWidget {
  const AnimatedBlock({
    super.key,
  });

  @override
  State<AnimatedBlock> createState() => _AnimatedBlockState();
}

const int _rows = 1;
const int _cols = 19;
const double _size = 20;
const double _spacing = 8;
final double _maxDistance = calculateHypot(
  const Point(0, 0),
  const Point(_cols - 1, _rows - 1),
);

class _AnimatedBlockState extends State<AnimatedBlock> {
  int count = 0;
  Point<int> waveOriginal = const Point(0, 0);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: _spacing,
      children: List.generate(_rows, (rowIndex) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: _spacing,
          children: List.generate(_cols, (colIndex) {
            return SpecPhaseAnimator<BlockPhases, BoxSpecAttribute, BoxSpec>(
              phases: BlockPhases.values,
              phaseBuilder: (phase) {
                final cellCordinates = Point<int>(colIndex, rowIndex);

                final originDistance = calculateHypot(
                  waveOriginal,
                  cellCordinates,
                );
                final originDistanceNormalized = originDistance / _maxDistance;
                final waveImpact = 1 - originDistanceNormalized;

                return Style(
                  $box.transform(
                      Matrix4.identity()..scale(1 + phase.value * waveImpact)),
                  $box.color(
                    phase == BlockPhases.identity
                        ? Colors.blueGrey.shade200
                        : Colors.blueGrey.shade200.mix(
                            Colors.lightBlueAccent,
                            (waveImpact * 100).toInt(),
                          ),
                  ),
                  $box.transformAlignment.center(),
                );
              },
              animation: (phase) {
                final cellCordinates = Point<int>(colIndex, rowIndex);

                final originDistance = calculateHypot(
                  waveOriginal,
                  cellCordinates,
                );

                return switch (phase) {
                  BlockPhases.identity => const SpecPhaseAnimationData(
                      duration: Duration(milliseconds: 100),
                      curve: Curves.easeInOut,
                    ),
                  BlockPhases.compress => SpecPhaseAnimationData(
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeInOut,
                      delay: Duration(
                          milliseconds: (100.0 * originDistance).toInt()),
                    ),
                  BlockPhases.expand => const SpecPhaseAnimationData(
                      duration: Duration(milliseconds: 200),
                      curve: Curves.easeInOut,
                    ),
                };
              },
              trigger: count,
              builder: (context, scaleStyle) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      count++;
                      waveOriginal = Point(colIndex, rowIndex);
                    });
                  },
                  child: Box(
                    style: Style(
                      $box.height(_size),
                      $box.width(_size),
                      $box.borderRadius.all(_size * 0.25),
                      scaleStyle(),
                    ),
                  ),
                );
              },
            );
          }),
        );
      }),
    );
  }
}

double calculateHypot(Point<int> p1, Point<int> p2) {
  final dx = (p2.x - p1.x).abs();
  final dy = (p2.y - p1.y).abs();
  return sqrt(dx * dx + dy * dy);
}
