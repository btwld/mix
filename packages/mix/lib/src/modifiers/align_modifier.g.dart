// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'align_modifier.dart';

// **************************************************************************
// ModifierGenerator
// **************************************************************************

mixin _$AlignModifier implements WidgetModifier<AlignModifier>, Diagnosticable {
  AlignmentGeometry get alignment;
  double? get widthFactor;
  double? get heightFactor;

  @override
  Type get type => AlignModifier;

  @override
  AlignModifier copyWith({
    AlignmentGeometry? alignment,
    double? widthFactor,
    double? heightFactor,
  }) {
    return AlignModifier(
      alignment: alignment ?? this.alignment,
      widthFactor: widthFactor ?? this.widthFactor,
      heightFactor: heightFactor ?? this.heightFactor,
    );
  }

  @override
  AlignModifier lerp(AlignModifier? other, double t) {
    return AlignModifier(
      alignment: MixOps.lerp(alignment, other?.alignment, t),
      widthFactor: MixOps.lerp(widthFactor, other?.widthFactor, t),
      heightFactor: MixOps.lerp(heightFactor, other?.heightFactor, t),
    );
  }

  @override
  List<Object?> get props => [alignment, widthFactor, heightFactor];

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is AlignModifier &&
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
      ..add(DiagnosticsProperty('alignment', alignment))
      ..add(DoubleProperty('widthFactor', widthFactor))
      ..add(DoubleProperty('heightFactor', heightFactor));
  }
}

class AlignModifierMix extends ModifierMix<AlignModifier> with Diagnosticable {
  final Prop<AlignmentGeometry>? alignment;
  final Prop<double>? widthFactor;
  final Prop<double>? heightFactor;

  const AlignModifierMix.create({
    this.alignment,
    this.widthFactor,
    this.heightFactor,
  });

  AlignModifierMix({
    AlignmentGeometry? alignment,
    double? widthFactor,
    double? heightFactor,
  }) : this.create(
         alignment: Prop.maybe(alignment),
         widthFactor: Prop.maybe(widthFactor),
         heightFactor: Prop.maybe(heightFactor),
       );

  @override
  AlignModifier resolve(BuildContext context) {
    return AlignModifier(
      alignment: MixOps.resolve(context, alignment),
      widthFactor: MixOps.resolve(context, widthFactor),
      heightFactor: MixOps.resolve(context, heightFactor),
    );
  }

  @override
  AlignModifierMix merge(AlignModifierMix? other) {
    if (other == null) return this;

    return AlignModifierMix.create(
      alignment: MixOps.merge(alignment, other.alignment),
      widthFactor: MixOps.merge(widthFactor, other.widthFactor),
      heightFactor: MixOps.merge(heightFactor, other.heightFactor),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('alignment', alignment))
      ..add(DiagnosticsProperty('widthFactor', widthFactor))
      ..add(DiagnosticsProperty('heightFactor', heightFactor));
  }

  @override
  List<Object?> get props => [alignment, widthFactor, heightFactor];
}
