import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../helpers/testing_utils.dart';

void main() {
  group('AspectRatioWidgetDecorator', () {
    test('constructor assigns aspectRatio correctly', () {
      const aspectRatio = 2.0;
      const decorator = AspectRatioWidgetDecorator(aspectRatio);
      expect(decorator.aspectRatio, aspectRatio);
    });

    test('copyWith returns new instance with updated value', () {
      const original = AspectRatioWidgetDecorator(1.0);
      final updated = original.copyWith(aspectRatio: 2.0);
      expect(updated.aspectRatio, 2.0);
      expect(updated, isNot(same(original)));
    });

    test('copyWith preserves original when null', () {
      const original = AspectRatioWidgetDecorator(1.0);
      final updated = original.copyWith();
      expect(updated.aspectRatio, 1.0);
      expect(updated, isNot(same(original)));
    });

    test('lerp interpolates correctly', () {
      const start = AspectRatioWidgetDecorator(1.0);
      const end = AspectRatioWidgetDecorator(3.0);
      final result = start.lerp(end, 0.5);
      expect(result.aspectRatio, 2.0);
    });

    test('equality and hashCode', () {
      const decorator1 = AspectRatioWidgetDecorator(1.0);
      const decorator2 = AspectRatioWidgetDecorator(1.0);
      const decorator3 = AspectRatioWidgetDecorator(2.0);
      expect(decorator1, decorator2);
      expect(decorator1.hashCode, decorator2.hashCode);
      expect(decorator1 == decorator3, false);
      expect(decorator1.hashCode == decorator3.hashCode, false);
    });

    test('props contains aspectRatio', () {
      const decorator = AspectRatioWidgetDecorator(2.0);
      expect(decorator.props, [2.0]);
    });

    testWidgets('build creates AspectRatio widget with correct aspectRatio', (
      tester,
    ) async {
      const aspectRatio = 2.0;
      const decorator = AspectRatioWidgetDecorator(aspectRatio);
      const child = SizedBox();
      await tester.pumpWithMixScope(decorator.build(child));
      final aspectRatioWidget = tester.widget<AspectRatio>(
        find.byType(AspectRatio),
      );
      expect(aspectRatioWidget.aspectRatio, aspectRatio);
      expect(aspectRatioWidget.child, isA<SizedBox>());
    });
  });

  group('AspectRatioWidgetDecoratorMix', () {
    test('constructor assigns aspectRatio', () {
      final attribute = AspectRatioWidgetDecoratorMix.raw(
        aspectRatio: Prop.value(1.5),
      );
      expectProp(attribute.aspectRatio, 1.5);
    });

    test('merge returns correct attribute', () {
      final attr1 = AspectRatioWidgetDecoratorMix.raw(
        aspectRatio: Prop.value(1.0),
      );
      final attr2 = AspectRatioWidgetDecoratorMix.raw(
        aspectRatio: Prop.value(2.0),
      );
      final merged = attr1.merge(attr2);
      expectProp(merged.aspectRatio, 2.0); // Prop uses replacement strategy
    });

    test('resolve returns correct modifier', () {
      final attribute = AspectRatioWidgetDecoratorMix.raw(
        aspectRatio: Prop.value(1.5),
      );
      expect(attribute, resolvesTo(const AspectRatioWidgetDecorator(1.5)));
    });

    test('equality', () {
      final attr1 = AspectRatioWidgetDecoratorMix.raw(
        aspectRatio: Prop.value(1.0),
      );
      final attr2 = AspectRatioWidgetDecoratorMix.raw(
        aspectRatio: Prop.value(1.0),
      );
      final attr3 = AspectRatioWidgetDecoratorMix.raw(
        aspectRatio: Prop.value(2.0),
      );
      expect(attr1, equals(attr2));
      expect(attr1, isNot(equals(attr3)));
    });
  });

  group('Integration', () {
    testWidgets('attribute resolves and builds correctly', (tester) async {
      final attribute = AspectRatioWidgetDecoratorMix.raw(
        aspectRatio: Prop.value(2.5),
      );
      expect(attribute, resolvesTo(const AspectRatioWidgetDecorator(2.5)));

      final decorator = attribute.resolve(MockBuildContext());
      const child = SizedBox();
      await tester.pumpWithMixScope(decorator.build(child));
      final aspectRatioWidget = tester.widget<AspectRatio>(
        find.byType(AspectRatio),
      );
      expect(aspectRatioWidget.aspectRatio, 2.5);
      expect(aspectRatioWidget.child, isA<SizedBox>());
    });
  });
}
