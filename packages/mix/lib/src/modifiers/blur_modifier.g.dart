// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'blur_modifier.dart';

// **************************************************************************
// ModifierGenerator
// **************************************************************************

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
