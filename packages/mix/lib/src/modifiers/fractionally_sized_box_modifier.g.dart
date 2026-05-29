// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fractionally_sized_box_modifier.dart';

// **************************************************************************
// ModifierGenerator
// **************************************************************************

mixin _$FractionallySizedBoxModifierMethods
    on WidgetModifier<FractionallySizedBoxModifier>, Diagnosticable {
  AlignmentGeometry get alignment;
  double? get heightFactor;
  double? get widthFactor;

  @override
  FractionallySizedBoxModifier copyWith({
    AlignmentGeometry? alignment,
    double? heightFactor,
    double? widthFactor,
  }) {
    return FractionallySizedBoxModifier(
      alignment: alignment ?? this.alignment,
      heightFactor: heightFactor ?? this.heightFactor,
      widthFactor: widthFactor ?? this.widthFactor,
    );
  }

  @override
  FractionallySizedBoxModifier lerp(
    FractionallySizedBoxModifier? other,
    double t,
  ) {
    if (other == null) return this as FractionallySizedBoxModifier;

    return FractionallySizedBoxModifier(
      alignment: MixOps.lerp(alignment, other.alignment, t)!,
      heightFactor: MixOps.lerp(heightFactor, other.heightFactor, t),
      widthFactor: MixOps.lerp(widthFactor, other.widthFactor, t),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('alignment', alignment))
      ..add(DoubleProperty('heightFactor', heightFactor))
      ..add(DoubleProperty('widthFactor', widthFactor));
  }

  @override
  List<Object?> get props => [alignment, heightFactor, widthFactor];
}

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
