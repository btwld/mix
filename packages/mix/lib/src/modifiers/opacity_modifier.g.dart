// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'opacity_modifier.dart';

// **************************************************************************
// ModifierGenerator
// **************************************************************************

class OpacityModifierMix extends ModifierMix<OpacityModifier>
    with Diagnosticable {
  final Prop<double>? opacity;

  const OpacityModifierMix.create({this.opacity});

  OpacityModifierMix({double? opacity})
    : this.create(opacity: Prop.maybe(opacity));

  @override
  OpacityModifier resolve(BuildContext context) {
    return OpacityModifier(opacity: MixOps.resolve(context, opacity));
  }

  @override
  OpacityModifierMix merge(OpacityModifierMix? other) {
    if (other == null) return this;

    return OpacityModifierMix.create(
      opacity: MixOps.merge(opacity, other.opacity),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties..add(DiagnosticsProperty('opacity', opacity));
  }

  @override
  List<Object?> get props => [opacity];
}
