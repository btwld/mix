import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

/// Overrides widget states used for style resolution below this scope.
///
/// This is intended for tooling and tests that need to render a component in a
/// specific visual state without changing the component's interaction state.
/// When present, the override takes precedence over explicit controllers and
/// ordinary [WidgetStateProvider] scopes for [StyleBuilder] resolution.
class WidgetStateStyleOverride extends InheritedWidget {
  WidgetStateStyleOverride({
    super.key,
    required Set<WidgetState> states,
    required super.child,
  }) : states = Set.unmodifiable(states);

  /// Returns the nearest style-state override, if one exists.
  static WidgetStateStyleOverride? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType();
  }

  /// The widget states to use when resolving descendant Mix styles.
  final Set<WidgetState> states;

  @override
  bool updateShouldNotify(WidgetStateStyleOverride oldWidget) {
    return !setEquals(oldWidget.states, states);
  }
}
