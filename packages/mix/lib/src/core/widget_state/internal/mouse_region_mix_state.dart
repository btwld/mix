/// Provides a [MouseRegionMixWidgetState] that tracks the current pointer position and makes it available to its child widgets.
///
/// The [MouseRegionMixStateWidget] is a stateful widget that listens for pointer hover events and updates the [MouseRegionMixStateController] with the current pointer position. The [MouseRegionMixWidgetState] is then used to provide the pointer position to its child widgets.
///
/// This widget is useful for building UI components that need to respond to the current pointer position, such as tooltips or hover effects.
library;

// MouseRegionBuilder
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class MouseRegionMixStateWidget extends StatefulWidget {
  const MouseRegionMixStateWidget({super.key, required this.child});

  final Widget child;

  @override
  State createState() => _MouseRegionMixStateWidgetState();
}

class _MouseRegionMixStateWidgetState extends State<MouseRegionMixStateWidget> {
  final _controller = MouseRegionMixStateController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    void onHover(PointerHoverEvent event) {
      final size = context.size;

      if (size != null) {
        _controller.updateCursorPosition(event.localPosition, size);
      }
    }

    return MouseRegion(
      onHover: onHover,
      opaque: false,
      child: MouseRegionMixWidgetState(
        notifier: _controller,
        child: widget.child,
      ),
    );
  }
}

class MouseRegionMixStateController extends ChangeNotifier {
  /// The current position of the pointer within the widget.
  ///
  /// The [pointerPosition] property provides the current alignment and offset
  /// of the pointer within the widget's bounds. It is updated whenever the
  /// pointer moves within the widget.
  ///
  /// The [updateCursorPosition] method is used to update the [pointerPosition]
  /// based on the provided cursor offset and widget size.
  PointerPosition? _pointerPosition;

  /// Returns the current position of the pointer within the widget.
  ///
  /// The [PointerPosition] object contains the [Alignment] and [Offset] of the
  /// pointer relative to the widget's bounds.
  PointerPosition? get pointerPosition => _pointerPosition;

  /// Updates the [pointerPosition] based on the provided [cursorOffset] and
  /// [size] of the widget.
  ///
  /// The [cursorOffset] represents the current position of the pointer within
  /// the widget's coordinate space.
  ///
  /// The [size] represents the width and height of the widget.
  ///
  /// This method calculates the relative position of the pointer within the
  /// widget's bounds and updates the [pointerPosition] accordingly.
  void updateCursorPosition(Offset cursorOffset, Size size) {
    // Calculate the relative x-coordinate of the cursor within the widget.
    // The value is normalized to a range of 0.0 to 1.0.
    final ax = cursorOffset.dx / size.width;

    // Calculate the relative y-coordinate of the cursor within the widget.
    // The value is normalized to a range of 0.0 to 1.0.
    final ay = cursorOffset.dy / size.height;

    // Calculate the alignment of the cursor within the widget's bounds.
    // The alignment is represented as an [Alignment] object, where (-1.0, -1.0)
    // represents the top-left corner and (1.0, 1.0) represents the bottom-right
    // corner. The x and y values are adjusted to map the range of 0.0 to 1.0
    // to the range of -1.0 to 1.0 using the formula ((value - 0.5) * 2).
    // The resulting values are clamped to ensure they stay within the valid
    // range of -1.0 to 1.0.
    final cursorAlignment = Alignment(
      ((ax - 0.5) * 2).clamp(-1.0, 1.0),
      ((ay - 0.5) * 2).clamp(-1.0, 1.0),
    );

    // Update the [_pointerPosition] with the calculated [cursorAlignment] and
    // [cursorOffset].
    _pointerPosition = PointerPosition(
      position: cursorAlignment,
      offset: cursorOffset,
    );

    // Notify listeners that the [pointerPosition] has changed.
    notifyListeners();
  }
}

class MouseRegionMixWidgetState
    extends InheritedNotifier<MouseRegionMixStateController> {
  const MouseRegionMixWidgetState({
    super.key,
    required super.notifier,
    required super.child,
  });

  static MouseRegionMixStateController? of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<MouseRegionMixWidgetState>()
        ?.notifier;
  }
}

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
