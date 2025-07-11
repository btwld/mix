import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../helpers/custom_matchers.dart';
import '../../helpers/testing_utils.dart';

void main() {
  // IntrinsicHeightModifierSpec
  group('IntrinsicHeightModifierSpec', () {
    test('lerp', () {
      const spec = IntrinsicHeightModifierSpec();
      const other = IntrinsicHeightModifierSpec();
      final result = spec.lerp(other, 0.5);
      expect(result, spec);
    });

    test('copyWith', () {
      const spec = IntrinsicHeightModifierSpec();
      final result = spec.copyWith();
      expect(result, spec);
    });

    testWidgets('build', (tester) async {
      const modifier = IntrinsicHeightModifierSpec();

      await tester.pumpMaterialApp(modifier.build(Container()));

      final IntrinsicHeight intrinsicHeight =
          tester.widget(find.byType(IntrinsicHeight));

      expect(find.byType(IntrinsicHeight), findsOneWidget);

      expect(intrinsicHeight.child, isA<Container>());
    });

    // equality
    test('equality', () {
      const spec = IntrinsicHeightModifierSpec();
      const other = IntrinsicHeightModifierSpec();
      expect(spec, other);
    });
  });

  // IntrinsicHeightModifierSpecAttribute
  group('IntrinsicHeightModifierSpecAttribute', () {
    test('merge', () {
      const modifier = IntrinsicHeightModifierSpecAttribute();
      const other = IntrinsicHeightModifierSpecAttribute();
      final result = modifier.merge(other);
      expect(result, modifier);
    });

    test('resolve', () {
      const modifier = IntrinsicHeightModifierSpecAttribute();
      expect(modifier, resolvesTo(const IntrinsicHeightModifierSpec()));
    });

    // equality
    test('equality', () {
      const modifier = IntrinsicHeightModifierSpecAttribute();
      const other = IntrinsicHeightModifierSpecAttribute();
      expect(modifier, other);
    });
  });

  // IntrinsicWidthModifierSpec
  group('IntrinsicWidthModifierSpec', () {
    test('lerp', () {
      const spec = IntrinsicWidthModifierSpec();
      const other = IntrinsicWidthModifierSpec();
      final result = spec.lerp(other, 0.5);
      expect(result, spec);
    });

    test('copyWith', () {
      const spec = IntrinsicWidthModifierSpec();
      final result = spec.copyWith();
      expect(result, spec);
    });

    // equality
    test('equality', () {
      const spec = IntrinsicWidthModifierSpec();
      const other = IntrinsicWidthModifierSpec();
      expect(spec, other);
    });

    testWidgets('build', (tester) async {
      const modifier = IntrinsicWidthModifierSpec();

      await tester.pumpMaterialApp(modifier.build(Container()));

      final IntrinsicWidth intrinsicWidth =
          tester.widget(find.byType(IntrinsicWidth));

      expect(find.byType(IntrinsicWidth), findsOneWidget);

      expect(intrinsicWidth.child, isA<Container>());
    });
  });

  // IntrinsicWidthModifierAttribute
  group('IntrinsicWidthModifierSpecAttribute', () {
    test('merge', () {
      const modifier = IntrinsicWidthModifierSpecAttribute();
      const other = IntrinsicWidthModifierSpecAttribute();
      final result = modifier.merge(other);
      expect(result, modifier);
    });

    test('resolve', () {
      const modifier = IntrinsicWidthModifierSpecAttribute();
      expect(modifier, resolvesTo(const IntrinsicWidthModifierSpec()));
    });

    // equality
    test('equality', () {
      const modifier = IntrinsicWidthModifierSpecAttribute();
      const other = IntrinsicWidthModifierSpecAttribute();
      expect(modifier, other);
    });
  });
}
