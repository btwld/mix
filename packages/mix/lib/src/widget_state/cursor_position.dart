import 'package:flutter/widgets.dart';

/// Data class for pointer position information.
///
/// Contains both the normalized alignment position and the raw pixel offset
/// relative to the widget bounds.
class PointerPosition {
  /// The normalized position as an [Alignment] where:
  /// - (-1, -1) is top-left corner
  /// - (0, 0) is center
  /// - (1, 1) is bottom-right corner
  final Alignment position;

  /// The raw pixel offset relative to the widget's top-left corner.
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
    final notifier = notifierOf(context);

    if (notifier == null) {
      throw FlutterError(
        'PointerPosition.of() called with no active PointerPositionProvider.\n'
        'Ensure that your widget is wrapped in a PointerPositionProvider.',
      );
    }

    return notifier.value;
  }

  /// Gets the cursor position without creating a dependency.
  ///
  /// Returns the current [PointerPosition] if available, or null if no cursor
  /// position is being tracked. Unlike [of], this method does not register
  /// the calling widget as a dependency.
  static PointerPosition? maybeOf(BuildContext context) {
    return notifierOf(context)?.value;
  }

  /// Gets the notifier for direct listening.
  ///
  /// This method is primarily intended for testing and advanced use cases.
  /// Most widgets should use [of] instead.
  ///
  /// Note: This method does not create a dependency on the provider.
  @visibleForTesting
  static PointerPositionNotifier? notifierOf(BuildContext context) {
    final provider = context
        .getInheritedWidgetOfExactType<PointerPositionProvider>();

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
  String toString() => 'PointerPosition(position: $position, offset: $offset)';

  @override
  int get hashCode => Object.hash(position, offset);
}

/// Notifier that tracks cursor position with automatic listener detection.
///
/// This notifier automatically optimizes performance by only updating position
/// when there are active listeners. The optimization works by leveraging
/// [ValueNotifier.hasListeners] to determine if position tracking should be active.
///
/// ## Performance Characteristics
///
/// - **Lazy Evaluation**: Position updates only occur when widgets are listening
/// - **Automatic Optimization**: No manual listener management required
/// - **Memory Efficient**: Clears position data when not in use
///
/// ## Usage
///
/// This notifier is typically used internally by [PointerPositionProvider] and
/// accessed through [PointerPosition.of] rather than directly.
class PointerPositionNotifier extends ValueNotifier<PointerPosition?> {
  PointerPositionNotifier() : super(null);

  /// Whether tracking should be active based on listener presence.
  ///
  /// Returns true if there are widgets listening for position updates.
  /// Use this to conditionally enable expensive mouse tracking operations.
  bool get shouldTrack => hasListeners;

  /// Updates position only if listeners exist.
  ///
  /// This method automatically optimizes performance by only updating
  /// the position when widgets are actually listening for changes.
  ///
  /// If no listeners are present, the update is skipped entirely,
  /// avoiding unnecessary object allocation and notifications.
  void updatePosition(Alignment position, Offset offset) {
    if (hasListeners) {
      value = PointerPosition(position: position, offset: offset);
    }
  }

  /// Clears the current position.
  ///
  /// Typically called when the mouse exits the tracked region or
  /// when the widget is disposed.
  void clearPosition() {
    value = null;
  }

  @override
  void dispose() {
    // Ensure position is cleared before disposal
    clearPosition();
    super.dispose();
  }
}

/// Internal provider for cursor position tracking.
///
/// This provider is an implementation detail and should not be used directly.
/// Instead, use [PointerPosition.of] to access cursor position from widgets.
///
/// The provider uses the [InheritedNotifier] pattern to efficiently propagate
/// cursor position changes only to widgets that depend on them.
class PointerPositionProvider
    extends InheritedNotifier<PointerPositionNotifier> {
  const PointerPositionProvider({
    super.key,
    required PointerPositionNotifier super.notifier,
    required super.child,
  });
}

/// Helper function to create a cursor position provider.
///
/// This is used internally by widgets that need to provide cursor position
/// to their descendants.
Widget provideCursorPosition({
  Key? key,
  required PointerPositionNotifier notifier,
  required Widget child,
}) {
  return PointerPositionProvider(key: key, notifier: notifier, child: child);
}
