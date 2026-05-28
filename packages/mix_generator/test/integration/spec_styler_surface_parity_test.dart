import 'dart:io';

import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:build_test/build_test.dart';
import 'package:mix_generator/mix_generator.dart';
import 'package:source_gen/source_gen.dart';
import 'package:test/test.dart';

import '../core/test_helpers.dart';

const _mixSources = {'mix|lib/mix.dart': _mixStub};

const _mixStub = r'''
  abstract class Spec<T extends Spec<T>> {
    const Spec();
  }

  class StyleSpec<S extends Spec<S>> {
    const StyleSpec({required S spec});
  }

  abstract class Style<S extends Spec<S>> {
    final List<VariantStyle<S>>? $variants;
    final WidgetModifierConfig? $modifier;
    final AnimationConfig? $animation;

    const Style({
      List<VariantStyle<S>>? variants,
      WidgetModifierConfig? modifier,
      AnimationConfig? animation,
    }) : $variants = variants,
         $modifier = modifier,
         $animation = animation;
  }

  mixin Diagnosticable {}

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

  class EdgeInsetsGeometry {}
  class EdgeInsetsGeometryMix {}
  class BoxConstraints {}
  class BoxConstraintsMix {}
  class Decoration {}
  class DecorationMix {}
  class DecorationImageMix {}
  class ShapeBorderMix {}
  class GradientMix {}
  class BoxBorderMix {}
  class BorderRadiusGeometryMix {}
  class ElevationShadow {}
  class BoxShadow {}
  class BoxShadowMix {}
  class Shadow {}
  class ShadowMix {}
  class ShadowListMix {
    const ShadowListMix(Object value);
  }
  class StrutStyle {}
  class StrutStyleMix {}
  class TextHeightBehavior {}
  class TextHeightBehaviorMix {}
  class TextStyle {}
  class TextStyleMix {}
  class ImageProvider<T> {}
  class Color {}
  class Rect {}
  class IconData {}
  class Locale {}
  class Paint {}
  class Matrix4 {}
  class AlignmentGeometry {}
  class Alignment extends AlignmentGeometry {
    static const center = Alignment();
    const Alignment();
  }
  class BoxFit {}
  class ImageRepeat {
    static const noRepeat = ImageRepeat();
    const ImageRepeat();
  }
  class TileMode {}
  class FontWeight {}
  class FontStyle {}
  class TextDecoration {}
  class TextDecorationStyle {}
  class FontFeature {}
  class FontVariation {}
  class TextScaler {}

  enum Axis { horizontal, vertical }
  enum MainAxisAlignment { start, center }
  enum CrossAxisAlignment { start, stretch }
  enum MainAxisSize { min, max }
  enum VerticalDirection { up, down }
  enum TextDirection { ltr, rtl }
  enum TextBaseline { alphabetic }
  enum Clip { none, hardEdge }
  enum StackFit { loose, expand }
  enum TextOverflow { clip }
  enum TextAlign { start }
  enum TextWidthBasis { parent }
  enum BlendMode { srcIn }
  enum FilterQuality { low }

  class FlexStyler {
    FlexStyler({
      Axis? direction,
      MainAxisAlignment? mainAxisAlignment,
      CrossAxisAlignment? crossAxisAlignment,
      MainAxisSize? mainAxisSize,
      VerticalDirection? verticalDirection,
      TextDirection? textDirection,
      TextBaseline? textBaseline,
      Clip? clipBehavior,
      double? spacing,
    });
  }

  class StackStyler {
    StackStyler({
      AlignmentGeometry? alignment,
      StackFit? fit,
      TextDirection? textDirection,
      Clip? clipBehavior,
    });
  }

  class TextStyler {}

  mixin SpacingStyleMixin<T> {
    T padding(EdgeInsetsGeometryMix value);
    T margin(EdgeInsetsGeometryMix value);
  }

  mixin ConstraintStyleMixin<T> {
    T constraints(BoxConstraintsMix value);
  }

  mixin DecorationStyleMixin<T> {
    T decoration(DecorationMix value);
    T foregroundDecoration(DecorationMix value);
  }

  mixin BorderStyleMixin<T> {}
  mixin BorderRadiusStyleMixin<T> {}
  mixin ShadowStyleMixin<T> {}

  mixin TransformStyleMixin<T> {
    T transform(Matrix4 value, {AlignmentGeometry alignment = Alignment.center});
  }

  mixin FlexStyleMixin<T> {
    T flex(FlexStyler value);
    T direction(Axis value) => flex(FlexStyler(direction: value));
    T mainAxisAlignment(MainAxisAlignment value) =>
        flex(FlexStyler(mainAxisAlignment: value));
    T crossAxisAlignment(CrossAxisAlignment value) =>
        flex(FlexStyler(crossAxisAlignment: value));
    T mainAxisSize(MainAxisSize value) =>
        flex(FlexStyler(mainAxisSize: value));
    T verticalDirection(VerticalDirection value) =>
        flex(FlexStyler(verticalDirection: value));
    T textDirection(TextDirection value) =>
        flex(FlexStyler(textDirection: value));
    T textBaseline(TextBaseline value) =>
        flex(FlexStyler(textBaseline: value));
    T spacing(double value) => flex(FlexStyler(spacing: value));
    T row() => direction(Axis.horizontal);
    T column() => direction(Axis.vertical);
  }

  mixin TextStyleMixin<T> {
    T style(TextStyleMix value);
  }
''';

