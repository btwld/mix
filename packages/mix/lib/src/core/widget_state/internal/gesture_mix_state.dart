import 'dart:async';

import 'package:flutter/material.dart';

import '../widget_state_controller.dart';

class GestureMixStateWidget extends StatefulWidget {
  const GestureMixStateWidget({
    super.key,
    required this.child,
    this.enableFeedback = false,
    this.controller,
    this.onTap,
    this.onLongPress,
    this.onTapUp,
    this.onTapCancel,
    this.onLongPressStart,
    this.onLongPressEnd,
    this.onLongPressCancel,
    this.onPanDown,
    this.onPanUpdate,
    this.onPanEnd,
    this.onPanCancel,
    this.onPanStart,
    this.excludeFromSemantics = false,
    this.hitTestBehavior = HitTestBehavior.opaque,
    required this.unpressDelay,
  });

  /// The child widget.
  final Widget child;

  /// The controller for the widget state.
  final WidgetStatesController? controller;

  /// Whether to provide feedback for gestures.
  final bool enableFeedback;

  /// The callback that is called when the user stops touching the screen after a tap gesture.
  final GestureTapUpCallback? onTapUp;

  /// The callback that is called when the user cancels a tap gesture.
  final GestureTapCancelCallback? onTapCancel;

  /// The callback that is called when the user starts a long press gesture.
  final GestureLongPressStartCallback? onLongPressStart;

  /// The callback that is called when the user ends a long press gesture.
  final GestureLongPressEndCallback? onLongPressEnd;

  /// The callback that is called when the user cancels a long press gesture.
  final GestureLongPressCallback? onLongPressCancel;

  /// The callback that is called when the user starts a pan gesture.
  final GestureDragDownCallback? onPanDown;

  /// The callback that is called when the user moves their finger during a pan gesture.
  final GestureDragUpdateCallback? onPanUpdate;

  final GestureDragCancelCallback? onPanCancel;

  final GestureDragStartCallback? onPanStart;

  /// The callback that is called when the user ends a pan gesture.
  final GestureDragEndCallback? onPanEnd;

  /// The callback that is called when the widget is pressed.
  final VoidCallback? onTap;

  /// The callback that is called when the widget is long-pressed.
  final VoidCallback? onLongPress;

  /// Whether to exclude the widget from semantics.
  final bool excludeFromSemantics;

  /// How to behave during hit testing.
  final HitTestBehavior hitTestBehavior;

  /// The duration to wait after the press is released before updating the press state.
  final Duration unpressDelay;

  @override
  State createState() => _GestureMixStateWidgetState();
}

class _GestureMixStateWidgetState extends State<GestureMixStateWidget> {
  int _pressCount = 0;
  Timer? _timer;
  late final WidgetStatesController _controller;
  bool _longPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? WidgetStatesController();
  }

  void _setLongPressed(bool value) {
    setState(() {
      _longPressed = value;
    });
  }

  void _onPanUpdate(DragUpdateDetails event) {
    widget.onPanUpdate?.call(event);
  }

  void _onPanDown(DragDownDetails details) {
    widget.onPanDown?.call(details);
  }

  _handlePress(bool value) {
    _controller.pressed = value;
    if (value) {
      _pressCount++;
      final initialPressCount = _pressCount;
      _unpressAfterDelay(initialPressCount);
    }
  }

  void _onPanEnd(DragEndDetails details) {
    _handlePress(true);
    widget.onPanEnd?.call(details);
  }

  void _onTapUp(TapUpDetails details) {
    _setLongPressed(false);
    widget.onTapUp?.call(details);
  }

  void _onTapCancel() {
    _setLongPressed(false);
    widget.onTapCancel?.call();
  }

  void _onLongPressStart(LongPressStartDetails details) {
    _setLongPressed(true);
    widget.onLongPressStart?.call(details);
  }

  void _onLongPressEnd(LongPressEndDetails details) {
    _setLongPressed(false);
    widget.onLongPressEnd?.call(details);
  }

  void _onLongPressCancel() {
    _setLongPressed(false);
    widget.onLongPressCancel?.call();
  }

  void _onPanCancel() {
    widget.onPanCancel?.call();
  }

  void _onPanStart(DragStartDetails details) {
    widget.onPanStart?.call(details);
  }

  void _unpressAfterDelay(int initialPressCount) {
    void unpressCallback() {
      if (_controller.has(WidgetState.pressed) &&
          _pressCount == initialPressCount) {
        _controller.pressed = false;
      }
    }

    _timer?.cancel();

    final delay = widget.unpressDelay;

    if (delay != Duration.zero) {
      _timer = Timer(delay, unpressCallback);
    } else {
      unpressCallback();
    }
  }

  void _onTap() {
    _handlePress(true);
    widget.onTap?.call();
    if (widget.enableFeedback) Feedback.forTap(context);
  }

  void _onLongPress() {
    widget.onLongPress?.call();
    if (widget.enableFeedback) Feedback.forLongPress(context);
  }

  @override
  void dispose() {
    _timer?.cancel();
    // Dispose if  being managed internally
    if (widget.controller == null) _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LongPressInheritedState(
      longPressed: _longPressed,
      child: GestureDetector(
        onTapUp: widget.onTap != null ? _onTapUp : null,
        onTap: widget.onTap != null ? _onTap : null,
        onTapCancel: widget.onTap != null ? _onTapCancel : null,
        onLongPressCancel:
            widget.onLongPress != null ? _onLongPressCancel : null,
        onLongPress: widget.onLongPress != null ? _onLongPress : null,
        onLongPressStart: widget.onLongPress != null ? _onLongPressStart : null,
        onLongPressEnd: widget.onLongPress != null ? _onLongPressEnd : null,
        onPanDown: widget.onPanDown != null ? _onPanDown : null,
        onPanStart: widget.onPanStart != null ? _onPanStart : null,
        onPanUpdate: widget.onPanUpdate != null ? _onPanUpdate : null,
        onPanEnd: widget.onPanEnd != null ? _onPanEnd : null,
        onPanCancel: widget.onPanCancel != null ? _onPanCancel : null,
        behavior: widget.hitTestBehavior,
        excludeFromSemantics: widget.excludeFromSemantics,
        child: widget.child,
      ),
    );
  }
}

class LongPressInheritedState extends InheritedWidget {
  const LongPressInheritedState({
    super.key,
    required super.child,
    required this.longPressed,
  });

  static LongPressInheritedState? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType();
  }

  static LongPressInheritedState of(BuildContext context) {
    final LongPressInheritedState? result = maybeOf(context);
    assert(result != null, 'No LongPressVariantController found in context');

    return result!;
  }

  final bool longPressed;

  @override
  bool updateShouldNotify(LongPressInheritedState oldWidget) {
    return oldWidget.longPressed != longPressed;
  }
}
