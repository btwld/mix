import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/experimental.dart';
import 'package:mix/mix.dart';

void main() {
  group('SpecPhaseAnimator', () {
    testWidgets('builds with initial phase only once', (tester) async {
      int buildCount = 0;
      await tester.pumpWidget(
        MaterialApp(
          home: SpecBuilder(
            builder: (context) {
              return SpecPhaseAnimator<bool, BoxSpecAttribute, BoxSpec>(
                phases: const [false, true],
                phaseBuilder: (phase) => Style(
                  $box.transform(Matrix4.identity()..scale(phase ? 2.0 : 1.0)),
                ),
                animation: (_) => const SpecPhaseAnimationData(
                  duration: Duration(milliseconds: 100),
                  curve: Curves.linear,
                ),
                trigger: 0,
                builder: (_, style) {
                  buildCount++;
                  return Box(style: style);
                },
              );
            },
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(Box), findsOneWidget);
      expect(buildCount, 1);
    });

    // testWidgets('animates between phases when trigger changes', (tester) async {
    //   int trigger = 0;

    //   await tester.pumpWidget(
    //     MaterialApp(
    //       home: SpecBuilder(
    //         builder: (context) {
    //           return SpecPhaseAnimator<bool, BoxSpecAttribute, BoxSpec>(
    //             trigger: trigger,
    //             phases: const [false, true],
    //             phaseBuilder: (phase) => Style(
    //               $box.transform(Matrix4.identity()..scale(phase ? 2.0 : 1.0)),
    //             ),
    //             animation: (phase) => const SpecPhaseAnimationData(
    //               duration: Duration(milliseconds: 100),
    //               curve: Curves.linear,
    //             ),
    //             builder: (context, style, phase) {
    //               return Box(style: style);
    //             },
    //           );
    //         },
    //       ),
    //     ),
    //   );

    //   trigger++;
    //   await tester.pump();
    //   await tester.pump(const Duration(milliseconds: 50));

    //   // Animation should be midway
    //   await tester.pump(const Duration(milliseconds: 50));

    //   // Animation should be complete
    //   expect(find.byType(Box), findsOneWidget);
    // });

    // testWidgets('handles delayed animations', (tester) async {
    //   await tester.pumpWidget(
    //     MaterialApp(
    //       home: SpecBuilder(
    //         builder: (context) {
    //           return SpecPhaseAnimator<bool, BoxSpecAttribute, BoxSpec>(
    //             phases: const [false, true],
    //             phaseBuilder: (phase) => Style(
    //               $box.transform(Matrix4.identity()..scale(phase ? 2.0 : 1.0)),
    //             ),
    //             animation: (phase) => SpecPhaseAnimationData(
    //               duration: const Duration(milliseconds: 100),
    //               curve: Curves.linear,
    //               delay: phase ? const Duration(milliseconds: 50) : Duration.zero,
    //             ),
    //             builder: (context, style, phase) {
    //               return Box(style: style);
    //             },
    //           );
    //         },
    //       ),
    //     ),
    //   );

    //   await tester.pump();
    //   await tester.pump(const Duration(milliseconds: 50)); // Wait for delay
    //   await tester.pump(const Duration(milliseconds: 100)); // Wait for animation

    //   expect(find.byType(Box), findsOneWidget);
    // });
  });
}
