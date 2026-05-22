import 'package:mix_annotations/mix_annotations.dart';
import 'package:mix_generator/src/core/builders/spec_mixin_builder.dart';
import 'package:mix_generator/src/core/models/annotation_config.dart';
import 'package:test/test.dart';

import '../test_helpers.dart';

/// The Equatable surface always emits — it references whichever `props`
/// the class exposes (generated or user-authored under `skipEquals`).
void expectRequiredSpecEqualitySurface(String code) {
  expect(code, contains('bool operator ==(Object other)'));
  expect(code, contains('propsEquals(props, other.props)'));
  expect(code, contains('int get hashCode => propsHash('));
  expect(code, contains('bool get stringify => true;'));
  expect(code, contains('Map<String, String> getDiff(Equatable other)'));
  expect(code, contains('propsDiff(props, other.props)'));
}

/// `props` is opt-out via `GeneratedSpecMethods.skipEquals` — assert it
/// when the equals bit is on (default), refute when it's off.
void expectGeneratedProps(String code) {
  expect(code, contains('List<Object?> get props =>'));
}

void expectNoGeneratedProps(String code) {
  expect(code, isNot(contains('List<Object?> get props =>')));
}

void main() {
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
          expectRequiredSpecEqualitySurface(code);
          expectGeneratedProps(code);
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
        expectRequiredSpecEqualitySurface(code);
        expectGeneratedProps(code);
      });

      test('closes mixin with brace before the legacy typedef', () {
        final builder = SpecMixinBuilder(
          specName: 'BoxSpec',
          fields: [],
          config: defaultConfig,
        );
        final code = builder.build();

        // The mixin block must close with `}` even though the file now
        // continues with the legacy typedef alias.
        expect(code, contains('}\n\n@Deprecated('));
        // Trailing `// ignore: unused_element` suppresses the analyzer
        // hint when callers stay on the new host shape.
        expect(code, endsWith('; // ignore: unused_element\n'));
      });

      test('emits legacy SpecMethods typedef alias', () {
        final builder = SpecMixinBuilder(
          specName: 'BoxSpec',
          fields: [],
          config: defaultConfig,
        );
        final code = builder.build();

        // Backwards compat: pre-2.0 generator emitted `_$BoxSpecMethods`.
        // The typedef keeps legacy host shapes
        // (`class BoxSpec extends Spec<BoxSpec> with Diagnosticable, _$BoxSpecMethods`)
        // compiling against the rich mixin.
        expect(code, contains('typedef _\$BoxSpecMethods = _\$BoxSpec;'));
      });

      test('marks legacy SpecMethods typedef @Deprecated', () {
        final builder = SpecMixinBuilder(
          specName: 'BoxSpec',
          fields: [],
          config: defaultConfig,
        );
        final code = builder.build();

        // The `@Deprecated(...)` annotation must sit immediately above the
        // typedef — guards against accidentally dropping the deprecation.
        // The `$` in the message is escaped (`\$`) so the analyzer treats
        // it as a literal in the generated Dart string, not interpolation.
        expect(
          code,
          contains(r"@Deprecated('Rename to `_\$BoxSpec`"),
        );
        expect(code, contains(r'`_\$BoxSpecMethods` alias'));
        final deprecatedIndex = code.indexOf('@Deprecated(');
        final typedefIndex = code.indexOf('typedef _\$BoxSpecMethods');
        expect(deprecatedIndex, greaterThanOrEqualTo(0));
        expect(typedefIndex, greaterThan(deprecatedIndex));
        // Nothing else between the annotation and the typedef.
        expect(
          code.substring(deprecatedIndex, typedefIndex),
          isNot(contains('\n\n')),
        );
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
        expect(code, contains('BoxSpec lerp('));
        expectRequiredSpecEqualitySurface(code);
        expectGeneratedProps(code);
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
        expect(code, contains('BoxSpec copyWith('));
        expectRequiredSpecEqualitySurface(code);
        expectGeneratedProps(code);
      });

      for (final testCase in [
        (
          name: 'skipEquals helper',
          methods: GeneratedSpecMethods.skipEquals,
          hasCopyWith: true,
          hasLerp: true,
        ),
        (
          name: 'no optional methods',
          methods: GeneratedSpecMethods.none,
          hasCopyWith: false,
          hasLerp: false,
        ),
        (
          name: 'copyWith only',
          methods: GeneratedSpecMethods.copyWith,
          hasCopyWith: true,
          hasLerp: false,
        ),
      ]) {
        test('keeps equality surface but skips props for ${testCase.name}', () {
          final builder = SpecMixinBuilder(
            specName: 'BoxSpec',
            fields: [],
            config: MixableSpecAnnotationConfig(methods: testCase.methods),
          );
          final code = builder.build();

          // `==`/`hashCode`/`getDiff`/`stringify` always emit so the
          // user-provided `props` powers a working equality surface.
          expectRequiredSpecEqualitySurface(code);
          // `props` itself is suppressed — user authors it.
          expectNoGeneratedProps(code);
          expect(code, contains('void debugFillProperties('));

          final copyWithMatcher = contains('BoxSpec copyWith(');
          final lerpMatcher = contains('BoxSpec lerp(');
          expect(
            code,
            testCase.hasCopyWith ? copyWithMatcher : isNot(copyWithMatcher),
          );
          expect(code, testCase.hasLerp ? lerpMatcher : isNot(lerpMatcher));
        });
      }

      test(
        'skipEquals suppresses props but keeps the equality surface intact',
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
            config: const MixableSpecAnnotationConfig(
              methods: GeneratedSpecMethods.skipEquals,
            ),
          );
          final code = builder.build();

          // User authors `props` — generator emits no `List<Object?> get props`
          // body, but still emits abstract field getters and the equality
          // surface that references `props`.
          expectNoGeneratedProps(code);
          expectRequiredSpecEqualitySurface(code);
          expect(code, contains('Color? get color;'));
          // copyWith + lerp still emit because skipEquals doesn't touch them.
          expect(code, contains('BoxSpec copyWith('));
          expect(code, contains('BoxSpec lerp('));
        },
      );
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

        expect(code, contains('String? name,'));
        expect(code, contains('int? count,'));
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

        expect(code, contains('List<Shadow>? shadows,'));
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

        expect(code, isNot(contains('Color?? color')));
        expect(code, contains('Color? color,'));
      });
    });
  });
}
