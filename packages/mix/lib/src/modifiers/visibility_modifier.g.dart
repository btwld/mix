// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'visibility_modifier.dart';

// **************************************************************************
// ModifierGenerator
// **************************************************************************

mixin _$VisibilityModifier
    implements WidgetModifier<VisibilityModifier>, Diagnosticable {
  bool get visible;

  @override
  Type get type => VisibilityModifier;

  @override
  VisibilityModifier copyWith({bool? visible}) {
    return VisibilityModifier(visible ?? this.visible);
  }

  @override
  List<Object?> get props => [visible];

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is VisibilityModifier &&
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
    properties.add(FlagProperty('visible', value: visible, ifTrue: 'visible'));
  }
}

class VisibilityModifierMix extends ModifierMix<VisibilityModifier>
    with Diagnosticable {
  final Prop<bool>? visible;

  const VisibilityModifierMix.create({this.visible});

  VisibilityModifierMix({bool? visible})
    : this.create(visible: Prop.maybe(visible));

  @override
  VisibilityModifier resolve(BuildContext context) {
    return VisibilityModifier(MixOps.resolve(context, visible));
  }

  @override
  VisibilityModifierMix merge(VisibilityModifierMix? other) {
    if (other == null) return this;

    return VisibilityModifierMix.create(
      visible: MixOps.merge(visible, other.visible),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty('visible', visible));
  }

  @override
  List<Object?> get props => [visible];
}
