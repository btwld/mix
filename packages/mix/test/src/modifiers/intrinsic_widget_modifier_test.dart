import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../helpers/custom_matchers.dart';

void main() {
  // IntrinsicHeightModifierSpec
  group('IntrinsicHeightModifierSpec', () {
    test('lerp', () {
      const spec = IntrinsicHeightModifier();
      const other = IntrinsicHeightModifier();
      final result = spec.lerp(other, 0.5);
      expect(result, spec);
    });

    test('copyWith', () {
      const spec = IntrinsicHeightModifier();
      final result = spec.copyWith();
      expect(result, spec);
    });

    testWidgets('build', (tester) async {
      const modifier = IntrinsicHeightModifier();

      await tester.pumpMaterialApp(modifier.build(Container()));

      final IntrinsicHeight intrinsicHeight = tester.widget(
        find.byType(IntrinsicHeight),
      );

      expect(find.byType(IntrinsicHeight), findsOneWidget);

      expect(intrinsicHeight.child, isA<Container>());
    });

    // equality
    test('equality', () {
      const spec = IntrinsicHeightModifier();
      const other = IntrinsicHeightModifier();
      expect(spec, other);
    });
  });

  // IntrinsicHeightModifierAttribute
  group('IntrinsicHeightModifierAttribute', () {
    test('merge', () {
      const modifier = IntrinsicHeightModifierAttribute();
      const other = IntrinsicHeightModifierAttribute();
      final result = modifier.merge(other);
      expect(result, modifier);
    });

    test('resolve', () {
      const modifier = IntrinsicHeightModifierAttribute();
      expect(modifier, resolvesTo(const IntrinsicHeightModifier()));
    });

    // equality
    test('equality', () {
      const modifier = IntrinsicHeightModifierAttribute();
      const other = IntrinsicHeightModifierAttribute();
      expect(modifier, other);
    });
  });

  // IntrinsicWidthModifierSpec
  group('IntrinsicWidthModifierSpec', () {
    test('lerp', () {
      const spec = IntrinsicWidthModifier();
      const other = IntrinsicWidthModifier();
      final result = spec.lerp(other, 0.5);
      expect(result, spec);
    });

    test('copyWith', () {
      const spec = IntrinsicWidthModifier();
      final result = spec.copyWith();
      expect(result, spec);
    });

    // equality
    test('equality', () {
      const spec = IntrinsicWidthModifier();
      const other = IntrinsicWidthModifier();
      expect(spec, other);
    });

    testWidgets('build', (tester) async {
      const modifier = IntrinsicWidthModifier();

      await tester.pumpMaterialApp(modifier.build(Container()));

      final IntrinsicWidth intrinsicWidth = tester.widget(
        find.byType(IntrinsicWidth),
      );

      expect(find.byType(IntrinsicWidth), findsOneWidget);

      expect(intrinsicWidth.child, isA<Container>());
    });
  });

  // IntrinsicWidthModifierAttribute
  group('IntrinsicWidthModifierAttribute', () {
    test('merge', () {
      const modifier = IntrinsicWidthModifierAttribute();
      const other = IntrinsicWidthModifierAttribute();
      final result = modifier.merge(other);
      expect(result, modifier);
    });

    test('resolve', () {
      const modifier = IntrinsicWidthModifierAttribute();
      expect(modifier, resolvesTo(const IntrinsicWidthModifier()));
    });

    // equality
    test('equality', () {
      const modifier = IntrinsicWidthModifierAttribute();
      const other = IntrinsicWidthModifierAttribute();
      expect(modifier, other);
    });
  });
}
