// ignore_for_file: prefer_relative_imports,avoid-importing-entrypoint-exports

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';
import 'package:mix_annotations/mix_annotations.dart';

import '../../internal/constants.dart';
import '../../internal/diagnostic_properties_builder_ext.dart';

part 'text_style_dto.g.dart';

final class TextStyleDataRef extends TextStyleData {
  final TextStyleRef ref;
  const TextStyleDataRef({required this.ref});

  @override
  TextStyleDataRef merge(covariant TextStyleDataRef? other) {
    if (other == null) return this;
    throw FlutterError.fromParts([
      ErrorSummary('Cannot merge TextStyleDataRef instances'),
      ErrorDescription(
        'An attempt was made to merge incompatible TextStyleDataRef objects. '
        'Attempted to merge: $this with $other',
      ),
      ErrorHint('This is likely due to an internal error in the Mix library.'),
      ErrorHint(
        'Please open an issue on GitHub: $mixIssuesUrl, '
        'Explain how you encountered this error, and provide the code that triggered it.',
      ),
    ]);
  }

  @override
  TextStyle resolve(MixData mix) => mix.tokens.textStyleRef(ref);

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.addUsingDefault('token', ref.token.name);
  }

  @override
  get props => [ref];
}

// TODO: Look for ways to consolidate TextStyleDto and TextStyleData
// If we remove TextStyle from tokens, it means we don't need a list of resolvable values
// to be resolved once we have a context. We can merge the values directly, simplifying the code,
// and this will allow more predictable behavior overall.
@MixableType(components: GeneratedPropertyComponents.none)
base class TextStyleData extends Mixable<TextStyle>
    with _$TextStyleData, Diagnosticable {
  final String? fontFamily;
  final FontWeight? fontWeight;
  final FontStyle? fontStyle;
  final double? fontSize;
  final double? letterSpacing;
  final double? wordSpacing;
  final TextBaseline? textBaseline;
  final ColorDto? color;
  final ColorDto? backgroundColor;
  final List<ShadowDto>? shadows;
  final List<FontFeature>? fontFeatures;
  final List<FontVariation>? fontVariations;
  final TextDecoration? decoration;
  final ColorDto? decorationColor;
  final TextDecorationStyle? decorationStyle;
  final String? debugLabel;
  final double? height;
  final Paint? foreground;
  final Paint? background;
  final double? decorationThickness;
  final List<String>? fontFamilyFallback;

  const TextStyleData({
    this.background,
    this.backgroundColor,
    this.color,
    this.debugLabel,
    this.decoration,
    this.decorationColor,
    this.decorationStyle,
    this.decorationThickness,
    this.fontFamily,
    this.fontFamilyFallback,
    this.fontVariations,
    this.fontFeatures,
    this.fontSize,
    this.fontStyle,
    this.fontWeight,
    this.foreground,
    this.height,
    this.letterSpacing,
    this.shadows,
    this.textBaseline,
    this.wordSpacing,
  });

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.addUsingDefault('background', background);
    properties.addUsingDefault('backgroundColor', backgroundColor);
    properties.addUsingDefault('color', color);
    properties.addUsingDefault('debugLabel', debugLabel);
    properties.addUsingDefault('decoration', decoration);
    properties.addUsingDefault('decorationColor', decorationColor);
    properties.addUsingDefault('decorationStyle', decorationStyle);
    properties.addUsingDefault('decorationThickness', decorationThickness);
    properties.addUsingDefault('fontFamily', fontFamily);
    properties.addUsingDefault('fontFamilyFallback', fontFamilyFallback);
    properties.addUsingDefault('fontVariations', fontVariations);
    properties.addUsingDefault('fontFeatures', fontFeatures);
    properties.addUsingDefault('fontSize', fontSize);
    properties.addUsingDefault('fontStyle', fontStyle);
    properties.addUsingDefault('fontWeight', fontWeight);
    properties.addUsingDefault('foreground', foreground);
    properties.addUsingDefault('height', height);
    properties.addUsingDefault('letterSpacing', letterSpacing);
    properties.addUsingDefault('shadows', shadows);
    properties.addUsingDefault('textBaseline', textBaseline);
    properties.addUsingDefault('wordSpacing', wordSpacing);
  }
}

