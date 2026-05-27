import 'package:build_test/build_test.dart';
import 'package:logging/logging.dart';
import 'package:mix_generator/mix_generator.dart';
import 'package:source_gen/source_gen.dart';
import 'package:test/test.dart';

import '../core/test_helpers.dart';

const _mixSources = {'mix|lib/mix.dart': _mixStub};

/// Minimal `package:mix/mix.dart` surface used by the
/// standalone styler tests.
const _mixStub = '''
  import 'package:flutter/foundation.dart';

  abstract class Spec<T extends Spec<T>> {
    const Spec();
  }

  class StyleSpec<S extends Spec<S>> {
    const StyleSpec({required S spec, Object? animation, Object? widgetModifiers});
  }

  abstract class Style<S extends Spec<S>> {
    final List<VariantStyle<S>>? \$variants;
    final WidgetModifierConfig? \$modifier;
    final AnimationConfig? \$animation;

    const Style({
      List<VariantStyle<S>>? variants,
      WidgetModifierConfig? modifier,
      AnimationConfig? animation,
    }) : \$variants = variants,
         \$modifier = modifier,
         \$animation = animation;
  }

  abstract class MixStyler<ST extends Style<SP>, SP extends Spec<SP>>
      extends Style<SP> with Diagnosticable {
    const MixStyler({super.variants, super.modifier, super.animation});
  }

  class AnimationConfig {}
  class WidgetModifierConfig {
    Object? resolve(Object context) => null;
  }
  class VariantStyle<S extends Spec<S>> {}
  class Directive<T> {}

  class Prop<T> {
    static Prop<T>? maybe<T>(T? value) => null;
    static Prop<T>? maybeMix<T>(Object? value) => null;
  }

  class MixOps {
    static Prop<T>? merge<T>(Prop<T>? a, Prop<T>? b) => null;
    static List<T>? mergeList<T>(List<T>? a, List<T>? b) => null;
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
    static T? resolve<T>(Object context, Prop<T>? prop) => null;
  }

  class EdgeInsetsGeometryMix {}
  class BoxConstraintsMix {}
  class DecorationMix {}
  class Matrix4 {}
  class Alignment {
    static const center = Alignment();
    const Alignment();
  }

  mixin SpacingStyleMixin<T> {
    T padding(EdgeInsetsGeometryMix value);
    T margin(EdgeInsetsGeometryMix value);
    T paddingAll(double value) => padding(EdgeInsetsGeometryMix());
  }

  mixin ConstraintStyleMixin<T> {
    T constraints(BoxConstraintsMix value);
    T width(double value) => constraints(BoxConstraintsMix());
    T height(double value) => constraints(BoxConstraintsMix());
  }

  mixin DecorationStyleMixin<T> {
    T decoration(DecorationMix value);
  }

  mixin BorderStyleMixin<T> {}
  mixin BorderRadiusStyleMixin<T> {}
  mixin ShadowStyleMixin<T> {}
  mixin TransformStyleMixin<T> {
    T transform(Matrix4 value, {Alignment alignment = Alignment.center});
    T scale(double value, {Alignment alignment = Alignment.center}) {
      return transform(Matrix4(), alignment: alignment);
    }
  }
''';

const _mixWithoutSpacingMixin = '''
  class EdgeInsetsGeometryMix {}
  mixin ConstraintStyleMixin<T> {}
''';

const _flutterResolveStubs = {
  'flutter|lib/foundation.dart': '''
    class DiagnosticPropertiesBuilder {
      void add(Object? property) {}
    }

    class DiagnosticsProperty<T> {
      const DiagnosticsProperty(String name, T value);
    }

    mixin Diagnosticable {
      void debugFillProperties(DiagnosticPropertiesBuilder properties) {}
    }
  ''',
  'flutter|lib/widgets.dart': '''
    export 'foundation.dart';

    class BuildContext {}
  ''',
};

LibraryBuilder _specStylerLibraryBuilder() {
  return LibraryBuilder(
    const SpecStylerGenerator(),
    generatedExtension: '.styler.g.dart',
  );
}

