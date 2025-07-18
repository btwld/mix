import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';
import 'package:mix/src/modifiers/internal/render_widget_modifier.dart';

void main() {
  group('orderSpecs', () {
    test('should order modifiers based on provided order', () {
      final orderOfModifiers = [
        ClipOvalModifierSpec,
        TransformModifierSpec,
        AlignModifierSpec,
        OpacityModifierSpec,
      ];
      final modifiers = <ModifierSpec>[
        const OpacityModifierSpec(1),
        const AlignModifierSpec(alignment: Alignment.center),
        TransformModifierSpec(transform: Matrix4.rotationX(3)),
        const ClipOvalModifierSpec(),
      ];

      final result = orderModifiers(orderOfModifiers, modifiers);

      expect(result.map((e) => e.type).toList(), orderOfModifiers);
    });

    test('should order modifiers based on provided order', () {
      final orderOfModifiers = [
        ClipOvalModifierSpec,
        AspectRatioModifierSpec,
        TransformModifierSpec,
        OpacityModifierSpec,
        VisibilityModifierSpec,
      ];
      const modifiers = <ModifierSpec>[
        VisibilityModifierSpec(true),
        OpacityModifierSpec(1),
        TransformModifierSpec(),
        AspectRatioModifierSpec(2),
        ClipOvalModifierSpec(),
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
        ClipOvalModifierSpec,
        AspectRatioModifierSpec,
        TransformModifierSpec,
        OpacityModifierSpec,
        VisibilityModifierSpec,
      ];

      final result = combineModifiers(
        null,
        const [
          VisibilityModifierSpec(true),
          OpacityModifierSpec(1),
          TransformModifierSpec(),
          AspectRatioModifierSpec(2),
          ClipOvalModifierSpec(),
        ],
        orderOfModifiers,
        defaultOrder: null,
      );

      expect(result.map((e) => e.type).toList(), orderOfModifiers);
    });

    test('should include default order specs', () {
      final modifiers = <ModifierSpec>[
        TransformModifierSpec(transform: Matrix4.rotationX(3)),
        const OpacityModifierSpec(1),
        const AlignModifierSpec(alignment: Alignment.center),
      ];

      final result = orderModifiers([], modifiers);

      expect(result.map((e) => e.type), [
        AlignModifierSpec,
        TransformModifierSpec,
        OpacityModifierSpec,
      ]);
    });

    test('should handle empty modifiers', () {
      final orderOfModifiers = [TransformModifierSpec];
      final modifiers = <ModifierSpec>[];

      final result = orderModifiers(orderOfModifiers, modifiers);

      expect(result, isEmpty);
    });

    test('should handle duplicate modifiers', () {
      final orderOfModifiers = [TransformModifierSpec];
      final modifiers = [
        const OpacityModifierSpec(1),
        const OpacityModifierSpec(0.4),
      ];

      final result = orderModifiers(orderOfModifiers, modifiers);

      expect(result.length, 1);
      expect(result.first.type, OpacityModifierSpec);
    });
  });
}
