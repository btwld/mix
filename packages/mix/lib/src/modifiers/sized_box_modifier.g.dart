// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sized_box_modifier.dart';

// **************************************************************************
// ModifierGenerator
// **************************************************************************

mixin _$SizedBoxModifierMethods
    on WidgetModifier<SizedBoxModifier>, Diagnosticable {
  double? get height;
  double? get width;

  @override
  SizedBoxModifier copyWith({double? height, double? width}) {
    return SizedBoxModifier(
      height: height ?? this.height,
      width: width ?? this.width,
    );
  }

  @override
  SizedBoxModifier lerp(SizedBoxModifier? other, double t) {
    if (other == null) return this as SizedBoxModifier;

    return SizedBoxModifier(
      height: MixOps.lerp(height, other.height, t),
      width: MixOps.lerp(width, other.width, t),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DoubleProperty('height', height))
      ..add(DoubleProperty('width', width));
  }

  @override
  List<Object?> get props => [height, width];
}

class SizedBoxModifierMix extends ModifierMix<SizedBoxModifier>
    with Diagnosticable {
  final Prop<double>? height;
  final Prop<double>? width;

  const SizedBoxModifierMix.create({this.height, this.width});

  SizedBoxModifierMix({double? height, double? width})
    : this.create(height: Prop.maybe(height), width: Prop.maybe(width));

  @override
  SizedBoxModifier resolve(BuildContext context) {
    return SizedBoxModifier(
      height: MixOps.resolve(context, height),
      width: MixOps.resolve(context, width),
    );
  }

  @override
  SizedBoxModifierMix merge(SizedBoxModifierMix? other) {
    if (other == null) return this;

    return SizedBoxModifierMix.create(
      height: MixOps.merge(height, other.height),
      width: MixOps.merge(width, other.width),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('height', height))
      ..add(DiagnosticsProperty('width', width));
  }

  @override
  List<Object?> get props => [height, width];
}
