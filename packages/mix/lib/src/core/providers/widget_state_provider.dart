import 'package:flutter/foundation.dart' show setEquals;
import 'package:flutter/widgets.dart'
    show BuildContext, InheritedModel, WidgetState, WidgetStatesController;

/// Provider for widget state information using Flutter's [InheritedModel].
///
/// This provider makes widget state information available to descendant widgets,
/// allowing them to conditionally style based on states like hover, pressed, focused, etc.
/// Uses [InheritedModel] for efficient updates - only widgets depending on changed states rebuild.
class WidgetStateProvider extends InheritedModel<WidgetState> {
  WidgetStateProvider({
    super.key,
    required Set<WidgetState> states,
    required super.child,
  }) : states = Set.unmodifiable(states);

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
    return of(context, state)?.states.contains(state) ?? false;
  }

  /// The active widget states.
  final Set<WidgetState> states;

  /// Whether the widget is disabled.
  bool get disabled => states.contains(WidgetState.disabled);

  /// Whether the widget is being hovered.
  bool get hovered => states.contains(WidgetState.hovered);

  /// Whether the widget has focus.
  bool get focused => states.contains(WidgetState.focused);

  /// Whether the widget is being pressed.
  bool get pressed => states.contains(WidgetState.pressed);

  /// Whether the widget is being dragged.
  bool get dragged => states.contains(WidgetState.dragged);

  /// Whether the widget is selected.
  bool get selected => states.contains(WidgetState.selected);

  /// Whether the widget has an error.
  bool get error => states.contains(WidgetState.error);

  /// Whether the widget is scrolled under another widget.
  bool get scrolledUnder => states.contains(WidgetState.scrolledUnder);

  @override
  bool updateShouldNotify(WidgetStateProvider oldWidget) {
    return !setEquals(oldWidget.states, states);
  }

  @override
  bool updateShouldNotifyDependent(
    WidgetStateProvider oldWidget,
    Set<WidgetState> dependencies,
  ) {
    return dependencies.any(
      (state) => oldWidget.states.contains(state) != states.contains(state),
    );
  }
}

/// Extension on [WidgetStatesController] providing convenient setters and getters
/// for individual widget states.
///
/// Simplifies working with widget state controllers by providing direct access
/// to common states like disabled, hovered, pressed, etc.
extension WidgetStateControllerExtension on WidgetStatesController {
  set disabled(bool value) => update(.disabled, value);

  set hovered(bool value) => update(.hovered, value);

  set pressed(bool value) => update(.pressed, value);

  set focused(bool value) => update(.focused, value);

  set selected(bool value) => update(.selected, value);
  set dragged(bool value) => update(.dragged, value);
  set scrolledUnder(bool value) => update(.scrolledUnder, value);
  set error(bool value) => update(.error, value);

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
