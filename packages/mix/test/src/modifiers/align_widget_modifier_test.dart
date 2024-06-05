import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/src/modifiers/align_widget_modifier.dart';

import '../../helpers/testing_utils.dart';

void main() {
  group('AlignModifierAttribute', () {
    test('merge', () {
      const modifier = AlignModifierAttribute();
      const other = AlignModifierAttribute();
      final result = modifier.merge(other);
      expect(result, modifier);
    });

    test('resolve', () {
      const modifier = AlignModifierAttribute();
      final result = modifier.resolve(EmptyMixData);
      expect(result, isA<AlignModifierSpec>());
    });

    // equality
    test('equality', () {
      const modifier = AlignModifierAttribute(
          alignment: Alignment.center, widthFactor: 0.5, heightFactor: 0.5);
      const other = AlignModifierAttribute(
          alignment: Alignment.center, widthFactor: 0.5, heightFactor: 0.5);
      expect(modifier, other);
    });

    test('inequality', () {
      const modifier = AlignModifierAttribute(
          alignment: Alignment.topCenter, widthFactor: 0.5, heightFactor: 0.5);
      const other = AlignModifierAttribute(
          alignment: Alignment.center, widthFactor: 0.5, heightFactor: 0.5);
      expect(modifier, isNot(equals(other)));
    });
  });

  group('AlignModifierSpec Tests', () {
    const alignment = Alignment.center;
    const alignment2 = Alignment.bottomRight;

    test('Constructor assigns alignment correctly', () {
      const modifier = AlignModifierSpec(alignment: alignment);

      expect(modifier.alignment, alignment);
    });

    test('Lerp method interpolates correctly', () {
      const start = AlignModifierSpec(alignment: alignment);
      const end = AlignModifierSpec(alignment: alignment2);
      final result = start.lerp(end, 0.5);

      expect(result.alignment, const Alignment(0.5, 0.5));
    });

    test('Equality and hashcode test', () {
      const modifier1 = AlignModifierSpec(alignment: alignment);
      const modifier2 = AlignModifierSpec(alignment: alignment);
      const modifier3 = AlignModifierSpec(alignment: alignment2);

      expect(modifier1, modifier2);
      expect(modifier1.hashCode, modifier2.hashCode);
      expect(modifier1 == modifier3, false);
      expect(modifier1.hashCode == modifier3.hashCode, false);
    });

    testWidgets(
      'Build method creates Align widget with correct alignment',
      (WidgetTester tester) async {
        const modifier = AlignModifierSpec(alignment: alignment);

        await tester.pumpMaterialApp(modifier.build(Container()));

        final Align alignWidget = tester.widget(find.byType(Align));

        expect(find.byType(Align), findsOneWidget);
        expect(alignWidget.alignment, alignment);
        expect(alignWidget.child, isA<Container>());
      },
    );
  });
}
