import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import 'package:examples/api/animation/phase.compress.dart' as phase;

void main() {
  group('BlockAnimation (phase.compress)', () {
    Widget buildTestWidget() {
      return const MaterialApp(
        home: Scaffold(body: Center(child: phase.BlockAnimation())),
      );
    }

    Color? getBoxColor(WidgetTester tester) {
      final containers = tester.widgetList<Container>(find.byType(Container));
      for (final c in containers) {
        if (c.decoration case BoxDecoration(:final color?)) {
          return color;
        }
      }
      return null;
    }

    testWidgets('renders with GestureDetector.behavior = opaque', (
      tester,
    ) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      final gestureDetector = tester.widget<GestureDetector>(
        find.byType(GestureDetector).first,
      );
      expect(gestureDetector.behavior, HitTestBehavior.opaque);
      expect(find.byType(Box), findsOneWidget);
    });

    testWidgets('initial state shows deepPurple color', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      final color = getBoxColor(tester);
      expect(color, Colors.deepPurple);
    });

    testWidgets(
      'tap triggers phase animation - color changes during animation',
      (tester) async {
        await tester.pumpWidget(buildTestWidget());
        await tester.pumpAndSettle();

        final initialColor = getBoxColor(tester);
        expect(initialColor, Colors.deepPurple);

        // Tap to trigger the animation
        await tester.tap(find.byType(GestureDetector).first);
        await tester.pump();

        // Pump partway through the animation and check for color change
        bool colorChanged = false;
        for (int i = 0; i < 20; i++) {
          await tester.pump(const Duration(milliseconds: 50));
          final color = getBoxColor(tester);
          if (color != initialColor) {
            colorChanged = true;
            break;
          }
        }

        expect(
          colorChanged,
          isTrue,
          reason: 'Color should change during phase animation after tap',
        );
      },
    );

    testWidgets('phaseAnimation cycles through phases and returns to initial', (
      tester,
    ) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      final initialColor = getBoxColor(tester);

      // Tap to trigger
      await tester.tap(find.byType(GestureDetector).first);
      await tester.pump();

      // Collect intermediate colors
      final colors = <Color?>[];
      for (int i = 0; i < 30; i++) {
        await tester.pump(const Duration(milliseconds: 50));
        colors.add(getBoxColor(tester));
      }

      // Should have seen some non-initial colors (compress/expanded phases)
      final nonInitialColors = colors
          .where((c) => c != null && c != initialColor)
          .toList();
      expect(
        nonInitialColors,
        isNotEmpty,
        reason: 'Should see intermediate phase colors during animation',
      );

      // After full animation completes, cycles back to initial
      await tester.pumpAndSettle();
      final finalColor = getBoxColor(tester);
      expect(
        finalColor,
        initialColor,
        reason: 'phaseAnimation cycles back to initial state',
      );
    });

    testWidgets('multiple taps each trigger a new animation cycle', (
      tester,
    ) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      final initialColor = getBoxColor(tester);

      // First tap
      await tester.tap(find.byType(GestureDetector).first);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      final afterFirstTap = getBoxColor(tester);
      expect(
        afterFirstTap,
        isNot(equals(initialColor)),
        reason: 'First tap should start animation',
      );

      // Let it complete
      await tester.pumpAndSettle();

      // Second tap
      await tester.tap(find.byType(GestureDetector).first);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      final afterSecondTap = getBoxColor(tester);
      expect(
        afterSecondTap,
        isNot(equals(initialColor)),
        reason: 'Second tap should also trigger animation',
      );
    });
  });
}
