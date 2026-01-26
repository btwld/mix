// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gradient_mix.dart';

// **************************************************************************
// MixableGenerator
// **************************************************************************

mixin _$LinearGradientMixMixin
    on Mix<LinearGradient>, DefaultValue<LinearGradient>, Diagnosticable {
  Prop<AlignmentGeometry>? get $begin;
  Prop<List<Color>>? get $colors;
  Prop<AlignmentGeometry>? get $end;
  Prop<List<double>>? get $stops;
  Prop<TileMode>? get $tileMode;
  Prop<GradientTransform>? get $transform;

  @override
  LinearGradientMix merge(LinearGradientMix? other) {
    return LinearGradientMix.create(
      begin: MixOps.merge($begin, other?.$begin),
      colors: MixOps.merge($colors, other?.$colors),
      end: MixOps.merge($end, other?.$end),
      stops: MixOps.merge($stops, other?.$stops),
      tileMode: MixOps.merge($tileMode, other?.$tileMode),
      transform: MixOps.merge($transform, other?.$transform),
    );
  }

  @override
  LinearGradient resolve(BuildContext context) {
    return LinearGradient(
      begin: MixOps.resolve(context, $begin) ?? defaultValue.begin,
      colors: MixOps.resolve(context, $colors) ?? defaultValue.colors,
      end: MixOps.resolve(context, $end) ?? defaultValue.end,
      stops: MixOps.resolve(context, $stops) ?? defaultValue.stops,
      tileMode: MixOps.resolve(context, $tileMode) ?? defaultValue.tileMode,
      transform: MixOps.resolve(context, $transform) ?? defaultValue.transform,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('begin', $begin))
      ..add(DiagnosticsProperty('colors', $colors))
      ..add(DiagnosticsProperty('end', $end))
      ..add(DiagnosticsProperty('stops', $stops))
      ..add(DiagnosticsProperty('tileMode', $tileMode))
      ..add(DiagnosticsProperty('transform', $transform));
  }

  @override
  List<Object?> get props => [
    $begin,
    $colors,
    $end,
    $stops,
    $tileMode,
    $transform,
  ];
}

mixin _$RadialGradientMixMixin
    on Mix<RadialGradient>, DefaultValue<RadialGradient>, Diagnosticable {
  Prop<AlignmentGeometry>? get $center;
  Prop<List<Color>>? get $colors;
  Prop<AlignmentGeometry>? get $focal;
  Prop<double>? get $focalRadius;
  Prop<double>? get $radius;
  Prop<List<double>>? get $stops;
  Prop<TileMode>? get $tileMode;
  Prop<GradientTransform>? get $transform;

  @override
  RadialGradientMix merge(RadialGradientMix? other) {
    return RadialGradientMix.create(
      center: MixOps.merge($center, other?.$center),
      colors: MixOps.merge($colors, other?.$colors),
      focal: MixOps.merge($focal, other?.$focal),
      focalRadius: MixOps.merge($focalRadius, other?.$focalRadius),
      radius: MixOps.merge($radius, other?.$radius),
      stops: MixOps.merge($stops, other?.$stops),
      tileMode: MixOps.merge($tileMode, other?.$tileMode),
      transform: MixOps.merge($transform, other?.$transform),
    );
  }

  @override
  RadialGradient resolve(BuildContext context) {
    return RadialGradient(
      center: MixOps.resolve(context, $center) ?? defaultValue.center,
      colors: MixOps.resolve(context, $colors) ?? defaultValue.colors,
      focal: MixOps.resolve(context, $focal) ?? defaultValue.focal,
      focalRadius:
          MixOps.resolve(context, $focalRadius) ?? defaultValue.focalRadius,
      radius: MixOps.resolve(context, $radius) ?? defaultValue.radius,
      stops: MixOps.resolve(context, $stops) ?? defaultValue.stops,
      tileMode: MixOps.resolve(context, $tileMode) ?? defaultValue.tileMode,
      transform: MixOps.resolve(context, $transform) ?? defaultValue.transform,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('center', $center))
      ..add(DiagnosticsProperty('colors', $colors))
      ..add(DiagnosticsProperty('focal', $focal))
      ..add(DiagnosticsProperty('focalRadius', $focalRadius))
      ..add(DiagnosticsProperty('radius', $radius))
      ..add(DiagnosticsProperty('stops', $stops))
      ..add(DiagnosticsProperty('tileMode', $tileMode))
      ..add(DiagnosticsProperty('transform', $transform));
  }

  @override
  List<Object?> get props => [
    $center,
    $colors,
    $focal,
    $focalRadius,
    $radius,
    $stops,
    $tileMode,
    $transform,
  ];
}

mixin _$SweepGradientMixMixin
    on Mix<SweepGradient>, DefaultValue<SweepGradient>, Diagnosticable {
  Prop<AlignmentGeometry>? get $center;
  Prop<List<Color>>? get $colors;
  Prop<double>? get $endAngle;
  Prop<double>? get $startAngle;
  Prop<List<double>>? get $stops;
  Prop<TileMode>? get $tileMode;
  Prop<GradientTransform>? get $transform;

  @override
  SweepGradientMix merge(SweepGradientMix? other) {
    return SweepGradientMix.create(
      center: MixOps.merge($center, other?.$center),
      colors: MixOps.merge($colors, other?.$colors),
      endAngle: MixOps.merge($endAngle, other?.$endAngle),
      startAngle: MixOps.merge($startAngle, other?.$startAngle),
      stops: MixOps.merge($stops, other?.$stops),
      tileMode: MixOps.merge($tileMode, other?.$tileMode),
      transform: MixOps.merge($transform, other?.$transform),
    );
  }

  @override
  SweepGradient resolve(BuildContext context) {
    return SweepGradient(
      center: MixOps.resolve(context, $center) ?? defaultValue.center,
      colors: MixOps.resolve(context, $colors) ?? defaultValue.colors,
      endAngle: MixOps.resolve(context, $endAngle) ?? defaultValue.endAngle,
      startAngle:
          MixOps.resolve(context, $startAngle) ?? defaultValue.startAngle,
      stops: MixOps.resolve(context, $stops) ?? defaultValue.stops,
      tileMode: MixOps.resolve(context, $tileMode) ?? defaultValue.tileMode,
      transform: MixOps.resolve(context, $transform) ?? defaultValue.transform,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('center', $center))
      ..add(DiagnosticsProperty('colors', $colors))
      ..add(DiagnosticsProperty('endAngle', $endAngle))
      ..add(DiagnosticsProperty('startAngle', $startAngle))
      ..add(DiagnosticsProperty('stops', $stops))
      ..add(DiagnosticsProperty('tileMode', $tileMode))
      ..add(DiagnosticsProperty('transform', $transform));
  }

  @override
  List<Object?> get props => [
    $center,
    $colors,
    $endAngle,
    $startAngle,
    $stops,
    $tileMode,
    $transform,
  ];
}
