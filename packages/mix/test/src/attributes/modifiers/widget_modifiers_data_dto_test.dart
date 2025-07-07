import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';
import 'package:mix/src/modifiers/internal/reset_modifier.dart';

import '../../../helpers/testing_utils.dart';

void main() {
  group('WidgetModifiersConfigDto', () {
    test('merge combines two WidgetModifiersConfigDto instances correctly', () {
      final dto1 = WidgetModifiersConfigDto([
        TransformModifierSpecAttribute(transform: Matrix4.identity()),
      ]);
      const dto2 = WidgetModifiersConfigDto([
        OpacityModifierSpecAttribute(opacity: 0.5),
      ]);

      final merged = dto1.merge(dto2);

      expect(merged.modifiers.length, 2);
      expect(
        merged.modifiers[0].resolve(EmptyMixData),
        TransformModifierSpec(transform: Matrix4.identity()),
      );
      expect(
        merged.modifiers[1].resolve(EmptyMixData),
        const OpacityModifierSpec(0.5),
      );
    });

    test('merge with cleaner removes previous modifiers ', () {
      final dto1 = WidgetModifiersConfigDto([
        TransformModifierSpecAttribute(transform: Matrix4.identity()),
      ]);

      const cleaner = WidgetModifiersConfigDto([
        ResetModifierSpecAttribute(),
      ]);

      const dto2 = WidgetModifiersConfigDto([
        OpacityModifierSpecAttribute(opacity: 0.5),
      ]);

      final merged = dto1.merge(cleaner).merge(dto2);

      expect(merged.modifiers.length, 2);

      expect(
        merged.modifiers[0].resolve(EmptyMixData),
        const ResetModifierSpec(),
      );
      expect(
        merged.modifiers[1].resolve(EmptyMixData),
        const OpacityModifierSpec(0.5),
      );
    });

    test('merge returns the same instance when other is null', () {
      final dto = WidgetModifiersConfigDto([
        TransformModifierSpecAttribute(transform: Matrix4.identity()),
      ]);

      final merged = dto.merge(null);

      expect(identical(merged, dto), true);
    });

    test('resolve creates WidgetModifiersData with resolved modifiers', () {
      final dto = WidgetModifiersConfigDto([
        TransformModifierSpecAttribute(transform: Matrix4.identity()),
        const OpacityModifierSpecAttribute(opacity: 0.5),
      ]);

      final resolved = dto.resolve(EmptyMixData);

      expect(resolved.value.length, 2);
      expect(
        resolved.value[0],
        TransformModifierSpec(transform: Matrix4.identity()),
      );
      expect(
        resolved.value[1],
        const OpacityModifierSpec(0.5),
      );
    });

    test('props returns list containing value', () {
      final List<WidgetModifierSpecAttribute> modifiers = [
        TransformModifierSpecAttribute(transform: Matrix4.identity()),
        const OpacityModifierSpecAttribute(opacity: 0.5),
      ];
      final dto = WidgetModifiersConfigDto(modifiers);

      expect(dto.props, [modifiers]);
    });
  });
}
