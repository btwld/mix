// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'padding_modifier.dart';

// **************************************************************************
// ModifierGenerator
// **************************************************************************

mixin _$PaddingModifier
    implements WidgetModifier<PaddingModifier>, Diagnosticable {
  EdgeInsetsGeometry get padding;

  @override
  Type get type => PaddingModifier;

  @override
  PaddingModifier copyWith({EdgeInsetsGeometry? padding}) {
    return PaddingModifier(padding ?? this.padding);
  }

  @override
  PaddingModifier lerp(PaddingModifier? other, double t) {
    return PaddingModifier(MixOps.lerp(padding, other?.padding, t));
  }

  @override
  List<Object?> get props => [padding];

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is PaddingModifier &&
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
    properties.add(DiagnosticsProperty('padding', padding));
  }
}

class PaddingModifierMix extends ModifierMix<PaddingModifier>
    with Diagnosticable {
  final Prop<EdgeInsetsGeometry>? padding;

  const PaddingModifierMix.create({this.padding});

  PaddingModifierMix({EdgeInsetsGeometryMix? padding})
    : this.create(padding: Prop.maybeMix(padding));

  @override
  PaddingModifier resolve(BuildContext context) {
    return PaddingModifier(MixOps.resolve(context, padding));
  }

  @override
  PaddingModifierMix merge(PaddingModifierMix? other) {
    if (other == null) return this;

    return PaddingModifierMix.create(
      padding: MixOps.merge(padding, other.padding),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty('padding', padding));
  }

  @override
  List<Object?> get props => [padding];
}
