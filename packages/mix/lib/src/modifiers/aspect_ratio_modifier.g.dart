// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'aspect_ratio_modifier.dart';

// **************************************************************************
// ModifierGenerator
// **************************************************************************

mixin _$AspectRatioModifierMethods
    on WidgetModifier<AspectRatioModifier>, Diagnosticable {
  double get aspectRatio;

  @override
  AspectRatioModifier copyWith({double? aspectRatio}) {
    return AspectRatioModifier(aspectRatio ?? this.aspectRatio);
  }

  @override
  AspectRatioModifier lerp(AspectRatioModifier? other, double t) {
    if (other == null) return this as AspectRatioModifier;

    return AspectRatioModifier(MixOps.lerp(aspectRatio, other.aspectRatio, t)!);
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DoubleProperty('aspectRatio', aspectRatio));
  }

  @override
  List<Object?> get props => [aspectRatio];
}

class AspectRatioModifierMix extends ModifierMix<AspectRatioModifier>
    with Diagnosticable {
  final Prop<double>? aspectRatio;

  const AspectRatioModifierMix.create({this.aspectRatio});

  AspectRatioModifierMix({double? aspectRatio})
    : this.create(aspectRatio: Prop.maybe(aspectRatio));

  @override
  AspectRatioModifier resolve(BuildContext context) {
    return AspectRatioModifier(MixOps.resolve(context, aspectRatio));
  }

  @override
  AspectRatioModifierMix merge(AspectRatioModifierMix? other) {
    if (other == null) return this;

    return AspectRatioModifierMix.create(
      aspectRatio: MixOps.merge(aspectRatio, other.aspectRatio),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty('aspectRatio', aspectRatio));
  }

  @override
  List<Object?> get props => [aspectRatio];
}
