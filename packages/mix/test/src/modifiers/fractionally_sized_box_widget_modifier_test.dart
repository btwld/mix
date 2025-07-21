import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../helpers/custom_matchers.dart';

void main() {
  // FractionallySizedBoxModifierSpec
  group('FractionallySizedBoxModifierSpec', () {
    test('Constructor assigns widthFactor and heightFactor correctly', () {
      const widthFactor = 0.5;
      const heightFactor = 0.5;
      const modifier = FractionallySizedBoxModifierSpec(
        widthFactor: widthFactor,
        heightFactor: heightFactor,
      );

      expect(modifier.widthFactor, widthFactor);
      expect(modifier.heightFactor, heightFactor);
    });

    test('Lerp method interpolates correctly', () {
      const start = FractionallySizedBoxModifierSpec(
        widthFactor: 0.5,
        heightFactor: 0.5,
      );
      const end = FractionallySizedBoxModifierSpec(
        widthFactor: 1.0,
        heightFactor: 1.0,
      );
      final result = start.lerp(end, 0.5);

      expect(result.widthFactor, 0.75);
      expect(result.heightFactor, 0.75);
    });

    test('Equality and hashcode test', () {
      const modifier1 = FractionallySizedBoxModifierSpec(
        widthFactor: 0.5,
        heightFactor: 0.5,
      );
      const modifier2 = FractionallySizedBoxModifierSpec(
        widthFactor: 0.5,
        heightFactor: 0.5,
      );
      const modifier3 = FractionallySizedBoxModifierSpec(
        widthFactor: 0.5,
        heightFactor: 0.6,
      );

      expect(modifier1, modifier2);
      expect(modifier1.hashCode, modifier2.hashCode);
      expect(modifier1 == modifier3, false);
      expect(modifier1.hashCode == modifier3.hashCode, false);
    });

    testWidgets(
      'Build method creates FractionallySizedBox widget with correct widthFactor and heightFactor',
      (WidgetTester tester) async {
        const widthFactor = 0.5;
        const heightFactor = 0.5;
        const modifier = FractionallySizedBoxModifierSpec(
          widthFactor: widthFactor,
          heightFactor: heightFactor,
        );

        await tester.pumpMaterialApp(modifier.build(Container()));

        final FractionallySizedBox fractionallySizedBoxWidget = tester.widget(
          find.byType(FractionallySizedBox),
        );

        expect(find.byType(FractionallySizedBox), findsOneWidget);
        expect(fractionallySizedBoxWidget.widthFactor, widthFactor);
        expect(fractionallySizedBoxWidget.heightFactor, heightFactor);
        expect(fractionallySizedBoxWidget.child, isA<Container>());
      },
    );
  });

  // FractionallySizedBoxModifierAttribute
  group('FractionallySizedBoxModifierAttribute', () {
    test('merge', () {
      const modifier = FractionallySizedBoxModifierAttribute(
        widthFactor: 0.5,
        heightFactor: 0.5,
      );
      const other = FractionallySizedBoxModifierAttribute(
        widthFactor: 0.5,
        heightFactor: 0.5,
      );
      final result = modifier.merge(other);
      expect(result, modifier);
    });

    test('resolve', () {
      const modifier = FractionallySizedBoxModifierAttribute(
        widthFactor: 0.5,
        heightFactor: 0.5,
      );
      expect(
        modifier,
        resolvesTo(
          const FractionallySizedBoxModifierSpec(
            widthFactor: 0.5,
            heightFactor: 0.5,
          ),
        ),
      );
    });

    test('equality', () {
      const modifier = FractionallySizedBoxModifierAttribute(
        widthFactor: 0.5,
        heightFactor: 0.5,
      );
      const other = FractionallySizedBoxModifierAttribute(
        widthFactor: 0.5,
        heightFactor: 0.5,
      );
      expect(modifier, other);
    });

    test('inequality', () {
      const modifier = FractionallySizedBoxModifierAttribute(
        widthFactor: 0.5,
        heightFactor: 0.5,
      );
      const other = FractionallySizedBoxModifierAttribute(
        widthFactor: 0.5,
        heightFactor: 0.6,
      );
      expect(modifier, isNot(equals(other)));
    });
  });
}
