import 'package:flutter/material.dart';

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
  /// If [aspect] is provided, the widget will only rebuild when that specific
  /// state changes, enabling granular performance optimization.
  static Set<WidgetState>? of(BuildContext context, {String? aspect}) {
    return InheritedModel.inheritFrom<WidgetStateProvider>(
      context,
      aspect: aspect,
    )?.states;
  }

  /// Retrieves the mouse position from the nearest [WidgetStateProvider] ancestor.
  PointerPosition? mousePositionOf(BuildContext context) {
    final provider = context
        .dependOnInheritedWidgetOfExactType<WidgetStateProvider>();

    return provider?.mousePosition;
  }

  /// Checks if a specific state is active in the current context.
  ///
  /// This method subscribes to changes only for the specified state,
  /// ensuring minimal rebuilds.
  static bool hasStateOf(BuildContext context, WidgetState state) {
    return of(context, aspect: state.name)?.any((s) => s == state) ?? false;
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

/// Simple controller for cursor position tracking
class CursorPositionController extends ValueNotifier<PointerPosition?> {
  CursorPositionController() : super(null);

  /// Updates the cursor position based on local position and widget size
  void updatePosition(Offset localPosition, Size size) {
    // Calculate normalized coordinates (0.0 to 1.0)
    final ax = localPosition.dx / size.width;
    final ay = localPosition.dy / size.height;

    // Convert to alignment coordinates (-1.0 to 1.0)
    final alignment = Alignment(
      ((ax - 0.5) * 2).clamp(-1.0, 1.0),
      ((ay - 0.5) * 2).clamp(-1.0, 1.0),
    );

    // Update the value
    value = PointerPosition(position: alignment, offset: localPosition);
  }

  /// Clears the cursor position
  void clear() {
    value = null;
  }
}

/// Updated WidgetStateBuilder that always accepts both controllers
class WidgetStateBuilder extends StatelessWidget {
  const WidgetStateBuilder({
    super.key,
    required this.controller,
    this.cursorPositionController,
    required this.builder,
  });

  final WidgetStatesController controller;
  final CursorPositionController? cursorPositionController;
  final Widget Function(BuildContext context) builder;

  @override
  Widget build(BuildContext context) {
    // Always listen to state controller, optionally to cursor controller
    final listenables = [
      controller,
      if (cursorPositionController != null) cursorPositionController!,
    ];

    return ListenableBuilder(
      listenable: Listenable.merge(listenables),
      builder: (context, _) {
        return WidgetStateProvider(
          states: controller.value,
          mousePosition: cursorPositionController?.value,
          child: Builder(builder: builder),
        );
      },
    );
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
