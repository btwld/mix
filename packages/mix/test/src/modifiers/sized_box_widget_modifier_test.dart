import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/src/core/utility.dart';
import 'package:mix/src/modifiers/sized_box_widget_modifier.dart';

import '../../helpers/testing_utils.dart';

void main() {
  group(
    'SizedBoxModifierSpec',
    () {
      test(
        'Constructor assigns width and height correctly',
        () {
          const width = 100.0;
          const height = 100.0;
          const modifier = SizedBoxModifierSpec(
            width: width,
            height: height,
          );

          expect(modifier.width, width);
          expect(modifier.height, height);
        },
      );

      test(
        'Lerp method interpolates correctly',
        () {
          const start = SizedBoxModifierSpec(
            width: 100.0,
            height: 100.0,
          );
          const end = SizedBoxModifierSpec(
            width: 200.0,
            height: 200.0,
          );
          final result = start.lerp(
            end,
            0.5,
          );

          expect(result.width, 150.0);
          expect(result.height, 150.0);
        },
      );

      test(
        'Equality and hashcode test',
        () {
          const modifier1 = SizedBoxModifierSpec(
            width: 100.0,
            height: 100.0,
          );
          const modifier2 = SizedBoxModifierSpec(
            width: 100.0,
            height: 100.0,
          );
          const modifier3 = SizedBoxModifierSpec(
            width: 100.0,
            height: 200.0,
          );

          expect(modifier1, modifier2);
          expect(modifier1.hashCode, modifier2.hashCode);
          expect(modifier1 == modifier3, false);
          expect(modifier1.hashCode == modifier3.hashCode, false);
        },
      );

      testWidgets(
        'Build method creates SizedBox widget with correct width and height',
        (WidgetTester tester) async {
          const width = 100.0;
          const height = 100.0;
          const modifier = SizedBoxModifierSpec(
            width: width,
            height: height,
          );

          await tester.pumpMaterialApp(
            modifier.build(
              Container(),
            ),
          );

          final SizedBox sizedBoxWidget = tester.widget(
            find.byType(
              SizedBox,
            ),
          );

          expect(
            find.byType(
              SizedBox,
            ),
            findsOneWidget,
          );
          expect(
            sizedBoxWidget.width,
            width,
          );
          expect(
            sizedBoxWidget.height,
            height,
          );
          expect(
            sizedBoxWidget.child,
            isA<Container>(),
          );
        },
      );
    },
  );

  group('SizedBoxModifierAttribute', () {
    test('Constructor assigns width and height correctly', () {
      const width = 100.0;
      const height = 100.0;
      const attribute = SizedBoxModifierAttribute(width: width, height: height);

      expect(attribute.width, width);
      expect(attribute.height, height);
    });

    test('Merge method merges correctly', () {
      const attribute1 = SizedBoxModifierAttribute(width: 100.0, height: 100.0);
      const attribute2 = SizedBoxModifierAttribute(width: 200.0, height: 200.0);
      final result = attribute1.merge(attribute2);

      expect(result.width, 200.0);
      expect(result.height, 200.0);
    });

    test('Resolve method resolves correctly', () {
      const attribute = SizedBoxModifierAttribute(width: 100.0, height: 100.0);

      final result = attribute.resolve(EmptyMixData);

      expect(result.width, 100.0);
      expect(result.height, 100.0);
    });

    test('Equality and hashcode test', () {
      const attribute1 = SizedBoxModifierAttribute(width: 100.0, height: 100.0);
      const attribute2 = SizedBoxModifierAttribute(width: 100.0, height: 100.0);
      const attribute3 = SizedBoxModifierAttribute(width: 100.0, height: 200.0);

      expect(attribute1, attribute2);
      expect(attribute1.hashCode, attribute2.hashCode);
      expect(attribute1 == attribute3, false);
      expect(attribute1.hashCode == attribute3.hashCode, false);
    });
  });

  group('SizedBoxModifierUtility', () {
    test('Call method returns correct SizedBoxModifierAttribute', () {
      const width = 100.0;
      const height = 100.0;
      const utility = SizedBoxModifierUtility(MixUtility.selfBuilder);
      final result = utility(width: width, height: height);

      expect(result.width, width);
      expect(result.height, height);
    });
  });
}
