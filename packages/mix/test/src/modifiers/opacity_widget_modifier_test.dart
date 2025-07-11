import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../helpers/custom_matchers.dart';
import '../../helpers/testing_utils.dart';

void main() {
  group('OpacityModifierSpec Tests', () {
    test('Constructor assigns opacity correctly', () {
      const opacity = 0.5;
      const modifier = OpacityModifierSpec(opacity);

      expect(modifier.opacity, opacity);
    });

    test('Lerp method interpolates correctly', () {
      const start = OpacityModifierSpec(0.0);
      const end = OpacityModifierSpec(1.0);
      final result = start.lerp(end, 0.5);

      expect(result.opacity, 0.5);
    });

    test('Equality and hashcode test', () {
      const modifier1 = OpacityModifierSpec(0.5);
      const modifier2 = OpacityModifierSpec(0.5);
      const modifier3 = OpacityModifierSpec(0.8);

      expect(modifier1, modifier2);
      expect(modifier1.hashCode, modifier2.hashCode);
      expect(modifier1 == modifier3, false);
      expect(modifier1.hashCode == modifier3.hashCode, false);
    });

    testWidgets(
      'Build method creates Opacity widget with correct opacity',
      (WidgetTester tester) async {
        const opacity = 0.5;
        const modifier = OpacityModifierSpec(opacity);

        await tester.pumpMaterialApp(modifier.build(Container()));

        final Opacity opacityWidget = tester.widget(find.byType(Opacity));

        expect(find.byType(Opacity), findsOneWidget);
        expect(opacityWidget.opacity, opacity);
        expect(opacityWidget.child, isA<Container>());
      },
    );
  });

  group('OpacityModifierSpecAttribute', () {
    test('merge', () {
      const modifier = OpacityModifierSpecAttribute(opacity: 0.5);
      const other = OpacityModifierSpecAttribute(opacity: 0.5);
      final result = modifier.merge(other);
      expect(result, modifier);
    });

    test('resolve', () {
      const modifier = OpacityModifierSpecAttribute(opacity: 0.5);
      const expectedSpec = OpacityModifierSpec(0.5);
      
      expect(modifier, resolvesTo(expectedSpec));
    });

    test('equality', () {
      const modifier = OpacityModifierSpecAttribute(opacity: 0.5);
      const other = OpacityModifierSpecAttribute(opacity: 0.5);
      expect(modifier, other);
    });

    test('inequality', () {
      const modifier = OpacityModifierSpecAttribute(opacity: 0.5);
      const other = OpacityModifierSpecAttribute(opacity: 0.8);
      expect(modifier == other, false);
    });
  });
}
