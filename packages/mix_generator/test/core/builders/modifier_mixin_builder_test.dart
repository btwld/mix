import 'package:mix_generator/src/core/builders/modifier_mix_builder.dart';
import 'package:mix_generator/src/core/builders/modifier_mixin_builder.dart';
import 'package:test/test.dart';

void main() {
  group('ModifierMixinBuilder', () {
    group('mixinName', () {
      test('generates spec-style mixin name from modifier name', () {
        final builder = ModifierMixinBuilder(
          modifierName: 'AlignModifier',
          fields: [],
        );

        expect(builder.mixinName, equals('_\$AlignModifier'));
      });
    });

    group('build', () {
      test('generates self-contained WidgetModifier mixin', () {
        final builder = ModifierMixinBuilder(
          modifierName: 'AlignModifier',
          fields: [],
        );
        final code = builder.build();

        expect(
          code,
          contains(
            'mixin _\$AlignModifier implements WidgetModifier<AlignModifier>, Diagnosticable',
          ),
        );
        expect(code, isNot(contains('Methods')));
        expect(code, isNot(contains('typedef')));
        expect(code, isNot(contains('on WidgetModifier')));
      });

      test('generates abstract getters for fields', () {
        final builder = ModifierMixinBuilder(
          modifierName: 'AlignModifier',
          fields: [
            ModifierFieldModel(
              name: 'alignment',
              typeName: 'AlignmentGeometry',
              isLerpable: true,
            ),
            ModifierFieldModel(
              name: 'widthFactor',
              typeName: 'double',
              isNullable: true,
              isLerpable: true,
            ),
          ],
        );
        final code = builder.build();

        expect(code, contains('AlignmentGeometry get alignment;'));
        expect(code, contains('double? get widthFactor;'));
      });

      test('generates type getter and build contract', () {
        final builder = ModifierMixinBuilder(
          modifierName: 'OpacityModifier',
          fields: [],
        );
        final code = builder.build();

        expect(code, contains('Type get type => OpacityModifier;'));
        expect(code, contains('Widget build(Widget child);'));
      });

      test('generates copyWith with named params', () {
        final builder = ModifierMixinBuilder(
          modifierName: 'AlignModifier',
          fields: [
            ModifierFieldModel(
              name: 'alignment',
              typeName: 'AlignmentGeometry',
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

      test('generates spec-style lerp for lerpable types', () {
        final builder = ModifierMixinBuilder(
          modifierName: 'AlignModifier',
          fields: [
            ModifierFieldModel(
              name: 'alignment',
              typeName: 'AlignmentGeometry',
              isNamedParam: true,
              isLerpable: true,
            ),
          ],
        );
        final code = builder.build();

        expect(
          code,
          contains('alignment: MixOps.lerp(alignment, other?.alignment, t),'),
        );
        expect(code, isNot(contains('if (other == null) return this')));
        expect(code, isNot(contains('other.alignment')));
        expect(code, isNot(contains(')!')));
      });

      test('generates spec-style lerp with positional params', () {
        final builder = ModifierMixinBuilder(
          modifierName: 'OpacityModifier',
          fields: [
            ModifierFieldModel(
              name: 'opacity',
              typeName: 'double',
              isNamedParam: false,
              isLerpable: true,
            ),
          ],
        );
        final code = builder.build();

        expect(code, contains('MixOps.lerp(opacity, other?.opacity, t),'));
        expect(
          code,
          isNot(contains('opacity: MixOps.lerp(opacity, other?.opacity, t)')),
        );
      });

      test('generates lerpSnap for non-lerpable types', () {
        final builder = ModifierMixinBuilder(
          modifierName: 'FlexibleModifier',
          fields: [
            ModifierFieldModel(
              name: 'fit',
              typeName: 'FlexFit',
              isNamedParam: true,
              isNullable: true,
              isEnum: true,
            ),
          ],
        );
        final code = builder.build();

        expect(code, contains('fit: MixOps.lerpSnap(fit, other?.fit, t),'));
      });

      test('generates shared diagnostics for field types', () {
        final builder = ModifierMixinBuilder(
          modifierName: 'MixedModifier',
          fields: [
            ModifierFieldModel(name: 'opacity', typeName: 'double'),
            ModifierFieldModel(name: 'quarterTurns', typeName: 'int'),
            ModifierFieldModel(
              name: 'clipBehavior',
              typeName: 'Clip',
              isEnum: true,
            ),
            ModifierFieldModel(
              name: 'reverse',
              typeName: 'bool',
              isNullable: true,
              flagDescription: 'reversed',
            ),
          ],
        );
        final code = builder.build();

        expect(code, contains("DoubleProperty('opacity', opacity)"));
        expect(code, contains("IntProperty('quarterTurns', quarterTurns)"));
        expect(
          code,
          contains("EnumProperty<Clip>('clipBehavior', clipBehavior)"),
        );
        expect(
          code,
          contains(
            "FlagProperty('reverse', value: reverse, ifTrue: 'reversed')",
          ),
        );
        expect(code, isNot(contains('super.debugFillProperties(properties)')));
      });

      test('generates props and equality surface', () {
        final builder = ModifierMixinBuilder(
          modifierName: 'SizedBoxModifier',
          fields: [
            ModifierFieldModel(
              name: 'width',
              typeName: 'double',
              isNullable: true,
            ),
            ModifierFieldModel(
              name: 'height',
              typeName: 'double',
              isNullable: true,
            ),
          ],
        );
        final code = builder.build();

        expect(code, contains('List<Object?> get props => [width, height];'));
        expect(code, contains('bool operator ==(Object other)'));
        expect(code, contains('propsEquals(props, other.props)'));
        expect(
          code,
          contains('int get hashCode => propsHash(runtimeType, props)'),
        );
        expect(code, contains('bool get stringify => true;'));
        expect(code, contains('Map<String, String> getDiff(Equatable other)'));
      });

      test('generates Diagnosticable surface', () {
        final builder = ModifierMixinBuilder(
          modifierName: 'OpacityModifier',
          fields: [],
        );
        final code = builder.build();

        expect(code, contains("String toStringShort() => '\$runtimeType';"));
        expect(
          code,
          contains(
            'String toString({DiagnosticLevel minLevel = DiagnosticLevel.info})',
          ),
        );
        expect(code, contains('DiagnosticsNode toDiagnosticsNode'));
        expect(code, contains('DiagnosticableNode<Diagnosticable>'));
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

      test('skips lerp emission when generateLerp is false', () {
        final builder = ModifierMixinBuilder(
          modifierName: 'VisibilityModifier',
          fields: [
            ModifierFieldModel(
              name: 'visible',
              typeName: 'bool',
              isNamedParam: false,
            ),
          ],
          generateLerp: false,
        );
        final code = builder.build();

        expect(code, isNot(contains('lerp(')));
        expect(code, isNot(contains('MixOps.lerp')));
        expect(code, contains('VisibilityModifier copyWith({'));
        expect(code, contains('List<Object?> get props => [visible];'));
      });
    });
  });
}
