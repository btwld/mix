// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rotated_box_modifier.dart';

// **************************************************************************
// ModifierGenerator
// **************************************************************************

mixin _$RotatedBoxModifier
    implements WidgetModifier<RotatedBoxModifier>, Diagnosticable {
  int get quarterTurns;

  @override
  Type get type => RotatedBoxModifier;

  @override
  RotatedBoxModifier copyWith({int? quarterTurns}) {
    return RotatedBoxModifier(quarterTurns ?? this.quarterTurns);
  }

  @override
  List<Object?> get props => [quarterTurns];

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is RotatedBoxModifier &&
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
    properties.add(IntProperty('quarterTurns', quarterTurns));
  }
}

class RotatedBoxModifierMix extends ModifierMix<RotatedBoxModifier>
    with Diagnosticable {
  final Prop<int>? quarterTurns;

  const RotatedBoxModifierMix.create({this.quarterTurns});

  RotatedBoxModifierMix({int? quarterTurns})
    : this.create(quarterTurns: Prop.maybe(quarterTurns));

  @override
  RotatedBoxModifier resolve(BuildContext context) {
    return RotatedBoxModifier(MixOps.resolve(context, quarterTurns));
  }

  @override
  RotatedBoxModifierMix merge(RotatedBoxModifierMix? other) {
    if (other == null) return this;

    return RotatedBoxModifierMix.create(
      quarterTurns: MixOps.merge(quarterTurns, other.quarterTurns),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty('quarterTurns', quarterTurns));
  }

  @override
  List<Object?> get props => [quarterTurns];
}
