import 'package:build_test/build_test.dart';
import 'package:logging/logging.dart';
import 'package:mix_generator/mix_generator.dart';
import 'package:source_gen/source_gen.dart';
import 'package:test/test.dart';

import '../core/test_helpers.dart';

/// Minimal stub of `SpacingStyleMixin` shared by tests that exercise
/// `EdgeInsetsGeometry` fields. The curated registry maps that type to
/// `SpacingStyleMixin`, so the generator now requires the mixin to be
/// resolvable from the spec library.
const _spacingStyleMixinStub = '''
  class EdgeInsetsGeometry {}
  class EdgeInsetsGeometryMix {}

  mixin SpacingStyleMixin<T> {
    T padding(EdgeInsetsGeometryMix value);
  }
''';

void main() {
  group('SpecStylerGenerator smoke', () {
    test('emits a class shell for a trivial spec', () async {
      const input = '''
        library spike;
        import 'package:mix_annotations/mix_annotations.dart';

        part 'spike.spec_styler.g.part';

        @MixableSpec()
        final class TrivialSpec {
          final int? count;
          const TrivialSpec({this.count});
        }
      ''';

      await testBuilder(
        PartBuilder([const SpecStylerGenerator()], '.spec_styler.g.part'),
        {
          ...mixAnnotationsSources,
          'mix|lib/spike.dart': input,
        },
        outputs: {
          'mix|lib/spike.spec_styler.g.part': decodedMatches(
            contains(
              'class TrivialStyler extends MixStyler<TrivialStyler, TrivialSpec>',
            ),
          ),
        },
      );
    });

    test('fails loudly when a curated owner mixin cannot be resolved', () async {
      const input = '''
        library spike;
        import 'package:mix_annotations/mix_annotations.dart';

        part 'spike.spec_styler.g.part';

        // `EdgeInsetsGeometry` is in the curated registry, which maps it to
        // `SpacingStyleMixin` — but no library defining `SpacingStyleMixin` is
        // imported, so generation must fail rather than silently skip.
        class EdgeInsetsGeometry {}

        @MixableSpec()
        final class BrokenSpec {
          final EdgeInsetsGeometry? padding;
          const BrokenSpec({this.padding});
        }
      ''';

      final logs = <LogRecord>[];
      await testBuilder(
        PartBuilder([const SpecStylerGenerator()], '.spec_styler.g.part'),
        {...mixAnnotationsSources, 'mix|lib/spike.dart': input},
        onLog: logs.add,
      );

      expect(
        logs
            .where((r) => r.level == Level.SEVERE)
            .map((r) => r.message)
            .join('\n'),
        allOf(
          contains('SpacingStyleMixin'),
          contains('could not resolve'),
        ),
      );
    });

    test('rejects @MixableSpec applied to a non-class element', () async {
      const input = '''
        library spike;
        import 'package:mix_annotations/mix_annotations.dart';

        part 'spike.spec_styler.g.part';

        @MixableSpec()
        void notAClass() {}
      ''';

      final logs = <LogRecord>[];
      await testBuilder(
        PartBuilder([const SpecStylerGenerator()], '.spec_styler.g.part'),
        {...mixAnnotationsSources, 'mix|lib/spike.dart': input},
        onLog: logs.add,
      );

      expect(
        logs
            .where((r) => r.level == Level.SEVERE)
            .map((r) => r.message)
            .join('\n'),
        contains('@MixableSpec'),
      );
    });

    test('emits Prop<T>? fields matching spec constructor parameters', () async {
      const input = '''
        library spike;
        import 'package:mix_annotations/mix_annotations.dart';
        import 'src/spacing_style_mixin.dart';

        part 'spike.spec_styler.g.part';

        @MixableSpec()
        final class TrivialSpec {
          final EdgeInsetsGeometry? padding;
          final int? count;
          const TrivialSpec({this.padding, this.count});
        }
      ''';

      await testBuilder(
        PartBuilder([const SpecStylerGenerator()], '.spec_styler.g.part'),
        {
          ...mixAnnotationsSources,
          'mix|lib/src/spacing_style_mixin.dart': _spacingStyleMixinStub,
          'mix|lib/spike.dart': input,
        },
        outputs: {
          'mix|lib/spike.spec_styler.g.part': decodedMatches(
            allOf(
              contains(r'Prop<EdgeInsetsGeometry>? $padding'),
              contains(r'Prop<int>? $count'),
            ),
          ),
        },
      );
    });

    test('emits .create() const constructor and default constructor', () async {
      const input = '''
        library spike;
        import 'package:mix_annotations/mix_annotations.dart';
        import 'src/spacing_style_mixin.dart';

        part 'spike.spec_styler.g.part';

        @MixableSpec()
        final class TrivialSpec {
          final EdgeInsetsGeometry? padding;
          const TrivialSpec({this.padding});
        }
      ''';

      await testBuilder(
        PartBuilder([const SpecStylerGenerator()], '.spec_styler.g.part'),
        {
          ...mixAnnotationsSources,
          'mix|lib/src/spacing_style_mixin.dart': _spacingStyleMixinStub,
          'mix|lib/spike.dart': input,
        },
        outputs: {
          'mix|lib/spike.spec_styler.g.part': decodedMatches(
            allOf(
              contains('const TrivialStyler.create('),
              contains('Prop<EdgeInsetsGeometry>? padding'),
              contains('TrivialStyler({'),
              contains('EdgeInsetsGeometryMix? padding'),
              contains('Prop.maybeMix(padding)'),
            ),
          ),
        },
      );
    });

    test('emits dedup with-clause from ownerMixins of all field types', () async {
      const input = '''
        library spike;
        import 'package:mix_annotations/mix_annotations.dart';
        import 'src/box_like_mixins.dart';

        part 'spike.spec_styler.g.part';

        @MixableSpec()
        final class BoxLikeSpec {
          final EdgeInsetsGeometry? padding;
          final EdgeInsetsGeometry? margin;
          final BoxConstraints? constraints;
          final Decoration? decoration;
          final Clip? clipBehavior;
          const BoxLikeSpec({
            this.padding,
            this.margin,
            this.constraints,
            this.decoration,
            this.clipBehavior,
          });
        }
      ''';

      await testBuilder(
        PartBuilder([const SpecStylerGenerator()], '.spec_styler.g.part'),
        {
          ...mixAnnotationsSources,
          'mix|lib/src/box_like_mixins.dart': '''
            class EdgeInsetsGeometry {}
            class BoxConstraints {}
            class Decoration {}
            enum Clip { hardEdge }
            class EdgeInsetsGeometryMix {}
            class BoxConstraintsMix {}
            class DecorationMix {}

            mixin SpacingStyleMixin<T> {
              T padding(EdgeInsetsGeometryMix value);
              T margin(EdgeInsetsGeometryMix value);
            }
            mixin ConstraintStyleMixin<T> {
              T constraints(BoxConstraintsMix value);
            }
            mixin DecorationStyleMixin<T> {
              T decoration(DecorationMix value);
            }
            mixin BorderStyleMixin<T> {}
            mixin BorderRadiusStyleMixin<T> {}
            mixin ShadowStyleMixin<T> {}
          ''',
          'mix|lib/spike.dart': input,
        },
        outputs: {
          'mix|lib/spike.spec_styler.g.part': decodedMatches(
            allOf(
              contains('SpacingStyleMixin<BoxLikeStyler>'),
              contains('ConstraintStyleMixin<BoxLikeStyler>'),
              contains('DecorationStyleMixin<BoxLikeStyler>'),
              contains('BorderStyleMixin<BoxLikeStyler>'),
              contains('BorderRadiusStyleMixin<BoxLikeStyler>'),
              contains('ShadowStyleMixin<BoxLikeStyler>'),
            ),
          ),
        },
      );
    });

    test('emits styler mixin setters for unowned fields and owner anchors', () async {
      const input = '''
        library spike;
        import 'package:mix_annotations/mix_annotations.dart';
        import 'src/spacing_style_mixin.dart';

        part 'spike.spec_styler.g.part';

        enum Clip { hardEdge }

        @MixableSpec()
        final class BoxLikeSpec {
          final EdgeInsetsGeometry? padding;
          final Clip? clipBehavior;
          const BoxLikeSpec({this.padding, this.clipBehavior});
        }
      ''';

      await testBuilder(
        PartBuilder([const SpecStylerGenerator()], '.spec_styler.g.part'),
        {
          ...mixAnnotationsSources,
          'mix|lib/src/spacing_style_mixin.dart': '''
            class EdgeInsetsGeometry {}
            class EdgeInsetsGeometryMix {}
            mixin SpacingStyleMixin<T> {
              T padding(EdgeInsetsGeometryMix value);
            }
          ''',
          'mix|lib/spike.dart': input,
        },
        outputs: {
          'mix|lib/spike.spec_styler.g.part': decodedMatches(
            allOf(
              contains('BoxLikeStyler clipBehavior(Clip value)'),
              contains('BoxLikeStyler padding(EdgeInsetsGeometryMix value)'),
            ),
          ),
        },
      );
    });

    test('emits factory per mixin method and per unowned field setter', () async {
      const input = '''
        library spike;
        import 'package:mix_annotations/mix_annotations.dart';
        import 'src/constraint_style_mixin.dart';

        part 'spike.spec_styler.g.part';

        class BoxConstraints {}
        enum Clip { hardEdge }

        @MixableSpec()
        final class BoxLikeSpec {
          final BoxConstraints? constraints;
          final Clip? clipBehavior;
          const BoxLikeSpec({this.constraints, this.clipBehavior});
        }
      ''';

      await testBuilder(
        PartBuilder([const SpecStylerGenerator()], '.spec_styler.g.part'),
        {
          ...mixAnnotationsSources,
          'mix|lib/src/constraint_style_mixin.dart': '''
            class BoxConstraintsMix {}

            mixin ConstraintStyleMixin<T> {
              T constraints(BoxConstraintsMix value);
              T width(double value) => constraints(BoxConstraintsMix());
              T height(double value) => constraints(BoxConstraintsMix());
            }
          ''',
          'mix|lib/spike.dart': input,
        },
        outputs: {
          'mix|lib/spike.spec_styler.g.part': decodedMatches(
            allOf(
              contains('factory BoxLikeStyler.width(double value)'),
              contains('factory BoxLikeStyler.height(double value)'),
              contains('factory BoxLikeStyler.clipBehavior(Clip value)'),
            ),
          ),
        },
      );
    });

    test(r'emits with-clause that includes _$XStylerMixin and emits the mixin', () async {
      const input = r'''
        library spike;
        import 'package:mix_annotations/mix_annotations.dart';

        part 'spike.spec_styler.g.part';

        enum Clip { hardEdge }

        @MixableSpec()
        final class TinySpec {
          final Clip? clipBehavior;
          const TinySpec({this.clipBehavior});
        }
      ''';

      await testBuilder(
        PartBuilder([const SpecStylerGenerator()], '.spec_styler.g.part'),
        {...mixAnnotationsSources, 'mix|lib/spike.dart': input},
        outputs: {
          'mix|lib/spike.spec_styler.g.part': decodedMatches(
            allOf(
              contains(r'_$TinyStylerMixin'),
              contains(r'mixin _$TinyStylerMixin on Style<TinySpec>'),
            ),
          ),
        },
      );
    });

    test('generated BoxSpec-shaped styler is semantically valid', () async {
      const input = r'''
        library spike;
        import 'package:mix_annotations/mix_annotations.dart';

        part 'spike.g.dart';

        class BuildContext {}
        class DiagnosticPropertiesBuilder {
          void add(Object? property) {}
        }
        class DiagnosticsProperty<T> {
          const DiagnosticsProperty(String name, T value);
        }
        mixin Diagnosticable {
          void debugFillProperties(DiagnosticPropertiesBuilder properties) {}
        }

        abstract class Spec<T extends Spec<T>> {
          const Spec();
        }
        class StyleSpec<S extends Spec<S>> {
          const StyleSpec({required S spec, Object? animation, Object? widgetModifiers});
        }
        abstract class Style<S extends Spec<S>> with Diagnosticable {
          final List<VariantStyle<S>>? $variants;
          final WidgetModifierConfig? $modifier;
          final AnimationConfig? $animation;
          const Style({
            List<VariantStyle<S>>? variants,
            WidgetModifierConfig? modifier,
            AnimationConfig? animation,
          })
              : $variants = variants,
                $modifier = modifier,
                $animation = animation;
          dynamic merge(covariant dynamic other);
          StyleSpec<S> resolve(BuildContext context);
          List<Object?> get props;
        }
        abstract class MixStyler<ST extends Style<SP>, SP extends Spec<SP>>
            extends Style<SP> {
          const MixStyler({super.variants, super.modifier, super.animation});
        }
        class AnimationConfig {}
        class WidgetModifierConfig {
          Object? resolve(BuildContext context) => null;
        }
        class VariantStyle<S extends Spec<S>> {}
        class Prop<T> {
          static Prop<T>? maybe<T>(T? value) => null;
          static Prop<T>? maybeMix<T>(Object? value) => null;
        }
        class MixOps {
          static Prop<T>? merge<T>(Prop<T>? a, Prop<T>? b) => null;
          static List<VariantStyle<S>>? mergeVariants<S extends Spec<S>>(
            List<VariantStyle<S>>? a,
            List<VariantStyle<S>>? b,
          ) => null;
          static WidgetModifierConfig? mergeModifier(
            WidgetModifierConfig? a,
            WidgetModifierConfig? b,
          ) => null;
          static AnimationConfig? mergeAnimation(
            AnimationConfig? a,
            AnimationConfig? b,
          ) => null;
          static T? resolve<T>(BuildContext context, Prop<T>? prop) => null;
        }

        class EdgeInsetsGeometry {}
        class EdgeInsetsGeometryMix {}
        enum Clip { hardEdge }
        mixin SpacingStyleMixin<T> {
          T padding(EdgeInsetsGeometryMix value);
          T paddingAll(double v) => padding(EdgeInsetsGeometryMix());
        }

        @MixableSpec()
        final class TinyBoxSpec extends Spec<TinyBoxSpec> {
          final EdgeInsetsGeometry? padding;
          final Clip? clipBehavior;
          const TinyBoxSpec({this.padding, this.clipBehavior});
        }
      ''';

      await expectGeneratorOutputResolves(
        builder: PartBuilder([const SpecStylerGenerator()], '.g.dart'),
        sources: {
          ...mixAnnotationsSources,
          'mix|lib/spike.dart': input,
        },
        inputAsset: 'mix|lib/spike.dart',
        outputAsset: 'mix|lib/spike.g.dart',
      );
    });
  });
}
