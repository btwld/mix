// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'padding_modifier.dart';

// **************************************************************************
// ModifierGenerator
// **************************************************************************

class PaddingModifierMix extends ModifierMix<PaddingModifier>
    with Diagnosticable {
  final Prop<EdgeInsetsGeometry>? padding;

  const PaddingModifierMix.create({this.padding});

  PaddingModifierMix({EdgeInsetsGeometryMix? padding})
    : this.create(padding: Prop.maybeMix(padding));

  @override
  PaddingModifier resolve(BuildContext context) {
    return PaddingModifier(MixOps.resolve(context, padding));
  }

  @override
  PaddingModifierMix merge(PaddingModifierMix? other) {
    if (other == null) return this;

    return PaddingModifierMix.create(
      padding: MixOps.merge(padding, other.padding),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty('padding', padding));
  }

  @override
  List<Object?> get props => [padding];
}
