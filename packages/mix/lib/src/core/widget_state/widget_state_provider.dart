import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'cursor_position_provider.dart';

class WidgetStateScope extends InheritedModel<WidgetState> {
  const WidgetStateScope({
    super.key,
    required this.states,
    required super.child,
  });

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

  @override
  bool updateShouldNotify(WidgetStateScope oldWidget) {
    return !setEquals(states, oldWidget.states);
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

    return false;
  }
}

/// Data class for pointer position
class PointerPosition {
  final Alignment position;
  final Offset offset;

  const PointerPosition({required this.position, required this.offset});

  /// Gets the current cursor position from the nearest provider.
  ///
  /// Returns the current [PointerPosition] if available, or null if no cursor
  /// position is being tracked or the widget is not hovering.
  ///
  /// This method registers the calling widget as a dependency, so it will
  /// rebuild when the cursor position changes.
  static PointerPosition? of(BuildContext context) {
    final provider = context.dependOnInheritedWidgetOfExactType<CursorPositionProvider>();

    return provider?.notifier?.value;
  }

  /// Gets the cursor position without creating a dependency.
  ///
  /// Returns the current [PointerPosition] if available, or null if no cursor
  /// position is being tracked. Unlike [of], this method does not register
  /// the calling widget as a dependency.
  static PointerPosition? maybeOf(BuildContext context) {
    final provider = context.getInheritedWidgetOfExactType<CursorPositionProvider>();

    return provider?.notifier?.value;
  }

  /// Gets the notifier for direct listening.
  ///
  /// This method is primarily intended for testing and advanced use cases.
  /// Most widgets should use [of] instead.
  /// 
  /// Note: This method does not create a dependency on the provider.
  @visibleForTesting
  static CursorPositionNotifier? notifierOf(BuildContext context) {
    final provider = context.getInheritedWidgetOfExactType<CursorPositionProvider>();

    return provider?.notifier;
  }

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
