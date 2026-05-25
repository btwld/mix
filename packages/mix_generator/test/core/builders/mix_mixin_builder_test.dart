import 'package:mix_annotations/mix_annotations.dart';
import 'package:mix_generator/src/core/builders/mix_mixin_builder.dart';
import 'package:mix_generator/src/core/models/annotation_config.dart';
import 'package:test/test.dart';

import '../test_helpers.dart';

void main() {
  const defaultConfig = MixableAnnotationConfig();

  group('MixMixinBuilder', () {
    group('generatedMixinName', () {
      test('produces _\$XMixin', () {
        final builder = MixMixinBuilder(
          mixName: 'BoxConstraintsMix',
          resolveToType: 'BoxConstraints',
          fields: const [],
          config: defaultConfig,
          hasDefaultValue: false,
        );

        expect(builder.generatedMixinName, equals('_\$BoxConstraintsMixMixin'));
      });
    });

    group('build', () {
      test('generates mixin declaration with correct on clause', () {
        final builder = MixMixinBuilder(
          mixName: 'BoxConstraintsMix',
          resolveToType: 'BoxConstraints',
          fields: const [],
          config: defaultConfig,
          hasDefaultValue: false,
        );

        expect(
          builder.build(),
          contains(
            'mixin _\$BoxConstraintsMixMixin on Mix<BoxConstraints>, Diagnosticable {',
          ),
        );
      });

      test('includes DefaultValue in the on clause when enabled', () {
        final builder = MixMixinBuilder(
          mixName: 'BoxConstraintsMix',
          resolveToType: 'BoxConstraints',
          fields: const [],
          config: defaultConfig,
          hasDefaultValue: true,
        );

        expect(
          builder.build(),
          contains(
            'mixin _\$BoxConstraintsMixMixin on Mix<BoxConstraints>, DefaultValue<BoxConstraints>, Diagnosticable {',
          ),
        );
      });

      test('includes Diagnosticable when debugFillProperties is generated', () {
        final builder = MixMixinBuilder(
          mixName: 'BoxConstraintsMix',
          resolveToType: 'BoxConstraints',
          fields: const [],
          config: defaultConfig,
          hasDefaultValue: false,
        );

        expect(
          builder.build(),
          contains('on Mix<BoxConstraints>, Diagnosticable'),
        );
      });

      test('generates merge method with MixOps.merge per field', () {
        final builder = MixMixinBuilder(
          mixName: 'BoxConstraintsMix',
          resolveToType: 'BoxConstraints',
          fields: [
            createTestMixFieldModel(
              name: 'minWidth',
              dartTypeDisplayString: 'double?',
            ),
            createTestMixFieldModel(
              name: 'maxWidth',
              dartTypeDisplayString: 'double?',
            ),
          ],
          config: defaultConfig,
          hasDefaultValue: false,
        );

        final code = builder.build();

        expect(
          code,
          contains('BoxConstraintsMix merge(BoxConstraintsMix? other)'),
        );
        expect(
          code,
          contains('minWidth: MixOps.merge(\$minWidth, other?.\$minWidth),'),
        );
        expect(
          code,
          contains('maxWidth: MixOps.merge(\$maxWidth, other?.\$maxWidth),'),
        );
      });

      test('generates abstract getters with declared names and types', () {
        final builder = MixMixinBuilder(
          mixName: 'BoxConstraintsMix',
          resolveToType: 'BoxConstraints',
          fields: [
            createTestMixFieldModel(
              name: 'minWidth',
              dartTypeDisplayString: 'Prop<double>?',
              declaredName: r'$minWidth',
            ),
            createTestMixFieldModel(
              name: 'maxWidth',
              dartTypeDisplayString: 'Prop<double>',
              declaredName: r'$maxWidth',
            ),
          ],
          config: defaultConfig,
          hasDefaultValue: false,
        );

        final code = builder.build();

        expect(code, contains(r'Prop<double>? get $minWidth;'));
        expect(code, contains(r'Prop<double> get $maxWidth;'));
      });

      test('generates resolve method with MixOps.resolve per field', () {
        final builder = MixMixinBuilder(
          mixName: 'BoxConstraintsMix',
          resolveToType: 'BoxConstraints',
          fields: [
            createTestMixFieldModel(
              name: 'minWidth',
              dartTypeDisplayString: 'double?',
            ),
            createTestMixFieldModel(
              name: 'maxWidth',
              dartTypeDisplayString: 'double?',
            ),
          ],
          config: defaultConfig,
          hasDefaultValue: false,
        );

        final code = builder.build();

        expect(
          code,
          contains('minWidth: MixOps.resolve(context, \$minWidth),'),
        );
        expect(
          code,
          contains('maxWidth: MixOps.resolve(context, \$maxWidth),'),
        );
      });

      test('uses defaultValue fallback in resolve when enabled', () {
        final builder = MixMixinBuilder(
          mixName: 'BoxConstraintsMix',
          resolveToType: 'BoxConstraints',
          fields: [
            createTestMixFieldModel(
              name: 'minWidth',
              dartTypeDisplayString: 'double?',
            ),
          ],
          config: defaultConfig,
          hasDefaultValue: true,
        );

        expect(
          builder.build(),
          contains(
            'minWidth: MixOps.resolve(context, \$minWidth) ?? defaultValue.minWidth,',
          ),
        );
      });

      test('generates props with all declared field names', () {
        final builder = MixMixinBuilder(
          mixName: 'BoxConstraintsMix',
          resolveToType: 'BoxConstraints',
          fields: [
            createTestMixFieldModel(
              name: 'minWidth',
              dartTypeDisplayString: 'double?',
            ),
            createTestMixFieldModel(
              name: 'maxWidth',
              dartTypeDisplayString: 'double?',
            ),
          ],
          config: defaultConfig,
          hasDefaultValue: false,
        );

        final code = builder.build();

        expect(code, contains('List<Object?> get props => ['));
        expect(code, contains('\$minWidth,'));
        expect(code, contains('\$maxWidth,'));
      });

      test(
        'generates debugFillProperties with DiagnosticsProperty per field',
        () {
          final builder = MixMixinBuilder(
            mixName: 'BoxConstraintsMix',
            resolveToType: 'BoxConstraints',
            fields: [
              createTestMixFieldModel(
                name: 'minWidth',
                dartTypeDisplayString: 'double?',
              ),
              createTestMixFieldModel(
                name: 'maxWidth',
                dartTypeDisplayString: 'double?',
              ),
            ],
            config: defaultConfig,
            hasDefaultValue: false,
          );

          final code = builder.build();

          expect(
            code,
            contains("..add(DiagnosticsProperty('minWidth', \$minWidth))"),
          );
          expect(
            code,
            contains("..add(DiagnosticsProperty('maxWidth', \$maxWidth))"),
          );
        },
      );
    });

    group('flag-controlled generation', () {
      test('skips merge when flag is disabled', () {
        final builder = MixMixinBuilder(
          mixName: 'BoxConstraintsMix',
          resolveToType: 'BoxConstraints',
          fields: const [],
          config: const MixableAnnotationConfig(
            methods: GeneratedMixMethods.skipMerge,
          ),
          hasDefaultValue: false,
        );

        final code = builder.build();

        expect(code, isNot(contains('BoxConstraintsMix merge(')));
        expect(code, contains('BoxConstraints resolve(BuildContext context)'));
        expect(code, contains('List<Object?> get props =>'));
        expect(code, contains('void debugFillProperties('));
      });

      test('skips resolve when flag is disabled', () {
        final builder = MixMixinBuilder(
          mixName: 'BoxConstraintsMix',
          resolveToType: 'BoxConstraints',
          fields: const [],
          config: const MixableAnnotationConfig(
            methods: GeneratedMixMethods.skipResolve,
          ),
          hasDefaultValue: false,
        );

        final code = builder.build();

        expect(code, contains('BoxConstraintsMix merge('));
        expect(
          code,
          isNot(contains('BoxConstraints resolve(BuildContext context)')),
        );
        expect(code, contains('List<Object?> get props =>'));
        expect(code, contains('void debugFillProperties('));
      });

      test('skips props when flag is disabled', () {
        final builder = MixMixinBuilder(
          mixName: 'BoxConstraintsMix',
          resolveToType: 'BoxConstraints',
          fields: const [],
          config: const MixableAnnotationConfig(
            methods: GeneratedMixMethods.skipProps,
          ),
          hasDefaultValue: false,
        );

        final code = builder.build();

        expect(code, contains('BoxConstraintsMix merge('));
        expect(code, contains('BoxConstraints resolve(BuildContext context)'));
        expect(code, isNot(contains('List<Object?> get props =>')));
        expect(code, contains('void debugFillProperties('));
      });

      test('skips debugFillProperties when flag is disabled', () {
        final builder = MixMixinBuilder(
          mixName: 'BoxConstraintsMix',
          resolveToType: 'BoxConstraints',
          fields: const [],
          config: const MixableAnnotationConfig(
            methods: GeneratedMixMethods.skipDebugFillProperties,
          ),
          hasDefaultValue: false,
        );

        final code = builder.build();

        expect(code, contains('BoxConstraintsMix merge('));
        expect(code, contains('BoxConstraints resolve(BuildContext context)'));
        expect(code, contains('List<Object?> get props =>'));
        expect(code, isNot(contains('void debugFillProperties(')));
        expect(code, isNot(contains('Diagnosticable')));
      });

      test('generates no methods when all flags are disabled', () {
        final builder = MixMixinBuilder(
          mixName: 'BoxConstraintsMix',
          resolveToType: 'BoxConstraints',
          fields: const [],
          config: const MixableAnnotationConfig(
            methods: GeneratedMixMethods.none,
          ),
          hasDefaultValue: false,
        );

        final code = builder.build();

        expect(
          code,
          contains('mixin _\$BoxConstraintsMixMixin on Mix<BoxConstraints> {'),
        );
        expect(code, isNot(contains('BoxConstraintsMix merge(')));
        expect(
          code,
          isNot(contains('BoxConstraints resolve(BuildContext context)')),
        );
        expect(code, isNot(contains('List<Object?> get props =>')));
        expect(code, isNot(contains('void debugFillProperties(')));
      });
    });

    group('empty fields', () {
      test('generates empty props list', () {
        final builder = MixMixinBuilder(
          mixName: 'EmptyMix',
          resolveToType: 'BoxConstraints',
          fields: const [],
          config: defaultConfig,
          hasDefaultValue: false,
        );

        final code = builder.build();

        expect(code, contains('List<Object?> get props => [];'));
        expect(code, isNot(contains('get \$')));
      });
    });
  });
}
