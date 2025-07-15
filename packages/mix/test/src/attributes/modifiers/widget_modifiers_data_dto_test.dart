import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';
import 'package:mix/src/modifiers/internal/reset_modifier.dart';

import '../../../helpers/custom_matchers.dart';

void main() {
  group('WidgetModifiersConfigDto', () {
    test('merge combines two WidgetModifiersConfigDto instances correctly', () {
      final dto1 = WidgetModifiersConfigDto(
        modifiers: [
          TransformModifierSpecAttribute(transform: Matrix4.identity()),
        ],
      );
      final dto2 = WidgetModifiersConfigDto(
        modifiers: const [OpacityModifierSpecAttribute(opacity: 0.5)],
      );

      final merged = dto1.merge(dto2);

      expect(merged.modifiers?.length, 2);
      expect(
        merged.modifiers![0],
        resolvesTo(TransformModifierSpec(transform: Matrix4.identity())),
      );
      expect(merged.modifiers![1], resolvesTo(const OpacityModifierSpec(0.5)));
    });

    test('merge with cleaner removes previous modifiers ', () {
      final dto1 = WidgetModifiersConfigDto(
        modifiers: [
          TransformModifierSpecAttribute(transform: Matrix4.identity()),
        ],
      );

      final cleaner = WidgetModifiersConfigDto(
        modifiers: const [ResetModifierSpecAttribute()],
      );

      final dto2 = WidgetModifiersConfigDto(
        modifiers: const [OpacityModifierSpecAttribute(opacity: 0.5)],
      );

      final merged = dto1.merge(cleaner).merge(dto2);

      expect(merged.modifiers?.length, 2);

      expect(merged.modifiers![0], resolvesTo(const ResetModifierSpec()));
      expect(merged.modifiers![1], resolvesTo(const OpacityModifierSpec(0.5)));
    });

    test('merge returns the same instance when other is null', () {
      final dto = WidgetModifiersConfigDto(
        modifiers: [
          TransformModifierSpecAttribute(transform: Matrix4.identity()),
        ],
      );

      final merged = dto.merge(null);

      expect(identical(merged, dto), true);
    });

    test('resolve creates WidgetModifiersConfig with resolved modifiers', () {
      final dto = WidgetModifiersConfigDto(
        modifiers: [
          TransformModifierSpecAttribute(transform: Matrix4.identity()),
          const OpacityModifierSpecAttribute(opacity: 0.5),
        ],
      );

      expect(
        dto,
        resolvesTo(
          isA<WidgetModifiersConfig>().having(
            (w) => w.value,
            'modifiers',
            hasLength(2),
          ),
        ),
      );

      // Test individual modifiers - using direct resolution for comparison
      expect(
        dto,
        resolvesTo(
          isA<WidgetModifiersConfig>().having(
            (w) => w.value[0],
            'first modifier',
            isA<TransformModifierSpec>(),
          ),
        ),
      );
      expect(
        dto,
        resolvesTo(
          isA<WidgetModifiersConfig>().having(
            (w) => w.value[1],
            'second modifier',
            isA<OpacityModifierSpec>(),
          ),
        ),
      );
    });

    test('props returns list containing value', () {
      final List<WidgetModifierSpecAttribute> modifiers = [
        TransformModifierSpecAttribute(transform: Matrix4.identity()),
        const OpacityModifierSpecAttribute(opacity: 0.5),
      ];
      final dto = WidgetModifiersConfigDto(modifiers: modifiers);

      expect(dto.props, [modifiers]);
    });
  });
}
