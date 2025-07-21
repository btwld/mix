import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/src/modifiers/visibility_widget_modifier.dart';

import '../../helpers/custom_matchers.dart';

void main() {
  group('VisibilityModifierSpec Tests', () {
    test('Constructor assigns visible correctly', () {
      const visible = true;
      const modifier = VisibilityModifierAttribute(visible: visible);

      expect(modifier.visible, visible);
    });

    test('Lerp method interpolates correctly', () {
      const start = VisibilityModifier(true);
      const end = VisibilityModifier(false);
      final afterResult = start.lerp(end, 0.5);
      final beforeResult = start.lerp(end, 0.49);

      expect(beforeResult.visible, true);
      expect(afterResult.visible, false);
    });

    test('Equality and hashcode test', () {
      const modifier1 = VisibilityModifier(true);
      const modifier2 = VisibilityModifier(true);
      const modifier3 = VisibilityModifier(false);

      expect(modifier1, modifier2);
      expect(modifier1.hashCode, modifier2.hashCode);
      expect(modifier1 == modifier3, false);
      expect(modifier1.hashCode == modifier3.hashCode, false);
    });

    testWidgets(
      'Build method creates Visibility widget with correct visible property',
      (WidgetTester tester) async {
        const visible = true;
        const modifier = VisibilityModifier(visible);

        await tester.pumpMaterialApp(modifier.build(Container()));

        final Visibility visibilityWidget = tester.widget(
          find.byType(Visibility),
        );

        expect(find.byType(Visibility), findsOneWidget);
        expect(visibilityWidget.visible, visible);
        expect(visibilityWidget.child, isA<Container>());
      },
    );
  });

  group('VisibilityModifierAttribute', () {
    test('merge', () {
      const modifier = VisibilityModifierAttribute(visible: true);
      const other = VisibilityModifierAttribute(visible: true);
      final result = modifier.merge(other);
      expect(result, modifier);
    });

    test('resolve', () {
      const modifier = VisibilityModifierAttribute(visible: true);
      expect(modifier, resolvesTo(const VisibilityModifier(true)));
    });

    // equality
    test('equality', () {
      const modifier = VisibilityModifierAttribute(visible: true);
      const other = VisibilityModifierAttribute(visible: true);
      expect(modifier, other);
    });

    test('inequality', () {
      const modifier = VisibilityModifierAttribute(visible: true);
      const other = VisibilityModifierAttribute(visible: false);
      expect(modifier, isNot(equals(other)));
    });
  });
}
