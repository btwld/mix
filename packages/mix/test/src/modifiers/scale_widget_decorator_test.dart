import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../helpers/testing_utils.dart';

void main() {
  group('ScaleModifierSpec', () {
    test('Constructor assigns scale correctly', () {
      const scale = 1.5;
      final modifier = $with.transform.scale(scale);

      final spec =
          modifier.resolve(MockMixData(Style(modifier)))
              as TransformModifierSpec;

      expect(spec.transform, Matrix4.diagonal3Values(scale, scale, 1));
    });

    testWidgets(
      'Build method creates Transform.scale widget with correct scale',
      (WidgetTester tester) async {
        const scale = 1.5;

        final modifier = $with.transform.scale(scale);

        final spec = modifier.resolve(MockMixData(Style(modifier)));

        await tester.pumpMaterialApp(spec.build(Container()));

        final Transform transformWidget = tester.widget(find.byType(Transform));

        expect(find.byType(Transform), findsOneWidget);
        expect(
          transformWidget.transform,
          Matrix4.diagonal3Values(scale, scale, 1.0),
        );
        expect(transformWidget.child, isA<Container>());
      },
    );
  });
}
