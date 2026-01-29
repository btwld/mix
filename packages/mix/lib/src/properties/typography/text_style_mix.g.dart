// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'text_style_mix.dart';

// **************************************************************************
// MixableGenerator
// **************************************************************************

mixin _$TextStyleMixMixin on Mix<TextStyle>, Diagnosticable {
  Prop<Paint>? get $background;
  Prop<Color>? get $backgroundColor;
  Prop<Color>? get $color;
  Prop<String>? get $debugLabel;
  Prop<TextDecoration>? get $decoration;
  Prop<Color>? get $decorationColor;
  Prop<TextDecorationStyle>? get $decorationStyle;
  Prop<double>? get $decorationThickness;
  Prop<String>? get $fontFamily;
  Prop<List<String>>? get $fontFamilyFallback;
  Prop<List<FontFeature>>? get $fontFeatures;
  Prop<double>? get $fontSize;
  Prop<FontStyle>? get $fontStyle;
  Prop<List<FontVariation>>? get $fontVariations;
  Prop<FontWeight>? get $fontWeight;
  Prop<Paint>? get $foreground;
  Prop<double>? get $height;
  Prop<bool>? get $inherit;
  Prop<double>? get $letterSpacing;
  Prop<List<Shadow>>? get $shadows;
  Prop<TextBaseline>? get $textBaseline;
  Prop<double>? get $wordSpacing;

  /// Merges with another [TextStyleMix].
  @override
  TextStyleMix merge(TextStyleMix? other) {
    return TextStyleMix.create(
      background: MixOps.merge($background, other?.$background),
      backgroundColor: MixOps.merge($backgroundColor, other?.$backgroundColor),
      color: MixOps.merge($color, other?.$color),
      debugLabel: MixOps.merge($debugLabel, other?.$debugLabel),
      decoration: MixOps.merge($decoration, other?.$decoration),
      decorationColor: MixOps.merge($decorationColor, other?.$decorationColor),
      decorationStyle: MixOps.merge($decorationStyle, other?.$decorationStyle),
      decorationThickness: MixOps.merge(
        $decorationThickness,
        other?.$decorationThickness,
      ),
      fontFamily: MixOps.merge($fontFamily, other?.$fontFamily),
      fontFamilyFallback: MixOps.merge(
        $fontFamilyFallback,
        other?.$fontFamilyFallback,
      ),
      fontFeatures: MixOps.merge($fontFeatures, other?.$fontFeatures),
      fontSize: MixOps.merge($fontSize, other?.$fontSize),
      fontStyle: MixOps.merge($fontStyle, other?.$fontStyle),
      fontVariations: MixOps.merge($fontVariations, other?.$fontVariations),
      fontWeight: MixOps.merge($fontWeight, other?.$fontWeight),
      foreground: MixOps.merge($foreground, other?.$foreground),
      height: MixOps.merge($height, other?.$height),
      inherit: MixOps.merge($inherit, other?.$inherit),
      letterSpacing: MixOps.merge($letterSpacing, other?.$letterSpacing),
      shadows: MixOps.merge($shadows, other?.$shadows),
      textBaseline: MixOps.merge($textBaseline, other?.$textBaseline),
      wordSpacing: MixOps.merge($wordSpacing, other?.$wordSpacing),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('background', $background))
      ..add(DiagnosticsProperty('backgroundColor', $backgroundColor))
      ..add(DiagnosticsProperty('color', $color))
      ..add(DiagnosticsProperty('debugLabel', $debugLabel))
      ..add(DiagnosticsProperty('decoration', $decoration))
      ..add(DiagnosticsProperty('decorationColor', $decorationColor))
      ..add(DiagnosticsProperty('decorationStyle', $decorationStyle))
      ..add(DiagnosticsProperty('decorationThickness', $decorationThickness))
      ..add(DiagnosticsProperty('fontFamily', $fontFamily))
      ..add(DiagnosticsProperty('fontFamilyFallback', $fontFamilyFallback))
      ..add(DiagnosticsProperty('fontFeatures', $fontFeatures))
      ..add(DiagnosticsProperty('fontSize', $fontSize))
      ..add(DiagnosticsProperty('fontStyle', $fontStyle))
      ..add(DiagnosticsProperty('fontVariations', $fontVariations))
      ..add(DiagnosticsProperty('fontWeight', $fontWeight))
      ..add(DiagnosticsProperty('foreground', $foreground))
      ..add(DiagnosticsProperty('height', $height))
      ..add(DiagnosticsProperty('inherit', $inherit))
      ..add(DiagnosticsProperty('letterSpacing', $letterSpacing))
      ..add(DiagnosticsProperty('shadows', $shadows))
      ..add(DiagnosticsProperty('textBaseline', $textBaseline))
      ..add(DiagnosticsProperty('wordSpacing', $wordSpacing));
  }

  @override
  List<Object?> get props => [
    $background,
    $backgroundColor,
    $color,
    $debugLabel,
    $decoration,
    $decorationColor,
    $decorationStyle,
    $decorationThickness,
    $fontFamily,
    $fontFamilyFallback,
    $fontFeatures,
    $fontSize,
    $fontStyle,
    $fontVariations,
    $fontWeight,
    $foreground,
    $height,
    $inherit,
    $letterSpacing,
    $shadows,
    $textBaseline,
    $wordSpacing,
  ];
}
