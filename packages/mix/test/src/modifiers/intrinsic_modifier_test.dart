import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../helpers/testing_utils.dart';

void main() {
  // IntrinsicHeightWidgetDecoratorSpec
  group('IntrinsicHeightWidgetDecoratorSpec', () {
    test('lerp', () {
      const spec = IntrinsicHeightWidgetDecorator();
      const other = IntrinsicHeightWidgetDecorator();
      final result = spec.lerp(other, 0.5);
      expect(result, spec);
    });

    test('copyWith', () {
      const spec = IntrinsicHeightWidgetDecorator();
      final result = spec.copyWith();
      expect(result, spec);
    });

    testWidgets('build', (tester) async {
      const modifier = IntrinsicHeightWidgetDecorator();

      await tester.pumpMaterialApp(modifier.build(Container()));

      final IntrinsicHeight intrinsicHeight = tester.widget(
        find.byType(IntrinsicHeight),
      );

      expect(find.byType(IntrinsicHeight), findsOneWidget);

      expect(intrinsicHeight.child, isA<Container>());
    });

    // equality
    test('equality', () {
      const spec = IntrinsicHeightWidgetDecorator();
      const other = IntrinsicHeightWidgetDecorator();
      expect(spec, other);
    });
  });

  // IntrinsicHeightWidgetDecoratorMix
  group('IntrinsicHeightWidgetDecoratorMix', () {
    test('merge', () {
      const modifier = IntrinsicHeightWidgetDecoratorMix();
      const other = IntrinsicHeightWidgetDecoratorMix();
      final result = modifier.merge(other);
      expect(result, modifier);
    });

    test('resolve', () {
      const modifier = IntrinsicHeightWidgetDecoratorMix();
      expect(modifier, resolvesTo(const IntrinsicHeightWidgetDecorator()));
    });

    // equality
    test('equality', () {
      const modifier = IntrinsicHeightWidgetDecoratorMix();
      const other = IntrinsicHeightWidgetDecoratorMix();
      expect(modifier, other);
    });
  });

  // IntrinsicWidthWidgetDecoratorSpec
  group('IntrinsicWidthWidgetDecoratorSpec', () {
    test('lerp', () {
      const spec = IntrinsicWidthWidgetDecorator();
      const other = IntrinsicWidthWidgetDecorator();
      final result = spec.lerp(other, 0.5);
      expect(result, spec);
    });

    test('copyWith', () {
      const spec = IntrinsicWidthWidgetDecorator();
      final result = spec.copyWith();
      expect(result, spec);
    });

    // equality
    test('equality', () {
      const spec = IntrinsicWidthWidgetDecorator();
      const other = IntrinsicWidthWidgetDecorator();
      expect(spec, other);
    });

    testWidgets('build', (tester) async {
      const modifier = IntrinsicWidthWidgetDecorator();

      await tester.pumpMaterialApp(modifier.build(Container()));

      final IntrinsicWidth intrinsicWidth = tester.widget(
        find.byType(IntrinsicWidth),
      );

      expect(find.byType(IntrinsicWidth), findsOneWidget);

      expect(intrinsicWidth.child, isA<Container>());
    });
  });

  // IntrinsicWidthWidgetDecoratorMix
  group('IntrinsicWidthWidgetDecoratorMix', () {
    test('merge', () {
      const modifier = IntrinsicWidthWidgetDecoratorMix();
      const other = IntrinsicWidthWidgetDecoratorMix();
      final result = modifier.merge(other);
      expect(result, modifier);
    });

    test('resolve', () {
      const modifier = IntrinsicWidthWidgetDecoratorMix();
      expect(modifier, resolvesTo(const IntrinsicWidthWidgetDecorator()));
    });

    // equality
    test('equality', () {
      const modifier = IntrinsicWidthWidgetDecoratorMix();
      const other = IntrinsicWidthWidgetDecoratorMix();
      expect(modifier, other);
    });
  });
}
