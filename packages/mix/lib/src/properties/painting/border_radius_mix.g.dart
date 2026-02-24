// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'border_radius_mix.dart';

// **************************************************************************
// MixableGenerator
// **************************************************************************

mixin _$BorderRadiusMixMixin
    on Mix<BorderRadius>, DefaultValue<BorderRadius>, Diagnosticable {
  Prop<Radius>? get $bottomLeft;
  Prop<Radius>? get $bottomRight;
  Prop<Radius>? get $topLeft;
  Prop<Radius>? get $topRight;

  /// Merges with another [BorderRadiusMix].
  @override
  BorderRadiusMix merge(BorderRadiusMix? other) {
    return BorderRadiusMix.create(
      bottomLeft: MixOps.merge($bottomLeft, other?.$bottomLeft),
      bottomRight: MixOps.merge($bottomRight, other?.$bottomRight),
      topLeft: MixOps.merge($topLeft, other?.$topLeft),
      topRight: MixOps.merge($topRight, other?.$topRight),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('bottomLeft', $bottomLeft))
      ..add(DiagnosticsProperty('bottomRight', $bottomRight))
      ..add(DiagnosticsProperty('topLeft', $topLeft))
      ..add(DiagnosticsProperty('topRight', $topRight));
  }

  @override
  List<Object?> get props => [$bottomLeft, $bottomRight, $topLeft, $topRight];
}

mixin _$BorderRadiusDirectionalMixMixin
    on
        Mix<BorderRadiusDirectional>,
        DefaultValue<BorderRadiusDirectional>,
        Diagnosticable {
  Prop<Radius>? get $bottomEnd;
  Prop<Radius>? get $bottomStart;
  Prop<Radius>? get $topEnd;
  Prop<Radius>? get $topStart;

  /// Merges with another [BorderRadiusDirectionalMix].
  @override
  BorderRadiusDirectionalMix merge(BorderRadiusDirectionalMix? other) {
    return BorderRadiusDirectionalMix.create(
      bottomEnd: MixOps.merge($bottomEnd, other?.$bottomEnd),
      bottomStart: MixOps.merge($bottomStart, other?.$bottomStart),
      topEnd: MixOps.merge($topEnd, other?.$topEnd),
      topStart: MixOps.merge($topStart, other?.$topStart),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('bottomEnd', $bottomEnd))
      ..add(DiagnosticsProperty('bottomStart', $bottomStart))
      ..add(DiagnosticsProperty('topEnd', $topEnd))
      ..add(DiagnosticsProperty('topStart', $topStart));
  }

  @override
  List<Object?> get props => [$bottomEnd, $bottomStart, $topEnd, $topStart];
}
