import 'package:mix_generator/src/core/builders/modifier_mix_builder.dart';
import 'package:mix_generator/src/core/registry/mix_type_registry.dart';
import 'package:test/test.dart';

void main() {
  group('ModifierMixBuilder', () {
    group('className', () {
      test('generates correct class name from modifier name', () {
        final builder = ModifierMixBuilder(
          modifierName: 'OpacityModifier',
          fields: [],
        );
        expect(builder.className, equals('OpacityModifierMix'));
      });
    });

    group('build', () {
      test('generates class extending ModifierMix with Diagnosticable', () {
        final builder = ModifierMixBuilder(
          modifierName: 'OpacityModifier',
          fields: [],
        );
        final code = builder.build();

        expect(
          code,
          contains(
            'class OpacityModifierMix extends ModifierMix<OpacityModifier> with Diagnosticable',
          ),
        );
      });

      test('generates create constructor with Prop fields', () {
        final builder = ModifierMixBuilder(
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

        expect(code, contains('final Prop<double>? opacity;'));
        expect(
          code,
          contains('const OpacityModifierMix.create({this.opacity});'),
        );
      });

      test('generates public constructor with Prop.maybe for direct types', () {
        final builder = ModifierMixBuilder(
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

        expect(code, contains('double? opacity,'));
        expect(code, contains('opacity: Prop.maybe(opacity)'));
      });

      test('generates public constructor with Prop.maybeMix for mix types', () {
        final builder = ModifierMixBuilder(
          modifierName: 'ClipRRectModifier',
          fields: [
            ModifierFieldModel(
              name: 'borderRadius',
              typeName: 'BorderRadiusGeometry',
              propWrapperKind: PropWrapperKind.maybeMix,
              mixTypeName: 'BorderRadiusGeometryMix',
            ),
            ModifierFieldModel(
              name: 'clipBehavior',
              typeName: 'Clip',
              propWrapperKind: PropWrapperKind.maybe,
            ),
          ],
        );
        final code = builder.build();

        expect(code, contains('BorderRadiusGeometryMix? borderRadius'));
        expect(code, contains('borderRadius: Prop.maybeMix(borderRadius)'));
        expect(code, contains('Clip? clipBehavior'));
        expect(code, contains('clipBehavior: Prop.maybe(clipBehavior)'));
      });

      test('generates resolve method', () {
        final builder = ModifierMixBuilder(
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

        expect(code, contains('@override'));
        expect(code, contains('OpacityModifier resolve(BuildContext context)'));
        expect(code, contains('return OpacityModifier('));
        expect(code, contains('MixOps.resolve(context, opacity)'));
      });

      test('generates merge method', () {
        final builder = ModifierMixBuilder(
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

        expect(code, contains('@override'));
        expect(
          code,
          contains('OpacityModifierMix merge(OpacityModifierMix? other)'),
        );
        expect(code, contains('if (other == null) return this;'));
        expect(code, contains('return OpacityModifierMix.create('));
        expect(code, contains('opacity: MixOps.merge(opacity, other.opacity)'));
      });

      test('generates debugFillProperties', () {
        final builder = ModifierMixBuilder(
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

        expect(code, contains('@override'));
        expect(
          code,
          contains(
            'void debugFillProperties(DiagnosticPropertiesBuilder properties)',
          ),
        );
        expect(code, contains('super.debugFillProperties(properties)'));
        expect(code, contains("DiagnosticsProperty('opacity', opacity)"));
      });

      test('generates props getter', () {
        final builder = ModifierMixBuilder(
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

        expect(code, contains('@override'));
        expect(code, contains('List<Object?> get props => ['));
        expect(code, contains('opacity,'));
      });

      test('handles multiple fields', () {
        final builder = ModifierMixBuilder(
          modifierName: 'ClipOvalModifier',
          fields: [
            ModifierFieldModel(
              name: 'clipper',
              typeName: 'CustomClipper<Rect>',
              propWrapperKind: PropWrapperKind.maybe,
            ),
            ModifierFieldModel(
              name: 'clipBehavior',
              typeName: 'Clip',
              propWrapperKind: PropWrapperKind.maybe,
            ),
          ],
        );
        final code = builder.build();

        expect(code, contains('final Prop<CustomClipper<Rect>>? clipper;'));
        expect(code, contains('final Prop<Clip>? clipBehavior;'));
        expect(code, contains('MixOps.resolve(context, clipper)'));
        expect(code, contains('MixOps.resolve(context, clipBehavior)'));
      });

      test('generates empty class when no fields', () {
        final builder = ModifierMixBuilder(
          modifierName: 'NoopModifier',
          fields: [],
        );
        final code = builder.build();

        expect(
          code,
          contains('class NoopModifierMix extends ModifierMix<NoopModifier>'),
        );
        expect(code, contains('const NoopModifierMix.create();'));
        expect(code, contains('List<Object?> get props => [];'));
      });
    });
  });
}
