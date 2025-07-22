import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../helpers/testing_utils.dart';

void main() {
  group('AspectRatioModifier', () {
    test('constructor assigns aspectRatio correctly', () {
      const aspectRatio = 2.0;
      const modifier = AspectRatioModifier(aspectRatio);
      expect(modifier.aspectRatio, aspectRatio);
    });

    test('copyWith returns new instance with updated value', () {
      const original = AspectRatioModifier(1.0);
      final updated = original.copyWith(aspectRatio: 2.0);
      expect(updated.aspectRatio, 2.0);
      expect(updated, isNot(same(original)));
    });

    test('copyWith preserves original when null', () {
      const original = AspectRatioModifier(1.0);
      final updated = original.copyWith();
      expect(updated.aspectRatio, 1.0);
      expect(updated, isNot(same(original)));
    });

    test('lerp interpolates correctly', () {
      const start = AspectRatioModifier(1.0);
      const end = AspectRatioModifier(3.0);
      final result = start.lerp(end, 0.5);
      expect(result.aspectRatio, 2.0);
    });

    test('equality and hashCode', () {
      const modifier1 = AspectRatioModifier(1.0);
      const modifier2 = AspectRatioModifier(1.0);
      const modifier3 = AspectRatioModifier(2.0);
      expect(modifier1, modifier2);
      expect(modifier1.hashCode, modifier2.hashCode);
      expect(modifier1 == modifier3, false);
      expect(modifier1.hashCode == modifier3.hashCode, false);
    });

    test('props contains aspectRatio', () {
      const modifier = AspectRatioModifier(2.0);
      expect(modifier.props, [2.0]);
    });

    testWidgets('build creates AspectRatio widget with correct aspectRatio', (
      tester,
    ) async {
      const aspectRatio = 2.0;
      const modifier = AspectRatioModifier(aspectRatio);
      const child = SizedBox();
      await tester.pumpWithMixScope(modifier.build(child));
      final aspectRatioWidget = tester.widget<AspectRatio>(
        find.byType(AspectRatio),
      );
      expect(aspectRatioWidget.aspectRatio, aspectRatio);
      expect(aspectRatioWidget.child, isA<SizedBox>());
    });
  });

  group('AspectRatioModifierAttribute', () {
    test('constructor assigns aspectRatio', () {
      final attribute = AspectRatioModifierAttribute(aspectRatio: Prop(1.5));
      expect(attribute.aspectRatio, isProp(1.5));
    });

    test('merge returns correct attribute', () {
      final attr1 = AspectRatioModifierAttribute(aspectRatio: Prop(1.0));
      final attr2 = AspectRatioModifierAttribute(aspectRatio: Prop(2.0));
      final merged = attr1.merge(attr2);
      expect(merged.aspectRatio, isProp(2.0));
    });

    test('resolve returns correct modifier', () {
      final attribute = AspectRatioModifierAttribute(aspectRatio: Prop(1.5));
      final resolved = attribute.resolve(MockBuildContext());
      expect(resolved, isA<AspectRatioModifier>());
      expect(resolved.aspectRatio, 1.5);
    });

    test('equality', () {
      final attr1 = AspectRatioModifierAttribute(aspectRatio: Prop(1.0));
      final attr2 = AspectRatioModifierAttribute(aspectRatio: Prop(1.0));
      final attr3 = AspectRatioModifierAttribute(aspectRatio: Prop(2.0));
      expect(attr1, equals(attr2));
      expect(attr1, isNot(equals(attr3)));
    });
  });

  group('Integration', () {
    testWidgets('attribute resolves and builds correctly', (tester) async {
      final attribute = AspectRatioModifierAttribute(aspectRatio: Prop(2.5));
      final modifier = attribute.resolve(MockBuildContext());
      const child = SizedBox();
      await tester.pumpWithMixScope(modifier.build(child));
      final aspectRatioWidget = tester.widget<AspectRatio>(
        find.byType(AspectRatio),
      );
      expect(aspectRatioWidget.aspectRatio, 2.5);
      expect(aspectRatioWidget.child, isA<SizedBox>());
    });
  });
}
