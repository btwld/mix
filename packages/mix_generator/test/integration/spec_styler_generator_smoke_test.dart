import 'package:build_test/build_test.dart';
import 'package:logging/logging.dart';
import 'package:mix_generator/mix_generator.dart';
import 'package:source_gen/source_gen.dart';
import 'package:test/test.dart';

import '../core/test_helpers.dart';

const _mixSources = {'mix|lib/mix.dart': _mixStub};
const _mixSourcesWithStyleWidget = {
  ..._mixSources,
  'mix|lib/src/core/style_widget.dart': '''
    import 'package:flutter/widgets.dart';
    import 'package:mix/mix.dart';

    abstract class StyleWidget<S extends Spec<S>> extends Widget {
      final Style<S> style;
      final StyleSpec<S>? styleSpec;

      const StyleWidget({
        required this.style,
        this.styleSpec,
        super.key,
      });
    }
  ''',
};

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
    static WidgetModifierConfig defaultTextStyler(Object value) => WidgetModifierConfig();
    Object? resolve(Object context) => null;
  }
  class VariantStyle<S extends Spec<S>> {}
  class Directive<T> {}

  class Prop<T> {
    static Prop<T>? maybe<T>(T? value) => null;
    static Prop<T>? maybeMix<T>(Object? value) => null;
    static Prop<T>? mix<T>(Object value) => null;
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
  class DecorationImageMix {}
  class ShapeBorderMix {}
  class GradientMix {}
  class BoxBorderMix {}
  class BorderRadiusGeometryMix {}
  class BoxShadowMix {}
  class ShadowMix {}
  class TextStyleMix {}
  class TextStyler {}
  class ImageProvider<T> {}
  class Color {}
  class BoxFit {}
  class ImageRepeat {
    static const noRepeat = ImageRepeat();
    const ImageRepeat();
  }
  class AlignmentGeometry {}
  class TileMode {}
  class ShapeBorder {}
  class FontWeight {}
  class FontStyle {}
  class TextDecoration {}
  class TextDecorationStyle {}
  class FontFeature {}
  class FontVariation {}
  class Paint {}
  class Matrix4 {}
  class Alignment extends AlignmentGeometry {
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
    T size(double width, double height) => constraints(BoxConstraintsMix());
  }

  mixin DecorationStyleMixin<T> {
    T decoration(DecorationMix value);
    T color(Color value) => decoration(DecorationMix());
    T gradient(GradientMix value) => decoration(DecorationMix());
  }

  mixin BorderStyleMixin<T> {}
  mixin BorderRadiusStyleMixin<T> {}
  mixin ShadowStyleMixin<T> {}
  mixin TransformStyleMixin<T> {
    T transform(Matrix4 value, {Alignment alignment = Alignment.center});
    T scale(double value, {Alignment alignment = Alignment.center}) {
      return transform(Matrix4(), alignment: alignment);
    }
    T translate(double x, double y, [double z = 0.0]) => transform(Matrix4());
  }

  mixin FlexStyleMixin<T> {
    T flex(FlexStyler value);
    T direction(Axis value) => flex(FlexStyler(direction: value));
    T row() => direction(Axis.horizontal);
    T column() => direction(Axis.vertical);
  }

  class FlexStyler {
    FlexStyler({
      Axis? direction,
      Object? mainAxisAlignment,
      Object? crossAxisAlignment,
      Object? mainAxisSize,
      Object? verticalDirection,
      Object? textDirection,
      Object? textBaseline,
      Object? clipBehavior,
      double? spacing,
    });

    FlexStyler direction(Axis value) => this;
    FlexStyler mainAxisAlignment(Object value) => this;
    FlexStyler crossAxisAlignment(Object value) => this;
    FlexStyler mainAxisSize(Object value) => this;
    FlexStyler verticalDirection(Object value) => this;
    FlexStyler textDirection(Object value) => this;
    FlexStyler textBaseline(Object value) => this;
    FlexStyler clipBehavior(Object value) => this;
    FlexStyler spacing(double value) => this;
  }

  enum Axis { horizontal, vertical }

  class StackStyler {
    StackStyler({
      AlignmentGeometry? alignment,
      Object? fit,
      Object? textDirection,
      Object? clipBehavior,
    });

    StackStyler alignment(AlignmentGeometry value) => this;
    StackStyler fit(Object value) => this;
    StackStyler textDirection(Object value) => this;
    StackStyler clipBehavior(Object value) => this;
  }

  mixin TextStyleMixin<T> {
    T style(TextStyleMix value);
    T color(Color value) => style(TextStyleMix());
    T fontSize(double value) => style(TextStyleMix());
  }

  mixin StackStyleMixin<T> {
    T alignment(AlignmentGeometry value);
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
  'flutter|lib/src/foundation/key.dart': '''
    class Key {
      const Key();
    }
  ''',
  'flutter|lib/src/widgets/framework.dart': '''
    import '../foundation/key.dart';
    export '../foundation/key.dart';

    abstract class Widget {
      const Widget({this.key});
      final Key? key;
    }

    class BuildContext {}
  ''',
  'flutter|lib/widgets.dart': '''
    export 'foundation.dart';
    export 'src/widgets/framework.dart';
  ''',
};

LibraryBuilder _specStylerLibraryBuilder() {
  return LibraryBuilder(
    const SpecStylerGenerator(),
    generatedExtension: '.styler.g.dart',
  );
}

Future<String> _expectSpecStylerValidationError(
  Map<String, String> sources, {
  String inputAsset = 'mix|lib/spike.dart',
}) async {
  final logs = <LogRecord>[];
  await testBuilder(
    _specStylerLibraryBuilder(),
    sources,
    generateFor: {inputAsset},
    onLog: logs.add,
  );

  return logs
      .where((r) => r.level == Level.SEVERE)
      .map((r) => r.message)
      .join('\n');
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

    test('omits call method when target is not configured', () async {
      const input = '''
        library spike;
        import 'package:mix_annotations/mix_annotations.dart';
        @MixableSpec()
        final class PlainSpec {
          const PlainSpec();
        }
      ''';

      await testBuilder(
        _specStylerLibraryBuilder(),
        {...mixAnnotationsSources, ..._mixSources, 'mix|lib/spike.dart': input},
        outputs: {
          'mix|lib/spike.styler.g.dart': decodedMatches(
            isNot(contains('Plain call(')),
          ),
        },
      );
    });

    test('emits widget call methods from MixableSpec targets', () async {
      const boxInput = '''
        library box_shape;
        import 'package:flutter/widgets.dart';
        import 'package:mix/mix.dart';
        import 'package:mix/src/core/style_widget.dart';
        import 'package:mix_annotations/mix_annotations.dart';

        @MixableSpec(target: Box.new)
        final class BoxSpec extends Spec<BoxSpec> {
          const BoxSpec();
        }

        class Box extends StyleWidget<BoxSpec> {
          const Box({
            super.key,
            required super.style,
            super.styleSpec,
            this.child,
          });

          final Widget? child;
        }
      ''';
      const textInput = '''
        library text_shape;
        import 'package:flutter/widgets.dart';
        import 'package:mix/mix.dart';
        import 'package:mix/src/core/style_widget.dart';
        import 'package:mix_annotations/mix_annotations.dart';

        @MixableSpec(target: StyledText.new)
        final class TextSpec extends Spec<TextSpec> {
          const TextSpec();
        }

        class StyledText extends StyleWidget<TextSpec> {
          const StyledText(this.text, {super.key, required super.style});

          final String text;
        }
      ''';
      const flexInput = '''
        library flex_shape;
        import 'package:flutter/widgets.dart';
        import 'package:mix/mix.dart';
        import 'package:mix/src/core/style_widget.dart';
        import 'package:mix_annotations/mix_annotations.dart';

        @MixableSpec(target: FlexBox.new)
        final class FlexBoxSpec extends Spec<FlexBoxSpec> {
          const FlexBoxSpec();
        }

        class FlexBox extends StyleWidget<FlexBoxSpec> {
          const FlexBox({
            super.key,
            required super.style,
            this.children = const <Widget>[],
          });

          final List<Widget> children;
        }
      ''';

      await expectGeneratorOutputResolves(
        builder: _specStylerLibraryBuilder(),
        sources: {
          ...mixAnnotationsSources,
          ..._flutterResolveStubs,
          ..._mixSourcesWithStyleWidget,
          'mix|lib/box_shape.dart': boxInput,
        },
        inputAsset: 'mix|lib/box_shape.dart',
        outputAsset: 'mix|lib/box_shape.styler.g.dart',
        outputMatcher: allOf(
          contains('Box call({Key? key, Widget? child})'),
          contains('return Box(key: key, style: this, child: child);'),
        ),
      );

      await expectGeneratorOutputResolves(
        builder: _specStylerLibraryBuilder(),
        sources: {
          ...mixAnnotationsSources,
          ..._flutterResolveStubs,
          ..._mixSourcesWithStyleWidget,
          'mix|lib/text_shape.dart': textInput,
        },
        inputAsset: 'mix|lib/text_shape.dart',
        outputAsset: 'mix|lib/text_shape.styler.g.dart',
        outputMatcher: allOf(
          contains('StyledText call(String text, {Key? key})'),
          contains('return StyledText(text, key: key, style: this);'),
        ),
      );

      await expectGeneratorOutputResolves(
        builder: _specStylerLibraryBuilder(),
        sources: {
          ...mixAnnotationsSources,
          ..._flutterResolveStubs,
          ..._mixSourcesWithStyleWidget,
          'mix|lib/flex_shape.dart': flexInput,
        },
        inputAsset: 'mix|lib/flex_shape.dart',
        outputAsset: 'mix|lib/flex_shape.styler.g.dart',
        outputMatcher: allOf(
          contains(
            'FlexBox call({Key? key, List<Widget> children = const <Widget>[]})',
          ),
          contains(
            'return FlexBox(key: key, style: this, children: children);',
          ),
        ),
      );
    });

    test('preserves source imports needed by target widgets', () async {
      const specInput = '''
        library box_spec;
        import 'package:flutter/widgets.dart';
        import 'package:mix/mix.dart';
        import 'package:mix_annotations/mix_annotations.dart';
        import 'box_widget.dart';

        @MixableSpec(target: Box.new)
        final class BoxSpec extends Spec<BoxSpec> {
          const BoxSpec();
        }
      ''';
      const widgetInput = '''
        import 'package:flutter/widgets.dart';
        import 'package:mix/src/core/style_widget.dart';
        import 'box_spec.dart';

        class Box extends StyleWidget<BoxSpec> {
          const Box({super.key, required super.style, this.child});

          final Widget? child;
        }
      ''';

      await expectGeneratorOutputResolves(
        builder: _specStylerLibraryBuilder(),
        sources: {
          ...mixAnnotationsSources,
          ..._flutterResolveStubs,
          ..._mixSourcesWithStyleWidget,
          'mix|lib/box_spec.dart': specInput,
          'mix|lib/box_widget.dart': widgetInput,
        },
        inputAsset: 'mix|lib/box_spec.dart',
        outputAsset: 'mix|lib/box_spec.styler.g.dart',
        outputMatcher: contains("import 'box_widget.dart';"),
      );
    });

    test('rejects target values that are not constructor tear-offs', () async {
      const input = '''
        library spike;
        import 'package:mix/mix.dart';
        import 'package:mix_annotations/mix_annotations.dart';

        Object notAConstructor() => Object();

        @MixableSpec(target: notAConstructor)
        final class BoxSpec extends Spec<BoxSpec> {
          const BoxSpec();
        }
      ''';

      final errors = await _expectSpecStylerValidationError({
        ...mixAnnotationsSources,
        ..._flutterResolveStubs,
        ..._mixSourcesWithStyleWidget,
        'mix|lib/spike.dart': input,
      });

      expect(errors, contains('must be a constructor tear-off'));
    });

    test('rejects target widgets that do not extend StyleWidget', () async {
      const input = '''
        library spike;
        import 'package:flutter/widgets.dart';
        import 'package:mix/mix.dart';
        import 'package:mix_annotations/mix_annotations.dart';

        class PlainWidget extends Widget {
          const PlainWidget({super.key});
        }

        @MixableSpec(target: PlainWidget.new)
        final class BoxSpec extends Spec<BoxSpec> {
          const BoxSpec();
        }
      ''';

      final errors = await _expectSpecStylerValidationError({
        ...mixAnnotationsSources,
        ..._flutterResolveStubs,
        ..._mixSourcesWithStyleWidget,
        'mix|lib/spike.dart': input,
      });

      expect(errors, contains('must extend StyleWidget<BoxSpec>'));
    });

    test('rejects StyleWidget targets for a different spec type', () async {
      const input = '''
        library spike;
        import 'package:mix/mix.dart';
        import 'package:mix/src/core/style_widget.dart';
        import 'package:mix_annotations/mix_annotations.dart';

        final class OtherSpec extends Spec<OtherSpec> {
          const OtherSpec();
        }

        class MismatchedWidget extends StyleWidget<OtherSpec> {
          const MismatchedWidget({required super.style});
        }

        @MixableSpec(target: MismatchedWidget.new)
        final class BoxSpec extends Spec<BoxSpec> {
          const BoxSpec();
        }
      ''';

      final errors = await _expectSpecStylerValidationError({
        ...mixAnnotationsSources,
        ..._flutterResolveStubs,
        ..._mixSourcesWithStyleWidget,
        'mix|lib/spike.dart': input,
      });

      expect(errors, contains('Spec generic mismatch'));
      expect(errors, contains('StyleWidget<OtherSpec>'));
    });

    test(
      'rejects target constructors with optional positional params',
      () async {
        const input = '''
        library spike;
        import 'package:flutter/widgets.dart';
        import 'package:mix/mix.dart';
        import 'package:mix/src/core/style_widget.dart';
        import 'package:mix_annotations/mix_annotations.dart';

        class _Style extends Style<BoxSpec> {
          const _Style();
        }

        class BadWidget extends StyleWidget<BoxSpec> {
          const BadWidget([this.child]) : super(style: const _Style());

          final Widget? child;
        }

        @MixableSpec(target: BadWidget.new)
        final class BoxSpec extends Spec<BoxSpec> {
          const BoxSpec();
        }
      ''';

        final errors = await _expectSpecStylerValidationError({
          ...mixAnnotationsSources,
          ..._flutterResolveStubs,
          ..._mixSourcesWithStyleWidget,
          'mix|lib/spike.dart': input,
        });

        expect(errors, contains('does not support optional positional'));
      },
    );

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
            allOf([
              contains('const TrivialStyler.create('),
              contains('Prop<EdgeInsetsGeometry>? padding'),
              contains('TrivialStyler({'),
              contains('EdgeInsetsGeometryMix? padding'),
              contains('Prop.maybeMix(padding)'),
              contains('TrivialStyler animate(AnimationConfig value)'),
              contains(
                'TrivialStyler variants(List<VariantStyle<TrivialSpec>> value)',
              ),
              contains('TrivialStyler wrap(WidgetModifierConfig value)'),
              contains('TrivialStyler modifier(WidgetModifierConfig value)'),
            ]),
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

    test('emits curated Box convenience factories', () async {
      const input = '''
        library spike;
        import 'package:mix/mix.dart'
            show Alignment, AlignmentGeometry, Matrix4, TextStyler;
        import 'package:mix_annotations/mix_annotations.dart';

        class EdgeInsetsGeometry {}
        class BoxConstraints {}
        class Decoration {}
        enum Clip { hardEdge }

        @MixableSpec()
        final class BoxSpec {
          final EdgeInsetsGeometry? padding;
          final BoxConstraints? constraints;
          final Decoration? decoration;
          final Matrix4? transform;
          final AlignmentGeometry? transformAlignment;
          final Clip? clipBehavior;
          const BoxSpec({
            this.padding,
            this.constraints,
            this.decoration,
            this.transform,
            this.transformAlignment,
            this.clipBehavior,
          });
        }
      ''';

      await testBuilder(
        _specStylerLibraryBuilder(),
        {...mixAnnotationsSources, ..._mixSources, 'mix|lib/spike.dart': input},
        outputs: {
          'mix|lib/spike.styler.g.dart': decodedMatches(
            allOf([
              contains('factory BoxStyler.color(Color value)'),
              contains('factory BoxStyler.width(double value)'),
              contains('factory BoxStyler.size(double width, double height)'),
              contains(
                'factory BoxStyler.scale(double scale, {Alignment alignment = .center})',
              ),
              contains('factory BoxStyler.translate(double x, double y'),
              contains('factory BoxStyler.textStyle(TextStyler value)'),
              contains('factory BoxStyler.animate(AnimationConfig value)'),
            ]),
          ),
        },
      );
    });

    test('emits curated Flex zero-argument factories', () async {
      const input = '''
        library spike;
        import 'package:mix_annotations/mix_annotations.dart';

        enum Axis { horizontal, vertical }

        @MixableSpec()
        final class FlexSpec {
          final Axis? direction;
          const FlexSpec({this.direction});
        }
      ''';

      await testBuilder(
        _specStylerLibraryBuilder(),
        {...mixAnnotationsSources, ..._mixSources, 'mix|lib/spike.dart': input},
        outputs: {
          'mix|lib/spike.styler.g.dart': decodedMatches(
            allOf([
              contains('FlexStyleMixin<FlexStyler>'),
              contains('factory FlexStyler.row() => FlexStyler().row();'),
              contains('factory FlexStyler.column() => FlexStyler().column();'),
              contains('FlexStyler flex(FlexStyler value)'),
              contains('return merge(value);'),
            ]),
          ),
        },
      );
    });

    test('emits curated Text factories and directive methods', () async {
      const input = '''
        library spike;
        import 'package:mix/mix.dart' show Directive;
        import 'package:mix_annotations/mix_annotations.dart';

        class TextStyle {}

        @MixableSpec()
        final class TextSpec {
          final TextStyle? style;
          final List<Directive<String>>? textDirectives;
          final String? semanticsLabel;
          const TextSpec({this.style, this.textDirectives, this.semanticsLabel});
        }
      ''';

      await testBuilder(
        _specStylerLibraryBuilder(),
        {...mixAnnotationsSources, ..._mixSources, 'mix|lib/spike.dart': input},
        outputs: {
          'mix|lib/spike.styler.g.dart': decodedMatches(
            allOf([
              contains('TextStyleMixin<TextStyler>'),
              contains('factory TextStyler.color(Color value)'),
              contains('factory TextStyler.fontSize(double value)'),
              contains(
                'factory TextStyler.fontFamilyFallback(List<String> value)',
              ),
              contains(
                'factory TextStyler.fontFeatures(List<FontFeature> value)',
              ),
              contains(
                'factory TextStyler.fontVariations(List<FontVariation> value)',
              ),
              contains('factory TextStyler.foreground(Paint value)'),
              contains('factory TextStyler.background(Paint value)'),
              contains('factory TextStyler.directive(Directive<String> value)'),
              contains('factory TextStyler.uppercase()'),
              contains('TextStyler directive(Directive<String> value)'),
              contains('TextStyler uppercase()'),
              contains('UppercaseStringDirective'),
              isNot(
                contains('factory TextStyler.semanticsLabel(String value)'),
              ),
              isNot(
                contains('factory TextStyler.animate(AnimationConfig value)'),
              ),
            ]),
          ),
        },
      );
    });

    test('emits curated Icon single-shadow convenience', () async {
      const input = '''
        library spike;
        import 'package:mix_annotations/mix_annotations.dart';

        class Shadow {}

        @MixableSpec()
        final class IconSpec {
          final List<Shadow>? shadows;
          final String? semanticsLabel;
          const IconSpec({this.shadows, this.semanticsLabel});
        }
      ''';

      await testBuilder(
        _specStylerLibraryBuilder(),
        {...mixAnnotationsSources, ..._mixSources, 'mix|lib/spike.dart': input},
        outputs: {
          'mix|lib/spike.styler.g.dart': decodedMatches(
            allOf([
              contains('factory IconStyler.shadows(List<ShadowMix> value)'),
              contains('factory IconStyler.shadow(ShadowMix value)'),
              contains('IconStyler shadow(ShadowMix value)'),
              isNot(
                contains('factory IconStyler.semanticsLabel(String value)'),
              ),
              isNot(
                contains('factory IconStyler.animate(AnimationConfig value)'),
              ),
            ]),
          ),
        },
      );
    });

    test('gates curated simple surface APIs on required fields', () async {
      const boxInput = '''
        library spike_box;
        import 'package:mix_annotations/mix_annotations.dart';

        enum Clip { hardEdge }

        @MixableSpec()
        final class BoxSpec {
          final Clip? clipBehavior;
          const BoxSpec({this.clipBehavior});
        }
      ''';
      const textInput = '''
        library spike_text;
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
        {
          ...mixAnnotationsSources,
          ..._mixSources,
          'mix|lib/box_spec.dart': boxInput,
          'mix|lib/text_spec.dart': textInput,
        },
        outputs: {
          'mix|lib/box_spec.styler.g.dart': decodedMatches(
            allOf([
              contains('factory BoxStyler.clipBehavior(Clip value)'),
              contains('factory BoxStyler.animate(AnimationConfig value)'),
              isNot(contains('factory BoxStyler.color(Color value)')),
              isNot(contains('factory BoxStyler.width(double value)')),
              isNot(contains('factory BoxStyler.scale(double scale')),
            ]),
          ),
          'mix|lib/text_spec.styler.g.dart': decodedMatches(
            allOf([
              contains('factory TextStyler.directive(Directive<String> value)'),
              isNot(contains('TextStyleMixin<TextStyler>')),
              isNot(contains('factory TextStyler.color(Color value)')),
              isNot(contains('factory TextStyler.fontSize(double value)')),
            ]),
          ),
        },
      );
    });

    test('does not activate compound surface for partial matches', () async {
      const boxSpec = '''
          import 'package:mix/mix.dart';

          final class BoxSpec extends Spec<BoxSpec> {
            const BoxSpec();
          }
        ''';
      const input = '''
          library combo;
          import 'package:mix/mix.dart' show Spec, StyleSpec;
          import 'package:mix_annotations/mix_annotations.dart';

          import '../box/box_spec.dart';

          @MixableSpec()
          final class FlexBoxSpec extends Spec<FlexBoxSpec> {
            final StyleSpec<BoxSpec>? box;
            const FlexBoxSpec({this.box});
          }
        ''';

      await testBuilder(
        _specStylerLibraryBuilder(),
        {
          ...mixAnnotationsSources,
          ..._mixSources,
          'mix|lib/src/box/box_spec.dart': boxSpec,
          'mix|lib/src/combo/flexbox_spec.dart': input,
        },
        outputs: {
          'mix|lib/src/combo/flexbox_spec.styler.g.dart': decodedMatches(
            allOf([
              contains('class FlexBoxStyler'),
              isNot(contains('factory FlexBoxStyler.direction(Axis value)')),
              isNot(contains('factory FlexBoxStyler.row()')),
              isNot(contains('FlexStyleMixin<FlexBoxStyler>')),
              isNot(contains('box: Prop.maybeMix(')),
              isNot(contains('FlexStyler(')),
            ]),
          ),
        },
      );
    });

    test('emits compound nested styler delegation', () async {
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
          final class FlexBoxSpec extends Spec<FlexBoxSpec> {
            final StyleSpec<BoxSpec>? box;
            final StyleSpec<FlexSpec>? flex;
            const FlexBoxSpec({this.box, this.flex});
          }
        ''';

      await testBuilder(
        _specStylerLibraryBuilder(),
        {
          ...mixAnnotationsSources,
          ..._mixSources,
          'mix|lib/src/box/box_spec.dart': boxSpec,
          'mix|lib/src/flex/flex_spec.dart': flexSpec,
          'mix|lib/src/combo/flexbox_spec.dart': input,
        },
        outputs: {
          'mix|lib/src/combo/flexbox_spec.styler.g.dart': decodedMatches(
            allOf([
              contains('EdgeInsetsGeometryMix? padding,'),
              contains('Axis? direction,'),
              contains('Clip? flexClipBehavior,'),
              contains('box: Prop.maybeMix('),
              contains('BoxStyler('),
              contains('flex: Prop.maybeMix('),
              contains('FlexStyler('),
              contains(
                'factory FlexBoxStyler.alignment(AlignmentGeometry value)',
              ),
              contains(
                'factory FlexBoxStyler.padding(EdgeInsetsGeometryMix value)',
              ),
              contains('factory FlexBoxStyler.direction(Axis value)'),
              contains(
                'factory FlexBoxStyler.mainAxisAlignment(MainAxisAlignment value)',
              ),
              contains('FlexStyleMixin<FlexBoxStyler>'),
              contains('FlexBoxStyler flex(FlexStyler value)'),
              contains('FlexBoxStyler padding(EdgeInsetsGeometryMix value)'),
              contains('return merge(FlexBoxStyler(padding: value));'),
              contains(
                'FlexBoxStyler transformAlignment(AlignmentGeometry value)',
              ),
              contains('AlignmentGeometry alignment = Alignment.center'),
              contains('factory FlexBoxStyler.row()'),
              contains('factory FlexBoxStyler.color(Color value)'),
              isNot(contains('FlexBoxStyler box(BoxStyler value)')),
              isNot(contains('FlexBoxStyler flexClipBehavior(Clip value)')),
            ]),
          ),
        },
      );
    });

    test('emits StackBox compound nested styler parity', () async {
      const boxSpec = '''
          import 'package:mix/mix.dart';

          final class BoxSpec extends Spec<BoxSpec> {
            const BoxSpec();
          }
        ''';
      const stackSpec = '''
          import 'package:mix/mix.dart';

          final class StackSpec extends Spec<StackSpec> {
            const StackSpec();
          }
        ''';
      const input = '''
          library combo;
          import 'package:mix/mix.dart' show Spec, StyleSpec;
          import 'package:mix_annotations/mix_annotations.dart';

          import '../box/box_spec.dart';
          import '../stack/stack_spec.dart';

          enum StackFit { loose }
          enum Clip { hardEdge }
          enum TextDirection { ltr }

          @MixableSpec()
          final class StackBoxSpec extends Spec<StackBoxSpec> {
            final StyleSpec<BoxSpec>? box;
            final StyleSpec<StackSpec>? stack;
            const StackBoxSpec({this.box, this.stack});
          }
        ''';

      await testBuilder(
        _specStylerLibraryBuilder(),
        {
          ...mixAnnotationsSources,
          ..._mixSources,
          'mix|lib/src/box/box_spec.dart': boxSpec,
          'mix|lib/src/stack/stack_spec.dart': stackSpec,
          'mix|lib/src/combo/stackbox_spec.dart': input,
        },
        outputs: {
          'mix|lib/src/combo/stackbox_spec.styler.g.dart': decodedMatches(
            allOf([
              contains(
                'factory StackBoxStyler.alignment(AlignmentGeometry value)',
              ),
              contains(
                'factory StackBoxStyler.padding(EdgeInsetsGeometryMix value)',
              ),
              contains(
                'factory StackBoxStyler.stackAlignment(AlignmentGeometry value)',
              ),
              contains('factory StackBoxStyler.fit(StackFit value)'),
              contains('factory StackBoxStyler.stackClipBehavior(Clip value)'),
              contains(
                'StackBoxStyler transformAlignment(AlignmentGeometry value)',
              ),
              contains('StackBoxStyler stack(StackStyler value)'),
              isNot(contains('StackBoxStyler box(BoxStyler value)')),
            ]),
          ),
        },
      );
    });

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
