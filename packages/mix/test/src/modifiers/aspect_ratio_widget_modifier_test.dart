import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/src/modifiers/aspect_ratio_widget_modifier.dart';

import '../../helpers/testing_utils.dart';

void main() {
  group('AspectRatioModifierSpec', () {
    test('Constructor assigns aspectRatio correctly', () {
      const aspectRatio = 2.0;
      const modifier = AspectRatioModifierSpec(aspectRatio);

      expect(modifier.aspectRatio, aspectRatio);
    });

    test('Lerp method interpolates correctly', () {
      const start = AspectRatioModifierSpec(1.0);
      const end = AspectRatioModifierSpec(3.0);
      final result = start.lerp(end, 0.5);

      expect(result.aspectRatio, 2.0);
    });

    test('Equality and hashcode test', () {
      const modifier1 = AspectRatioModifierSpec(1.0);
      const modifier2 = AspectRatioModifierSpec(1.0);
      const modifier3 = AspectRatioModifierSpec(2.0);

      expect(modifier1, modifier2);
      expect(modifier1.hashCode, modifier2.hashCode);
      expect(modifier1 == modifier3, false);
      expect(modifier1.hashCode == modifier3.hashCode, false);
    });

    testWidgets(
      'Build method creates AspectRatio widget with correct aspectRatio',
      (WidgetTester tester) async {
        const aspectRatio = 2.0;
        const modifier = AspectRatioModifierSpec(aspectRatio);

        await tester.pumpMaterialApp(modifier.build(Container()));

        final AspectRatio aspectRatioWidget =
            tester.widget(find.byType(AspectRatio));

        expect(find.byType(AspectRatio), findsOneWidget);
        expect(aspectRatioWidget.aspectRatio, aspectRatio);

        expect(aspectRatioWidget.child, isA<Container>());
        expect(aspectRatioWidget.aspectRatio, aspectRatio);
      },
    );
  });

  group('AspectRatioModifierAttribute', () {
    test('merge', () {
      const modifier = AspectRatioModifierAttribute(1.0);
      const other = AspectRatioModifierAttribute(1.0);
      final result = modifier.merge(other);
      expect(result, modifier);
    });

    test('resolve', () {
      const modifier = AspectRatioModifierAttribute(1.0);
      final result = modifier.resolve(EmptyMixData);
      expect(result, isA<AspectRatioModifierSpec>());
    });

    test('equality', () {
      const modifier = AspectRatioModifierAttribute(1.0);
      const other = AspectRatioModifierAttribute(1.0);
      expect(modifier, other);
    });

    test('inequality', () {
      const modifier = AspectRatioModifierAttribute(1.0);
      const other = AspectRatioModifierAttribute(2.0);
      expect(modifier, isNot(equals(other)));
    });
  });
}