const _boxSpec = r'''
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
''';

const _flexSpec = r'''
  @MixableSpec()
  final class FlexSpec extends Spec<FlexSpec> {
    final Axis? direction;
    final MainAxisAlignment? mainAxisAlignment;
    final CrossAxisAlignment? crossAxisAlignment;
    final MainAxisSize? mainAxisSize;
    final VerticalDirection? verticalDirection;
    final TextDirection? textDirection;
    final TextBaseline? textBaseline;
    final Clip? clipBehavior;
    final double? spacing;
    const FlexSpec({
      this.direction,
      this.mainAxisAlignment,
      this.crossAxisAlignment,
      this.mainAxisSize,
      this.verticalDirection,
      this.textDirection,
      this.textBaseline,
      this.clipBehavior,
      this.spacing,
    });
  }
''';

const _stackSpec = r'''
  @MixableSpec()
  final class StackSpec extends Spec<StackSpec> {
    final AlignmentGeometry? alignment;
    final StackFit? fit;
    final TextDirection? textDirection;
    final Clip? clipBehavior;
    const StackSpec({
      this.alignment,
      this.fit,
      this.textDirection,
      this.clipBehavior,
    });
  }
''';

const _textSpec = r'''
  @MixableSpec()
  final class TextSpec extends Spec<TextSpec> {
    final TextOverflow? overflow;
    final StrutStyle? strutStyle;
    final TextAlign? textAlign;
    final TextScaler? textScaler;
    final int? maxLines;
    final TextStyle? style;
    final TextWidthBasis? textWidthBasis;
    final TextHeightBehavior? textHeightBehavior;
    final TextDirection? textDirection;
    final bool? softWrap;
    final List<Directive<String>>? textDirectives;
    final Color? selectionColor;
    final String? semanticsLabel;
    final Locale? locale;
    const TextSpec({
      this.overflow,
      this.strutStyle,
      this.textAlign,
      this.textScaler,
      this.maxLines,
      this.style,
      this.textWidthBasis,
      this.textHeightBehavior,
      this.textDirection,
      this.softWrap,
      this.textDirectives,
      this.selectionColor,
      this.semanticsLabel,
      this.locale,
    });
  }
''';

const _iconSpec = r'''
  @MixableSpec()
  final class IconSpec extends Spec<IconSpec> {
    final Color? color;
    final double? size;
    final double? weight;
    final double? grade;
    final double? opticalSize;
    final List<Shadow>? shadows;
    final TextDirection? textDirection;
    final bool? applyTextScaling;
    final double? fill;
    final String? semanticsLabel;
    final double? opacity;
    final BlendMode? blendMode;
    final IconData? icon;
    const IconSpec({
      this.color,
      this.size,
      this.weight,
      this.grade,
      this.opticalSize,
      this.shadows,
      this.textDirection,
      this.applyTextScaling,
      this.fill,
      this.semanticsLabel,
      this.opacity,
      this.blendMode,
      this.icon,
    });
  }
''';

