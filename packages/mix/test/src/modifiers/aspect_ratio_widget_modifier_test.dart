import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../helpers/custom_matchers.dart';

void main() {
  group('AspectRatioModifierSpec', () {
    test('Constructor assigns aspectRatio correctly', () {
      const aspectRatio = 2.0;
      const modifier = AspectRatioModifier(aspectRatio);

      expect(modifier.aspectRatio, aspectRatio);
    });

    test('Lerp method interpolates correctly', () {
      const start = AspectRatioModifier(1.0);
      const end = AspectRatioModifier(3.0);
      final result = start.lerp(end, 0.5);

      expect(result.aspectRatio, 2.0);
    });

    test('Equality and hashcode test', () {
      const modifier1 = AspectRatioModifier(1.0);
      const modifier2 = AspectRatioModifier(1.0);
      const modifier3 = AspectRatioModifier(2.0);

      expect(modifier1, modifier2);
      expect(modifier1.hashCode, modifier2.hashCode);
      expect(modifier1 == modifier3, false);
      expect(modifier1.hashCode == modifier3.hashCode, false);
    });

    testWidgets(
      'Build method creates AspectRatio widget with correct aspectRatio',
      (WidgetTester tester) async {
        const aspectRatio = 2.0;
        const modifier = AspectRatioModifier(aspectRatio);

        await tester.pumpMaterialApp(modifier.build(Container()));

        final AspectRatio aspectRatioWidget = tester.widget(
          find.byType(AspectRatio),
        );

        expect(find.byType(AspectRatio), findsOneWidget);
        expect(aspectRatioWidget.aspectRatio, aspectRatio);

        expect(aspectRatioWidget.child, isA<Container>());
        expect(aspectRatioWidget.aspectRatio, aspectRatio);
      },
    );
  });

  group('AspectRatioModifierAttribute', () {
    test('merge', () {
      const modifier = AspectRatioModifierAttribute(aspectRatio: 1.0);
      const other = AspectRatioModifierAttribute(aspectRatio: 1.0);
      final result = modifier.merge(other);
      expect(result, modifier);
    });

    test('resolve', () {
      const modifier = AspectRatioModifierAttribute(aspectRatio: 1.0);
      expect(modifier, resolvesTo(const AspectRatioModifier(1.0)));
    });

    test('equality', () {
      const modifier = AspectRatioModifierAttribute(aspectRatio: 1.0);
      const other = AspectRatioModifierAttribute(aspectRatio: 1.0);
      expect(modifier, other);
    });

    test('inequality', () {
      const modifier = AspectRatioModifierAttribute(aspectRatio: 1.0);
      const other = AspectRatioModifierAttribute(aspectRatio: 2.0);
      expect(modifier, isNot(equals(other)));
    });
  });
}
