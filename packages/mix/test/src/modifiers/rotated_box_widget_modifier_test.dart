import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/src/modifiers/rotated_box_widget_modifier.dart';

import '../../helpers/custom_matchers.dart';

void main() {
  group('RotateModifierSpec', () {
    test('Constructor assigns quarterTurns correctly', () {
      const quarterTurns = 1;
      const modifier = RotatedBoxModifier(quarterTurns);

      expect(modifier.quarterTurns, quarterTurns);
    });

    test('Lerp method interpolates correctly', () {
      const start = RotatedBoxModifier(0);
      const end = RotatedBoxModifier(4);
      final result = start.lerp(end, 0.5);

      expect(result.quarterTurns, 2);
    });

    test('Equality and hashcode test', () {
      const modifier1 = RotatedBoxModifier(1);
      const modifier2 = RotatedBoxModifier(1);
      const modifier3 = RotatedBoxModifier(2);

      expect(modifier1, modifier2);
      expect(modifier1.hashCode, modifier2.hashCode);
      expect(modifier1 == modifier3, false);
      expect(modifier1.hashCode == modifier3.hashCode, false);
    });

    testWidgets(
      'Build method creates RotatedBox widget with correct quarterTurns',
      (WidgetTester tester) async {
        const quarterTurns = 1;
        const modifier = RotatedBoxModifier(quarterTurns);

        await tester.pumpMaterialApp(modifier.build(Container()));

        final RotatedBox rotatedBoxWidget = tester.widget(
          find.byType(RotatedBox),
        );

        expect(find.byType(RotatedBox), findsOneWidget);
        expect(rotatedBoxWidget.quarterTurns, quarterTurns);
        expect(rotatedBoxWidget.child, isA<Container>());
      },
    );
  });

  group('RotateModifierAttribute', () {
    test('merge', () {
      const modifier = RotatedBoxModifierAttribute(quarterTurns: 1);
      const other = RotatedBoxModifierAttribute(quarterTurns: 1);
      final result = modifier.merge(other);
      expect(result, modifier);
    });

    test('resolve', () {
      const modifier = RotatedBoxModifierAttribute(quarterTurns: 1);
      expect(modifier, resolvesTo(const RotatedBoxModifier(1)));
    });

    test('equality', () {
      const modifier = RotatedBoxModifierAttribute(quarterTurns: 1);
      const other = RotatedBoxModifierAttribute(quarterTurns: 1);
      expect(modifier, other);
    });

    // inequality
    test('inequality', () {
      const modifier = RotatedBoxModifierAttribute(quarterTurns: 1);
      const other = RotatedBoxModifierAttribute(quarterTurns: 2);
      expect(modifier, isNot(other));
    });
  });
}