const _imageSpec = r'''
  @MixableSpec()
  final class ImageSpec extends Spec<ImageSpec> {
    final ImageProvider<Object>? image;
    final double? width;
    final double? height;
    final Color? color;
    final ImageRepeat? repeat;
    final BoxFit? fit;
    final AlignmentGeometry? alignment;
    final Rect? centerSlice;
    final FilterQuality? filterQuality;
    final BlendMode? colorBlendMode;
    final String? semanticLabel;
    final bool? excludeFromSemantics;
    final bool? gaplessPlayback;
    final bool? isAntiAlias;
    final bool? matchTextDirection;
    const ImageSpec({
      this.image,
      this.width,
      this.height,
      this.color,
      this.repeat,
      this.fit,
      this.alignment,
      this.centerSlice,
      this.filterQuality,
      this.colorBlendMode,
      this.semanticLabel,
      this.excludeFromSemantics,
      this.gaplessPlayback,
      this.isAntiAlias,
      this.matchTextDirection,
    });
  }
''';

const _flexBoxSpec = r'''
  @MixableSpec()
  final class FlexBoxSpec extends Spec<FlexBoxSpec> {
    final StyleSpec<BoxSpec>? box;
    final StyleSpec<FlexSpec>? flex;
    const FlexBoxSpec({this.box, this.flex});
  }
''';

const _stackBoxSpec = r'''
  @MixableSpec()
  final class StackBoxSpec extends Spec<StackBoxSpec> {
    final StyleSpec<BoxSpec>? box;
    final StyleSpec<StackSpec>? stack;
    const StackBoxSpec({this.box, this.stack});
  }
''';

const _targets = {
  'BoxStyler': _Target(
    stylePath: 'lib/src/specs/box/box_style.dart',
    generatedPath: 'lib/src/specs/box/box_style.g.dart',
  ),
  'TextStyler': _Target(
    stylePath: 'lib/src/specs/text/text_style.dart',
    generatedPath: 'lib/src/specs/text/text_style.g.dart',
  ),
  'IconStyler': _Target(
    stylePath: 'lib/src/specs/icon/icon_style.dart',
    generatedPath: 'lib/src/specs/icon/icon_style.g.dart',
  ),
  'ImageStyler': _Target(
    stylePath: 'lib/src/specs/image/image_style.dart',
    generatedPath: 'lib/src/specs/image/image_style.g.dart',
  ),
  'FlexStyler': _Target(
    stylePath: 'lib/src/specs/flex/flex_style.dart',
    generatedPath: 'lib/src/specs/flex/flex_style.g.dart',
  ),
  'StackStyler': _Target(
    stylePath: 'lib/src/specs/stack/stack_style.dart',
    generatedPath: 'lib/src/specs/stack/stack_style.g.dart',
  ),
  'FlexBoxStyler': _Target(
    stylePath: 'lib/src/specs/flexbox/flexbox_style.dart',
    generatedPath: 'lib/src/specs/flexbox/flexbox_style.g.dart',
  ),
  'StackBoxStyler': _Target(
    stylePath: 'lib/src/specs/stackbox/stackbox_style.dart',
    generatedPath: 'lib/src/specs/stackbox/stackbox_style.g.dart',
  ),
};

const _allowedMissingFactories = <String, Map<String, String>>{};

const _allowedAddedFactories = <String, Map<String, String>>{};

const _allowedMissingMethods = {
  'FlexBoxStyler': {
    'borderRadius':
        'Generated stylers inherit this owner-mixin convenience method.',
    'border': 'Generated stylers inherit this owner-mixin convenience method.',
  },
  'StackBoxStyler': {
    'borderRadius':
        'Generated stylers inherit this owner-mixin convenience method.',
    'border': 'Generated stylers inherit this owner-mixin convenience method.',
  },
};

const _allowedAddedMethods = <String, Map<String, String>>{};

