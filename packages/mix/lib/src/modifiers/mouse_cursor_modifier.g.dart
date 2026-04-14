// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mouse_cursor_modifier.dart';

// **************************************************************************
// ModifierGenerator
// **************************************************************************

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
