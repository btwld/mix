import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../helpers/testing_utils.dart';

void main() {
  // IntrinsicHeightWidgetModifierSpec
  group('IntrinsicHeightWidgetModifierSpec', () {
    test('lerp', () {
      const spec = IntrinsicHeightWidgetModifier();
      const other = IntrinsicHeightWidgetModifier();
      final result = spec.lerp(other, 0.5);
      expect(result, spec);
    });

    test('copyWith', () {
      const spec = IntrinsicHeightWidgetModifier();
      final result = spec.copyWith();
      expect(result, spec);
    });

    testWidgets('build', (tester) async {
      const modifier = IntrinsicHeightWidgetModifier();

      await tester.pumpMaterialApp(modifier.build(Container()));

      final IntrinsicHeight intrinsicHeight = tester.widget(
        find.byType(IntrinsicHeight),
      );

      expect(find.byType(IntrinsicHeight), findsOneWidget);

      expect(intrinsicHeight.child, isA<Container>());
    });

    // equality
    test('equality', () {
      const spec = IntrinsicHeightWidgetModifier();
      const other = IntrinsicHeightWidgetModifier();
      expect(spec, other);
    });
  });

  // IntrinsicHeightWidgetModifierMix
  group('IntrinsicHeightWidgetModifierMix', () {
    test('merge', () {
      const modifier = IntrinsicHeightWidgetModifierMix();
      const other = IntrinsicHeightWidgetModifierMix();
      final result = modifier.merge(other);
      expect(result, modifier);
    });

    test('resolve', () {
      const modifier = IntrinsicHeightWidgetModifierMix();
      expect(modifier, resolvesTo(const IntrinsicHeightWidgetModifier()));
    });

    // equality
    test('equality', () {
      const modifier = IntrinsicHeightWidgetModifierMix();
      const other = IntrinsicHeightWidgetModifierMix();
      expect(modifier, other);
    });
  });

  // IntrinsicWidthWidgetModifierSpec
  group('IntrinsicWidthWidgetModifierSpec', () {
    test('lerp', () {
      const spec = IntrinsicWidthWidgetModifier();
      const other = IntrinsicWidthWidgetModifier();
      final result = spec.lerp(other, 0.5);
      expect(result, spec);
    });

    test('copyWith', () {
      const spec = IntrinsicWidthWidgetModifier();
      final result = spec.copyWith();
      expect(result, spec);
    });

    // equality
    test('equality', () {
      const spec = IntrinsicWidthWidgetModifier();
      const other = IntrinsicWidthWidgetModifier();
      expect(spec, other);
    });

    testWidgets('build', (tester) async {
      const modifier = IntrinsicWidthWidgetModifier();

      await tester.pumpMaterialApp(modifier.build(Container()));

      final IntrinsicWidth intrinsicWidth = tester.widget(
        find.byType(IntrinsicWidth),
      );

      expect(find.byType(IntrinsicWidth), findsOneWidget);

      expect(intrinsicWidth.child, isA<Container>());
    });
  });

  // IntrinsicWidthWidgetModifierMix
  group('IntrinsicWidthWidgetModifierMix', () {
    test('merge', () {
      const modifier = IntrinsicWidthWidgetModifierMix();
      const other = IntrinsicWidthWidgetModifierMix();
      final result = modifier.merge(other);
      expect(result, modifier);
    });

    test('resolve', () {
      const modifier = IntrinsicWidthWidgetModifierMix();
      expect(modifier, resolvesTo(const IntrinsicWidthWidgetModifier()));
    });

    // equality
    test('equality', () {
      const modifier = IntrinsicWidthWidgetModifierMix();
      const other = IntrinsicWidthWidgetModifierMix();
      expect(modifier, other);
    });
  });
}
