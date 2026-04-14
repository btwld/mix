// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'align_modifier.dart';

// **************************************************************************
// ModifierGenerator
// **************************************************************************

class AlignModifierMix extends ModifierMix<AlignModifier> with Diagnosticable {
  final Prop<AlignmentGeometry>? alignment;
  final Prop<double>? heightFactor;
  final Prop<double>? widthFactor;

  const AlignModifierMix.create({
    this.alignment,
    this.heightFactor,
    this.widthFactor,
  });

  AlignModifierMix({
    AlignmentGeometry? alignment,
    double? heightFactor,
    double? widthFactor,
  }) : this.create(
         alignment: Prop.maybe(alignment),
         heightFactor: Prop.maybe(heightFactor),
         widthFactor: Prop.maybe(widthFactor),
       );

  @override
  AlignModifier resolve(BuildContext context) {
    return AlignModifier(
      alignment: MixOps.resolve(context, alignment),
      heightFactor: MixOps.resolve(context, heightFactor),
      widthFactor: MixOps.resolve(context, widthFactor),
    );
  }

  @override
  AlignModifierMix merge(AlignModifierMix? other) {
    if (other == null) return this;

    return AlignModifierMix.create(
      alignment: MixOps.merge(alignment, other.alignment),
      heightFactor: MixOps.merge(heightFactor, other.heightFactor),
      widthFactor: MixOps.merge(widthFactor, other.widthFactor),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('alignment', alignment))
      ..add(DiagnosticsProperty('heightFactor', heightFactor))
      ..add(DiagnosticsProperty('widthFactor', widthFactor));
  }

  @override
  List<Object?> get props => [alignment, heightFactor, widthFactor];
}
