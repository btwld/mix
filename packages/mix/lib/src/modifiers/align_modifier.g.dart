// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'align_modifier.dart';

// **************************************************************************
// ModifierGenerator
// **************************************************************************

mixin _$AlignModifierMethods on WidgetModifier<AlignModifier>, Diagnosticable {
  AlignmentGeometry get alignment;
  double? get heightFactor;
  double? get widthFactor;

  @override
  AlignModifier copyWith({
    AlignmentGeometry? alignment,
    double? heightFactor,
    double? widthFactor,
  }) {
    return AlignModifier(
      alignment: alignment ?? this.alignment,
      heightFactor: heightFactor ?? this.heightFactor,
      widthFactor: widthFactor ?? this.widthFactor,
    );
  }

  @override
  AlignModifier lerp(AlignModifier? other, double t) {
    if (other == null) return this as AlignModifier;

    return AlignModifier(
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
