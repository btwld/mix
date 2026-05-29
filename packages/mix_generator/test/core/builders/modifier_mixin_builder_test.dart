import 'package:mix_generator/src/core/builders/modifier_mix_builder.dart';
import 'package:mix_generator/src/core/builders/modifier_mixin_builder.dart';
import 'package:test/test.dart';

void main() {
  group('ModifierMixinBuilder', () {
    group('mixinName', () {
      test('generates correct mixin name from modifier name', () {
        final builder = ModifierMixinBuilder(
          modifierName: 'AlignModifier',
          fields: [],
        );
        expect(builder.mixinName, equals('_\$AlignModifierMethods'));
      });
    });

    group('build', () {
      test('generates mixin with WidgetModifier constraint', () {
        final builder = ModifierMixinBuilder(
          modifierName: 'AlignModifier',
          fields: [],
        );
        final code = builder.build();

        expect(
          code,
          contains(
            'mixin _\$AlignModifierMethods on WidgetModifier<AlignModifier>, Diagnosticable',
          ),
        );
      });

      test('generates abstract getters for fields', () {
        final builder = ModifierMixinBuilder(
          modifierName: 'AlignModifier',
          fields: [
            ModifierFieldModel(
              name: 'alignment',
              typeName: 'AlignmentGeometry',
              propWrapperKind: PropWrapperKind.maybe,
              isLerpable: true,
            ),
            ModifierFieldModel(
              name: 'widthFactor',
              typeName: 'double',
              propWrapperKind: PropWrapperKind.maybe,
              isNullable: true,
              isLerpable: true,
            ),
          ],
        );
        final code = builder.build();

        expect(code, contains('AlignmentGeometry get alignment;'));
        expect(code, contains('double? get widthFactor;'));
      });

      test('generates copyWith with named params', () {
        final builder = ModifierMixinBuilder(
          modifierName: 'AlignModifier',
          fields: [
            ModifierFieldModel(
              name: 'alignment',
              typeName: 'AlignmentGeometry',
              propWrapperKind: PropWrapperKind.maybe,
              isNamedParam: true,
            ),
          ],
        );
        final code = builder.build();

        expect(code, contains('AlignModifier copyWith({'));
        expect(code, contains('AlignmentGeometry? alignment,'));
        expect(code, contains('alignment: alignment ?? this.alignment,'));
      });

      test('generates copyWith with positional params', () {
        final builder = ModifierMixinBuilder(
          modifierName: 'OpacityModifier',
          fields: [
            ModifierFieldModel(
              name: 'opacity',
              typeName: 'double',
              propWrapperKind: PropWrapperKind.maybe,
              isNamedParam: false,
              isLerpable: true,
            ),
          ],
        );
        final code = builder.build();

        expect(code, contains('OpacityModifier copyWith({'));
        expect(code, contains('opacity ?? this.opacity,'));
        expect(code, isNot(contains('opacity: opacity ?? this.opacity,')));
      });

      test('generates lerp with MixOps.lerp for lerpable types', () {
        final builder = ModifierMixinBuilder(
          modifierName: 'AlignModifier',
          fields: [
            ModifierFieldModel(
              name: 'alignment',
              typeName: 'AlignmentGeometry',
              propWrapperKind: PropWrapperKind.maybe,
              isNamedParam: true,
              isLerpable: true,
            ),
          ],
        );
        final code = builder.build();

        expect(
          code,
          contains('alignment: MixOps.lerp(alignment, other.alignment, t)!'),
        );
      });

      test('generates lerp with MixOps.lerpSnap for non-lerpable types', () {
        final builder = ModifierMixinBuilder(
          modifierName: 'FlexibleModifier',
          fields: [
            ModifierFieldModel(
              name: 'fit',
              typeName: 'FlexFit',
              propWrapperKind: PropWrapperKind.maybe,
              isNamedParam: true,
              isNullable: true,
              isEnum: true,
            ),
          ],
        );
        final code = builder.build();

        expect(code, contains('fit: MixOps.lerpSnap(fit, other.fit, t),'));
      });

      test('generates lerp with null assertion for non-nullable fields', () {
        final builder = ModifierMixinBuilder(
          modifierName: 'ClipOvalModifier',
          fields: [
            ModifierFieldModel(
              name: 'clipBehavior',
              typeName: 'Clip',
              propWrapperKind: PropWrapperKind.maybe,
              isNamedParam: true,
              isNullable: false,
              isEnum: true,
            ),
          ],
        );
        final code = builder.build();

        expect(
          code,
          contains(
            'clipBehavior: MixOps.lerpSnap(clipBehavior, other.clipBehavior, t)!',
          ),
        );
      });

      test('generates lerp without null assertion for nullable fields', () {
        final builder = ModifierMixinBuilder(
          modifierName: 'SizedBoxModifier',
          fields: [
            ModifierFieldModel(
              name: 'width',
              typeName: 'double',
              propWrapperKind: PropWrapperKind.maybe,
              isNamedParam: true,
              isNullable: true,
              isLerpable: true,
            ),
          ],
        );
        final code = builder.build();

        expect(code, contains('width: MixOps.lerp(width, other.width, t),'));
        expect(
          code,
          isNot(contains('width: MixOps.lerp(width, other.width, t)!')),
        );
      });

      test('generates DoubleProperty diagnostic for double fields', () {
        final builder = ModifierMixinBuilder(
          modifierName: 'OpacityModifier',
          fields: [
            ModifierFieldModel(
              name: 'opacity',
              typeName: 'double',
              propWrapperKind: PropWrapperKind.maybe,
            ),
          ],
        );
        final code = builder.build();

        expect(code, contains("DoubleProperty('opacity', opacity)"));
      });

      test('generates IntProperty diagnostic for int fields', () {
        final builder = ModifierMixinBuilder(
          modifierName: 'RotatedBoxModifier',
          fields: [
            ModifierFieldModel(
              name: 'quarterTurns',
              typeName: 'int',
              propWrapperKind: PropWrapperKind.maybe,
            ),
          ],
        );
        final code = builder.build();

        expect(code, contains("IntProperty('quarterTurns', quarterTurns)"));
      });

      test('generates EnumProperty diagnostic for enum fields', () {
        final builder = ModifierMixinBuilder(
          modifierName: 'ClipOvalModifier',
          fields: [
            ModifierFieldModel(
              name: 'clipBehavior',
              typeName: 'Clip',
              propWrapperKind: PropWrapperKind.maybe,
              isEnum: true,
            ),
          ],
        );
        final code = builder.build();

        expect(
          code,
          contains("EnumProperty<Clip>('clipBehavior', clipBehavior)"),
        );
      });

      test('generates FlagProperty for bool with flag description', () {
        final builder = ModifierMixinBuilder(
          modifierName: 'ScrollViewModifier',
          fields: [
            ModifierFieldModel(
              name: 'reverse',
              typeName: 'bool',
              propWrapperKind: PropWrapperKind.maybe,
              isNullable: true,
              flagDescription: 'reversed',
            ),
          ],
        );
        final code = builder.build();

        expect(
          code,
          contains(
            "FlagProperty('reverse', value: reverse, ifTrue: 'reversed')",
          ),
        );
      });

      test('generates props getter', () {
        final builder = ModifierMixinBuilder(
          modifierName: 'SizedBoxModifier',
          fields: [
            ModifierFieldModel(
              name: 'height',
              typeName: 'double',
              propWrapperKind: PropWrapperKind.maybe,
              isNullable: true,
            ),
            ModifierFieldModel(
              name: 'width',
              typeName: 'double',
              propWrapperKind: PropWrapperKind.maybe,
              isNullable: true,
            ),
          ],
        );
        final code = builder.build();

        expect(code, contains('List<Object?> get props => [height, width];'));
      });

      test('generates empty methods for zero-field modifier', () {
        final builder = ModifierMixinBuilder(
          modifierName: 'IntrinsicHeightModifier',
          fields: [],
        );
        final code = builder.build();

        expect(code, contains('IntrinsicHeightModifier copyWith()'));
        expect(code, contains('return const IntrinsicHeightModifier();'));
        expect(code, contains('List<Object?> get props => [];'));
      });

      test('generates lerp with positional params', () {
        final builder = ModifierMixinBuilder(
          modifierName: 'OpacityModifier',
          fields: [
            ModifierFieldModel(
              name: 'opacity',
              typeName: 'double',
              propWrapperKind: PropWrapperKind.maybe,
              isNamedParam: false,
              isLerpable: true,
            ),
          ],
        );
        final code = builder.build();

        expect(code, contains('MixOps.lerp(opacity, other.opacity, t)!,'));
        expect(
          code,
          isNot(contains('opacity: MixOps.lerp(opacity, other.opacity, t)!')),
        );
      });
    });
  });
}
