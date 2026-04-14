// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'flexible_modifier.dart';

// **************************************************************************
// ModifierGenerator
// **************************************************************************

class FlexibleModifierMix extends ModifierMix<FlexibleModifier>
    with Diagnosticable {
  final Prop<FlexFit>? fit;
  final Prop<int>? flex;

  const FlexibleModifierMix.create({this.fit, this.flex});

  FlexibleModifierMix({FlexFit? fit, int? flex})
    : this.create(fit: Prop.maybe(fit), flex: Prop.maybe(flex));

  @override
  FlexibleModifier resolve(BuildContext context) {
    return FlexibleModifier(
      fit: MixOps.resolve(context, fit),
      flex: MixOps.resolve(context, flex),
    );
  }

  @override
  FlexibleModifierMix merge(FlexibleModifierMix? other) {
    if (other == null) return this;

    return FlexibleModifierMix.create(
      fit: MixOps.merge(fit, other.fit),
      flex: MixOps.merge(flex, other.flex),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('fit', fit))
      ..add(DiagnosticsProperty('flex', flex));
  }

  @override
  List<Object?> get props => [fit, flex];
}
