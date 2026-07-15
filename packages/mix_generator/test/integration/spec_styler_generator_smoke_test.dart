import 'package:build/build.dart';
import 'package:build_test/build_test.dart';
import 'package:logging/logging.dart';
import 'package:mix_generator/mix_generator.dart';
import 'package:source_gen/source_gen.dart';
import 'package:test/test.dart';

import '../core/test_helpers.dart';

const _mixSources = {
  'mix|lib/mix.dart': _mixStub,
  'mix|lib/src/core/mix_element.dart': '''
    abstract class Mix<T> {
      const Mix();
    }
  ''',
  'mix|lib/src/core/style_spec.dart': _styleSpecStub,
};

/// `StyleSpec` declared at its real `package:mix` path so the URL-based
/// `styleSpecChecker` matches in tests — the same reason
/// `_setterTypeMixSources` declares `Mix` at its real path for `mixChecker`.
const _styleSpecStub = '''
  import '../../mix.dart';

  class StyleSpec<S extends Spec<S>> {
    const StyleSpec({
      required S spec,
      Object? animation,
      Object? widgetModifiers,
    });
  }
''';

const _setterTypeMixSources = {
  'mix|lib/src/core/mix_element.dart': '''
    abstract class Mix<T> {
      const Mix();
    }
  ''',
  'mix|lib/src/core/style_spec.dart': _styleSpecStub,
  'mix|lib/mix.dart': '''
    import 'package:flutter/foundation.dart';

    import 'src/core/mix_element.dart';
    import 'src/core/style_spec.dart';

    export 'src/core/mix_element.dart';
    export 'src/core/style_spec.dart';

    abstract class Spec<T extends Spec<T>> {
      const Spec();
    }

    abstract class Style<S extends Spec<S>> extends Mix<StyleSpec<S>> {
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

    class Prop<T> {
      static Prop<T>? maybe<T>(T? value) => null;
      static Prop<T>? maybeMix<T>(Mix<T>? value) => null;
      static Prop<T>? mix<T>(Mix<T> value) => null;
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

      static T? resolve<T>(Object context, Prop<T>? prop) => null;
    }
  ''',
};
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
/// part styler tests.
const _mixStub = '''
  import 'package:flutter/foundation.dart';
  import 'src/core/mix_element.dart';
  import 'src/core/style_spec.dart';

  export 'src/core/mix_element.dart';
  export 'src/core/style_spec.dart';

  abstract class Spec<T extends Spec<T>> {
    const Spec();
  }

  abstract class Style<S extends Spec<S>> extends Mix<StyleSpec<S>> {
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

    ST onHovered(ST style) => style;
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
  class ElevationShadow {}
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
  class TextBaseline {}
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
    T minWidth(double value) => constraints(BoxConstraintsMix());
    T maxWidth(double value) => constraints(BoxConstraintsMix());
    T minHeight(double value) => constraints(BoxConstraintsMix());
    T maxHeight(double value) => constraints(BoxConstraintsMix());
  }

  mixin DecorationStyleMixin<T> {
    T decoration(DecorationMix value);
    T foregroundDecoration(DecorationMix value);
    T color(Color value) => decoration(DecorationMix());
    T gradient(GradientMix value) => decoration(DecorationMix());
    T border(BoxBorderMix value) => decoration(DecorationMix());
    T borderRadius(BorderRadiusGeometryMix value) => decoration(DecorationMix());
    T elevation(ElevationShadow value) => decoration(DecorationMix());
    T shadow(BoxShadowMix value) => decoration(DecorationMix());
    T shadows(List<BoxShadowMix> value) => decoration(DecorationMix());
    T image(DecorationImageMix value) => decoration(DecorationMix());
    T shape(ShapeBorderMix value) => decoration(DecorationMix());
    T backgroundImage(
      ImageProvider image, {
      BoxFit? fit,
      AlignmentGeometry? alignment,
      ImageRepeat repeat = .noRepeat,
    }) => decoration(DecorationMix());
    T backgroundImageUrl(
      String url, {
      BoxFit? fit,
      AlignmentGeometry? alignment,
      ImageRepeat repeat = .noRepeat,
    }) => decoration(DecorationMix());
    T backgroundImageAsset(
      String path, {
      BoxFit? fit,
      AlignmentGeometry? alignment,
      ImageRepeat repeat = .noRepeat,
    }) => decoration(DecorationMix());
    T linearGradient({
      required List<Color> colors,
      List<double>? stops,
      AlignmentGeometry? begin,
      AlignmentGeometry? end,
      TileMode? tileMode,
    }) => decoration(DecorationMix());
    T radialGradient({
      required List<Color> colors,
      List<double>? stops,
      AlignmentGeometry? center,
      double? radius,
      AlignmentGeometry? focal,
      double? focalRadius,
      TileMode? tileMode,
    }) => decoration(DecorationMix());
    T sweepGradient({
      required List<Color> colors,
      List<double>? stops,
      AlignmentGeometry? center,
      double? startAngle,
      double? endAngle,
      TileMode? tileMode,
    }) => decoration(DecorationMix());
    T foregroundLinearGradient({
      required List<Color> colors,
      List<double>? stops,
      AlignmentGeometry? begin,
      AlignmentGeometry? end,
      TileMode? tileMode,
    }) => foregroundDecoration(DecorationMix());
    T foregroundRadialGradient({
      required List<Color> colors,
      List<double>? stops,
      AlignmentGeometry? center,
      double? radius,
      AlignmentGeometry? focal,
      double? focalRadius,
      TileMode? tileMode,
    }) => foregroundDecoration(DecorationMix());
    T foregroundSweepGradient({
      required List<Color> colors,
      List<double>? stops,
      AlignmentGeometry? center,
      double? startAngle,
      double? endAngle,
      TileMode? tileMode,
    }) => foregroundDecoration(DecorationMix());
  }

  mixin BorderStyleMixin<T> {}
  mixin BorderRadiusStyleMixin<T> {}
  mixin ShadowStyleMixin<T> {}
  mixin TransformStyleMixin<T> {
    T transform(Matrix4 value, {Alignment alignment = .center});
    T rotate(double radians, {Alignment alignment = .center}) {
      return transform(Matrix4(), alignment: alignment);
    }
    T scale(double scale, {Alignment alignment = .center}) {
      return transform(Matrix4(), alignment: alignment);
    }
    T translate(double x, double y, [double z = 0.0]) => transform(Matrix4());
    T skew(double skewX, double skewY) => transform(Matrix4());
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
    T backgroundColor(Color value) => style(TextStyleMix());
    T fontSize(double value) => style(TextStyleMix());
    T fontWeight(FontWeight value) => style(TextStyleMix());
    T fontStyle(FontStyle value) => style(TextStyleMix());
    T letterSpacing(double value) => style(TextStyleMix());
    T wordSpacing(double value) => style(TextStyleMix());
    T height(double value) => style(TextStyleMix());
    T textBaseline(TextBaseline value) => style(TextStyleMix());
    T decoration(TextDecoration value) => style(TextStyleMix());
    T decorationColor(Color value) => style(TextStyleMix());
    T decorationStyle(TextDecorationStyle value) => style(TextStyleMix());
    T decorationThickness(double value) => style(TextStyleMix());
    T fontFamily(String value) => style(TextStyleMix());
    T fontFamilyFallback(List<String> value) => style(TextStyleMix());
    T shadows(List<ShadowMix> value) => style(TextStyleMix());
    T shadow(ShadowMix value) => style(TextStyleMix());
    T fontFeatures(List<FontFeature> value) => style(TextStyleMix());
    T fontVariations(List<FontVariation> value) => style(TextStyleMix());
    T foreground(Paint value) => style(TextStyleMix());
    T background(Paint value) => style(TextStyleMix());
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

Builder _specStylerPartBuilder() {
  return PartBuilder([const SpecStylerGenerator()], '.g.dart');
}

Future<String> _expectSpecStylerValidationError(
  Map<String, String> sources, {
  String inputAsset = 'mix|lib/spike.dart',
}) async {
  final logs = <LogRecord>[];
  await testBuilder(
    _specStylerPartBuilder(),
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
        part 'spike.g.dart';
        @MixableSpec()
        final class TrivialSpec {
          final int? count;
          const TrivialSpec({this.count});
        }
      ''';

      await testBuilder(
        _specStylerPartBuilder(),
        {...mixAnnotationsSources, ..._mixSources, 'mix|lib/spike.dart': input},
        outputs: {
          'mix|lib/spike.g.dart': decodedMatches(
            contains(
              'class TrivialStyler extends MixStyler<TrivialStyler, TrivialSpec>',
            ),
          ),
        },
      );
    });

    test(
      'combines spec mixin and generated styler in one .g.dart part',
      () async {
        const input = '''
        library combined;
        import 'package:mix/mix.dart';
        import 'package:mix_annotations/mix_annotations.dart';
        part 'combined.g.dart';

        @MixableSpec()
        final class CombinedSpec extends Spec<CombinedSpec> {
          final int? count;
          const CombinedSpec({this.count});
        }
      ''';

        await testBuilder(
          PartBuilder([
            SpecGenerator(),
            const SpecStylerGenerator(),
          ], '.g.dart'),
          {
            ...mixAnnotationsSources,
            ..._mixSources,
            'mix|lib/combined.dart': input,
          },
          outputs: {
            'mix|lib/combined.g.dart': decodedMatches(
              allOf([
                contains('mixin _\$CombinedSpec implements Spec<CombinedSpec>'),
                contains(
                  'class CombinedStyler extends MixStyler<CombinedStyler, CombinedSpec>',
                ),
              ]),
            ),
          },
        );
      },
    );

    test('emits full styler members without legacy mixin getters', () async {
      const input = '''
        library spike;
        import 'package:mix_annotations/mix_annotations.dart';
        part 'spike.g.dart';
        @MixableSpec()
        final class TrivialSpec {
          final int? count;
          const TrivialSpec({this.count});
        }
      ''';

      await testBuilder(
        _specStylerPartBuilder(),
        {...mixAnnotationsSources, ..._mixSources, 'mix|lib/spike.dart': input},
        outputs: {
          'mix|lib/spike.g.dart': decodedMatches(
            allOf([
              contains(
                'class TrivialStyler extends MixStyler<TrivialStyler, TrivialSpec>',
              ),
              contains(r'final Prop<int>? $count;'),
              contains('TrivialStyler count(int value)'),
              contains('TrivialStyler merge(TrivialStyler? other)'),
              isNot(contains('_\$TrivialStylerMixin')),
              isNot(contains(r'Prop<int>? get $count;')),
              isNot(contains('@override\n  final Prop<int>? \$count;')),
            ]),
          ),
        },
      );
    });

    test('omits call method when target is not configured', () async {
      const input = '''
        library spike;
        import 'package:mix_annotations/mix_annotations.dart';
        part 'spike.g.dart';
        @MixableSpec()
        final class PlainSpec {
          const PlainSpec();
        }
      ''';

      await testBuilder(
        _specStylerPartBuilder(),
        {...mixAnnotationsSources, ..._mixSources, 'mix|lib/spike.dart': input},
        outputs: {
          'mix|lib/spike.g.dart': decodedMatches(
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
        part 'box_shape.g.dart';

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
        part 'text_shape.g.dart';

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
        part 'flex_shape.g.dart';

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
        builder: _specStylerPartBuilder(),
        sources: {
          ...mixAnnotationsSources,
          ..._flutterResolveStubs,
          ..._mixSourcesWithStyleWidget,
          'mix|lib/box_shape.dart': boxInput,
        },
        inputAsset: 'mix|lib/box_shape.dart',
        outputAsset: 'mix|lib/box_shape.g.dart',
        outputMatcher: allOf(
          contains('Box call({Key? key, Widget? child})'),
          contains('return Box(key: key, style: this, child: child);'),
        ),
      );

      await expectGeneratorOutputResolves(
        builder: _specStylerPartBuilder(),
        sources: {
          ...mixAnnotationsSources,
          ..._flutterResolveStubs,
          ..._mixSourcesWithStyleWidget,
          'mix|lib/text_shape.dart': textInput,
        },
        inputAsset: 'mix|lib/text_shape.dart',
        outputAsset: 'mix|lib/text_shape.g.dart',
        outputMatcher: allOf(
          contains('StyledText call(String text, {Key? key})'),
          contains('return StyledText(text, key: key, style: this);'),
        ),
      );

      await expectGeneratorOutputResolves(
        builder: _specStylerPartBuilder(),
        sources: {
          ...mixAnnotationsSources,
          ..._flutterResolveStubs,
          ..._mixSourcesWithStyleWidget,
          'mix|lib/flex_shape.dart': flexInput,
        },
        inputAsset: 'mix|lib/flex_shape.dart',
        outputAsset: 'mix|lib/flex_shape.g.dart',
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

    test(
      'uses source imports needed by target widgets from the host part',
      () async {
        const specInput = '''
        library box_spec;
        import 'package:flutter/widgets.dart';
        import 'package:mix/mix.dart';
        import 'package:mix_annotations/mix_annotations.dart';
        import 'box_widget.dart';
        part 'box_spec.g.dart';

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
          builder: _specStylerPartBuilder(),
          sources: {
            ...mixAnnotationsSources,
            ..._flutterResolveStubs,
            ..._mixSourcesWithStyleWidget,
            'mix|lib/box_spec.dart': specInput,
            'mix|lib/box_widget.dart': widgetInput,
          },
          inputAsset: 'mix|lib/box_spec.dart',
          outputAsset: 'mix|lib/box_spec.g.dart',
          outputMatcher: allOf([
            contains('Box call({Key? key, Widget? child})'),
            isNot(contains("import 'box_widget.dart';")),
          ]),
        );
      },
    );

    test('rejects target values that are not constructor tear-offs', () async {
      const input = '''
        library spike;
        import 'package:mix/mix.dart';
        import 'package:mix_annotations/mix_annotations.dart';
        part 'spike.g.dart';

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
        part 'spike.g.dart';

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
        part 'spike.g.dart';

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
        part 'spike.g.dart';

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
        part 'spike.g.dart';
        class EdgeInsetsGeometry {}

        @MixableSpec()
        final class SupportedSpec {
          final EdgeInsetsGeometry? padding;
          const SupportedSpec({this.padding});
        }
      ''';

      await testBuilder(
        _specStylerPartBuilder(),
        {...mixAnnotationsSources, ..._mixSources, 'mix|lib/spike.dart': input},
        outputs: {
          'mix|lib/spike.g.dart': decodedMatches(
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
        part 'spike.g.dart';
        class EdgeInsetsGeometry {}

        @MixableSpec()
        final class BrokenSpec {
          final EdgeInsetsGeometry? padding;
          const BrokenSpec({this.padding});
        }
      ''';

        final logs = <LogRecord>[];
        await testBuilder(_specStylerPartBuilder(), {
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
        part 'spike.g.dart';
        @MixableSpec()
        void notAClass() {}
      ''';

      final logs = <LogRecord>[];
      await testBuilder(_specStylerPartBuilder(), {
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
        part 'spike.g.dart';
        class EdgeInsetsGeometry {}
        @MixableSpec()
        final class TrivialSpec {
          final EdgeInsetsGeometry? padding;
          final int? count;
          const TrivialSpec({this.padding, this.count});
        }
      ''';

        await testBuilder(
          _specStylerPartBuilder(),
          {
            ...mixAnnotationsSources,
            ..._mixSources,
            'mix|lib/spike.dart': input,
          },
          outputs: {
            'mix|lib/spike.g.dart': decodedMatches(
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
        part 'spike.g.dart';
        class EdgeInsetsGeometry {}
        @MixableSpec()
        final class TrivialSpec {
          final EdgeInsetsGeometry? padding;
          const TrivialSpec({this.padding});
        }
      ''';

      await testBuilder(
        _specStylerPartBuilder(),
        {...mixAnnotationsSources, ..._mixSources, 'mix|lib/spike.dart': input},
        outputs: {
          'mix|lib/spike.g.dart': decodedMatches(
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
        part 'spike.g.dart';
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
          _specStylerPartBuilder(),
          {
            ...mixAnnotationsSources,
            ..._mixSources,
            'mix|lib/spike.dart': input,
          },
          outputs: {
            'mix|lib/spike.g.dart': decodedMatches(
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
        part 'spike.g.dart';
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
          _specStylerPartBuilder(),
          {
            ...mixAnnotationsSources,
            ..._mixSources,
            'mix|lib/spike.dart': input,
          },
          outputs: {
            'mix|lib/spike.g.dart': decodedMatches(
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
        part 'spike.g.dart';

        @MixableSpec()
        final class TextSpec {
          final List<Directive<String>>? textDirectives;
          const TextSpec({this.textDirectives});
        }
      ''';

      await testBuilder(
        _specStylerPartBuilder(),
        {...mixAnnotationsSources, ..._mixSources, 'mix|lib/spike.dart': input},
        outputs: {
          'mix|lib/spike.g.dart': decodedMatches(
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
        part 'spike.g.dart';

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
        _specStylerPartBuilder(),
        {...mixAnnotationsSources, ..._mixSources, 'mix|lib/spike.dart': input},
        outputs: {
          'mix|lib/spike.g.dart': decodedMatches(
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

    test('uses MixableField setterType for nested styler fields', () async {
      const input = '''
        library spike;
        import 'package:flutter/foundation.dart';
        import 'package:flutter/widgets.dart';
        import 'package:mix/mix.dart';
        import 'package:mix_annotations/mix_annotations.dart';
        part 'spike.g.dart';

        final class InnerSpec extends Spec<InnerSpec> {
          const InnerSpec();
        }

        class InnerStyler extends Style<InnerSpec> with Diagnosticable {}

        @MixableSpec()
        final class HostSpec extends Spec<HostSpec> {
          @MixableField(setterType: InnerStyler)
          final StyleSpec<InnerSpec>? container;
          const HostSpec({this.container});
        }
      ''';

      await expectGeneratorOutputResolves(
        builder: _specStylerPartBuilder(),
        sources: {
          ...mixAnnotationsSources,
          ..._flutterResolveStubs,
          ..._setterTypeMixSources,
          'mix|lib/spike.dart': input,
        },
        inputAsset: 'mix|lib/spike.dart',
        outputAsset: 'mix|lib/spike.g.dart',
        outputMatcher: allOf([
          contains('factory HostStyler.container(InnerStyler value)'),
          contains('HostStyler container(InnerStyler value)'),
          contains('InnerStyler? container,'),
          contains('container: Prop.maybeMix(container)'),
          isNot(contains('StyleSpec<InnerSpec> value')),
          isNot(contains('Prop.maybe(container)')),
        ]),
      );
    });

    test(
      'derives nested styler types from StyleSpec fields by convention',
      () async {
        const input = '''
        library spike;
        import 'package:flutter/foundation.dart';
        import 'package:flutter/widgets.dart';
        import 'package:mix/mix.dart';
        import 'package:mix_annotations/mix_annotations.dart';
        part 'spike.g.dart';

        final class InnerSpec extends Spec<InnerSpec> {
          const InnerSpec();
        }

        class InnerStyler extends Style<InnerSpec> with Diagnosticable {}

        @MixableSpec()
        final class HostSpec extends Spec<HostSpec> {
          final StyleSpec<InnerSpec>? container;
          const HostSpec({this.container});
        }
      ''';

        await expectGeneratorOutputResolves(
          builder: _specStylerPartBuilder(),
          sources: {
            ...mixAnnotationsSources,
            ..._flutterResolveStubs,
            ..._setterTypeMixSources,
            'mix|lib/spike.dart': input,
          },
          inputAsset: 'mix|lib/spike.dart',
          outputAsset: 'mix|lib/spike.g.dart',
          outputMatcher: allOf([
            contains('factory HostStyler.container(InnerStyler value)'),
            contains('HostStyler container(InnerStyler value)'),
            contains('InnerStyler? container,'),
            contains('container: Prop.maybeMix(container)'),
            isNot(contains('StyleSpec<InnerSpec> value')),
            isNot(contains('Prop.maybe(container)')),
          ]),
        );
      },
    );

    test(
      'derives same-package generated styler types without resolving them',
      () async {
        // InnerStyler is emitted into inner_spec.g.dart by this same builder,
        // so it can never resolve while spike.dart is being generated. The
        // convention must hold by string derivation alone — this is the
        // downstream-aggregator scenario (a spec composing sibling specs from
        // its own package).
        const inner = '''
        import 'package:mix/mix.dart';
        import 'package:mix_annotations/mix_annotations.dart';
        part 'inner_spec.g.dart';

        @MixableSpec()
        final class InnerSpec extends Spec<InnerSpec> {
          const InnerSpec();
        }
      ''';
        const input = '''
        library spike;
        import 'package:mix/mix.dart';
        import 'package:mix_annotations/mix_annotations.dart';
        import 'inner_spec.dart';
        part 'spike.g.dart';

        @MixableSpec()
        final class HostSpec extends Spec<HostSpec> {
          final StyleSpec<InnerSpec>? inner;
          const HostSpec({this.inner});
        }
      ''';

        await testBuilder(
          _specStylerPartBuilder(),
          {
            ...mixAnnotationsSources,
            ..._mixSources,
            'mix|lib/inner_spec.dart': inner,
            'mix|lib/spike.dart': input,
          },
          outputs: {
            'mix|lib/inner_spec.g.dart': decodedMatches(
              contains('class InnerStyler'),
            ),
            'mix|lib/spike.g.dart': decodedMatches(
              allOf(
                contains('InnerStyler? inner,'),
                contains('inner: Prop.maybeMix(inner)'),
                contains('HostStyler inner(InnerStyler value)'),
                isNot(contains('Prop.maybe(inner)')),
              ),
            ),
          },
        );
      },
    );

    test(
      'renders forwarded sibling surface types in the host library scope',
      () async {
        const visible = '''
        class VisibleType {}
      ''';
        const inner = '''
        import 'package:mix/mix.dart';
        import 'package:mix_annotations/mix_annotations.dart';
        import 'visible.dart' as inner_types;
        part 'inner_support.dart';

        @MixableSpec()
        final class InnerSpec extends Spec<InnerSpec> {
          final inner_types.VisibleType? value;

          const InnerSpec({this.value});
        }
      ''';
        const innerSupport = '''
        part of 'inner_spec.dart';

        final class InnerStyler extends Mix<StyleSpec<InnerSpec>> {
          const InnerStyler();

          InnerStyler value(inner_types.VisibleType value) => this;
        }
      ''';
        const input = '''
        library spike;
        import 'package:flutter/foundation.dart';
        import 'package:flutter/widgets.dart';
        import 'package:mix/mix.dart';
        import 'package:mix_annotations/mix_annotations.dart';
        import 'inner_spec.dart' as nested;
        import 'visible.dart' as host_types;
        part 'spike.g.dart';

        @MixableSpec()
        final class HostSpec extends Spec<HostSpec> {
          @MixableField(forwardStyler: true)
          final StyleSpec<nested.InnerSpec>? inner;

          const HostSpec({this.inner});
        }
      ''';

        await expectGeneratorOutputResolves(
          builder: _specStylerPartBuilder(),
          sources: {
            ...mixAnnotationsSources,
            ..._flutterResolveStubs,
            ..._mixSources,
            'mix|lib/visible.dart': visible,
            'mix|lib/inner_spec.dart': inner,
            'mix|lib/inner_support.dart': innerSupport,
            'mix|lib/spike.dart': input,
          },
          inputAsset: 'mix|lib/spike.dart',
          outputAsset: 'mix|lib/spike.g.dart',
          outputMatcher: allOf([
            contains('factory HostStyler.inner(nested.InnerStyler value)'),
            contains('factory HostStyler.value(host_types.VisibleType value)'),
            contains('return inner(nested.InnerStyler().value(value));'),
            isNot(contains('inner_types.VisibleType')),
          ]),
        );
      },
    );

    test(
      'forwards the canonical factory surface of a nested generated styler',
      () async {
        const input = '''
        library spike;
        import 'package:mix/mix.dart';
        import 'package:mix_annotations/mix_annotations.dart';
        part 'spike.g.dart';

        class EdgeInsetsGeometry {}
        class BoxConstraints {}
        class Decoration {}

        @MixableSpec()
        final class BoxSpec extends Spec<BoxSpec> {
          final EdgeInsetsGeometry? padding;
          final BoxConstraints? constraints;
          final Decoration? decoration;
          final Matrix4? transform;
          final AlignmentGeometry? transformAlignment;

          const BoxSpec({
            this.padding,
            this.constraints,
            this.decoration,
            this.transform,
            this.transformAlignment,
          });
        }

        @MixableSpec()
        final class CardSpec extends Spec<CardSpec> {
          @MixableField(forwardStyler: true)
          final StyleSpec<BoxSpec>? container;

          const CardSpec({this.container});
        }
      ''';

        await testBuilder(
          _specStylerPartBuilder(),
          {
            ...mixAnnotationsSources,
            ..._mixSources,
            'mix|lib/spike.dart': input,
          },
          outputs: {
            'mix|lib/spike.g.dart': decodedMatches(
              allOf([
                contains('factory CardStyler.container(BoxStyler value)'),
                contains(
                  'factory CardStyler.padding(EdgeInsetsGeometryMix value)',
                ),
                contains('factory CardStyler.color(Color value)'),
                contains(
                  'factory CardStyler.scale(double scale, {Alignment alignment = .center})',
                ),
                contains('CardStyler color(Color value)'),
                contains('return container(BoxStyler().color(value));'),
                isNot(contains('factory CardStyler.paddingAll(')),
                isNot(contains('factory CardStyler.animate(')),
              ]),
            ),
          },
        );
      },
    );

    test('supports default and restricted nested styler surfaces', () async {
      const input = '''
        library spike;
        import 'package:mix/mix.dart';
        import 'package:mix_annotations/mix_annotations.dart';
        part 'spike.g.dart';

        class EdgeInsetsGeometry {}
        class BoxConstraints {}
        class Decoration {}

        @MixableSpec()
        final class BoxSpec extends Spec<BoxSpec> {
          final EdgeInsetsGeometry? padding;
          final BoxConstraints? constraints;
          final Decoration? decoration;
          final Matrix4? transform;
          final AlignmentGeometry? transformAlignment;

          const BoxSpec({
            this.padding,
            this.constraints,
            this.decoration,
            this.transform,
            this.transformAlignment,
          });
        }

        @MixableSpec()
        final class FlexSpec extends Spec<FlexSpec> {
          final Axis? direction;
          const FlexSpec({this.direction});
        }

        @MixableSpec()
        final class FlexBoxSpec extends Spec<FlexBoxSpec> {
          final StyleSpec<BoxSpec>? box;
          final StyleSpec<FlexSpec>? flex;
          const FlexBoxSpec({this.box, this.flex});
        }

        @MixableSpec()
        final class DefaultCardSpec extends Spec<DefaultCardSpec> {
          @MixableField(forwardStyler: true)
          final StyleSpec<FlexBoxSpec>? container;
          const DefaultCardSpec({this.container});
        }

        @MixableSpec()
        final class RestrictedCardSpec extends Spec<RestrictedCardSpec> {
          @MixableField(forwardStyler: true, stylerSurface: BoxSpec)
          final StyleSpec<FlexBoxSpec>? container;
          const RestrictedCardSpec({this.container});
        }
      ''';

      await testBuilder(
        _specStylerPartBuilder(),
        {...mixAnnotationsSources, ..._mixSources, 'mix|lib/spike.dart': input},
        outputs: {
          'mix|lib/spike.g.dart': decodedMatches(
            allOf([
              contains('factory DefaultCardStyler.color(Color value)'),
              contains('factory DefaultCardStyler.row()'),
              contains('factory DefaultCardStyler.direction(Axis value)'),
              contains('return container(FlexBoxStyler().row());'),
              contains('factory RestrictedCardStyler.color(Color value)'),
              contains('return container(FlexBoxStyler().color(value));'),
              isNot(contains('factory RestrictedCardStyler.row()')),
              isNot(
                contains('factory RestrictedCardStyler.direction(Axis value)'),
              ),
            ]),
          ),
        },
      );
    });

    test(
      'uses setterType as the forwarded nested styler implementation',
      () async {
        const input = '''
        library spike;
        import 'package:flutter/foundation.dart';
        import 'package:flutter/widgets.dart';
        import 'package:mix/mix.dart';
        import 'package:mix_annotations/mix_annotations.dart';
        part 'spike.g.dart';

        @MixableSpec()
        final class InnerSpec extends Spec<InnerSpec> {
          final bool? visible;
          const InnerSpec({this.visible});
        }

        mixin VisibleStylerMixin<T> {
          T visible(bool value) => this as T;
        }

        final class CustomInnerStyler extends Mix<StyleSpec<InnerSpec>>
            with VisibleStylerMixin<CustomInnerStyler> {
          const CustomInnerStyler();
        }

        @MixableSpec()
        final class CardSpec extends Spec<CardSpec> {
          @MixableField(
            setterType: CustomInnerStyler,
            forwardStyler: true,
          )
          final StyleSpec<InnerSpec>? container;
          const CardSpec({this.container});
        }
      ''';

        await expectGeneratorOutputResolves(
          builder: _specStylerPartBuilder(),
          sources: {
            ...mixAnnotationsSources,
            ..._flutterResolveStubs,
            ..._mixSources,
            'mix|lib/spike.dart': input,
          },
          inputAsset: 'mix|lib/spike.dart',
          outputAsset: 'mix|lib/spike.g.dart',
          outputMatcher: allOf([
            contains('factory CardStyler.container(CustomInnerStyler value)'),
            contains('factory CardStyler.visible(bool value)'),
            contains('return container(CustomInnerStyler().visible(value));'),
          ]),
        );
      },
    );

    test(
      'rejects a custom forwarding setterType with a missing method',
      () async {
        const input = '''
        library spike;
        import 'package:mix/mix.dart';
        import 'package:mix_annotations/mix_annotations.dart';
        part 'spike.g.dart';

        @MixableSpec()
        final class InnerSpec extends Spec<InnerSpec> {
          final bool? visible;
          const InnerSpec({this.visible});
        }

        final class CustomInnerStyler extends Mix<StyleSpec<InnerSpec>> {
          const CustomInnerStyler();
        }

        @MixableSpec()
        final class HostSpec extends Spec<HostSpec> {
          @MixableField(
            setterType: CustomInnerStyler,
            forwardStyler: true,
          )
          final StyleSpec<InnerSpec>? nested;

          const HostSpec({this.nested});
        }
      ''';

        final message = await _expectSpecStylerValidationError({
          ...mixAnnotationsSources,
          ..._mixSources,
          'mix|lib/spike.dart': input,
        });

        expect(
          message,
          allOf([
            contains('Custom `setterType` `CustomInnerStyler`'),
            contains('does not implement forwarded method `visible`'),
          ]),
        );
      },
    );

    test(
      'rejects a custom forwarding setterType without zero-argument construction',
      () async {
        const input = '''
        library spike;
        import 'package:mix/mix.dart';
        import 'package:mix_annotations/mix_annotations.dart';
        part 'spike.g.dart';

        @MixableSpec()
        final class InnerSpec extends Spec<InnerSpec> {
          final bool? visible;
          const InnerSpec({this.visible});
        }

        final class CustomInnerStyler extends Mix<StyleSpec<InnerSpec>> {
          final int seed;

          const CustomInnerStyler(this.seed);

          CustomInnerStyler visible(bool value) => this;
        }

        @MixableSpec()
        final class HostSpec extends Spec<HostSpec> {
          @MixableField(
            setterType: CustomInnerStyler,
            forwardStyler: true,
          )
          final StyleSpec<InnerSpec>? nested;

          const HostSpec({this.nested});
        }
      ''';

        final message = await _expectSpecStylerValidationError({
          ...mixAnnotationsSources,
          ..._mixSources,
          'mix|lib/spike.dart': input,
        });

        expect(
          message,
          allOf([
            contains('Custom `setterType` `CustomInnerStyler`'),
            contains('must be constructible with no arguments'),
          ]),
        );
      },
    );

    test('rejects an abstract custom forwarding setterType', () async {
      const input = '''
        library spike;
        import 'package:mix/mix.dart';
        import 'package:mix_annotations/mix_annotations.dart';
        part 'spike.g.dart';

        @MixableSpec()
        final class InnerSpec extends Spec<InnerSpec> {
          final bool? visible;
          const InnerSpec({this.visible});
        }

        abstract class CustomInnerStyler extends Mix<StyleSpec<InnerSpec>> {
          const CustomInnerStyler();

          CustomInnerStyler visible(bool value);
        }

        @MixableSpec()
        final class HostSpec extends Spec<HostSpec> {
          @MixableField(
            setterType: CustomInnerStyler,
            forwardStyler: true,
          )
          final StyleSpec<InnerSpec>? nested;

          const HostSpec({this.nested});
        }
      ''';

      final message = await _expectSpecStylerValidationError({
        ...mixAnnotationsSources,
        ..._mixSources,
        'mix|lib/spike.dart': input,
      });

      expect(
        message,
        allOf([
          contains('Custom `setterType` `CustomInnerStyler`'),
          contains('must be constructible with no arguments'),
        ]),
      );
    });

    test(
      'rejects a custom forwarding setterType with an incompatible method',
      () async {
        const input = '''
        library spike;
        import 'package:mix/mix.dart';
        import 'package:mix_annotations/mix_annotations.dart';
        part 'spike.g.dart';

        @MixableSpec()
        final class InnerSpec extends Spec<InnerSpec> {
          final bool? visible;
          const InnerSpec({this.visible});
        }

        final class CustomInnerStyler extends Mix<StyleSpec<InnerSpec>> {
          const CustomInnerStyler();

          CustomInnerStyler visible(String value) => this;
        }

        @MixableSpec()
        final class HostSpec extends Spec<HostSpec> {
          @MixableField(
            setterType: CustomInnerStyler,
            forwardStyler: true,
          )
          final StyleSpec<InnerSpec>? nested;

          const HostSpec({this.nested});
        }
      ''';

        final message = await _expectSpecStylerValidationError({
          ...mixAnnotationsSources,
          ..._mixSources,
          'mix|lib/spike.dart': input,
        });

        expect(
          message,
          allOf([
            contains('Custom `setterType` `CustomInnerStyler`'),
            contains('forwarded method `visible` has incompatible signature'),
            contains('expected `visible(bool value)`'),
          ]),
        );
      },
    );

    test(
      'rejects a custom forwarding setterType with an incompatible return type',
      () async {
        const input = '''
        library spike;
        import 'package:mix/mix.dart';
        import 'package:mix_annotations/mix_annotations.dart';
        part 'spike.g.dart';

        @MixableSpec()
        final class InnerSpec extends Spec<InnerSpec> {
          final bool? visible;
          const InnerSpec({this.visible});
        }

        final class CustomInnerStyler extends Mix<StyleSpec<InnerSpec>> {
          const CustomInnerStyler();

          Object visible(bool value) => Object();
        }

        @MixableSpec()
        final class HostSpec extends Spec<HostSpec> {
          @MixableField(
            setterType: CustomInnerStyler,
            forwardStyler: true,
          )
          final StyleSpec<InnerSpec>? nested;

          const HostSpec({this.nested});
        }
      ''';

        final message = await _expectSpecStylerValidationError({
          ...mixAnnotationsSources,
          ..._mixSources,
          'mix|lib/spike.dart': input,
        });

        expect(
          message,
          allOf([
            contains('Custom `setterType` `CustomInnerStyler`'),
            contains('forwarded method `visible` must return'),
            contains('assignable to `CustomInnerStyler`'),
          ]),
        );
      },
    );

    test('honors nested factory aliases and skipped factories', () async {
      const input = '''
        library spike;
        import 'package:mix/mix.dart';
        import 'package:mix_annotations/mix_annotations.dart';
        part 'spike.g.dart';

        @MixableSpec()
        final class InnerSpec extends Spec<InnerSpec> {
          @MixableField(factoryName: 'visibility')
          final bool? visible;

          @MixableField(skipFactory: true)
          final int? internalValue;

          const InnerSpec({this.visible, this.internalValue});
        }

        @MixableSpec()
        final class CardSpec extends Spec<CardSpec> {
          @MixableField(forwardStyler: true, skipFactory: true)
          final StyleSpec<InnerSpec>? container;
          const CardSpec({this.container});
        }
      ''';

      await testBuilder(
        _specStylerPartBuilder(),
        {...mixAnnotationsSources, ..._mixSources, 'mix|lib/spike.dart': input},
        outputs: {
          'mix|lib/spike.g.dart': decodedMatches(
            allOf([
              contains('factory CardStyler.visibility(bool value)'),
              contains('CardStyler visibility(bool value)'),
              contains('return container(InnerStyler().visible(value));'),
              contains(
                'factory CardStyler.visibility(bool value) => CardStyler().visibility(value);',
              ),
              isNot(contains('factory CardStyler.container(')),
              isNot(contains('factory CardStyler.internalValue(')),
            ]),
          ),
        },
      );
    });

    test(
      'restricted surfaces delegate through the actual factory implementation',
      () async {
        const input = '''
        library spike;
        import 'package:flutter/foundation.dart';
        import 'package:flutter/widgets.dart';
        import 'package:mix/mix.dart';
        import 'package:mix_annotations/mix_annotations.dart';
        part 'spike.g.dart';

        @MixableSpec()
        final class SelectedSpec extends Spec<SelectedSpec> {
          @MixableField(factoryName: 'state')
          final bool? visible;

          const SelectedSpec({this.visible});
        }

        @MixableSpec()
        final class ActualSpec extends Spec<ActualSpec> {
          @MixableField(factoryName: 'state')
          final bool? enabled;

          const ActualSpec({this.enabled});
        }

        @MixableSpec()
        final class HostSpec extends Spec<HostSpec> {
          @MixableField(
            forwardStyler: true,
            stylerSurface: SelectedSpec,
          )
          final StyleSpec<ActualSpec>? nested;

          const HostSpec({this.nested});
        }
      ''';

        await expectGeneratorOutputResolves(
          builder: _specStylerPartBuilder(),
          sources: {
            ...mixAnnotationsSources,
            ..._flutterResolveStubs,
            ..._mixSources,
            'mix|lib/spike.dart': input,
          },
          inputAsset: 'mix|lib/spike.dart',
          outputAsset: 'mix|lib/spike.g.dart',
          outputMatcher: allOf([
            contains('factory HostStyler.state(bool value)'),
            contains('return nested(ActualStyler().enabled(value));'),
          ]),
        );
      },
    );

    test('resolves contextual shorthand for forwarded factories', () async {
      const input = '''
        library spike;
        import 'package:flutter/foundation.dart';
        import 'package:flutter/widgets.dart';
        import 'package:mix/mix.dart';
        import 'package:mix_annotations/mix_annotations.dart';
        part 'spike.g.dart';

        class EdgeInsetsGeometry {}
        class BoxConstraints {}
        class Decoration {}
        enum Clip { hardEdge }

        @MixableSpec()
        final class BoxSpec extends Spec<BoxSpec> {
          final AlignmentGeometry? alignment;
          final EdgeInsetsGeometry? padding;
          final EdgeInsetsGeometry? margin;
          final BoxConstraints? constraints;
          final Decoration? decoration;
          final Decoration? foregroundDecoration;
          final Matrix4? transform;
          final AlignmentGeometry? transformAlignment;
          final Clip? clipBehavior;

          const BoxSpec({
            this.alignment,
            this.padding,
            this.margin,
            this.constraints,
            this.decoration,
            this.foregroundDecoration,
            this.transform,
            this.transformAlignment,
            this.clipBehavior,
          });
        }

        @MixableSpec()
        final class CardSpec extends Spec<CardSpec> {
          @MixableField(forwardStyler: true)
          final StyleSpec<BoxSpec>? container;
          const CardSpec({this.container});
        }

        CardStyler hoveredCard() =>
            CardStyler().onHovered(.color(Color()));
      ''';

      await expectGeneratorOutputResolves(
        builder: _specStylerPartBuilder(),
        sources: {
          ...mixAnnotationsSources,
          ..._flutterResolveStubs,
          ..._mixSources,
          'mix|lib/spike.dart': input,
        },
        inputAsset: 'mix|lib/spike.dart',
        outputAsset: 'mix|lib/spike.g.dart',
        outputMatcher: contains('factory CardStyler.color(Color value)'),
      );
    });

    test('rejects forwarding on a non-StyleSpec field', () async {
      const input = '''
        library spike;
        import 'package:mix_annotations/mix_annotations.dart';
        part 'spike.g.dart';

        @MixableSpec()
        final class CardSpec {
          @MixableField(forwardStyler: true)
          final int? container;
          const CardSpec({this.container});
        }
      ''';

      final message = await _expectSpecStylerValidationError({
        ...mixAnnotationsSources,
        ..._mixSources,
        'mix|lib/spike.dart': input,
      });

      expect(
        message,
        allOf([
          contains('@MixableField(forwardStyler: true)'),
          contains('`container`'),
          contains('requires an exact `StyleSpec<XSpec>` field'),
        ]),
      );
    });

    test('rejects an incompatible restricted styler surface', () async {
      const input = '''
        library spike;
        import 'package:mix/mix.dart';
        import 'package:mix_annotations/mix_annotations.dart';
        part 'spike.g.dart';

        class Decoration {}
        class TextStyle {}

        @MixableSpec()
        final class BoxSpec extends Spec<BoxSpec> {
          final Decoration? decoration;
          const BoxSpec({this.decoration});
        }

        @MixableSpec()
        final class TextSpec extends Spec<TextSpec> {
          final TextStyle? style;
          const TextSpec({this.style});
        }

        @MixableSpec()
        final class CardSpec extends Spec<CardSpec> {
          @MixableField(forwardStyler: true, stylerSurface: BoxSpec)
          final StyleSpec<TextSpec>? label;
          const CardSpec({this.label});
        }
      ''';

      final message = await _expectSpecStylerValidationError({
        ...mixAnnotationsSources,
        ..._mixSources,
        'mix|lib/spike.dart': input,
      });

      expect(
        message,
        allOf([
          contains('Styler surface `BoxStyler`'),
          contains('not a compatible subset of `TextStyler`'),
          contains('factory `decoration(DecorationMix value)` is unavailable'),
        ]),
      );
    });

    test('rejects duplicate names from multiple forwarded fields', () async {
      const input = '''
        library spike;
        import 'package:mix/mix.dart';
        import 'package:mix_annotations/mix_annotations.dart';
        part 'spike.g.dart';

        class Decoration {}

        @MixableSpec()
        final class BoxSpec extends Spec<BoxSpec> {
          final Decoration? decoration;
          const BoxSpec({this.decoration});
        }

        @MixableSpec()
        final class CardSpec extends Spec<CardSpec> {
          @MixableField(forwardStyler: true)
          final StyleSpec<BoxSpec>? primary;

          @MixableField(forwardStyler: true)
          final StyleSpec<BoxSpec>? secondary;

          const CardSpec({this.primary, this.secondary});
        }
      ''';

      final message = await _expectSpecStylerValidationError({
        ...mixAnnotationsSources,
        ..._mixSources,
        'mix|lib/spike.dart': input,
      });

      expect(
        message,
        allOf([
          contains('Forwarded factory `CardStyler.decoration`'),
          contains('conflicts with another generated factory'),
        ]),
      );
    });

    test(
      'rejects forwarded methods that collide with inherited styler members',
      () async {
        const input = '''
        library spike;
        import 'package:mix/mix.dart';
        import 'package:mix_annotations/mix_annotations.dart';
        part 'spike.g.dart';

        @MixableSpec()
        final class InnerSpec extends Spec<InnerSpec> {
          @MixableField(factoryName: 'onHovered')
          final bool? hovered;

          const InnerSpec({this.hovered});
        }

        @MixableSpec()
        final class HostSpec extends Spec<HostSpec> {
          @MixableField(forwardStyler: true)
          final StyleSpec<InnerSpec>? nested;

          const HostSpec({this.nested});
        }
      ''';

        final message = await _expectSpecStylerValidationError({
          ...mixAnnotationsSources,
          ..._mixSources,
          'mix|lib/spike.dart': input,
        });

        expect(
          message,
          allOf([
            contains('Forwarded method `HostStyler.onHovered`'),
            contains('conflicts with an inherited `MixStyler` member'),
          ]),
        );
      },
    );

    test('rejects spec setterType that is not Mix-compatible', () async {
      const input = '''
        library spike;
        import 'package:mix/mix.dart';
        import 'package:mix_annotations/mix_annotations.dart';
        part 'spike.g.dart';

        final class InnerSpec extends Spec<InnerSpec> {
          const InnerSpec();
        }

        class InnerStyler {}

        @MixableSpec()
        final class HostSpec extends Spec<HostSpec> {
          @MixableField(setterType: InnerStyler)
          final StyleSpec<InnerSpec>? container;
          const HostSpec({this.container});
        }
      ''';

      final message = await _expectSpecStylerValidationError({
        ...mixAnnotationsSources,
        ..._flutterResolveStubs,
        ..._setterTypeMixSources,
        'mix|lib/spike.dart': input,
      });

      expect(
        message,
        allOf([
          contains('@MixableField(setterType: InnerStyler)'),
          contains('must be assignable to `Mix<StyleSpec<InnerSpec>>`'),
        ]),
      );
    });

    test('rejects spec setterType with the wrong Mix value type', () async {
      const input = '''
        library spike;
        import 'package:mix/mix.dart';
        import 'package:mix_annotations/mix_annotations.dart';
        part 'spike.g.dart';

        final class InnerSpec extends Spec<InnerSpec> {
          const InnerSpec();
        }

        final class OtherSpec extends Spec<OtherSpec> {
          const OtherSpec();
        }

        class OtherStyler extends Style<OtherSpec> {}

        @MixableSpec()
        final class HostSpec extends Spec<HostSpec> {
          @MixableField(setterType: OtherStyler)
          final StyleSpec<InnerSpec>? container;
          const HostSpec({this.container});
        }
      ''';

      final message = await _expectSpecStylerValidationError({
        ...mixAnnotationsSources,
        ..._flutterResolveStubs,
        ..._setterTypeMixSources,
        'mix|lib/spike.dart': input,
      });

      expect(
        message,
        allOf([
          contains('@MixableField(setterType: OtherStyler)'),
          contains('resolves to `Mix<StyleSpec<OtherSpec>>`'),
          contains('but the field stores `StyleSpec<InnerSpec>`'),
        ]),
      );
    });

    test('rejects spec setterType with a nullable Mix value type', () async {
      const input = '''
        library spike;
        import 'package:mix/mix.dart';
        import 'package:mix_annotations/mix_annotations.dart';
        part 'spike.g.dart';

        final class InnerSpec extends Spec<InnerSpec> {
          const InnerSpec();
        }

        class NullableStyler extends Mix<StyleSpec<InnerSpec>?> {}

        @MixableSpec()
        final class HostSpec extends Spec<HostSpec> {
          @MixableField(setterType: NullableStyler)
          final StyleSpec<InnerSpec>? container;
          const HostSpec({this.container});
        }
      ''';

      final message = await _expectSpecStylerValidationError({
        ...mixAnnotationsSources,
        ..._flutterResolveStubs,
        ..._setterTypeMixSources,
        'mix|lib/spike.dart': input,
      });

      expect(
        message,
        allOf([
          contains('@MixableField(setterType: NullableStyler)'),
          contains('resolves to `Mix<StyleSpec<InnerSpec>?>`'),
          contains('but the field stores `StyleSpec<InnerSpec>`'),
        ]),
      );
    });

    test('rejects spec setterType with a dynamic Mix value type', () async {
      const input = '''
        library spike;
        import 'package:mix/mix.dart';
        import 'package:mix_annotations/mix_annotations.dart';
        part 'spike.g.dart';

        final class InnerSpec extends Spec<InnerSpec> {
          const InnerSpec();
        }

        class DynamicStyler extends Mix<dynamic> {}

        @MixableSpec()
        final class HostSpec extends Spec<HostSpec> {
          @MixableField(setterType: DynamicStyler)
          final StyleSpec<InnerSpec>? container;
          const HostSpec({this.container});
        }
      ''';

      final message = await _expectSpecStylerValidationError({
        ...mixAnnotationsSources,
        ..._flutterResolveStubs,
        ..._setterTypeMixSources,
        'mix|lib/spike.dart': input,
      });

      expect(
        message,
        allOf([
          contains('@MixableField(setterType: DynamicStyler)'),
          contains('resolves to `Mix<dynamic>`'),
          contains('but the field stores `StyleSpec<InnerSpec>`'),
        ]),
      );
    });

    test('rejects raw spec Mix setterType', () async {
      const input = '''
        library spike;
        import 'package:mix/mix.dart';
        import 'package:mix_annotations/mix_annotations.dart';
        part 'spike.g.dart';

        final class InnerSpec extends Spec<InnerSpec> {
          const InnerSpec();
        }

        class RawStyler extends Mix {}

        @MixableSpec()
        final class HostSpec extends Spec<HostSpec> {
          @MixableField(setterType: RawStyler)
          final StyleSpec<InnerSpec>? container;
          const HostSpec({this.container});
        }
      ''';

      final message = await _expectSpecStylerValidationError({
        ...mixAnnotationsSources,
        ..._flutterResolveStubs,
        ..._setterTypeMixSources,
        'mix|lib/spike.dart': input,
      });

      expect(
        message,
        allOf([
          contains('@MixableField(setterType: RawStyler)'),
          contains('resolves to `Mix<dynamic>`'),
          contains('but the field stores `StyleSpec<InnerSpec>`'),
        ]),
      );
    });

    test('uses host imports needed by field type arguments', () async {
      const boxSpec = '''
          import 'package:mix/mix.dart';

          final class BoxSpec extends Spec<BoxSpec> {
            const BoxSpec();
          }

          class BoxStyler extends Style<BoxSpec> {
            const BoxStyler();
          }
        ''';
      // FlexSpec's convention-derived `FlexStyler` resolves from the mix stub.
      const flexSpec = '''
          import 'package:mix/mix.dart';

          final class FlexSpec extends Spec<FlexSpec> {
            const FlexSpec();
          }
        ''';
      const input = '''
          library combo;
          import 'package:flutter/foundation.dart';
          import 'package:flutter/widgets.dart';
          import 'package:mix/mix.dart';
          import 'package:mix_annotations/mix_annotations.dart';

          import '../box/box_spec.dart';
          import '../flex/flex_spec.dart';
          part 'combo_spec.g.dart';

          @MixableSpec()
          final class ComboSpec extends Spec<ComboSpec> {
            final StyleSpec<BoxSpec>? box;
            final StyleSpec<FlexSpec>? flex;
            const ComboSpec({this.box, this.flex});
          }
        ''';

      await expectGeneratorOutputResolves(
        builder: _specStylerPartBuilder(),
        sources: {
          ...mixAnnotationsSources,
          ..._mixSources,
          ..._flutterResolveStubs,
          'mix|lib/src/box/box_spec.dart': boxSpec,
          'mix|lib/src/flex/flex_spec.dart': flexSpec,
          'mix|lib/src/combo/combo_spec.dart': input,
        },
        inputAsset: 'mix|lib/src/combo/combo_spec.dart',
        outputAsset: 'mix|lib/src/combo/combo_spec.g.dart',
      );
    });

    test('emits curated transform anchor with alignment', () async {
      const input = '''
        library spike;
        import 'package:mix/mix.dart' show Alignment, Matrix4;
        import 'package:mix_annotations/mix_annotations.dart';
        part 'spike.g.dart';

        @MixableSpec()
        final class TransformSpec {
          final Matrix4? transform;
          final Alignment? transformAlignment;
          const TransformSpec({this.transform, this.transformAlignment});
        }
      ''';

      await testBuilder(
        _specStylerPartBuilder(),
        {...mixAnnotationsSources, ..._mixSources, 'mix|lib/spike.dart': input},
        outputs: {
          'mix|lib/spike.g.dart': decodedMatches(
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
        part 'spike.g.dart';
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
          _specStylerPartBuilder(),
          {
            ...mixAnnotationsSources,
            ..._mixSources,
            'mix|lib/spike.dart': input,
          },
          outputs: {
            'mix|lib/spike.g.dart': decodedMatches(
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
        import 'package:mix/mix.dart';
        import 'package:mix_annotations/mix_annotations.dart';
        part 'spike.g.dart';

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
        _specStylerPartBuilder(),
        {...mixAnnotationsSources, ..._mixSources, 'mix|lib/spike.dart': input},
        outputs: {
          'mix|lib/spike.g.dart': decodedMatches(
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
        part 'spike.g.dart';

        enum Axis { horizontal, vertical }

        @MixableSpec()
        final class FlexSpec {
          final Axis? direction;
          const FlexSpec({this.direction});
        }
      ''';

      await testBuilder(
        _specStylerPartBuilder(),
        {...mixAnnotationsSources, ..._mixSources, 'mix|lib/spike.dart': input},
        outputs: {
          'mix|lib/spike.g.dart': decodedMatches(
            allOf([
              contains('FlexStyleMixin<FlexStyler>'),
              contains('factory FlexStyler.row() => FlexStyler().row();'),
              contains('factory FlexStyler.column() => FlexStyler().column();'),
              contains('FlexStyler flex(FlexStyler value)'),
              contains('return merge(value);'),
              contains('@override\n  FlexStyler direction(Axis value)'),
            ]),
          ),
        },
      );
    });

    test('emits curated Text factories and directive methods', () async {
      const input = '''
        library spike;
        import 'package:mix/mix.dart';
        import 'package:mix_annotations/mix_annotations.dart';
        part 'spike.g.dart';

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
        _specStylerPartBuilder(),
        {...mixAnnotationsSources, ..._mixSources, 'mix|lib/spike.dart': input},
        outputs: {
          'mix|lib/spike.g.dart': decodedMatches(
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
        part 'spike.g.dart';

        class Shadow {}

        @MixableSpec()
        final class IconSpec {
          final List<Shadow>? shadows;
          final String? semanticsLabel;
          const IconSpec({this.shadows, this.semanticsLabel});
        }
      ''';

      await testBuilder(
        _specStylerPartBuilder(),
        {...mixAnnotationsSources, ..._mixSources, 'mix|lib/spike.dart': input},
        outputs: {
          'mix|lib/spike.g.dart': decodedMatches(
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
        library box_spec;
        import 'package:mix_annotations/mix_annotations.dart';
        part 'box_spec.g.dart';

        enum Clip { hardEdge }

        @MixableSpec()
        final class BoxSpec {
          final Clip? clipBehavior;
          const BoxSpec({this.clipBehavior});
        }
      ''';
      const textInput = '''
        library text_spec;
        import 'package:mix/mix.dart' show Directive;
        import 'package:mix_annotations/mix_annotations.dart';
        part 'text_spec.g.dart';

        @MixableSpec()
        final class TextSpec {
          final List<Directive<String>>? textDirectives;
          const TextSpec({this.textDirectives});
        }
      ''';

      await testBuilder(
        _specStylerPartBuilder(),
        {
          ...mixAnnotationsSources,
          ..._mixSources,
          'mix|lib/box_spec.dart': boxInput,
          'mix|lib/text_spec.dart': textInput,
        },
        outputs: {
          'mix|lib/box_spec.g.dart': decodedMatches(
            allOf([
              contains('factory BoxStyler.clipBehavior(Clip value)'),
              contains('factory BoxStyler.animate(AnimationConfig value)'),
              isNot(contains('factory BoxStyler.color(Color value)')),
              isNot(contains('factory BoxStyler.width(double value)')),
              isNot(contains('factory BoxStyler.scale(double scale')),
            ]),
          ),
          'mix|lib/text_spec.g.dart': decodedMatches(
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
          part 'flexbox_spec.g.dart';

          @MixableSpec()
          final class FlexBoxSpec extends Spec<FlexBoxSpec> {
            final StyleSpec<BoxSpec>? box;
            const FlexBoxSpec({this.box});
          }
        ''';

      await testBuilder(
        _specStylerPartBuilder(),
        {
          ...mixAnnotationsSources,
          ..._mixSources,
          'mix|lib/src/box/box_spec.dart': boxSpec,
          'mix|lib/src/combo/flexbox_spec.dart': input,
        },
        outputs: {
          'mix|lib/src/combo/flexbox_spec.g.dart': decodedMatches(
            allOf([
              contains('class FlexBoxStyler'),
              isNot(contains('factory FlexBoxStyler.direction(Axis value)')),
              isNot(contains('factory FlexBoxStyler.row()')),
              isNot(contains('FlexStyleMixin<FlexBoxStyler>')),
              // The nested field still gets its convention-derived styler
              // type; only the compound flattening must stay inactive.
              contains('BoxStyler? box,'),
              contains('box: Prop.maybeMix(box)'),
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
          import 'package:mix/mix.dart';
          import 'package:mix_annotations/mix_annotations.dart';

          import '../box/box_spec.dart';
          import '../flex/flex_spec.dart';
          part 'flexbox_spec.g.dart';

          @MixableSpec()
          final class FlexBoxSpec extends Spec<FlexBoxSpec> {
            final StyleSpec<BoxSpec>? box;
            final StyleSpec<FlexSpec>? flex;
            const FlexBoxSpec({this.box, this.flex});
          }
        ''';

      await testBuilder(
        _specStylerPartBuilder(),
        {
          ...mixAnnotationsSources,
          ..._mixSources,
          'mix|lib/src/box/box_spec.dart': boxSpec,
          'mix|lib/src/flex/flex_spec.dart': flexSpec,
          'mix|lib/src/combo/flexbox_spec.dart': input,
        },
        outputs: {
          'mix|lib/src/combo/flexbox_spec.g.dart': decodedMatches(
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
          import 'package:mix/mix.dart';
          import 'package:mix_annotations/mix_annotations.dart';

          import '../box/box_spec.dart';
          import '../stack/stack_spec.dart';
          part 'stackbox_spec.g.dart';

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
        _specStylerPartBuilder(),
        {
          ...mixAnnotationsSources,
          ..._mixSources,
          'mix|lib/src/box/box_spec.dart': boxSpec,
          'mix|lib/src/stack/stack_spec.dart': stackSpec,
          'mix|lib/src/combo/stackbox_spec.dart': input,
        },
        outputs: {
          'mix|lib/src/combo/stackbox_spec.g.dart': decodedMatches(
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
        part 'spike.g.dart';

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
          _specStylerPartBuilder(),
          {
            ...mixAnnotationsSources,
            ..._mixSources,
            'mix|lib/spike.dart': input,
          },
          outputs: {
            'mix|lib/spike.g.dart': decodedMatches(
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

    test('emits generated styler members directly on the class', () async {
      const input = r'''
        library spike;
        import 'package:mix_annotations/mix_annotations.dart';
        part 'spike.g.dart';
        enum Clip { hardEdge }

        @MixableSpec()
        final class TinySpec {
          final Clip? clipBehavior;
          const TinySpec({this.clipBehavior});
        }
      ''';

      await testBuilder(
        _specStylerPartBuilder(),
        {...mixAnnotationsSources, ..._mixSources, 'mix|lib/spike.dart': input},
        outputs: {
          'mix|lib/spike.g.dart': decodedMatches(
            allOf(
              contains(
                'class TinyStyler extends MixStyler<TinyStyler, TinySpec>',
              ),
              contains(r'final Prop<Clip>? $clipBehavior;'),
              contains('TinyStyler clipBehavior(Clip value)'),
              contains('TinyStyler merge(TinyStyler? other)'),
              isNot(contains(r'_$TinyStylerMixin')),
              isNot(contains(r'Prop<Clip>? get $clipBehavior;')),
            ),
          ),
        },
      );
    });

    test('generated BoxSpec-shaped styler is semantically valid', () async {
      const input = r'''
        library spike;
        import 'package:flutter/foundation.dart';
        import 'package:flutter/widgets.dart';
        import 'package:mix/mix.dart';
        import 'package:mix_annotations/mix_annotations.dart';
        part 'spike.g.dart';

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
        builder: _specStylerPartBuilder(),
        sources: {
          ...mixAnnotationsSources,
          ..._mixSources,
          ..._flutterResolveStubs,
          'mix|lib/spike.dart': input,
        },
        inputAsset: 'mix|lib/spike.dart',
        outputAsset: 'mix|lib/spike.g.dart',
      );
    });

    test('emits part-safe output without imports', () async {
      const input = '''
        library spike;
        import 'package:mix_annotations/mix_annotations.dart';
        part 'spike.g.dart';

        enum Clip { hardEdge }

        @MixableSpec()
        final class TinySpec {
          final Clip? clipBehavior;
          const TinySpec({this.clipBehavior});
        }
      ''';

      await testBuilder(
        _specStylerPartBuilder(),
        {...mixAnnotationsSources, ..._mixSources, 'mix|lib/spike.dart': input},
        outputs: {
          'mix|lib/spike.g.dart': decodedMatches(
            allOf(
              contains('// GENERATED CODE - DO NOT MODIFY BY HAND'),
              contains("part of 'spike.dart';"),
              isNot(contains("import 'package:mix/mix.dart';")),
              isNot(contains("import 'spike.dart';")),
              contains(
                'class TinyStyler extends MixStyler<TinyStyler, TinySpec>',
              ),
            ),
          ),
        },
      );
    });

    test(
      'does not emit imports when source imports package:mix/mix.dart',
      () async {
        const input = '''
        library spike;
        import 'package:mix/mix.dart';
        import 'package:mix_annotations/mix_annotations.dart';
        part 'spike.g.dart';

        enum Clip { hardEdge }

        @MixableSpec()
        final class TinySpec {
          final Clip? clipBehavior;
          const TinySpec({this.clipBehavior});
        }
      ''';

        await testBuilder(
          _specStylerPartBuilder(),
          {
            ...mixAnnotationsSources,
            ..._mixSources,
            'mix|lib/spike.dart': input,
          },
          outputs: {
            'mix|lib/spike.g.dart': decodedMatches(
              allOf(
                contains("part of 'spike.dart';"),
                isNot(contains("import 'package:mix/mix.dart';")),
              ),
            ),
          },
        );
      },
    );
  });
}
