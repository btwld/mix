// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'opacity_modifier.dart';

// **************************************************************************
// ModifierGenerator
// **************************************************************************

mixin _$OpacityModifier
    implements WidgetModifier<OpacityModifier>, Diagnosticable {
  double get opacity;

  @override
  Type get type => OpacityModifier;

  @override
  OpacityModifier copyWith({double? opacity}) {
    return OpacityModifier(opacity ?? this.opacity);
  }

  @override
  OpacityModifier lerp(OpacityModifier? other, double t) {
    return OpacityModifier(MixOps.lerp(opacity, other?.opacity, t));
  }

  @override
  List<Object?> get props => [opacity];

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is OpacityModifier &&
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
    properties.add(DoubleProperty('opacity', opacity));
  }
}

class OpacityModifierMix extends ModifierMix<OpacityModifier>
    with Diagnosticable {
  final Prop<double>? opacity;

  const OpacityModifierMix.create({this.opacity});

  OpacityModifierMix({double? opacity})
    : this.create(opacity: Prop.maybe(opacity));

  @override
  OpacityModifier resolve(BuildContext context) {
    return OpacityModifier(MixOps.resolve(context, opacity));
  }

  @override
  OpacityModifierMix merge(OpacityModifierMix? other) {
    if (other == null) return this;

    return OpacityModifierMix.create(
      opacity: MixOps.merge(opacity, other.opacity),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty('opacity', opacity));
  }

  @override
  List<Object?> get props => [opacity];
}
