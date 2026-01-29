import 'package:mix_annotations/mix_annotations.dart';
import 'package:mix_generator/src/core/builders/spec_mixin_builder.dart';
import 'package:mix_generator/src/core/models/annotation_config.dart';
import 'package:test/test.dart';

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
        expect(builder.mixinName, equals('_\$BoxSpecMethods'));
      });

      test('generates correct mixin name for TextSpec', () {
        final builder = SpecMixinBuilder(
          specName: 'TextSpec',
          fields: [],
          config: defaultConfig,
        );
        expect(builder.mixinName, equals('_\$TextSpecMethods'));
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
          contains('mixin _\$BoxSpecMethods on Spec<BoxSpec>, Diagnosticable'),
        );
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
        expect(code, contains('super.debugFillProperties(properties)'));
      });

      test('generates props override', () {
        final builder = SpecMixinBuilder(
          specName: 'BoxSpec',
          fields: [],
          config: defaultConfig,
        );
        final code = builder.build();

        expect(code, contains('@override'));
        expect(code, contains('List<Object?> get props =>'));
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
  });
}
