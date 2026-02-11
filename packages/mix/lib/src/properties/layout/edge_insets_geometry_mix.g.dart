// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'edge_insets_geometry_mix.dart';

// **************************************************************************
// MixableGenerator
// **************************************************************************

mixin _$EdgeInsetsMixMixin
    on Mix<EdgeInsets>, DefaultValue<EdgeInsets>, Diagnosticable {
  Prop<double>? get $bottom;
  Prop<double>? get $left;
  Prop<double>? get $right;
  Prop<double>? get $top;

  /// Merges with another [EdgeInsetsMix].
  @override
  EdgeInsetsMix merge(EdgeInsetsMix? other) {
    return EdgeInsetsMix.create(
      bottom: MixOps.merge($bottom, other?.$bottom),
      left: MixOps.merge($left, other?.$left),
      right: MixOps.merge($right, other?.$right),
      top: MixOps.merge($top, other?.$top),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('bottom', $bottom))
      ..add(DiagnosticsProperty('left', $left))
      ..add(DiagnosticsProperty('right', $right))
      ..add(DiagnosticsProperty('top', $top));
  }

  @override
  List<Object?> get props => [$bottom, $left, $right, $top];
}

mixin _$EdgeInsetsDirectionalMixMixin
    on Mix<EdgeInsetsDirectional>, Diagnosticable {
  Prop<double>? get $bottom;
  Prop<double>? get $end;
  Prop<double>? get $start;
  Prop<double>? get $top;

  /// Merges with another [EdgeInsetsDirectionalMix].
  @override
  EdgeInsetsDirectionalMix merge(EdgeInsetsDirectionalMix? other) {
    return EdgeInsetsDirectionalMix.create(
      bottom: MixOps.merge($bottom, other?.$bottom),
      end: MixOps.merge($end, other?.$end),
      start: MixOps.merge($start, other?.$start),
      top: MixOps.merge($top, other?.$top),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('bottom', $bottom))
      ..add(DiagnosticsProperty('end', $end))
      ..add(DiagnosticsProperty('start', $start))
      ..add(DiagnosticsProperty('top', $top));
  }

  @override
  List<Object?> get props => [$bottom, $end, $start, $top];
}
