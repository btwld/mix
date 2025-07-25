import 'package:flutter/material.dart';

import '../widget_state/internal/mouse_region_mix_state.dart';

/// A streamlined provider for widget states using [InheritedModel].
///
/// This provider replaces the verbose [MixWidgetStateModel] with a cleaner
/// Set-based approach while maintaining granular rebuild capabilities.
class WidgetStateProvider extends InheritedModel<String> {
  const WidgetStateProvider({
    super.key,
    required this.states,
    this.mousePosition,
    required super.child,
  });

  /// Retrieves the widget states from the nearest [WidgetStateProvider] ancestor.
  ///
  /// If [aspects] is provided, the widget will only rebuild when those specific
  /// states change, enabling granular performance optimization.
  static Set<WidgetState> of(BuildContext context, [Set<String>? aspects]) {
    if (aspects == null || aspects.isEmpty) {
      final provider = InheritedModel.inheritFrom<WidgetStateProvider>(context);

      return provider?.states ?? {};
    }

    // For granular updates, we need to register each state individually
    WidgetStateProvider? provider;
    for (final state in aspects) {
      provider = InheritedModel.inheritFrom<WidgetStateProvider>(
        context,
        aspect: state,
      );
    }

    return provider?.states ?? {};
  }

  /// Retrieves the mouse position from the nearest [WidgetStateProvider] ancestor.
  static PointerPosition? mousePositionOf(BuildContext context) {
    final provider = context
        .dependOnInheritedWidgetOfExactType<WidgetStateProvider>();

    return provider?.mousePosition;
  }

  /// Checks if a specific state is active in the current context.
  ///
  /// This method subscribes to changes only for the specified state,
  /// ensuring minimal rebuilds.
  static bool hasState(BuildContext context, WidgetState state) {
    return of(context, {state.name}).contains(state);
  }

  /// The current set of active widget states.
  final Set<WidgetState> states;

  /// Optional mouse position for advanced hover effects.
  final PointerPosition? mousePosition;

  @override
  bool updateShouldNotify(WidgetStateProvider oldWidget) {
    return !identical(states, oldWidget.states) ||
        mousePosition != oldWidget.mousePosition;
  }

  @override
  bool updateShouldNotifyDependent(
    WidgetStateProvider oldWidget,
    Set<String> dependencies,
  ) {
    // Only notify dependents if a state they care about changed
    for (final state in dependencies) {
      final hadState = oldWidget.states.map((s) => s.name).contains(state);
      final hasState = states.map((s) => s.name).contains(state);
      if (hadState != hasState) return true;
    }

    return false;
  }
}

class WidgetStateBuilder extends StatelessWidget {
  const WidgetStateBuilder({
    super.key,
    required this.controller,
    required this.builder,
  });

  final WidgetStatesController controller;

  final Widget Function(BuildContext context) builder;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        return WidgetStateProvider(
          states: controller.value,
          child: Builder(builder: builder),
        );
      },
    );
  }
}
