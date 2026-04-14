// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rotated_box_modifier.dart';

// **************************************************************************
// ModifierGenerator
// **************************************************************************

class RotatedBoxModifierMix extends ModifierMix<RotatedBoxModifier>
    with Diagnosticable {
  final Prop<int>? quarterTurns;

  const RotatedBoxModifierMix.create({this.quarterTurns});

  RotatedBoxModifierMix({int? quarterTurns})
    : this.create(quarterTurns: Prop.maybe(quarterTurns));

  @override
  RotatedBoxModifier resolve(BuildContext context) {
    return RotatedBoxModifier(MixOps.resolve(context, quarterTurns));
  }

  @override
  RotatedBoxModifierMix merge(RotatedBoxModifierMix? other) {
    if (other == null) return this;

    return RotatedBoxModifierMix.create(
      quarterTurns: MixOps.merge(quarterTurns, other.quarterTurns),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty('quarterTurns', quarterTurns));
  }

  @override
  List<Object?> get props => [quarterTurns];
}