void main() {
  group('SpecStylerGenerator smoke', () {
    test('emits a class shell for a trivial spec', () async {
      const input = '''
        library spike;
        import 'package:mix_annotations/mix_annotations.dart';
        @MixableSpec()
        final class TrivialSpec {
          final int? count;
          const TrivialSpec({this.count});
        }
      ''';

      await testBuilder(
        _specStylerLibraryBuilder(),
        {...mixAnnotationsSources, ..._mixSources, 'mix|lib/spike.dart': input},
        outputs: {
          'mix|lib/spike.styler.g.dart': decodedMatches(
            contains(
              'class TrivialStyler extends MixStyler<TrivialStyler, TrivialSpec>',
            ),
          ),
        },
      );
    });

    test('resolves curated owner mixins from public Mix library', () async {
      const input = '''
        library spike;
        import 'package:mix_annotations/mix_annotations.dart';
        class EdgeInsetsGeometry {}

        @MixableSpec()
        final class SupportedSpec {
          final EdgeInsetsGeometry? padding;
          const SupportedSpec({this.padding});
        }
      ''';

      await testBuilder(
        _specStylerLibraryBuilder(),
        {...mixAnnotationsSources, ..._mixSources, 'mix|lib/spike.dart': input},
        outputs: {
          'mix|lib/spike.styler.g.dart': decodedMatches(
            allOf(
              contains('SpacingStyleMixin<SupportedStyler>'),
              contains(
                'factory SupportedStyler.padding(EdgeInsetsGeometryMix value)',
              ),
              isNot(
                contains('factory SupportedStyler.paddingAll(double value)'),
              ),
            ),
          ),
        },
      );
    });

    test(
      'fails loudly when public Mix library does not export a curated owner mixin',
      () async {
        const input = '''
        library spike;
        import 'package:mix_annotations/mix_annotations.dart';
        class EdgeInsetsGeometry {}

        @MixableSpec()
        final class BrokenSpec {
          final EdgeInsetsGeometry? padding;
          const BrokenSpec({this.padding});
        }
      ''';

        final logs = <LogRecord>[];
        await testBuilder(_specStylerLibraryBuilder(), {
          ...mixAnnotationsSources,
          'mix|lib/mix.dart': _mixWithoutSpacingMixin,
          'mix|lib/spike.dart': input,
        }, onLog: logs.add);

        expect(
          logs
              .where((r) => r.level == Level.SEVERE)
              .map((r) => r.message)
              .join('\n'),
          allOf(contains('SpacingStyleMixin'), contains('mix.dart')),
        );
      },
    );

    test('rejects @MixableSpec applied to a non-class element', () async {
      const input = '''
        library spike;
        import 'package:mix_annotations/mix_annotations.dart';
        @MixableSpec()
        void notAClass() {}
      ''';

      final logs = <LogRecord>[];
      await testBuilder(_specStylerLibraryBuilder(), {
        ...mixAnnotationsSources,
        'mix|lib/spike.dart': input,
      }, onLog: logs.add);

      expect(
        logs
            .where((r) => r.level == Level.SEVERE)
            .map((r) => r.message)
            .join('\n'),
        contains('@MixableSpec'),
      );
    });

    test(
      'emits Prop<T>? fields matching spec constructor parameters',
      () async {
        const input = '''
        library spike;
        import 'package:mix_annotations/mix_annotations.dart';
        class EdgeInsetsGeometry {}
        @MixableSpec()
        final class TrivialSpec {
          final EdgeInsetsGeometry? padding;
          final int? count;
          const TrivialSpec({this.padding, this.count});
        }
      ''';

        await testBuilder(
          _specStylerLibraryBuilder(),
          {
            ...mixAnnotationsSources,
            ..._mixSources,
            'mix|lib/spike.dart': input,
          },
          outputs: {
            'mix|lib/spike.styler.g.dart': decodedMatches(
              allOf(
                contains(r'Prop<EdgeInsetsGeometry>? $padding'),
                contains(r'Prop<int>? $count'),
              ),
            ),
          },
        );
      },
    );

    test('emits .create() const constructor and default constructor', () async {
      const input = '''
        library spike;
        import 'package:mix_annotations/mix_annotations.dart';
        class EdgeInsetsGeometry {}
        @MixableSpec()
        final class TrivialSpec {
          final EdgeInsetsGeometry? padding;
          const TrivialSpec({this.padding});
        }
      ''';

      await testBuilder(
        _specStylerLibraryBuilder(),
        {...mixAnnotationsSources, ..._mixSources, 'mix|lib/spike.dart': input},
        outputs: {
          'mix|lib/spike.styler.g.dart': decodedMatches(
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

    test(
      'emits dedup with-clause from ownerMixins of all field types',
      () async {
        const input = '''
        library spike;
        import 'package:mix_annotations/mix_annotations.dart';
        class EdgeInsetsGeometry {}
        class BoxConstraints {}
        class Decoration {}
        enum Clip { hardEdge }

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
          _specStylerLibraryBuilder(),
          {
            ...mixAnnotationsSources,
            ..._mixSources,
            'mix|lib/spike.dart': input,
          },
          outputs: {
            'mix|lib/spike.styler.g.dart': decodedMatches(
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
      },
    );

    test(
      'emits styler mixin setters for unowned fields and owner anchors',
      () async {
        const input = '''
        library spike;
        import 'package:mix_annotations/mix_annotations.dart';
        class EdgeInsetsGeometry {}
        enum Clip { hardEdge }

        @MixableSpec()
        final class BoxLikeSpec {
          final EdgeInsetsGeometry? padding;
          final Clip? clipBehavior;
          const BoxLikeSpec({this.padding, this.clipBehavior});
        }
      ''';

        await testBuilder(
          _specStylerLibraryBuilder(),
          {
            ...mixAnnotationsSources,
            ..._mixSources,
            'mix|lib/spike.dart': input,
          },
          outputs: {
            'mix|lib/spike.styler.g.dart': decodedMatches(
              allOf(
                contains('BoxLikeStyler clipBehavior(Clip value)'),
                contains('BoxLikeStyler padding(EdgeInsetsGeometryMix value)'),
              ),
            ),
          },
        );
      },
    );

    test('keeps curated raw-list fields unwrapped', () async {
      const input = '''
        library spike;
        import 'package:mix/mix.dart' show Directive;
        import 'package:mix_annotations/mix_annotations.dart';

        @MixableSpec()
        final class TextSpec {
          final List<Directive<String>>? textDirectives;
          const TextSpec({this.textDirectives});
        }
      ''';

      await testBuilder(
        _specStylerLibraryBuilder(),
        {...mixAnnotationsSources, ..._mixSources, 'mix|lib/spike.dart': input},
        outputs: {
          'mix|lib/spike.styler.g.dart': decodedMatches(
            allOf(
              contains(r'final List<Directive<String>>? $textDirectives;'),
              contains('List<Directive<String>>? textDirectives,'),
              contains('textDirectives: textDirectives,'),
              isNot(contains('Prop<List<Directive<String>>>')),
              isNot(contains('Prop.maybe(textDirectives)')),
              isNot(contains('factory TextStyler.textDirectives(')),
              isNot(contains('TextStyler textDirectives(')),
            ),
          ),
        },
      );
    });

    test('honors field factory and setter controls', () async {
      const input = '''
        library spike;
        import 'package:mix_annotations/mix_annotations.dart';

        enum Clip { hardEdge }

        @MixableSpec()
        final class ControlSpec {
          @MixableField(skipFactory: true)
          final Clip? clipped;

          @MixableField(ignoreSetter: true)
          final int? ignored;

          @MixableField(factoryName: 'visibility')
          final bool? visible;

          const ControlSpec({this.clipped, this.ignored, this.visible});
        }
      ''';

      await testBuilder(
        _specStylerLibraryBuilder(),
        {...mixAnnotationsSources, ..._mixSources, 'mix|lib/spike.dart': input},
        outputs: {
          'mix|lib/spike.styler.g.dart': decodedMatches(
            allOf([
              contains('ControlStyler clipped(Clip value)'),
              isNot(contains('factory ControlStyler.clipped(Clip value)')),
              isNot(contains('ControlStyler ignored(int value)')),
              isNot(contains('factory ControlStyler.ignored(int value)')),
              contains('ControlStyler visible(bool value)'),
              contains('factory ControlStyler.visibility(bool value)'),
              isNot(contains('factory ControlStyler.visible(bool value)')),
            ]),
          ),
        },
      );
    });

    test('copies source imports needed by field type arguments', () async {
      const boxSpec = '''
          import 'package:mix/mix.dart';

          final class BoxSpec extends Spec<BoxSpec> {
            const BoxSpec();
          }
        ''';
      const flexSpec = '''
          import 'package:mix/mix.dart';

          final class FlexSpec extends Spec<FlexSpec> {
            const FlexSpec();
          }
        ''';
      const input = '''
          library combo;
          import 'package:mix/mix.dart' show Spec, StyleSpec;
          import 'package:mix_annotations/mix_annotations.dart';

          import '../box/box_spec.dart';
          import '../flex/flex_spec.dart';

          @MixableSpec()
          final class ComboSpec extends Spec<ComboSpec> {
            final StyleSpec<BoxSpec>? box;
            final StyleSpec<FlexSpec>? flex;
            const ComboSpec({this.box, this.flex});
          }
        ''';

      await expectGeneratorOutputResolves(
        builder: _specStylerLibraryBuilder(),
        sources: {
          ...mixAnnotationsSources,
          ..._mixSources,
          ..._flutterResolveStubs,
          'mix|lib/src/box/box_spec.dart': boxSpec,
          'mix|lib/src/flex/flex_spec.dart': flexSpec,
          'mix|lib/src/combo/combo_spec.dart': input,
        },
        inputAsset: 'mix|lib/src/combo/combo_spec.dart',
        outputAsset: 'mix|lib/src/combo/combo_spec.styler.g.dart',
        resolveAsset: 'mix|lib/src/combo/combo_spec.styler.g.dart',
      );
    });

    test('emits curated transform anchor with alignment', () async {
      const input = '''
        library spike;
        import 'package:mix/mix.dart' show Alignment, Matrix4;
        import 'package:mix_annotations/mix_annotations.dart';

        @MixableSpec()
        final class TransformSpec {
          final Matrix4? transform;
          final Alignment? transformAlignment;
          const TransformSpec({this.transform, this.transformAlignment});
        }
      ''';

      await testBuilder(
        _specStylerLibraryBuilder(),
        {...mixAnnotationsSources, ..._mixSources, 'mix|lib/spike.dart': input},
        outputs: {
          'mix|lib/spike.styler.g.dart': decodedMatches(
            allOf([
              contains('TransformStyleMixin<TransformStyler>'),
              contains('factory TransformStyler.transform('),
              contains(
                'TransformStyler transform(Matrix4 value, {Alignment alignment = .center})',
              ),
              contains('TransformStyler(transform: value,'),
              contains('transformAlignment: alignment'),
              isNot(
                contains(
                  'factory TransformStyler.transformAlignment(Alignment value)',
                ),
              ),
              isNot(
                contains('TransformStyler transformAlignment(Alignment value)'),
              ),
              isNot(
                contains('return merge(TransformStyler(transform: value));'),
              ),
            ]),
          ),
        },
      );
    });

    test(
      'emits direct field factories without mixin convenience factories',
      () async {
        const input = '''
        library spike;
        import 'package:mix_annotations/mix_annotations.dart';
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
          _specStylerLibraryBuilder(),
          {
            ...mixAnnotationsSources,
            ..._mixSources,
            'mix|lib/spike.dart': input,
          },
          outputs: {
            'mix|lib/spike.styler.g.dart': decodedMatches(
              allOf(
                contains(
                  'factory BoxLikeStyler.constraints(BoxConstraintsMix value)',
                ),
                contains('factory BoxLikeStyler.clipBehavior(Clip value)'),
                isNot(contains('factory BoxLikeStyler.width(double value)')),
                isNot(contains('factory BoxLikeStyler.height(double value)')),
              ),
            ),
          },
        );
      },
    );

    test(
      'uses annotation-provided owner mixin element for custom mixins',
      () async {
        const input = '''
        library spike;
        import 'package:mix/mix.dart' show EdgeInsetsGeometryMix;
        import 'package:mix_annotations/mix_annotations.dart';

        class EdgeInsetsGeometry {}

        mixin CustomSpacingMixin<T> {
          T padding(EdgeInsetsGeometryMix value);
          T customPadding(EdgeInsetsGeometryMix value) => padding(value);
        }

        @MixableSpec()
        final class CustomSpec {
          @MixableField(mixin: CustomSpacingMixin)
          final EdgeInsetsGeometry? padding;
          const CustomSpec({this.padding});
        }
      ''';

        await testBuilder(
          _specStylerLibraryBuilder(),
          {
            ...mixAnnotationsSources,
            ..._mixSources,
            'mix|lib/spike.dart': input,
          },
          outputs: {
            'mix|lib/spike.styler.g.dart': decodedMatches(
              allOf(
                contains('CustomSpacingMixin<CustomStyler>'),
                contains(
                  'factory CustomStyler.padding(EdgeInsetsGeometryMix value)',
                ),
                isNot(
                  contains(
                    'factory CustomStyler.customPadding(EdgeInsetsGeometryMix value)',
                  ),
                ),
                isNot(contains('SpacingStyleMixin<CustomStyler>')),
              ),
            ),
          },
        );
      },
    );

    test(
      r'emits with-clause that includes _$XStylerMixin and emits the mixin',
      () async {
        const input = r'''
        library spike;
        import 'package:mix_annotations/mix_annotations.dart';
        enum Clip { hardEdge }

        @MixableSpec()
        final class TinySpec {
          final Clip? clipBehavior;
          const TinySpec({this.clipBehavior});
        }
      ''';

        await testBuilder(
          _specStylerLibraryBuilder(),
          {
            ...mixAnnotationsSources,
            ..._mixSources,
            'mix|lib/spike.dart': input,
          },
          outputs: {
            'mix|lib/spike.styler.g.dart': decodedMatches(
              allOf(
                contains(r'_$TinyStylerMixin'),
                contains(r'mixin _$TinyStylerMixin on Style<TinySpec>'),
              ),
            ),
          },
        );
      },
    );

    test('generated BoxSpec-shaped styler is semantically valid', () async {
      const input = r'''
        library spike;
        import 'package:mix/mix.dart' show Spec;
        import 'package:mix_annotations/mix_annotations.dart';

        class EdgeInsetsGeometry {}
        enum Clip { hardEdge }

        @MixableSpec()
        final class TinyBoxSpec extends Spec<TinyBoxSpec> {
          final EdgeInsetsGeometry? padding;
          final EdgeInsetsGeometry? margin;
          final Clip? clipBehavior;
          const TinyBoxSpec({this.padding, this.margin, this.clipBehavior});
        }
      ''';

      await expectGeneratorOutputResolves(
        builder: _specStylerLibraryBuilder(),
        sources: {
          ...mixAnnotationsSources,
          ..._mixSources,
          ..._flutterResolveStubs,
          'mix|lib/spike.dart': input,
        },
        inputAsset: 'mix|lib/spike.dart',
        outputAsset: 'mix|lib/spike.styler.g.dart',
        resolveAsset: 'mix|lib/spike.styler.g.dart',
      );
    });

    test(
      'emits a standalone library with package:mix/mix.dart import',
      () async {
        const input = '''
        library spike;
        import 'package:mix_annotations/mix_annotations.dart';

        enum Clip { hardEdge }

        @MixableSpec()
        final class TinySpec {
          final Clip? clipBehavior;
          const TinySpec({this.clipBehavior});
        }
      ''';

        await testBuilder(
          LibraryBuilder(
            const SpecStylerGenerator(),
            generatedExtension: '.styler.g.dart',
          ),
          {
            ...mixAnnotationsSources,
            ..._mixSources,
            'mix|lib/spike.dart': input,
          },
          outputs: {
            'mix|lib/spike.styler.g.dart': decodedMatches(
              allOf(
                contains('// GENERATED CODE - DO NOT MODIFY BY HAND'),
                contains("import 'package:mix/mix.dart';"),
                contains("import 'spike.dart';"),
                isNot(contains('part of')),
                contains(
                  'class TinyStyler extends MixStyler<TinyStyler, TinySpec>',
                ),
              ),
            ),
          },
        );
      },
    );

    test('does not duplicate source package:mix/mix.dart imports', () async {
      const input = '''
        library spike;
        import 'package:mix/mix.dart';
        import 'package:mix_annotations/mix_annotations.dart';

        enum Clip { hardEdge }

        @MixableSpec()
        final class TinySpec {
          final Clip? clipBehavior;
          const TinySpec({this.clipBehavior});
        }
      ''';

      await testBuilder(
        _specStylerLibraryBuilder(),
        {...mixAnnotationsSources, ..._mixSources, 'mix|lib/spike.dart': input},
        outputs: {
          'mix|lib/spike.styler.g.dart': decodedMatches(
            predicate<String>(
              (source) =>
                  RegExp(
                    RegExp.escape("import 'package:mix/mix.dart';"),
                  ).allMatches(source).length ==
                  1,
              "contains exactly one import 'package:mix/mix.dart';",
            ),
          ),
        },
      );
    });
  });
}
