import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';
import 'package:mix/src/modifiers/internal/reset_modifier.dart';

import '../../../helpers/custom_matchers.dart';
import '../../../helpers/testing_utils.dart';

void main() {
  group('WidgetModifiersConfigDto', () {
    test('merge combines two WidgetModifiersConfigDto instances correctly', () {
      final dto1 = WidgetModifiersConfigDto([
        TransformModifierSpecAttribute(transform: Matrix4.identity())
      ]);
      final dto2 = WidgetModifiersConfigDto(const [
        OpacityModifierSpecAttribute(opacity: 0.5),
      ]);

      final merged = dto1.merge(dto2);

      expect(merged.modifiers.length, 2);
      expect(
        merged.modifiers[0],
        resolvesTo(TransformModifierSpec(transform: Matrix4.identity())),
      );
      expect(
        merged.modifiers[1],
        resolvesTo(const OpacityModifierSpec(0.5)),
      );
    });

    test('merge with cleaner removes previous modifiers ', () {
      final dto1 = WidgetModifiersConfigDto([
        TransformModifierSpecAttribute(transform: Matrix4.identity())
      ]);

      final cleaner = WidgetModifiersConfigDto(const [
        ResetModifierSpecAttribute(),
      ]);

      final dto2 = WidgetModifiersConfigDto(const [
        OpacityModifierSpecAttribute(opacity: 0.5),
      ]);

      final merged = dto1.merge(cleaner).merge(dto2);

      expect(merged.modifiers.length, 2);

      expect(
        merged.modifiers[0],
        resolvesTo(const ResetModifierSpec()),
      );
      expect(
        merged.modifiers[1],
        resolvesTo(const OpacityModifierSpec(0.5)),
      );
    });

    test('merge returns the same instance when other is null', () {
      final dto = WidgetModifiersConfigDto([
        TransformModifierSpecAttribute(transform: Matrix4.identity())
      ]);

      final merged = dto.merge(null);

      expect(identical(merged, dto), true);
    });

    test('resolve creates WidgetModifiersData with resolved modifiers', () {
      final dto = WidgetModifiersConfigDto([
        TransformModifierSpecAttribute(transform: Matrix4.identity()),
        const OpacityModifierSpecAttribute(opacity: 0.5),
      ]);

      expect(dto, resolvesTo(isA<WidgetModifiersData>().having(
        (w) => w.value,
        'modifiers',
        hasLength(2),
      )));
      
      // Test individual modifiers
      final resolved = dto.resolve(EmptyMixData);
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
