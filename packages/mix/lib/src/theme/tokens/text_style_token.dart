// ignore_for_file: deprecated_member_use_from_same_package

import 'package:flutter/widgets.dart';

import '../../internal/mix_error.dart';
import '../mix/mix_theme.dart';
import 'mix_token.dart';

/// A token representing a text style value in the Mix theme.
///
/// @Deprecated: Use Token<TextStyle> instead.
@Deprecated(
  'Use Token<TextStyle> instead. '
  'This will be removed in v3.0.0. '
  'Migration: TextStyleToken("heading1") → Token<TextStyle>("heading1")',
)
class TextStyleToken extends MixToken<TextStyle> with MixTokenCallable<TextStyle> {
  const TextStyleToken(super.name);

  @override
  TextStyleRef call() => TextStyleRef(this);

  @override
  TextStyle resolve(BuildContext context) {
    final themeValue = MixTheme.of(context).textStyles[this];
    assert(
      themeValue != null,
      'TextStyleToken $name is not defined in the theme',
    );

    final resolvedValue = themeValue is TextStyleResolver
        ? themeValue.resolve(context)
        : themeValue;

    return resolvedValue ?? const TextStyle();
  }
}

/// {@macro mix.token.resolver}
@immutable
class TextStyleResolver extends TextStyle with WithTokenResolver<TextStyle> {
  @override
  final BuildContextResolver<TextStyle> resolve;

  const TextStyleResolver(this.resolve);
}

@immutable
final class TextStyleRef extends TextStyle with TokenRef<TextStyleToken> {
  @override
  final TextStyleToken token;

  const TextStyleRef(this.token);

  @override
  operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is TextStyleRef && other.token == token;
  }

  @override
  TextStyle copyWith({
    bool? inherit,
    Color? color,
    Color? backgroundColor,
    double? fontSize,
    FontWeight? fontWeight,
    FontStyle? fontStyle,
    double? letterSpacing,
    double? wordSpacing,
    TextBaseline? textBaseline,
    double? height,
    TextLeadingDistribution? leadingDistribution,
    Locale? locale,
    Paint? foreground,
    Paint? background,
    List<Shadow>? shadows,
    List<FontFeature>? fontFeatures,
    List<FontVariation>? fontVariations,
    TextDecoration? decoration,
    Color? decorationColor,
    TextDecorationStyle? decorationStyle,
    double? decorationThickness,
    String? debugLabel,
    String? fontFamily,
    List<String>? fontFamilyFallback,
    String? package,
    TextOverflow? overflow,
  }) =>
      throw _e(token.name, 'copyWith');

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    try {
      return super.toString(minLevel: minLevel);
    } catch (e) {
      return token.name;
    }
  }

  @override
  String get fontFamily => throw _e(token.name, 'fontFamily');

  @override
  bool get inherit => throw _e(token.name, 'inherit');

  @override
  Color get color => throw _e(token.name, 'color');

  @override
  Color get backgroundColor => throw _e(token.name, 'backgroundColor');

  @override
  double get fontSize => throw _e(token.name, 'fontSize');

  @override
  FontWeight get fontWeight => throw _e(token.name, 'fontWeight');

  @override
  FontStyle get fontStyle => throw _e(token.name, 'fontStyle');

  @override
  double get letterSpacing => throw _e(token.name, 'letterSpacing');

  @override
  double get wordSpacing => throw _e(token.name, 'wordSpacing');

  @override
  TextBaseline get textBaseline => throw _e(token.name, 'textBaseline');

  @override
  double get height => throw _e(token.name, 'height');

  @override
  TextLeadingDistribution get leadingDistribution =>
      throw _e(token.name, 'leadingDistribution');

  @override
  Locale get locale => throw _e(token.name, 'locale');

  @override
  Paint get foreground => throw _e(token.name, 'foreground');

  @override
  Paint get background => throw _e(token.name, 'background');

  @override
  List<Shadow> get shadows => throw _e(token.name, 'shadows');

  @override
  List<FontFeature> get fontFeatures => throw _e(token.name, 'fontFeatures');

  @override
  List<FontVariation> get fontVariations =>
      throw _e(token.name, 'fontVariations');

  @override
  TextDecoration get decoration => throw _e(token.name, 'decoration');

  @override
  Color get decorationColor => throw _e(token.name, 'decorationColor');

  @override
  TextDecorationStyle get decorationStyle =>
      throw _e(token.name, 'decorationStyle');

  @override
  double get decorationThickness => throw _e(token.name, 'decorationThickness');

  @override
  String get debugLabel => throw _e(token.name, 'debugLabel');

  @override
  int get hashCode => token.name.hashCode;
}

FlutterError _e(String token, String field) {
  return MixError.accessTokenValue(token, field);
}
