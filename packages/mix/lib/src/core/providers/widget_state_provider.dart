import 'package:flutter/widgets.dart'
    show WidgetState, InheritedModel, BuildContext, WidgetStatesController;

class WidgetStateProvider extends InheritedModel<WidgetState> {
  const WidgetStateProvider({
    super.key,
    required this.states,
    required super.child,
  });

  /// Gets the [WidgetStateProvider] from the given [context] without establishing a dependency.
  static WidgetStateProvider? maybeOf(BuildContext context) {
    return context.getInheritedWidgetOfExactType<WidgetStateProvider>();
  }

  /// Gets the [WidgetStateProvider] from the given [context] and establishes a dependency.
  static WidgetStateProvider? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<WidgetStateProvider>();
  }

  /// Gets the current widget states from the given [context] without establishing a dependency.
  static Set<WidgetState> statesOf(BuildContext context) {
    return maybeOf(context)?.states ?? const {};
  }

  /// Watches for changes to a specific [state] and returns whether it's currently active.
  /// 
  /// This method establishes a dependency on the specific [state], causing the widget
  /// to rebuild only when that particular state changes.
  static bool watchState(BuildContext context, WidgetState state) {
    final provider = InheritedModel.inheritFrom<WidgetStateProvider>(
      context,
      aspect: state,
    );
    return provider?.states.contains(state) ?? false;
  }

  /// Checks if a specific [state] is currently active without establishing a dependency.
  /// 
  /// Use this when you need to check a state without causing rebuilds when it changes.
  static bool hasState(BuildContext context, WidgetState state) {
    return statesOf(context).contains(state);
  }

  final Set<WidgetState> states;

  @override
  bool updateShouldNotify(WidgetStateProvider oldWidget) {
    return true;
  }

  @override
  bool updateShouldNotifyDependent(
    WidgetStateProvider oldWidget,
    Set<WidgetState> dependencies,
  ) {
    // If the states haven't changed at all, no need to notify
    if (oldWidget.states.length == states.length && 
        oldWidget.states.containsAll(states)) {
      return false;
    }
    
    // If there are no dependencies registered, don't notify
    if (dependencies.isEmpty) {
      return false;
    }
    
    // Check if any of the states this widget depends on have changed
    for (final state in dependencies) {
      final wasActive = oldWidget.states.contains(state);
      final isActive = states.contains(state);
      
      // Notify if the state changed (became active or inactive)
      if (wasActive != isActive) {
        return true;
      }
    }
    
    // No relevant state changes for this widget's dependencies
    return false;
  }
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