void main() {
  test(
    'generated styler surface stays aligned with handwritten stylers',
    () async {
      final generatedSources = await _generateParityOutputs();

      for (final entry in _targets.entries) {
        final stylerName = entry.key;
        final handwritten = _extractSurface(stylerName, [
          _readMixFile(entry.value.stylePath),
          _readMixFile(entry.value.generatedPath),
        ]);
        final generated = _extractSurface(stylerName, [
          generatedSources[stylerName] ??
              (throw StateError('No generated output for $stylerName.')),
        ]);

        _expectParity(
          stylerName: stylerName,
          label: 'factories',
          handwritten: handwritten.factories,
          generated: generated.factories,
          allowedMissing: _allowedMissingFactories[stylerName] ?? const {},
          allowedAdded: _allowedAddedFactories[stylerName] ?? const {},
        );
        _expectParity(
          stylerName: stylerName,
          label: 'methods',
          handwritten: handwritten.methods,
          generated: generated.methods,
          allowedMissing: _allowedMissingMethods[stylerName] ?? const {},
          allowedAdded: _allowedAddedMethods[stylerName] ?? const {},
        );
      }
    },
  );
}

Future<Map<String, String>> _generateParityOutputs() async {
  final outputs = <String, String>{};
  for (final entry in _generatedInputs.entries) {
    outputs[entry.key] = await _generateOutput(entry.value);
  }

  return outputs;
}

Future<String> _generateOutput(_GeneratedInput input) async {
  String? generated;
  final capture = predicate<String>((value) {
    generated = value;
    return true;
  }, 'captured generated styler output');

  await testBuilder(
    LibraryBuilder(
      const SpecStylerGenerator(),
      generatedExtension: '.styler.g.dart',
    ),
    {...mixAnnotationsSources, ..._mixSources, ...input.sources},
    generateFor: {input.inputAsset},
    outputs: {input.outputAsset: decodedMatches(capture)},
  );

  return generated ??
      (throw StateError('SpecStylerGenerator emitted nothing.'));
}

final _generatedInputs = {
  'BoxStyler': _GeneratedInput(
    inputAsset: 'mix|lib/src/box/box_spec.dart',
    outputAsset: 'mix|lib/src/box/box_spec.styler.g.dart',
    sources: {'mix|lib/src/box/box_spec.dart': _library(_boxSpec)},
  ),
  'TextStyler': _GeneratedInput(
    inputAsset: 'mix|lib/src/text/text_spec.dart',
    outputAsset: 'mix|lib/src/text/text_spec.styler.g.dart',
    sources: {'mix|lib/src/text/text_spec.dart': _library(_textSpec)},
  ),
  'IconStyler': _GeneratedInput(
    inputAsset: 'mix|lib/src/icon/icon_spec.dart',
    outputAsset: 'mix|lib/src/icon/icon_spec.styler.g.dart',
    sources: {'mix|lib/src/icon/icon_spec.dart': _library(_iconSpec)},
  ),
  'ImageStyler': _GeneratedInput(
    inputAsset: 'mix|lib/src/image/image_spec.dart',
    outputAsset: 'mix|lib/src/image/image_spec.styler.g.dart',
    sources: {'mix|lib/src/image/image_spec.dart': _library(_imageSpec)},
  ),
  'FlexStyler': _GeneratedInput(
    inputAsset: 'mix|lib/src/flex/flex_spec.dart',
    outputAsset: 'mix|lib/src/flex/flex_spec.styler.g.dart',
    sources: {'mix|lib/src/flex/flex_spec.dart': _library(_flexSpec)},
  ),
  'StackStyler': _GeneratedInput(
    inputAsset: 'mix|lib/src/stack/stack_spec.dart',
    outputAsset: 'mix|lib/src/stack/stack_spec.styler.g.dart',
    sources: {'mix|lib/src/stack/stack_spec.dart': _library(_stackSpec)},
  ),
  'FlexBoxStyler': _GeneratedInput(
    inputAsset: 'mix|lib/src/flexbox/flexbox_spec.dart',
    outputAsset: 'mix|lib/src/flexbox/flexbox_spec.styler.g.dart',
    sources: {
      'mix|lib/src/box/box_spec.dart': _library(_dependencySpec(_boxSpec)),
      'mix|lib/src/flex/flex_spec.dart': _library(_dependencySpec(_flexSpec)),
      'mix|lib/src/flexbox/flexbox_spec.dart': _library(
        _flexBoxSpec,
        imports: ['../box/box_spec.dart', '../flex/flex_spec.dart'],
      ),
    },
  ),
  'StackBoxStyler': _GeneratedInput(
    inputAsset: 'mix|lib/src/stackbox/stackbox_spec.dart',
    outputAsset: 'mix|lib/src/stackbox/stackbox_spec.styler.g.dart',
    sources: {
      'mix|lib/src/box/box_spec.dart': _library(_dependencySpec(_boxSpec)),
      'mix|lib/src/stack/stack_spec.dart': _library(
        _dependencySpec(_stackSpec),
      ),
      'mix|lib/src/stackbox/stackbox_spec.dart': _library(
        _stackBoxSpec,
        imports: ['../box/box_spec.dart', '../stack/stack_spec.dart'],
      ),
    },
  ),
};

