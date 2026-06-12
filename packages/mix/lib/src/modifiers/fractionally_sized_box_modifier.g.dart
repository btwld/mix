// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fractionally_sized_box_modifier.dart';

// **************************************************************************
// ModifierGenerator
// **************************************************************************

mixin _$FractionallySizedBoxModifier
    implements WidgetModifier<FractionallySizedBoxModifier>, Diagnosticable {
  double? get widthFactor;
  double? get heightFactor;
  AlignmentGeometry get alignment;

  @override
  Type get type => FractionallySizedBoxModifier;

  @override
  FractionallySizedBoxModifier copyWith({
    double? widthFactor,
    double? heightFactor,
    AlignmentGeometry? alignment,
  }) {
    return FractionallySizedBoxModifier(
      widthFactor: widthFactor ?? this.widthFactor,
      heightFactor: heightFactor ?? this.heightFactor,
      alignment: alignment ?? this.alignment,
    );
  }

  @override
  FractionallySizedBoxModifier lerp(
    FractionallySizedBoxModifier? other,
    double t,
  ) {
    return FractionallySizedBoxModifier(
      widthFactor: MixOps.lerp(widthFactor, other?.widthFactor, t),
      heightFactor: MixOps.lerp(heightFactor, other?.heightFactor, t),
      alignment: MixOps.lerp(alignment, other?.alignment, t),
    );
  }

  @override
  List<Object?> get props => [widthFactor, heightFactor, alignment];

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is FractionallySizedBoxModifier &&
            runtimeType == other.runtimeType &&
            propsEquals(props, other.props);
  }

  @override
  int get hashCode => propsHash(runtimeType, props);

  @override
  bool get stringify => true;

  @override
  Map<String, String> getDiff(Equatable other) {
    if (this == other) return const {};

    return propsDiff(props, other.props);
  }

  @override
  String toStringShort() => '$runtimeType';

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) =>
      toDiagnosticsNode(
        style: DiagnosticsTreeStyle.singleLine,
      ).toString(minLevel: minLevel);

  @override
  DiagnosticsNode toDiagnosticsNode({
    String? name,
    DiagnosticsTreeStyle? style,
  }) =>
      DiagnosticableNode<Diagnosticable>(name: name, value: this, style: style);

  @override
  Widget build(Widget child);

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties
      ..add(DoubleProperty('widthFactor', widthFactor))
      ..add(DoubleProperty('heightFactor', heightFactor))
      ..add(DiagnosticsProperty('alignment', alignment));
  }
}

class FractionallySizedBoxModifierMix
    extends ModifierMix<FractionallySizedBoxModifier>
    with Diagnosticable {
  final Prop<double>? widthFactor;
  final Prop<double>? heightFactor;
  final Prop<AlignmentGeometry>? alignment;

  const FractionallySizedBoxModifierMix.create({
    this.widthFactor,
    this.heightFactor,
    this.alignment,
  });

  FractionallySizedBoxModifierMix({
    double? widthFactor,
    double? heightFactor,
    AlignmentGeometry? alignment,
  }) : this.create(
         widthFactor: Prop.maybe(widthFactor),
         heightFactor: Prop.maybe(heightFactor),
         alignment: Prop.maybe(alignment),
       );

  @override
  FractionallySizedBoxModifier resolve(BuildContext context) {
    return FractionallySizedBoxModifier(
      widthFactor: MixOps.resolve(context, widthFactor),
      heightFactor: MixOps.resolve(context, heightFactor),
      alignment: MixOps.resolve(context, alignment),
    );
  }

  @override
  FractionallySizedBoxModifierMix merge(
    FractionallySizedBoxModifierMix? other,
  ) {
    if (other == null) return this;

    return FractionallySizedBoxModifierMix.create(
      widthFactor: MixOps.merge(widthFactor, other.widthFactor),
      heightFactor: MixOps.merge(heightFactor, other.heightFactor),
      alignment: MixOps.merge(alignment, other.alignment),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('widthFactor', widthFactor))
      ..add(DiagnosticsProperty('heightFactor', heightFactor))
      ..add(DiagnosticsProperty('alignment', alignment));
  }

  @override
  List<Object?> get props => [widthFactor, heightFactor, alignment];
}
