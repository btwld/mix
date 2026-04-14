// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fractionally_sized_box_modifier.dart';

// **************************************************************************
// ModifierGenerator
// **************************************************************************

class FractionallySizedBoxModifierMix
    extends ModifierMix<FractionallySizedBoxModifier>
    with Diagnosticable {
  final Prop<AlignmentGeometry>? alignment;
  final Prop<double>? heightFactor;
  final Prop<double>? widthFactor;

  const FractionallySizedBoxModifierMix.create({
    this.alignment,
    this.heightFactor,
    this.widthFactor,
  });

  FractionallySizedBoxModifierMix({
    AlignmentGeometry? alignment,
    double? heightFactor,
    double? widthFactor,
  }) : this.create(
         alignment: Prop.maybe(alignment),
         heightFactor: Prop.maybe(heightFactor),
         widthFactor: Prop.maybe(widthFactor),
       );

  @override
  FractionallySizedBoxModifier resolve(BuildContext context) {
    return FractionallySizedBoxModifier(
      alignment: MixOps.resolve(context, alignment),
      heightFactor: MixOps.resolve(context, heightFactor),
      widthFactor: MixOps.resolve(context, widthFactor),
    );
  }

  @override
  FractionallySizedBoxModifierMix merge(
    FractionallySizedBoxModifierMix? other,
  ) {
    if (other == null) return this;

    return FractionallySizedBoxModifierMix.create(
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
