import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/nullability_suffix.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:mix_generator/src/core/builders/spec_mixin_builder.dart';
import 'package:mix_generator/src/core/models/annotation_config.dart';
import 'package:mix_generator/src/core/models/field_model.dart';
import 'package:mix_generator/src/core/registry/mix_type_registry.dart';
import 'package:test/test.dart';

// Test helper to create FieldModel instances for testing
FieldModel createTestFieldModel({
  required String name,
  required String effectiveSpecType,
  bool isNullable = false,
  String? typeName,
  bool isLerpable = false,
}) {
  return FieldModel(
    name: name,
    dartType: _FakeDartType(effectiveSpecType, isNullable),
    element: _FakeFieldElement(name),
    isNullable: isNullable,
    typeName: typeName ?? effectiveSpecType.replaceAll('?', ''),
    isList: false,
    effectiveSpecType: effectiveSpecType,
    effectivePublicParamType: effectiveSpecType,
    isLerpable: isLerpable,
    propWrapperKind: PropWrapperKind.none,
    isWrappedInProp: false,
    diagnosticKind: DiagnosticKind.diagnostics,
    generateSetter: true,
  );
}

// Minimal fake DartType for testing
class _FakeDartType implements DartType {
  final String _displayString;
  final bool _isNullable;

  _FakeDartType(this._displayString, this._isNullable);

  @override
  String getDisplayString({bool withNullability = true}) => _displayString;

  @override
  NullabilitySuffix get nullabilitySuffix =>
      _isNullable ? NullabilitySuffix.question : NullabilitySuffix.none;

  @override
  dynamic noSuchMethod(Invocation invocation) {
    throw UnsupportedError(
      'Unexpected DartType access in test: ${invocation.memberName}',
    );
  }
}

// Minimal fake FieldElement for testing
class _FakeFieldElement implements FieldElement {
  @override
  final String name;

  _FakeFieldElement(this.name);

  @override
  dynamic noSuchMethod(Invocation invocation) {
    throw UnsupportedError(
      'Unexpected FieldElement access in test: ${invocation.memberName}',
    );
  }
}