String _library(String body, {List<String> imports = const []}) {
  final buffer = StringBuffer()
    ..writeln("import 'package:mix/mix.dart';")
    ..writeln("import 'package:mix_annotations/mix_annotations.dart';");

  for (final import in imports) {
    buffer.writeln("import '$import';");
  }

  buffer.writeln(body);

  return buffer.toString();
}

String _dependencySpec(String source) =>
    source.replaceFirst('@MixableSpec()', '');

_PublicSurface _extractSurface(String stylerName, Iterable<String> sources) {
  final factories = <String, String>{};
  final methods = <String, String>{};
  final mixinName = '_\$${stylerName}Mixin';

  for (final source in sources) {
    final unit = parseString(content: source).unit;
    for (final declaration in unit.declarations) {
      if (declaration is ClassDeclaration &&
          declaration.name.lexeme == stylerName) {
        _collectClassSurface(declaration, factories, methods);
      }
      if (declaration is MixinDeclaration &&
          declaration.name.lexeme == mixinName) {
        _collectMixinMethods(declaration, methods);
      }
    }
  }

  return _PublicSurface(factories: factories, methods: methods);
}

void _collectClassSurface(
  ClassDeclaration declaration,
  Map<String, String> factories,
  Map<String, String> methods,
) {
  for (final member in declaration.members) {
    if (member is ConstructorDeclaration) {
      final name = member.name?.lexeme;
      if (member.factoryKeyword != null && _isPublicMember(name)) {
        factories[name!] = _constructorSignature(member);
      }
    }
    if (member is MethodDeclaration && _isPublicMethod(member)) {
      methods[member.name.lexeme] = _methodSignature(member);
    }
  }
}

void _collectMixinMethods(
  MixinDeclaration declaration,
  Map<String, String> methods,
) {
  for (final member in declaration.members) {
    if (member is MethodDeclaration && _isPublicMethod(member)) {
      methods[member.name.lexeme] = _methodSignature(member);
    }
  }
}

String _constructorSignature(ConstructorDeclaration constructor) {
  final name = constructor.name?.lexeme ?? '';

  return _normalizeSignature(
    '$name${_parameterListSignature(constructor.parameters)}',
  );
}

String _methodSignature(MethodDeclaration method) {
  final returnType = method.returnType?.toSource() ?? '';

  return _normalizeSignature(
    '$returnType ${method.name.lexeme}${_parameterListSignature(method.parameters)}',
  );
}

String _parameterListSignature(FormalParameterList? parameterList) {
  if (parameterList == null) return '()';

  final requiredPositional = <String>[];
  final optionalPositional = <String>[];
  final named = <String>[];
  for (final parameter in parameterList.parameters) {
    final signature = _parameterSignature(parameter);
    if (parameter.isNamed) {
      named.add(signature);
    } else if (parameter.isOptionalPositional) {
      optionalPositional.add(signature);
    } else {
      requiredPositional.add(signature);
    }
  }

  final parts = <String>[...requiredPositional];
  if (optionalPositional.isNotEmpty) {
    parts.add('[${optionalPositional.join(', ')}]');
  }
  if (named.isNotEmpty) {
    parts.add('{${named.join(', ')}}');
  }

  return '(${parts.join(', ')})';
}

