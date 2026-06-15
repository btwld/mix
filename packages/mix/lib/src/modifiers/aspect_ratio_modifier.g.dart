// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'aspect_ratio_modifier.dart';

// **************************************************************************
// ModifierGenerator
// **************************************************************************

mixin _$AspectRatioModifier
    implements WidgetModifier<AspectRatioModifier>, Diagnosticable {
  double get aspectRatio;

  @override
  Type get type => AspectRatioModifier;

  @override
  AspectRatioModifier copyWith({double? aspectRatio}) {
    return AspectRatioModifier(aspectRatio ?? this.aspectRatio);
  }

  @override
  AspectRatioModifier lerp(AspectRatioModifier? other, double t) {
    return AspectRatioModifier(MixOps.lerp(aspectRatio, other?.aspectRatio, t));
  }

  @override
  List<Object?> get props => [aspectRatio];

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is AspectRatioModifier &&
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
    properties.add(DoubleProperty('aspectRatio', aspectRatio));
  }
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