void main() {
  // Default config that generates all methods
  const defaultConfig = MixableSpecAnnotationConfig();

  group('SpecMixinBuilder', () {
    group('mixinName', () {
      test('generates correct mixin name', () {
        final builder = SpecMixinBuilder(
          specName: 'BoxSpec',
          fields: [],
          config: defaultConfig,
        );
        expect(builder.mixinName, equals('_\$BoxSpec'));
      });

      test('generates correct mixin name for TextSpec', () {
        final builder = SpecMixinBuilder(
          specName: 'TextSpec',
          fields: [],
          config: defaultConfig,
        );
        expect(builder.mixinName, equals('_\$TextSpec'));
      });
    });

    group('build', () {
      test('generates mixin declaration', () {
        final builder = SpecMixinBuilder(
          specName: 'BoxSpec',
          fields: [],
          config: defaultConfig,
        );
        final code = builder.build();

        expect(
          code,
          contains('mixin _\$BoxSpec implements Spec<BoxSpec>, Diagnosticable'),
        );
      });

      test('emits `Type get type` returning the spec class', () {
        final builder = SpecMixinBuilder(
          specName: 'BoxSpec',
          fields: [],
          config: defaultConfig,
        );
        final code = builder.build();

        expect(code, contains('Type get type => BoxSpec;'));
      });

      test(
        'inlines `==` and `hashCode` using `propsEquals` / `propsHash` helpers',
        () {
          final builder = SpecMixinBuilder(
            specName: 'BoxSpec',
            fields: [
              createTestFieldModel(
                name: 'color',
                effectiveSpecType: 'Color?',
                isNullable: true,
              ),
            ],
            config: defaultConfig,
          );
          final code = builder.build();

          // User-facing shape is `class BoxSpec with _$BoxSpec` — the mixin
          // must carry `==`/`hashCode` itself rather than relying on
          // `Equatable` being mixed in by the user.
          expect(code, contains('bool operator ==(Object other)'));
          expect(code, contains('propsEquals(props, other.props)'));
          expect(code, contains('int get hashCode => propsHash('));
        },
      );

      test('inlines Diagnosticable concrete methods', () {
        final builder = SpecMixinBuilder(
          specName: 'BoxSpec',
          fields: [],
          config: defaultConfig,
        );
        final code = builder.build();

        // `_$BoxSpec implements Diagnosticable` — since the applying class
        // mixes nothing else in, the mixin must provide concrete bodies.
        expect(code, contains('String toStringShort()'));
        expect(code, contains('String toString({DiagnosticLevel minLevel'));
        expect(code, contains('DiagnosticsNode toDiagnosticsNode('));
      });

      test('generates abstract getters for fielded specs', () {
        final builder = SpecMixinBuilder(
          specName: 'BoxSpec',
          fields: [
            createTestFieldModel(
              name: 'color',
              effectiveSpecType: 'Color?',
              isNullable: true,
            ),
          ],
          config: defaultConfig,
        );
        final code = builder.build();

        expect(code, contains('Color? get color;'));
      });

      test('generates copyWith override', () {
        final builder = SpecMixinBuilder(
          specName: 'BoxSpec',
          fields: [],
          config: defaultConfig,
        );
        final code = builder.build();

        expect(code, contains('@override'));
        expect(code, contains('BoxSpec copyWith('));
        expect(code, contains('return BoxSpec('));
      });

      test('generates lerp override', () {
        final builder = SpecMixinBuilder(
          specName: 'BoxSpec',
          fields: [],
          config: defaultConfig,
        );
        final code = builder.build();

        expect(code, contains('@override'));
        expect(code, contains('BoxSpec lerp(BoxSpec? other, double t)'));
        expect(code, contains('return BoxSpec('));
      });

      test('generates debugFillProperties override', () {
        final builder = SpecMixinBuilder(
          specName: 'BoxSpec',
          fields: [],
          config: defaultConfig,
        );
        final code = builder.build();

        expect(code, contains('@override'));
        expect(
          code,
          contains(
            'void debugFillProperties(DiagnosticPropertiesBuilder properties)',
          ),
        );
        // The mixin `implements Diagnosticable` — there is no parent
        // `debugFillProperties` to delegate to, so no `super` call.
        expect(code, isNot(contains('super.debugFillProperties(properties)')));
      });

      test('emits Equatable surface (stringify + getDiff) with @override', () {
        final builder = SpecMixinBuilder(
          specName: 'BoxSpec',
          fields: [],
          config: defaultConfig,
        );
        final code = builder.build();

        // `Spec<T> with Equatable` pulls the Equatable contract in via
        // `implements Spec<X>` — the mixin inlines concrete bodies because
        // `implements` doesn't carry over Equatable's concrete impls.
        expect(code, contains('bool get stringify => true;'));
        expect(code, contains('Map<String, String> getDiff(Equatable other)'));
        expect(code, contains('propsDiff(props, other.props)'));
      });

      test('closes mixin with brace', () {
        final builder = SpecMixinBuilder(
          specName: 'BoxSpec',
          fields: [],
          config: defaultConfig,
        );
        final code = builder.build();

        expect(code, endsWith('}\n'));
      });
    });

    group('empty fields', () {
      test('generates empty props list', () {
        final builder = SpecMixinBuilder(
          specName: 'EmptySpec',
          fields: [],
          config: defaultConfig,
        );
        final code = builder.build();

        expect(code, contains('List<Object?> get props => [];'));
      });

      test('generates copyWith with no parameters', () {
        final builder = SpecMixinBuilder(
          specName: 'EmptySpec',
          fields: [],
          config: defaultConfig,
        );
        final code = builder.build();

        expect(code, contains('EmptySpec copyWith({'));
        expect(code, contains('}) {'));
      });
    });

    group('flag-controlled generation', () {
      test('skips copyWith when flag is disabled', () {
        final builder = SpecMixinBuilder(
          specName: 'BoxSpec',
          fields: [],
          config: const MixableSpecAnnotationConfig(
            methods: GeneratedSpecMethods.skipCopyWith,
          ),
        );
        final code = builder.build();

        expect(code, isNot(contains('BoxSpec copyWith(')));
        // lerp and props should still be generated
        expect(code, contains('BoxSpec lerp('));
        expect(code, contains('List<Object?> get props =>'));
      });

      test('skips lerp when flag is disabled', () {
        final builder = SpecMixinBuilder(
          specName: 'BoxSpec',
          fields: [],
          config: const MixableSpecAnnotationConfig(
            methods: GeneratedSpecMethods.skipLerp,
          ),
        );
        final code = builder.build();

        expect(code, isNot(contains('BoxSpec lerp(')));
        // copyWith and props should still be generated
        expect(code, contains('BoxSpec copyWith('));
        expect(code, contains('List<Object?> get props =>'));
      });

      test('skips props when equals flag is disabled', () {
        final builder = SpecMixinBuilder(
          specName: 'BoxSpec',
          fields: [],
          config: const MixableSpecAnnotationConfig(
            methods: GeneratedSpecMethods.skipEquals,
          ),
        );
        final code = builder.build();

        expect(code, isNot(contains('List<Object?> get props =>')));
        // copyWith and lerp should still be generated
        expect(code, contains('BoxSpec copyWith('));
        expect(code, contains('BoxSpec lerp('));
      });

      test('always generates debugFillProperties', () {
        final builder = SpecMixinBuilder(
          specName: 'BoxSpec',
          fields: [],
          config: const MixableSpecAnnotationConfig(
            methods: GeneratedSpecMethods.none,
          ),
        );
        final code = builder.build();

        // debugFillProperties is always generated
        expect(code, contains('void debugFillProperties('));
        // But other methods should be skipped
        expect(code, isNot(contains('BoxSpec copyWith(')));
        expect(code, isNot(contains('BoxSpec lerp(')));
        expect(code, isNot(contains('List<Object?> get props =>')));
      });

      test('generates only copyWith when only copyWith flag is set', () {
        final builder = SpecMixinBuilder(
          specName: 'BoxSpec',
          fields: [],
          config: const MixableSpecAnnotationConfig(
            methods: GeneratedSpecMethods.copyWith,
          ),
        );
        final code = builder.build();

        expect(code, contains('BoxSpec copyWith('));
        expect(code, isNot(contains('BoxSpec lerp(')));
        expect(code, isNot(contains('List<Object?> get props =>')));
      });
    });

    group('copyWith optional parameters', () {
      test('makes nullable field types optional in copyWith', () {
        final fields = [
          createTestFieldModel(
            name: 'color',
            effectiveSpecType: 'Color?',
            isNullable: true,
          ),
          createTestFieldModel(
            name: 'size',
            effectiveSpecType: 'double?',
            isNullable: true,
          ),
        ];

        final builder = SpecMixinBuilder(
          specName: 'TestSpec',
          fields: fields,
          config: defaultConfig,
        );
        final code = builder.build();

        // Nullable types should remain nullable (already optional)
        expect(code, contains('Color? color,'));
        expect(code, contains('double? size,'));
      });

      test('makes non-nullable field types optional in copyWith', () {
        final fields = [
          createTestFieldModel(
            name: 'name',
            effectiveSpecType: 'String',
            isNullable: false,
          ),
          createTestFieldModel(
            name: 'count',
            effectiveSpecType: 'int',
            isNullable: false,
          ),
        ];

        final builder = SpecMixinBuilder(
          specName: 'TestSpec',
          fields: fields,
          config: defaultConfig,
        );
        final code = builder.build();

        // Non-nullable types should become nullable (optional) in copyWith
        expect(code, contains('String? name,'));
        expect(code, contains('int? count,'));
        // Should NOT contain non-nullable parameters
        expect(code, isNot(contains('String name,')));
        expect(code, isNot(contains('int count,')));
      });

      test('handles mixed nullable and non-nullable fields', () {
        final fields = [
          createTestFieldModel(
            name: 'requiredField',
            effectiveSpecType: 'String',
            isNullable: false,
          ),
          createTestFieldModel(
            name: 'optionalField',
            effectiveSpecType: 'String?',
            isNullable: true,
          ),
        ];

        final builder = SpecMixinBuilder(
          specName: 'MixedSpec',
          fields: fields,
          config: defaultConfig,
        );
        final code = builder.build();

        // Both should be optional (nullable) in copyWith
        expect(code, contains('String? requiredField,'));
        expect(code, contains('String? optionalField,'));
      });

      test('handles complex types that are non-nullable', () {
        final fields = [
          createTestFieldModel(
            name: 'decoration',
            effectiveSpecType: 'BoxDecoration',
            isNullable: false,
          ),
          createTestFieldModel(
            name: 'alignment',
            effectiveSpecType: 'AlignmentGeometry',
            isNullable: false,
          ),
        ];

        final builder = SpecMixinBuilder(
          specName: 'ComplexSpec',
          fields: fields,
          config: defaultConfig,
        );
        final code = builder.build();

        // Non-nullable complex types should become optional
        expect(code, contains('BoxDecoration? decoration,'));
        expect(code, contains('AlignmentGeometry? alignment,'));
      });

      test('handles list types correctly', () {
        final fields = [
          createTestFieldModel(
            name: 'shadows',
            effectiveSpecType: 'List<Shadow>',
            isNullable: false,
          ),
          createTestFieldModel(
            name: 'nullableShadows',
            effectiveSpecType: 'List<Shadow>?',
            isNullable: true,
          ),
        ];

        final builder = SpecMixinBuilder(
          specName: 'ListSpec',
          fields: fields,
          config: defaultConfig,
        );
        final code = builder.build();

        // Non-nullable list should become optional
        expect(code, contains('List<Shadow>? shadows,'));
        // Already nullable list stays nullable
        expect(code, contains('List<Shadow>? nullableShadows,'));
      });

      test('uses null coalescing in copyWith body', () {
        final fields = [
          createTestFieldModel(
            name: 'value',
            effectiveSpecType: 'String',
            isNullable: false,
          ),
        ];

        final builder = SpecMixinBuilder(
          specName: 'TestSpec',
          fields: fields,
          config: defaultConfig,
        );
        final code = builder.build();

        // Should use ?? for fallback to current value
        expect(code, contains('value: value ?? this.value,'));
      });

      test('does not double-add nullable suffix', () {
        final fields = [
          createTestFieldModel(
            name: 'color',
            effectiveSpecType: 'Color?',
            isNullable: true,
          ),
        ];

        final builder = SpecMixinBuilder(
          specName: 'TestSpec',
          fields: fields,
          config: defaultConfig,
        );
        final code = builder.build();

        // Should NOT have double question marks
        expect(code, isNot(contains('Color?? color')));
        expect(code, contains('Color? color,'));
      });
    });
  });
}
