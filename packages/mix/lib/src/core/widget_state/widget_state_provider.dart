import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class WidgetStateScope extends InheritedModel<WidgetState> {
  const WidgetStateScope({
    super.key,
    required this.states,
    this.pointerPosition,
    required super.child,
  });

  static PointerPosition? positionOf(BuildContext context) {
    final provider = context
        .dependOnInheritedWidgetOfExactType<WidgetStateScope>();

    return provider?.pointerPosition;
  }

  static WidgetStateScope? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType();
  }

  static bool hasState(BuildContext context, WidgetState state) {
    final provider = InheritedModel.inheritFrom<WidgetStateScope>(
      context,
      aspect: state,
    );

    return provider?.states.contains(state) ?? false;
  }

  final Set<WidgetState> states;

  final PointerPosition? pointerPosition;

  @override
  bool updateShouldNotify(WidgetStateScope oldWidget) {
    return !setEquals(states, oldWidget.states) ||
        pointerPosition != oldWidget.pointerPosition;
  }

  @override
  bool updateShouldNotifyDependent(
    WidgetStateScope oldWidget,
    Set<WidgetState> dependencies,
  ) {
    // Only notify if a dependent state actually changed
    for (final state in dependencies) {
      if (oldWidget.states.contains(state) != states.contains(state)) {
        return true;
      }
    }

    // Also check if cursor position changed when hovering
    if (states.contains(WidgetState.hovered) &&
        pointerPosition != oldWidget.pointerPosition) {
      return dependencies.contains(WidgetState.hovered);
    }

    return false;
  }
}

/// Data class for pointer position
class PointerPosition {
  final Alignment position;
  final Offset offset;

  const PointerPosition({required this.position, required this.offset});

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PointerPosition &&
        other.position == position &&
        other.offset == offset;
  }

  @override
  int get hashCode => Object.hash(position, offset);
}

extension WidgetStateControllerExtension on WidgetStatesController {
  set disabled(bool value) => update(WidgetState.disabled, value);

  set hovered(bool value) => update(WidgetState.hovered, value);

  set pressed(bool value) => update(WidgetState.pressed, value);

  set focused(bool value) => update(WidgetState.focused, value);

  set selected(bool value) => update(WidgetState.selected, value);
  set dragged(bool value) => update(WidgetState.dragged, value);
  set scrolledUnder(bool value) => update(WidgetState.scrolledUnder, value);
  set error(bool value) => update(WidgetState.error, value);

  bool get disabled => value.contains(WidgetState.disabled);
  bool get hovered => value.contains(WidgetState.hovered);
  bool get pressed => value.contains(WidgetState.pressed);
  bool get focused => value.contains(WidgetState.focused);
  bool get selected => value.contains(WidgetState.selected);
  bool get dragged => value.contains(WidgetState.dragged);
  bool get scrolledUnder => value.contains(WidgetState.scrolledUnder);
  bool get error => value.contains(WidgetState.error);

  /// Checks if the controller has a specific widget state.
  bool has(WidgetState state) => value.contains(state);
}