String _parameterSignature(FormalParameter parameter) {
  final defaultValue = parameter is DefaultFormalParameter
      ? parameter.defaultValue?.toSource()
      : null;
  final inner = parameter is DefaultFormalParameter
      ? parameter.parameter
      : parameter;
  final type = _parameterType(inner);
  final name = _parameterName(inner);
  final defaultSuffix = defaultValue == null ? '' : ' = $defaultValue';

  if (parameter.isNamed) {
    final requiredPrefix = parameter.isRequiredNamed ? 'required ' : '';

    return '$requiredPrefix$type ${name ?? ''}$defaultSuffix'.trim();
  }

  return '$type$defaultSuffix';
}

String _parameterType(FormalParameter parameter) {
  if (parameter is SimpleFormalParameter) {
    return parameter.type?.toSource() ?? 'dynamic';
  }
  if (parameter is FieldFormalParameter) {
    return parameter.type?.toSource() ?? 'dynamic';
  }
  if (parameter is FunctionTypedFormalParameter) {
    final returnType = parameter.returnType?.toSource() ?? 'dynamic';

    return '$returnType Function';
  }

  return parameter.toSource();
}

String? _parameterName(FormalParameter parameter) {
  if (parameter is SimpleFormalParameter) return parameter.name?.lexeme;
  if (parameter is FieldFormalParameter) return parameter.name.lexeme;
  if (parameter is FunctionTypedFormalParameter) return parameter.name.lexeme;

  return null;
}

String _normalizeSignature(String source) {
  return source.replaceAll(RegExp(r'\s+'), ' ').trim();
}

bool _isPublicMethod(MethodDeclaration method) {
  if (method.isStatic || method.isGetter || method.isSetter) return false;

  final name = method.name.lexeme;
  if (!_isPublicMember(name)) return false;

  return name != 'call';
}

bool _isPublicMember(String? name) {
  return name != null && !name.startsWith('_');
}

void _expectParity({
  required String stylerName,
  required String label,
  required Map<String, String> handwritten,
  required Map<String, String> generated,
  required Map<String, String> allowedMissing,
  required Map<String, String> allowedAdded,
}) {
  expect(
    allowedMissing.values,
    everyElement(isNotEmpty),
    reason: '$stylerName $label allowed-missing entries need reasons.',
  );
  expect(
    allowedAdded.values,
    everyElement(isNotEmpty),
    reason: '$stylerName $label allowed-added entries need reasons.',
  );

  final handwrittenNames = handwritten.keys.toSet();
  final generatedNames = generated.keys.toSet();
  final missing = handwrittenNames
      .difference(generatedNames)
      .difference(allowedMissing.keys.toSet());
  final added = generatedNames
      .difference(handwrittenNames)
      .difference(allowedAdded.keys.toSet());
  final changed = <String, String>{};
  for (final name in handwrittenNames.intersection(generatedNames)) {
    if (handwritten[name] == generated[name]) continue;

    changed[name] =
        'handwritten `${handwritten[name]}`, generated `${generated[name]}`';
  }

  expect(
    missing,
    isEmpty,
    reason:
        '$stylerName generated $label are missing handwritten members. '
        'Allowed missing: $allowedMissing',
  );
  expect(
    added,
    isEmpty,
    reason:
        '$stylerName generated $label include generated-only members. '
        'Allowed added: $allowedAdded',
  );
  expect(
    changed,
    isEmpty,
    reason: '$stylerName generated $label signatures drifted.',
  );
}

String _readMixFile(String relativePath) {
  final uri = Directory.current.uri.resolve('../mix/$relativePath');

  return File.fromUri(uri).readAsStringSync();
}

class _Target {
  final String stylePath;
  final String generatedPath;

  const _Target({required this.stylePath, required this.generatedPath});
}

class _GeneratedInput {
  final String inputAsset;
  final String outputAsset;
  final Map<String, String> sources;

  const _GeneratedInput({
    required this.inputAsset,
    required this.outputAsset,
    required this.sources,
  });
}

class _PublicSurface {
  final Map<String, String> factories;
  final Map<String, String> methods;

  const _PublicSurface({required this.factories, required this.methods});
}
