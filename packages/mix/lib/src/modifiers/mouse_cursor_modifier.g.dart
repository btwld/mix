// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mouse_cursor_modifier.dart';

// **************************************************************************
// ModifierGenerator
// **************************************************************************

mixin _$MouseCursorModifier
    implements WidgetModifier<MouseCursorModifier>, Diagnosticable {
  MouseCursor? get mouseCursor;

  @override
  Type get type => MouseCursorModifier;

  @override
  MouseCursorModifier copyWith({MouseCursor? mouseCursor}) {
    return MouseCursorModifier(mouseCursor: mouseCursor ?? this.mouseCursor);
  }

  @override
  MouseCursorModifier lerp(MouseCursorModifier? other, double t) {
    return MouseCursorModifier(
      mouseCursor: MixOps.lerpSnap(mouseCursor, other?.mouseCursor, t),
    );
  }

  @override
  List<Object?> get props => [mouseCursor];

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is MouseCursorModifier &&
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
    properties.add(DiagnosticsProperty('mouseCursor', mouseCursor));
  }
}

class MouseCursorModifierMix extends ModifierMix<MouseCursorModifier>
    with Diagnosticable {
  final Prop<MouseCursor>? mouseCursor;

  const MouseCursorModifierMix.create({this.mouseCursor});

  MouseCursorModifierMix({MouseCursor? mouseCursor})
    : this.create(mouseCursor: Prop.maybe(mouseCursor));

  @override
  MouseCursorModifier resolve(BuildContext context) {
    return MouseCursorModifier(
      mouseCursor: MixOps.resolve(context, mouseCursor),
    );
  }

  @override
  MouseCursorModifierMix merge(MouseCursorModifierMix? other) {
    if (other == null) return this;

    return MouseCursorModifierMix.create(
      mouseCursor: MixOps.merge(mouseCursor, other.mouseCursor),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty('mouseCursor', mouseCursor));
  }

  @override
  List<Object?> get props => [mouseCursor];
}
