import 'package:mix_annotations/mix_annotations.dart';
import 'package:mix_generator/src/core/builders/styler_mixin_builder.dart';
import 'package:mix_generator/src/core/models/annotation_config.dart';
import 'package:test/test.dart';

void main() {
  // Default config that generates all methods
  const defaultConfig = MixableStylerAnnotationConfig();

  group('StylerMixinBuilder', () {
    group('mixinName', () {
      test('generates correct mixin name', () {
        final builder = StylerMixinBuilder(
          stylerName: 'BoxStyler',
          specName: 'BoxSpec',
          fields: [],
          config: defaultConfig,
        );
        expect(builder.mixinName, equals('_\$BoxStylerMixin'));
      });

      test('generates correct mixin name for TextStyler', () {
        final builder = StylerMixinBuilder(
          stylerName: 'TextStyler',
          specName: 'TextSpec',
          fields: [],
          config: defaultConfig,
        );
        expect(builder.mixinName, equals('_\$TextStylerMixin'));
      });
    });

    group('build', () {
      test('generates mixin declaration', () {
        final builder = StylerMixinBuilder(
          stylerName: 'BoxStyler',
          specName: 'BoxSpec',
          fields: [],
          config: defaultConfig,
        );
        final code = builder.build();

        expect(
          code,
          contains('mixin _\$BoxStylerMixin on Style<BoxSpec>, Diagnosticable'),
        );
      });

      test('generates merge override', () {
        final builder = StylerMixinBuilder(
          stylerName: 'BoxStyler',
          specName: 'BoxSpec',
          fields: [],
          config: defaultConfig,
        );
        final code = builder.build();

        expect(code, contains('@override'));
        expect(code, contains('BoxStyler merge(BoxStyler? other)'));
        expect(code, contains('return BoxStyler.create('));
      });

      test('generates resolve override', () {
        final builder = StylerMixinBuilder(
          stylerName: 'BoxStyler',
          specName: 'BoxSpec',
          fields: [],
          config: defaultConfig,
        );
        final code = builder.build();

        expect(code, contains('@override'));
        expect(
          code,
          contains('StyleSpec<BoxSpec> resolve(BuildContext context)'),
        );
        expect(code, contains('final spec = BoxSpec('));
        expect(code, contains('return StyleSpec('));
      });

      test('generates debugFillProperties override', () {
        final builder = StylerMixinBuilder(
          stylerName: 'BoxStyler',
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
        final builder = StylerMixinBuilder(
          stylerName: 'BoxStyler',
          specName: 'BoxSpec',
          fields: [],
          config: defaultConfig,
        );
        final code = builder.build();

        expect(code, contains('@override'));
        expect(code, contains('List<Object?> get props =>'));
      });

      test('closes mixin with brace', () {
        final builder = StylerMixinBuilder(
          stylerName: 'BoxStyler',
          specName: 'BoxSpec',
          fields: [],
          config: defaultConfig,
        );
        final code = builder.build();

        expect(code, endsWith('}\n'));
      });
    });

    group('base fields in merge', () {
      test('includes variants, modifier, animation in merge', () {
        final builder = StylerMixinBuilder(
          stylerName: 'BoxStyler',
          specName: 'BoxSpec',
          fields: [],
          config: defaultConfig,
        );
        final code = builder.build();

        expect(
          code,
          contains(
            'variants: MixOps.mergeVariants(\$variants, other?.\$variants)',
          ),
        );
        expect(
          code,
          contains(
            'modifier: MixOps.mergeModifier(\$modifier, other?.\$modifier)',
          ),
        );
        expect(
          code,
          contains(
            'animation: MixOps.mergeAnimation(\$animation, other?.\$animation)',
          ),
        );
      });
    });

    group('base fields in props', () {
      test('includes animation, modifier, variants in props', () {
        final builder = StylerMixinBuilder(
          stylerName: 'BoxStyler',
          specName: 'BoxSpec',
          fields: [],
          config: defaultConfig,
        );
        final code = builder.build();

        expect(code, contains('\$animation,'));
        expect(code, contains('\$modifier,'));
        expect(code, contains('\$variants,'));
      });
    });

    group('base methods', () {
      test('generates animate method', () {
        final builder = StylerMixinBuilder(
          stylerName: 'BoxStyler',
          specName: 'BoxSpec',
          fields: [],
          config: defaultConfig,
        );
        final code = builder.build();

        expect(code, contains('BoxStyler animate(AnimationConfig value)'));
        expect(code, contains('return merge(BoxStyler(animation: value))'));
      });

      test('generates variants method', () {
        final builder = StylerMixinBuilder(
          stylerName: 'BoxStyler',
          specName: 'BoxSpec',
          fields: [],
          config: defaultConfig,
        );
        final code = builder.build();

        expect(
          code,
          contains('BoxStyler variants(List<VariantStyle<BoxSpec>> value)'),
        );
        expect(code, contains('return merge(BoxStyler(variants: value))'));
      });

      test('generates wrap method', () {
        final builder = StylerMixinBuilder(
          stylerName: 'BoxStyler',
          specName: 'BoxSpec',
          fields: [],
          config: defaultConfig,
        );
        final code = builder.build();

        expect(code, contains('BoxStyler wrap(WidgetModifierConfig value)'));
        expect(code, contains('return merge(BoxStyler(modifier: value))'));
      });

      test('skips base methods when setters flag is disabled', () {
        final builder = StylerMixinBuilder(
          stylerName: 'BoxStyler',
          specName: 'BoxSpec',
          fields: [],
          config: const MixableStylerAnnotationConfig(
            methods: GeneratedStylerMethods.skipSetters,
          ),
        );
        final code = builder.build();

        expect(code, isNot(contains('BoxStyler animate(')));
        expect(code, isNot(contains('BoxStyler variants(')));
        expect(code, isNot(contains('BoxStyler wrap(')));
      });
    });

    group('flag-controlled generation', () {
      test('skips setters when flag is disabled', () {
        final builder = StylerMixinBuilder(
          stylerName: 'BoxStyler',
          specName: 'BoxSpec',
          fields: [],
          config: const MixableStylerAnnotationConfig(
            methods: GeneratedStylerMethods.skipSetters,
          ),
        );
        final code = builder.build();

        // merge, resolve, debugFillProperties, props should still be generated
        expect(code, contains('BoxStyler merge('));
        expect(code, contains('StyleSpec<BoxSpec> resolve('));
        expect(code, contains('void debugFillProperties('));
        expect(code, contains('List<Object?> get props =>'));
      });

      test('skips merge when flag is disabled', () {
        final builder = StylerMixinBuilder(
          stylerName: 'BoxStyler',
          specName: 'BoxSpec',
          fields: [],
          config: const MixableStylerAnnotationConfig(
            methods: GeneratedStylerMethods.skipMerge,
          ),
        );
        final code = builder.build();

        expect(code, isNot(contains('BoxStyler merge(')));
        // Other methods should still be generated
        expect(code, contains('StyleSpec<BoxSpec> resolve('));
        expect(code, contains('void debugFillProperties('));
        expect(code, contains('List<Object?> get props =>'));
      });

      test('skips resolve when flag is disabled', () {
        final builder = StylerMixinBuilder(
          stylerName: 'BoxStyler',
          specName: 'BoxSpec',
          fields: [],
          config: const MixableStylerAnnotationConfig(
            methods: GeneratedStylerMethods.skipResolve,
          ),
        );
        final code = builder.build();

        expect(code, isNot(contains('StyleSpec<BoxSpec> resolve(')));
        // Other methods should still be generated
        expect(code, contains('BoxStyler merge('));
        expect(code, contains('void debugFillProperties('));
        expect(code, contains('List<Object?> get props =>'));
      });

      test('skips debugFillProperties when flag is disabled', () {
        final builder = StylerMixinBuilder(
          stylerName: 'BoxStyler',
          specName: 'BoxSpec',
          fields: [],
          config: const MixableStylerAnnotationConfig(
            methods: GeneratedStylerMethods.skipDebugFillProperties,
          ),
        );
        final code = builder.build();

        expect(code, isNot(contains('void debugFillProperties(')));
        // Other methods should still be generated
        expect(code, contains('BoxStyler merge('));
        expect(code, contains('StyleSpec<BoxSpec> resolve('));
        expect(code, contains('List<Object?> get props =>'));
      });

      test('skips props when flag is disabled', () {
        final builder = StylerMixinBuilder(
          stylerName: 'BoxStyler',
          specName: 'BoxSpec',
          fields: [],
          config: const MixableStylerAnnotationConfig(
            methods: GeneratedStylerMethods.skipProps,
          ),
        );
        final code = builder.build();

        expect(code, isNot(contains('List<Object?> get props =>')));
        // Other methods should still be generated
        expect(code, contains('BoxStyler merge('));
        expect(code, contains('StyleSpec<BoxSpec> resolve('));
        expect(code, contains('void debugFillProperties('));
      });

      test('generates nothing when all flags disabled', () {
        final builder = StylerMixinBuilder(
          stylerName: 'BoxStyler',
          specName: 'BoxSpec',
          fields: [],
          config: const MixableStylerAnnotationConfig(
            methods: GeneratedStylerMethods.none,
          ),
        );
        final code = builder.build();

        // Only mixin declaration and closing brace
        expect(
          code,
          contains('mixin _\$BoxStylerMixin on Style<BoxSpec>, Diagnosticable'),
        );
        expect(code, isNot(contains('BoxStyler merge(')));
        expect(code, isNot(contains('StyleSpec<BoxSpec> resolve(')));
        expect(code, isNot(contains('void debugFillProperties(')));
        expect(code, isNot(contains('List<Object?> get props =>')));
      });
    });
  });
}
