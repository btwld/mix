import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../helpers/custom_matchers.dart';

void main() {
  group('PaddingSpec', () {
    test('lerp returns correct PaddingSpec', () {
      const padding1 = EdgeInsets.all(10.0);
      const padding2 = EdgeInsets.all(20.0);
      const spec1 = PaddingModifier(padding1);
      const spec2 = PaddingModifier(padding2);

      final result = spec1.lerp(spec2, 0.5);

      expect(result.padding, equals(const EdgeInsets.all(15.0)));
    });

    test('lerp behaves like EdgeInsets.lerp', () {
      const padding = EdgeInsets.all(10.0);
      const padding2 = EdgeInsets.all(20.0);
      const padding3 = EdgeInsets.all(30.0);
      const spec = PaddingModifier(padding);
      const spec2 = PaddingModifier(padding2);
      const spec3 = PaddingModifier(padding3);

      final lerp1 = spec.lerp(null, 0.5);
      final lerp2 = spec.lerp(spec2, 0.5);
      final lerp3 = spec.lerp(spec3, 0.5);

      final insets2 = EdgeInsets.lerp(padding, padding2, 0.5);
      final insets3 = EdgeInsets.lerp(padding, padding3, 0.5);

      expect(lerp1.padding, equals(spec.padding));
      expect(lerp2.padding, equals(insets2));
      expect(lerp3.padding, equals(insets3));
    });

    test('copyWith returns new PaddingSpec with updated padding', () {
      const padding1 = EdgeInsets.all(10.0);
      const padding2 = EdgeInsets.all(20.0);
      const spec = PaddingModifier(padding1);

      final result = spec.copyWith(padding: padding2);

      expect(result.padding, equals(padding2));
    });

    test('copyWith returns original PaddingSpec when padding is null', () {
      const padding = EdgeInsets.all(10.0);
      const spec = PaddingModifier(padding);

      final result = spec.copyWith();

      expect(result.padding, equals(padding));
    });

    testWidgets('build returns Padding widget with correct padding', (
      WidgetTester tester,
    ) async {
      const padding = EdgeInsets.all(10.0);
      const spec = PaddingModifier(padding);
      const child = SizedBox();

      await tester.pumpWidget(spec.build(child));

      final paddingWidget = tester.widget<Padding>(find.byType(Padding));
      expect(paddingWidget.padding, equals(padding));
    });
  });

  group('PaddingModifierAttribute', () {
    test('merge returns correct PaddingModifierAttribute', () {
      final padding1 = EdgeInsetsDto.all(10.0);
      final padding2 = EdgeInsetsDto.all(20.0);

      final attribute1 = PaddingModifierAttribute(padding: padding1);
      final attribute2 = PaddingModifierAttribute(padding: padding2);

      final result = attribute1.merge(attribute2);

      expect(result.padding, equals(padding2));
    });

    test('deep merge returns correct PaddingModifierAttribute', () {
      final padding1 = EdgeInsetsDto(top: 1, bottom: 2, left: 3, right: 4);
      final padding2 = EdgeInsetsDto(top: 4, bottom: 3);

      final attribute1 = PaddingModifierAttribute(padding: padding1);
      final attribute2 = PaddingModifierAttribute(padding: padding2);

      final result = attribute1.merge(attribute2);

      expect(
        result.padding,
        equals(EdgeInsetsDto(top: 4, bottom: 3, left: 3, right: 4)),
      );
    });

    test(
      'merge returns original PaddingModifierAttribute when other is null',
      () {
        final padding = EdgeInsetsDto.all(10.0);
        final attribute = PaddingModifierAttribute(padding: padding);

        final result = attribute.merge(null);

        expect(result.padding, equals(padding));
      },
    );

    test('resolve returns correct PaddingSpec', () {
      final padding = EdgeInsetsDto.all(10.0);
      final attribute = PaddingModifierAttribute(padding: padding);

      expect(
        attribute,
        resolvesTo(const PaddingModifier(EdgeInsets.all(10.0))),
      );
    });

    test('props returns list with padding', () {
      final padding = EdgeInsetsDto.all(10.0);
      final attribute = PaddingModifierAttribute(padding: padding);

      expect(attribute.props, equals([padding]));
    });
  });
}
