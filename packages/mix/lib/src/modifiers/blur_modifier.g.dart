// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'blur_modifier.dart';

// **************************************************************************
// ModifierGenerator
// **************************************************************************

mixin _$BlurModifierMethods on WidgetModifier<BlurModifier>, Diagnosticable {
  double get sigma;

  @override
  BlurModifier copyWith({double? sigma}) {
    return BlurModifier(sigma ?? this.sigma);
  }

  @override
  BlurModifier lerp(BlurModifier? other, double t) {
    if (other == null) return this as BlurModifier;

    return BlurModifier(MixOps.lerp(sigma, other.sigma, t)!);
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DoubleProperty('sigma', sigma));
  }

  @override
  List<Object?> get props => [sigma];
}

class BlurModifierMix extends ModifierMix<BlurModifier> with Diagnosticable {
  final Prop<double>? sigma;

  const BlurModifierMix.create({this.sigma});

  BlurModifierMix({double? sigma}) : this.create(sigma: Prop.maybe(sigma));

  @override
  BlurModifier resolve(BuildContext context) {
    return BlurModifier(MixOps.resolve(context, sigma));
  }

  @override
  BlurModifierMix merge(BlurModifierMix? other) {
    if (other == null) return this;

    return BlurModifierMix.create(sigma: MixOps.merge(sigma, other.sigma));
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty('sigma', sigma));
  }

  @override
  List<Object?> get props => [sigma];
}
