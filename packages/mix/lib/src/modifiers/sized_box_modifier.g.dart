// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sized_box_modifier.dart';

// **************************************************************************
// ModifierGenerator
// **************************************************************************

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
