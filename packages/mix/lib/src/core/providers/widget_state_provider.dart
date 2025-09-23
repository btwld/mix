import 'package:flutter/widgets.dart'
    show WidgetState, InheritedModel, BuildContext, WidgetStatesController;

/// Extension on [Set<WidgetState>] to provide convenient boolean checks
/// for specific widget states.
extension on Set<WidgetState> {
  bool get hasDisabled => contains(WidgetState.disabled);
  bool get hasHovered => contains(WidgetState.hovered);
  bool get hasFocused => contains(WidgetState.focused);
  bool get hasPressed => contains(WidgetState.pressed);
  bool get hasDragged => contains(WidgetState.dragged);
  bool get hasSelected => contains(WidgetState.selected);
  bool get hasError => contains(WidgetState.error);
}

/// Provider for widget state information using Flutter's [InheritedModel].
///
/// This provider makes widget state information available to descendant widgets,
/// allowing them to conditionally style based on states like hover, pressed, focused, etc.
/// Uses [InheritedModel] for efficient updates - only widgets depending on changed states rebuild.
class WidgetStateProvider extends InheritedModel<WidgetState> {
  /// Whether the widget is disabled.
  final bool disabled;

  /// Whether the widget is being hovered.
  final bool hovered;

  /// Whether the widget has focus.
  final bool focused;

  /// Whether the widget is being pressed.
  final bool pressed;

  /// Whether the widget is being dragged.
  final bool dragged;

  /// Whether the widget is selected.
  final bool selected;

  /// Whether the widget has an error.
  final bool error;

  WidgetStateProvider({
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

  /// Retrieves the [WidgetStateProvider] from the widget tree.
  ///
  /// If [state] is provided, creates a dependency only on that specific state.
  /// This enables granular rebuilds when only specific states change.
  static WidgetStateProvider? of(BuildContext context, [WidgetState? state]) {
    return InheritedModel.inheritFrom<WidgetStateProvider>(
      context,
      aspect: state,
    );
  }

  /// Checks if a specific [WidgetState] is currently active.
  ///
  /// Returns false if no [WidgetStateProvider] is found in the widget tree.
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

  @override
  bool updateShouldNotify(WidgetStateProvider oldWidget) {
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
    WidgetStateProvider oldWidget,
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

/// Extension on [WidgetStatesController] providing convenient setters and getters
/// for individual widget states.
///
/// Simplifies working with widget state controllers by providing direct access
/// to common states like disabled, hovered, pressed, etc.
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
