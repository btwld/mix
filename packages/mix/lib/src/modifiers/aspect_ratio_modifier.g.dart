// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'aspect_ratio_modifier.dart';

// **************************************************************************
// ModifierGenerator
// **************************************************************************

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