@MixableType(
  components: GeneratedPropertyComponents.none,
  mergeLists: false,
)
final class TextStyleDto extends Mixable<TextStyle>
    with _$TextStyleDto, Diagnosticable {
  final List<TextStyleData> value;
  final Token<TextStyle>? token;

  @MixableConstructor()
  const TextStyleDto._({this.value = const [], this.token});

  factory TextStyleDto.token(Token<TextStyle> token) =>
      TextStyleDto._(token: token);

  factory TextStyleDto({
    ColorDto? color,
    ColorDto? backgroundColor,
    double? fontSize,
    FontWeight? fontWeight,
    FontStyle? fontStyle,
    double? letterSpacing,
    String? debugLabel,
    double? wordSpacing,
    TextBaseline? textBaseline,
    List<ShadowDto>? shadows,
    List<FontFeature>? fontFeatures,
    TextDecoration? decoration,
    ColorDto? decorationColor,
    TextDecorationStyle? decorationStyle,
    List<FontVariation>? fontVariations,
    double? height,
    Paint? foreground,
    Paint? background,
    double? decorationThickness,
    String? fontFamily,
    List<String>? fontFamilyFallback,
  }) {
    return TextStyleDto._(value: [
      TextStyleData(
        background: background,
        backgroundColor: backgroundColor,
        color: color,
        debugLabel: debugLabel,
        decoration: decoration,
        decorationColor: decorationColor,
        decorationStyle: decorationStyle,
        decorationThickness: decorationThickness,
        fontFamily: fontFamily,
        fontFamilyFallback: fontFamilyFallback,
        fontVariations: fontVariations,
        fontFeatures: fontFeatures,
        fontSize: fontSize,
        fontStyle: fontStyle,
        fontWeight: fontWeight,
        foreground: foreground,
        height: height,
        letterSpacing: letterSpacing,
        shadows: shadows,
        textBaseline: textBaseline,
        wordSpacing: wordSpacing,
      ),
    ]);
  }

  factory TextStyleDto.ref(TextStyleToken token) {
    return TextStyleDto._(value: [TextStyleDataRef(ref: token())]);
  }

  /// Resolves this [TextStyleDto] to a [TextStyle].
  /// 
  /// If a token is present, resolves it directly using the unified resolver system.
  /// Otherwise, processes the value list by resolving any token references,
  /// merging all [TextStyleData] objects, and resolving to a final [TextStyle].
  @override
  TextStyle resolve(MixData mix) {
    // Direct token resolution using unified resolver system
    if (token != null) {
      return mix.tokens.resolveToken<TextStyle>(token!.name);
    }

    final result = value
        .map((e) => e is TextStyleDataRef ? e.resolve(mix)._toData() : e)
        .reduce((a, b) => a.merge(b))
        .resolve(mix);

    return result;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);

    for (var e in value) {
      properties.add(
        DiagnosticsProperty(
          e.toStringShort(),
          e,
          expandableValue: true,
          style: DiagnosticsTreeStyle.whitespace,
        ),
      );
    }
  }
}

extension TextStyleExt on TextStyle {
  TextStyleDto toDto() {
    if (this is TextStyleRef) {
      return TextStyleDto.ref((this as TextStyleRef).token);
    }

    return TextStyleDto._(value: [_toData()]);
  }

  TextStyleData _toData() => TextStyleData(
        background: background,
        backgroundColor: backgroundColor?.toDto(),
        color: color?.toDto(),
        debugLabel: debugLabel,
        decoration: decoration,
        decorationColor: decorationColor?.toDto(),
        decorationStyle: decorationStyle,
        decorationThickness: decorationThickness,
        fontFamily: fontFamily,
        fontFamilyFallback: fontFamilyFallback,
        fontVariations: fontVariations,
        fontFeatures: fontFeatures,
        fontSize: fontSize,
        fontStyle: fontStyle,
        fontWeight: fontWeight,
        foreground: foreground,
        height: height,
        letterSpacing: letterSpacing,
        shadows: shadows?.map((e) => e.toDto()).toList(),
        textBaseline: textBaseline,
        wordSpacing: wordSpacing,
      );
}
