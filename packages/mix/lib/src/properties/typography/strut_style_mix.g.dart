// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'strut_style_mix.dart';

// **************************************************************************
// MixableGenerator
// **************************************************************************

mixin _$StrutStyleMixMixin on Mix<StrutStyle>, Diagnosticable {
  Prop<String>? get $fontFamily;
  Prop<List<String>>? get $fontFamilyFallback;
  Prop<double>? get $fontSize;
  Prop<FontStyle>? get $fontStyle;
  Prop<FontWeight>? get $fontWeight;
  Prop<bool>? get $forceStrutHeight;
  Prop<double>? get $height;
  Prop<double>? get $leading;

  @override
  StrutStyleMix merge(StrutStyleMix? other) {
    return StrutStyleMix.create(
      fontFamily: MixOps.merge($fontFamily, other?.$fontFamily),
      fontFamilyFallback: MixOps.merge(
        $fontFamilyFallback,
        other?.$fontFamilyFallback,
      ),
      fontSize: MixOps.merge($fontSize, other?.$fontSize),
      fontStyle: MixOps.merge($fontStyle, other?.$fontStyle),
      fontWeight: MixOps.merge($fontWeight, other?.$fontWeight),
      forceStrutHeight: MixOps.merge(
        $forceStrutHeight,
        other?.$forceStrutHeight,
      ),
      height: MixOps.merge($height, other?.$height),
      leading: MixOps.merge($leading, other?.$leading),
    );
  }

  @override
  StrutStyle resolve(BuildContext context) {
    return StrutStyle(
      fontFamily: MixOps.resolve(context, $fontFamily),
      fontFamilyFallback: MixOps.resolve(context, $fontFamilyFallback),
      fontSize: MixOps.resolve(context, $fontSize),
      fontStyle: MixOps.resolve(context, $fontStyle),
      fontWeight: MixOps.resolve(context, $fontWeight),
      forceStrutHeight: MixOps.resolve(context, $forceStrutHeight),
      height: MixOps.resolve(context, $height),
      leading: MixOps.resolve(context, $leading),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('fontFamily', $fontFamily))
      ..add(DiagnosticsProperty('fontFamilyFallback', $fontFamilyFallback))
      ..add(DiagnosticsProperty('fontSize', $fontSize))
      ..add(DiagnosticsProperty('fontStyle', $fontStyle))
      ..add(DiagnosticsProperty('fontWeight', $fontWeight))
      ..add(DiagnosticsProperty('forceStrutHeight', $forceStrutHeight))
      ..add(DiagnosticsProperty('height', $height))
      ..add(DiagnosticsProperty('leading', $leading));
  }

  @override
  List<Object?> get props => [
    $fontFamily,
    $fontFamilyFallback,
    $fontSize,
    $fontStyle,
    $fontWeight,
    $forceStrutHeight,
    $height,
    $leading,
  ];
}
