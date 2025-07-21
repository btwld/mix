import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';
import 'package:mix/src/modifiers/internal/render_widget_modifier.dart';

void main() {
  group('orderSpecs', () {
    test('should order modifiers based on provided order', () {
      final orderOfModifiers = [
        ClipOvalModifier,
        TransformModifier,
        AlignModifier,
        OpacityModifier,
      ];
      final modifiers = <Modifier>[
        const OpacityModifier(1),
        const AlignModifier(alignment: Alignment.center),
        TransformModifier(transform: Matrix4.rotationX(3)),
        const ClipOvalModifier(),
      ];

      final result = orderModifiers(orderOfModifiers, modifiers);

      expect(result.map((e) => e.type).toList(), orderOfModifiers);
    });

    test('should order modifiers based on provided order', () {
      final orderOfModifiers = [
        ClipOvalModifier,
        AspectRatioModifier,
        TransformModifier,
        OpacityModifier,
        VisibilityModifier,
      ];
      const modifiers = <Modifier>[
        VisibilityModifier(true),
        OpacityModifier(1),
        TransformModifier(),
        AspectRatioModifier(2),
        ClipOvalModifier(),
      ];

      final result = orderModifiers(
        orderOfModifiers,
        modifiers,
        defaultOrder: null,
      );

      expect(result.map((e) => e.type).toList(), orderOfModifiers);
    });

    test('should order modifiers based on provided order', () {
      final orderOfModifiers = [
        ClipOvalModifier,
        AspectRatioModifier,
        TransformModifier,
        OpacityModifier,
        VisibilityModifier,
      ];

      final result = combineModifiers(
        null,
        const [
          VisibilityModifier(true),
          OpacityModifier(1),
          TransformModifier(),
          AspectRatioModifier(2),
          ClipOvalModifier(),
        ],
        orderOfModifiers,
        defaultOrder: null,
      );

      expect(result.map((e) => e.type).toList(), orderOfModifiers);
    });

    test('should include default order specs', () {
      final modifiers = <Modifier>[
        TransformModifier(transform: Matrix4.rotationX(3)),
        const OpacityModifier(1),
        const AlignModifier(alignment: Alignment.center),
      ];

      final result = orderModifiers([], modifiers);

      expect(result.map((e) => e.type), [
        AlignModifier,
        TransformModifier,
        OpacityModifier,
      ]);
    });

    test('should handle empty modifiers', () {
      final orderOfModifiers = [TransformModifier];
      final modifiers = <Modifier>[];

      final result = orderModifiers(orderOfModifiers, modifiers);

      expect(result, isEmpty);
    });

    test('should handle duplicate modifiers', () {
      final orderOfModifiers = [TransformModifier];
      final modifiers = [const OpacityModifier(1), const OpacityModifier(0.4)];

      final result = orderModifiers(orderOfModifiers, modifiers);

      expect(result.length, 1);
      expect(result.first.type, OpacityModifier);
    });
  });
}
