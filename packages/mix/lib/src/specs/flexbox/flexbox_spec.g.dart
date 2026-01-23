// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'flexbox_spec.dart';

// **************************************************************************
// MixGenerator
// **************************************************************************

mixin _$FlexBoxSpecMethods on Spec<FlexBoxSpec>, Diagnosticable {
  StyleSpec<BoxSpec>? get box;
  StyleSpec<FlexSpec>? get flex;

  @override
  FlexBoxSpec copyWith({StyleSpec<BoxSpec>? box, StyleSpec<FlexSpec>? flex}) {
    return FlexBoxSpec(box: box ?? this.box, flex: flex ?? this.flex);
  }

  @override
  FlexBoxSpec lerp(FlexBoxSpec? other, double t) {
    return FlexBoxSpec(
      box: box?.lerp(other?.box, t),
      flex: flex?.lerp(other?.flex, t),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('box', box))
      ..add(DiagnosticsProperty('flex', flex));
  }

  @override
  List<Object?> get props => [box, flex];
}
