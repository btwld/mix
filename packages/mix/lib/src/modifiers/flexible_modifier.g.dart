// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'flexible_modifier.dart';

// **************************************************************************
// ModifierGenerator
// **************************************************************************

mixin _$FlexibleModifierMethods
    on WidgetModifier<FlexibleModifier>, Diagnosticable {
  FlexFit? get fit;
  int? get flex;

  @override
  FlexibleModifier copyWith({FlexFit? fit, int? flex}) {
    return FlexibleModifier(fit: fit ?? this.fit, flex: flex ?? this.flex);
  }

  @override
  FlexibleModifier lerp(FlexibleModifier? other, double t) {
    if (other == null) return this as FlexibleModifier;

    return FlexibleModifier(
      fit: MixOps.lerpSnap(fit, other.fit, t),
      flex: MixOps.lerp(flex, other.flex, t),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(EnumProperty<FlexFit>('fit', fit))
      ..add(IntProperty('flex', flex));
  }

  @override
  List<Object?> get props => [fit, flex];
}

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
