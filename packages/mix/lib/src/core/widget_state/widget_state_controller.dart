import "package:flutter/material.dart";

/// A controller that manages the state of a widget.
///
/// [MixWidgetStateController] tracks various states of a widget, such as
/// [has(WidgetState.disabled)], [has(WidgetState.hovered)], [has(WidgetState.focused)], [has(WidgetState.pressed)], [has(WidgetState.dragged)], [has(WidgetState.selected)].
/// These states are stored in a [Set] called [value].
///
/// The controller extends [ChangeNotifier], allowing listeners to be notified
/// when the state of the widget changes.
// Deprecated typedef moved to src/core/deprecated.dart

extension MixWidgetStatesExt on WidgetStatesController {
  /// The current set of states for the widget.
  ///
  /// This is annotated with `@visibleForTesting` to indicate that it is
  /// accessible for testing purposes.

  /// Sets whether the widget is in the disabled state.
  set disabled(bool value) => update(WidgetState.disabled, value);

  /// Sets whether the widget is being hovered over.
  set hovered(bool value) => update(WidgetState.hovered, value);

  /// Sets whether the widget has focus.
  set focused(bool value) => update(WidgetState.focused, value);

  /// Sets whether the widget is being pressed.
  set pressed(bool value) => update(WidgetState.pressed, value);

  /// Sets whether the widget is being dragged.
  set dragged(bool value) => update(WidgetState.dragged, value);

  /// Sets whether the widget is in the selected state.
  set selected(bool value) => update(WidgetState.selected, value);

  /// Sets whether the widget is in the selected state.
  set error(bool value) => update(WidgetState.error, value);

  /// Checks if the widget is currently in the given state [key].
  bool has(WidgetState key) => value.contains(key);
}

extension on Set<WidgetState> {
  bool get hasDisabled => contains(WidgetState.disabled);
  bool get hasHovered => contains(WidgetState.hovered);
  bool get hasFocused => contains(WidgetState.focused);
  bool get hasPressed => contains(WidgetState.pressed);
  bool get hasDragged => contains(WidgetState.dragged);
  bool get hasSelected => contains(WidgetState.selected);
  bool get hasError => contains(WidgetState.error);
}

class MixWidgetStateModel extends InheritedModel<WidgetState> {
  MixWidgetStateModel.fromSet({
    super.key,
    required Set<WidgetState> states,
    required super.child,
  }) : disabled = states.hasDisabled,
       hovered = states.hasHovered,
       focused = states.hasFocused,
       pressed = states.hasPressed,
       dragged = states.hasDragged,
       selected = states.hasSelected,
       error = states.hasError;

  const MixWidgetStateModel({
    super.key,
    required this.disabled,
    required this.hovered,
    required this.focused,
    required this.pressed,
    required this.dragged,
    required this.selected,
    required this.error,
    required super.child,
  });

  static MixWidgetStateModel? of(BuildContext context, [WidgetState? state]) {
    return InheritedModel.inheritFrom<MixWidgetStateModel>(
      context,
      aspect: state,
    );
  }

  static bool hasStateOf(BuildContext context, WidgetState state) {
    final model = of(context, state);
    if (model == null) {
      return false;
    }

    return switch (state) {
      WidgetState.disabled => model.disabled,
      WidgetState.hovered => model.hovered,
      WidgetState.focused => model.focused,
      WidgetState.pressed => model.pressed,
      WidgetState.dragged => model.dragged,
      WidgetState.selected => model.selected,
      WidgetState.error => model.error,
      WidgetState.scrolledUnder => false,
    };
  }

  final bool disabled;
  final bool hovered;
  final bool focused;
  final bool pressed;
  final bool dragged;
  final bool selected;
  final bool error;

  @override
  bool updateShouldNotify(MixWidgetStateModel oldWidget) {
    return oldWidget.disabled != disabled ||
        oldWidget.hovered != hovered ||
        oldWidget.focused != focused ||
        oldWidget.pressed != pressed ||
        oldWidget.dragged != dragged ||
        oldWidget.selected != selected ||
        oldWidget.error != error;
  }

  @override
  bool updateShouldNotifyDependent(
    MixWidgetStateModel oldWidget,
    Set<WidgetState> dependencies,
  ) {
    return oldWidget.disabled != disabled && dependencies.hasDisabled ||
        oldWidget.hovered != hovered && dependencies.hasHovered ||
        oldWidget.focused != focused && dependencies.hasFocused ||
        oldWidget.pressed != pressed && dependencies.hasPressed ||
        oldWidget.dragged != dragged && dependencies.hasDragged ||
        oldWidget.selected != selected && dependencies.hasSelected ||
        oldWidget.error != error && dependencies.hasError;
  }
}
